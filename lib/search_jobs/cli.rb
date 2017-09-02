class SearchJobs::CLI

  @@jobs_array = nil

  def run
    puts "Welcome to Job Search!"
    search
    good_bye
  end

  def search
    input = nil
    while input != 'exit'
      puts "Please type 'search' to look for a job, 'show' to see the last search, 'clear' to clear last search or type 'exit': "
      input = gets.strip.downcase
      if input == 'search'
        puts "Please enter the job you are looking for: "
        search_term = gets.strip
        puts "Please enter the zip code: "
        begin
          zip_code = gets
          zip_code = Integer(zip_code)
        rescue
          print "Please enter the zip code: "
          retry
        end
        @@jobs_array = SearchJobs::Scraper.indeed(search_term, zip_code)
        make_jobs(@@jobs_array)
      elsif input == 'show'
        display_jobs
      elsif input == 'clear'
        clear_last_search
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
    SearchJobs::Jobs.all.each do |job|
      puts "#{job.company.upcase.strip}".colorize(:yellow)
      puts "#{job.name.upcase}".colorize(:blue)
      puts "  Location:".colorize(:light_blue) + " #{job.location}"
      puts "  Url:".colorize(:light_blue) + " #{job.url}"
      puts "  Summary:".colorize(:light_blue) + "#{job.summary.strip}"
      puts "----------------------".colorize(:red)
      puts "If you want to apply just click on the link or 'copy-paste' it into your browser :)"
    end
  end

  def clear_last_search
    SearchJobs::Jobs.all.clear
  end

  def good_bye
    puts "Good bye!"
  end
end
