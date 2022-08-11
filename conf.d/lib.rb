##
# Color code define for BASH
##
class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end
end

###
# Detect which OS vagrant is running on.
###
module OS
  def OS.windows?
    Vagrant::Util::Platform.windows?
  end

  def OS.mac?
    Vagrant::Util::Platform.darwin?
  end

  def OS.linux?
    Vagrant::Util::Platform.linux?
  end
end

load "#{VDIR}/conf.d/nodescfg.rb"