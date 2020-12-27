	
					  
	<cfif url.accessOrg eq "EDIT" or url.accessOrg eq "ALL">			  
	
		<cf_filelibraryN
			DocumentPath="Mission"
			SubDirectory="#URL.Mission#" 
			Filter="#URL.Mandate#"
			Insert="yes"
			loadscript="no"			
			Remove="yes"
			rowHeader="no"
			ShowSize="yes">	 
		
	<cfelse>
	
		<cf_filelibraryN
			DocumentPath="Mission"
			SubDirectory="#URL.Mission#" 
			Filter="#URL.Mandate#"
			Insert="no"
			loadscript="no"			
			Remove="no"
			rowHeader="no"
			ShowSize="yes">	 
	
	</cfif>	
	
	<cfset ajaxonload("doHighlight")>