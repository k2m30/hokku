require 'pp'
require 'open-uri'
require 'net/http'

def syllables(str)
  vowels = %w(у е ы а о э ё я и ю У Е Ы А О ЭЯ И Ю Ё)
  result = []
  str.gsub!(/["-]/, '').gsub!("\n", ' ')
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
      return find(str, start_word_index+1, number)
    end
    if count == number
      return phrase, i + start_word_index
    end
  end
  nil
end

str = 'Для меня деньги - бумага, для тебя - свобода.
На американскую мечту сегодня мода.
К этой мечте стремишься ты, -
Работать роботом ради бумажной мечты.

Солнечным утром
Неожиданный
Затаился лосоось
В кустах черники

Ты - менеджер среднего звена.
Ты не работаешь "Под", ты работаешь "На".
Твой этот век - твоя компьютерная эра.
Главное не человек, а его карьера.'

address = 'http://lib.ru/POEZIQ/TWARDOWSKIJ/terkin.txt_Ascii.txt'
# address = 'http://lib.ru/SHAKESPEARE/sonets.txt_Ascii.txt'

# address = 'http://lib.ru/JAPAN/BASE/base.txt_Ascii.txt'
# address = 'http://lib.ru/POEZIQ/ahmadulina.txt_Ascii.txt'
str = Net::HTTP.get(URI(address)).encode!('utf-8', 'koi8-r')



hash = syllables str
hokku_candidates = []
0.upto hash.size do |i|
  hokku_candidates << find(hash, i, 17)
end
hokku_candidates.uniq!.compact!


hokku_candidates[0..-1].each do |candidate|
  begin
    hokku = []
    result = nil
    result2 = nil
    result3 = nil

    first_word = candidate.first.first.first
    next unless first_word.start_with?('Й', 'Ц', 'У', 'К', 'Е', 'Н', 'Г', 'Ш', 'Щ', 'З', 'Х', 'Ф', 'Ы', 'В', 'А', 'П', 'Р', 'О', 'Л', 'Д', 'Ж', 'Я', 'Ч', 'С', 'М', 'И', 'Т', 'Ь', 'Б', 'Ю')

    last_word = candidate.first.last.first
    next unless last_word.end_with?('.')

    result = find(candidate.first, 0, 5)
    next if result.nil? || result.last+1!=result.first.size
    hokku << result.first.map(&:first).join(' ')

    result2 = find(candidate.first, result.last+1, 7)
    next if result2.nil? || result2.last+1!=result.first.size + result2.first.size

    hokku << result2.first.map(&:first).join(' ')
    result3 = find(candidate.first, result2.last+1, 5)

    hokku << result3.first.map(&:first).join(' ')
    hokku = hokku.join("\n")

    puts hokku
    puts

  rescue => e
    p candidate
    p [result, result2, result3]
    p e.message
    pp e.backtrace[0..4]
  end

end