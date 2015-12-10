var cmd = "/usr/local/bin/python"

var args = ['/Users/jeroen/Sites/vpro/hackathon/PythonAPI.py']

var spawn = require('child_process').spawn;
var child = spawn('./start.sh');

child.stdout.on('data', function(data) {
    console.log('stdout: ' + data);
    //Here is where the output goes
});
child.stderr.on('data', function(data) {
    console.log('stdout: ' + data);
    //Here is where the error output goes
});
child.on('close', function(code) {
    console.log('closing code: ' + code);
    //Here you can get the exit code of the script
});