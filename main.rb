$: << File.dirname(__FILE__)
require 'optparse'
require 'nim'

def parse_options
  options = OptionParser.new 
  options.banner = "Usage: rubywarrior [options]"
  options.on('-c', '--cli', "Run in Command Line Mode")  { $mode = :cli }
  options.on('-g', '--gui',   "Run in GUI Mode")     { $mode = :gui }
  options.on('-h', '--help',          "Show this message")          { puts(options); exit }
  options.parse!(ARGV)
end

$mode = :cli
parse_options

if $mode == :cli
  game = Nim::Game.new(3,7)
  runner = Nim::CLI.new(game)
  runner.run
else
  Nim::GUI.run
end
