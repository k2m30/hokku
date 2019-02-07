str_pass = 'Очень неожиданный притаился лосёнок в кустах черники'
str_fail = 'Неожиданный притаился лосось в кустах черники'
@vowels ~w(у е ы а о э ё я и ю)

defmodule Hokku do
  hokkus = []

  def get_syllables(count, text) do
    text
    |> String.downcase()
    |> String.codepoints()
    |> Enum.partition(&Enum.member?(@vowels, &1))
    |> Tuple.to_list()
    |> Enum.map(&Enum.join/1)
  end

  # def check_for_hokku(text, current) do
  #   text = file open
  #
  #   current = text.push word
  #
  #   {status, str} = get_syllables(5, text)
  #   if staus == :ok do
  #     current << str
  #   else do
  #
  #   end
  #
  #   {status, str} = get_syllables(7, text)
  #   if staus == :ok do
  #     current << str
  #   else do
  #     break
  #   end
  #
  #   {status, str} = get_syllables(5, text)
  #   if staus == :ok do
  #     current << str
  #   else do
  #     break
  #   end
  #
  #   hokkus << current
  #   return hokkus
  # end
end

Hokku.get_syllables("adsdf sdf sdf ")