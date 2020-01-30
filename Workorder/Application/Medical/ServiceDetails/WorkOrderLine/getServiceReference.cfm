
<cfquery name="ServiceArea" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT    *
	FROM      WorkOrderService P
	WHERE     ServiceDomain = '#url.servicedomain#'
	AND       EXISTS (SELECT 'X'
	                  FROM   WorkOrderServiceMissionItem
					  WHERE  ServiceDomain = P.ServiceDomain
					  AND    Reference     = P.Reference
					  AND    Mission       = '#url.mission#'
					  AND    ServiceItem   = '#url.serviceItem#')
	ORDER BY  ListingOrder,Reference 						
	
</cfquery>		
		
<cfif serviceArea.recordcount eq "0">
	
	<cfquery name="ServiceArea" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT    *
		FROM      WorkOrderService P
		WHERE     ServiceDomain = '#url.servicedomain#'			
		ORDER BY  ListingOrder,Reference 						
		
	</cfquery>		

</cfif>

<select name="ServiceReference" id="ServiceReference" class="regularxl enterastab">
	<cfoutput query="ServiceArea">
	   <cf_tl id="#Description#" var="1">
	   <option value="#Reference#" <cfif url.reference eq Reference>selected</cfif>>#lt_text#</option>
	</cfoutput>					
</select>