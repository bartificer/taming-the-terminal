const http = require('https');
const fs = require('fs');

// const path = require('path');

// module.exports = {
//   getCurrentDirectoryBase: () => {
//     return path.basename(process.cwd());
//   },

//   directoryExists: (filePath) => {
//     return fs.existsSync(filePath);
//   }
// };

/**
 * getAssetDir
 *
 * @param {string} outputfile - path + name of output file
 * @returns path to asset directory
 */
function getAssetDir(outputfile) {
  // convert the outputfile tot asset directory:
  // /path/to/file.md --> /path/to/assets/file/

  const re = /^(.*)\/(.*)\.md$/;
  const match = re.exec(outputfile);
  const assetdir = `${match[1]}/assets/${match[2]}`;

  // create the asset directory and all missing directories in between
  if (!fs.existsSync(assetdir)) {
    fs.mkdirSync(assetdir, { recursive: true });
  }
  return assetdir;
}

/**
 * downloadImages
 *
 * Download all images in the page
 *
 * @param {*} dom
 * @param {string} imagedir - location where to save the images
 */
function downloadImages(dom, outputfile) {
  const imagedir = getAssetDir(outputfile);

  const images = dom.getElementsByTagName('img');
  const reFile = /.*\/(.*\..*)$/;

  for (const image of images) {
    const srcLink = image.getAttribute('src');
    const match = reFile.exec(srcLink);
    const fileName = match[match.length - 1];
    const destFile = `${imagedir}/${fileName}`;

    const file = fs.createWriteStream(destFile);
    const request = http.get(srcLink, function (response) {
      response.pipe(file);
    });
  }
}

module.exports = downloadImages;
