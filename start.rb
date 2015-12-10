require 'json'
require 'pty'

cmd = "/usr/local/bin/python /Users/jeroen/Sites/vpro/hackathon/PythonAPI.py"

def process_line(line)
  obj = nil
  result = ""
  
  begin
    obj = JSON.parse(line.sub('INFO:root:',''))
    result = obj["Classification"]["ClassificationValues"].to_s
  rescue Exception => e
      
  end
    
  result
end

begin
  PTY.spawn(cmd) do |stdout, stdin, pid|
    begin

      stdout.each do |line|
        print process_line(line)
        print "\n"
      end

    rescue Errno::EIO
    end
  end
rescue PTY::ChildExited
  puts "The child process exited!"
end

