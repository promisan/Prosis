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
<cfquery name="Class" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT * 
	 FROM   Ref_AuthorizationRole
	 WHERE  Role = '#URL.Role#'	  
</cfquery>

<cfif class.recordcount eq "0">

	<cf_compression>	 

<cfelse>
	
	<cfif Class.OrgUnitLevel neq "Global">
				   
		   <select name="missionsel" id="missionsel"
	        multiple
	        style="width:120; font-size: xx-small;">
		   
			   <option selected>Any</option>				   
			   
				<cfquery name="MissionList" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  Ref_Mission 	
					WHERE Operational = 1	
					
				</cfquery>
			   
	           <cfloop query="MissionList">		
			   	     <option value="#Mission#">#Mission#</option>
			   </cfloop>	
			    
		   </select>	
		   
	   <cfelse>
	   
	   	 <input type="hidden" name="missionsel" id="missionsel">N/A   
		 
	   </cfif>		
   
</cfif>   

   </cfoutput> 

