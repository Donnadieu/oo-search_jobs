require 'mechanize'
require 'pry'

class SearchJobs::Scraper
  # Set up an array to store all of the results
  @@results = []
  def self.indeed(search_term = 'nuclear', zip_code = '14605')
    # Instantiate a new web scraper with Mechanize
    scraper = Mechanize.new
    # Mechanize setup to rate limit of scraping
    # to once every second.
    scraper.history_added = Proc.new { sleep 1.0 }
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
    next_page = results_page.search('div.pagination a').last
    no_results =

    binding.pry

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
        next_page = results_page.search('div.pagination a').last
      end
    end
    @@results
  end
end
