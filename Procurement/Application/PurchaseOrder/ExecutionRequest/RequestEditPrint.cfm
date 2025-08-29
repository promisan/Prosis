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
<cfquery name="PO" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Distinct RC.ExecutionTemplate
    FROM   
	Purchase P, 
	PurchaseExecution PE, 
	PurchaseExecutionRequest PER,
	Ref_OrderClass RC
	WHERE  P.PurchaseNo=PE.PurchaseNo
	and PER.PurchaseNo=PE.PurchaseNo
	and PER.ExecutionId=PE.ExecutionId
	and PER.RequestId='#URL.ID#'
	and RC.Code=P.OrderClass
</cfquery>


<cfoutput>

<cfif PO.ExecutionTemplate neq "">

		
	<cfset path = replaceNoCase(PO.ExecutionTemplate,'\','\\','ALL')> 

	<script>	 	 
		 window.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id=print&ID1='#url.id#'&ID0=#path#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	</script>

<cfelse>
	<cf_tl id="No print format defined" var="1">
	<script>
	   alert("#lt_text#");
	</script>

</cfif>

</cfoutput>