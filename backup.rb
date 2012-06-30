#example.rb

require_relative 'backup_checker'





email_config = File.join(Dir.home, "authinfo.txt")

b = BackupChecker.new()

if b.catalog.empty?
  report = "The Backup Directory (#{File.absolute_path(b.backup_dir)}) is empty of valid backup files."
  puts report

  mailer = EmailAlerter.new()
  mailer.send_report(email_config, report)
else
  report = b.report
  puts report

  if b.alert?
    mailer = EmailAlerter.new()
    mailer.send_report(email_config, report)
  end
end



