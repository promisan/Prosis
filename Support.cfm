		
<cfquery name="Link" 
	datasource="AppsSystem">
		SELECT    *
		FROM      PortalLinks
		WHERE     PortalId = '#url.id#'
</cfquery>
   
<cfif link.recordcount eq "1">
   
   <cfoutput>   
	   <cflocation addtoken="No" url="#link.locationurl#">   
   </cfoutput>
   
</cfif>
