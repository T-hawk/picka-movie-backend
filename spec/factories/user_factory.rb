require 'faker'

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "asdfasdf" }
    password_confirmation { "asdfasdf" }
  end

  factory :invalid_user do
    name {"Error"}
    email {"error"}
    password {"asdfasdf"}
    password_confirmation {"sdfasdf"}
  end
end
