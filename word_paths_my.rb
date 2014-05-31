#!/usr/bin/env ruby -wKU

class PriorityQueue
   
    attr_accessor :heap
    
    def initialize
        @heap = Array.new
    end
	
	def push(item)
        @heap.push(item)
	end

    def pop
        item = @heap.pop()
        return item
    end

    def print
    	@heap
    end
    
    def is_empty
        return (@heap.size == 0)
    end

end


class Node

 	attr_accessor :state
 	attr_accessor :parent
 	attr_accessor :path_cost
 	attr_accessor :goal_word

    def initialize(state, parent, path_cost=0, goal_word)
        @state = state
        @parent = parent
        @path_cost = path_cost
        @goal_word = goal_word
    end

    def expand(dictionary)
    	objs = []
    	priority_function(@path_cost.to_i + 1, generate_words(@state), dictionary).each do |str, steps|
			objs.push(Node.new(str, self, steps, @goal_word))
		end
		return objs
	end

    def priority_function(path_cost, words, dictionary)
    	desire_words = {}
    	min_words = []
    
    	words.each do |word|
    		if dictionary.include?(word)
    			desire_words[word] = path_cost + heuristic(word.split(''), @goal_word.split(''))
    		end 
    	end

    	desire_words.each { |k, v| min_words.push([k, v]) if v == desire_words.values.min }

    	return min_words
    end

    def chain
    	node = self
        trail = [] 
        while node do
            trail.push(node.state)
            node = node.parent
        end
        return trail.reverse
    end

end


def search(start_word, end_word, dictionary)
	exit if start_word.size != end_word.size
	frontier = PriorityQueue.new
	frontier.push(Node.new(start_word, nil, 0, end_word))
	explored = Array.new

	while not frontier.is_empty do
		node = frontier.pop()
		next if explored.include?(node.state)
		explored.push(node.state)
		node.expand(dictionary).each do |child|
			if not explored.include?(child)
				if( child.state == end_word)
					return child.chain
				end	
				frontier.push(child)
			end
		end
	end

	return []
end

def heuristic(item, goal)
	same_char = 0
	item.zip(goal).each {|a,b| same_char += 1 if (a != b) }
	return same_char
end

def load_words(lenght)
	results = Array.new
	File.open("/usr/share/dict/words", "r") do |aFile|
			aFile.each {|line| results.push(line.chomp) if ( line.size == lenght+1 )} 
	end
	return results
end

LOWER_LETTERS = ('a'..'z').to_a

def generate_words(word)
	next_words = Array.new
	for i in (0..word.size-1)
		LOWER_LETTERS.each do |char| 
			if char != word[i]
				if i > 0
					next_words.push(word[0..i-1] + char + word[i+1..word.size])
				else
					next_words.push(char + word[1..word.size-1])
				end	
			end
		end
	end
	return next_words
end

search('head', 'tail', load_words('head'.size)).each {|word| puts word}