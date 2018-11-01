
require 'byebug'

PEGS = {
  "B" => :b,
  "G" => :g,
  "Y" => :y,
  "R" => :r,
  "O" => :o,
  "P" => :p
}

class Code
  attr_reader :pegs

  def initialize(pegs)
    @pegs = pegs
  end

  def self.parse(string)
    pegs = []
    string.upcase.chars.each do |char|
      # raise "Error!" unless PEGS.keys.include?(char)
      pegs << PEGS[char]
    end
    Code.new(pegs)
  end

  def self.random
    code_pegs = PEGS.values
    random_pegs = []
    4.times { random_pegs << code_pegs.sample }
    Code.new(random_pegs)
  end

  def [](pegs)
    @pegs[pegs]
  end

  def exact_matches(code2)
    exact = 0
    code2.pegs.each_with_index do |el, idx|
      exact += 1 if self[idx] == el
    end
    exact
  end

  def near_matches(code2)
    near = 0
    code2.pegs.uniq.each do |el|
      near += 1 if @pegs.uniq.include?(el)
    end
    near - exact_matches(code2)
  end

  def ==(code)
    return false if !code.is_a?(Code)
    self.pegs == code.pegs
  end


end

class Game
  attr_reader :secret_code

  def initialize(secret_code = Code.random)
    @secret_code = secret_code
  end

  def play
    10.times do
      guess = get_guess

      if guess == @secret_code
        puts "Congrats! You win!"
        return
      end
      system('clear')
      display_matches(guess)
    end
    puts "Try again"
  end

  def get_guess
    puts "please enter your input"
    input = gets.chomp
    Code.parse(input)
  end

  def display_matches(code)
    puts "Exact Matches: #{@secret_code.exact_matches(code)}"
    puts "-----------------"
    puts "Near Matches: #{@secret_code.near_matches(code)}"
  end

  def over?(code)
    @secret_code.exact_matches(code) == 4
  end

  def conclude
    puts "Game over!"
  end

end
