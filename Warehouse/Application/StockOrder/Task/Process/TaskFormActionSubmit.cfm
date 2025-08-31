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
<cfquery name="get" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT * 
	FROM   RequestTask
	WHERE  TaskId = '#url.taskid#'	
</cfquery>	 

<cfparam name="Form.Warehouse"        default="">
<cfparam name="Form.Location"         default="">
<cfparam name="Form.PersonNo"         default="">
<cfparam name="Form.PersonFirstName"  default="">
<cfparam name="Form.PersonLastName"   default="">

<cfparam name="PersonFirstName"  default="#Form.PersonFirstName#">
<cfparam name="PersonLastName"   default="#Form.PersonLastName#">

<cfif Form.PersonNo neq "">
		  	  
	<cfquery name="Person" 
	  datasource="AppsEmpkloyee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   PersonNo
		WHERE  PersonNo = '#Form.PersonNo#'	
	</cfquery>	
	
	<cfif Person.recordcount eq "1">
	
		<cfset PersonLastName  = Person.LastName>
		<cfset PersonFirstName = Person.FirstName>
	
	</cfif>

</cfif>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.TransactionDate#">
<cfset dte = dateValue>

<cfset dte = DateAdd("h","#form.Transaction_hour#", dte)>
<cfset dte = DateAdd("n","#form.Transaction_minute#", dte)>

<cfif url.action eq "add">
	
	<cfquery name="InsertAction" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    INSERT INTO RequestTaskAction
				(RequestId, 
				 TaskSerialNo, 
				 ActionCode, 
				 <cfif form.warehouse neq "">
				 ActionWarehouse,
				 ActionLocation,
				 </cfif>
				 DateTimePlanning, 
				 ActionMemo, 
				 PersonNo,
				 PersonLastName,
				 PersonFirstName,
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)
		VALUES  ('#get.RequestId#',
				 '#get.TaskSerialNo#',
				 '#form.actioncode#',
				 <cfif form.warehouse neq "">
				 '#form.Warehouse#',
				 '#form.Location#',
				 </cfif> 
				 #dte#,
				 '#form.ActionMemo#',
				 '#form.personno#',
				 '#PersonLastName#',
				 '#PersonFirstName#',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')  	
	</cfquery>	

<cfelse>

	<cfquery name="InsertAction" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    UPDATE RequestTaskAction
		SET    ActionCode       = '#form.actioncode#',
		       DateTimePlanning = #dte#,
			   ActionMemo       = '#form.ActionMemo#',
			   PersonNo         = '#form.PersonNo#',
			   PersonLastName   = '#PersonLastName#',
			   PersonFirstName  = '#PersonFirstName#',
			   <cfif FORM.warehouse neq "">
				   ActionWarehouse  = '#Form.Warehouse#',
				   ActionLocation   = '#Form.Location#'			   
			   </cfif>
		WHERE TaskActionId = '#url.actionid#'			
	</cfquery>	

</cfif> 
 	
<cfoutput>
<script language="JavaScript">
   _cf_loadingtexthtml="";	
  try {		
  ColdFusion.Window.hide('dialogprocesstask')
  } catch(e) {}
  // refresh the content of the receipts
  ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskProcessDetail.cfm?taskid=#url.taskid#&actormode=#url.actormode#','box#url.taskid#')
  // update the status in the view on the line level
  se = document.getElementById('status#url.taskid#')
  if (se) {
  ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Task/Process/TaskViewStatus.cfm?taskid=#url.taskid#&actormode=#url.actormode#','status#url.taskid#')
  }
   _cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";	
</script>
</cfoutput>
	

	  

