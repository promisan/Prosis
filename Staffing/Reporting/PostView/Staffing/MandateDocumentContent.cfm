				  
	<cfif url.accessOrg eq "EDIT" or url.accessOrg eq "ALL">			  
	
		<cf_filelibraryN
			DocumentPath="Mission"
			SubDirectory="#URL.Mission#" 
			Filter="#URL.Mandate#"
			Insert="yes"
			loadscript="No"			
			Remove="yes"
			rowHeader="no"
			ShowSize="yes">	 
		
	<cfelse>
	
		<cf_filelibraryN
			DocumentPath="Mission"
			SubDirectory="#URL.Mission#" 
			Filter="#URL.Mandate#"
			Insert="no"
			loadscript="No"			
			Remove="no"
			rowHeader="no"
			ShowSize="yes">	 
	
	</cfif>	
	
	<cfset ajaxonload("doHighlight")>