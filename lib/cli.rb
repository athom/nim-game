require "readline"

module Nim
  class CLI 
	def initialize(nim)
	  @model = nim 
	end

    def action actor, seeds
      if actor == :ai
        puts 'AI is thinking ... '
        sleep 1
        puts 'AI take action!'
      else
        puts 'your turn:' if actor == :before
        puts 'you had taken action:' if actor == :after
        seeds.each_with_index do |seed, i|
          puts "["+(i+1).to_s+"]" + " " + seed.to_s
        end
      end
  
      if seeds.empty?
        puts 'you lose ... ' if actor == :ai
        puts 'you win!' if actor == :after
        exit 0
      end
    end
  
    def help
        puts """Usage: input 2 1 means reduce 1 at 2nd row.
      help, h, ?: print this message
      exit,quit,q:quit the game
        """
    end
  
    def user_action seeds
      buf = Readline.readline("> ", true      )
      exit 0 if ["quit", "exit", "q"].include? buf
      return help if ["help", "?", "h"].include?buf
      options = buf.split
      index= options[0].to_i-1
      num= options[1].to_i
  
      if index < 0 or index > seeds.size - 1
        puts 'no such index'
        return -1, -1
      end
      if num>seeds[index] or num <= 0
        puts 'illigle quality'
        return -1, -1
      end
      return index, num
    end
  
    def run 
	  seeds = @model.seeds
      loop do	
        action :before, seeds
        next unless @model.your_turn(user_action seeds)
        action :after, seeds
        @model.ai_turn
        action :ai, seeds
      end
    end
  end
end

