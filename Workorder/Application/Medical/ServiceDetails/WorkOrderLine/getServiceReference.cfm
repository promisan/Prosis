<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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