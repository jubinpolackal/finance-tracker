# frozen_string_literal: true

class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_one_attached :avatar
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def already_tracked_stock?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    return false unless stock

    stocks.where(id: stock.id).exists?
  end

  def under_tracking_limit?
    stocks.count < 10
  end

  def can_track_stock?(ticker_symbol)
    under_tracking_limit? && !already_tracked_stock?(ticker_symbol)
  end

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"
  end
end
