# frozen_string_literal: true

class DailyDigestMailer < ApplicationMailer
  def digest(user, questions)
    @questions = questions
    mail to: user.email
  end
end
