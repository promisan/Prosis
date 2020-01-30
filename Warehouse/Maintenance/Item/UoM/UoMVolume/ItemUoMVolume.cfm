
<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">	
		
	<cfoutput>
	
	<tr><td colspan="2" align="center">
	
		<cfdiv bind="url:UoMVolume/ItemUoMVolumeListing.cfm?id=#url.id#&UoM=#URL.UoM#" id="itemUoMVolumelist"/>
				
	</td></tr>
	
	<tr><td colspan="2">
		<cfdiv id="itemUoMVolumeedit"/>
	</td></tr>
	
	</cfoutput>	

</table>