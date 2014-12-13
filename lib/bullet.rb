class Bullet

  def initialize(window, x, y, x_speed, y_speed, bullet_speed)
    @window = window
    @x = x
    @y = y
    @x_speed = x_speed
    @y_speed = y_speed
    @bullet_speed = bullet_speed
    @bullet_image = Gosu::Image.new(window, 'img/test_bullet2.png')
  end

  def bounds
    BoundingBox.new(@x, @y, 10, 10)
  end

  def draw
    @bullet_image.draw(@x, @y, 1)
  end

  def update
    @x += @bullet_speed * @x_speed
    @y += @bullet_speed * @y_speed
  end

end
