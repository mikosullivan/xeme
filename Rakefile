require 'minitest/test_task'

Minitest::TestTask.create(:test) do |t|
  t.libs << 'test'
  
  # select files that implement MiniTest
  Dir.glob('./test/scripts/**/*.rb').each do |rb|
      lines = File.read(rb).lines
      lines = lines.select{|l| l.match(/\< Minitest\:\:Test/mu)}
      
      if lines.any?
          t.test_globs << rb
      end
  end
end

task :default => :test