class SearchJobs::Jobs
  attr_accessor :name, :location, :url

  @@all = []

  def initialize(job_hash)
    job_hash.each { |attribute, value| self.send("#{attribute}=", value)}
    @@all << self
  end

  def self.all
    @@all
  end
end
