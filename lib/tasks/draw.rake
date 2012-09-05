namespace :utils do
  task :draw, [:needs] => [:environment] do |t,args|
    CONTESTS = {
        "#SOME_CODE"    => 3,
    }

    BLACKBOARD_PEOPLE = {
        "#SOME_CODE" => %w(fake1 fake2),
    }

    PEOPLE_TO_REJECT = %w(your-account)

    DB_PEOPLE = {}

    CONTESTS.keys.each do |code|
      activity = Activity.published.where(:code => code).first
      DB_PEOPLE[code] = activity.participations.map(&:account) if activity
    end

    WINNERS = {}

    CONTESTS.each do |c|
      WINNERS[c.first] = ((DB_PEOPLE[c.first] || []) + (BLACKBOARD_PEOPLE[c.first] || []) -  PEOPLE_TO_REJECT).map(&:downcase).uniq.shuffle.sample(c.last.to_i)
    end

    pp WINNERS
  end
end