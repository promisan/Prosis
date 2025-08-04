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

<cfoutput>

<cfsavecontent variable="myquery">    

        SELECT *
		FROM
		
			(
	    
			SELECT   M.*,
			
					 (
					  SELECT count(*) 
					  FROM   Organization.dbo.OrganizationObject O 
					  WHERE  M.MailId = O.ObjectKeyValue4) as WorkflowMode,
					  
					 (
						SELECT   TOP 1 R.Created
						FROM	 Organization.dbo.OrganizationObject O,
						         Organization.dbo.OrganizationObjectActionMail R
						WHERE    O.ObjectKeyValue4 = M.MailId 
						AND      O.ObjectId        = R.ObjectId     
						AND		 R.MailType        = 'Comment'
						ORDER BY R.Created DESC
					 ) AS LastResponse
					 
		    FROM     userQuery.dbo.#session.acc#ApplicantMail M		
			
			) as Subtable
			
			
		
		WHERE 1=1
		
		--condition
						
</cfsavecontent>


<!--- filter by candidate, name, indexno, galaxyNo
we show only message that are newer than 5 month or messages that have a response newer than 5 month
we load the table initially thus limit query on the database repeatedly
 --->

</cfoutput>

<cfset fields=ArrayNew(1)>

<cfset itm="0">

<cfset itm = itm+1>												
<cfset fields[itm] = {labelfilter  		= "Open", 	                   
					 field         		= "WorkflowMode",					
					 filtermode    		= "3",    
					 search        		= "text",
					 align         		= "center",
					 formatted     		= "Rating",
					 ratinglist    		= "1=Green,0=Red"}>	
					 
<cfset itm = itm+1>							
<cfset fields[itm] = {label        		= "Candidate",                   
					 field         		= "Name", 	
					 functionscript		= "ShowCandidate",
					 functionfield 		= "PersonNo",						
					 search        		= "text"}>	
					 
<cfset itm = itm+1>									
<cfset fields[itm] = {labelfilter 		= "Last response",
					 label      		= "Response",    					
					 field      		= "LastResponse",
					 formatted  		= "dateformat(LastResponse,CLIENT.DateFormatShow)",
					 search     		= "date"}>				
					 
<cfset itm = itm+1>							
<cfset fields[itm] = {label      		= "Time",    					
					 field      		= "LastResponse",
					 formatted  		= "timeformat(LastResponse,'HH:MM')"}>									 	 				 
					 
<cfset itm = itm+1>			
<cfset fields[itm] = {label       		= "Subject", 					
					 field        		= "MailSubject",
					 search       		= "text"}>					

<cfset itm = itm+1>									
<cfset fields[itm] = {label      		= "Sent",    					
					 field      		= "MailDateSent",
					 formatted  		= "dateformat(MailDateSent,CLIENT.DateFormatShow)",
					 search     		= "date"}>
							
<cf_listing
	    header             = "applicantmail"
	    box                = "applicantmail"
		link               = "#SESSION.root#/Roster/RosterGeneric/Messaging/MessagingListingContent.cfm?systemfunctionid=#url.systemfunctionid#&owner=#url.owner#"
	    html               = "No"
		tableheight        = "100%"
		listquery          = "#myquery#"
		listorder          = "LastResponse"
		listorderdir       = "DESC"
		headercolor        = "ffffff"
		filtershow         = "Hide"
		excelshow          = "Yes"
		show               = "25"
		listlayout         = "#fields#"
		navtarget          = "messaging"
		navtemplate        = "Roster/PHP/Messaging/MessagingWorkflow.cfm"
		drillmode          = "embed" <!--- embed|window|dialog|standard --->
		drillargument      = "540;600;false;false"	
		drilltemplate      = "Roster/Candidate/Details/eMail/eMailDetail.cfm"
		drillkey           = "MailId">	
		
