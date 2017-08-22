require 'mechanize'
require 'pry'

class SearchJobs::Scraper

  def self.indeed(search_term = "developer remote", zip_code = 14605)
    # Set up an array to store all of the results
    results = []
    # Instantiate a new web scraper with Mechanize
    scraper = Mechanize.new
    # Mechanize setup to rate limit of scraping
    # to once every half-second.
    scraper.history_added = Proc.new { sleep 0.50 }
    # hard-coding the address
    url = "https://www.indeed.com/"

    page = scraper.get(url)
    search_form = page.form

    # Use Mechanize to enter search terms into the form fields
    search_form.fields.each do |f|
      if f.name == "q"
        f.value = search_term
      elsif f.name == "l"
        f.value = zip_code
      end
    end
    # Get results
    results_page = search_form.submit
    next_page = results_page.search('div.pagination a').last
    # Parse results
    while next_page.text.include?("Next")
      results_page.css('td#resultsCol').each do |result|
        result.css('div.row.result').each do |job|
          job_title = job.css('a').attr('title').text
          location = job.css('span.location').text
          job_url  =
          # Save results
          results << {job_title: job_title, location: location, job_url: job_url}
        end
      end
      scraper.click(next_page)
      results_page = scraper.click(next_page)
      next_page = results_page.search('div.pagination a').last
    end
    results.size
  end


  def self.monster(search_term = "Manager", zip_code = 14605)
    # Set up an array to store all of the results
    results = []
    # Instantiate a new web scraper with Mechanize
    scraper = Mechanize.new
    # Mechanize setup to rate limit of scraping
    # to once every half-second.
    scraper.history_added = Proc.new { sleep 0.5 }
    # hard-coding the address
    url = "https://www.monster.com/"

    page = scraper.get(url)
    search_form = page.forms.first

    # Use Mechanize to enter search terms into the form fields
    search_form.fields.each do |f|
      if f.name == "q"
        f.value = search_term
      elsif f.name == "where"
        f.value = zip_code
      end
    end
  end
end
