#!/usr/bin/python3
# -*- coding: utf-8 -*-
# @Time    : 2018/6/9 18:33
# @Author  : LIANG SITING
# @Email   : liangstcathy@foxmail.com
# @File    : CCMAX.py


import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import networkx as nx
from matplotlib.backends.backend_pdf import PdfPages


# FUNCTIONS
def get_data(df):
    """Get needed data from specific time period"""
    upper_date = pd.to_datetime("2017-01-01")
    lower_date = pd.to_datetime("2013-12-31")
    df['date'] = pd.to_datetime(df['date'], unit='D', origin='1899-12-30')
    df.index = df['date']
    df = df.sort_index()
    df = df.drop('date', 1)
    df = df.iloc[df.index < upper_date, :]
    df = df.iloc[df.index > lower_date, :]
    df.columns = pd.Series(df.columns.values).str.upper()
    return df


# Read data and pick out time period used
TRAD_ASSETS = pd.read_excel("20171108Traditional_assets_indices_20130101_20171101.xlsx", sheetname="Sheet3")
TRAD_ASSETS.index = TRAD_ASSETS['Date']
TRAD_ASSETS = TRAD_ASSETS.sort_index()
TRAD_ASSETS = TRAD_ASSETS.drop('Date', 1)

CAP = pd.read_csv("CC_CAP_20140101_20161231.txt", sep=";")
PRICE = pd.read_csv("CC_PRICE_20140101_20161231.txt", sep=";")
VOLUME = pd.read_csv("CC_VOLUME_20140101_20161231.txt", sep=";")
CAP = get_data(CAP)
PRICE = get_data(PRICE)
VOLUME = get_data(VOLUME)


# Seperate data by year and calculate correlation matrix
year = CAP.index.year.unique()
CC_data = []
for i in range(len(year)):
    price = PRICE.loc[PRICE.index.year == year[i], :]
    cap = CAP.loc[CAP.index.year == year[i], :]
    volume = VOLUME.loc[VOLUME.index.year == year[i], :]
    trad_assets = TRAD_ASSETS.loc[TRAD_ASSETS.index.year == year[i], :]
    # Pick out 10 cryptocurrency with the largestest CAP
    cc_price_max = price[cap.mean(skipna=True).sort_values(na_position='last', ascending=False)[:10].index.values]
    trad_cc_price_max = pd.merge(cc_price_max, trad_assets, how='outer', left_index=True, right_index=True)
    price_max_without_na = trad_cc_price_max.fillna(method="ffill")
    price_max_without_na_log = pd.DataFrame(price_max_without_na.apply(np.log))
    ret_max_xts = price_max_without_na_log.diff()
    # correlation matrix
    imp_index = list(range(10))
    imp_index.extend([13, 21])
    cor_mat = ret_max_xts.iloc[:, imp_index].corr()
    cor_mat_graph = cor_mat
    cor_mat_graph[cor_mat_graph< 0.5] = 0
    cor_mat_graph = cor_mat_graph.values
    np.fill_diagonal(cor_mat_graph, 0)
    cor_mat_graph = pd.DataFrame(cor_mat_graph)
    cor_mat_graph.columns = cor_mat.columns.values
    cor_mat_graph.index = cor_mat.columns.values
    #
    subdata = {"PRICE": price,
               "CAP": cap,
               "VOLUME": volume,
               "CC_PRICE_max": cc_price_max,
               "TRAD_CC_PRICE_max": trad_cc_price_max,
               "PRICE_max_without_na": price_max_without_na,
               "RET_max_xts": ret_max_xts,
               "COR_MAT": cor_mat,
               "COR_MAT_graph": cor_mat_graph}
    CC_data.append(subdata)


# Show a network relation between cryptocurrency and S&P100 and gold
color = ("red", "blueviolet", "darkorchid", "goldenrod", "chartreuse",
          "palevioletred", "steelblue", "slateblue", "tan", "wheat")
for k in range(len(year)):
    cor_mat_graph = CC_data[k]["COR_MAT_graph"]
    G = nx.Graph()
    G.add_nodes_from(list(cor_mat_graph.columns.values))
    edges = []
    for i in range(len(cor_mat_graph.columns)):
        for j in range(i+1,len(cor_mat_graph.columns)):
            if cor_mat_graph.iloc[i,j]!=0:
                edges.append((cor_mat_graph.index.values[i],
                              cor_mat_graph.index.values[j],
                              cor_mat_graph.iloc[i,j]))
    G.add_weighted_edges_from(edges)
    nx.draw(G,
            pos=nx.spring_layout(G),
            node_color=color,
            node_size=1500,
            node_shape="o",
            width=1,
            edge_color="k",
            linewidths=2,
            with_labels=True,
            font_color="blue",
            alpha=0.8)
    plt.savefig(''.join(["CORR", str(year[k]), ".png"]))
    plt.close()


# For the whole period
PRICE_MAX = PRICE[CAP.mean(skipna=True).sort_values(na_position='last', ascending=False)[:10].index.values]
TRAD_CC_PRICE = pd.merge(PRICE, TRAD_ASSETS, how='outer', left_index=True, right_index=True)
TRAD_CC_PRICE_max = pd.merge(PRICE_MAX, TRAD_ASSETS, how='outer', left_index=True, right_index=True)
PRICE_without_na = TRAD_CC_PRICE.fillna(method="ffill")
PRICE_max_without_na = TRAD_CC_PRICE_max.fillna(method="ffill")
PRICE_without_na_log = pd.DataFrame(PRICE_without_na.apply(np.log))
PRICE_max_without_na_log = pd.DataFrame(PRICE_max_without_na.apply(np.log))
RET_xts = PRICE_without_na_log.diff()
RET_max_xts = PRICE_max_without_na_log.diff()
imp_index = list(range(10))
imp_index.extend([13, 21])

# Build and save as pdf Bar plot for standard deviation/volatility
StD_max = RET_max_xts.iloc[:, imp_index].std()
fig = StD_max.plot.bar()
fig = fig.get_figure()
pdf = PdfPages('Volatility_max.pdf')
pdf.savefig(fig)
pdf.close()