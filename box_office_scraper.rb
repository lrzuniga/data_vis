require 'rubygems'
require 'nokogiri'
require 'open-uri'

BASE_URL = "http://www.last.fm/charts/artists/hyped/place/"
country = "Canada"
city = "Toronto"
FULL_URL = BASE_URL + country + "/" + city

File.open('artists.txt', 'w+') do |f|
	page = Nokogiri::HTML(open(FULL_URL))
	artists = page.css('ol li div.rankItem-wrap div.rankItem-wrap2 a.rankItem-blockLink')[0..4]
	artists.each do |artist|
		f.puts artist.inspect
	end
end

