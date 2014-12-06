class Pig
  attr_accessor :x, :y, :move_up, :move_down, :move_right, :move_left, :pig_speed

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
    if move_up
      unless y <= 0
        @y += -@pig_speed
      end
    end

    if move_down
      unless y >= (600 - @pig_image.height)
        @y += @pig_speed
      end
    end

    if move_right
      unless x >= (800 - @pig_image.width)
        @x += @pig_speed
      end
    end

    if move_left
      unless x <= 0
        @x += -@pig_speed
      end
    end
  end

end
