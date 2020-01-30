<cfquery name="CountRec" 
      datasource="AppsWorkOrder" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      	SELECT	RequestId as id
		FROM	Request
		WHERE	ServiceDomain = '#url.id1#'
		AND 	ServiceDomainClass = '#url.id2#'
		UNION
		SELECT	WorkorderId as id
		FROM	Workorderline
		WHERE	ServiceDomain = '#url.id1#'
		AND 	ServiceDomainClass = '#url.id2#'
</cfquery>

<cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("Domain Class is in use. Operation aborted.")
     
     </script>  
 
<cfelse>
		
	<cfquery name="Delete" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_ServiceitemDomainClass
		WHERE	ServiceDomain = '#url.id1#'
		AND 	Code = '#url.id2#'
	</cfquery>

</cfif>

<cfoutput>
	<script language="JavaScript">
    	ptoken.navigate('#SESSION.root#/Workorder/Maintenance/Domain/DomainClass/DomainClassListing.cfm?ID1=#url.id1#','domainClassListing')   
	</script> 
</cfoutput>