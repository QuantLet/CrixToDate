install.packages("igraph")
library(igraph) 

#centralized
tr <- make_tree(40, children = 3, mode = "undirected")
plot(tr, vertex.size=10, vertex.label=NA)

#decentralized
tr <- make_tree(40, children = 4, mode = "undirected")
plot(tr, vertex.size=10, vertex.label=NA)

#distributed
zach <- graph("Zachary")
plot(zach, vertex.size=10, vertex.label=NA)
