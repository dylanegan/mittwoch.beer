require "json"

require "erb"
require "tilt"

module MittwochBeer
  Mittwoch = Struct.new(:date, :venues)
  Venue = Struct.new(:id, :name, :foursquare_id, :untappd_id, :url)

  class MittwochProxy < Array
    def previous
      @previous ||= self.select { |mittwoch| mittwoch.date < Date.today }
    end

    def today
      @today ||= self.select { |mittwoch| mittwoch.date == Date.today }
    end

    def upcoming
      @upcoming ||= self.select { |mittwoch| mittwoch.date > Date.today }
    end
  end

  def self.mittwochs
    return @mittwochs if @mittwochs

    @mittwochs = MittwochProxy.new

    json("mittwochs").each do |mittwoch|
      @mittwochs << Mittwoch.new(Date.parse(mittwoch["date"]), venues_for(mittwoch["venues"]))
    end

    @mittwochs
  end

  def self.renderer(template, locals = {})
    Renderer.new(template, locals)
  end

  def self.venues
    @venues ||= json("venues").map do |venue|
      Venue.new(venue["id"], venue["name"], venue["foursquare_id"], venue["untappd_id"], venue["url"])
    end
  end

  class Renderer
    attr_reader :locals, :template

    def initialize(template, locals = {})
      @template = Tilt.new("templates/#{template}", trim: true)
      @locals = locals
    end

    def render
      @render ||= template.render(self, locals)
    end
  end

  private

  def self.json(file)
    JSON.parse(IO.read("json/#{file}.json"))
  end

  def self.venues_for(ids)
    venues.select { |venue| ids.include?(venue.id) }
  end
end
