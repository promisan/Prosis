
<cfquery name="get" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   ContractEvaluation		
		WHERE  EvaluationId = '#URL.EvaluationId#'
</cfquery>

<cfquery name="set" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE ContractEvaluation
		SET    Evaluation   = '#Form.Description#'
		WHERE  EvaluationId = '#URL.EvaluationId#'
</cfquery>
								
<cf_Navigation
	 Alias         = "AppsEPAS"
	 Object        = "Contract"
	 Group         = "Contract"
	 Section       = "#URL.Section#"
	 Id            = "#get.ContractId#"
	 BackEnable    = "1"
	 HomeEnable    = "1"
	 ResetEnable   = "1"
	 ProcessEnable = "0"
	 OpenDirect    = "1"
	 NextSubmit    = "0"
	 NextEnable    = "1"
	 NextMode      = "1"
	 SetNext       = "1">
	 
	