
    <cfoutput>		
    <tr>
	<cfif url.outputshow eq "0">
		<td class="labelit" style="border-right: 1px solid Gray;border-bottom: 1px solid Gray;" colspan="2">
		<cf_space spaces="6" label="No.">
		</td>			
	<cfelse>
		<td class="labelit" colspan="2" style="border-bottom: 1px solid Gray"><cf_space spaces="2" align="center" label=""></td>
	</cfif> 			
	<td class="labelit" style="border-right: 1px solid Gray;border-bottom: 1px solid Gray">
	<cf_space spaces="80" label="Activity"></td>	
	<td class="labelit" style="border-bottom: 1px solid Gray">
	<cf_space align="center" spaces="40" label="Location"></td>
	<td class="labelit" style="border-right: 1px solid Gray;border-bottom: 1px solid Gray">
	<cf_space spaces="23" align="center" label="Start"></td>
	<td class="labelit" style="border-right: 1px solid Gray;border-bottom: 1px solid Gray">
	<cf_space spaces="23" align="center" label="End"></td>
	<td class="labelit" style="border-bottom: 1px solid Gray">
	<cf_space align="center" spaces="14" label="Dur."></td>	
	</tr>	
	</cfoutput>	
		
	