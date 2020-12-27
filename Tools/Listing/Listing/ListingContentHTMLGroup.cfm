
<!--- attention : PENDING if the grouping has more than 600 records itself, we are not going to group but we do a normal listing --->

<cfinclude template="ListingGroupData.cfm">

<cfset pre = session.listingdata[box]['colprefix']>	
<cfset agg = session.listingdata[box]['aggregate']>	

<!--- GROUP / PIVOT PRESENTATION --->
	
<cfif session.listingdata[box]['firstsummary'] gte "3">			   
   <cfset headercols = pre+session.listingdata[box]['firstsummary']-1>	 
<cfelse>		
   <cfset headercols = cols>		   			   	   		   		
</cfif>	
													
<cfif searchgroup.recordcount eq "1">

	<!--- we show group and content as there is just one group record and then we better show data with it --->	
	<cfset navmode = attributes.navigation>	<!--- paging or auto --->	
								
	<cfinclude template="ListingContentHTMLStandard.cfm">														

<cfelse>
										
	<!--- we show group then expand on it on the fly --->
	<cfset navmode = "manual">			
		
		
	<!--- we determine how to show the group, WITH columns or without columns --->			
	<cfif session.listingdata[box]['colnfield'] neq "">
	
	    <!--- ------------------------ --->
		<!--- -- PIVOT presentation--- --->
		<!--- ------------------------ --->	
		
		<cfset headercols = "5">
	
	    <!--- pivot header --->
		<tr class="fixrow240">
			<td style="background-color:white" colspan="<cfoutput>#headercols#</cfoutput>"</td>
			<td colspan="<cfoutput>#cols-headercols#</cfoutput>" align="right" style="border-right:1px solid silver">				
			<cfset attributes.mode = "Header">			
			<cfinclude template="ListingContentHTMLColumn.cfm"> 	
			</td>
			<td style="background-color:white"></td>
		</tr>		
							
		<!--- we take a random value of the key so we can easily find the content --->					
		<cfoutput query="SearchGroup" startrow="1" maxrows="200" group="#url.listgroupfield#">				
			<cfset currrow = currrow + 1>							     					
			<cfinclude template="ListingContentHTMLGroupData.cfm">																			
		</cfoutput>		
		
	 <cfelse>
	 	 
	 	<!--- -------------------------- --->
	 	<!--- --ROW LINE PRESENTATION-- --->
		<!--- ------------------------- --->	 	 				
		<cfoutput query="SearchGroup" startrow="1" maxrows="200" group="#url.listgroupfield#">				
			<cfset currrow = currrow + 1>					     					
			<cfinclude template="ListingContentHTMLGroupData.cfm">																			
		</cfoutput>			 
	 
	 </cfif>																			

</cfif>

