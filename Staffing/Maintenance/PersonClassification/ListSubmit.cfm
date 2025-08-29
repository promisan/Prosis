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
<cfparam name="Form.Operational"    default="1">
<cfparam name="Form.ListValue"      default="">

<cfparam name="Form.GroupListCode"  default="#url.lc#">
<cfparam name="Form.Description"    default="#url.de#">
<cfparam name="Form.GroupListOrder" default="#url.lo#">

<cfif Form.GroupListCode eq "">

<cfelse>

	<cfif URL.ID2 neq "new">

		 <cfquery name="Update" 
			  datasource="AppsEmployee" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  UPDATE Ref_PersonGroupList
			  SET    Operational         = '#Form.Operational#',
	 		         Description         = '#Form.Description#',			 
					 GroupListOrder      = '#Form.GroupListOrder#'
			  WHERE  GroupListCode = '#Form.GroupListCode#'
			   AND   GroupCode = '#URL.Code#' 
		</cfquery>
	
	
		<cfset url.id2 = "">
					
	<cfelse>

		<cfquery name="Exist" 
		    datasource="AppsEmployee" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT *
			FROM Ref_PersonGroupList
			  WHERE  GroupListCode = '#Form.GroupListCode#'
			   AND   GroupCode = '#URL.Code#' 
		</cfquery>
		
		<cfif Exist.recordCount eq "0">
			
				<cfquery name="Insert" 
				     datasource="AppsEmployee" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO Ref_PersonGroupList
				         (GroupCode,
						 GroupListCode,
						 Description,
						 GroupListOrder,
						 Operational)
				      VALUES ('#URL.Code#',
					      '#Form.GroupListCode#',
						  '#Form.Description#',
						  '#Form.GroupListOrder#',
				      	  '#Form.Operational#')
				</cfquery>
				
		<cfelse>
				
			<script>
			<cfoutput>
			alert("Sorry, but #Form.ListValue# already exists")
			</cfoutput>
			</script>
					
		</cfif>		
		
		<cfset url.id2 = "new">
			   	
	</cfif>

</cfif>	

<cfoutput>
  <script>
	#ajaxlink('List.cfm?code=#url.code#&id2=#url.id2#')#
  </script>	
</cfoutput>


