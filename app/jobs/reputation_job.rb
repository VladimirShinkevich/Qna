# frozen_string_literal: true

class ReputationJob < ApplicationJob
  queue_as :default

  def perform(obj)
    Reputation.calculate(obj)
  end
end
