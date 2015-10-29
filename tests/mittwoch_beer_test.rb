require_relative "../lib/mittwoch_beer"

failed = false

MittwochBeer.renderer("index.html.erb", { mittwochs: MittwochBeer.mittwochs }).render

duplicate_foursquare_venues = MittwochBeer.venues.group_by { |venue| venue.foursquare_id }.
  select { |id, venues| !id.nil? && venues.size > 1 }

if duplicate_foursquare_venues.any?
  puts "Detected duplicate Foursquare venues..."
  puts ""

  duplicate_foursquare_venues.each do |id, venues|
    puts "Identification: #{id}"

    venues.each do |venue|
      puts venue.name
    end

    puts ""
  end
end

duplicate_untappd_venues = MittwochBeer.venues.group_by { |venue| venue.untappd_id }.
  select { |id, venues| !id.nil? && venues.size > 1 }

if duplicate_untappd_venues.any?
  puts "Detected duplicate Untappd venues ..."
  puts ""

  duplicate_untappd_venues.each do |id, venues|
    puts "Identification: #{id}"

    venues.each do |venue|
      puts venue.name
    end

    puts ""
  end
end

exit 1 if failed
