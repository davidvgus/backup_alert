#example.rb

require_relative 'backup_checker'
require 'inifile'







b = BackupChecker.new()
mailer = EmailAlerter.new()

#email_config = File.join(Dir.home, "authinfo.txt")

puts "\n"
puts ini_contents = IniFile.new('backup_checker.ini').to_h['global']['email_config_file']
puts "\n"
email_config = IniFile.new('backup_checker.ini').to_h['global']['email_config_file']

if b.set_manager.empty?
  report = "The Backup Directory (#{File.absolute_path(b.backup_dir)}) is empty of valid backup files."
  puts report


  mailer.send_report(email_config, report)
else
  report = b.report
  puts "\n"
  puts "-" * 40

  puts report

  puts "-" * 40
  print "\n"

  if b.alert?
    mailer.send_report(email_config, report)
  end
end



