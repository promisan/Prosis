
<!--- validations for Candidates --->

<cfcomponent>

	<cffunction name    = "getValidationStruct" 
		    access      = "private" 
		    returntype  = "struct">
			
			<cfparam name="ValidationCode"  type="string"  default="">
			<cfparam name="PassCode"     	type="string"  default="No">
			
			<cfquery name="getValidationDefinition"
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_Validation
					WHERE  ValidationCode = '#ValidationCode#'
			</cfquery>
			
			<cf_tl id="#getValidationDefinition.ValidationTitle#" var="lblVLabel">	
			<cf_tl id="#getValidationDefinition.ValidationInstructions#" var="lblVMemo">	
			
			<cfset vResult.label        = lblVLabel>
			<cfset vResult.passmemo     = lblVMemo>
			<cfset vResult.name         = getValidationDefinition.ValidationName>
			<cfset vResult.pass         = PassCode>
	
			<cfreturn vResult>
			
	</cffunction>
	
	
	<cffunction name    = "cto120" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates if CTO is reaching 120 hours" 
		    output      = "true">	
					
			 <cfparam name="SystemFunctionId"   type="string"  default="">				
			 <cfparam name="Object"             type="string"  default="Person">	
			 <cfparam name="ObjectKeyValue1"    type="string"  default="">	
			 <cfparam name="ValidationCode"     type="string"  default="">	
			 
			 <cfset result.pass = "OK">
			 
			 <cfquery name="getbalance" 
				  	datasource="AppsEmployee" 
				  	username="#SESSION.login#" 
				  	password="#SESSION.dbpw#">
					SELECT    TOP 1  Balance
					FROM      PersonLeaveBalance
					WHERE     LeaveType IN (SELECT LeaveType 
					                        FROM   Ref_LeaveType
                                            WHERE  LeaveAccrual = '2') 
					AND       PersonNo = '#ObjectKeyValue1#' 													
				</cfquery>	
				
				<cfquery name="getthreshold" 
				  	datasource="AppsEmployee" 
				  	username="#SESSION.login#" 
				  	password="#SESSION.dbpw#">
					SELECT    MaximumBalance
					FROM      Ref_LeaveTypeCredit
					WHERE     LeaveType IN (SELECT LeaveType 
					                        FROM   Ref_LeaveType
                                            WHERE  LeaveAccrual = '2') 
				</cfquery>
				
				<cfif getBalance.Balance gte getthreshold.maximumBalance>				
							   			   				
					<cfinvoke method    = "getValidationStruct" 					   
					   ValidationCode   = "#ValidationCode#"
					   PassCode			= "No"
					   returnvariable   = "result">	
			
			    </cfif> 
						
			<cfreturn result>		 
					 
	</cffunction>		
	
	
	
	<cffunction name    = "leavepending" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates at least one activity with an output" 
		    output      = "true">	
					
			 <cfparam name="SystemFunctionId"   type="string"  default="">				
			 <cfparam name="Object"             type="string"  default="Person">	
			 <cfparam name="ObjectKeyValue1"    type="string"  default="">	
			 <cfparam name="ValidationCode"     type="string"  default="">	
			 
			 <cfset result.pass = "OK">
			 
			  <cfquery name="get"
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    SELECT    * 
				FROM      PersonLeave
				WHERE     Status IN ('0', '1') 
				AND       PersonNo = '#ObjectKeyValue1#'
			   </cfquery>	
			 
			   <cfif get.recordcount gt 0>
			   			   				
					<cfinvoke method    = "getValidationStruct" 					   
					   ValidationCode   = "#ValidationCode#"
					   PassCode			= "No"
					   returnvariable   = "result">	
			
			    </cfif> 
						
			<cfreturn result>		 
					 
	</cffunction>	 	
	
	<cffunction name    = "epas" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates at least one activity with an output" 
		    output      = "true">	
					
			 <cfparam name="SystemFunctionId"   type="string"  default="">				
			 <cfparam name="Object"             type="string"  default="ProgramId">	
			 <cfparam name="ObjectKeyValue1"    type="string"  default="">	
			 <cfparam name="ValidationCode"     type="string"  default="">	
			 
			<cfset result.pass = "OK">
			
			<!--- check for active mission, check for active period and then we show, query to be tuned --->
			 
			<cfquery name="get"
				datasource="AppsEPAS" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				SELECT     *
				FROM       Contract
				WHERE      PersonNo   = '#ObjectKeyValue1#' 
				AND        Period     = '2018.1'
				AND        ActionStatus IN ('2')
				
			</cfquery>	
			 
			<cfif get.recordcount eq "0">
			   			   				
				<cfinvoke method    = "getValidationStruct" 					   
				   ValidationCode   = "#ValidationCode#"
				   PassCode			= "No"
				   returnvariable   = "result">	
			
			</cfif> 			
						
			<cfreturn result>
			 	   						 				
	</cffunction>	 	
				
		
</cfcomponent>	
