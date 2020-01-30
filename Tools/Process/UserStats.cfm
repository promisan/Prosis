
<cfset fileNo = 1>

<!--- create reference logon file --->

<cfquery name="clear" 
	datasource="AppsSystem">
	DELETE FROM skUserLastLogon					
</cfquery>

<cfquery name="Logon" 
	datasource="AppsSystem">
	INSERT INTO dbo.skUserLastLogon 
	 (Account, LastConnection) 
	 
	SELECT DISTINCT
			ConnData.Account,
			MAX(ConnData.LastConnection) AS LastConnection
	FROM
		(
			SELECT DISTINCT 
					Account, 
					MAX(Created) AS LastConnection
			FROM	UserStatusLog 
			GROUP BY Account
			UNION ALL
			SELECT DISTINCT 
					Account, 
					MAX(ActionTimeStamp) AS LastConnection
			FROM	UserActionLog 
			WHERE	ActionClass = 'Logon'
			GROUP BY Account
		) as ConnData
		INNER JOIN UserNames U
			ON ConnData.Account = U.Account
	GROUP BY ConnData.Account
</cfquery>


<CF_DropTable dbName="AppsSystem" full="yes" tblName="skUserGrant">

<cfquery name="Granted" 
		datasource="AppsOrganization">
			SELECT DISTINCT 
			           UserAccount,
			           OfficerUserId, 
				       OfficerLastName, 
					   OfficerFirstName, 
					   Max(Created) as Last, 
					   COUNT(*) AS entries
			INTO   	   System.dbo.skUserGrant					
			FROM       OrganizationAuthorization
			GROUP BY   UserAccount, OfficerUserId, OfficerLastName, OfficerFirstName
			ORDER BY   UserAccount,OfficerUserId
		</cfquery>
		
		1..
		<cfflush>
		
<cfquery name="CleanOrphanedGroupAccess" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE  OrganizationAuthorization 
		FROM    OrganizationAuthorization OA
		WHERE   Source NOT IN (SELECT    Account
	                           FROM      System.dbo.UserNames
	                           WHERE     Account = OA.Source) 
		AND     Source <> 'Manual' AND Source is not NULL
</cfquery>		

<cfquery name="CleanWorkflowAccess" 
	datasource="AppsOrganization">
	DELETE  FROM  OrganizationAuthorization
	WHERE   ClassIsAction = 1 
	AND     ClassParameter NOT IN (SELECT ActionCode FROM Ref_EntityAction)
</cfquery>					 
	
<!--- clean inconsistent group inherit personal authorization records --->

<!--- role + param --->

<cfquery name="Clean" 
	datasource="AppsOrganization">
DELETE FROM OrganizationAuthorization
WHERE     AccessId IN (SELECT     Access.AccessId
						FROM      OrganizationAuthorization Access LEFT OUTER JOIN
				                  OrganizationAuthorization Inherit ON Access.ClassParameter = Inherit.ClassParameter AND Access.Source = Inherit.UserAccount AND 
				                  Access.Role = Inherit.Role
						WHERE     (Access.Source <> 'Manual')
						AND       Access.Mission IS NULL 
						AND       Inherit.Mission IS NULL 
						AND       Access.OrgUnit IS NULL 
						AND       Inherit.OrgUnit IS NULL
						GROUP BY  Access.AccessId, Inherit.AccessId
						HAVING    Inherit.AccessId IS NULL
					  ) 	 
</cfquery>

<cfquery name="CleanDenied" 
	datasource="AppsOrganization">
DELETE FROM OrganizationAuthorizationDeny
WHERE     AccessId IN (SELECT     Access.AccessId
						FROM      OrganizationAuthorizationDeny Access LEFT OUTER JOIN
				                  OrganizationAuthorization Inherit ON Access.ClassParameter = Inherit.ClassParameter AND Access.Source = Inherit.UserAccount AND 
				                  Access.Role = Inherit.Role
						WHERE     (Access.Source <> 'Manual')
						AND       Access.Mission IS NULL 
						AND       Inherit.Mission IS NULL 
						AND       Access.OrgUnit IS NULL 
						AND       Inherit.OrgUnit IS NULL
						GROUP BY  Access.AccessId, Inherit.AccessId
						HAVING    Inherit.AccessId IS NULL
					  ) 	 
</cfquery>

2..<cfflush>

<!--- role + param + mission --->

<cfquery name="Clean" 
	datasource="AppsOrganization">
DELETE FROM OrganizationAuthorization
WHERE     AccessId IN (SELECT     Access.AccessId
						FROM         OrganizationAuthorization Access LEFT OUTER JOIN
						                      OrganizationAuthorization Inherit ON Access.Mission = Inherit.Mission AND Access.ClassParameter = Inherit.ClassParameter AND 
						                      Access.Source = Inherit.UserAccount AND Access.Role = Inherit.Role
						WHERE     (Access.Source <> 'Manual')
						AND Access.Mission is not NULL
						AND       Access.OrgUnit IS NULL 
						AND       Inherit.OrgUnit IS NULL
						GROUP BY Access.AccessId, Inherit.AccessId
						HAVING      (Inherit.AccessId IS NULL)
					  ) 	
</cfquery>		

3..<cfflush>

<!--- role + param + mission --->

<cfquery name="CleanDenied" 
	datasource="AppsOrganization">
DELETE FROM OrganizationAuthorizationDeny
WHERE     AccessId IN (SELECT   Access.AccessId
						FROM    OrganizationAuthorizationDeny Access LEFT OUTER JOIN
						        OrganizationAuthorization Inherit ON Access.Mission = Inherit.Mission AND Access.ClassParameter = Inherit.ClassParameter AND 
						        Access.Source = Inherit.UserAccount AND Access.Role = Inherit.Role
						WHERE     (Access.Source <> 'Manual')
						AND Access.Mission is not NULL
						AND       Access.OrgUnit IS NULL 
						AND       Inherit.OrgUnit IS NULL
						GROUP BY Access.AccessId, Inherit.AccessId
						HAVING      (Inherit.AccessId IS NULL)
					  ) 	
</cfquery>						  

5..	<cfflush>  
					  