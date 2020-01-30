<cfquery name="getMissionPosting" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	ServiceItemMissionPosting
	WHERE 	ServiceItem	= '#url.id1#'
	AND		Mission = '#url.id2#'
	ORDER BY SelectionDateExpiration DESC
</cfquery>
<cfoutput>
	<font color="808080">
	<cfif getMissionPosting.recordcount gt 0>		
		#Dateformat(getMissionPosting.SelectionDateExpiration, "#CLIENT.DateFormatShow#")#, <cfif getMissionPosting.ActionStatus eq 0>Open<cfelseif getMissionPosting.ActionStatus eq 1><b>Closed</b></cfif>, #getMissionPosting.recordcount# record<cfif getMissionPosting.recordcount gt 1>s</cfif>			
	<cfelse>
		No periods defined
	</cfif>
	</font>
</cfoutput> 