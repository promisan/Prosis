
<!--- create ePas--->

<cfset entity = "'EntPasEvaluation'">

<cfparam name="fun" default="">

<cfquery name="AccountList" 
	datasource="appsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    UserNames
	WHERE   PersonNo = '#Per#' 
</cfquery>

<cfif accountList.recordcount gte "1">

	<!--- supervisor is reviewed each time when he/she opens the screen if still valid for processing !!! 
		
		<cfquery name="Clear" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM OrganizationObjectActionAccess 
			WHERE  Objectid IN 
			              (SELECT  ObjectId
						   FROM    OrganizationObject O
						   WHERE   O.EntityCode IN (#preserveSingleQuotes(entity)#) 
						   AND     O.ObjectKeyValue4 = '#Evaluate.ContractId#'
						   AND     O.ObjectKeyValue1 = '#Evaluate.EvaluationType#')					  
																			
		</cfquery>
		
	--->

	<cfloop query="AccountList">
	
		<!--- enable access on the fly --->
								
		<cfquery name="Insert" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
							
				INSERT INTO OrganizationObjectActionAccess
				    	(ObjectId, 
					     ActionCode, 
				    	 UserAccount,
				    	 OfficerUserId, 
				    	 OfficerLastName, 
				    	 OfficerFirstName)
						 
				SELECT  DISTINCT 
				        O.ObjectId, 
				        OA.ActionCode, 
						'#account#',
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
				FROM    OrganizationObject O 
			            INNER JOIN OrganizationObjectAction OA ON O.ObjectId = OA.ObjectId 
				        INNER JOIN Ref_EntityActionPublish AS R ON OA.ActionPublishNo = R.ActionPublishNo AND OA.ActionCode = R.ActionCode
			    WHERE   O.EntityCode IN (#preserveSingleQuotes(entity)#) 
				AND     R.PersonAccess = 0													
				AND     O.ObjectKeyValue4 = '#Evaluate.ContractId#'		
				AND     O.ObjectKeyValue1 = '#Evaluate.EvaluationType#' 
				<cfif fun eq "firstofficer">
				AND     R.ActionReference = 'FRO'
				<cfelseif fun eq "SecondOfficer">
				AND     R.ActionReference = 'SRO'
				<cfelse>
				AND     1=0
				</cfif>
				AND 	NOT EXISTS (  SELECT 'X'
								      FROM   OrganizationObjectActionAccess  OOA
						              WHERE  OOA.Objectid = O.ObjectId 
						              AND    OOA.ActionCode = OA.ActionCode 
						              AND    OOA.UserAccount = '#account#'	)			
							
		</cfquery>	
		
		</cfloop>
		
	
<cfelse>

	<table align="center"><tr><td class="labelmedium" align="center"><cf_tl id="Problem, user could not be identified"></td></tr></table>	

</cfif>
		