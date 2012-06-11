#backup_checker.rb


class BackupFile
  attr_accessor :name, :size, :ftype

  def initialize(filename, size, ftype)
    @name = filename
    @size = size
    @ftype = ftype
  end
end

class BackupSet

  attr_accessor :complete, :files, :size, :creation_date

  def initialize(backup_set, backup_dir, minsize)
    @set_number = backup_set
    @backup_dir = backup_dir
    @files = []
    @creation_date = 0
    @complete = false
    @min_size = minsize
    @size = 0
    @ftypes = {"K" => false, "R" => false}
  end

  def add_file(filename, size, ftype)
    case ftype
      when "K"
        @ftypes[ftype] = true
      when "R"
        @ftypes[ftype] = true
      else
    end

    @files << BackupFile.new(filename, size, ftype)
    @size += size
    @creation_date = File.ctime(File.join(@backup_dir, filename)).to_i if ftype == "R"
  end

  def is_complete?
    # A set is complete if it has at least one:
    #*.4BK
    #*.4BR
    #and is of the minimum kilobyte size
    @complete = @ftypes["K"] && @ftypes["R"] && min_size_reached? ? true : false
  end

  def min_size_reached?
    @size >= @min_size ? true : false
  end

end

class BackupSetCatalog

  attr_accessor :catalog

  def initialize(backup_dir = 'sample', min_size)
    @catalog = create_catalog(backup_dir, min_size)
  end

  def create_catalog(backup_dir, min_size)
    backup_sets = {}

    Dir.entries(backup_dir).each do |file|

      pattern = /(?<set_number>\d{3})(-\d)?\.4B(?<backup_file_type>[RSK])$/

      pattern =~ file


      if $~

        set_number = $~[:set_number]
        file_size = File.size(File.join(backup_dir, file))
        file_type = $~[:backup_file_type]

        if backup_sets.has_key?(set_number)
          backup_sets[set_number].add_file(file, file_size, file_type)
        else
          backup_sets[set_number] = BackupSet.new(set_number, backup_dir, min_size)
          backup_sets[set_number].add_file(file, file_size, file_type)
        end
      end
    end
    backup_sets
  end

  def list_set_names
    @catalog.keys
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

  def load_sets
    #
  end

  def log_write
    #
  end

end