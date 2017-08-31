class SearchJobs::CLI

  def run
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
        @@job_hash = SearchJobs::Scraper.indeed(search_term, zip_code)
        make_jobs
      elsif input == 'show'
        make_jobs
      elsif input == 'exit'
        good_bye
      else
        puts "That is not a valid entry pleae try again"
      end
    end
  end

  def make_jobs
    jobs_array = SearchJobs::Scraper.indeed
    SearchJobs::Jobs.create_from_collection(jobs_array)
  end

  def display_jobs
    SearchJobs::Jobs.all.each do |job|
      puts "#{job.name.upcase}".colorize(:blue)
      puts "  Location:".colorize(:light_blue) + " #{job.location}"
      puts "  Url:".colorize(:green) + " #{job.url}"
      puts "----------------------".colorize(:red)
    end
  end

  def good_bye
    @@job_hash.clear
    puts "Good bye!"
  end
end
