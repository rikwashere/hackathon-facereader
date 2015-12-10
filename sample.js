var exec = require('child_process').exec;
var proc = exec('/usr/local/bin/python /Users/jeroen/Sites/vpro/hackathon/PythonAPI.py');

proc.stdout.on('data', function(data) {
    console.log(" sas" , data); 
});