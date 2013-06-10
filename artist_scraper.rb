require 'rubygems'
require 'nokogiri'
require 'open-uri'

class Database
	attr_accessor :artist_array

	def initialize
		@artist_array = []
	end
		
	def add_to_file
		file = File.open("artists.html", "w")

		@artist_array.each do |artist|
			file.puts ('<div class="rank_' + artist.rank + '" ' + 'href="' + artist.full_url + '">' + artist.name + '</div>')
		end

		file.close
	end

end

class Artist
	attr_accessor :rank, :name, :full_url

	def initialize(rank, name, full_url)
		@rank = rank
		@name = name
		@full_url = full_url
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
		country = "United States".delete("'").gsub(/\W+/, "+")
		city = "Portland".delete("'").gsub(/\W+/, "+")
		full_url = BASE_HYPED_URL + "/" + country + "/" + city

		page = Nokogiri::HTML(open(full_url))
		artists = page.css('div.rankItem-wrap2 a.rankItem-blockLink')[0..4]

		artists.each do |artist|
			rank = artist.css("h4 span.rankItem-position").text.delete(".")
			name = artist.css("h4 span.rankItem-title").text
			full_url = BASE_ARTIST_URL + artist['href']
			@db.artist_array << Artist.new(rank, name, full_url)
		end

		@db.add_to_file
	end
end

Runner.run