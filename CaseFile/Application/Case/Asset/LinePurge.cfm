
<cftransaction>
		
	<!--- update workflow --->
	<cfquery name="Delete" 
		     datasource="AppsCaseFile" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     DELETE FROM ClaimAsset			  
			 WHERE  ClaimId = '#URL.ClaimId#'
			  AND   Assetid = '#URL.ID2#'
	</cfquery>

</cftransaction>

<cfset url.id2 = "">
<cfinclude template="Line.cfm">

