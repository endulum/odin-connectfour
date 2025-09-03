require "colorize"

# display a prompt prefix with optional phrase and collect response from stdin
module Prompt
  def get_input(prefix = "> ")
    print prefix.bold
    gets.chomp
  end
end
