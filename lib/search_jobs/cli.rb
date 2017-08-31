class SearchJobs::CLI

  @@jobs_array = nil

  def run
    puts "Welcome to Job Search!"
    search
    make_jobs(@@jobs_array)
    good_bye
  end

  def search
    input = nil
    while input != 'exit' && input != 'search'
      puts "Please type 'search'to look for a job or type 'exit': "
      input = STDIN.gets.strip.downcase
      if input == 'search'
        puts "Please enter the job you are looking for: "
        search_term = STDIN.gets.strip
        puts "Please enter the zip code: "
        zip_code = STDIN.gets.to_i
        @@jobs_array = SearchJobs::Scraper.indeed(search_term, zip_code)
      elsif input == 'exit'
        good_bye
      else
        puts "That is not a valid entry pleae try again"
      end
    end
  end

  def make_jobs(jobs_array)
    jobs_array = SearchJobs::Scraper.indeed
    SearchJobs::Jobs.create_from_collection(jobs_array)
  end

  def display_jobs
    input = nil
    puts "The search is over, a total of #{SearchJobs::Jobs.all.size} were found in your area. Type 'show' to diplay the search results"
    SearchJobs::Jobs.all.each do |job|
      puts "#{job.company.upcase.strip}".colorize(:yellow)
      puts "#{job.name.upcase}".colorize(:blue)
      puts "  Location:".colorize(:light_blue) + " #{job.location}"
      puts "  Url:".colorize(:light_blue) + " #{job.url}"
      puts "  Summary:".colorize(:light_blue) + "#{job.summary.strip}"
      puts "----------------------".colorize(:red)
    end
    puts "If you want to apply just click on the link or 'copy-paste' into your browser :)"
  end

  def good_bye
    puts "Good bye!"
  end
end
