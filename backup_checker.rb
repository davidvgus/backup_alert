
class BackupSet

  def initialize(size)
    @size = size
    @set_date = ''
    @set = []
  end

  def self.create_set(file_names)
    backup_sets = {}
    
  end

  def is_complete?
    # A set is complete if it has at least one:
    #*.4BK
    #*.4BR
    #and is of the minimum kilobyte size
  end
end

class BackupChecker
  #load parameters from ini file
  require 'inifile'
  require 'date'

  attr_reader :ini_contents

  def initialize()
    @ini_contents = IniFile.new('backup_checker.ini').to_h['global']
    @minimum_size_in_k = 1
    @backup_dir = @ini_contents['backup_directory']
    @working_directory = Dir.new(".")
    @current_time = Time.now
    @alert_message = ""
    @dir_entries = ''
    @log_file = 'log.txt'
  end

  def alert?
    #
  end

  def check
    #log
  end

  def do_alert
    #Log what you did for the alert
  end

  def get_dir_entries

  end

  def initialize_set
    #
  end

  def log_write
    #
  end

end