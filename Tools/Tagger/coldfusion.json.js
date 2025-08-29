/*
 * Copyright © 2025 Promisan B.V.
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