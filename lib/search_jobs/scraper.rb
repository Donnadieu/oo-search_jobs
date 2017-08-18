require 'mechanize'
require 'pry'

class SearchJobs::Scraper

  def self.scrape_indeed(search_term = "Manager", zip_code = 14605)
    results = []
    scraper = Mechanize.new
    scraper.history_added = Proc.new { sleep 0.5 }
    url = "https://www.indeed.com/"
    page = scraper.get(url)
    search_form = page.forms.first

    search_form.fields.each do |f|
      if f.name == "q"
        f.value = search_term
      elsif f.name == "l"
        f.value = zip_code
      end
    end
    results_page = search_form.submit
    results_page.css('td#resultsCol').each do |result|
      result.css('div.row.result').each do |job|
        binding.pry
        job_title = job.css('a').attr('title').text
      end
    end
  end
end
# job = results_page.search('h2.jobtitle a')
