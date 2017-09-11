class SearchJobs::Scraper
  # Set up an array to store all of the results
  @@jobs_data = []

  def self.indeed(search_term = nil, zip_code = nil)
    # Instantiate a new web scraper with Mechanize
    scraper = Mechanize.new
    # Mechanize setup to rate limit of scraping
    # to once every half-second.
    scraper.history_added = Proc.new { sleep 0.5 }
    # hard-coding the address
    url = "https://www.indeed.com/"
    page = scraper.get(url)
    # Getting the search form on the page
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
      puts "Searching... Please be patient go make a coffee :)"
      results_page.css('div.row.result').each do |job|

        job_title = job.css('a').attr('title').text.strip
        job_location = job.css('span.location').text.strip
        job_url = "https://www.indeed.com#{job.css('a').attr('href').text}"
        job_company = job.css('span.company').text.strip
        job_summary = job.css('span.summary').text.strip

        # Save results
        @@jobs_data << {name: job_title, location: job_location, url: job_url, company: job_company, summary: job_summary}
      end
    elsif no_results == false && next_page != nil
      while next_page.text.include?("Next") && @@jobs.size <= 100
        puts "Searching... Please be patient go make a coffee :)"
        results_page.css('div.row.result').each do |job|

          job_title = job.css('a').attr('title').text.strip
          job_location = job.css('span.location').text.strip
          job_url =  ("https://www.indeed.com#{job.css('a').attr('href').text}")
          job_company = job.css('span.company').text.strip
          job_summary = job.css('span.summary').text.strip

          # Save results
          @@jobs_data << {name: job_title, location: job_location, url: job_url, company: job_company, summary: job_summary}
        end
        scraper.click(next_page)
        results_page = scraper.click(next_page)
        next_page = results_page.css('div.pagination a').last
      end
    end
  end

  def self.number_jobs
    number = 0
    @@jobs_data.each do |job_hash|
      number += 1
      job_hash[:number] = number
    end
  end

  def self.jobs
    @@jobs_data
  end
end
