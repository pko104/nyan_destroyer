class Charge

  attr_reader :x, :y, :player, :speed, :death, :bounce
  attr_accessor :state

  def initialize(window, x, y, player)

    @enemy_image = Gosu::Image.new(window, 'img/colossus.png')

    @player = player
    @window = window
    @x = x
    @y = y
    @state = :attack
    @speed = 20
    @bounce = false

    @death = Gosu::Sample.new(@window, 'music/Shot 4.wav')
  end

  def bounds
    BoundingBox.new(@x, @y, 100, 42)
  end

  def draw
    @enemy_image.draw(@x, @y, 1)
  end

  def update
    unless @state == :pause
      @bounce = true if  @x >= 1032 || @y >= 672 || @x <= 0 || @y <= 0
    #  if @bounce == true
#
        dx = (player.x - self.x).to_f
        dy = (player.y - self.y).to_f

        distance = Math.sqrt((dx * dx) + (dy * dy))

       vel_x = (dx / distance) * speed
       vel_y = (dy / distance) * speed

        @x += vel_x
        @y += vel_y
        #@y = speed
    #  else
    #    @destroy == false
    end
  end

end
