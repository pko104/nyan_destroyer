class Enemy
  attr_accessor :x, :y

  def initialize(window, x, y, speed)
    random_enemy = [1,2,3,4].sample
    @enemy_image = Gosu::Image.new(window, "img/enemy#{random_enemy}.png")
    @window = window
    @x = x
    @y = y
    @speed = speed
  end

  def draw
    @enemy_image.draw(x, y, 5)
  end

  def update
    @x += @speed
  end

  def bounds
    BoundingBox.new(@x, @y, 50, 50)
  end
end
