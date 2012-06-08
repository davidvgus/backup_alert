




class BackupChecker
  #load parameters from ini file
  require 'inifile'
  require 'date'

  attr_reader :ini_contents

  def initialize()
    @ini_contents = IniFile.new('backup_checker.ini').to_h['global']
    @backup_dir = @ini_contents['backup_directory']
    @working_directory = Dir.new(".")
    @current_time = Time.now
    @alert_message = ""
    @dir_entries = ''
  end



  def alert?

  end

  def do_alert
    #Log what you did for the alert
  end

  def check
    #get entries for backup dir
    #Check to see that there is at least one entry from previous day
    #alert if there is no entry from previous day
    #log
  end

  def get_dir_entries
    
  end

  def log_write
    #
  end

end