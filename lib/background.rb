class Background
  attr_reader :theme, :menu_music, :lose_music
  def initialize(window, x, y)
    @window = window
    @y = y
    @x = x

   # @layer1 = Layers.new("bgLayer1.png", 800, 1, 0, 0, 1)
   # @layer2 = Layers.new("bgLayer2.png", 800, 3, 0, 0, 2)


    @bg_image1 = Gosu::Image.new(window, 'img/backgrounds/bg1.png')
    @bg_image2 = Gosu::Image.new(window, 'img/backgrounds/bg2.png')
    @bg_image3 = Gosu::Image.new(window, 'img/backgrounds/bg3.png')
    @bg_image4 = Gosu::Image.new(window, 'img/backgrounds/bg4.png')
    @bg_image5 = Gosu::Image.new(window, 'img/backgrounds/bg5.png')
    @bg_image6 = Gosu::Image.new(window, 'img/backgrounds/bg6.png')

    @song_path = ['music/spanish_armada.mp3'].sample
    @theme = Gosu::Song.new(window, @song_path)
    @menu_music = Gosu::Song.new(window, 'music/menu.mp3')
    @lose_music = Gosu::Song.new(window, 'music/nyan.mp3')

  end

  def draw
    case
    when @window.score >= 200_000
      @bg_image6.draw(@x, @y, 0)
    when @window.score >= 160_000
      @bg_image5.draw(@x, @y, 0)
    when @window.score >= 120_000
      @bg_image4.draw(@x, @y, 0)
    when @window.score >= 80_000
      @bg_image3.draw(@x, @y, 0)
    when @window.timer.seconds >= 20
      @bg_image2.draw(@x, @y, 0)
    else
      @bg_image1.draw(@x, @y, 0)

    end
  end
end
