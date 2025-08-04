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
		
<!--- prepopulate so ajax is not bother in case of refresh --->		

<cfquery name="Request" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Request								
		<cfif url.requestid eq "">
		WHERE 1= 0
		<cfelse>
		WHERE  RequestId   = '#url.requestid#'		
		</cfif>
		
</cfquery>		

<cfquery name="RequestLine" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT ValueFrom as Serviceitem
		FROM   RequestWorkorderDetail
		WHERE  Amendment = 'ServiceItem'
		<cfif url.requestid eq "">
		AND 1=0
		<cfelse>
		AND  Requestid   = '#url.requestid#'
		</cfif>		
</cfquery>

<cfif RequestLine.recordcount eq "0">

	<!--- this should not occur --->
	
	<cfquery name="RequestLine" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   RequestLine
		<cfif url.requestid eq "">
		WHERE 1=0
		<cfelse>
		WHERE  Requestid   = '#url.requestid#'		
		</cfif>				
	</cfquery>

</cfif>

<cfquery name="RequestAction" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT R.RequestType, R.ServiceDomain, R.RequestAction, R.RequestActionName, R.ListingOrder, R.ServiceDomainClass, R.isAmendment, R.PointerBilling, 
               R.PointerReference, R.PointerExpiration, R.CustomForm, R.CustomFormCondition, R.EntityClass, R.Operational, R.OfficerUserId, R.OfficerLastName, 
               R.OfficerFirstName, R.Created, D.Description
		FROM   #CLIENT.LanPrefix#Ref_RequestWorkflow AS R INNER JOIN
               Ref_ServiceItemDomainClass AS D ON R.ServiceDomain = D.ServiceDomain AND R.ServiceDomainClass = D.Code
		WHERE  R.RequestType   = '#url.requesttype#'
		AND    R.ServiceDomain = '#url.domain#'
		<cfif url.serviceitem neq "">		
		AND    EXISTS (SELECT 'X' 
		               FROM   Ref_RequestWorkflowServiceItem 
                       WHERE  RequestType = R.RequestType
					   AND    ServiceDomain = R.ServiceDomain 
					   AND    RequestAction = R.RequestAction
					   AND    ServiceItem = '#url.serviceitem#')					  
		</cfif>		
		AND    R.Operational = 1	
		AND    D.Operational = 1	
		ORDER BY D.ListingOrder, R.ListingOrder
</cfquery>

<cfif RequestAction.recordcount eq "0">
	
	<cfquery name="RequestAction" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT R.RequestType, R.ServiceDomain, R.RequestAction, R.RequestActionName, R.ListingOrder, R.ServiceDomainClass, R.isAmendment, R.PointerBilling, 
	               R.PointerReference, R.PointerExpiration, R.CustomForm, R.CustomFormCondition, R.EntityClass, R.Operational, R.OfficerUserId, R.OfficerLastName, 
	               R.OfficerFirstName, R.Created, D.Description
			FROM   #CLIENT.LanPrefix#Ref_RequestWorkflow AS R INNER JOIN
	               Ref_ServiceItemDomainClass AS D ON R.ServiceDomain = D.ServiceDomain AND R.ServiceDomainClass = D.Code
			WHERE  R.RequestType   = '#url.requesttype#'
			AND    R.ServiceDomain = '#url.domain#'			
			AND    R.Operational = 1	
			AND    D.Operational = 1	
			ORDER BY D.ListingOrder, R.ListingOrder
	</cfquery>

</cfif>

<cfif RequestAction.recordcount eq "1">

	<script language="JavaScript">
       document.getElementById('rowaction').className = "hide"
	</script>

<cfelse>

	<script language="JavaScript">
     document.getElementById('rowaction').className = "regular"
	</script>

</cfif>

<cfoutput>

<!-- <cfform> -->
<cfselect name="requestaction" id="requestaction" class="regularxl" 
   group="Description" 
  value="RequestAction"
  Display="RequestActionName"
  query="RequestAction"
  selected="#Request.RequestAction#" 
  onchange="loadcustomform('#url.requestid#',document.getElementById('requesttype').value,'#url.serviceitem#','edit',document.getElementById('workorderlineid').value,this.value)"
  style="color:black;width:300">
    <!---
	<cfloop query="RequestAction">
        <option value="#RequestAction#" <cfif Request.RequestAction eq RequestAction>selected</cfif>>#RequestActionName#</option>				
	</cfloop>	
	--->
	</cfselect>
	
<!-- </cfform> -->

</cfoutput>
