module Keys

  def button_down(id)
    if @state == :menu

        if id == Gosu::KbUp
        @menu.selection -= 1
        @menu.select_sound.play(0.4) if @sfx == true
        if @menu.selection < 1
          @menu.selection = 3
        end
        elsif id == Gosu::KbDown
        @menu.selection += 1
        @menu.select_sound.play(0.4) if @sfx == true
        if @menu.selection > 3
          @menu.selection = 1
        end
        elsif id == Gosu::KbReturn
        if @menu.selection == 1
          @menu.menu_action = "start"
        elsif @menu.selection == 2
          @menu.menu_action = "mtoggle"
        elsif @menu.selection == 3
          @menu.menu_action = "sfxtoggle"
        end
      end
    end


    if @state != :lose
      if id == Gosu::KbUp
        @player.move_up = true
      end
      if id == Gosu::KbDown
        @player.move_down = true
      end
      if id == Gosu::KbLeft
        @player.move_left = true
      end
      if id == Gosu::KbRight
        @player.move_right = true
      end
      if id == Gosu::KbR
        if @player.bombs >= 1
          @player.bombs -= 1
          @player.help_request_sfx.play if @sfx
          @enemies.clear
        end
      end
      if id == Gosu::KbP
        if @player.binding_pry >= 1
          @player.binding_pry -= 1
          @player.pry_sfx.play if @sfx
          if @timer.seconds < (@timer.seconds + 3)
            @enemies.each {|e| e.state = :pause}
          else
            @enemies.each {|e| e.state = :attack}
          end
        end
      end

      # Bullets
      case
      when id == Gosu::KbSpace
        if @player.bullet_speed_boost > 0
          @bullets << @player.fire(:left, @player.bullet_speed_boost)
        else
          @bullets << @player.fire(:left)
        end
      end
    end
    # Menu

    if @state == :lose
      if id == Gosu::KbR
        reset(:menu)
      end
    end

  end

  def button_up(id)
    if id == Gosu::KbUp
      @player.move_up = false
    end
    if id == Gosu::KbDown
      @player.move_down = false
    end
    if id == Gosu::KbLeft
      @player.move_left = false
    end
    if id == Gosu::KbRight
      @player.move_right = false
    end

  end
end
