#backup_checker.rb


class BackupFile
  attr_accessor :name, :size, :ftype

  def initialize(filename, size, ftype)
    @name = filename
    @size = size
    @ftype = ftype
  end

  def to_s
    @name
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
    @creation_date = File.mtime(File.join(@backup_dir, filename)).to_i if ftype == "R"
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

  def info(files_column_width, size_column_width)
    list_of_names = []
    @files.each {|f| list_of_names << "#{f.name}" }
    #"666, test_file.txt, test_file2.txt, C, 100"
    status = is_complete? ? 'Complete' : 'Incomplete'
    date =  Time.at(@creation_date)
    elapsed_time = (Time.now - date).to_i / (60 * 60)
    size = (@size/(1024 * 1024)).to_s + "MB"
    size = "<1MB" if size == "0MB"
    "\nSet:%s  Files:  % -#{files_column_width }s \n\t Status: % -10s  \n\t Size:   % -#{size_column_width}s\n\t Date:   %s\n\t Age in Hours: %s" %
        [@set_number, list_of_names.join(', '), status, size, date, elapsed_time]
  end

end

class BackupSetCatalog

  attr_accessor :catalog

  def initialize(backup_dir = 'sample', min_size)
    @catalog = create_catalog(backup_dir, min_size)
  end

  def create_catalog(backup_dir, min_size)
    backup_sets = {}

    unless File.directory?(backup_dir)
      email_config = File.join(Dir.home, "authinfo.txt")
      report = "The Backup Directory (#{File.absolute_path(backup_dir)}) Does not exist."
      puts report

      mailer = EmailAlerter.new()
      mailer.send_report(email_config, report)
      exit()
    end

    Dir.entries(backup_dir).each do |file|

      /(?<set_number>\d{3})(-\d)?\.4B(?<backup_file_type>[RSK])$/ =~ file

      if $~
        #puts "%s %d" % [$~[:backup_file_type], $~[:set_number]]
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

  def get_ordered_set_keys
    inverse_hash = @catalog.inject({}) { |h, (k, v)| h[v.creation_date] = k; h }.reject {|k,v| k == 0}
    inverse_hash.values
  end

  def get_last_set
    inverse_hash = @catalog.inject({}) { |h, (k, v)| h[v.creation_date] = k; h }.reject {|k,v| k == 0}
    inverse_hash[inverse_hash.keys.sort.last]
  end

  def last_backup_complete?
    #turn this into an if statement so that you do something useful if there is no catalog
    @catalog[get_last_set].is_complete? if @catalog
  end

  def time_since_last_backup(test_time = nil)

    if test_time == nil
      #test_time not used except in a testing.
      Time.now.to_i - @catalog[get_last_set].creation_date
    else
      #test_time used when testing.
      test_time - @catalog[get_last_set].creation_date
    end

  end

  def hours_since_last_complete_backup(test_time = nil)
    #test_time used for testing
    time_since_last_backup(test_time) / (60 * 60)
  end

  def empty?
    @catalog.empty?
  end


end

class BackupChecker
  #load parameters from ini file
  require 'inifile'
  require 'date'


  attr_reader :ini_contents, :current_time, :catalog, :backup_dir

  def initialize(current_time = nil)
    @ini_contents = IniFile.new('backup_checker.ini').to_h['global']


    @files_column_width = @ini_contents['files_column_width'].to_i
    @size_column_width = @ini_contents['size_column_width'].to_i

    @current_time = current_time || Time.now
    @one_day = 24 * 60 * 60

    @alert_message = @ini_contents['alert_message']

    @working_directory = Dir.new(".")
    @log_file_full_path = File.join(Dir.new("."), @ini_contents['log_file_name'])

    @minimum_size_in_k = @ini_contents['min_size'].to_i
    @backup_dir = @ini_contents['backup_directory']
    @catalog = BackupSetCatalog.new(@backup_dir, @minimum_size_in_k)
  end

  def alert?(test_time = nil)

    if test_time
      !@catalog.last_backup_complete? || @catalog.hours_since_last_complete_backup(test_time) > 24
      #!@catalog.last_backup_complete? || @catalog.hours_since_last_complete_backup > 24
      #@catalog.hours_since_last_complete_backup(1339415518) < 24
    else
      !@catalog.last_backup_complete? || @catalog.hours_since_last_complete_backup > 24
      #@catalog.hours_since_last_complete_backup < 24
    end
  end

  def backup_dir_exists?
    File.directory?(@backup_dir)
  end

  def complete?
    @catalog.last_backup_complete?
  end

  def report
    report_string = ""
    @catalog.get_ordered_set_keys.each do |key|
      report_string << @catalog.catalog[key].info(@files_column_width, @size_column_width)
    end
    report_string
  end

end

#class Gmailer
#  require 'tlsmail'
#  require 'time'
#  require 'parseconfig'
#
#
#  def send_report(email_config, message)
#    email_config = ParseConfig.new(email_config).params
#    from = email_config['from_address']
#    to = email_config['to_address']
#    p = email_config['p']
#    content = <<EOF
#From: #{from}
#To: #{to}
#subject: Backup Alert
#Date: #{Time.now.rfc2822}
#
#    #{message}
#EOF
#    print 'content', content
#
#    Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
#    Net::SMTP.start('smtp.gmail.com', 587, 'gmail.com', from, p, :login) do |smtp|
#      smtp.send_message(content, from, to)
#    end
#  end
#end


class EmailAlerter
  require 'net/smtp'
  require 'time'
  require 'parseconfig'


  def send_report(email_config, report)
    email_config = ParseConfig.new(email_config).params
    from = email_config['from_address']
    to = email_config['to_address']
    server = email_config['server']
    message = <<MESSAGE_END
From: Site of Care Backup_Checker <#{from}>
To: IT<#{to}>
Subject:  SoC Backup Needs Attention
Date: #{Time.now.rfc2822}

Begin Report:
MESSAGE_END

    message << report

    Net::SMTP.start(server) do |smtp|
      smtp.send_message message, from,
                        to
    end
  end
end




