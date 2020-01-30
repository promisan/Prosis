
<cfoutput>
	
	<cfif url.overall eq "0">
	  <cfset cl = "green">
	<cfelse>
	  <cfset cl = "red">   
	</cfif>
	
	<table>
	<tr class="labelit">
	<td valign="bottom" style="font-size:21px;font-weight:200">
	<cfif url.overall eq "0"><cf_tl id="No"><cf_tl id="Pending"><cfelse><font color="#cl#">#url.overall#</font></cfif> 
	</td>
	<td valign="bottom" style="padding-left:6px;font-size:21px;font-weight:200">	
	<cfif url.overall eq "1"><cf_tl id="batch clearance"><cfelse><cf_tl id="batch clearances"></cfif>
	</td>
	</tr>
	</table>

</cfoutput>