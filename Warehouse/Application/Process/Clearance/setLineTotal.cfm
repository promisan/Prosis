
<cfparam name="url.reference" default="">

<cfquery name="Total" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

		SELECT sum(RequestedAmount) as Total 		      
		FROM   Materials.dbo.Request L, 			 
			   Organization Org			 
		WHERE  L.Status   = '#url.Status#' 
		AND    L.OrgUnit  = Org.OrgUnit 
		AND    L.Mission  = '#URL.Mission#' 		
		AND    L.Reference = '#url.reference#'		
		
</cfquery>

<cfoutput>
#NumberFormat(Total.Total,'__,____.__')#
</cfoutput>
