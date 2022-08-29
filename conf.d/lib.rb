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
load "#{VDIR}/conf.d/port_forward.rb"