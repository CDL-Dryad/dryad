FactoryBot.define do

  factory :affiliation, class: StashDatacite::Affiliation do
    long_name { Faker::Educator.university }
  end

end
