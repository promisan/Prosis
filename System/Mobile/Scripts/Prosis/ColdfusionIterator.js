/*
 * Copyright © 2025 Promisan
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
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