require 'json'
require 'pty'
require 'faye/websocket'

Faye::WebSocket.load_adapter('thin')

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

ws = nil

App = lambda do |env|

  ws = Faye::WebSocket.new(env)

  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
  end

  begin
    PTY.spawn(cmd) do |stdout, stdin, pid|
      begin

        stdout.each do |line|
          ws.send process_line(line).to_s
          # Return async Rack response
          ws.rack_response
          
          print process_line(line).to_s
          print "\n"
        end

      rescue Errno::EIO
      end
    end
  rescue PTY::ChildExited
    puts "The child process exited!"
  end



end

