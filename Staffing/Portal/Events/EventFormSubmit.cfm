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
<cf_assignid>

<cfset dateValue = "">
<CF_DateConvert Value="#dateformat(now(),client.dateformatshow)#">
<cfset dte = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.ActionDateEffective#">
<cfset eff = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#Form.ActionDateExpiration#">
<cfset exp = dateValue>

<cfquery name="qInsert" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">			 
		INSERT INTO PersonEvent
		          (EventId,
				   EventTrigger,
		           EventCode,
		           PersonNo,
		           Mission,
		           ReasonCode,
		           ReasonListCode,    				   
				   <cfif FORM.OrgUnit neq "">
				   OrgUnit,
				   </cfif>					   
				   <cfif FORM.PositionNo neq "">
				   PositionNo,
				   </cfif>
				   Source,			   
		           DateEvent,
		           DateEventDue,
				   ActionDateEffective,
				   ActionDateExpiration,
		           ActionStatus,			           
		           OfficerUserId,
		           OfficerLastName,
		           OfficerFirstName)
		VALUES  ('#rowguid#',
		         '#FORM.Trigger#',
		         '#FORM.EventCode#',
		         '#FORM.PersonNo#',
		         '#FORM.Mission#',		         
		         '#FORM.Reason#',
		         '#FORM.ReasonList#',				
				 <cfif FORM.OrgUnit neq "">
				     '#FORM.OrgUnit#',
				 </cfif>	
				 <cfif FORM.PositionNo neq "">
			         '#FORM.PositionNo#',
				 </cfif>	 
				 'Portal',				 
		         #dte#,
		         #eff#,
				 #eff#,
				 #exp#,
		         0,			         
		         '#SESSION.acc#',
		         '#SESSION.last#',
		         '#SESSION.first#')
	</cfquery>
	
	<cfset url.personNo       = form.PersonNo>
	<cfset url.mission        = form.Mission>
	<cfset url.trigger        = form.trigger>
	<cfset url.eventcode      = form.eventcode>
	<cfset url.reasoncode     = form.reason>
	<cfset url.reasonlistcode = form.reasonlist>
	
	<cfinclude template="EventBaseReasonWorkflow.cfm">

<script>
		
	ProsisUI.closeWindow('evdialog')

</script>
