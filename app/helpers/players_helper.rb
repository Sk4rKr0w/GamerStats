module PlayersHelper
  def format_queue_type(queue_type)
    case queue_type
    when 'RANKED_SOLO_5x5'
      'Ranked Solo/Duo'
    # Aggiungi altre mappature se necessario
    else
      queue_type
    end
  end
end
