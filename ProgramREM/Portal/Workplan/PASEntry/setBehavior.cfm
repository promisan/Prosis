
<!--- default behavior --->

<cfquery name="get" 
	 datasource="appsEPAS" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		  SELECT *
		  FROM   Contract
		  WHERE  ContractId = '#url.contractid#'		  
</cfquery>

<cfquery name="Insert" 
	 datasource="AppsEPAS" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">					 
		INSERT INTO ContractBehavior
			   (ContractId, BehaviorCode, PriorityCode,OfficerUserId,OfficerLastName,OfficerFirstName)
		SELECT '#get.contractid#', 
		       BehaviorCode, 
			   PriorityCode, 
			   '#session.acc#','#session.last#','#session.first#'
		FROM   Ref_ParameterMissionBehavior D
		WHERE  Mission = '#get.Mission#'
		AND    NOT EXISTS (SELECT 'X' 
		                   FROM   ContractBehavior 
				 		   WHERE  ContractId = '#get.Contractid#' 
						   AND    BehaviorCode = D.BehaviorCode)					  
</cfquery>	

