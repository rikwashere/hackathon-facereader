require 'json'
require 'pty'
require 'eventmachine'
require 'websocket-eventmachine-server'

# require 'faye/websocket'

# Faye::WebSocket.load_adapter('thin')

cmd = "/usr/local/bin/python /Users/jeroen/Sites/vpro/hackathon/PythonAPI.py"

def process_line(line)
  obj = nil
  values = []
  
  begin
    obj = JSON.parse(line.sub('INFO:root:',''))
    values = obj["Classification"]["ClassificationValues"]["ClassificationValue"]
    arousal = (values.detect {|v| v["Label"] == "Arousal"}["Value"]["float"]).to_f
  rescue Exception => e
    # 
  end
  
  {
    arousal: arousal,
    values: values
  }
end

as = nil

PTY.spawn(cmd) do |stdout, stdin, pid|
  begin

    stdout.each do |line|
      as.send process_line(line).to_s
      puts "Send a line"
    end

  rescue Errno::EIO
  end
end


EM.run do

  WebSocket::EventMachine::Server.start(:host => "0.0.0.0", :port => 9292) do |ws|
    ws.onopen do
      puts "Client connected"
    end

    ws.onmessage do |msg, type|
      puts "Received message: #{msg}"
      ws.send msg, :type => type
    end

    ws.onclose do
      puts "Client disconnected"
    end
    
  end

end

