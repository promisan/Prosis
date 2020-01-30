	
<link href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

	<cfset dateValue = "">
	   <CF_DateConvert Value="#Form.DateEffective#">
	<cfset STR = dateValue>
					
	<cfset dateValue = "">
	   <CF_DateConvert Value="#Form.DateExpiration#">
	<cfset END = dateValue>
	
	<cfset dateValue = "">
	<cfif Form.PasEvaluation neq "">
	     <CF_DateConvert Value="#Form.PASEvaluation#">
    	<cfset EVAL = dateValue>
	<cfelse>
		<cfset EVAL = 'NULL'>
	</cfif>	
		
	<cfquery name="Parameter" 
		datasource="appsEPas" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
        FROM Ref_ContractPeriod
		WHERE Code = (SELECT Period FROM Contract WHERE ContractId = '#URL.ContractId#')
		
	</cfquery>
		
	<cfquery name="Contract" 
		datasource="AppsEPAS" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Contract
		SET    DateEffective       = #STR#,
		       DateExpiration      = #END#,
			   FunctionDescription = '#Form.FunctionDescription#',
			   Objective           = '#Form.Objective#',
			   EnableTasks         = '#Form.EnableTasks#',
			   PASEvaluation       = #EVAL#,
			   ActionStatus        = '#Form.ActionStatus#'
		WHERE  ContractId          = '#URL.ContractId#'
	</cfquery>
	
	<!--- clean tasks --->
	
	<cfquery name="Contract" 
		datasource="AppsEPAS" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE ContractActivity
		SET    Operational = 0
		WHERE  ContractId = '#URL.ContractId#'
		AND    ActivityOrder >= #Form.EnableTasks#
	</cfquery>
			
	<cfloop index="RoleFunction" list="FirstOfficer,SecondOfficer">
	
		<cfparam name="Form.#rolefunction#" default="">
		<cfset per = evaluate("Form.#rolefunction#")>
		
		<cfquery name="Check" 
		datasource="appsEPas" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      ContractActor C
			WHERE     ContractId   = '#url.ContractId#'			
			AND       RoleFunction = '#rolefunction#'			
			AND       PersonNo     = '#per#'   		
		</cfquery>
		
		 <cfquery name="Reset" 
		   datasource="AppsEPAS" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   UPDATE ContractActor  
			   SET    ActionStatus = '9'		  
			   WHERE  ContractId   = '#URL.ContractId#'			  			  
			   AND    RoleFunction = '#rolefunction#'
		 </cfquery>	
		
		<cfif check.recordcount eq "1">
	
			 <cfquery name="UpdateEvaluate" 
			   datasource="AppsEPAS" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				   UPDATE ContractActor  
				   SET    ActionStatus = '1'		  
				   WHERE  ContractId   = '#URL.ContractId#'
				   AND    PersonNo     = '#per#'
				   AND    Role         = 'Evaluation'
				   AND    RoleFunction = '#rolefunction#'
			 </cfquery>	
		 
		<cfelse>
		
			 <cfquery name="Insert" 
			   datasource="AppsEPAS" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   INSERT INTO ContractActor  
				         (ContractId, 
						  PersonNo, 
						  RoleFunction,
						  Role,
						  ActionStatus,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				VALUES ('#URL.ContractId#', 
				       '#Per#',
					   '#RoleFunction#',
					   'Evaluation', 
					   '1',
					   '#SESSION.acc#', 
					   '#SESSION.last#', 
					   '#SESSION.first#')
			  </cfquery>	
			  
		</cfif>	  			  		 
	
	</cfloop>
	
	<!--- option to inherit from prior period 		
	<cfparam name="Form.Inherit" default="">
		
	<cfif Form.Inherit neq "">
		
			<cf_GeneralSubmitCopy 
			    From="#Form.Inherit#"
				To = "#ContractId#">
					
	</cfif>	
	
	--->
	
	<cfif Form.ActionStatus gte "8">
	
	<!--- to be define, ideally we load the same page again.
		<cf_Navigation
		 Alias         = "AppsEPAS"
		 Object        = "Contract"
		 Group         = "Contract"
		 Section       = "#URL.Section#"
		 Id            = "#URL.ContractId#"
		 BackEnable    = "1"
		 HomeEnable    = "1"
		 ResetEnable   = "1"
		 ProcessEnable = "0"
		 OpenDirect    = "1"
		 NextSubmit    = "0"
		 NextEnable    = "0"
		 NextMode      = "0"
		 SetNext       = "0">
		 --->
		 
		 <script>
			 parent.Prosis.busy('no')
		 </script>
	
	<cfelse>
								
		<cf_Navigation
		 Alias         = "AppsEPAS"
		 Object        = "Contract"
		 Group         = "Contract"
		 Section       = "#URL.Section#"
		 Id            = "#URL.ContractId#"
		 BackEnable    = "1"
		 HomeEnable    = "1"
		 ResetEnable   = "1"
		 ProcessEnable = "0"
		 OpenDirect    = "1"
		 NextSubmit    = "0"
		 NextEnable    = "1"
		 NextMode      = "1"
		 SetNext       = "1">
		 
</cfif>		 
				
	