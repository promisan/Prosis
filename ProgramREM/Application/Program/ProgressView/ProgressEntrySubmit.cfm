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

<TITLE>Submit Progress report</TITLE>

<!--- <cf_wait Text="Saving"> --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<!--- Query returning search results --->
<cfquery name="Parameter" 
datasource="AppsProgram" >
    SELECT *
    FROM Parameter
</cfquery>

<cfif Parameter.ProgressMemoEnforce eq "1">

	<cfloop index="Rec" from="1" to="#CLIENT.RecordNo#">
	
	<cfset progressstatus      = Evaluate("FORM.progressstatus_" & #Rec#)>
	<cfset progressmemo        = Evaluate("FORM.progressmemo_" & #Rec#)>
	
	<cfif #ProgressStatus# neq "0">
	
    	<cfif Progressmemo eq "">
	       
           <cf_message message = "You have submitted one or more progress reports without providing additional clarification [Memo]. <p></p>Please update."
            return = "back">

           <cfabort>
		 		   
     	</cfif>
	
	</cfif>
		
	</cfloop>

</cfif>


<!--- KRW 29 may 2007: removed transaction because of conflict with language update. 
Can not use two different db sources in a trans --->
<!--- <cftransaction action="BEGIN">  --->          
 
<cfloop index="Rec" from="1" to="#CLIENT.RecordNo#">

<cfoutput>

<cfset programcode         = Evaluate("FORM.programcode_" & #Rec#)>
<cfset activityperiod      = Evaluate("FORM.activityperiod_" & #Rec#)>
<cfset outputid            = Evaluate("FORM.outputid_" & #Rec#)>
<cfset progressstatusdate  = Evaluate("FORM.progressstatusdate_" & #Rec#)>
<cfset revisedoutputdate   = Evaluate("FORM.revisedoutputdate_" & #Rec#)>

    
<cfset dateValue = "">
<CF_DateConvert Value="#progressstatusdate#">
<cfset DTE = #dateValue#>

<cfset dateValue = "">
<cfif #revisedoutputdate# neq "">
   <CF_DateConvert Value="#revisedoutputdate#">
   <cfset RDTE = #dateValue#>
<cfelse>
   <cfset RDTE = 'NULL'>
</cfif>	 
      
<cfset progressstatus      = Evaluate("FORM.progressstatus_" & #Rec#)>

<cfif progressstatus lt "2">
   <cfset RDTE = 'NULL'>
</cfif>

<cfset progressmemo        = Evaluate("FORM.progressmemo_" & #Rec#)>
  
<cfif Len(#progressmemo#) gt 450>
	<cf_message message = "Your entered a memo that exceeded the allowed size of 450 characters."
  		return = "back">
  	<cfabort>
</cfif>
  
  
</cfoutput>  

<cfif #ProgressStatus# neq "0">

<!--- check if record already exists in order to update and not to add --->

<cfquery name="Check" 
datasource="AppsProgram" 
username=#SESSION.login# 
password=#SESSION.dbpw#>
Select ProgressId, ProgressStatus
FROM ProgramActivityProgress 
WHERE OutputId = '#OutputId#'
AND ActivityPeriod = '#ActivityPeriod#'
AND (ProgressStatus = '#progressstatus#' OR ProgressStatus = '0')
</cfquery>

<cfif Check.recordCount eq "1" and (#Parameter.ProgressTransactional# eq "0" or #Check.ProgressStatus# eq "0")>

	<cfquery name="Update" 
	datasource="AppsProgram" 
	username=#SESSION.login# 
	password=#SESSION.dbpw#>
	UPDATE ProgramActivityProgress  
	SET ProgressStatusDate = #dte#,
	    RevisedOutputDate  = #rdte#,
	    ProgressStatus     = '#ProgressStatus#',
		ProgressMemo       = '#ProgressMemo#',
		OfficerUserId      = '#SESSION.acc#',
		OfficerLastName    = '#SESSION.last#',
		OfficerFirstName   = '#SESSION.first#',
		Created            = getDate()
	WHERE ProgressId = '#Check.ProgressId#'		  
	</cfquery>		
	
	
	<cf_LanguageInput
		TableCode       = "ProgramActivityProgress" 
		Mode            = "Save"
		Name1           = "ProgressMemo"
		NameSuffix      = "_#Rec#"		
		Key1Value       = "#programcode#"
		Key2Value       = "#activityperiod#"
		Key3Value       = "#Check.ProgressId#">

<cfelse>
 
	<cfquery name="Insert" 
	datasource="AppsProgram" 
	username=#SESSION.login# 
	password=#SESSION.dbpw#>
	INSERT INTO ProgramActivityProgress  
	         (ProgramCode, ActivityPeriod,
			  OutputId, 
			  ProgressStatusDate,
			  RevisedOutputDate,
			  ProgressStatus,
			  ProgressMemo,
			  OfficerUserId,
			  OfficerLastName,
			  OfficerFirstName,
			  Created)
	  VALUES ('#programcode#', '#activityperiod#',
	          '#outputid#',
	          #dte#,  
			  #rdte#,
			  '#progressstatus#',
			  '#progressmemo#',
			  '#SESSION.acc#',
			  '#SESSION.last#',
			  '#SESSION.first#',
			  getDate())
	</cfquery>	
	
	<cfquery name="LastNo" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT Max(ProgressId) as ProgressId
	 FROM   ProgramActivityProgress
	 WHERE  OutputID	    = '#outputid#'
	  AND   ProgramCode 	= '#programcode#'
	  AND   ActivityPeriod 	= '#activityperiod#'
	 </cfquery>
	 					
	<cf_LanguageInput
		TableCode       = "ProgramActivityProgress" 
		Mode            = "Save"
		Name1           = "ProgressMemo"
		NameSuffix      = "_#Rec#"		
		Key1Value       = "#programcode#"
		Key2Value       = "#activityperiod#"
		Key3Value       = "#LastNo.ProgressId#">
	
</cfif>

</cfif>

</cfloop>

<cflocation url="ProgressViewGeneral.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#&Period=#URL.Period#&Sub=#URL.Sub#" addtoken="No">		  

