#example.rb

require_relative 'backup_checker'





email_config = File.join(Dir.home, "authinfo.txt")

b = BackupChecker.new()

report = b.report

puts report

if b.alert?
  gm = Gmailer.new()
  gm.send_report(email_config, report)
end

