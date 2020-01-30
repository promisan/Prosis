
<cfoutput>
	
<cfset stylescroll = "">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">

<tr><td width="100%" height="100%" class="clsListingContent">			
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   
	   <!--- ------------ --->	
	   <!--- -navigation- --->
	   <!--- ------------ --->        
	   <tr class="hide"><td id="listingaction"></td></tr>        
	         
	   <tr><td valign="top" height="10">   
	      <table cellspacing="0" cellpadding="0" width="100%" border="0">
		    <cfset stcl = "header">	   	
			<tr><td height="5"></td></tr>
		    <tr><td colspan="#cols+1#" class="line"></td></tr>   
		    <cfinclude template="ListingHeader.cfm">		
		    <tr><td colspan="#cols+1#" class="line"></td></tr>   
		  </table>	  
	   </td></tr>       
	
	   <tr><td style="height:10px" id="#attributes.box#_content_nav" class="clsNoPrint">
	       <cfinclude template="ListingNavigation.cfm">
		   </td>
	   </tr>		
	      
	   <tr><td valign="top" style="height:100%;">	
	   		  			
				<input type="hidden" name="rowno"      id="rowno"   	value="1">		
				<input type="hidden" name="norows"     id="norows"   	value="#showrows#">			
				<input type="hidden" name="page"       id="page"  	    value="#URL.page#">	 	
				<input type="hidden" name="pages"      id="pages"  	    value="#pages#">			
				
				<cfset row = 0>
				<cfset lst = "">
				
				<cfif attributes.listtype eq "SQL">
				
				    <cftry> 
				
						<cfif searchresult.recordcount neq "0">				
							<cfset ratio = CheckGroup.recordcount/SearchResult.recordcount>															
						</cfif>
						
						<cfcatch>
						    <cfset ratio = 1>
						</cfcatch>
					
					</cftry>
					
				<cfelse>
				
					<cfset ratio = 1>	
				
				</cfif>		
							
				<cfif attributes.selectmode eq "CheckBox" or attributes.selectmode eq "Radio">			
					
					<cfform name="formlistcontent">
					    <cfinclude template="ListingContentData.cfm">
					</cfform>	
							
				<cfelse>	
							
					<cfinclude template="ListingContentData.cfm">						
									
				</cfif>				
											
			
			</td>		
		</tr>			
							
	</table>	

	</td>
	</tr>
	
</table>

</cfoutput>	

<script>
	try { Prosis.busy('no'); } catch(e) {}
</script>
