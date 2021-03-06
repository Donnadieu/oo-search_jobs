class SearchJobs::Jobs

  attr_accessor :name, :location, :url, :company, :summary

  @@all = []

  def initialize(job_hash)
    job_hash.each do |attribute, value|
      self.send("#{attribute}=", value)
    end
    @@all << self
  end

  def self.all
    @@all
  end
end
