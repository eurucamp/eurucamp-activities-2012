class Activity
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::Validations

  embeds_many :participations

  field :published, :type => Boolean
  field :code,      :type => String
  field :name,      :type => String
  field :where,     :type => String
  field :when,      :type => DateTime

  validates :code,  :presence => true, :allow_blank => false
  validates :name,  :presence => true, :allow_blank => false
  validates :where, :presence => true, :allow_blank => false
  validates :when,  :presence => true, :allow_blank => false

  index({ :code => 1 }, { :unique => true })
  index({ "participations.account" => 1 }, { :unique => true, :drop_dups => true })

  accepts_nested_attributes_for :participations

  scope :published, where(:published => true)
end





