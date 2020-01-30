		
<!--- show map info --->
	
<cfset cnt = 1>
   
<cfloop index="itm" list="#url.coordinates#" delimiters=":">
        <cfif cnt eq "1">
			 <cfset latitude  = itm>
		<cfelse>
			 <cfset longitude = itm> 
		</cfif>
		<cfset cnt=cnt+1>
</cfloop>				
            
<table width="100%" height="100%" border="0" bgcolor="white">
	<tr>
    	<td align="center">
	<cftry>
	
    <cfmap centerlatitude="#latitude#" 
        centerlongitude="#longitude#" 
        doubleclickzoom="true" 
		zoomlevel="18"
        showscale="true"
        type="hybrid"
        typecontrol="advanced"
        zoomcontrol="large3d" 
        tip="#url.name#"
        height="591"
        width="604">
        
	</cfmap>
	<cfcatch>
	MAP could not be located
	</cfcatch>
	</cftry>
   	</Td>
	</tr>
</table>	