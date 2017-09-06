class SearchJobs::Jobs

  attr_accessor :name, :location, :url, :company, :summary, :number

  @@all = []

  def initialize(job_hash)
    job_hash.each do |attribute, value|
      self.send("#{attribute}=", value)
    end
    @@all << self
  end

  def self.create_from_collection(jobs_array)
    jobs_array.each do |job_hash|
      SearchJobs::Jobs.new(job_hash)
    end
  end

  def self.search_by_number(job_number)
    SearchJobs::Jobs.all.detect {|job| job.number == job_number}
  end

  def self.all
    @@all
  end
end
