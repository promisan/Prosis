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
<cfparam name="Form.Location" default="">
<cfparam name="Form.Casualty" default="">
<cfparam name="Form.Cause" default="">
<cfparam name="Form.Circumstance" default="">
<cfparam name="Form.Remarks" default="">
<cfparam name="Form.Mission" default="">

 <cfset dateValue = "">
 <CF_DateConvert Value="#Form.IncidentDate#">
 <cfset DTE = dateValue>


	<cfquery 
		name="Check" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  ClaimIncident
			WHERE ClaimId = '#url.Claimid#'	
	</cfquery>

	<cfif Check.recordcount eq "0">
	
	   <cfquery name="InsertClaim" 
     datasource="AppsCaseFile" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ClaimIncident
         (ClaimId,
		 IncidentDate,
		 Mission,
		 Location,
		 Casualty,
		 CasualtyType,
		 Cause,		 
		 Circumstance,		 
		 Remarks, 		 
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
      VALUES ('#URL.ClaimId#',
		  #dte#,
          '#Form.Mission#',
          '#Form.Location#',
          '#Form.Casualty#',
		  '#Form.CasualtyType#',
          '#Form.Cause#',		  
          '#Form.Circumstance#',		  		  
          '#Form.Remarks#',		  		  		  
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')
	  </cfquery>	
   
<cfelse>

		 <cfquery name="UpdateClaim" 
	     datasource="AppsCaseFile" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 UPDATE ClaimIncident
		 SET    Mission='#Form.Mission#',
		 		IncidentDate = #dte#,
		 		Location     = '#Form.Location#',
		        Casualty     = '#Form.Casualty#',
				CasualtyType = '#Form.CasualtyType#',
				Cause        = '#Form.Cause#',
				Circumstance = '#Form.Circumstance#'
				<cfif Form.Remarks neq "null">
					,Remarks= '#Form.Remarks#'
				</cfif>				
	     WHERE  ClaimId = '#URL.ClaimID#' 
	     </cfquery>
	
</cfif>	

<cfoutput>
<table width="100%" align="right"><tr><td align="right" class="labelmedium" style="color:##0080C0">Saved on #timeformat(now(),"HH:MM:SS")#</td></tr></table>
</cfoutput>

	