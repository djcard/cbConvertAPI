# cbContentAPI
A CF Wrapper for the API for convertAPI.com

## Background
THis was created to solve the specific problem of converting heic image so the image conversion area is about 80% developed. As of 9/30/22 there is no build out for the other conversion apis. 
However, it is set up so that it can be expanded. PRs welcome.
## Installation
```box install cbConvertAPI```

## Usage
In Coldbox, use ```property name="imageConverter" inject="imageConverter@convertAPI";```

To convert ```var filesWritten = imageConvert(sourceFilename, targetFileName); ``` will return an array of the files written. Even though this will only convert 1 file at a time, an array is still returned.

Other parameters can include items on the API documentation at https://www.convertapi.com/image-api




