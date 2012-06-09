
#backup_checker.rb

class BackupSet

  attr_accessor :complete, :files, :creation_date

  def initialize()
    @files = []
    @creation_date = ""
    @complete = false
  end

  def add_file(filename)
    @files << filename
  end

  def add_file_size
    #
  end

  def get_creation_date
    #get the creation date for the .4DR file
  end

end

class BackupSetCatalog

  def initialize(config_file)
    @set_date = ''
    @sets = create_sets(backup_dir)
  end

  def create_catalog(file_names)
    backup_sets = {}

    file_names.each do |file|

      pattern = /(?<set_number>\d{3})(-\d)?\.4B(?<backup_file_type>[RSK])$/

      #If the file is a backup set file
      if $~

        if defined? backup_sets[$~[:set_number]]
          backup_sets[$~[:set_number]].add_file(file)
        else
          backup_sets[$~[:set_number]] = BackupSet.new()
        end
      end
    end
  end

  def set_exists?(set_number)

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
    @catalog = BackupSetCatalog.new(@backup_dir)
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