require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
  	page = Nokogiri::HTML(open(index_url))
  	students = []

  	page.css('div.student-card').each do |student_card|
		name = student_card.css('h4.student-name').text
		location = student_card.css('p.student-location').text
		profile_url = student_card.css('a').first["href"]
		student_hash = {
			:name => name,
			:location => location,
			:profile_url => profile_url
		}
  	students << student_hash
  	end
  	students
  end

  def self.scrape_profile_page(profile_url)
	page = Nokogiri::HTML(open(profile_url))
	
	student = {}

	page.css('.social-icon-container a @href').each do |link|
		case link.value
		when /twitter/
			student[:twitter] = link.value
		when /linkedin/
			student[:linkedin] = link.value
		when /facebook/
			student[:facebook] = link.value
		when /github/
			student[:github] = link.value	
		when /.com/
			student[:blog] = link.value
		end
	end
	student[:profile_quote] = page.css(".profile-quote").text
	student[:bio] = page.css("div.description-holder p").text
	student
  end
end

