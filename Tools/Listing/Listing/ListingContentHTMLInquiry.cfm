<cfoutput>
	
	<table width="100%" height="100%" onkeyup="listnavigateRow('#box#')">   
		
	<cfif attributes.filtershow neq "No"> 
	   
		<tr>
			<td height="30">
				<table width="100%" cellspacing="0" cellpadding="0" align="right">    
					<cf_tl id="Filter" var="tlFilter">    
					<tr>
						<td height="28" width="99%" style="padding-left:10px" class="labelmedium">
	                    	#tlFilter#
	                    </td>
						<td align="right" height="100%" width="23" style="cursor:pointer;border-left:dotted 1px silver;">
	
							<cfif attributes.filtershow eq "hide">						  
		                    	<cfset cl = "hide">
		                    	<cfset cla = "regular">
		                    <cfelse>
		                   		<cfset cl = "regular">
		                    	<cfset cla = "hide">
		                    </cfif>
																					
	                        <cf_space spaces="8">
	                        <img src="#SESSION.root#/images/up6.png" 
	                        	id="locate#attributes.box#_col"	
	                       		height="22"
	                        	width="23"
	                        	align="absmiddle"
	                        	onclick="listingshow('locate#attributes.box#')"								
	                        	class="#cl#">
	                            
	                        <img src="#SESSION.root#/images/down6.png" 		    
	                        	id="locate#attributes.box#_exp" 
	                        	height="22"
	                        	width="23"
	                        	align="absmiddle"
	                        	onclick="listingshow('locate#attributes.box#')" 								
	                        	class="#cla#">
	
						</td>						
					</tr>    
					<tr>
	                	<td height="1" colspan="2" class="line">
	                    </td>
	                </tr>    
										
					<cfset getMissingFilter = "1">
					
	                <tr>
					  					
						<td class="#cl#" id="locate#attributes.box#" name="locate#attributes.box#" colspan="2" width="100%">
							<!--- show filter options --->							
							<cfinclude template="ListingFilter.cfm">									
						</td>    
						
					</tr>    
				</table>
			</td>
		</tr>   
		
	</cfif>  
		
	<tr class="xhide">
	   	<td height="0%" id="#attributes.box#_ajax"></td>
	</tr>						
					
	<tr>
	   	<td style="padding:3px;height:100%" width="100%" id="#attributes.box#_content">			   			     
			 <cfinclude template="ListingContentHTML.cfm">						  					  												
		</td>
	</tr>	 
		   
	</table> 
	
</cfoutput>  
