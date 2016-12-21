FactoryGirl.define do
  factory :user do
    username 'Mike'
    email 'mikemacadam87@gmail.com'
    password 'password'
    password_confirmation 'password'
    confirmed_at Date.today
    role 'admin'
  end
end
