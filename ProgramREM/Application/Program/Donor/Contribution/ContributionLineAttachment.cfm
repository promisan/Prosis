<cfoutput>

	<table border="0" cellspacing="0" cellpadding="0" width="100%">	
	<tr>
	<td class="n_contribution" colspan="3"></td>	
	<td style="padding:4px">
	
		<cfif mode eq "edit">
	
			<cf_filelibraryN
				DocumentPath="DonorLines"
				SubDirectory="#URL.LineId#" 
				Filter=""
				Presentation="all"
				Insert="yes"
				Remove="yes"
				width="100%"	
				Loadscript="no"				
				border="1"
				box = "r_#URL.LineId#">	
			
		<cfelse>
		
			<cf_filelibraryN
				DocumentPath="DonorLines"
				SubDirectory="#URL.LineId#" 
				Filter=""
				Presentation="all"
				Insert="no"
				Remove="no"
				width="100%"	
				Loadscript="no"				
				border="1"
				box = "r_#URL.LineId#">	
		
		
		</cfif>	
			
	</td>
	</tr>		
	</table>	
	
</cfoutput>	