class DrawResult
  def initialize(points)
    @points = points
  end

  def score
    result_names.fetch(@points, "Deuce")
  end

  private
  def result_names
    {
        0 => "Love-All",
        1 => "Fifteen-All",
        2 => "Thirty-All",
    }
  end
end

class AdvantageOrWinResult
  def initialize(p1points, p2points)
    @p1points = p1points
    @p2points = p2points
  end

  def score
    result = @p1points - @p2points
    case
    when result == 1
      "Advantage player1"
    when result == -1
      "Advantage player2"
    when result >= 2
      "Win for player1"
    else
      "Win for player2"
    end
  end
end

class OngoinResult
  def initialize(p1points , p2points)
    @p1points = p1points
    @p2points = p2points
  end

  def score
    "#{result_names[@p1points]}-#{result_names[@p2points]}"
  end

  private

  def result_names
    {
        0 => "Love",
        1 => "Fifteen",
        2 => "Thirty",
        3 => "Forty",
    }
  end
end

class TennisGame1

  def initialize(player1Name, player2Name)
    @player1Name = player1Name
    @player2Name = player2Name
    @p1points = 0
    @p2points = 0
  end

  def won_point(playerName)
    if playerName == "player1"
      @p1points += 1
    else
      @p2points += 1
    end
  end

  def score
    draw_result if (@p1points == @p2points)
    advantage_or_win_result if (@p1points>=4 || @p2points>=4)
    ongoing_result
  end

  private

  def advantage_or_win_result
    AdvantageOrWinResult.new(@p1points, @p2points).score
  end

  def draw_result
    DrawResult.new(@p2points).score
  end

  def ongoing_result
    OngoinResult.new(@p1points, @p2points).score
  end
end
