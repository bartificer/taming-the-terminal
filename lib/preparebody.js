const jsdom = require('jsdom');
const { JSDOM } = jsdom;

module.exports = function (contents) {
  /*
   * do the filtering and manipulation of the original DOM here,
   * so we only use the part of the page that's relevant
   */
  const { window } = new JSDOM(contents);
  const dom = window.document;

  convertCodeblocks(dom);

  // extract the title so we know what we're working on
  const title = dom.querySelector('.contenttitle h1 a').innerHTML;
  console.log('Title: ' + title);

  // the actual content is in div#contentbody
  // but we want the title too, so we're using it's parent
  // and then strip away everything that is not in
  // .contenttitle or .contentbody

  let body = dom.querySelector('#contentmiddle');

  // just to be sure, let's first get the children to be removed
  // and iterate over the resulting array to actually remove them
  // to avoid skipping children because we mess up the iterator

  let prune = [];

  for (const child of body.children) {
    if (
      child.className !== 'contenttitle' &&
      child.className !== 'contentbody'
    ) {
      prune.push(child);
    }
  }

  // now do the actual removal
  for (const child of prune) {
    body.removeChild(child);
  }

  // fix the title, we only want the h1
  let notUsed = dom.querySelector('.contenttitle p');
  notUsed.parentNode.removeChild(notUsed);

  // remove the seriesbox, they are not there
  // in the new markdown pages, so we don't need them here
  notUsed = body.querySelector('.seriesbox');
  notUsed.parentNode.removeChild(notUsed);

  return body;
};

/**
 * let's try to convert a <textarea class='crayon-plain'> to a <pre>
 * so the gfm code recognizes it and preserves the whitespace
 *
 * If we don't do this, the new lines and indents are lost
 *
 * @param {JSDOM} dom
 */
function convertCodeblocks(dom) {
  let textAreas = dom.getElementsByTagName('textarea');

  // iterate over the textareas and add the content
  // to <pre><code> so turndown doesn't strip out the
  // whitespace
  for (let i = 0; i < textAreas.length; i++) {
    const ta = textAreas[i];
    let parentNode = ta.parentNode;

    let pre = dom.createElement('pre');
    let code = dom.createElement('code');
    code.innerHTML = ta.innerHTML;
    pre.appendChild(code);
    parentNode.appendChild(pre);
  }

  // remove the textareas AFTER the PRE is added, otherwise
  // we're skipping textareas.
  for (let i = 0; i < textAreas.length; i++) {
    const ta = textAreas[i];
    let parentNode = ta.parentNode;
    parentNode.removeChild(ta);
  }
}
