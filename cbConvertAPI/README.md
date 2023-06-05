# cbContentAPI
A CF Wrapper for the API for convertAPI.com

## Background
THis was created to solve the specific problem of converting heic image so the image conversion area is about 80% developed. As of 9/30/22 there is no build out for the other conversion apis. 
However, it is set up so that it can be expanded. PRs welcome.
## Installation
```box install cbConvertAPI```

## Usage
In Coldbox, use ```property name="imageConverter" inject="imageConverter@cbConvertAPI";```

You will need to set 3 settings
CONVERTAPI_API_KEY - get from convertapi.com
CONVERTAPI_API_SECRET - get from convertapi.com
CONVERTAPI_IMAGE_OUTPUT_PATH - to where you want the resultant file written

To convert ```var filesWritten = imageConvert(sourceFilename, targetFileName); ``` will return an array of the files written. Even though this will only convert 1 file at a time, an array is still returned.

Other parameters can include items on the API documentation at https://www.convertapi.com/image-api


Changelog
0.0.1 - changed documentation to correct slug and cleaned out bad property attribute; added the outputPath argument to
    run command to override the default value in CONVERTAPI_IMAGE_OUTPUT_PATH




