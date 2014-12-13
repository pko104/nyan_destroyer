class SpeedBoost
  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @state = :unused

    @speed_boost_image = Gosu::Image.new(window, 'img/rails.jpg')
  end

  def bounds
    BoundingBox.new(@x, @y, 64, 64)
  end

  def draw
    if unused?
      @speed_boost_image.draw(@x, @y, 0)
    end
  end

  def boost(player)
    player.bullet_speed_boost += 2
    use
  end

  def use
    @state = :used
  end

  def unused?
    @state == :unused
  end

end
