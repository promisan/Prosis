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
<html>
<head>
	<title>Process steps</title>
	<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
</head>

<cfparam name="URL.Confirm" default="">
<cfset init = "0">

<cfloop index="ID" list="#URL.Confirm#" delimiters=",">

    <cfif init eq "0">
	
		<cfquery name="Object" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT O.*, R.*, C.EnableEMail as ClassMail
		 FROM OrganizationObject O, 
		      OrganizationObjectAction A, 
		      Ref_Entity R, 
			  Ref_EntityClass C
		 WHERE A.ActionId = '#ID#'
		 AND O.Objectid = A.ObjectId
		 AND O.EntityCode  = R.EntityCode
		 AND O.EntityCode  = C.EntityCode 
		 AND O.EntityClass = C.EntityClass
		 AND O.Operational  = 1
		</cfquery>
		
		<cfset key1     = "#Object.ObjectKeyValue1#">
		<cfset key2     = "#Object.ObjectKeyValue2#">
		<cfset key3     = "#Object.ObjectKeyValue3#">
		<cfset key4     = "#Object.ObjectKeyValue4#">
		
		<cfset ObjectId = "#Object.ObjectId#">
		
		<cfset keyname1 = "#Object.EntityKeyField1#">
		<cfset keyname2 = "#Object.EntityKeyField2#">
		<cfset keyname3 = "#Object.EntityKeyField3#">
		<cfset keyname4 = "#Object.EntityKeyField4#">
	
	</cfif>
	
	<cfset CLIENT.prepS = now()>

	<!--- looping through the selected steps --->

	<cfquery name="Action" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT *
		 FROM OrganizationObjectAction 		
		 WHERE ActionId = '#ID#' 
		 ORDER BY OfficerDate DESC
	</cfquery>
	
	<cfquery name="Step" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT *
		 FROM Ref_EntityAction
		 WHERE ActionCode = '#Action.ActionCode#' 		
	</cfquery>
		
    <cfif Action.OfficerDate gte #CLIENT.Preps#>
	
		<cf_alert 
		   message="This document was processed by #Action.OfficerFirstName# #Action.OfficerLastName# on #DateFormat(Action.OfficerDate,CLIENT.DateFormatShow)# at <b>#TimeFormat(Action.OfficerDate,'HH:MM:SS')#.Document does NOT require further action by you.">
		   <cfabort>
	   
	</cfif>	
		
	<!--- condition script --->
	
	<cfparam name="Form.actionStatus" default="2">
	
	<cfif Form.actionStatus gte "2">
		  
		  <cf_ProcessActionMethod
				methodname       = "Condition"
				location         = "Text"
				ObjectId         = "#Object.ObjectId#"
				ActionId         = "#Action.ActionId#"
				actioncode       = "#Action.ActionCode#"
				actionpublishno  = "#Action.ActionPublishNo#">						
		 
	</cfif>
	
	<!--- condition script --->
	
	<cf_ProcessActionMethod
		methodname       = "Submission"
		Location         = "Text"
		ObjectId         = "#Object.ObjectId#"
		ActionId         = "#Action.ActionId#"
		actioncode       = "#Action.ActionCode#"
		actionpublishno  = "#Action.ActionPublishNo#">		
		
	<cf_ProcessActionMethod
		methodname       = "Submission"
		Location         = "File"
		ObjectId         = "#Object.ObjectId#"
		ActionId         = "#Action.ActionId#"
		actioncode       = "#Action.ActionCode#"
		actionpublishno  = "#Action.ActionPublishNo#">						
			
	<cfif Action.ActionStatus eq "2">
	   <cfset act = "0">
	<cfelse>
	   <cfif Step.ActionType eq "Action">
	   <cfset act = "2">   
	   <cfelse>
	   <cfset act = "2Y">   
	   </cfif>
	</cfif>
		
	<cfquery name="Update" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 UPDATE OrganizationObjectAction 		
		 SET    ActionStatus     = '#act#',
			    OfficerUserId    = '#SESSION.acc#',
			    OfficerLastName  = '#SESSION.last#',
			    OfficerFirstName = '#SESSION.first#',
			    OfficerDate      = getDate()
		 WHERE  ActionId         = '#ID#' 
	</cfquery>
	
	<!--- define next action and eMail notification --->
		
	<cfinclude template="ProcessActionMailTrigger.cfm">
						
</cfloop>	

<cfoutput>

<cfif url.myentity neq "">
	<cfoutput>
		<script>			    		
			try {		
				parent.opener.document.getElementById('#url.myentity#ref').click()
				<!--- does not work properly opener.parent.close() --->
			} catch(e) {}
		</script>			
	</cfoutput>
</cfif>

<cfif url.ajaxid neq "">

	 <script>
	 	workflowreload('#url.ajaxid#')		
	 </script>

<cfelse>

	<cfset ref = replace("#url.ref#","|","&","ALL")>

	<cftry>
	
		<cfif CGI.HTTPS eq "off">
	      <cfset protocol = "http">
		<cfelse> 
		  <cfset protocol = "https">
		</cfif>
	
		<script language="JavaScript">
			window.location = "#protocol#://#CGI.HTTP_HOST##ref#"
		</script>
	
	<cfcatch></cfcatch>
	</cftry>
	
</cfif>	

</cfoutput>
