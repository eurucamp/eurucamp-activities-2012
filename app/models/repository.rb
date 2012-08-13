class Repository
  def self.activities
    Settings.activities.sort { |x,y| x["when"] <=> y["when"] }
  end

  def self.codes
    activities.map { |a| a["code"] }
  end

  def self.all
    activities.map do |activity|
      activity.merge("participations" => Participation.where(:code => activity["code"]))
    end
  end
end