// By default, ColdFusion upper-cases all its keys. This method 
// will lowercase the ColdFusion keys.
var cleanColdFusionJSONResponse = function( apiAction, response ){
	// Check to see if this it the load.
	if (apiAction == "load"){
		
		jQuery.each(
			response,
			function( index, tagData ){
				jQuery.each(
					tagData,
					function( key, value ){
						tagData[ key.toLowerCase() ] = value;
					}
				);
			
			}
		);
	
	}
	return( response );
}