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
		SELECT *
		FROM   Ref_RequestWorkflow								
		WHERE  RequestType   = '#url.requesttype#'
		AND    ServiceDomain = '#url.domain#'
		AND    Operational = 1
		ORDER BY ListingOrder
</cfquery>


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

<select name="requestaction" id="requestaction" class="regularxl"
 onchange="loadcustomform('#url.requestid#',document.getElementById('requesttype').value,'#url.serviceitem#','edit',document.getElementById('workorderlineid').value,this.value)"
   style="color:black;width:300">
	<cfloop query="RequestAction">
        <option value="#RequestAction#" <cfif Request.RequestAction eq RequestAction>selected</cfif>>#RequestActionName#</option>				
	</cfloop>	
</select>

</cfoutput>
