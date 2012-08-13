class Participation
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::Validations

  field :code
  field :account

  index({ :code => 1, :account => 1 }, { :unique => true, :drop_dups => true })
  validates :code, :inclusion => { :in => Repository.codes, :allow_blank => false }
end