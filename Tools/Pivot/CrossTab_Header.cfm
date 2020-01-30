
<cfoutput>
<tr bgcolor="white">

	<cfset frm = "#Formula.recordcount#"> 
	<cfset cw  = "#80/frm#">  
	
	<td class="labelit" height="20" style="width:250px;border-left: 1px solid d7d7d7; border-bottom: 1px solid d7d7d7;">
	Set:&nbsp;#node#<cfloop index="i" from="1" to="65" step="1">&nbsp;</cfloop>
	</td>
			
	<cfset box = "#node#_header">
	<cfloop query="Xax">
		<cfif len(fieldHeader) gt "5">
		   <cfset hdr = "#left(fieldHeader,5)#..">
		<cfelse>
		   <cfset hdr = "#fieldHeader#">	
		</cfif>
		<td colspan="#frm#" 
		    align="center" 
			style="border-left: 1px solid d7d7d7; border-bottom: 1px solid d7d7d7;padding-left:4px">
		<cfif node eq "1">
			<cfif format eq "HTML">
				<a href="##" style="cursor: help;" title="#fieldHeader#">#hdr#</a>
			<cfelse>
			   #hdr#
			</cfif>   
		</cfif>	   	  
		</td>
	</cfloop>	
		
	<td class="labelit" colspan="#frm#" width="80" align="right" style="border-left: 1px solid d7d7d7; border-right: 1px solid d7d7d7; border-bottom: 1px solid d7d7d7;" height="5" >
	<cfif node eq "1">Total&nbsp;</b></cfif>
	</td>

</tr>

<tr bgcolor="d3d3d3">

	<cfset frm = "#Formula.recordcount#">
	<td style="width:250px;border-top: 1px solid d7d7d7;border-left: 1px solid d7d7d7; border-bottom: 1px solid d7d7d7;"></td>
	<cfset box = "#node#_header">
	<cfloop query="Xax">
		
		<cfloop query="Formula">
			<td class="labelit" width="#cw#" 
				align="right" 
				style="<cfif #currentrow# eq "1">width:#cw#</cfif>;border-top: 1px solid d7d7d7;border-left: 1px solid d7d7d7; border-right: 1px solid d7d7d7; border-bottom: 1px solid d7d7d7;">
				#fieldHeader#
			</td>
		</cfloop>  
		
	</cfloop>
	
	<cfloop query="Formula">
		<cfif currentrow lt formula.recordcount>
			<td width="#cw#" class="labelit" align="right" style="<cfif #currentrow# eq "1">width:#cw#</cfif>border-top: 1px solid d7d7d7;border-left: 1px solid d7d7d7; border-bottom: 1px solid d7d7d7;">
		<cfelse>
			<td width="#cw#" class="labelit" align="right" style="border-top: 1px solid d7d7d7;border-left: 1px solid d7d7d7; border-right: 1px solid d7d7d7; border-bottom: 1px solid d7d7d7;">
		</cfif>
		#fieldHeader#
		</td>
		</cfloop>  

</tr>
</cfoutput>	