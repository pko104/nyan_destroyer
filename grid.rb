class Grid
  attr_reader :home
  def initialize(window)
    @window = window
    @grass_image = Gosu::Image.new(window, 'img/grass.jpg')
    @mud_image = Gosu::Image.new(window, 'img/mud.png')
    @tree_image = Gosu::Image.new(window, 'img/tree.jpg')
    @home = Home.new(window, 0, 0)
  end

  def draw
    draw_home
    draw_bottom_grass
    draw_top_grass
    draw_safety_grass
    draw_mud
  end

  def draw_square(top_left_x, top_left_y, color)
    x = top_left_x
    y = top_left_y
    c = color
    @window.draw_quad(x, y, c, x + 50, y, c, x + 50, y + 50, c, x, y + 50, c, 1)
  end

  def draw_mud
    x = 0
    y = 200
    z = 0

    while 800 > y
      until x == 1000
        @mud_image.draw(x, y, z)
        x += 50
      end
        y += 50
        x = 0
    end
  end


  def draw_bottom_grass
    x = 0
    y = 950
    z = 0
    until y < 800
      until x == 1000
        @grass_image.draw(x, y, z)
        x += 50
      end
      y -= 50
      x = 0
    end
  end

  def draw_safety_grass
  x = 0
  y = 550
  z = 1

  until x == 1000
    @grass_image.draw(x, y, z)
    x += 50
  end

  end


  def draw_top_grass
    x2 = 0
    y2 = 0
    z2 = 0
    while 200 > y2
      until x2 == 1000
        @grass_image.draw(x2, y2, z2)
        x2 += 50
      end
      y2 += 50
      x2 = 0
    end
  end

  def draw_home
    @home.home_image.draw(0, 0, 1)
  end

end

#262 × 691
