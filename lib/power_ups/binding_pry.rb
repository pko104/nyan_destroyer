class PryBoost
  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @state = :unused

    @pry_boost_image = Gosu::Image.new(window, 'img/binding_pry.png')
  end

  def bounds
    BoundingBox.new(@x, @y, 120, 25)
  end

  def draw
    if unused?
      @pry_boost_image.draw(@x, @y, 0)
    end
  end

  def boost(player)
    player.binding_pry += 1
    use
  end

  def use
    @state = :used
  end

  def unused?
    @state == :unused
  end

end
