#!/usr/bin/env node
'use strict';

// parse arguments
var argv = require('minimist')(process.argv.slice(2));
if (argv._.indexOf('build') > -1) {    
    require('./src/builder.js')
}