FactoryBot.define do
  factory :user do
    name {"Brad"}
    email {"brad@gmail.com"}
    password {"asdfasdf"}
    password_confirmation {"asdfasdf"}
  end

  factory :invalid_user do
    name {"Error"}
    email {"error"}
    password {"asdfasdf"}
    password_confirmation {"sdfasdf"}
  end
end
