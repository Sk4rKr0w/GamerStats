class InsightsController < ApplicationController
    def index
      file_path = Rails.root.join('vendor', 'assets', 'dragontail-14.13.1', '14.13.1', 'data', 'en_US', 'champion.json')
      file = File.read(file_path)
      champions_data = JSON.parse(file)
  
      @insights = champions_data['data'].values.map do |champion|
        {
          tier: 'S', # Questa è solo un esempio. Potresti avere bisogno di un altro file o logica per il tier
          champion: champion['id'],
          winrate: champion['winrate'], # Dati casuali per esempio. Devi sostituire con i dati reali
          pickrate: champion['pickrate'], # Dati casuali per esempio. Devi sostituire con i dati reali
          banrate: champion['banrate'], # Dati casuali per esempio. Devi sostituire con i dati reali
          matches: champion['matches'], # Dati casuali per esempio. Devi sostituire con i dati reali
          lane: champion['role'] # Dati casuali per esempio. Devi sostituire con i dati reali
        }
      end
    end
  end
  