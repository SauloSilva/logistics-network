class City < ActiveRecord::Base
  attr_accessor :routes

  validates :name, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
  validates :name, uniqueness: { scope: :map_id }

  belongs_to :map
  has_many :destinations, foreign_key: :from_id, dependent: :destroy, class_name: :Route do
    def to_format!
      self.map do |route|
        if route.from && route.to
          [route.from.name, route.to.name, route.distance]
        else
          [route.from_name, route.to_name, route.distance]
        end
      end
    end
  end

  before_validation :transform_name
  after_save :routes_save

  def self.all_destinations
    destinations = []

    City.all.each do |city|
      city.destinations.to_format!.each do |destination|
        destinations << destination
      end
    end

    destinations
  end

  def map_name=(name)
    self.map_id = Map.where(name: name).first_or_create.id
  end

  private

  def routes_save
    return unless routes

    destinations.destroy_all

    routes.each do |route|
      dist = destinations.new route
      dist.save
    end
  end

  def transform_name
    name.capitalize! if name
  end
end