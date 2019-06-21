require 'csv'
require 'kmeans-clusterer'
require 'ruby-graphviz'

data = []
labels = []
g = GraphViz.new( :G, :type => :digraph )
# Load data from CSV file into two arrays - one for latitude and longtitude data and one for labels
CSV.foreach("./data/kmean_data2.csv", :headers => false) do |row|
  labels.push( row[0] )
  data.push( [row[1].to_f, row[2].to_f] )
end

k = 3 # Number of clusters to find
kmeans = KMeansClusterer.run k, data, labels: labels, runs: 100

# kmeans.clusters.each do |cluster|
#   puts "Cluster #{cluster.id}"
#   puts "Center of Cluster: #{cluster.centroid}"
#   puts "Cities in Cluster: " + cluster.points.map{ |c| c.label }.join(",")
# end

k = 7 # Optimal K found using the elbow method
kmeans = KMeansClusterer.run k, data, labels: labels, runs: 100
kmeans.clusters.each do |cluster|
 puts "Cluster #{cluster.id}"
 puts "Center of Cluster: #{cluster.centroid}"
 cluster.points.map{ |c| g.add_nodes("#{c.label}") }
 # g.add_nodes("#{cluster.points}")
end

g.output( :png => "cluster.png" )