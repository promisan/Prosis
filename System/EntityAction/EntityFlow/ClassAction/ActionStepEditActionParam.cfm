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

