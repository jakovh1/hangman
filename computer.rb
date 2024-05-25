# frozen_string_literal: true

require './stages'
require 'json'

# Class representing a Computer.
#
# This class provides methods to:
#  - Print a placeholder for a word
#  - Check a guess from an user
#  - Print the last stage of the gallows when an user used all their guesses
#  - Save a game
#  - Select and Load a saved game
class Computer
  include Stages

  attr_reader :incorrect_guesses, :word_solved, :word

  def initialize
    @word = pick_word(load_words)
    @word_array = @word.split('').map { |char| [char, false] }
    @incorrect_guesses = 0
    @word_solved = false
  end

  def check_guess(guess)
    changes_made = 0
    @word_array.each do |element|
      if element[0] == guess
        element[1] = true
        changes_made += 1
      end
    end
    @word_solved = @word_array.all? { |element| element[1] }
    @incorrect_guesses += 1 if changes_made.zero?
  end

  def print_placeholder
    puts STAGES[@incorrect_guesses]
    @word_array.each do |letter|
      print letter[1] ? "#{letter[0]} " : '_ '
    end
    puts ''
  end

  def print_last_stage
    puts STAGES[6]
    puts @word
  end

  def save_game(used_letters)
    current_datetime = Time.now.strftime('%Y-%m-%d_%H:%M:%S')
    filename = "./saves/#{current_datetime}.json"

    File.open(filename, 'w') do |file|
      file.write(dump_to_json(used_letters))
    end
  end

  def select_saved_game
    saves = print_saved_games

    print 'Please enter a number corresponding to the saved game you want to load: '
    selected_game = 0
    loop do
      selected_game = gets.chomp
      break if selected_game.match(/^[1-#{saves.length}]$/)

      print 'Please enter a valid number corresponding to the saved game you want to load: '
    end

    load_saved_game(selected_game.to_i - 1)
  end

  private

  def print_saved_games
    saves = Dir.children('./saves')
    saves.each_with_index do |filename, index|
      puts "#{index + 1} #{filename[0..-6]}"
    end

    saves
  end

  def load_saved_game(filenumber)
    json_data = File.read("./saves/#{Dir.children('./saves')[filenumber]}")
    deserialized_obj = JSON.parse(json_data)

    if valid_data?(deserialized_obj)
      @word, @word_array, @incorrect_guesses, @word_solved = deserialized_obj.values_at('word', 'word_array', 'incorrect_guesses', 'word_solved')
      deserialized_obj['used_letters']
    else
      puts 'An Error occured while loading the game.'
    end
  end

  def valid_data?(obj)
    obj['word'].is_a?(String) &&
      obj['word_array'].is_a?(Array) &&
      obj['incorrect_guesses'].is_a?(Integer) &&
      [TrueClass, FalseClass].include?(obj['word_solved'].class) &&
      obj['used_letters'].is_a?(Array)
  end

  def load_words
    words = []
    File.open('words.txt', 'r') do |file|
      file.each_line do |line|
        word = line.strip
        words.push(word) if word.length > 4 && word.length < 13
      end
    end
    words
  end

  def pick_word(words)
    words.sample
  end

  def dump_to_json(used_letters)
    JSON.dump({
                'word': @word,
                'word_array': @word_array,
                'incorrect_guesses': @incorrect_guesses,
                'word_solved': @word_solved,
                'used_letters': used_letters
              })
  end
end
