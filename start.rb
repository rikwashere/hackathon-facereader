require 'json'
require 'pty'

cmd = "/usr/local/bin/python /Users/jeroen/Sites/vpro/hackathon/PythonAPI.py"

def process_line(line)
  obj = nil
  values = []
  
  begin
    obj = JSON.parse(line.sub('INFO:root:',''))
    values = obj["Classification"]["ClassificationValues"]["ClassificationValue"]
    arousal = (values.detect {|v| v["Label"] == "Arousal"}["Value"]["float"]).to_f
  rescue Exception => e
      
  end
  
  {
    arousal: arousal,
    values: values
  }
end

begin
  PTY.spawn(cmd) do |stdout, stdin, pid|
    begin

      stdout.each do |line|
        print process_line(line).to_s
        print "\n"
      end

    rescue Errno::EIO
    end
  end
rescue PTY::ChildExited
  puts "The child process exited!"
end

