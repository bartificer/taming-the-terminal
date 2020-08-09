#!/usr/bin/env node

const path = require('path');
const fs = require('fs-extra');

// load the series metadata
const metadataPath = path.join(__dirname, '..', 'docs', 'series.json');
const series = fs.readJsonSync(metadataPath);

// build the redirects
const FILENAME = 'ttt-redirects.conf';
const RULE_TEMPLATE = 'location = {{{original.path}}} { return 302 {{{resting.url}}}; }';