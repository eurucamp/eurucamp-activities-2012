class Activity
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::Validations

  has_many :participations

  field :published, :type => Boolean, :default => false
  field :code,      :type => String
  field :name,      :type => String
  field :where,     :type => String
  field :when,      :type => DateTime
  field :prerequisites, :type => String

  validates :code,  :presence => true, :allow_blank => false, :uniqueness => true
  validates :name,  :presence => true, :allow_blank => false
  validates :where, :presence => true, :allow_blank => false
  validates :when,  :presence => true, :allow_blank => false

  index({:code => 1}, {:unique => true})

  accepts_nested_attributes_for :participations

  default_scope order_by(:when => :asc)
  scope :published, where(:published => true)

  before_validation do |a|
    a.code = a.code.try(:downcase)
  end
end





