class HelloWorldJob < ApplicationJob
  queue_as :default

  def fetch_country params
    country = Country.find_by_name params['name']
    return country if country
    Country.create! name: params['name'], code: params['code'], timezone: params['timezone']
  end

  def fetch_network params
    network = Network.find_by_name params['name']
    return network if network
    country = fetch_country params['country']
    Network.create! name: params['name'], country_id: country.id
  end

  def perform(*args)
    Show.destroy_all
    url = 'http://api.tvmaze.com/search/shows'
    conn = Faraday.new(url: url) do |faraday|
      faraday.adapter Faraday.default_adapter
      faraday.response :json
    end

    response = conn.get '/shows', page: args[0]
    if response.success?
      response.body.each do |show|
        show['image'] ||= {}
        show['externals'] ||= {}
        show['network'] ||= {}

        network = fetch_network(show['network']) if show['network'].present?

        Show.create!(
          name: show['name'],
          url: show['url'],
          show_type: show['type'],
          status: show['status'],
          runtime: show['runtime'],
          premiered: show['premiered'],
          original: show['image']['original'],
          medium: show['image']['medium'],
          tvmaze_id: show['id'],
          imdb_id: show['externals']['imdb'],
          tvrage_id: show['externals']['tvrage'],
          thetvdb_id: show['externals']['thetvdb'],
          summary: show['summary'],
          network_id: network.try(:id),
          language: show['language'],
        )
      end
    else
      puts "FAILURE!"
    end
  end
end
