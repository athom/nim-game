module Nim
  class Game
    attr_accessor :seeds
    def initialize(size, max_num)
      size.times do|i|
        @seeds ||= []
        @seeds[i] = 1 + rand(max_num)
      end
#      @seeds=[2,3,4]
    end
  

	def ai_turn
	  smart_ai_action
	end
  
    def your_turn(args) 
	  index = args[0]
	  num = args[1]
      return false if index == -1
      @seeds[index] -= num
      @seeds.delete @seeds[index] if @seeds[index] == 0
      return true
    end
  
    def run
      @ui.run self
    end

	private

    def stupid_ai_action
      index = rand(@seeds.length)
      rand_size = (rand(@seeds[index])+1)
      @seeds[index] -= rand_size
      @seeds.delete @seeds[index] if @seeds[index] == 0
      [index, rand_size]
    end
  
    def smart_ai_action
      return stupid_ai_action if !@seeds.empty? and @seeds.inject(0){|sum, x| sum ^ x } == 0	
  
      h ||= {}
      seeds = @seeds.clone
      @seeds.each do |e|
        h[e] ||= 0
        h[e] += 1
        h.delete e if h[e]%2 == 0
      end
      seeds = h.select{|e,v| v<2}.keys
  
      if seeds.size == 1
	s_index = @seeds.index seeds.first
        @seeds.delete_at(s_index)
        return [s_index, seeds.first]
      end
  
      possible_groups = seeds.combination(seeds.size-1).to_a
      set = {}
      possible_groups.each do |pg|
        other = (seeds-pg)[0]
        delta = pg.inject(0){|sum,x| sum^x}
        if other > delta
          set[:change] = other
          set[:delta] = delta
        end
      end
  
      s_index = @seeds.index(set[:change])
      s_size = @seeds[s_index] - set[:delta]
      @seeds[s_index] = set[:delta]
      @seeds.delete_if{|e| e == 0}
      return [s_index, s_size]
    end
  end
end
