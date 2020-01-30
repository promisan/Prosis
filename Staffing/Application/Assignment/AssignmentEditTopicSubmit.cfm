
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