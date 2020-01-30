(
	function( $ ){
 
		// Create a namespace for ColdFusion related functionality.
		jQuery.coldfusion = {};
		 
		jQuery.coldfusion.eachRow = function( query, callback ){
			// This is the WDDX-compatible format.
			jQuery.coldfusion.eachRow.wddxIterator(query,callback);
			
			// Return the jQuery library.
			return( this );
		};
		 
		// Define a cfquery loop iteration method that can handle the
		// SerializeJSON() method that returns WDDX-compatible data.
		jQuery.coldfusion.eachRow.wddxIterator = function( query, callback ){
			var i = 0;
			 
			// Loop over the records.
			for (var i = 0 ; i < query.ROWCOUNT ; i++){
				(
					function( rowIndex ) {
						var row = {};
						 
						// Loop over the column names to create the data
						// collection as column-value pairs.
						$.each(query.DATA,function( column, values ){
							row[ column.toUpperCase() ] = values[ rowIndex ];
						});
				 
						// Execute the callback method in the context of
						// the row data.
						callback.call( row, rowIndex, row );
					}
				)( i );
			}
		};
		 
 
	}

)( jQuery );