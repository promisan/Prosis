
<cfoutput>

	<script>
	     
		 _cf_loadingtexthtml='';	
	     ColdFusion.navigate('WorkClusterListing.cfm?id=#url.id#&desc=#url.desc#&Step=#URL.Step#&date=#URL.date#','node')
		 ColdFusion.navigate('WorkClusterMAP.cfm?id=#url.id#&desc=#url.desc#&Step=#URL.Step#&date=#URL.date#','map')
		 
	</script>

</cfoutput>
