
<cfif attach eq "1">
	
	<cf_filelibraryN
			DocumentPath="ProcurementJob"
			SubDirectory="#URL.ID1#" 
			Filter="#OrgUnit#"
			Box="Org#orgunit#"
			Insert="yes"		
			loadscript="No"	
			Remove="yes"
			width="99%"		
			AttachDialog="yes"
			align="left"
			border="1">	
			
<cfelse>

	<cf_filelibraryN
		DocumentPath="ProcurementJob"
		SubDirectory="#URL.ID1#" 
		Filter="#OrgUnit#"
		Box="Org#orgunit#"
		loadscript="No"
		Insert="no"
		Remove="no"
		reload="true"		
		width="99%"
		align="left"
		border="1">	

</cfif>	

