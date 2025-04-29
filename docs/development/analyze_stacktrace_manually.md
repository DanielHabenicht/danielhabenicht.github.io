# Analyze stack traces manually

No automated tool like sentry? 
You can convert minified stacktraces to original lines like this: 

```bash
npm install source-map
```

```js name=source-file-track.js
fs = require('fs');
var sourceMap = require('source-map');
const consumer = new sourceMap.SourceMapConsumer(
  fs.readFileSync('./frontend/dist/assets/index-DNGrc4uI.js.map', 'utf8')
);
var trace = `    at https://website.net/assets/index-DcBJRmgk.js:139:6172
    at https://website.net/assets/index-DcBJRmgk.js:67:20466
    at https://website.net/assets/index-DcBJRmgk.js:67:20082
    at lr (https://website.net/assets/index-DcBJRmgk.js:40:43163)
    at lr (https://website.net/assets/index-DcBJRmgk.js:40:43163)
    at https://website.net/assets/index-DcBJRmgk.js:67:20466
    at https://website.net/assets/index-DcBJRmgk.js:67:20082
    at https://website.net/assets/index-DcBJRmgk.js:67:21487
    at https://website.net/assets/index-DcBJRmgk.js:136:5836
    at SelectPortal
    at lr (https://website.net/assets/index-DcBJRmgk.js:40:43163)
    at c (https://website.net/assets/index-DcBJRmgk.js:136:873)
    at c (https://website.net/assets/index-DcBJRmgk.js:121:68667)
    at o (https://website.net/assets/index-DcBJRmgk.js:121:69679)
    at c (https://website.net/assets/index-DcBJRmgk.js:136:873)
    at c (https://website.net/assets/index-DcBJRmgk.js:121:33151)
    at tle (https://website.net/assets/index-DcBJRmgk.js:121:34557)
    at ide (https://website.net/assets/index-DcBJRmgk.js:139:3099)
    at hU (https://website.net/assets/index-DcBJRmgk.js:139:21018)
    at div
    at lr (https://website.net/assets/index-DcBJRmgk.js:40:43163)
    at div
    at nav
    at div
    at fZe (https://website.net/assets/index-DcBJRmgk.js:276:380)
    at BZe (https://website.net/assets/index-DcBJRmgk.js:276:13681)
    at lr (https://website.net/assets/index-DcBJRmgk.js:40:43163)
    at TRt (https://website.net/assets/index-DcBJRmgk.js:466:74)
    at xCe (https://website.net/assets/index-DcBJRmgk.js:58:7337)
    at LCe (https://website.net/assets/index-DcBJRmgk.js:67:748)
    at div
    at lr (https://website.net/assets/index-DcBJRmgk.js:40:43163)
    at https://website.net/assets/index-DcBJRmgk.js:121:49753
    at ORe (https://website.net/assets/index-DcBJRmgk.js:121:48209)
    at c (https://website.net/assets/index-DcBJRmgk.js:121:6483)
    at ule (https://website.net/assets/index-DcBJRmgk.js:121:40926)
    at lr (https://website.net/assets/index-DcBJRmgk.js:40:43163)
    at GTe (https://website.net/assets/index-DcBJRmgk.js:67:16633)
    at lr (https://website.net/assets/index-DcBJRmgk.js:40:43163)
    at lr (https://website.net/assets/index-DcBJRmgk.js:40:43163)
    at e (https://website.net/assets/index-DcBJRmgk.js:466:4944)
    at $9e (https://website.net/assets/index-DcBJRmgk.js:165:2897)
    at RQe (https://website.net/assets/index-DcBJRmgk.js:247:18768)
    at fQe (https://website.net/assets/index-DcBJRmgk.js:247:10228)
    at GZe (https://website.net/assets/index-DcBJRmgk.js:276:17967)`;

const lines = trace.split('\n');
const regex = /at (.+):(\d+):(\d+)/;
positions = [];
lines.forEach((line) => {
  const match = line.match(regex);
  if (match) {
    const url = match[1];
    const lineNumber = parseInt(match[2], 10);
    const columnNumber = parseInt(match[3], 10);
    positions.push({ url, line: lineNumber, column: columnNumber });
  }
});

consumer.then((c) => {
  positions.forEach((pos) => {
    console.log(
      c.originalPositionFor({
        line: pos.line,
        column: pos.column,
      })
    );
  });
});

```
