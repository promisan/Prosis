	
<cfquery name="Last" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	TOP 1 *
    FROM 	PromotionElement
	WHERE 	PromotionId = '#Attributes.PromotionId#'
	ORDER 	BY ElementSerialNo DESC				
</cfquery>

<cfif Last.ElementSerialNo neq "">							
	<cfset pElementSerialNo = Last.ElementSerialNo+1>
<cfelse>
    <cfset pElementSerialNo = 1>
</cfif>	
		
<CFSET Caller.pElementSerialNo = pElementSerialNo>		
