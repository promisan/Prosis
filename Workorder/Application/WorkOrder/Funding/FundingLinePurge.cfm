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

<cfquery name="get" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   WorkOrderFunding
		WHERE  FundingDetailId = '#URL.ID2#'
	</cfquery>

	<cfquery name="Delete" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE WorkOrderFunding
		SET    Operational = 0
		WHERE  FundingDetailId = '#URL.ID2#'			
	</cfquery>
	
<cfif url.billingdetailid neq "">
	 <cfset url.id2 = "">
</cfif>

<cfif get.workorderline eq "">
	
		<cfinclude template="FundingLine.cfm">
	
<cfelse>

	<cfoutput>
		 <script>
	    	 ColdFusion.navigate('../ServiceDetails/Billing/DetailBillingList.cfm?workorderid=#URL.workorderid#&workorderline=#get.workorderline#','billingdata')
		 </script>
		</cfoutput> 	 
		
</cfif>



