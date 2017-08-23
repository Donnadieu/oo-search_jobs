require 'mechanize'
require 'pry'
require 'httparty'

class SearchJobs::Scraper
  # Set up an array to store all of the results
  @@results = []
  def self.indeed(search_term = 'nuclear', zip_code = '14605')
    # Instantiate a new web scraper with Mechanize
    scraper = Mechanize.new
    # Mechanize setup to rate limit of scraping
    # to once every second.
    # scraper.history_added = Proc.new { sleep 1.0 }
    # hard-coding the address
    url = "https://www.indeed.com/"
    page = scraper.get(url)
    search_form = page.form
    # Use Mechanize to enter search terms into the form fields
    search_form.fields.each do |f|
      if f.name == "q"
        f.value = search_term
      elsif f.name == "l"
        f.value = zip_code.to_i
      end
    end

    # Get results
    results_page = search_form.submit
    next_page = results_page.css('div.pagination a').last
    no_results = next_page == nil

    # Parse results
    if next_page == nil && no_results == false
      results_page.css('td#resultsCol').each do |result|
        result.css('div.row.result').each do |job|
          job_title = job.css('a').attr('title').text
          job_location = job.css('span.location').text
          job_url = job.css('a').attr('href').text
          # Save results
          @@results << {title: job_title, location: job_location, url: job_url}
        end
      end
    elsif no_results
      puts "No results for this query in your area"
    else
      while next_page.text.include?("Next")
        results_page.css('td#resultsCol').each do |result|
          result.css('div.row.result').each do |job|
            job_title = job.css('a').attr('title').text
            job_location = job.css('span.location').text
            job_url = job.css('a').attr('href').text
            # Save results
            @@results << {title: job_title, location: job_location, url: job_url}
          end
        end
        scraper.click(next_page)
        results_page = scraper.click(next_page)
        next_page = results_page.css('div.pagination a').last
      end
    end
  end
end
# def self.carreer(search_term = "nursing", zip_code = 14605)
#   # Instantiate a new web scraper with Mechanize
#   scraper = Mechanize.new
#   # Mechanize setup to rate limit of scraping
#   # to once every half-second.
#   scraper.history_added = Proc.new { sleep 0.5 }
#
#   # hard-coding the address
#   url = "http://www.careerbuilder.com/"
#   page = scraper.get(url)
#   search_form = page.form
#
#   # Use Mechanize to enter search terms into the form fields
#   search_form.fields.each do |f|
#     if f.name == "keywords"
#       f.value = search_term
#     elsif f.name == "location"
#       f.value = zip_code.to_i
#     end
#   end
#   # Get results and avoid redirect error
#   begin
#     results_page = search_form.submit
#   rescue Mechanize::ResponseCodeError => e
#     redirect_url = HTTParty.get(url).request.last_uri.to_s
#     results_page = scraper.get(redirect_url)
#   end
#
#   next_page = results_page.css('div.pager a').last
#   more_pages = results_page.css('div.pager a#next-button').attr('aria-disabled').value =="false"
#   no_results = next_page == nil
#   # Parse results
#   if  more_pages == false && no_results == false
#     results_page.css('div.jobs').each do |result|
#       result.css('div.job-row').each do |job|
#         job_title = job.css('h2 a').text
#         job_location = job.css('.job-text').text.split(" ")
#         job_location = job_location[-2] + job_location[-1]
#         job_url = job.css('h2 a').attr('href').text
#         # Save results
#         @@results << {title: job_title, location: job_location, url: job_url}
#       end
#     end
#   elsif no_results
#     puts "No results for this query in your area"
#   else
#     while more_pages
#       results_page.css('div.jobs').each do |result|
#         result.css('div.job-row').each do |job|
#           job_title = job.css('h2 a').text
#           job_location = job.css('.job-text').text.split(" ")
#           job_location = job_location[-2] + job_location[-1]
#           job_url = job.css('h2 a').attr('href').text
#           # Save results
#           @@results << {title: job_title, location: job_location, url: job_url}
#         end
#       end
#       if next_page.class == Nokogiri::XML::Element
#         begin
#           results_page = scraper.click(next_page)
#         rescue Mechanize::ResponseCodeError => e
#           redirect_url = HTTParty.get(url).request.last_uri.to_s
#           results_page = scraper.get(redirect_url)
#         end
#       end
#       next_page = results_page.css('div.pager a').last
#     end
#   end
#   @@results
# end
