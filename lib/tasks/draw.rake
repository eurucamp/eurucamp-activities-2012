namespace :utils do
  task :draw, [:needs] => [:environment] do |t,args|
    CONTESTS = {
        "#CODECLIMATE"    => 3,
        "#BUBBLE"         => 10,
        "#CHEMEX"         => 2,
        "#OREILLY"        => 6
    }

    WHITEBOARD_PEOPLE = {
        "#OREILLY" => %w(chrisberkhout MichaelP codezeilen shime.rb erotte abrirjam nerdbabe UdoJ),
        "#CHEMEX"  => %w(chrisberkhout norbertc errote),
        "#BUBBLE"  => %w(BenjaminMichenrv africajam nerdbabe MichaelP africajam nerdbabe MichaelP dimitritievely)
    }

    PEOPLE_TO_REJECT = %w(eurucamp eurucamplive myabc piotrgega)

    DB_PEOPLE = {}

    CONTESTS.keys.each do |code|
      activity = Activity.published.where(:code => code).first
      DB_PEOPLE[code] = activity.participations.map(&:account) if activity
    end

    WINNERS = {}

    CONTESTS.each do |c|
      WINNERS[c.first] = ((DB_PEOPLE[c.first] || []) + (WHITEBOARD_PEOPLE[c.first] || []) -  PEOPLE_TO_REJECT).map(&:downcase).uniq.shuffle.sample(c.last.to_i)
    end

    pp WINNERS
  end
end