<cfoutput>
	
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" onkeyup="listnavigateRow()">    
	
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
	  
		<tr class="xxxxxhide">
	    	<td height="0%" id="#attributes.box#_ajax"></td>
	    </tr>						
				
		<cfset vContentHeight = "100%">		
		
		<!--- ------------------------------------------------------------------------------------- --->
		<!--- provision to fix the height bug in IE10 and IE11 but ONLY if the left tree is enabled --->
		<!--- ------------------------------------------------------------------------------------- --->
		
		<cfquery name="tree" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		         SELECT *
		         FROM  Ref_ModuleControlDetailField
		         WHERE SystemFunctionId = '#url.SystemFunctionId#'
		         AND   FunctionSerialNo = '1'
		         AND   FieldTree = 1		
		</cfquery>
		
		<cfif tree.recordcount gte "1">
			
			<cfif find ("MSIE 10","#CGI.HTTP_USER_AGENT#")
				or (
				      find("Mozilla/5.0","#CGI.HTTP_USER_AGENT#") and 
					  find("Trident","#CGI.HTTP_USER_AGENT#") and 
					  find("rv:11","#CGI.HTTP_USER_AGENT#") and 
					  find("like Gecko","#CGI.HTTP_USER_AGENT#")
					  
					)>
				<cfset vContentHeight = "#url.height-270#">		
			</cfif>
		
		</cfif>
		
		<!--- ------------------------------------------------------------------------------------- --->
		<!--- provision to fix the height bug in IE10 and IE11 but ONLY if the left tree is enabled --->
		<!--- ------------------------------------------------------------------------------------- --->
		
		<tr>
	    	<td style="padding:3px;" width="100%" height="#vContentHeight#">
			   <cf_divscroll overflowx="auto" overflowy="hidden" id="#attributes.box#_content">					     
				    <cfinclude template="ListingContent.cfm">			
			   </cf_divscroll>						  												
			</td>
	    </tr>	 
		   
	</table> 
	
</cfoutput>  
