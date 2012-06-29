#example.rb

require_relative 'backup_checker'





email_config = File.join(Dir.home, "authinfo.txt")

b = BackupChecker.new()

report = b.report

puts report

if b.alert?
  mailer = EmailAlerter.new()
  #mailer.send_report(email_config, report)
  mailer.send_report(email_config, report)
end

