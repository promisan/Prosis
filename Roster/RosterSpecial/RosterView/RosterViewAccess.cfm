
<!--- ensure global access based on a role to bucket --->

<!--- clear previously granted access --->

<cfinvoke component="Service.Access"  
	   method="roster" 
	   returnvariable="Access"
	   role="'AdminRoster'">	
	
<cfquery name="Check" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#"> 
	 SELECT    TOP 1 Created
	 FROM      RosterAccessAuthorization with (nolock)
	 WHERE     UserAccount = '#SESSION.acc#'
	 AND       Source = 'Manager' 
	 ORDER BY  Created DESC
</cfquery>	

<cfif check.recordcount eq "0">
   <cfset prior = "01/01/1900">
<cfelse>
   <cfset prior = "#dateformat(check.created,client.DateSQL)#">
</cfif>

<cfquery name="Check2" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#"> 
	 SELECT    TOP 1 Created
	 FROM      FunctionOrganization
	 ORDER BY  Created DESC
</cfquery>	 

<cfif check2.recordcount eq "0">
   <cfset prior2 = "01/01/1900">
<cfelse>
   <cfset prior2 = "#dateformat(check2.created,client.DateSQL)#">
</cfif>
	
<cftransaction>
	
<cfif DateDiff("d", prior, dateformat(now(),client.DateSQL)) neq "0" or 
		DateDiff("d", prior2, prior) gte "0">
			
		<cfquery name="ClearInherited" 
		 datasource="AppsSelection" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#"> 
			 DELETE FROM RosterAccessAuthorization
			 WHERE   UserAccount = '#SESSION.acc#'
			 AND     Source       = 'Manager' 	 <!--- inherited access --->
		</cfquery>	 
		
		<!--- select roster mangers + bucket table --->
			   	  
		<cfif Access eq "EDIT" or Access eq "ALL">
		
			<!--- grant full access --->
			
			<cftry>
				
				<cfquery name="Inherit" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#"> 
				
				INSERT INTO RosterAccessAuthorization
						(FunctionId, 
						 UserAccount, 
						 AccessLevel, 
						 Source, 
						 Role,
						 OfficerUserId,OfficerLastName,OfficerFirstName,Created)
						 
				SELECT  DISTINCT FO.FunctionId, 
				        '#SESSION.acc#', 
						A.AccessLevel, 
						'Manager', 
						'AdminRoster',
						'#SESSION.acc#','#SESSION.last#','#SESSION.first#',#now()#
						
				FROM    FunctionOrganization FO INNER JOIN
				        Ref_SubmissionEdition S ON FO.SubmissionEdition = S.SubmissionEdition INNER JOIN
				        Organization.dbo.OrganizationAuthorization A ON S.Owner = A.ClassParameter INNER JOIN
				        Ref_StatusCode R ON S.Owner = R.Owner
				WHERE   A.Role = 'AdminRoster'
				AND 	R.Id           = 'Fun' 
				AND 	S.Operational  = 1
				AND 	R.RosterAction = '1' 
				AND 	A.UserAccount  = '#SESSION.acc#'
				AND 	FO.FunctionId NOT IN (SELECT FunctionId 
					                          FROM   RosterAccessAuthorization
					                          WHERE  UserAccount = '#SESSION.acc#'
											  AND    FunctionId  = FO.FunctionId
											  AND    Role        = A.Role 
											   <!--- added condition on 12/4 for charles --->
											  AND    AccessLevel IN ('1','2')) 
							   
				</cfquery>
									
				<cfcatch></cfcatch>
				
			</cftry>
					
		</cfif>
		
		<!--- ----------------------------------------------------------- --->
	    <!--- grant inherited access as defined in roster clear role role --->
		<!--- ----------------------------------------------------------- --->
				
		<cfquery name="InheritProcessRights" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
			
			INSERT INTO RosterAccessAuthorization 
			
					(FunctionId,  
					 UserAccount, 
					 AccessLevel, 
					 Source, 
					 Role,
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName,
					 Created)
			
			<!--- global rights --->
			 
			SELECT   DISTINCT FO.FunctionId, 
			         '#SESSION.acc#', 
					 A.AccessLevel, 
					 'Manager', <!--- means inherited through manager --->
					 'RosterClear',
					 '#SESSION.acc#', 
					 '#SESSION.last#', 
					 '#SESSION.first#',
					 #now()# <!--- better performance than getdtae() --->
					 
			FROM      FunctionOrganization FO INNER JOIN
		              Ref_SubmissionEdition S ON FO.SubmissionEdition = S.SubmissionEdition INNER JOIN
		              Organization.dbo.OrganizationAuthorization A ON S.Owner = A.ClassParameter INNER JOIN
		              FunctionTitle F ON FO.FunctionNo = F.FunctionNo AND A.GroupParameter = F.OccupationalGroup
			WHERE    A.Role        = 'RosterClear' 
				AND  A.UserAccount = '#SESSION.acc#'
				AND  S.Operational = 1
				AND  A.Mission is NULL
				AND  A.AccessLevel != '0'
				AND  NOT EXISTS (SELECT FunctionId 
					                           FROM   RosterAccessAuthorization
					                           WHERE  UserAccount = '#SESSION.acc#'
											   AND    FunctionId  = FO.FunctionId
											   AND    Role        = 'RosterClear'
											   <!--- added condition on 12/4 for charles --->
											   AND    AccessLevel IN ('1','2')) 
				
				
			UNION	
			
			<!--- mission rights --->
			
			SELECT   DISTINCT FO.FunctionId, 
			         '#SESSION.acc#', 
					 A.AccessLevel, 
					 'Manager', 
					 'RosterClear',
					 '#SESSION.acc#', 
					 '#SESSION.last#', 
					 '#SESSION.first#',
					 #now()#   <!--- better performance than getdtae() --->
					 
			FROM     FunctionOrganization FO INNER JOIN
		             Ref_SubmissionEdition S ON FO.SubmissionEdition = S.SubmissionEdition INNER JOIN
		             Organization.dbo.OrganizationAuthorization A ON S.Owner = A.ClassParameter AND FO.Mission = A.Mission INNER JOIN
		             FunctionTitle F ON FO.FunctionNo = F.FunctionNo AND A.GroupParameter = F.OccupationalGroup
					  
			WHERE    A.Role = 'RosterClear' 
				AND  A.UserAccount = '#SESSION.acc#'
				AND  S.Operational = 1			
				AND  A.AccessLevel != '0' 
				AND  NOT EXISTS (SELECT FunctionId 
		                         FROM   RosterAccessAuthorization
		                         WHERE  UserAccount = '#SESSION.acc#'
								 AND    FunctionId  = FO.FunctionId
								 AND    Role        = 'RosterClear' 
								 <!--- added condition on 12/4 for charles --->
								 AND    AccessLevel IN ('1','2')) 
				
			UNION	
					
			<!--- read rights accross the board --->
			
			SELECT  DISTINCT FO.FunctionId, 
			        '#SESSION.acc#', 
					'0', 
					'Manager', 
					'RosterClear',
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#',
					#now()#  <!--- better performance than getdtae() --->
			FROM    FunctionOrganization FO INNER JOIN
		            Ref_SubmissionEdition S ON FO.SubmissionEdition = S.SubmissionEdition INNER JOIN
		            Organization.dbo.OrganizationAuthorization A ON S.Owner = A.ClassParameter INNER JOIN
		            FunctionTitle F ON FO.FunctionNo = F.FunctionNo AND A.GroupParameter = F.OccupationalGroup
			WHERE   A.Role = 'RosterClear' 
				AND A.UserAccount = '#SESSION.acc#'
				AND S.Operational = 1
				AND A.Mission is NULL
				AND A.AccessLevel = '0' 
				AND NOT EXISTS (SELECT FunctionId 
	                            FROM   RosterAccessAuthorization
	                            WHERE  UserAccount = '#SESSION.acc#'
							    AND    FunctionId  = FO.FunctionId
							    AND    Role        = 'RosterClear' 
							    <!--- added condition on 12/4 for charles --->
							    AND    AccessLevel IN ('1','2')) 
			</cfquery>									   
										   
</cfif>
	
</cftransaction>