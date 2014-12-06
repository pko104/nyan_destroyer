class Grid

  def initialize(window)
    @window = window
  end

  def draw
    draw_board
  end

  def draw_square(top_left_x, top_left_y, color)
    x = top_left_x
    y = top_left_y 
    c = color
    @window.draw_quad(x, y, c, x + 50, y, c, x + 50, y + 50, c, x, y + 50, c, 1)
  end

  def draw_board
    x = 0
    y = 0
    color_counter = 1

    until y == 1000
      until x == 1000
        if color_counter % 2 == 0
          color = 0xffffffff
        else
          color = 0xffffd700
        end

        draw_square(x, y, color) 
        color_counter += 1
        x += 50
      end
      y += 50
      x = 0
      color_counter = 0
    end
  end
end
