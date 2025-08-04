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

<cfparam name="Form.Workgroup"   default="">
<cfparam name="Form.ExecutionId" default="">
<cfparam name="Form.PurchaseNo"  default="">

<cfif Form.PurchaseNo eq "">

	<script>
		alert("No purchase order selected. Operation aborted")
	</script>
	<cfabort>

</cfif>

<cfquery name="Purchase" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Purchase
	WHERE PurchaseNo = '#Form.PurchaseNo#'	
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#Purchase.Mission#'
</cfquery>

<cfif Parameter.ExecutionRequestReferenceCheck eq "1">
	<cfset url.Reference=Form.Reference>
	<cfset url.RequestId=URL.Id>
	<cfinclude template="RequestReferenceCheck.cfm">

</cfif>

<cfif not LSIsNumeric(Form.RequestAmount)>

	<script>
		alert("Incorrect amouunt. Operation aborted.")
	</script>
	<cfabort>

</cfif>

<cfset amt = replace("#form.requestamount#",",","","ALL")>

<cfif Form.ExecutionId eq "">
	<script>
		alert("No funding selected. Operation aborted.")
	</script>
	<cfabort>
</cfif>

<cfquery name="Budget" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   PurchaseExecution
	WHERE  ExecutionId = '#form.ExecutionId#'	
</cfquery>

<cfif budget.amount lte "0">
		<script>
		alert("Problem, budget can not be determined. Operation aborted.")
	</script>
	<cfabort>
   
</cfif>

<cftransaction>
		
	<!--- details --->
	
	<cfquery name="Clear" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM PurchaseExecutionRequestDetail
		WHERE RequestId = '#URL.Id#'
	</cfquery>
			
	<cfquery name="Populate" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    INSERT INTO PurchaseExecutionRequestDetail
				(RequestId,DetailDescription,DetailReference,DetailQuantity,DetailRate)
	    SELECT  '#url.id#',DetailDescription,DetailReference,DetailQuantity,DetailRate
	    FROM    UserQuery.dbo.#SESSION.acc#ExecutionRequest_#client.sessionNo# 	
	</cfquery>		
	
	<cfquery name="Update" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE PurchaseExecutionRequest
			 SET    RequestAmount         = '#amt#', 
			        RequestDescription    = '#Form.RequestDescription#',
				    Reference             = '#Form.Reference#', 
				    Remarks               = '#Form.Remarks#', 
			        Period                = '#Form.Period#',
					ProgramCode           = '#Form.ProgramCode#',
					PurchaseNo            = '#Form.PurchaseNo#',
					ExecutionId           = '#Form.ExecutionId#'
			 WHERE  RequestId = '#URL.Id#'	
	</cfquery>	
	
		
	<cfquery name="Reserved" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT sum(RequestAmount) as Amount 
			FROM   PurchaseExecutionRequest
			WHERE  ExecutionId = '#Form.ExecutionId#'	
			AND    ActionStatus != '9'
	</cfquery>
	
	<cfif reserved.amount eq "0" or reserved.amount eq "">
	    <cfset res = 0>
	<cfelse>
	    <cfset res = reserved.amount>  
	</cfif>
	
	<cfif Budget.Amount lt res>
	
		<script>
			alert("Insufficient funds. Operation aborted.")
		</script>
		<CFABORT>
	
	</cfif>	

</cftransaction>

<cfquery name="Update" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE OrganizationObject
	 SET    EntityGroup       = '#Form.Workgroup#'
	 WHERE  ObjectKeyValue4   = '#URL.Id#'	
</cfquery>	

<cfoutput>

	<script>

	  try {	
			parent.opener.applyfilter('','','#URL.Id#');
		} catch(e) {}   
		
	  try {
	  	  parent.opener.editRequestRefresh('#URL.Id#'); 	
		} catch(e) {}  
		
	  parent.window.close();
	  
	</script>
	
</cfoutput>