<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfoutput>

<cfquery name="String" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_EntityDocument
		WHERE EntityCode = '#URL.EntityCode#'
		AND DocumentCode = '#url.Dialog#' 
	</cfquery>
	
	<cfif String.documentStringList eq "" and string.lookupfieldkey neq "">
	
	    <input type="hidden" name="ActionDialogParameter" id="ActionDialogParameter">
	  
	<cfelse>
											
		<select name="ActionDialogParameter" id="ActionDialogParameter" class="regularxl">

		    <option value="">N/A</option>			
			<cfloop index="itm" list="#String.documentStringList#" delimiters=",">
			   
		    	<option value="#itm#"
				 <cfif itm eq url.DialogParameter>selected</cfif>>
				 #itm#
				 </option>	 
							 
			</cfloop>
			
			<cfif string.lookupfieldkey neq "">
			
				<cfquery name="List" 
					datasource="#String.lookupdatasource#" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT DISTINCT #String.LookupFieldKey# as PK, 
						       #String.LookupFieldName# as Name
						FROM  #String.lookuptable#		
						WHERE 	#String.LookupFieldKey# > ''			
				 </cfquery>	
				 
				 <cfloop query="List">
				   
			    	<option value="" value="#pk#"
					 <cfif pk eq url.DialogParameter>selected</cfif>>
					 #name#
					 </option>	 
								 
				</cfloop>
				
			</cfif>
			
		</select>
						
	</cfif>
	
</cfoutput>	

