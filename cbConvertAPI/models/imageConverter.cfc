component accessors="true" extends="baseConverter" {

	property name="imageOutputPath" inject="coldbox:setting:imageOutputPath@cbConvertAPI";

	property name="sourceTypesSupported" type="array";
	property name="destTypesSupported"   type="array";
	property name="async"              default="false";
	property name="timeout"            default="900";
	property name="jobId"              default="";
	property name="webhook"            default="";
	property name="imageResolution"    default="200";
	property name="scaleImage"         default="false";
	property name="scaleProportions"   default="true";
	property name="scalelfLarger"      default="false";
	property name="imageHeight"        default="";
	property name="imageWidth"         default="";
	property name="imageInterpolation" default="false";
	property name="transparentColor"   default="";
	property name="imageQuality"       default="75";
	property name="colorSpace"         default="default";
	property name="colorProfile"       default="default";
	property name="imageQuality"       default="75";
	property name="transparentColor"   default="";
	property name="multipage"          default="true";

	specialSettings = {
		"colorSpace"       : [ "jpg", "pdf", "svg", "webp" ],
		"colorProfile"     : [ "pdf" ],
		"imageQuality"     : [ "jpg", "png", "svg", "webp" ],
		"transparentColor" : [ "png" ],
		"multipage"        : [ "tiff" ]
	};

	setSourceTypesSupported( [
		"bmp",
		"fax",
		"gif",
		"heic",
		"ico",
		"images",
		"jpeg",
		"jpg",
		"mdi",
		"png",
		"psd",
		"svg",
		"tif",
		"tiff",
		"webp"
	] );

	setdestTypesSupported( [
		"jpg",
		"pdf",
		"pdfa",
		"png",
		"svg",
		"tiff",
		"webp"
	] );

	function assignPropertiesFromArguments( args ){
		if ( args.keyExists( "storeFile" ) ) {
			setStoreFile( args.storeFile );
		};
		if ( args.keyExists( "timeout" ) ) {
			setTimeout( args.timeout );
		};
		if ( args.keyExists( "async" ) ) {
			setAsync( args.async );
		};
		if ( args.keyExists( "jobId" ) ) {
			setJobId( args.jobId );
		};
		if ( args.keyExists( "webhook" ) ) {
			setWebhook( args.webhook );
		};
		if ( args.keyExists( "imageResolution" ) ) {
			setImageResolution( args.imageResolution );
		};
		if ( args.keyExists( "scaleImage" ) ) {
			setScaleImage( args.scaleimage );
		};
		if ( args.keyExists( "scaleProportions" ) ) {
			setScaleProportions( args.scaleProportions );
		};
		if ( args.keyExists( "scalelfLarger" ) ) {
			setScalelfLarger( args.scalelfLarger );
		};
		if ( args.keyExists( "imageHeight" ) ) {
			setImageHeight( args.imageHeight );
		};
		if ( args.keyExists( "imageWidth" ) ) {
			setimageWidth( args.imageWidth );
		};
		if ( args.keyExists( "colorSpace" ) ) {
			setColorSpace( args.colorSpace );
		};
		if ( args.keyExists( "imageQuality" ) ) {
			setImageQuality( args.imageQuality );
		};
	}

	function run(
		required string sourceFilePath,
		required string targetFileName,
		boolean storeFile        = false,
		numeric timeOut          = 900,
		boolean async            = false,
		string jobId             = "",
		string webhook           = "",
		numeric imageresolution  = 200,
		boolean ScaleImage       = false,
		boolean scaleProportions = true,
		boolean scalelfLarger    = false,
		numeric imageHeight,
		numeric imageWidth,
		string colorSpace    = "Default",
		numeric imageQuality = 75
	){
		assignPropertiesFromArguments( arguments );
		var binaryFile = obtainFileBinary( arguments.sourceFilePath );

		if ( !isBinary( binaryFile ) ) {
			return "File was not read binary";
		}

		var sourceFileType = sourceFilePath.listLast( "." );
		var targetFileType = targetFileName.listlast( "." );
		if ( !typeFromSupported( sourceFileType ) ) {
			writeDump( "Sorry This file Type is not supported" );
			return;
		}

		if ( !typeToSupported( targetFileType ) ) {
			writeDump( "Sorry this target type is not supported" );
			return;
		}

		var apiURL = createUrl(
			sourceFileType,
			targetFileType,
			arguments.storeFile
		);

		var imageString = fileToBase64( binaryFile );
		var callBody    = createBody( arguments.targetFileName, imageString );

		var results = callAPI( apiURL, callBody );

		if ( results[ "status_code" ] != 200 ) {
			writeDump( "There was an error in the process" );
			writeDump( results );
			return "";
		}
		var responseObj  = deserializeJSON( results.fileContent );
		var filesWritten = writeOutputFiles( responseObj, getimageOutputPath() );
		return filesWritten;
	}



	/***
	 * Creates the URL for the API call
	 *
	 * @sourceFileType The file type for the source file (.heic, jpeg etc)
	 * @targetFileType The file type for the converted file
	 * @storeFile      Whether the file should be stored on the convertAPI server
	 **/
	function createURL( required string sourceFileType, required string targetFileType ){
		var urlString = "#trim( variables.BaseURL )#/#trim( sourceFileType )#/to/#trim( targetFileType )#?secret=#variables.apiSecret#&StoreFile=#trim( getstoreFile() )#&timeout=#getTimeout()#&async=#getAsync()#&";
		urlstring     = getJobId().len() ? urlString & "&jobid=#jobid#" : urlString;
		urlstring     = getWebhook().len() ? urlString & "&webhook=#getWebhook()#" : urlString;
		urlstring     = getImageHeight().len() ? urlString & "&imageHeight=#getImageHeight()#" : urlString;
		urlstring     = getImageWidth().len() ? urlString & "&imageWidth=#getImage#" : urlString;
		urlstring     = isNumeric( getimageresolution() ) ? urlString & "&imageResolution=#getImageResolution()#" : urlString;
		urlstring     = isBoolean( getScaleImage() ) ? urlString & "&scaleImage=#getScaleImage()#" : urlString;
		urlstring     = isBoolean( getScaleProportions() ) ? urlString & "&scaleProportions=#getScaleProportions()#" : urlString;
		urlstring     = isBoolean( getscalelfLarger() ) ? urlString & "&scalelfLarger=#getScalelfLarger()#" : urlString;
		urlstring     = isBoolean( getImageInterpolation() ) ? urlString & "&imageInterpolation=#getImageInterpolation()#" : urlString;

		if ( specialSettings.colorSpace.findNoCase( arguments.targetFileType ) ) {
			urlstring = getColorSpace().len() ? urlString & "&colorSpace=#getcolorspace()#" : urlstring;
		}

		if ( specialSettings.colorProfile.findNoCase( arguments.targetFileType ) ) {
			urlstring = getColorProfile().len() ? urlString & "&colorProfile=#getColorProfile()#" : urlstring;
		}

		if ( specialSettings.imageQuality.findNoCase( arguments.targetFileType ) ) {
			urlstring = isNumeric( getImageQuality() ) ? urlString & "&imageQuality=#getImageQuality()#" : urlstring;
		}

		if ( specialSettings.transparentColor.findNoCase( arguments.targetFileType ) ) {
			urlstring = getTransparentColor().len() ? urlString & "&transparentColor=#getTransparentColor()#" : urlstring;
		}

		if ( specialSettings.multipage.findNoCase( arguments.targetFileType ) ) {
			urlstring = isBoolean( getMultipage() ) ? urlString & "&multipage=#getMultipage()#" : urlstring;
		}

		return urlString;
	}

	function callAPI( required string urlString, required struct body ){
		cfhttp(
			method  = "POST",
			charset = "utf-8",
			url     = urlString,
			result  = "res"
		) {
			cfhttpparam(
				type  = "header",
				name  = "Authentication",
				value = "Basic: #variables.ApiKey# #variables.ApiSecret#"
			);
			cfhttpparam(
				type  = "header",
				name  = "Content-Type",
				value = "application/json"
			);
			cfhttpParam( type = "body", value = serializeJSON( arguments.body ) );
		}
		return res;
	}

	function createBody(
		required string fileName,
		required string imageData,
		storeFile = variables.StoreFile
	){
		return {
			"Parameters" : [
				{
					"Name"      : "File",
					"FileValue" : { "Name" : "#fileName#", "Data" : "#imageData#" }
				},
				{ "Name" : "StoreFile", "Value" : arguments.storeFile }
			]
		};
	}

	function typeFromSupported( required string fileType ){
		return getSourceTypesSupported().findNoCase( arguments.fileType );
	}

	function typeToSupported( required string fileType ){
		return getDestTypesSupported().findNoCase( arguments.fileType );
	}

}
