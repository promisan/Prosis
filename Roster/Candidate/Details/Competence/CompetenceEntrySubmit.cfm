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

<cfparam name="FORM.FieldId" default="">

<cfinclude template="../SubmissionSubmit.cfm">

<cfquery name="Clear" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">	
	DELETE FROM ApplicantCompetence
	WHERE ApplicantNo = '#appno#'
</cfquery>

<!--- add background fields level, geo, exp after identifying the assigned serialNo --->
 
<cfloop index="Item" 
        list="#Form.FieldId#" 
        delimiters="' ,">
		
	<cfquery name="InsertCompetence" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO dbo.[ApplicantCompetence] 
	         (ApplicantNo,
			 CompetenceId,
			 Status,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,
	    	 Created)
	  VALUES ('#AppNo#', 
	          '#Item#',
			  '0',
			  '#SESSION.acc#',
			  '#SESSION.last#',
			  '#SESSION.first#', 
			  getdate())
     </cfquery>
		  
</cfloop>	


<!--- no needed 

<cfoutput>
	<script language="JavaScript">		    
		ptoken.location("../General.cfm?source=#url.source#&ID=#PersonNo#&ID2=#URL.ID2#&Topic=#URL.Topic#")		  
	</script>	
</cfoutput>  

--->

