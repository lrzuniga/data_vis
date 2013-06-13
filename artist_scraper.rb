require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'erb'

class Artist
	attr_accessor :rank, :name, :artist_url, :photo_links

	def initialize(rank, name, artist_url, photo_links)
		@rank = rank
		@name = name
		@artist_url = artist_url
		@photo_links = photo_links
	end
end

class Database
	attr_accessor :artist_array, :city, :country

	def initialize(city, country)
		@artist_array = []
		@city = city.downcase
		@country = country.downcase
	end
		
	def convert_erb_html_file
    	template_file = File.open("web/data_vis_erb.html.erb", 'r').read
		erb = ERB.new(template_file)
		File.open("web/data_vis_test.html", 'w+') do |file|
			file.write(erb.result(binding))
		end
	end

end

class Runner
	BASE_HYPED_URL = "http://www.last.fm/charts/artists/hyped/place"
	BASE_ARTIST_URL = "http://www.last.fm"

	def self.run

		# print "Which city? "
		# country = gets.chomp.delete("'").gsub(/\W+/, "+")
		# print "Which city? "
		# city = gets.chomp.delete("'").gsub(/\W+/, "+")
		country = "United States"
		city = "Nashville"
		full_url = BASE_HYPED_URL + "/" + country.delete("'").gsub(/\W+/, "+") + "/" + city.delete("'").gsub(/\W+/, "+")

		hyped_page = Nokogiri::HTML(open(full_url))
		artists = hyped_page.css('div.rankItem-wrap2 a.rankItem-blockLink')[0..4]

		@db = Database.new(city, country)

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

		@db.convert_erb_html_file
	end
end

Runner.run