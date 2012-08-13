class Participation
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::Validations

  belongs_to :activity

  field :account

  validates :account, :presence => true, :allow_blank => false, :uniqueness => {:scope => [:account, :activity_id]}

  index({:account => 1, :activity_id => 1}, {:unique => true, :drop_dups => true})

end