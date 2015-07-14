#!/usr/bin/ruby -w

require "priority_queue"

def load_word_dic(size)
	words_in_dic = Array.new

	begin
		File.open("/home/vlado/projects/ruby/word_paths/words", "r") do |io|
			io.each {|word| words_in_dic.push(word.chomp) if (word.chomp.size == size)}
		end
	rescue
		puts "*Error: #{$!}"
	end
	
	return words_in_dic;
end

def generate_words(word)
	next_words = Array.new

	for i in (0..word.size-1)
		LOWER_LETTERS.each do |letter|
			next if letter == word[i]
			if i == 0
				new_word = letter + word[i+1..word.size-1]
			else
				new_word = word[0..i-1] + letter + word[i+1..word.size-1]
			end
		    next_words.push(new_word)
		end
	end

	return next_words
end

def diff(word, end_word)
	diff_char = 0
	word.zip(end_word).each {|a,b| diff_char+=1 if (a != b)}
	return diff_char
end

LOWER_LETTERS = ("a".."z").to_a;

class Node
	attr_accessor :word, :cost, :parent, :end_word
	
	def initialize(word, end_word, parent=nil, cost=0)
		@word, @end_word, @parent, @cost = word, end_word, parent, cost
	end

	def expand
		next_nodes = Array.new
		generate_words(@word).each {|word| next_nodes.push(Node.new(word, @end_word, self, @cost+1))  if $all_words.include?(word)}
		return next_nodes
	end

	def chain
		chain = Array.new
		node = self
		while node do
			chain.push(node.word)
			node = node.parent
		end
		return chain.reverse
	end
end

def find_shortest_path(start_word, end_word)
	if start_word.size != end_word.size
		puts "Size of the words must be equal"
		exit 0
	end

	explored = Array.new
	q = PriorityQueue.new
	q[Node.new(start_word, end_word)] = diff(start_word.split(''), end_word.split(''))
	
	while not q.empty? do
		#delete the node with lowest path cost and return it
		node = q.delete_min[0]
		explored.push(node)
		node.expand.each do |child|
			next if explored.include?(child)
			if child.word == end_word
				return child.chain
			else
				q[child] = child.cost + diff(child.word.split(''), end_word.split(''))
			end
		end 
	end
end

$all_words = load_word_dic(4)
puts find_shortest_path('head', 'tail')
$all_words = load_word_dic(5)
puts find_shortest_path('white', 'black')