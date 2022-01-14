
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
	
	<cffunction name    = "DoubleIncumbency" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates if there is no double incumbency" 
		    output      = "true">	
					
			 <cfparam name="SystemFunctionId"   type="string"  default="">				
			 <cfparam name="Object"             type="string"  default="Position">	
			 <cfparam name="ObjectKeyValue1"    type="string"  default="">	
			 <cfparam name="ValidationCode"     type="string"  default="">	
			 
			 <cfset result.pass = "OK">
			 
			 <cfquery name="get"
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   PersonAssignment
				    WHERE  PositionNo = '#ObjectKeyValue1#'	
					AND    DateEffective <= getDate()
					AND    DateExpiration >= getDate()
					AND    Incumbency = 100		
					AND    AssignmentStatus IN ('0','1')	
					AND    AssignmentType = 'Actual'
			</cfquery>
										
			<cfif get.recordcount gte "2">
				
				<cfinvoke method    = "getValidationStruct" 					   
				   ValidationCode   = "#ValidationCode#"
				   PassCode			= "No"
				   returnvariable   = "result">	
			
			</cfif>
			
			<cfreturn result>
			 	   						 				
	</cffunction>	
					
		
</cfcomponent>	
