
<cfoutput>

<table width="100%" height="100%">

<tr><td width="100%" height="100%" class="clsListingContent">			

	<table width="100%" height="100%">
	   
	   <!--- ------------ --->	
	   <!--- -navigation- --->
	   <!--- ------------ --->        
	   <tr class="hide"><td id="listingaction"></td></tr> 
	   
	   <tr style="border-top:1px solid silver;border-bottom:1px solid silver"><td style="height:10px" id="#attributes.box#_content_nav" class="clsNoPrint">
	       <cfinclude template="ListingNavigation.cfm">
		   </td>
	   </tr>		       
	   	 
	   <tr><td valign="top" style="height:100%;">	
	   		
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
					    <cfinclude template="ListingContentGetCell.cfm">
					</cfform>	
							
				<cfelse>											
									
					<cfset vContentHeight = "100%">		
					
					<cfset orderset = 0>
					<cfset col      = 0>
					<cfset total    = 0>
					<cfset showrows = 1>	
															
					<cf_divscroll id="_divContentFields" height="#vContentHeight#">
					
						<div id="_divSubContent">
						
						<cfoutput>
						   		   
							<table style="width:98.5%" class="navigation_table" id="#box#_table" border="0">	
																					
								<cfinclude template="ListingHeader.cfm">									
								
								<cfset cols = session.listingdata[box]['columns']>									
								
								<cfif searchresult.recordcount eq "0">																    								
									<tr><td style="height:50" align="center" colspan="#cols#" class="labelmedium"><cf_tl id="NoRecords" var="tlNoRecords">#tlNoRecords#.</td></tr>																																				
								</cfif>	
																								
								<!--- generate data on the level of the group --->
																																																									
								<cfsavecontent variable="mytablecontent">				
								   								  
									<cfif url.listgroupfield eq "" 
									          or url.listgrouptotal eq "0" 
											  or drillkey eq "">																												 
										
										<cfset navmode = attributes.navigation>		
										<!--- show records optionally with group information --->																																													
										<cfinclude template="ListingContentHTMLStandard.cfm">	
																									
									<cfelse>
									
										<cfset navmode = "manual">	
										<!--- shows GROUPED data ONLY with or without column --->																		
										<cfinclude template="ListingContentHTMLGroup.cfm">		
										
									</cfif>			
																		
								</cfsavecontent>
								
								#mytablecontent#
								
								<tr class="hidden"><td id="#attributes.box#_gridbox"></td></tr>
							
							</table>	
						
						</cfoutput>
						</div>
					</cf_divscroll>					
									
				</cfif>			
				
				<!--- we use those indicators in the listingscript to tell what to do --->
								
				<input type="hidden" id="rowno"   	  value="1">		
				<input type="hidden" id="norows"   	  value="#showrows#">			
				<input type="hidden" id="page"  	  value="#URL.page#">	 	
				<input type="hidden" id="pages"  	  value="#pages#">										
				<input type="hidden" id="navigation"  value="#navmode#">											
							
			</td>		
		</tr>	
		
		<tr style="border-top:1px solid silver">
		   <td style="height:10px" id="#attributes.box#_content_nav" class="clsNoPrint">		   
	       <cfinclude template="ListingNavigation.cfm">
		   </td>
	    </tr>		
		
									
	</table>	

	</td>
	</tr>
	
</table>

</cfoutput>	

<script>
	try { Prosis.busyRegion('no','_divSubContent') } catch(e) {}
	try { Prosis.busy('no') } catch(e) {}
</script>
