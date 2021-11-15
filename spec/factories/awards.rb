FactoryBot.define do
  factory :award do
    name { 'MyAward' }
    after(:build) do |award|
      award.image.attach(
        io: File.open("#{Rails.root}/app/assets/images/test_image.jpg"),
        filename: 'test_image.jpg'
      )
    end
  end
end
