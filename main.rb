require 'pry'
require 'gosu'
require_relative './lib/pig'
require_relative './lib/enemy'
require_relative './lib/bounding_box'
require_relative 'menu'
require_relative './lib/home'
require_relative 'grid'

class Game < Gosu::Window
  attr_reader :state
  def initialize
    super(1000, 1000, false)
    @grid = Grid.new(self)
    @pig = Pig.new(self, 500, 950)
    @state = :menu
    @summon_counter = 0
    @menu = Menu.new(self, 0, 0)
    @large_font = Gosu::Font.new(self, 'futura', 100)
    @small_font = Gosu::Font.new(self, 'futura', 40)



    @lane1 = [ ]
    @lane2 = [ ]
    @lane3 = [ ]
    @lane4 = [ ]
    @lane5 = [ ]
    @lane6 = [ ]
    @lane7 = [ ]
    @lane8 = [ ]
  end

  def draw
    if @state == :menu
      @menu.draw
    end

    if @state == :running
      @grid.draw
      @pig.draw
      @lane1.each { |enemy| enemy.draw }
      @lane2.each { |enemy| enemy.draw }
      @lane3.each { |enemy| enemy.draw }
      @lane4.each { |enemy| enemy.draw }
      @lane5.each { |enemy| enemy.draw }
      @lane6.each { |enemy| enemy.draw }
      @lane7.each { |enemy| enemy.draw }
      @lane8.each { |enemy| enemy.draw }
    end

    if @state == :lost
      # t = Time.now + 10
      #   while Time.now < t
      @menu.lose_image.draw(650, 220, 0)
      @menu.draw_text(275, 0, "Sorry, I win...", @large_font, 0xffffffff)
      @menu.draw_text(300, 125, "Press Enter to play again!", @small_font, 0xffffffff)

    end
  end


  def update
    @lane1.each { |enemy| enemy.update }
    @lane2.each { |enemy| enemy.update }
    @lane3.each { |enemy| enemy.update }
    @lane4.each { |enemy| enemy.update }
    @lane5.each { |enemy| enemy.update }
    @lane6.each { |enemy| enemy.update }
    @lane7.each { |enemy| enemy.update }
    @lane8.each { |enemy| enemy.update }
    @summon_counter += 1
    summon_farmers

    pig_collided?
    player_won?
  end

  def player_won?
    if @grid.home.bounds.intersects?(@pig.bounds)
      @state = :menu
      reset
    end
  end

  def pig_collided?
    [@lane1, @lane2, @lane3, @lane4, @lane5, @lane6, @lane7, @lane8].each do |lane|
      lane.each do |enemy|
       if enemy.bounds.intersects?(@pig.bounds)
         @state = :lost
       end
      end
    end
  end

  def summon_farmers
    if (@summon_counter % 180 == 0) || (@summon_counter % 190 == 0)
      @lane2 << Enemy.new(self, 950, 700, -5)
    elsif (@summon_counter % 120 == 0) || (@summon_counter % 180 == 0)
      @lane3 << Enemy.new(self, 50, 650, 7)
    elsif (@summon_counter % 110 == 0) || (@summon_counter % 180 == 0)
      @lane4 << Enemy.new(self, 950, 600, -5)
    elsif (@summon_counter % 210 == 0) || (@summon_counter % 100 == 0)
      @lane1 << Enemy.new(self, 50, 750, 7)
    end

    if (@summon_counter % 60 == 0) || (@summon_counter % 120 == 0)
      @lane5 << Enemy.new(self, 50, 350, 10)
    end

    if (@summon_counter % 120 == 0)
      @lane6 << Enemy.new(self, 950, 500, -5)
    end

    if (@summon_counter % 60 == 0) || (@summon_counter % 120 == 0)
      @lane7 << Enemy.new(self, 50, 450, 8)
    end

    if (@summon_counter % 60 == 0) || (@summon_counter % 120 == 0)
      @lane8 << Enemy.new(self, 950, 400, -8)
    end
  end

  def lose_screen
    @state = :lose
  end

  def reset
    @state = :menu
    @grid = Grid.new(self)
    @pig = Pig.new(self, 500, 900)
    @summon_counter = 0

    @menu = Menu.new(self, 0, 0)

    @lane1 = [ Enemy.new(self, 1000, 500, -5) ]
    @lane2 = [ Enemy.new(self, 0, 450, 5)]
  end

  def button_down(id)
    if id == Gosu::KbW
      unless @pig.y <= 0
        @pig.y -= @pig.pig_speed
      end
    end
    if id == Gosu::KbS
      unless @pig.y >= (1000 - @pig.pig_image.height)
        @pig.y += @pig.pig_speed
      end
    end
    if id == Gosu::KbA
      unless @pig.x <= 0
        @pig.x -= @pig.pig_speed
      end
    end
    if id == Gosu::KbD
      unless @pig.x >= (1000 - @pig.pig_image.width)
        @pig.x += @pig.pig_speed
      end
    end
    if id == Gosu::KbSpace
      @state = :running
    end


      if id == Gosu::KbReturn
      @state = :menu
      reset
      end

  end
end

Game.new.show
