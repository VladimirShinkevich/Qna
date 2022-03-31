# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/daily_dijest
class DailyDigestPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/daily_dijest/dijest
  def digest
    DailyDigestMailer.digest
  end
end
