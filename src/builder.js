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
console.log(`Start to build code inside docker`);

localExecCmd('docker', ['run', '-i', '-v', workingdir + ':/source', dockerImageName, '/build.sh'])

function usage() {
    console.log([
        'Usage: builder <options>',
        '',
        '--device device name',
        '--cmakefile cmakeLists.txt full path',
        '--workingdir workingdir',
    ].join('\r\n'));
}

function localExecCmd(cmd, args, cb) {
    try {
        console.log(`command is ${cmd}, arguments are ${args}`);
        var cp = require('child_process').spawn(cmd, args);

        var result = '';
        cp.stdout.on('data', function (data) {
            console.log(String(data));
            result += String(data);
        });

        cp.stderr.on('data', function (data) {
            console.log(String(data));
            result += String(data);
        });

        cp.on('close', function (code) {
            if (cb) {
                return cb(result);
            }
        });
    } catch (e) {
        e.stack = "ERROR: " + e;
        if (cb) cb(e);
    }
}
