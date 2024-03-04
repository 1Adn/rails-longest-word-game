class GamesController < ApplicationController
  def new
    @letters = []
    grid_size = 10
    grid_size.times { @letters.push(('A'..'Z').to_a.sample) }
  end
  def score
    @attempt = params[:word]
    @grid_letters = params[:grid_letters]
    @message = ''
    if check_letters(@attempt, @grid_letters)
      if check_word_exist(@attempt)
        @score = get_score(@attempt)
        @message = 'Answer correct !'
      else
        @message = "Word don't exist !"
        @score = 0
      end
    else
      @message = 'Letters are not valid !'
      @score = 0
    end
  end
  def check_word_exist(attempt)
    api_url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    api = URI.open(api_url).read
    api_check = JSON.parse(api)
    api_check.any?
  end

  private

  def check_letters(attempt, grid)
    valid = true
    used_letters = []
    attempt.each_char do |letter|
      if grid.include?(letter) && !used_letters.include?(letter)
        used_letters.push(letter)
      else
        valid = false
      end
    end
      return valid
  end


  def get_score(attempt)
    28 * attempt.size
  end
end
