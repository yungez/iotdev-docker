#!/usr/bin/env node
'use strict';

/* builder to build user src */
var spawnSync = require('child_process').spawnSync;
const config = require('./config.json');
const fs = require('fs-extra');
const path = require('path');

// parse arguments
var argv = require('minimist')(process.argv.slice(2));
if (argv['device']) {    
    var device = argv['device'];    
} else {
    usage()
}

if (argv['workingdir']) {
    var workingdir = argv['workingdir']
} else {
    usage()
}

var cmakefile = "";
if (argv['cmakefile']) {
    let cmakefile = argv['cmakefile']
}

// get docker image name based on device
var dockerImageName = config[`${device}`];

if ( dockerImageName === 'undefined') {
    console.log(`there's no configure for device ${device} in config.json`);
    return 1;
}
var dockerVersion = spawnSync('docker', ['-v']);

if (String(dockerVersion.stdout).indexOf('Docker version') == -1) {
    console.log("Docker hasn't been installed yet");
} else {
    console.log(`docker version: ${String(dockerVersion.stdout)}`);
}


// run cmake inside docker container
var execSync = require('child_process').execSync;
console.log(`start to build application inside docker`);
var dockercommand = `docker run -t -d -i -v "${workingdir}":/source ${dockerImageName} /build.sh`;
var containerid = execSync(dockercommand);
console.log(`containerid is ${containerid}`);
var output = fs.readFileSync(path.join(workingdir, 'build.log'));
console.log('build output');
console.log('-------------------------------------------------');
console.log(String(output));

function usage() {
    console.log([
        'Usage: builder <options>',
        '',
        '--device device name',
        '--cmakefile cmakeLists.txt full path',
        '--workingdir workingdir',
    ].join('\r\n'));
}