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
<cfparam name="Form.CustomDialog" default="">

<cfif url.id2 eq "">

	<cfquery name="Verify" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
		SELECT 	*
		FROM   	Ref_RequestWorkflow
		WHERE 	RequestType = '#Form.RequestType#'
		AND 	RequestAction = '#Form.RequestAction#'
	</cfquery>
	
	<cfif Verify.recordcount gt 0>
	
		<script language="JavaScript">alert("A record with this request type and action has been registered already!")</script>  
	
	<cfelse>
	
		<cfquery name="Insert" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_RequestWorkflow
		           (RequestType,
		           RequestAction,
		           RequestActionName,
		           <cfif trim(Form.CustomForm) neq "">CustomForm,</cfif>
		           <cfif trim(Form.CustomFormCondition) neq "">CustomFormCondition,</cfif>
				   <cfif trim(Form.EntityClass) neq "">EntityClass,</cfif>	           
		           Operational,
		           OfficerUserId,
		           OfficerLastName,
		           OfficerFirstName)
		     VALUES
		           ('#Form.RequestType#',
				   '#Form.RequestAction#',
				   '#Form.RequestActionName#',
		           <cfif trim(Form.CustomForm) neq "">'#Form.CustomForm#',</cfif>
		           <cfif trim(Form.CustomFormCondition) neq "">'#Form.CustomFormCondition#',</cfif>
				   <cfif trim(Form.EntityClass) neq "">'#Form.EntityClass#',</cfif>
		           #Form.operational#,
				   '#SESSION.acc#',
				   '#SESSION.last#',
				   '#SESSION.first#')
		
		</cfquery>
		
		
		<cfoutput>
			<script>
				ColdFusion.Window.hide('mydialog'); 	
				ColdFusion.navigate('RequestWorkflowListing.cfm?ID1=#url.id1#','listing');
			</script>
		</cfoutput>
	
	</cfif>
		  
<cfelse>

	<cfquery name="Update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_RequestWorkflow
			SET 
			      RequestAction        = '#Form.RequestAction#',
				  RequestActionName    = '#Form.RequestActionName#',
				  CustomForm           = <cfif trim(Form.CustomForm) eq "">null<cfelse>'#Form.CustomForm#'</cfif>,
				  CustomFormCondition  = <cfif trim(Form.CustomFormCondition) eq "">null<cfelse>'#Form.CustomFormCondition#'</cfif>,
				  EntityClass          = <cfif trim(Form.EntityClass) eq "">null<cfelse>'#Form.EntityClass#'</cfif>,
				  Operational          = #Form.operational#
			WHERE RequestType          = '#Form.RequestType#'
			AND   RequestAction        = '#Form.RequestActionOld#'
	</cfquery>
	
	
	<cfset url.type = url.id1>
	<cfset url.action = url.id2>
	<cfinclude template="RequestWorkflowWarehouseMultipleSubmit.cfm">
	
	<cfoutput>
		<script>
			ColdFusion.Window.hide('mydialog'); 	
			ColdFusion.navigate('RequestWorkflowListing.cfm?ID1=#url.id1#','listing');
		</script>
	</cfoutput>

</cfif>