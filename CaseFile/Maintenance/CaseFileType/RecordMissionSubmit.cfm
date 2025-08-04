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

<cfparam name="Form.Operational"        default="0">
<cfparam name="Form.action"               default="0">
<cfparam name="Form.Description"        default="">

<cfif URL.action eq "new">
			
	<cfquery name="Verify" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ClaimTypeMission
		WHERE ClaimType = '#Form.ClaimType#' 
		AND Mission = '#Form.Mission#' 
	</cfquery>

    <cfif #Verify.recordCount# is 1>
   
	   <script language="JavaScript">
	   
	     alert("An record with this code has been registered already!")
	     
	   </script>  
  
   <cfelse>
   
		<cfquery name="Insert" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ClaimTypeMission
			         (ClaimType,
					 Mission,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,	
					 Created)
			  VALUES ('#Form.ClaimType#',  
			          '#Form.Mission#',
			   	      '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				      '#SESSION.first#',
				       getDate())
		  </cfquery>
		  
	</cfif>	  
		   	
</cfif>

<cfset url.id1 = "#Form.ClaimType#">
<cfset url.action = "view">
<cfinclude template="RecordMissionListingDetail.cfm">
