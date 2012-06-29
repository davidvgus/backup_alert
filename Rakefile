require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['tests/*.rb']
  t.verbose = true
end

#rake create_sample_files[sample]
task :create_sample_files, :test_dir do |t, arg|
  #File.open(File.join('sample_file_info.txt'), r)
  x = File.open('sample_file_info.txt', 'r'){|f| f.readlines}
  sample_dir_name = arg[:test_dir]
  Dir.mkdir(sample_dir_name)
  x.each do |line|
    /^name:\s+(?<name>\w+\.\w{3})\s\| mtime: (?<mtime>\d+) size:\s+(?<size>\d+)$/ =~ line
    File.open(File.join(sample_dir_name, $~[:name]), 'w') do |f|
      f.write("a" * $~[:size].to_i)
    end
    FileUtils.touch File.join(sample_dir_name, $~[:name]), {:mtime => $~[:mtime].to_i}
  end

end

