require 'pp'
require 'open-uri'
require 'net/http'
require 'sinatra'

class Word
  attr_accessor :body, :syllables

  VOWELS = %w(у е ы а о э ё я и ю)

  def new(body)
    @body = body.gsub(/\W+/, '')
    @syllables = count_syllables
  end

  def count_syllables
    @syllables = 0
    VOWELS.each do |vowel|
      @syllables += @body.count(vowel)
    end
  end
end


def syllables(str)
  vowels = %w(у е ы а о э ё я и ю У Е Ы А О Э Я И Ю Ё)
  result = []
  str.gsub!("\n", ' ')
  str.split(' ').each do |word|
    syl = 0
    vowels.each do |vowel|
      syl = syl + word.count(vowel)
    end
    result << [word, syl]
  end
  result
end

def find(str, start_word_index, number)
  count = 0
  phrase = []

  work_array = str

  work_array[start_word_index..-1].each_with_index do |word, i|
    count = count + word.last
    phrase << word
    if count > number
      return find(str, start_word_index + 1, number)
    end
    if count == number
      return phrase, i + start_word_index
    end
  end
  nil
end

def run(str, syllables_array)
  return [] if str.nil?
  hash = syllables str
  hokku_candidates = []
  0.upto hash.size do |i|
    hokku_candidates << find(hash, i, syllables_array.sum)
  end
  hokku_candidates.uniq!.compact!

  all_hokkus = []

  hokku_candidates[0..-1].each do |candidate|
    begin
      hokku = []

      first_word = candidate.first.first.first
      next unless first_word.start_with?('Й', 'Ц', 'У', 'К', 'Е', 'Н', 'Г', 'Ш',
                                         'Щ', 'З', 'Х', 'Ф', 'Ы', 'В', 'А', 'П',
                                         'Р', 'О', 'Л', 'Д', 'Ж', 'Я', 'Ч', 'С',
                                         'М', 'И', 'Т', 'Ь', 'Б', 'Ю')

      last_word = candidate.first.last.first
      next unless last_word.end_with?('.', '!', '?')

      index = 0
      size = 0
      syllables_array.each do |word_size|
        result = find(candidate.first, index, word_size)

        break if result.nil?
        index = result.last + 1
        size += result.first.size
        break if result.last + 1 != size
        hokku << result
      end

      next if hokku.map {|a| a.first.map(&:last).inject(:+)}.inject(:+) != syllables_array.inject(&:+)

      hokku = hokku.map {|a| a.first.map(&:first).join(' ')}.join("\n")
      all_hokkus << hokku

    rescue => e
      p candidate
      p e.message
      pp e.backtrace[0..4]
    end
  end
  all_hokkus
end

set :port, 3000

get '/' do
  @str = params[:str]
  @hokkus = []
  @tankas = []
  erb :index
end
post '/' do
  @str = params[:str]
  @hokkus = run(@str, [5, 7, 5])
  @tankas = run(@str, [5, 7, 5, 7, 7])
  erb :index
end