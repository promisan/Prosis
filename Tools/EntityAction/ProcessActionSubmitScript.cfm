	
		
	<cfparam name="url.id" default="">
	<cfparam name="dsn" default="appsOrganization">

	<cfset val = replaceNoCase("#val#", "@action", "#ActionId#" , "ALL")>
	<cfset val = replaceNoCase("#val#", "@object", "#Object.ObjectId#" , "ALL")>	
	<cfset val = replaceNoCase("#val#", "@key1", "#Object.ObjectKeyValue1#" , "ALL")>
	<cfset val = replaceNoCase("#val#", "@key2", "#Object.ObjectKeyValue2#" , "ALL")>
	<cfset val = replaceNoCase("#val#", "@key3", "#Object.ObjectKeyValue3#" , "ALL")>
	<cfset val = replaceNoCase("#val#", "@key4", "#Object.ObjectKeyValue4#" , "ALL")>
		
	<!--- runtime conversion of custom object fields --->
	
	<cfquery name="Fields" 
		 datasource="#dsn#"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">	 
	     SELECT    R.EntityCode, R.DocumentCode, R.DocumentDescription, I.DocumentItem, I.DocumentItemValue, R.DocumentId
         FROM      Organization.dbo.Ref_EntityDocument AS R INNER JOIN
                   Organization.dbo.OrganizationObjectInformation AS I ON R.DocumentId = I.DocumentId AND I.Objectid = '#Object.ObjectId#'
         WHERE     (R.EntityCode = '#Object.EntityCode#') 
		 AND       (R.DocumentType = 'field') 
	</cfquery>	       
	
	<cfloop query="fields">
	
	    <cfif documentitem eq "date">
				
			<cfif DocumentItemValue neq "">
		        <cfset dateValue = "">
				<CF_DateConvert Value="#DocumentItemValue#">
				<cfset DTE = dateValue>
				<cfset val = replaceNoCase("#val#", "@#documentcode#","#dateformat(dte,client.datesql)#", "ALL")>
			<cfelse>
			    <cfset val = replaceNoCase("#val#", "@#documentcode#","01/01/1900", "ALL")>
			</cfif>  
					
		<cfelse>
		
		   	<cfset val = replaceNoCase("#val#", "@#documentcode#","#DocumentItemValue#", "ALL")>
		
		</cfif>
		    		
	</cfloop>
	
	<cfset val = replaceNoCase("#val#", "@last",  "#SESSION.last#"  , "ALL")>
	<cfset val = replaceNoCase("#val#", "@first", "#SESSION.first#" , "ALL")>
	<cfset val = replaceNoCase("#val#", "@acc",   "#SESSION.acc#"   , "ALL")>
	
	<cfquery name="SQL" 
	 datasource="#dsn#"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">	 	 	 
	 	#preserveSingleQuotes(val)#  
	</cfquery>
	
	<script>
		Prosis.busy('no');
	</script>
	
		

		