class SearchJobs::Jobs

  attr_accessor :name, :location, :url

  @@all = []

  def initialize(job_hash)
    job_hash.each { |attribute, value| self.send("#{attribute}=", "#{value}") }
    @@all << self
  end

  def self.create_from_collection(jobs_array)
    jobs_array.each do |job_hash|
      SearchJobs::Jobs.new(job_hash)
    end
  end

  def self.all
    @@all
  end
end
