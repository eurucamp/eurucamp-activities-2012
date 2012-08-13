class Participation
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::Validations

  embedded_in :activity

  field :account

  validates :account,  :presence => true, :allow_blank => false

  # index({ :account => 1 }, { :unique => true, :drop_dups => true })
  # moved to parent document
end