class Menu
  attr_accessor :selection, :menu_action

  def initialize(window, x, y)
    @window = window
    @y = y
    @x = x

    # Assets
    @menu_font = Gosu::Font.new(@window, "Futura", 600 / 15)
    @control_font = Gosu::Font.new(@window, "Futura", 600 / 30)
    @bg_image = Gosu::Image.new(window, 'img/menu/background.png')
    @title = Gosu::Image.new(window, 'img/menu/title_name_big.png')

    # Logic
    @selection = 1
    @menu_action = nil
  end

  def draw
    @bg_image.draw(@x, @y, 0)
    @title.draw(175, 25, 4)
    draw_top_white
    draw_instructions_white

    draw_text(800, 920, "Controls:", @control_font, 0xFF000000)
    draw_text(800, 940, "Arrows - Move Hog", @control_font, 0xFF000000)
    draw_text(800, 960, "Spacebar - Start", @control_font, 0xFF000000)

  end

  def draw_square(top_left_x, top_left_y, color)
    x = top_left_x
    y = top_left_y
    c = color
    @window.draw_quad(x, y, c, x + 50, y, c, x + 50, y + 50, c, x, y + 50, c, 1)
  end

  def draw_top_white
    x = 0
    y = 0
    while y < 200
      until x == 1000
        draw_square(x,y, 0xffffffff)
        x += 50
      end
      y += 50
      x = 0
    end
  end

  def draw_instructions_white
    x = 750
    y = 900
    while y < 1000
      until x == 1000
          draw_square(x,y, 0xffffffff)
          x += 50
      end
      y += 50
      x = 750
    end
  end

  def update
    @menu_action
  end

  def draw_text_centered(text, font, y_adjust, c)
    x = (800 - font.text_width(text)) / 2
    y = (600 - font.height) / 2
    y += y_adjust
    color = c
    draw_text(x, y, text, font, color)
  end

  def draw_text(x, y, text, font, color)
    font.draw(text, x, y, 3, 1, 1, color)
  end


end
