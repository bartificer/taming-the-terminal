// Post process the html file

const fs = require('fs');
const path = require('path');

const input = process.argv[2];
const output = process.argv[3];

if (!input || !output) {
  console.error("Usage: node postprocess-html.js <input-file> <output-file>");
  process.exit(1);
}

const html = fs.readFileSync(input, "utf8");

// Replace all <audio> tags, but only if preload is missing
const modified = html.replace(
  /<audio(?![^>]*\bpreload=)/g,
  '<audio preload="metadata"'
);

fs.writeFileSync(output, modified);

console.log(`Post-processed HTML written to: ${output}`);
