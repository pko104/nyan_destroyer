class Menu
  attr_accessor :selection, :music, :sfx, :menu_action, :select_sound

  def initialize(window, x, y, music, sfx)
    @window = window
    @y = y
    @x = x
    @music = music
    @sfx = sfx

    # Assets
    @menu_font = Gosu::Font.new(@window, "Futura", 600 / 15)
    @control_font = Gosu::Font.new(@window, "Futura", 600 / 30)
    @select_sound = Gosu::Sample.new(@window, 'music/menuselect.ogg')
    @bg_image = Gosu::Image.new(window, 'img/menu/menu_background.png')
    @title = Gosu::Image.new(window, 'img/title.png')

    # Logic
    @selection = 1
    @menu_action = nil
  end

  def draw
    @bg_image.draw(@x, @y, 0)
    @title.draw(150, -50, 0)

    # Toggle Music/SFX
    @window.music == true ? @music_value = "ON" : @music_value = "OFF"
    @window.sfx == true ? @sfx_value = "ON" : @sfx_value = "OFF"

    # Menu Controls
    scolor, mcolor, fcolor = 0xffffffff, 0xffffffff, 0xffffffff
    hcolor = Gosu::Color::RED

    scolor = hcolor if @selection == 1
    draw_text_centered("Play Game", @menu_font, 250, scolor)
    mcolor = hcolor if @selection == 2
    draw_text_centered("Music: #{@music_value} ", @menu_font, 300, mcolor)
    fcolor = hcolor if @selection == 3
    draw_text_centered("SFX: #{@sfx_value} ", @menu_font, 350, fcolor)


    # Player Controls
    draw_text(15, 620, "Controls:", @control_font, 0xffffffff)
    draw_text(15, 640, "Enter - Reset at gameover", @control_font, 0xffffffff)
    draw_text(15, 660, "Up/Down/Left/Right - Move Player", @control_font, 0xffffffff)
    draw_text(15, 680, "Spacebar - Shoot", @control_font, 0xffffffff)
   # draw_text(15, 700, "Spacebar - Use Help Request", @control_font, 0xffffffff)
    #draw_text(15, 720, "P - Activate Pry", @control_font, 0xffffffff)

    # Credits
   # draw_text(850, 700, "Borrowed from Spencer Dixon ", @control_font, 0xffffffff )
    #draw_text(875, 720, "Updated by Peter Ko", @control_font, 0xffffffff )

    # Highscore
   # draw_text(280, 565, "High Scores: rubywars.herokuapp.com ", @control_font, 0xffffffff )
  end

  def update
    @menu_action
  end

  def draw_text_centered(text, font, y_adjust, c)
    x = (1080 - font.text_width(text)) / 2
    y = (720 - font.height) / 2
    y += y_adjust
    color = c
    draw_text(x, y, text, font, color)
  end

  def draw_text(x, y, text, font, color)
    font.draw(text, x, y, 3, 1, 1, color)
  end


end
