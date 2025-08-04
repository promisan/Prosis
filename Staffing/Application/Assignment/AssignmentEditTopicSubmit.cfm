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

<cfquery name="Topic" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		 SELECT  *
	     FROM  Ref_PersonGroup
		 WHERE Code IN (SELECT GroupCode FROM Ref_PersonGroupList)
		 
		 AND   Operational = 1
		 
		 AND   Context = 'Assignment'
		 AND   Code != 'AssignEnd'
		 
		 <cfif getAdministrator(Post.mission) eq "1">
	
			<!--- no filtering --->

		 <cfelse>		
		 
		 AND   Code IN (SELECT GroupCode 
		                FROM   Ref_PersonGroupRole						
						WHERE  Role IN (SELECT DISTINCT Role 
		                                FROM   Organization.dbo.OrganizationAuthorization
										WHERE  UserAccount = '#SESSION.acc#')
						)	
											
		 AND   Code IN (SELECT GroupCode
		                FROM   Ref_PersonGroupOwner				
						WHERE  Owner IN (SELECT MissionOwner
						                 FROM   Organization.dbo.Ref_Mission
										 WHERE  Mission = '#Post.Mission#')
										
					   )									   
														   
		 </cfif>	
		 											   
</cfquery>

<cfquery name="Clear" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM PersonAssignmentTopic 
		WHERE  PersonNo = '#Form.PersonNo#'
		AND    AssignmentNo = '#ass#'					
</cfquery>

<cfloop query="topic">

	<cfparam name="Form.ListCode_#Code#" default="">

	<cfset listCode = evaluate("Form.ListCode_#Code#")>
		    		  
	<cfquery name="Insert" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		
		 INSERT INTO PersonAssignmentTopic
		 
			 (PersonNo,
			  PositionNo,
			  AssignmentNo,
			  GroupCode,
			  GroupListCode, 							  
			  OfficerUserId,
			  OfficerLastName,
			  OfficerFirstName)
				  
		 VALUES
		
			 ('#Form.PersonNo#',
			  '#Form.PositionNo#',
			  '#ass#', 
			  '#Code#', 
			  '#ListCode#',
			  '#SESSION.acc#', 
			  '#SESSION.last#', 
			  '#SESSION.first#')
		  
	</cfquery>
				   
</cfloop>