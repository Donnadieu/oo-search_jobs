class SearchJobs::CLI

  def call
    puts "Welcome to Job Search!"
    search
  end

  def search
    puts "Please enter the job you are looking for: "
    search_term = gets.strip
    puts "Please enter the zip code: "
    zip_code = gets.to_i
    SearchJobs::Scraper.indeed(search_term, zip_code)
  end
end
