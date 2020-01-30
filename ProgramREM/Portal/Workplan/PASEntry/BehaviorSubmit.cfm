	 <cfquery name="Verify" 
		datasource="appsEPAS" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  COUNT(*) AS Entries, 
			        SUM(DISTINCT C.MinEntries) AS MinEntries
			FROM    ContractBehavior CB,
                    Ref_Behavior R,
					Ref_BehaviorClass C 
			WHERE   CB.BehaviorCode = R.Code 
			AND     R.BehaviorClass = C.Code
			AND     CB.Contractid = '#URL.ContractId#' 
			AND 	R.Operational=1
			AND 	C.Operational=1
	 </cfquery>	
	 
	  <cfquery name="Verify2" 
		datasource="appsEPAS" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    Ref_BehaviorClass C 
			WHERE   Operational = 1
			and   Code NOT IN (SELECT BehaviorClass 
			                     FROM   ContractBehavior CB,
					                    Ref_Behavior R
								 WHERE  CB.BehaviorCode = R.Code 
								 AND    CB.Contractid = '#URL.ContractId#')
	 </cfquery>	

	  <cf_Navigation
			 Alias         = "AppsEPAS"
			 Object        = "Contract"
			 Group         = "Contract"
			 Section       = "#URL.Section#"
			 Id            = "#URL.ContractId#"
			 OpenDirect    = "1"
			 NextEnable    = "1"
			 reload        = "1"
			 NextMode      = "1"
			 SetNext       = "1">
