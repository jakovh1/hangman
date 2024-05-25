# frozen_string_literal: true

# Class representing a Player.
#
# This class provides methods to:
#  - Take input from an user (letter, 'save' or 'load')
#  - Generate a prompt message based on the existence of saved games
class Player
  attr_accessor :used_letters

  def initialize
    @used_letters = []
  end

  def take_input
    input = ''
    message = generate_message
    print message[0]
    loop do
      input = gets.chomp.downcase
      break if input.match(message[1]) && !@used_letters.include?(input)

      print message[0].gsub('your', 'a valid')
    end
    @used_letters.push(input) if input.length == 1
    input
  end

  private

  def generate_message
    puts "Used letters: #{@used_letters.join(', ')}" unless @used_letters.empty?
    saves = Dir.children('./saves')
    if saves.empty?
      ['Please enter your guess (1 letter), or type ‘save’ to save the game: ', /^(?:[a-z]|save)$/]
    else
      ['Please enter your guess (1 letter), or type ‘save’ to save the game or ‘load’ to load a saved game: ',
       /^(?:[a-z]|save|load)$/]
    end
  end
end
