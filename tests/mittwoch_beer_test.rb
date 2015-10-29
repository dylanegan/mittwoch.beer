require_relative "../lib/mittwoch_beer"

MittwochBeer.renderer("index.html.erb", { mittwochs: MittwochBeer.mittwochs }).render
