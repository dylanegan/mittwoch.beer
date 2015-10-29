#!/usr/bin/env ruby

require_relative "lib/mittwoch_beer"

File.open("public/index.html", "w") do |file|
  file << MittwochBeer.renderer("index.html.erb", { mittwochs: MittwochBeer.mittwochs }).render
end
