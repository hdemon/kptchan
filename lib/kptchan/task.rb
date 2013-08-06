require "active_support/all"
require "mongoid"


class Task
  include Mongoid::Document

  field :inc_id, type: Integer
  field :nickname
  field :category, type: Symbol
  field :content
  field :created_at, type: Time
  field :done, type: Boolean
  field :available, type: Boolean
end
