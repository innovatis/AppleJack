require 'drb'

class ApplicationController
  KInternetEventClass = KAEGetURL = 'GURL'.unpack('N').first
  KeyDirectObject = '----'.unpack('N').first

  attr_accessor :menu

  def awakeFromNib
    @status_bar = NSStatusBar.systemStatusBar
    @status_item = @status_bar.statusItemWithLength(NSVariableStatusItemLength)
    @status_item.setHighlightMode(true)
    @status_item.setMenu(@menu)

    @app_icon = NSImage.imageNamed('applejack.png')
    @app_alter_icon = NSImage.imageNamed('applejack_a.png')
    @app_working_icon = NSImage.imageNamed('applejack_working.png')
    @app_alter_working_icon = NSImage.imageNamed('applejack_working_a.png')

    @status_item.setImage(@app_icon)
    @status_item.setAlternateImage(@app_alter_icon)
  end

  def drbConnection
    DRbObject.new_with_uri("druby://127.0.0.1:14853")
  end 
  
  def setWorking
    @status_item.setImage(@app_working_icon)
    @status_item.setAlternateImage(@app_alter_working_icon)
  end
  
  def unsetWorking
    @status_item.setImage(@app_icon)
    @status_item.setAlternateImage(@app_alter_icon)
  end 

  def work
    Thread.new { 
      setWorking
      yield
      unsetWorking
    }
  end 
  
  def runSpecs(a)
    work { drbConnection.run_specs }
  end
  alias showPreferencesWindow runSpecs
  
  def runFeatures(a)
    work { drbConnection.run_features }
  end
  alias checkForUpdates runFeatures
  
  def runBoth(a)
    work { drbConnection.run_both }
  end
  alias showAbout runBoth
  
end
