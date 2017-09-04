class SearchJobs::CLI

  def run
    search
  end

  def search
    input = nil
    while input != 'exit'
      puts "Please type 'search' to look for a job, 'show' to see the last search, 'clear' to clear last search or type 'exit': "
      input = gets.strip.downcase
      case input
      when 'search'
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
        make_jobs(SearchJobs::Scraper.indeed(search_term, zip_code))
      when'show'
        if SearchJobs::Jobs.all.empty?
          puts "No jobs to show"
        else
          display_jobs
        end
      when 'clear'
        clear_last_search
      when 'exit'
        good_bye
      else
        puts "That is not a valid entry pleae try again"
      end
    end
  end

  def make_jobs(jobs_array)
    SearchJobs::Jobs.create_from_collection(jobs_array)
  end

  def display_jobs
    SearchJobs::Jobs.all.each do |job|
      puts "==========#{job.company.upcase.strip}=========".colorize(:yellow)
      puts "#{job.name.upcase}".colorize(:blue)
      puts "  Location:".colorize(:light_blue) + " #{job.location}"
      puts "  Url:".colorize(:light_blue) + " #{job.url}"
      puts "  Summary:".colorize(:light_blue) + "#{job.summary}"
      puts "----------------------".colorize(:red)
      puts "If you want to apply just 'copy-paste' the link it into your browser :)"
    end
  end

  def clear_last_search
    SearchJobs::Jobs.all.clear
  end

  def good_bye
    puts "Good bye!"
  end
end
