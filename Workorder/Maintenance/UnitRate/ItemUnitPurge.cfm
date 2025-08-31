<!--
    Copyright © 2025 Promisan B.V.

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
<cfquery name="verifyDelete" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 *
	FROM   WorkOrderLineBillingDetail
	WHERE  ServiceItem     = '#URL.ID1#'
	AND    ServiceItemUnit = '#URL.ID2#'
</cfquery>	


<cfquery name="verifyBaseLine" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 *
	FROM   WorkOrderBaseLineDetail
	WHERE  ServiceItem     = '#URL.ID1#'
	AND    ServiceItemUnit = '#URL.ID2#'
</cfquery>	

<cfif verifyDelete.recordCount eq "0" and verifyBaseLine.recordcount eq "0">	
		
	<cfquery name="Delete" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM ServiceItemUnit
		WHERE  ServiceItem = '#URL.ID1#'
		AND    Unit        = '#URL.ID2#'
	</cfquery>
	
<cfelse>

	<script>
		alert("Service unit record is in use. Action aborted")
	</script>	
	<!---- records is in use --->	
	
</cfif>

<cfoutput>

	<script language="JavaScript">   
		ColdFusion.navigate('#SESSION.root#/workorder/maintenance/unitRate/ItemUnitListing.cfm?ID1=#URL.ID1#','contentbox2')
	</script> 
	
</cfoutput>