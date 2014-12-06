require 'pry'
require 'gosu'
require_relative './lib/pig'

require_relative 'grid'

class Game < Gosu::Window
  def initialize
    super(1000, 1000, false)
    @grid = Grid.new(self)
    @pig = Pig.new(self, 100, 600)
  end

  def draw
    @grid.draw
    @pig.draw
  end

  def update

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
  end

  def button_up(id)
    if id == Gosu::KbW
      @pig.move_up = false
    end
    if id == Gosu::KbS
      @pig.move_down = false
    end
    if id == Gosu::KbA
      @pig.move_left = false
    end
    if id == Gosu::KbD
      @pig.move_right = false
    end
  end

end
Game.new.show
