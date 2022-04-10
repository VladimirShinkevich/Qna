# frozen_string_literal: true

class Search
  RESOURCES = {
    'Questions' => Question,
    'Answers' => Answer,
    'Comments' => Comment,
    'Users' => User,
    'All' => ThinkingSphinx
  }.freeze

  def self.search(search_params)
    RESOURCES[search_params[:resources]].search search_params[:search]
  end
end
