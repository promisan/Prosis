
<!--- create ePas--->

<cfparam name="URL.PersonNo" default="#client.PersonNo#">

<cfset entity = "'EntPas','EntPasEvaluation'">

<!--- determine user account based on PersonNo --->

<cfquery name="Account" 
	datasource="appsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    UserNames
	WHERE   PersonNo = '#URL.PersonNo#'
</cfquery>

<!--- supervisor is reviewed each time when he/she opens the screen if still valid for processing !!! --->

<cfif Account.recordcount gte "1">

	<cfquery name="Clear" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		
		DELETE FROM OrganizationObjectActionAccess 
		WHERE  Objectid IN (					  					   
					   SELECT  DISTINCT OO.ObjectId
					   FROM    OrganizationObject OO 
					           INNER JOIN OrganizationObjectAction OOA ON OO.ObjectId = OOA.ObjectId 
					           INNER JOIN Ref_EntityActionPublish AS R ON OOA.ActionPublishNo = R.ActionPublishNo AND OOA.ActionCode = R.ActionCode
					   WHERE    R.PersonAccess = 0					   
					   AND      OO.EntityCode IN (#preserveSingleQuotes(entity)#) 
					   AND      OO.ObjectKeyValue4 IN (SELECT  ContractId
												       FROM    EPAS.dbo.ContractActor
												       WHERE   PersonNo     = '#URL.PersonNo#'
													   AND     Role         = 'Evaluation'
													   AND     ActionStatus = '1')		
					 )								   
   		AND    UserAccount = '#Account.Account#'		
	</cfquery>	
	
	<cftry>
	
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
				'#Account.account#',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#'
	    FROM    OrganizationObject O 
		        INNER JOIN OrganizationObjectAction OA ON O.ObjectId = OA.ObjectId 
			    INNER JOIN Ref_EntityActionPublish AS R ON OA.ActionPublishNo = R.ActionPublishNo AND OA.ActionCode = R.ActionCode
	    WHERE   O.EntityCode IN (#preserveSingleQuotes(entity)#) 
		AND     R.PersonAccess = 0		
		AND     EXISTS (SELECT  'X'
		                FROM    EPAS.dbo.ContractActor
						WHERE   ContractId = O.ObjectKeyValue4
	                    AND     PersonNo     = '#URL.PersonNo#' 
						AND     Role         = 'Evaluation'									  
						AND     ActionStatus = '1') 
						
	   </cfquery>	
	   
	   <cfcatch></cfcatch>
	   
	   </cftry>
	
</cfif>						
