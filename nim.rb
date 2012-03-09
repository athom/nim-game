require "readline"

class Nim
  def initialize(size, max_num)
    size.times do|i|
      @seeds ||= []
      @seeds[i] = 1 + rand(max_num)
    end
  end

  def ui actor
    if actor == :ai
      puts 'AI is thinking ... '
      sleep 1
      puts 'AI take action!'
    else
      puts 'your turn:' if actor == :before
      puts 'you had taken action:' if actor == :after
      @seeds.each_with_index do |seed, i|
        puts "["+(i+1).to_s+"]" + " " + seed.to_s
      end
    end

    def help
      puts """Usage: input 2 1 means reduce 1 at 2nd row.
    help, h, ?: print this message
    exit,quit,q:quit the game
      """
    end

    if @seeds.empty?
      puts 'you lose ... ' if actor == :ai
      puts 'you win!' if actor == :after
      exit 0
    end
  end

  def stupid_ai_action
    index = rand(@seeds.length)
    @seeds[index] -= (rand(@seeds[index])+1)
    @seeds.delete @seeds[index] if @seeds[index] == 0
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
      @seeds.delete_at(@seeds.index seeds.first)
      return
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

    @seeds[@seeds.index(set[:change])] = set[:delta]
    @seeds.delete_if{|e| e == 0}
  end

  def your_action 
    buf = Readline.readline("> ", true      )
    exit 0 if ["quit", "exit", "q"].include? buf
    return help if ["help", "?", "h"].include?buf
    options = buf.split
    index= options[0].to_i-1
    num= options[1].to_i

    if index < 0 or index > @seeds.size - 1
      puts 'no such index'
      return false
    end
    if num>@seeds[index] or num <= 0
      puts 'illigle quality'
      return false
    end

    @seeds[index] -= num
    @seeds.delete @seeds[index] if @seeds[index] == 0

    return true
  end

  def run
    loop do	
      ui :before
      next unless your_action
      ui :after
      smart_ai_action
      ui :ai
    end
  end
end

Nim.new(3, 7).run
