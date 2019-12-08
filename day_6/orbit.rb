class Node
  attr_reader :value, :children
  attr_accessor :parent

  def initialize(value)
    @value = value
    @children = []
  end

  def add_child(node)
    @children << node
    node.parent = self
  end

  def orbits
    if parent.nil?
      0
    else
      1 + parent.orbits
    end
  end
end

def create_orbit_map
  input = File.readlines("./input.txt").map(&:strip)
  nodes = []
  input.each do |orbit_str|
    val_one, val_two = orbit_str.split(")")
    node_one = nodes.find { |node| node.value == val_one }
    if node_one.nil?
      node_one = Node.new(val_one)
      nodes << node_one
    end
    node_two = nodes.find { |node| node.value == val_two }
    if node_two.nil?
      node_two = Node.new(val_two)
      nodes << node_two
    end
    node_one.add_child(node_two)
  end
  nodes
end

def total_orbits
  nodes = create_orbit_map
  nodes.inject(0) { |acc, el| acc + el.orbits }
end

def common_ancestor(nodes, node_one, node_two)
  curr_node = node_one
  children_checked = Hash.new(false)
  result = children_includes_node(curr_node, node_two.value, children_checked)
  until result[:result]
    curr_node = curr_node.parent
    children_checked = result[:children_checked]
    result = children_includes_node(curr_node, node_two.value, children_checked)
  end
  curr_node
end

def orbital_moves
  nodes = create_orbit_map
  me = nodes.find { |node| node.value == "YOU" }
  santa = nodes.find { |node| node.value == "SAN" }
  ancestor = common_ancestor(nodes, me, santa)
  steps_from_me = steps_to_parent_node(me, ancestor)
  steps_from_santa = steps_to_parent_node(santa, ancestor)
  steps_from_me + steps_from_santa - 2 # subtract 2 so not counting san and you nodes
end

def steps_to_parent_node(node, parent)
  steps = 0
  curr_node = node
  until curr_node.value == parent.value
    steps += 1
    curr_node = curr_node.parent
    raise "hell" if curr_node.nil?
  end
  steps
end

def children_includes_node(node, node_value_to_find, children_checked)
  all_children = []
  node.children.each { |child| all_children << child unless children_checked[child.value] }
  all_children.each do |child|
    children_checked[child.value] = true
    if child.value == node_value_to_find
      return { children_checked: children_checked, result: true }
    else
      child.children.each { |b_child| all_children << b_child }
    end
  end
  { children_checked: children_checked, result: false }
end

if __FILE__ == $PROGRAM_NAME
  puts "Total number of orbits are #{total_orbits}"
  puts "Total number of orbital moves are #{orbital_moves}"
end
