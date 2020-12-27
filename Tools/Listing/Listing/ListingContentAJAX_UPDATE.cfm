<!--- we refresh the fields directly --->
	 
	<cfif searchResult.recordcount eq "1">	
			 
		<!--- we loop through the record with its query field row values --->	 
		<cfloop query="SearchResult">	
		
			<cfloop index="rowshow" from="1" to="3">		   						
				<cfinclude template="ListingContentGetCell.cfm">				
			</cfloop>				
			
		</cfloop> 
								
	<cfelse>
	
	    <!--- we conclude that the line no longer exists so we hide it --->
		
		<cfoutput>
		
			<script language="JavaScript">
					 				 
			 line = document.getElementsByName('f#box#_#url.ajaxid#')														 
			 i = 0			
			 while (line[i]) {			   
			   line[i].className = "hide"
			   i++
			 }			 	 
			</script>
			
		</cfoutput>
		
	</cfif>	