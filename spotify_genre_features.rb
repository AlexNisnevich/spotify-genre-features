require 'optparse'
require 'rspotify'

# Usage:
# ruby spotify_genre_features.rb --api_key <KEY> --secret <SECRET> | tee features.csv

options = {}
op = OptionParser.new do |opt|
  opt.on('--api_key KEY') { |o| options[:api_key] = o }
  opt.on('--secret SECRET') { |o| options[:secret] = o }
end
op.parse!

if !options[:api_key] || !options[:secret]
  puts op.help()
  exit
end

RSpotify.authenticate(options[:api_key], options[:secret])

puts "id,genre,acousticness,danceability,duration_ms,energy,instrumentalness,key,liveness,loudness,mode,speechiness,tempo,time_signature,valence"

genres = RSpotify::Recommendations.available_genre_seeds

genres.each do |genre|
  begin
    tracks = RSpotify::Track.search "genre:#{genre}", limit: 50
    features = RSpotify::AudioFeatures.find(tracks.map(&:id))

    features.each do |f|
      puts "#{f.id},#{genre},#{f.acousticness},#{f.danceability},#{f.duration_ms},#{f.energy},#{f.instrumentalness},#{f.key},#{f.liveness},#{f.loudness},#{f.mode},#{f.speechiness},#{f.tempo},#{f.time_signature},#{f.valence}"
    end
  rescue
    next
  end
end