
<!--- ------- --->
<!--- passtru --->
<!--- ------- --->

<cfoutput>
<script>
	end = document.getElementById("DateExpiration").value		
	eff = document.getElementById("DateEffective").value	
	ptoken.navigate('EntitlementPrior.cfm?id=#url.id#&trg=#url.trg#&ent=#url.ent#&eff='+eff+'&exp='+end,'exist')	
</script>
</cfoutput>

	
	