class Eric
  attr_accessor :x, :y

  def initialize(window, x, y, speed)
    @eric_image = Gosu::Image.new(window, "img/creepy_eric.png")
    @window = window
    @x = x
    @y = y
    @speed = speed
  end

  def draw
    @enemy_image.draw(x, y, -1)
  end

  def update
  
  end


end
