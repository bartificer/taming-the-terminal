/**
 * Custom rules for turning PBS html pages into markdown
 *
 * NOTE: matching on html tags should be done in uppercase
 * regardless of the case in the original html file.
 * Otherwise the match will not be successful.
 */

/**
 * fixCodeBlock
 *
 * fix the code blocks
 *
 * assume they are all crayon formatted and
 * the <textarea> is already converted to <pre><code>
 */

const fixCodeBlock = {
  filter: function (node) {
    return node.className.match('crayon-syntax');
  },
  replacement: function (content, node, options) {
    // console.log('entering the fixCodeBlock rule');

    // find the language in the <span class="crayon-language">JavaScript</span>
    let language = node.querySelector('.crayon-language') || 'html';

    // get the actual code block
    let cb = node.getElementsByTagName('code');
    let codeBlock = cb.length > 0 ? cb[0].textContent : '';

    return (
      `\n\n${options.fence}${language.textContent}\n` +
      codeBlock +
      `\n${options.fence}\n\n`
    );
  }
};

/**
 * removeCrayonTable
 *
 * remove the table that holds the crayon formatted code
 */
const removeCrayonTable = {
  filter: function (node) {
    return node.nodeName === 'TABLE' && node.className === 'crayon-table';
  },
  replacement: function () {
    return '';
  }
};

/**
 * fixCodeSnippets
 *
 * fix the code snippets that are not crayon formatted
 */
const fixCodeSnippets = {
  filter: function (node) {
    return node.nodeName === 'PRE' && node.className.length > 0;
  },
  replacement: function (content, node, options) {
    if (node.className === 'crayon:false') {
      c = node.textContent;
      return (
        `\n\n${options.fence}\n` + node.textContent + `\n${options.fence}\n\n`
      );
    }
  }
};

/**
 * remove an unwanted div.tags_area
 *
 * no idea why I couldn't remove it in prepareBody,
 * but this works just as well
 */
const removeTagsArea = {
  filter: function (node) {
    return node.nodeName === 'DIV' && node.className === 'tags_area';
  },
  replacement: function () {
    return '';
  }
};

/**
 * Fix the title, i.e. lose the link
 */
const fixTitle = {
  filter: function (node) {
    const matching = node.nodeName === 'H1' && node.firstChild.nodeName === 'A';
    return matching;
  },
  replacement: function (content, node, options) {
    let title = node.firstChild.textContent;
    return `\n\n# ${title}\n\n`;
  }
};

/**
 * fix podcast link
 *
 * Mark up the links to the podcast and such so it resembles the
 * section in pbs89 and onwards
 */
const fixPodcastLink = {
  filter: function (node) {
    const matching = node.nodeName === 'DIV' && node.className === 'podcast';
    return matching;
  },
  replacement: function (content, node, options) {
    // there are two ways the text refers to the CCATP episode
    // one is with a link, one is without a link

    const p = node.getElementsByTagName('P')[0];
    const ccatpLink = p.getElementsByTagName('A');

    let podcastLink = '';
    let episodeNumber = '';
    const re = /^.*Episode #?([0-9]+).*$/;

    if (ccatpLink.length > 0) {
      // there is a link
      const href = ccatpLink[0].getAttribute('href');
      episodeNumber = re.exec(ccatpLink[0].textContent)[1];

      podcastLink = `Listen along to this instalment on [episode ${episodeNumber} of the Chit Chat Across the Pond Podcast](${href})`;
    } else {
      podcastLink = p.textContent;

      episodeNumber = re.exec(podcastLink)[1];
    }

    const audioLink = node
      .getElementsByTagName('AUDIO')[0]
      .getElementsByTagName('A')[0]
      .getAttribute('href');

    const title = `# Matching Postcast Episode ${episodeNumber}`;
    const audioControls = `<audio controls src="${audioLink}">Your browser does not support HTML 5 audio 🙁</audio>`;
    const downloadLink = `You can also <a href="${audioLink}?autoplay=0&loop=0&controls=1" >Download the MP3</a>`;

    return (
      `\n\n${title}\n\n` +
      `${podcastLink}\n\n` +
      `${audioControls}\n\n` +
      `${downloadLink}\n\n`
    );
  }
};

/**
 * Fix the download location of the zip even if we know
 * that the actual zip is not yet on GitHub
 */
const fixZipLink = {
  filter: function (node) {
    const matching =
      node.nodeName === 'A' &&
      node.getAttribute('href') &&
      node.getAttribute('href').match(/\/.*\.zip$/);
    return matching;
  },
  replacement: function (content, node, options) {
    // build the original link, because it looks like content
    // only contains the text of the <a> tag
    const link = node.getAttribute('href');
    const oldLink = `[${node.textContent}](${link})`;

    if (link.match(/\/.*\.zip$/)) {
      // we found the zip
      const re = /\/.*\/(.+?\.zip)$/gm;
      const match = re.exec(link);
      const zipName = match[match.length - 1]; // only the last group

      const newLink = `or [here on GitHub](https://cdn.jsdelivr.net/gh/bbusschots/pbs-resources/instalmentZips/${zipName})`;
      return oldLink + ' ' + newLink;
    } else {
      return oldLink;
    }
  }
};

/**
 * Fix references to other instalments
 */

const fixInstalmentRefs = {
  filter: function (node) {
    const matching =
      node.nodeName === 'A' &&
      node.getAttribute('href') &&
      node
        .getAttribute('href')
        .match(/\/www.bartbusschots.ie.*\/pbs-([0-9]+)-of-x.*$/);
    return matching;
  },
  replacement: function (content, node, options) {
    // build the original link, because it looks like content
    // only contains the text of the <a> tag
    const link = node.getAttribute('href');
    const oldLink = `[${node.textContent}](${link})`;
    const re = /\/www.bartbusschots.ie.*\/pbs-([0-9]+)-of-x.*$/;
    const match = re.exec(link);
    if (match.length > 1) {
      // we found a link to a different instalment

      const newLink = `[${node.textContent}](https://bartificer.net/pbs${
        match[match.length - 1]
      })`;
      return newLink;
    } else {
      return oldLink;
    }
  }
};

/**
 * fixImages
 *
 * fix the reference to the images
 */
const fixImages = {
  filter: function (node) {
    const matching =
      node.nodeName === 'IMG' &&
      node.getAttribute('src') &&
      node.getAttribute('src').match(/.*\/.*.png$/);
    return matching;
  },
  replacement: function (content, node, options) {
    const alt = node.alt || '';
    let src = node.getAttribute('src') || '';
    const title = node.title || '';
    const titlePart = title ? ' "' + title + '"' : '';

    // get the filename part
    const reSrc = /.*\/(.*.png)$/;
    const matchSrc = reSrc.exec(src);

    // get the name of the outputfile
    const reDest = /^.*\/(pbs[0-9]+).md$/;
    const matchDest = reDest.exec(options.output);

    if (matchSrc.length > 1) {
      // we found a link to a local image
      src = `../assets/${matchDest[1]}/${matchSrc[1]}`;
    }

    const img = src ? '![' + alt + ']' + '(' + src + titlePart + ')' : '';

    // console.log('fixImages: ' + img);
    return img;
  }
};

module.exports = [
  {
    name: 'fixCodeBlock',
    rule: fixCodeBlock
  },
  {
    name: 'removeCrayonTable',
    rule: removeCrayonTable
  },
  {
    name: 'fixCodeSnippets',
    rule: fixCodeSnippets
  },
  {
    name: 'removeTagsArea',
    rule: removeTagsArea
  },
  {
    name: 'fixTitle',
    rule: fixTitle
  },
  {
    name: 'fixPodcastLink',
    rule: fixPodcastLink
  },
  {
    name: 'fixZipLink',
    rule: fixZipLink
  },
  {
    name: 'fixInstalmentRefs',
    rule: fixInstalmentRefs
  },
  {
    name: 'fixImages',
    rule: fixImages
  }
];
