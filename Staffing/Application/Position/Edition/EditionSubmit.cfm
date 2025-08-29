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
<cfparam name="Form.Operational" default="0">

<cftransaction action="BEGIN">
	
		<cfif URL.ID1 eq "">
		
			<cfquery name="Insert" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO PositionParentEdition
			         (PositionParentId,
					 SubmissionEdition,
					 Operational,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			      VALUES ('#URL.ID#',
			      	  '#Form.SubmissionEdition#',
					  '#Form.Operational#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
			</cfquery>
			
						
		<cfelse>
			
			   <cfquery name="Update" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     UPDATE PositionParentEdition
				  SET   Operational = '#Form.Operational#' 
				 WHERE  PositionParentId = '#URL.ID#'
				   AND  SubmissionEdition = '#URL.ID1#'
		    	</cfquery>			
							
		</cfif>
		
</cftransaction>
  	
<script>
	 <cfoutput>
	 #ajaxLink('../Edition/Edition.cfm?ID=#URL.ID#')#
	 </cfoutput> 
</script>	
   
