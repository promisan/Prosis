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
<cfoutput>

<cf_param name="URL.Id"     		default=""  type="String">
<cf_param name="URL.AjaxId"    		default=""  type="String">
<cf_param name="URL.ApplicantNo"    default=""  type="String">
<cf_param name="URL.ListOrder"      default=""  type="String">

<cfquery name="qProcess" 
	datasource="AppsSystem">
		SELECT 	Max(Created) as StartDate
		FROM	Ref_ModuleControl
		WHERE	SystemModule	= 'SelfService'
		AND		FunctionClass	= '#url.id#'
		AND		MenuClass		= 'Process'
		AND		Operational		= 1
</cfquery>

<cfset StartDate = qProcess.StartDate>

<cfquery name="submission" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     ApplicantSubmission A
	WHERE    ApplicantNo = '#url.applicantNo#' 
</cfquery>

<cfsavecontent variable="myquery">
    SELECT *
	FROM (
		SELECT    M.*, 
		         (SELECT OfficerLastName FROM System.dbo.BroadCast WHERE BroadcastId = M.Functionid) as OfficerLastName,
				 (SELECT count(*)        FROM Organization.dbo.OrganizationObject O WHERE M.MailId = O.ObjectKeyValue4) as OpenMode
	    FROM     Applicant.dbo.ApplicantMail M 		 
		WHERE    M.PersonNo = '#Submission.PersonNo#'			
		AND      M.MailStatus = '1' ) as B
		WHERE 1=1	
		<cfif startDate neq "">
			AND MailDateSent >= '#StartDate#'			
		</cfif>
</cfsavecontent>

</cfoutput>

<cfset fields=ArrayNew(1)>

<cfset itm = 1>												
<cfset fields[itm] = {labelfilter  = "Open", 	                   
					 field         = "OpenMode",					
					 filtermode    = "3",    					 
					 align         = "center",
					 formatted     = "Class",
					 classlist     = "0=labelbold"}>	
					 
<cfset itm = itm+1>			
<cfset fields[itm] = {label      = "Subject", 					
					 field      = "MailSubject",
					 search     = "text"}>
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label      = "Addressee",                   
					 field      = "MailAddress", 
					 special    = "Mail",
					 search     = "text"}>
				 					 
<cfset itm = itm+1>									
<cfset fields[itm] = {label      = "Sent",    					
					 field      = "MailDateSent",										 
					 formatted  = "dateformat(MailDateSent,CLIENT.DateFormatShow)"}>

<cfset itm = itm+1>							
<cfset fields[itm] = {label      = "Time",    					
					 field      = "MailDateSent",
					 formatted  = "timeformat(MailDateSent,'HH:MM')"}>			
							
<cf_listing header             = "applicantmail"
		    box                = "applicantmail"
			link               = "#SESSION.root#/Roster/PHP/Messaging/MessagingContent.cfm?applicantno=#url.applicantno#&id=#url.id#"
		    html               = "No"
			tableheight        = "100%"
			listquery          = "#myquery#"
			listorder          = "MailDateSent"
			listorderdir       = "DESC"
			headercolor        = "ffffff"			
			filtershow         = "Yes"
			excelshow          = "No"
			show               = "25"
			listlayout         = "#fields#"
			navtarget          = "messaging"
			navtemplate        = "Roster/PHP/Messaging/MessagingWorkflow.cfm?ajax=yes&id=#url.id#"
			drillmode          = "embed" <!--- embed|window|dialog|standard --->
			drillargument      = "540;600;false;false"	
			drilltemplate      = "Roster/Candidate/Details/eMail/eMailDetail.cfm"
			drillkey           = "MailId">	
			