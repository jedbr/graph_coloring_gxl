require 'nokogiri'

class Node
  include Math
  attr_reader :x, :y
  
  def initialize(x, y)
    @x = x
    @y = y
  end
  
  def distance_to(node)
    sqrt((x - node.x)**2 + (y  - node.y)**2)
  end
end

Edge = Struct.new(:node1, :node2)

class Graph
  attr_reader :nodes, :edges

  def initialize(area_r, n, r)
    @node_label = '@'
    @edge_label = '`'
    @nodes = {}
    @edges = {}
    @area_r = area_r.to_f
    @n = n
    @r = r
    generate
    save_xml
  end
  
  def generate
    generate_nodes
    create_edges
  end
  
  def generate_nodes
    @n.times do
      begin
        x = rand(-@area_r..@area_r)
        y = rand(-@area_r..@area_r)
      end until x**2 + y**2 <= @area_r**2
      @nodes[@node_label.next!] = Node.new(x, y)
    end
  end
  
  def create_edges
    @nodes.take(@n - 1).each_with_index do |node, i|
      @nodes.drop(i + 1).each do |other_node|
        if node.last.distance_to(other_node.last) < 2 * @r
          @edges[@edge_label.next!] = Edge.new(node.first, other_node.first)
        end
      end
    end
  end

  def save_xml
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.gxl('xmlns:xlink': 'http://www.w3.org/1999/xlink') do
        xml.graph(id:         'undirected-instance', 
                  edgeids:    'true', 
                  edgemode:   'defaultdirected', 
                  hypergraph: 'false') do

          @nodes.each_key { |k| xml.node(id: k) }
          @edges.each do |label, edge| 
            xml.edge(id:         label, 
                     to:         edge.node2, 
                     from:       edge.node1, 
                     isdirected: 'false')
          end
        end
      end
    end

    filename = Time.now.strftime 'graph_%H%M%S_%d%m%Y.xml'
    File.open(filename, 'w') { |f| f.write builder.to_xml }
    builder.to_xml
  end
end

Graph.new(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i) unless ARGV.empty?
