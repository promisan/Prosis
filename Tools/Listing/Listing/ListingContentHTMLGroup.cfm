
<!--- attention : PENDING if the grouping has more than 600 records itself, we are not going to group but we do a normal listing --->

<cfinclude template="ListingDataGroup.cfm">

<cfset pre = session.listingdata[box]['colprefix']>	
<cfset agg = session.listingdata[box]['aggregate']>	

<!--- GROUP / PIVOT PRESENTATION --->
	
<cfif session.listingdata[box]['firstsummary'] gte "3">			   
   <cfset headercols = pre+session.listingdata[box]['firstsummary']-1>	 
<cfelse>		
   <cfset headercols = cols>		   			   	   		   		
</cfif>	

<cfset headercols = pre>

<cfif headercols lte "3">
	<cfset headercols = "4">
</cfif>
										
<!--- we show group then expand on it on the fly --->
<cfset navmode = "manual">			
				
<!--- we determine how to show the group, WITH columns or without columns --->			

<cfif url.listcolumn1 neq "" and url.listcolumn1 neq "summary">
	
    <!--- ------------------------ --->
	<!--- -- PIVOT presentation--- --->
	<!--- ------------------------ --->	
					
	<cfoutput>

    <!--- group header with dimension --->
	
	<tr class="fixrow240">		
		<td style="min-width:360px;" colspan="#headercols#">	
						
			<cfif url.listcolumn1_type eq "period">
			
			        <!--- to keep this from moving --->
				    <div style="height:24px;position:relative;">
		              <div style="height:100%;width:100%;position:absolute;left:0;top:0;" class="sticky">
									
						<table align="center" style="width:100%;"><tr>
						<td align="center"><table><tr>
																		
								<cfloop index="itm" list="Year,Quarter,Month,Week">					
									<cfset sc = "document.getElementById('listcolumn1_typemode').value='#itm#';applyfilter('','','content')">				
									<cfif url.listcolumn1_typemode neq "#itm#">
										<td style="padding:1px"><input onclick="#sc#" type="button" name="selectperiod" value="#itm#" class="button10g" style="height:25px;border-radius:5px;width:75px;border:1px solid gray"></td>
									<cfelse>
									     <td align="center" style="width:75px;border:0x;font-weight:bold">#itm#</td>
									</cfif>						
								</cfloop>	
								
							</tr></table></td>	
						</tr>		
						</table>	
				
					  </div>
				  </div>			
			
			</cfif>
		
		</td>
		<td style="width:100%;background-color:white;border-bottom:1px solid silver;border-right: 1px solid silver" colspan="#cols-1#">	
												
		<cfset attributes.mode = "Header">			
		<cfinclude template="ListingContentHTMLGroupShowColumn.cfm"> 	
		
		</td>									
	</tr>	
	
	</cfoutput>	
							
	<!--- we take a random value of the key so we can easily find the content --->
		
	<cfset resultset = "">
					
	<cfset gridcontent = "row">													
	<cfoutput query="SearchGroup" group="#url.listgroupfield#" startrow=1 maxrows="200">								
		<cfset val = "|#evaluate(url.listgroupfield)#|">	
		<cfif not findNoCase(val,resultset)>							     					
		     <cfset resultset = "#resultset#,#val#">							 
		     <cfinclude template="ListingContentHTMLGroupShow.cfm"> 
			 <cfset currrow = currrow + 1>																		
		</cfif>				
	</cfoutput>		
	
	<!--- Overall Totalrow total --->
						
	<cfset gridcontent  = "total"> 
	<cfset searchGroup  = searchgrouptotal> <!--- we swop content --->
    <cfinclude template = "ListingContentHTMLGroupShow.cfm">	
	<cfset searchgroup  = session.listingdata[box]['datasetgroup']> 						
						
 <cfelse>
	 	 	 
 	<!--- ---------------------------- --->
 	<!--- -- ROW LINE PRESENTATION --- --->
	<!--- ---------------------------- --->	 
		
	<cfset resultset = "">
									
	<cfoutput query="SearchGroup" group="#url.listgroupfield#" startrow=1 maxrows="200">							
		<cfset val = "|#evaluate(url.listgroupfield)#|">	
		<cfif not findNoCase(val,resultset)>							     					
		     <cfset resultset = "#resultset#,#val#">
		     <cfinclude template="ListingContentHTMLGroupShow.cfm">		
			 <cfset currrow = currrow + 1>																		
		</cfif>									     																									
	</cfoutput>			 
			 
 </cfif>	
	 
<!---
</cfif>
--->


