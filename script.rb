# frozen_string_literal: true

require_relative './stages'
require_relative './player'
require_relative './computer'

player = Player.new
computer = Computer.new

while computer.incorrect_guesses < 6 && !computer.word_solved
  computer.print_placeholder
  input = player.take_input

  if input.length == 1
    computer.check_guess(input)

  elsif input == 'save'
    computer.save_game(player.used_letters)
    puts 'The game has been saved!'
    break

  elsif input == 'load'
    loaded_used_letters = computer.select_saved_game
    if loaded_used_letters.is_a?(Array)
      player.used_letters = loaded_used_letters
      puts 'The game has been loaded!'
      next
    else
      puts 'An Error occurred while loading a game.'
      break
    end
  end
end

computer.print_last_stage if computer.incorrect_guesses == 6
computer.print_placeholder if computer.word_solved
