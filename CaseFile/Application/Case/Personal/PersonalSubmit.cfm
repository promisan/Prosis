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

<cfquery name="Check" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  ClaimPerson
		WHERE ClaimId = '#url.Claimid#'	
</cfquery>

<cfif Check.recordcount eq "0">
	
	   <cfquery name="InsertClaim" 
     datasource="AppsCaseFile" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ClaimPerson
         (ClaimId,
		 #url.field#,		
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
      VALUES ('#URL.ClaimId#',
          '#url.value#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')
	  </cfquery>	

<cfelse>

		 <cfquery name="UpdateClaim" 
	     datasource="AppsCaseFile" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 UPDATE ClaimPerson
		 SET    #url.field#= '#url.value#'
	     WHERE  ClaimId = '#URL.ClaimID#' 
	     </cfquery>
	
</cfif>	


<cfoutput>
Saved on #timeformat(now(),"HH:MM:SS")#
</cfoutput>
	