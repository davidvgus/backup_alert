#example.rb
require 'tlsmail'
require 'time'
require 'parseconfig'
require_relative 'backup_checker'




email_config = File.join(Dir.home, ".authinfo.txt")

def send_report(email_config, message)
  email_config = ParseConfig.new(email_config).params
  from = email_config['from_address']
  to = email_config['to_address']
  p = email_config['p']
  content = <<EOF
From: #{from}
To: #{to}
subject: Backup Alert
Date: #{Time.now.rfc2822}

#{message}
EOF
  print 'content', content

  Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
  Net::SMTP.start('smtp.gmail.com', 587, 'gmail.com', from, p, :login) do |smtp|
    smtp.send_message(content, from, to)
  end
end







b = BackupChecker.new()

report = b.report

puts report

if b.alert?
  send_report(email_config, report)
end

