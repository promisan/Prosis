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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.FinalClaimExpress"  default="0">
<cfparam name="Form.FinalClaimDetailed" default="1">
<cfparam name="Form.DSAModeDefine" default="1">

<!--- check logon section --->

   <cfset dateValue = "">
		<CF_DateConvert Value="#DateFormat(Form.SourceDateCutOff,CLIENT.DateFormatShow)#">
		<cfset CUT = dateValue>


<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="AppsTravelClaim"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Parameter
	SET  ClaimRequestPrefix = '#Form.ClaimRequestPrefix#', 
	     ClaimPrefix        = '#Form.ClaimPrefix#', 
		 ClaimNo            = '#Form.ClaimNo#', 
		 ExportNo           = '#Form.ExportNo#', 
		 Consolidation      = '#Form.Consolidation#', 
		 PortalURL          = '#Form.PortalURL#',
		 DaysExpiration     = '#Form.DaysExpiration#', 
		 DocumentLibrary    = '#Form.DocumentLibrary#', 
		 DocumentURL        = '#Form.DocumentURL#', 
		 TemplateRoot       = '#Form.TemplateRoot#', 
		 TemplateHome       = '#Form.TemplateHome#', 
		 DSARate999         = '#Form.DSARate999/100#', 
		 WorkflowSelect     = '#Form.WorkflowSelect#', 
		 ReturnReminder     = '#Form.ReturnReminder#',
		 PortalMailAddress  = '#Form.PortalmailAddress#',
		 ReturnReminderInterval = '#Form.ReturnReminderInterval#',
		 ShowUserValidation = '#Form.ShowUserValidation#',
		 WorkflowClass      = '#Form.WorkflowClass#', 
		 EnforceIncomplete  = '#Form.EnforceIncomplete#',
		 FinalClaimDetailed = '#Form.FinalClaimDetailed#',
		 FinalClaimExpress  = '#Form.FinalClaimExpress#',
		 EnableGMTTime      = '#Form.EnableGMTTime#',
		 Enable10_24DSA     = '#Form.Enable10_24DSA#',
		 ClaimTolerance     = '#Form.ClaimTolerance#',
		 NonobligatedThreshold= '#Form.Nonobligatedthreshold#',
		 EnableActorSubmit  = '#Form.EnableActorSubmit#',
		 AliasSourceData    = '#Form.AliasSourceData#', 
		 SourceServer       = '#Form.SourceServer#',
		 StopOverHours      = '#Form.StopOverHours#',
		 SourceDatabase     = '#Form.SourceDatabase#', 
		 SourceSchema       = '#Form.SourceSchema#',
		 <!---
		 DSAModeDefine      = '#Form.DSAModeDefine#',
		 --->
		 SourceDateCutOff   = #cut#,
		 ModeDebug          = '#Form.ModeDebug#',
		 TreeUnit           = '#Form.TreeUnit#',
		 LogonDataSource    = '#Form.LogonDataSource#',
		 LogonTableName     = '#Form.LogonTableName#',
		 Identification1    = '#Form.Identification1#',
		 Identification2    = '#Form.Identification2#',
		 Identification3    = '#Form.Identification3#',
		 LogonEnforce       = '#Form.LogonEnforce#'
	</cfquery>

	<cfoutput>

		<cf_message status="System" 
		   message="Parameters have been updated" 
		   return="ParameterEdit.cfm?idmenu=#URL.IDMenu#">
	   </cfoutput>
  
<cfelse> 

	<cflocation url="../../Menu.cfm" addtoken="No">
 
</cfif>	
	
