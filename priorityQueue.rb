#!/usr/bin/ruby -w

require 'priority_queue'

q = PriorityQueue.new
q["node1"] = 0
q["node2"] = 1

puts q.min
q.delete_min
puts q.min
puts q.empty?