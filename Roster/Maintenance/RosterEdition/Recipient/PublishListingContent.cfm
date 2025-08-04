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

<cfparam name="url.edition"    default="">

<cfoutput>

	<cfsavecontent variable="myquery">	
	
	SELECT     P.SubmissionEdition, 
	           P.OrgUnit, 
			   O.OrgUnitName, 
			   PM.RecipientName,
			   PM.eMailAddress, 
			   Pm.EditionSent, 
			   P.EditionConfirmed, 
			   PM.ActionStatus, 			   
			   PM.RecipientId
	FROM       Ref_SubmissionEditionPublish AS P INNER JOIN
               Organization.dbo.Organization AS O ON P.OrgUnit = O.OrgUnit INNER JOIN
			   Ref_SubmissionEditionPublishMail AS PM ON PM.SubmissionEdition = P.SubmissionEdition  <!--- only shown if this has a published record indeed --->
				AND P.OrgUnit = PM.OrgUnit
	WHERE      P.SubmissionEdition = '#url.submissionedition#'		 
	</cfsavecontent>	
	
</cfoutput>		

<cfset menu[1] = {label = "Broadcast", icon = "mail.gif", script = "broadcast('#url.submissionedition#','post')"}>				 		

<cfset fields=ArrayNew(1)>

<cfset itm = 1>						
<cfset fields[itm] = {label   = "Organization",                  
					field   = "OrgUnitName",
					filtermode = "2",
					search  = "text"}>						

<cfset itm = itm+1>									
<cfset fields[itm] = {label   = "Name",                  
					field   = "RecipientName",
					filtermode = "0",
					search  = "text"}>									

<cfset itm = itm+1>									
<cfset fields[itm] = {label   = "eMail",                  
					field   = "eMailAddress",
					filtermode = "0",
					search  = "text"}>						

<cfset itm = itm+1>																		
<cfset fields[itm] = {label    = "Sent",					
					field      = "EditionSent",
					search     = "date",
					align      = "center",
					formatted  = "dateformat(EditionSent,'#CLIENT.DateFormatShow#')"}>	
							
<cfset itm = itm+1>									
<cfset fields[itm] = {label   = "Status",                  
					field   = "ActionStatus",
					filtermode = "0",
					search  = "text"}>										
							
<cfset itm = itm+1>				
<cfset fields[itm] = {label    = "Confirmed",  					
					field      = "EditionConfirmed",
					align      = "center",
					formatted  = "dateformat(EditionConfirmed,'#CLIENT.DateFormatShow#')"}>										
					
<cf_listing
    header        = "mybox"
    box           = "EditionBox"
	link          = "#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/PublishListingContent.cfm?submissionedition=#url.submissionedition#"    	
	datasource    = "AppsSelection"
	listquery     = "#myquery#"	
	menu          = "#menu#"	
	listorder     = "OrgUnitName"
	listorderdir  = "ASC"
	listgroup     = "OrgUnitName"
	headercolor   = "ffffff"
	listlayout    = "#fields#"
	filterShow    = "Yes"
	excelShow     = "Yes"
	drillmode     = "embedxt"	
	drilltemplate = "Roster/Maintenance/RosterEdition/Recipient/PublishListingDocument.cfm?submissionedition=#url.submissionedition#&RecipientId="
	drillargument = "940;900;false;false"		
	drillkey      = "RecipientId">
