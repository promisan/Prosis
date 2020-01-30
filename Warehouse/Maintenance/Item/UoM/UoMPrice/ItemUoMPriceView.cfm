

<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">		
		
	<cfoutput>
	
	<tr><td colspan="2" align="center" height="100%" style="padding:10px">
	
		<cf_divscroll style="height:100%">
	
		<cfdiv bind="url:UoMPrice/ItemUoMPriceListing.cfm?id=#url.id#&UoM=#URL.UoM#&selectedMission=#URL.selectedMission#" id="itemUoMPricelist"/>
		
		</cf_divscroll>
		
	</td></tr>
	
	<tr><td colspan="2">
		<cfdiv id="itemUoMPriceedit"/>
	</td></tr>
	
	</cfoutput>	

</TABLE>
