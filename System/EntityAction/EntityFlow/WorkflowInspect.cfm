<cf_compression>

<cfparam name="url.PublishNo" default="">
<cfparam name="url.ActionCode" default="xxxx">
<cfparam name="url.EntityClass" default="LIC">
<cfparam name="url.EntityCode" default="Procjob">

<cfif URL.PublishNo eq "">
	
		<cfquery name="Get" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT A.*, D.DocumentDescription, D.DocumentMode
		FROM Ref_EntityClassAction A Left Join Ref_EntityDocument D
			ON A.EntityCode = D.EntityCode AND A.ActionDialog = D.DocumentCode AND D.DocumentType = 'dialog'
		WHERE A.ActionCode  = '#URL.ActionCode#'
		AND   A.EntityClass = '#URL.EntityClass#'
		AND   A.EntityCode  = '#URL.EntityCode#' 
		</cfquery>
		
		<cfquery name="Goto" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_EntityClassActionProcess
		WHERE ActionCode  = '#URL.ActionCode#'
		AND   EntityClass = '#URL.EntityClass#'
		AND   EntityCode  = '#URL.EntityCode#' 
		AND  Operational = 1
		</cfquery>
		
		<cfquery name="Script" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityClassActionScript
		WHERE  ActionCode  = '#URL.ActionCode#'
		AND    EntityClass = '#URL.EntityClass#'
		AND    EntityCode  = '#URL.EntityCode#' 
		AND    MethodEnabled = 1	
		</cfquery>
			
	<cfelse>
	
		<cfquery name="Get" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT A.*, D.DocumentDescription, D.DocumentMode
		FROM Ref_EntityActionPublish A Left Join Ref_EntityDocument D
			ON A.ActionDialog = D.DocumentCode AND D.DocumentType = 'dialog'
		WHERE A.ActionCode    = '#URL.ActionCode#'
		AND  A.ActionPublishNo = '#URL.PublishNo#'	
		</cfquery>
		
		<cfquery name="Goto" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM  Ref_EntityActionPublishProcess
		WHERE ActionCode    = '#URL.ActionCode#'
		AND   ActionPublishNo = '#URL.PublishNo#'	
		AND  Operational = 1
		</cfquery>
		
		<cfquery name="Script" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityActionPublishScript
		WHERE  ActionCode    = '#URL.ActionCode#'
		AND    ActionPublishNo = '#URL.PublishNo#'	
		AND    MethodEnabled = 1		
		</cfquery>
		
		
	
</cfif>	

<cfquery name="Report" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT E.*
  	 FROM   Ref_EntityDocument E, Ref_EntityActionDocument D
     WHERE  E.EntityCode = '#URL.EntityCode#'
	 AND    E.DocumentId = D.DocumentId
	 AND    D.ActionCode = '#URL.ActionCode#'
     AND    E.DocumentType = 'report'
</cfquery>		

<cfquery name="Attach" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT E.*
  	 FROM   Ref_EntityDocument E, Ref_EntityActionDocument D
     WHERE  E.EntityCode = '#URL.EntityCode#'
	 AND    E.DocumentId = D.DocumentId
	 AND    D.ActionCode = '#URL.ActionCode#'
     AND    E.DocumentType = 'attach'
</cfquery>		 

<cfquery name="Field" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT E.*
  	 FROM   Ref_EntityDocument E, Ref_EntityActionDocument D
     WHERE  E.EntityCode = '#URL.EntityCode#'
	 AND    E.DocumentId = D.DocumentId
	 AND    D.ActionCode = '#URL.ActionCode#'
     AND    E.DocumentType = 'field'
</cfquery>		
	

<cfoutput query="get">

<form name="formInspector" id="formInspector">

<table width="100%"
       cellspacing="0"    
	   cellpadding="0"    
       align="center">

<tr class="labelit line" style="height:15px"><td bgcolor="f4f4f4" class="labelit" style="padding-left:5px" width="55%">Code</td>
<td width="45%" style="padding-left:5px"><a href="javascript:stepedit('#URL.EntityCode#','#URL.EntityClass#','#URL.actionCode#','#URL.PublishNo#')"><strong>#ActionCode#</strong></a></td>
</tr>
<tr class="labelit line" style="height:15px"><td bgcolor="f4f4f4" class="labelit" style="padding-left:5px">Action Type</td>
<td style="padding-left:5px">#ActionType#</td>
</tr>
<tr class="labelit line" style="height:15px"><td bgcolor="f4f4f4" class="labelit" style="padding-left:5px">Actor</td>
<td style="padding-left:5px">#ActionReference#</td>
</tr>




<tr class="line labelit"><td colspan="2" style="padding-left:2px;"><b>Process</td></tr>

<tr class="labelit line" style="height:15px"><td  style="padding-top:3px;padding-left:5px" bgcolor="f4f4f4">Quick Process</td>
<cfset Toggle = "enableQuickProcess">

<cfinclude template="WorkflowInspectToggle.cfm">

<tr class="labelit line" style="height:15px"><td  bgcolor="f4f4f4" style="padding-left:5px">Custom Dialog</td>
	<td><cfif ActionDialog neq "">#DocumentDescription# [#DocumentMode#]<cfelse>None</cfif></td>
</tr>

<tr class="labelit line" style="height:15px"><td  bgcolor="f4f4f4" style="padding-left:5px">Passtru Parameter</td>
	<td><cfif ActionDialog neq ""><cfif ActionDialogParameter neq "">#ActionDialogParameter#</b><cfelse>None</cfif><cfelse>N/A</cfif></td>
</tr>

<tr class="labelit line" style="height:15px"><td bgcolor="f4f4f4" style="padding-left:5px" style="padding-left:4px">Attach Document</td>
	<cfset Toggle = "EnableAttachment">
	<cfinclude template="WorkflowInspectToggle.cfm">
	
<tr class="labelit line" style="height:15px"><td style="padding-left:5px"  bgcolor="f4f4f4">Notes</td>
	<cfset Toggle = "EnableTextArea">
	<cfinclude template="WorkflowInspectToggle.cfm">

<tr class="labelit line" style="height:15px"><td style="padding-left:5px"  bgcolor="f4f4f4">Rich Text Editor</td>
	<cfset Toggle = "EnableHTMLEdit">
	<cfinclude template="WorkflowInspectToggle.cfm">

<tr class="labelit line" style="height:15px"><td style="padding-left:5px"  bgcolor="f4f4f4">My Clearances</td>
	<cfset Toggle = "EnableMyClearances">
	<cfinclude template="WorkflowInspectToggle.cfm">
	
<tr class="labelit line" style="height:15px"><td style="padding-left:5px"  bgcolor="f4f4f4">Mail Notification</td>
	<cfset Toggle = "EnableNotification">
	<cfinclude template="WorkflowInspectToggle.cfm">

<tr class="labelit line" style="height:15px"><td  style="padding-left:5px" bgcolor="f4f4f4">Mail Confirmation</td>
	<cfset Toggle = "NotificationManual">
	<cfinclude template="WorkflowInspectToggle.cfm">

<tr class="labelit line" style="height:15px"><td style="padding-left:5px" bgcolor="f4f4f4">Custom mail</td>
	<td><cfif DueMailCode neq "">Yes</b><cfelse>No</cfif></td></tr>

	
	
		
<tr class="line labelit"><td colspan="2" style="padding-left:2px;"><b>Authorization</td></tr>

<tr class="labelit line" style="height:15px"><td bgcolor="f4f4f4" style="padding-top:3px;padding-left:5px" >Access Delegated</td>
	<td><cfif ActionAccess neq "">Yes</b><cfelse>No</cfif></td></tr>

<tr class="labelit line" style="height:15px"><td bgcolor="f4f4f4" style="padding-left:5px" >Limit Delegation</td>
	<td><cfif ActionAccessUserGroup neq "">#ActionAccessUserGroup#</b><cfelse>No</cfif></td></tr>

<tr class="labelit line" style="height:15px"><td bgcolor="f4f4f4" style="padding-left:5px" >Perform by Holder</td>
	<cfset Toggle = "PersonAccess">
	<cfinclude template="WorkflowInspectToggle.cfm">

<tr class="line labelit"><td colspan="2" style="padding-left:2px;"><b>Workflow</td></tr>

<tr class="labelit line" style="height:15px"><td bgcolor="f4f4f4" style="padding-left:5px" >Go To Mode</td>
	<td><cfif ActionGoTo eq 0>Disabled<cfelseif ActionGoTo eq "1">Pending steps<cfelseif ActionGoTo eq "2">Performed<cfelse>All</cfif></td>
</tr>

<tr class="labelit line" style="height:15px"><td bgcolor="f4f4f4" style="padding-left:5px" >No of steps</td>
	<td><cfif ActionGoTo eq 0>0<cfelse><cfif GoTo.Recordcount eq "0">All<cfelse>#GoTo.Recordcount#</cfif></cfif></td>
</tr>



<tr class="line labelit"><td colspan="2" style="padding-left:2px;"><b>Embedded</td></tr>

<tr class="labelit line" style="height:15px"><td bgcolor="f4f4f4" style="padding-left:5px" >Reports</td>
	<td>#Report.recordcount#</td></tr>
<tr class="labelit line" style="height:15px"><td bgcolor="f4f4f4" style="padding-left:5px" >Custom Fields</td>
	<td>#Field.recordcount#</td></tr>
<tr class="labelit line" style="height:15px"><td bgcolor="f4f4f4" style="padding-left:5px" >Attachments</td>
	<td>#Attach.Recordcount#</td></tr>

	
	
<tr class="line labelit"><td colspan="2" style="padding-left:2px;"><b>Mail</td></tr>

<tr class="labelit line" style="height:12px"><td bgcolor="f4f4f4" style="padding-left:5px">Due Mail</td>
	<td><cfif PersonMailCode neq "">
	
	<cfquery name="Object" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM         Ref_EntityDocument
		WHERE     (EntityCode = '#URL.EntityCode#') 
		AND  DocumentType = 'mail'
		AND  DocumentCode = '#PersonMailCode#'
	</cfquery>
	
	#Object.DocumentDescription#</b><cfelse>No</cfif></td></tr>
	
<tr class="labelit line" style="height:12px!force">
   <td bgcolor="f4f4f4" style="padding-left:5px" >Action Mail</td>
	<td><cfif PersonMailAction neq "">
	
	<cfquery name="Object" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM         Ref_EntityDocument
		WHERE     (EntityCode = '#URL.EntityCode#') 
		AND  DocumentType = 'mail'
		AND  DocumentCode = '#PersonMailAction#'
	</cfquery>

	#Object.DocumentDescription#</b><cfelse>No</cfif></td></tr>

<tr class="labelit line" style="height:12px">
    <td bgcolor="f4f4f4" style="padding-left:5px" >Attach Reports</td>
	<td><cfif PersonMailActionAttach eq "1">Yes</b><cfelse>No</cfif></td>
</tr>



<tr class="line labelit"><td colspan="2" style="padding-left:2px;"><b>Miscellaneous</td></tr>
<tr class="labelit line" style="height:18px"><td style="padding-top:4px;padding-left:5px" bgcolor="f4f4f4">Lead time</td>
	<td class="labelit line" style="height:18px">
	<input type="text" 
       name="ActionLeadTime" 
	   id="ActionLeadTime"
	   value="#ActionLeadTime#" 
	   size="1" 
	   style="text-align:center;height:15px"
	   maxlength="3"
	   class="regular"
	   onchange="toggleParam('ActionLeadTime',this.value,'#URL.EntityCode#','#URL.EntityClass#','#URL.ActionCode#','#URL.PublishNo#','Yes')">&nbsp;day
	</td></tr>

<tr class="labelit line" style="height:18px"><td bgcolor="f4f4f4" style="padding-left:5px">Action within</td>
<td style="height:18px">
<input type="text" 
       name="ActionTakeAction" 
	   id="ActionTakeAction"
	   value="#ActionTakeAction#" 
	   size="1" 
	   maxlength="3"
	   style="text-align:center;height:15px"
	   class="regular"
	   onchange="toggleParam('ActionTakeAction',this.value,'#URL.EntityCode#','#URL.EntityClass#','#URL.ActionCode#','#URL.PublishNo#','Yes')">&nbsp;hr	
</td></tr>

<tr class="labelit line" style="height:15px"><td bgcolor="f4f4f4" style="padding-left:5px">Show Reference</td>
	<cfset Toggle = "ActionReferenceShow">
	<cfinclude template="WorkflowInspectToggle.cfm">

	
	
	
<tr class="line labelit"><td colspan="2" style="padding-left:2px;"><b>Events</td></tr>

<tr class="labelit line" style="height:15px"><td bgcolor="f4f4f4" style="padding-top:4px;padding-left:5px">Due status</td>
	<td><cfif DueEntityStatus eq "">N/A<cfelse>#DueEntityStatus#</cfif></td></tr>

	<cfif Script.recordcount gte "1">		
		<tr class="line labelit"><td colspan="2" style="padding-left:2px;"><b>Event Script</td></tr>		
	<cfloop query="Script">
		<cfif len(MethodScript) gt "5" or documentId neq "">
			<tr class="labelit line" style="height:12px">
			<td style="padding-left:5px" bgcolor="f4f4f4">#Method#</td>
			<td><cfif len(MethodScript) gt "5" or documentId neq "">Yes<cfif documentId neq "">&nbsp;(scriptfile)</cfif></b><cfelse>-</cfif></td>
			</tr>
		</cfif>
	</cfloop>

</cfif>

</table>

</form>

</cfoutput>
