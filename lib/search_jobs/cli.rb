class SearchJobs::CLI

  def call
    puts "Welcome to Job Search!"
    search
    make_jobs
    good_bye
  end

  def search
    input = nil
    while input != 'exit'
      puts "Please type 'search'to look for a job or type 'exit': "
      input = STDIN.gets.strip.downcase
      if input == 'search'
        puts "Please enter the job you are looking for: "
        search_term = STDIN.gets.strip
        puts "Please enter the zip code: "
        zip_code = STDIN.gets.to_i
        job_hash = SearchJobs::Scraper.indeed(search_term, zip_code)
        job_hash
      end
    end
  end

  def make_jobs
    SearchJobs::Jobs.new(search)
    puts "Almost done..."
  end

  def good_bye
    puts "Good bye!"
  end
end
