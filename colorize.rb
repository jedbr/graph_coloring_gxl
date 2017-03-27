require 'nokogiri'

class Node
  attr_accessor :label, :degree, :neighbours, :frequency

  def initialize(label)
    @label = label
    @degree = 0
    @neighbours = []
    @frequency = nil
  end

  def <<(node)
    @neighbours << node
    @degree += 1
  end
end

nodes = {}
edges = {}
frequencies = {}
current_frequency = 0

xml = Nokogiri::XML(File.open(ARGV.first))

xml.root.xpath('//node').each do |n| 
  label = n.attributes['id'].value
  nodes[label] = Node.new(label)
end

xml.root.xpath('//edge').each do |e|
  label = e.attributes['id'].value
  from = e.attributes['from'].value
  to = e.attributes['to'].value
  edges[label] = { from: from, to: to }
end

edges.each_value do |edge|
  from = nodes[edge[:from]]
  to = nodes[edge[:to]]
  from << to
  to << from
end

nodes = nodes.sort_by { |label, node| node.degree }.reverse.map(&:last)

nodes.each do |node|
  frequencies.each do |frequency, nodes_using_frequency|
    if (nodes_using_frequency & node.neighbours).empty?
      node.frequency = frequency
      frequencies[frequency] << node
      break
    end
  end

  if node.frequency.nil?
    node.frequency = current_frequency += 1
    frequencies[current_frequency] = [node]
  end
end

p nodes.map(&:label)
p nodes.map(&:degree)
p nodes.map(&:frequency)
