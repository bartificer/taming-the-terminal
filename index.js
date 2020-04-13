const chalk = require('chalk');
const clear = require('clear');
const figlet = require('figlet');
const fs = require('fs');
const TurndownService = require('turndown');
const turndownPluginGfm = require('turndown-plugin-gfm');
const gfm = turndownPluginGfm.gfm;

const program = require('commander');

const downloadImages = require('./lib/files');
const prepareBody = require('./lib/preparebody');
const customRules = require('./lib/customrules');

clear();

console.log(
  chalk.yellow(figlet.textSync('PBS Convert', { horizontalLayout: 'full' }))
);

program
  .version(require('./package.json').version)
  .usage('(<input> | --input <input>) [options]')
  .option('-i, --input <input>', 'string of HTML or HTML file to convert')
  .option('-o, --output <file>', 'output file')
  .option('--bullet-list-marker <marker>', '"-", "+", or "*"')
  .option('--code-block-style <style>', '"indented" or "fenced"')
  .option('--em-delimiter <delimiter>', '"_" or "*"')
  .option('--fence <fence>', '"```" or "~~~"')
  .option('--heading-style <style>', '"setext" or "atx"')
  .option('--hr <hr>', 'any thematic break')
  .option('--link-style <style>', '"inlined" or "referenced"')
  .option(
    '--link-reference-style <style>',
    '"full", "collapsed", or "shortcut"'
  )
  .option('--strong-delimiter <delimiter>', '"**" or "__"')
  .parse(process.argv);

let stdin = '';
if (process.stdin.isTTY) {
  turndown(program.input || program.args[0]);
} else {
  process.stdin.on('readable', function () {
    let chunk = this.read();
    if (chunk !== null) stdin += chunk;
  });
  process.stdin.on('end', function () {
    turndown(stdin);
  });
}

/**
 * Actual conversion function
 *
 * @param {*} string content of the file
 */
function turndown(string) {
  let turndownService = new TurndownService(options(options()), {
    defaultReplacement: function (innerHTML, node) {
      return node.isBlock ? '\n\n' + node.outerHTML + '\n\n' : node.outerHTML;
    }
  });
  // Use GitHub markdown extensions
  turndownService.use(gfm);

  // add the custom rules
  for (const rule of customRules) {
    turndownService.addRule(rule.name, rule.rule);
  }

  if (fs.existsSync(string)) {
    fs.readFile(string, 'utf8', function (error, contents) {
      if (error) throw error;
      const body = prepareBody(contents);

      downloadImages(body, program.output);

      output(turndownService.turndown(body));
    });
  } else {
    output(turndownService.turndown(string));
  }
}

/**
 * output the markdown
 *
 * @param {string} markdown
 */
function output(markdown) {
  if (program.output) {
    fs.writeFile(program.output, markdown, 'utf8', function (error) {
      if (error) throw error;
      console.log(program.output);
    });
  } else {
    console.log(markdown);
  }
}

/**
 * Handle the options of the program
 *
 * returns object with options
 */
function options() {
  let opts = {};
  for (let i = 0; i < program.options.length; i++) {
    let optionName = optionNameFromFlag(program.options[i].long);
    if (program[optionName]) opts[optionName] = program[optionName];
  }
  delete opts.version;
  delete opts.input;
  // delete opts.output;
  opts.headingStyle = 'atx';
  opts.codeBlockStyle = 'fenced';
  return opts;
}

function optionNameFromFlag(flag) {
  return flag.replace(/^--/, '').replace(/-([a-z])/g, function (match, char) {
    return char.toUpperCase();
  });
}
