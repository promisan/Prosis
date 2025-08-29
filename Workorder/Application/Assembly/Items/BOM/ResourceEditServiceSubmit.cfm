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
<cfif URL.ResourceId eq "">

	<!---- adding it up ---->
	
	<cfquery name="qCheck" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM WorkOrderLineResource
		WHERE WorkOrderId  = '#URL.WorkOrderId#'
		AND WorkOrderLine  = '#URL.WorkOrderLine#'
		AND ResourceItemNo = '#FORM.ItemNo#'
		AND ResourceUoM    = '#FORM.UoM#'	 
	</cfquery>		

	<cfif qCheck.recordcount eq 0>
	
		<cf_AssignId>
		<cfset resourceid = rowguid>	
		
		<cfquery name="qAdd" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	 
		INSERT INTO WorkOrderLineResource
	           (ResourceId
	           ,WorkOrderId
	           ,WorkOrderLine
	           ,ResourceItemNo
	           ,ResourceUoM
	           ,ResourceMode
	           ,Quantity
	           ,Price
	           ,Memo
	           ,OfficerUserId
	           ,OfficerLastName
	           ,OfficerFirstName)
	     VALUES
	           ('#resourceid#'
	           ,'#url.workorderid#'
	           ,'#url.workorderline#'
	           ,'#FORM.ItemNo#'
	           ,'#FORM.uom#'
	           ,'#FORM.ResourceMode#'
	           ,'#FORM.Quantity#'
	           ,'#FORM.Price#'
	           ,'#FORM.Remarks#'
	           ,'#SESSION.acc#'
	           ,'#SESSION.Last#'
	           ,'#SESSION.First#')
		</cfquery>		

		<script>
		    parent.applyfilter(1,'','content');
			parent.ColdFusion.Window.destroy('myservice',true)	
		</script>	

	<cfelse>

		<script>
			alert('Service class Item already exists for this workorder')
		</script>		
			
	</cfif>
	
</cfif>