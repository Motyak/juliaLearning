var net = require('net');

var modelData = {};
modelData["m"] = 2;
modelData["n"] = 2;
modelData["N"] = 2 * modelData.n + modelData.m;
modelData["c"] = JSON.parse('[[10000,10000,20,10000,10000,10000],[10000,10000,10000,257,10000,10000],[20,10000,10000,312,312,10000],[10000,257,10000,10000,130,140],[10000,10000,312,130,10000,10000],[10000,10000,10000,140,10000,10000]]');
modelData["t"] = JSON.parse('[[1440,1440,2,1440,1440,1440],[1440,1440,1440,31,1440,1440],[2,1440,1440,37,37,1440],[1440,31,1440,1440,16,17],[1440,1440,37,16,1440,1440],[1440,1440,1440,17,1440,1440]]');
modelData["e"] = JSON.parse('[0,0,750,825,0,0]');
modelData["l"] = JSON.parse('[2879,2879,765,840,809,849]');

var client = new net.Socket();
client.connect(8080, '127.0.0.1', function() {
	console.log('Connected');
	client.write(JSON.stringify(modelData)+'\n');
});

client.on('data', function(data) {
	console.log('Received: ' + data);
	client.destroy(); // kill client after server's response
});

client.on('close', function() {
	console.log('Connection closed');
});