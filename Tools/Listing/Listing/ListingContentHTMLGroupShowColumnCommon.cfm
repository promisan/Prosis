
<!--- this is column presentation for date field in particular --->

<cfoutput>

<cfif url.datacell1 eq "total">		
	<cfset cwd = "50">	<!--- normal count --->		
<cfelse>		
	<cfset cwd = "65">			
</cfif>

	<table style="width:100%;height:100%">	
	
		<cfswitch expression="#attributes.mode#">
		
			<cfcase value="header">
				
					<cfset span = 0>				
					
					<!--- column --->
									
					<cfset perc = round(100/(getRange.recordcount+1))>	
					<cfset perc = 0>	
														
					<tr class="labelmedium">
																				
						<cfloop query="getRange">											
								  				 							
							<cfif cnt eq "2">						     
							     <td style="height:100%;text-align:center;min-width:#cwd#px;width:#perc#%;border-left:1px solid silver;padding-right:4px;<cfif currentrow eq recordcount>border-right:1px solid green</cfif>">#col#</td>							 
								 <cfset cell = cell+1>
							<cfelse>	
							 	 <td style="width:#perc*(cnt-1)#%">
								 <table style="width:100%;height:100%">
								 <tr class="line"><td colspan="#cnt-1#" style="text-align:center;border-left:1px solid silver;<cfif currentrow eq recordcount>border-right:1px solid green</cfif>">#col#</td></tr>
								 <tr>
							     <cfloop index="itm" list="#URL.datacell1formula#">		
								 				 
								 <td style="text-align:center;min-width:#cwd#px;width:#perc#%;border-left:1px solid silver;padding-right:4px">#itm#</td>
								 <cfset cell = cell+1>
								 </cfloop>	
								 </tr>
								 </table>
								 </td>							 										 							 
							</cfif>						 
								 
						</cfloop>
											
						<cfif cnt eq "2">						     
						     <td style="background-color:e6e6e6;text-align:center;min-width:#cwd#px;width:#perc#%;border-left:1px solid silver;padding-right:4px"><cf_tl id="Total"></td>							 
							 <cfset cell = cell+1>
						<cfelse>	
						 	 <td style="width:#perc*(cnt-1)#%">
								 <table style="height:100%;width:100%">
									 <tr class="line">
									 <td colspan="#cnt-1#" style="background-color:e6e6e6;text-align:center;border-left:1px solid silver"><cf_tl id="Total"></td>
									 </tr>
									 <tr>
								     <cfloop index="itm" list="#URL.datacell1formula#">						 
									 <td style="background-color:e6e6e6;text-align:center;min-width:#cwd#px;width:#perc#%;border-left:1px solid silver;padding-right:4px">#itm#</td>
									 <cfset cell = cell+1>
									 </cfloop>	
									 </tr>
								 </table>
							 </td>							 										 							 
						</cfif>			
																		
					</tr>	
						
				</cfcase>
				
				<cfcase value="line">
				
				    <!--- line --->	
							
					<cfset perc = round(100/(getRange.recordcount+1))>
					
					<cfset perc = perc/(cnt-1)>
					
											
					<tr class="labelmedium2" style="<cfif gridcontent eq 'total'>background-color:e6e6e6</cfif>">
						
						<cfloop query="getRange">	
									
							<Cfset vCol = col>
							<cfscript>
								subSet = myval.filter(function(cellcontent){ 
												return cellcontent[1] == "#vCol#"; 
v											});
							</cfscript>							
							
							<cfset drillfield = "#url.listcolumn1#">
							<cfset filter     = "#vcol#">					   
														
							<cfif ArrayLen(subSet) neq 0>						    				 
								 								 
								 <cfloop index="itm" from="2" to="#cnt#">	
								 
									 <td style="text-align:right;min-width:#cwd#px;width:#perc#%;border-left:1px solid silver;padding-right:6px;<cfif currentrow eq recordcount>;border-right:1px solid green</cfif>"
									 onclick="<cfif gridcontent eq 'row'>listgroupshow('#SearchGroup.GroupKeyValue#','#rowdata#','#drillfield#','#filter#')</cfif>">
									 <cfset val = subSet[1][itm]>#val#
									 </td>
								 								 
								 </cfloop>
								 
							<cfelse>
							
								 <cfloop index="itm" from="2" to="#cnt#">	
							     <td style="background-color:##eaeaea80;min-width:#cwd#px;width:#perc#%;border-left:1px solid silver;padding-right:6px;<cfif currentrow eq recordcount>;border-right:1px solid green</cfif>"></td>
								 </cfloop>															 
								 
							</cfif>	 
											
						</cfloop>
						
						<!--- total column --->
						
						<cfif cnt eq "2">						     
						     <td style="text-align:right;background-color:##d6d6d680;min-width:#cwd#px;width:#perc#%;border-left:1px solid silver;padding-right:6px">
							 <cfparam name="myTot[#cnt#]" default="">
							 <cfset val = myTot[cnt]>#val#
								 </td>				 						
						<cfelse>	
						 	  <cfloop index="itm" from="2" to="#cnt#">	
							  <cfparam name="myTot[#cnt#]" default="">
						     <td style="text-align:right;background-color:##d6d6d680;min-width:#cwd#px;width:#perc#%;border-left:1px solid silver;padding-right:6px">#myTot[itm]#</td>
							 </cfloop>						 										 							 
						</cfif>					
									
					</tr>					
					
			</cfcase>				
			
		</cfswitch>
		
	</table>

</cfoutput>
			
