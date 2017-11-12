const alfyTest = require('alfy-test');

const alfy = alfyTest();

alfy('Rainbow').then(result => {
	console.log(result);
});

