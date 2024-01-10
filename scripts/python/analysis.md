## NetworkX connectivity analysis

# Goal
The goal of this analysis is to calculate connectivity metrics for bicycle infrastructure in Santa Barbara and compare the results against the People for Bikes shortest path connectivity metric. The primary analytical package we'll be using is NetworkX, which provides a variety of connectivity algorithms for networks defined by nodes and edges (graph theory).

# NetworkX examples

Converting polylines into edges & nodes: https://networkx.org/documentation/stable/auto_examples/geospatial/plot_lines.html#sphx-glr-auto-examples-geospatial-plot-lines-py

Connectivity Algorithms: https://networkx.org/documentation/stable/reference/algorithms/connectivity.html#module-networkx.algorithms.connectivity

# Simplifying Osm
new_network shapefile is derived from achic19's script, main_file.ipynb within git@github.com:achic19/SOD.git
The plan is perform a spatial join on this shapefile with the canbics classified osm shapefile so we can get a simplified network with canbics classifications



