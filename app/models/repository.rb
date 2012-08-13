class Repository
  def self.all
    Activity.all
    #activities.map do |activity|
    #  activity.merge("participations" => Participation.where(:code => activity["code"]))
    #end
  end
end