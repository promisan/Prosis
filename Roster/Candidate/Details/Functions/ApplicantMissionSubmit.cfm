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

<cfif url.act eq "add"> 

		<cfquery name="Insert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ApplicantMission
		         (Applicantno,
					 Mission,
					 Status,
					 Source,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
		  VALUES ('#url.app#',
		          '#url.mis#', 
				  '1',
				   'Manual',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
	           
</cfif>

<cfif url.act eq "del"> 
		
	<cfquery name="Delete" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM ApplicantMission
		WHERE  ApplicantNo = '#url.app#'
		AND    Mission = '#url.mis#'		
	</cfquery>	
		
</cfif>	


<cfoutput>

<script language="JavaScript">
   
 	 window.location = "ApplicantMission.cfm?id=#url.id#&mode=edit"
        
</script>  

</cfoutput>
