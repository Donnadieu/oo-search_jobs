class SearchJobs::CLI
  # Create a run function
  def run
    search
  end
  # Create a search funtion based on user input
  def search
    input = nil
    # Ensure that the program doesn't end unless specified
    while input != 'exit'
      puts "Please type 'search' to look for a job, 'show' to see the last search, 'clear' to clear last search or type 'exit': "
      input = gets.strip.downcase
      case input
      when 'search'
        puts "Please enter the job you are looking for: "
        search_term = gets.strip
        puts "Please enter the zip code: "
        # Make sure that the zip code is a number
        begin
          zip_code = gets
          zip_code = Integer(zip_code)
        rescue
          print "Please enter the zip code: "
          retry
        end
        # Scrape the infromation from the page
        SearchJobs::Scraper.indeed(search_term, zip_code)
        # Numbered the jobs array
        # SearchJobs::Scraper.number_jobs
        # Intsantiate jobs based on hashes keys and values
        # make_jobs(SearchJobs::Scraper.jobs_data)

      when'show'
        if SearchJobs::Jobs.all.empty?
          puts "No jobs to show"
        else
          display_jobs
          select_menu
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

  def select_menu
    puts "Select the number of the job you would like to know more details of: "
    input = gets.strip.to_i
    job = SearchJobs::Jobs.all[input-1]
    puts "==========#{job.company.upcase.strip}=========".colorize(:yellow)
    puts "#{job.name.upcase}".colorize(:blue)
    puts "  Location:".colorize(:light_blue) + " #{job.location}"
    puts "  Url:".colorize(:light_blue) + " #{job.url}"
    puts "  Summary:".colorize(:light_blue) + "#{job.summary}"
    puts "----------------------".colorize(:red)
    puts "If you want to apply just 'copy-paste' the link into your browser :)"
  end

  # Display resutls from the search
  def display_jobs
    jobs = SearchJobs::Jobs.all

    jobs.each.with_index(1) do |job, index|
      puts "#{index}.".colorize(:red) + "==========#{job.company.upcase.strip}=========".colorize(:yellow)
      puts "#{job.name.upcase}".colorize(:blue)
    end
  end

  def clear_last_search
    SearchJobs::Jobs.all.clear
    SearchJobs::Scraper.jobs_data.clear
  end

  def good_bye
    puts "Good bye!"
  end
end
