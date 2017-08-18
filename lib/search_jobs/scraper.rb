require 'mechanize'
require 'pry'

class SearchJobs::Scraper

  def self.scrape_indeed(search_term = "Manager", zip_code = 14605)
    # Set up an array to store all of the results
    results = []
    # Instantiate a new web scraper with Mechanize
    scraper = Mechanize.new
    # Mechanize setup to rate limit of scraping
    # to once every half-second.
    scraper.history_added = Proc.new { sleep 0.5 }
    # hard-coding the address
    url = "https://www.indeed.com/"

    page = scraper.get(url)
    search_form = page.forms.first

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
    # Parse results
    results_page.css('td#resultsCol').each do |result|
      result.css('div.row.result').each do |job|
        job_title = job.css('a').attr('title').text
        # Save results
        results << {job_title: job_title}
      end
    end
    binding.pry
  end
end
# job = results_page.search('h2.jobtitle a')
# results << {job_title: job_title, location: location, profile_url: profile_url, summary: summary}
