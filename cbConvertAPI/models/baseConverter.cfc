component {

	property name="apiSecret" inject="coldbox:setting:apiSecret@cbConvertAPI";
	property name="apiKey"    inject="coldbox:setting:apiKey@cbConvertAPI";
	property name="baseURL" default="https://v2.convertapi.com/convert";

	function writeOutputFiles( ResponseData, outputPath ){
		var retme = [];
		responseData.Files.each( function( item ){
			var outputFileName = expandPath( "#trim( outputPath )#/#item.Filename#" );
			fileWrite( outputFileName, toBinary( item.fileData ) );
			retme.append( outputFileName );
		} );

		return retme;
	}

	function obtainFileBinary( path ){
		if ( !fileExists( arguments.path ) ) {
			return "";
		}
		return fileReadBinary( expandPath( arguments.path ) );
	}

	function fileToBase64( fileData ){
		return toBase64( fileData );
	}

}
