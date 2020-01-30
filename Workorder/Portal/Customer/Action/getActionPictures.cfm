<cftry>

	<cf_filelibraryN
		box="box_#url.workactionid#"
		DocumentPath="WorkOrder"
		SubDirectory="#url.workactionid#" 
		Filter=""	
		Listing="1"							
		Insert="no"
		color="transparent"
		Remove="#url.remove#"										
		width="100%"	
		Loadscript="no"				
		border="1">
	
	<cfcatch type="Any">
		<cf_tl id="These pictures could not being loaded">
	</cfcatch>
	
</cftry>	