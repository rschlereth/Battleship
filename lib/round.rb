class Round

  def start
    puts "Welcome to BATTLESHIP \nEnter p to play. Enter q to quit."
    start_button = gets
    if start_button = "q"
      puts "Until next time!"
    end
  end
end
