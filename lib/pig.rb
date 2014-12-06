class Pig
  attr_accessor :pig_image, :x, :y, :move_up, :move_down, :move_right, :move_left, :pig_speed

  def initialize(window, x, y)
    @pig_image = Gosu::Image.new(window, 'img/pig.png')
    @x = x
    @y = y

    @pig_speed = 50

    @move_up = false
    @move_down = false
    @move_right = false
    @move_left = false
  end

  def bounds
    BoundingBox.new(@x, @y, 50, 50)
  end

  def draw
    @pig_image.draw(@x, @y, 0)
  end

  def update
  
  end
end
