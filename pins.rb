
$pincount = 0
$pins = []

def pin_is_on? id
  `cat /sys/class/gpio/gpio#{$pins[id][:gpio]}/value`.to_i == 1
end

def pin_set_on id
  puts `echo 1 > /sys/class/gpio/gpio#{$pins[id][:gpio]}/value`
  true
end

def pin_set_off id
  puts `echo 0 > /sys/class/gpio/gpio#{$pins[id][:gpio]}/value`
  true
end

def pins_init
  pinlist = $config[:pins]

  pinlist.each do |pin|
      puts "Init pin_#$pincount: #{pin.inspect}"
      puts `echo #{pin[:gpio]}  > /sys/class/gpio/export`
      puts `echo out > /sys/class/gpio/gpio#{pin[:gpio]}/direction`
      if pin[:active_low]
        puts `echo 1 > /sys/class/gpio/gpio#{pin[:gpio]}/active_low`
      end
      puts `echo 0 > /sys/class/gpio/gpio#{pin[:gpio]}/value`
      $pincount += 1
      $pins << pin
  end
end
