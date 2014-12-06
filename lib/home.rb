class Home
  attr_reader :home_image
  def initialize(window, x, y)
    @home_image = Gosu::Image.new(window, 'img/home.png')
    @x = x
    @y = y
  end

  def bounds
    BoundingBox.new(@x, @y, 200, 200)
  end


end
