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
<cf_screentop height="100%" html="No" scroll="No">

<cfoutput>

<script language="JavaScript">
	
	function memo(topic,row) {
		
		se   = document.getElementById(topic+row);
				
		if (se.className =="hide") {		   
			 se.className  = "regular";						 
			 } else {		   
		   	 se.className  = "hide";
		 }
	}
		 
	function print(id) {
		  w = #CLIENT.width# - 100;
		  h = #CLIENT.height# - 140;
		  window.open("eMail/eMailPrint.cfm?id="+id,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	  	}
	 
</script>	 

<cf_listingscript>

<cfsavecontent variable="myquery">
    SELECT *
	FROM (
		SELECT    M.*, 
		         (SELECT OfficerLastName FROM System.dbo.BroadCast WHERE BroadcastId = M.Functionid) as OfficerLastName
	    FROM     Applicant.dbo.ApplicantMail M 
		WHERE    M.PersonNo = '#URL.ID#'	
		AND      M.MailStatus = '1' ) as B
		WHERE 1=1	
</cfsavecontent>

</cfoutput>

<cfset fields=ArrayNew(1)>
			
<cfset fields[1] = {label      = "Subject", 					
					field      = "MailSubject",
					search     = "text"}>
					
<cfset fields[2] = {label      = "Address",                   
					field      = "MailAddress", 
					special    = "Mail",
					search     = "text"}>
							
<cfset fields[3] = {label      = "Sent",    					
					field      = "MailDateSent",
					formatted  = "dateformat(MailDateSent,CLIENT.DateFormatShow)",
					search     = "date"}>
					
<cfset fields[4] = {label      = "Time",    					
					field      = "MailDateSent",
					formatted  = "timeformat(MailDateSent,'HH:MM')"}>			
					
<cfset fields[5] = {label      = "Officer",    					
					field      = "OfficerLastName",
					filtermode = "2",
					search     = "text"}>								
							
<cf_listing
	    header        = "applicantmail"
	    box           = "applicantmail"
		link          = "#SESSION.root#/Roster/Candidate/Details/eMail/eMailSent.cfm?id=#url.id#"
	    html          = "No"
		tableheight   = "100%"
		listquery     = "#myquery#"
		listorder     = "MailDateSent"
		listorderdir  = "DESC"
		headercolor   = "ffffff"
		filtershow    = "Hide"
		excelshow     = "Yes"
		listlayout    = "#fields#"
		drillmode     = "embed" <!--- embed|window|dialog|standard --->
		drillargument = "540;600;false;false"	
		drilltemplate = "Roster/Candidate/Details/eMail/eMailDetail.cfm"
		drillkey      = "MailId">	
