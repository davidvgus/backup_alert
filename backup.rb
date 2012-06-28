#example.rb

require_relative 'backup_checker'

b = BackupChecker.new()

b.report

if b.alert?
  b.do_alert
end
