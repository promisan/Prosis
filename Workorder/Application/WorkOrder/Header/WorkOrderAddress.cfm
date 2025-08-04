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

<cfquery name="Parameter" 
    datasource="AppsWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        SELECT TOP 1 * 
        FROM  Ref_ParameterMission
</cfquery>

<cfparam name="URL.Mission" default="#Parameter.Mission#"> 
<cfparam name="URL.scope"   default="backoffice"> 

<cfif URL.Mission eq "">
	<cfset URL.Mission = Parameter.Mission>
</cfif>

<cfquery name="Get" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   Wo.*, 
	         SI.Description AS ServiceItemDescription, 			
			 C.OrgUnit,
			 C.CustomerName AS CustomerName, 
             C.Reference AS CustomerReference, 
			 C.PhoneNumber AS CustomerPhoneNo
    FROM     WorkOrder Wo INNER JOIN
             ServiceItem SI ON Wo.ServiceItem = SI.Code INNER JOIN
             Customer C ON Wo.CustomerId = C.CustomerId	INNER JOIN
			 Organization.dbo.Organization O ON C.OrgUnit = O.OrgUnit
	WHERE    Wo.WorkOrderId = '#URL.workorderid#' 
</cfquery>	
		
<cfoutput>	
	
	<cfif get.orgunit neq "">		
	
		<iframe src="../../../../System/Organization/Application/Address/UnitAddress.cfm?id=#get.orgunit#&scope=#url.scope#"
        width="100%" height="99%" frameborder="0">
		</iframe>		
		
	<cfelse>
		
		<table width="100%" cellspacing="0" cellpadding="0" align="center">
			<tr><td height="50"><cf_tl id="Customer not associated to a organization record" class="message"></td></tr>
		</table>
	
	</cfif>	

</cfoutput>	

