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
<cfparam name="Form.workorderid_#left(url.workorderid,8)#" default="">

<cfset sel = evaluate("Form.workorderid_#left(url.workorderid,8)#")>
<cfset mem = evaluate("Form.workordermemo_#left(url.workorderid,8)#")>

<cfif sel eq "">

	<cfquery name="Delete" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM Employee.dbo.PositionWorkorder
	    WHERE  PositionNo = '#URL.PositionNo#'
        AND    WorkOrderId = '#url.workorderid#'
	</cfquery>	
	
	<cfoutput>
	<script>
	  document.getElementById('workordermemo_#left(url.workorderid,8)#').className = "hide"
	</script>
	</cfoutput>

<cfelse>

	<cfoutput>
	<script>
	  document.getElementById('workordermemo_#left(url.workorderid,8)#').className = "regular"
	</script>
	</cfoutput>

	<cfquery name="get" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Employee.dbo.PositionWorkorder
	    WHERE  PositionNo = '#URL.PositionNo#'
        AND    WorkOrderId = '#url.workorderid#'
	</cfquery>	
	
	<cfif get.recordcount eq "0">
	
	<cfquery name="insert" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Employee.dbo.PositionWorkorder
		(PositionNo, WorkOrderId,Memo,OfficerUserId,OfficerLastName,OfficerFirstName)
		VALUES
		('#url.positionno#','#url.workorderid#','#mem#','#session.acc#','#session.last#','#session.first#')
	</cfquery>		
	
	<cfelse>
	
	<cfquery name="update" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Employee.dbo.PositionWorkorder
		SET    Memo = '#mem#'
	    WHERE  PositionNo = '#URL.PositionNo#'
        AND    WorkOrderId = '#url.workorderid#'
	</cfquery>	
	
	</cfif>
	

</cfif>