require 'pry'
require 'gosu'
require 'uri'
require 'net/http'
#require 'devil'

require_relative 'lib/bounding_box'
require_relative 'lib/player'
require_relative 'lib/keys'
require_relative 'lib/enemies'
require_relative 'lib/background'
require_relative 'lib/bullet'
require_relative 'lib/charge'
require_relative 'lib/timer'
require_relative 'lib/columnattack'
require_relative 'lib/power_ups/speed'
require_relative 'lib/power_ups/bombs'
require_relative 'lib/power_ups/binding_pry'
require_relative 'menu'

NAME = ARGV[0] || "Anonymous"

class GameWindow < Gosu::Window
  SCREEN_WIDTH = 1080
  SCREEN_HEIGHT = 768

  include Keys
  attr_reader :timer, :player, :name, :score, :music, :sfx
  attr_accessor :enemies, :large_font


  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.caption = "Nyan Destroyer"
    @background = Background.new(self, 0, 0)
    @player = Player.new(self, 0, 360)

    #Power Ups
    @power_ups = summon_power_ups
    @dropped_power_up = @power_ups.select {|o| o.unused? == true}.first
    @current_boost = []
    @pwr_up_frequency = 25 * 60
    @pwr_up_spawn_time = 5 * 60
    @p_up_counter = 0

    # Enemies + Bullets
    @spawn_rate = 0.5
    @spawn_acc = 5.0
    @enemies = []
    @bullets = []
    @special_enemies =[]
 #   @column_enemies = []

    # Game & Player Mechanics
    @name = NAME
    @score = 0
    @state = :menu

    # Timer & Counters
    @timer = Timer.new
    @counter_spawn = 0
    @counter_rate = 0

    #Map movement
    @camera_x = @camera_y = 0

    # Font and Menu
    @music = true
    @sfx = true
    @menu = Menu.new(self, 0, 0, @music, @sfx)
    @large_font = Gosu::Font.new(self, "Futura", SCREEN_HEIGHT / 10)
    @medium_font = Gosu::Font.new(self, "Futura", SCREEN_HEIGHT / 22)
    @small_font = Gosu::Font.new(self, "Futura", SCREEN_HEIGHT / 30)
    @game_end = nil
  end

  def draw
    @menu.draw if @state == :menu

    if @state != :menu
      if @state == :running
        @counter_spawn += 1
        @counter_rate += 1
        @background.draw
        @player.draw
        @enemies.each {|e| e.draw} if !@enemies.empty?
        @bullets.each {|b| b.draw} if !@bullets.empty?
        @special_enemies.each {|s| s.draw} if !@special_enemies.empty?
      #  @column_enemies.each {|s| s.update} if !@column_enemies.empty?
        @p_up_counter += 1

        #Drop Power Ups
        if @p_up_counter >= @pwr_up_frequency && @p_up_counter <= @pwr_up_frequency  + @pwr_up_spawn_time
          @dropped_power_up.draw if !@dropped_power_up.nil?
          if @p_up_counter == @pwr_up_frequency + @pwr_up_spawn_time
            @p_up_counter = 0
            @dropped_power_up = @power_ups.select {|o| o.unused? == true}.first
          end
        end

        draw_text((SCREEN_WIDTH - @large_font.text_width("#{@score}") + 25) / 2, 10,"#{@score}", @medium_font, Gosu::Color::YELLOW)
        draw_text(1000, 54,"#{@timer.seconds}", @small_font, Gosu::Color::RED)
      end

      if @state == :lose
        draw_text_centered("Game Over", large_font)
        @background.draw
        if @game_end == nil
          @game_end = Timer.new
        end
        @game_end.update
        if @game_end.seconds >= 15
          reset(:menu)
        end
      end
    end
  end


  def update
    menu_action = @menu.update
    if @state == :menu && @music == true
      @background.menu_music.play
    else
      @background.menu_music.pause
    end

    if menu_action == "start"
      @background.menu_music.pause
      @background.theme.play if @music
      @state = :running
      @timer = Timer.new
    elsif menu_action == "mtoggle"
      @music == true ? @music = false : @music = true
    elsif menu_action == "sfxtoggle"
      @sfx == true ? @sfx = false : @sfx = true
    end
    @menu.menu_action = nil

    if @state == :running
      @counter_spawn +=1
      @counter_rate +=1
      @player.update
      @timer.update
      @enemies.each {|e| e.update}
      @special_enemies.each {|s| s.update}
 #     @column_enemies.each {|c| c.update}
      @bullets.each {|b| b.update} if !@bullets.empty?

      summon_enemies

  #    column_collision?
      spenemy_collision?
      enemy_collision?
      bullet_collision?
      power_up_boost? if !@dropped_power_up.nil?
    end

    if @state == :lose
      @background.theme.pause
      @background.lose_music.play if @music
      @enemies.each {|e| e.state == :pause}
    end
  end

  def summon_enemies
    case
    when timer.minutes >= 4
      if @counter_spawn >= (@spawn_rate * 60.0)
        4.times { @enemies << spawn }
        @counter_spawn = 0
      end
      if @counter_rate >= (@spawn_acc * 60.0)
        @spawn_rate -= 0.4 if @spawn_rate > 0.7
        @counter_rate = 0
      end
    when timer.minutes >= 2
      if @counter_spawn >= (@spawn_rate * 60.0)
        3.times { @enemies << spawn }
        @counter_spawn = 0
      end
      if @counter_rate >= (@spawn_acc * 60.0)
        @spawn_rate -= 0.4 if @spawn_rate > 0.7
        @counter_rate = 0
      end
    when timer.seconds >= 20
      if @counter_spawn >= (@spawn_rate * 60.0)
       # 2.times { @enemies << spawn }
        @special_enemies << colossus

        @counter_spawn = 0
      end
      if @counter_rate >= (@spawn_acc * 60.0)
        @spawn_rate -= 0.4 if @spawn_rate > 0.7
        @counter_rate = 0
      end
    when timer.seconds >= 0
      if @counter_spawn >= (@spawn_rate * 60.0)
        @enemies << spawn
     #   @column_enemies << columns
        @counter_spawn = 0
      end
      if @counter_rate >= (@spawn_acc * 60.0)
        @spawn_rate -= 0.4 if @spawn_rate > 0.7
        @counter_rate = 0
      end
    end
  end

  def e_top_right
    Enemy.new(self, (rand(100) + 980), rand(100), @player)
  end

  def e_mid_top_right
    Enemy.new(self, (rand(100) + 980), (rand(100) + 155), @player)
  end

  def e_mid_right
    Enemy.new(self, (rand(100) + 980), (rand(100) + 310), @player)
  end

  def e_mid_bot_right
    Enemy.new(self, (rand(100) + 980), (rand(100) + 465), @player)
  end

  def e_bot_right
    Enemy.new(self, (rand(100) + 980), (rand(100) + 620), @player)
  end

 # def columns
 #   ColumnAttack.new(self, (rand(100..980)), (700), @player)
 # end

  def colossus
    Charge.new(self, (rand(100) + 980), (rand(100..620)), @player)
  end

  def spawn
    [e_bot_right, e_mid_bot_right, e_mid_right, e_mid_top_right, e_top_right].sample
  end

  def summon_power_ups
    power_ups = []
    5.times do
      power_ups << SpeedBoost.new(self, rand(700), rand(500))
    end
    10.times do
      power_ups << PryBoost.new(self, rand(700), rand(500))
    end
    10.times do
      power_ups << BombBoost.new(self, rand(700), rand(500))
    end
    power_ups.shuffle!
    return power_ups
  end

  def enemy_collision?
    @enemies.any? do |enemy|
      if enemy.bounds.intersects?(@player.bounds)
       @state = :lose
      end
    end
  end

   def spenemy_collision?
     @special_enemies.any? do |man|
       if man.bounds.intersects?(@player.bounds)
        @state = :lose
       end
     end
   end

   # def column_collision?
   #   @column_enemies.any? do |column|
   #     if column.bounds.intersects?(@player.bounds)
   #      @state = :lose
   #     elsif column.bounce
   #       @column_enemies.delete(column)
   #     end
   #   end
   # end

  def bullet_collision?
    unless @bullets.empty?
      @bullets.any? do |bullet|

        @enemies.any? do |enemy|
          if bullet.bounds.intersects?(enemy.bounds)
            @enemies.delete(enemy)
            enemy.death.play if sfx == true
            @score += (100 + (@timer.seconds)*20)
          end
        end
        @kill_count = 0
        @special_enemies.any? do |man|
          if man.bounce
            @special_enemies.delete(man)
          elsif bullet.bounds.intersects?(man.bounds)
            @special_enemies.delete(man)
            man.death.play if sfx == true
            @score += (500 + (@timer.seconds)*20)
          end

        end

      end
    end
  end

  def power_up_boost?
    if @dropped_power_up.bounds.intersects?(@player.bounds) && @dropped_power_up.unused?
      @dropped_power_up.boost(@player)
    end
  end

  def draw_text_centered(text, font)
    x = (SCREEN_WIDTH - font.text_width(text)) / 2
    y = (SCREEN_HEIGHT - font.height) / 2
    color = Gosu::Color::WHITE
    draw_text(x, y, text, font, color)
    draw_text((SCREEN_WIDTH - @large_font.text_width("#{@score}"))/2, 500,"#{@score}", @large_font, Gosu::Color::YELLOW)
  end

  def draw_text(x, y, text, font, color)
    font.draw(text, x, y, 3, 1, 1, color)
  end

  def reset(state)
    @menu = Menu.new(self, 0, 0, @music, @sfx)
    @player = Player.new(self, 0, 360)
    @timer = Timer.new
    @power_ups = summon_power_ups
    @enemies = []
    @bullets = []
    @current_boost = []
    @column_enemies = []
    @special_enemies = []
    @score = 0
    @state = state
    @dropped_power_up = nil
    @game_end = nil
    @p_up_counter = 0
    @counter_spawn = 0
    @counter_rate = 0
  end
end

GameWindow.new.show
