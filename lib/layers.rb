class Layers < Gosu::Image
attr_reader :vel

  def initialize(image, imagewidth, vel, x, y, z)
        @layer2_image = Gosu::Image.new($window, image, true)
        @layer2_image2 = Gosu::Image.new($window, image, true)
        @x = x
        @xt = @x
        @yt = y
        @vel = vel
        @z = z
        @iw = imagewidth
  end

  def draw
    @layer2_image.draw(@xt, @yt, @z)
    @layer2_image2.draw(@xt + @iw, @yt, @z)
  end

  def update
    @xt -= @vel
     if @xt <= -@iw then @xt = @x end
  end
end


