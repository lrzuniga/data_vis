require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'erb'

class Database
	attr_accessor :artist_array

	def initialize
		@artist_array = []
	end
		
	def add_to_file
		file = File.open("artists.html", "w")

		@artist_array.each do |artist|
			file.puts () #need way to input data into html
		end

		file.close
	end

end

class Artist
	attr_accessor :rank, :name, :artist_url

	def initialize(rank, name, artist_url, photo_links)
		@rank = rank
		@name = name
		@artist_url = artist_url
		@photo_links = photo_links
	end
end

class Runner
	BASE_HYPED_URL = "http://www.last.fm/charts/artists/hyped/place"
	BASE_ARTIST_URL = "http://www.last.fm"

	def self.run
		@db = Database.new

		# print "Which city? "
		# country = gets.chomp.delete("'").gsub(/\W+/, "+")
		# print "Which city? "
		# city = gets.chomp.delete("'").gsub(/\W+/, "+")
		country = "Canada".delete("'").gsub(/\W+/, "+")
		city = "Toronto".delete("'").gsub(/\W+/, "+")
		full_url = BASE_HYPED_URL + "/" + country + "/" + city

		hyped_page = Nokogiri::HTML(open(full_url))
		artists = hyped_page.css('div.rankItem-wrap2 a.rankItem-blockLink')[0..4]

		artists.each do |artist|
			rank = artist.css("h4 span.rankItem-position").text.delete(".")
			name = artist.css("h4 span.rankItem-title").text
			artist_url = BASE_ARTIST_URL + artist['href']

			images_page = Nokogiri::HTML(open(artist_url + "/+images"))
			photos = images_page.css("ul#pictures.pictures.clearit li a img")[0..15]

			photo_links = []
			photos.each do |photo|
				photo_links << photo['src']
			end

			@db.artist_array << Artist.new(rank, name, artist_url, photo_links)
		end

		puts @db.artist_array.inspect

		# @db.add_to_file
	end
end

Runner.run