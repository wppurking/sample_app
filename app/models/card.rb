class Card < ActiveRecord::Base
  attr_accessible :title, :body

  before_save :log_card


  belongs_to :user

  private
  def log_card
    puts "Save Card"
  end
end
