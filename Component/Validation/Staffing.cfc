
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
			
			<cf_tl id="#getValidationDefinition.ValidationTitle#"        var="lblVLabel">	
			<cf_tl id="#getValidationDefinition.ValidationInstructions#" var="lblVMemo">	
			
			<cfset vResult.label        = lblVLabel>
			<cfset vResult.passmemo     = lblVMemo>
			<cfset vResult.name         = getValidationDefinition.ValidationName>
			<cfset vResult.pass         = PassCode>
	
			<cfreturn vResult>
			
	</cffunction> 
	
	<cffunction name    = "Document" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "validates at least one activity with an output" 
		    output      = "true">	
					
			 <cfparam name="SystemFunctionId"   type="string"  default="">				
			 <cfparam name="Object"             type="string"  default="PersonNo">	
			 <cfparam name="ObjectKeyValue1"    type="string"  default="">	
			 <cfparam name="ValidationCode"     type="string"  default="">	
			 
			 <cfset result.pass = "OK">
			 
			 <cfquery name="get"
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					 SELECT       DocumentType, Description, EnableRemove, EnableEdit, VerifyDocumentNo, DocumentUsage, ListingOrder, OfficerUserId, OfficerLastName, OfficerFirstName, Created
		             FROM         Ref_DocumentType
		             WHERE        VerifyDocumentNo = '2' 
					 AND          DocumentType NOT IN
		                             (SELECT        DocumentType
		                               FROM         PersonDocument
		                               WHERE        PersonNo = '#ObjectKeyValue1#' 
									   AND          DependentId IS NULL 
									   AND          ActionStatus <> '9' 
									   AND          (DateExpiration IS NULL OR DateExpiration >= GETDATE())
									 )
																		   
	     	 </cfquery>
			 
			 <cfif get.recordcount gte "1">
			 			 			
						
				<cfinvoke method    = "getValidationStruct" 					   
				   ValidationCode   = "#ValidationCode#"
				   PassCode			= "No"
				   returnvariable   = "result">	
				
			  </cfif>
			
			  <cfreturn result>		   
			 
	</cffunction>		 
	
	<cffunction name    = "IncumbencyDouble" 
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
				    WHERE  PositionNo      = '#ObjectKeyValue1#'	
					AND    DateEffective   <= getDate()
					AND    DateExpiration  >= getDate()
					AND    Incumbency      = 100		
					AND    AssignmentStatus IN ('0','1')	
					AND    AssignmentType  = 'Actual'
			</cfquery>
																						
			<cfif get.recordcount gte "2">
					
				<cfinvoke method    = "getValidationStruct" 					   
				   ValidationCode   = "#ValidationCode#"
				   PassCode			= "No"
				   returnvariable   = "result">	
			
			</cfif>
			
			<cfreturn result>
			 	   						 				
	</cffunction>	
	
	<cffunction name    = "Fund" 
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
				    FROM   PositionParent
					WHERE  PositionParentId IN (SELECT PositionParentId FROM Position WHERE PositionNo      = '#ObjectKeyValue1#')	
					AND    Fund = 'ZZZ'					
			</cfquery>
																						
			<cfif get.recordcount gte "1">
					
				<cfinvoke method    = "getValidationStruct" 					   
				   ValidationCode   = "#ValidationCode#"
				   PassCode			= "No"
				   returnvariable   = "result">	
			
			</cfif>
			
			<cfreturn result>
			 	   						 				
	</cffunction>	
	
	<cffunction name    = "LienStatus" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "Check Lien status with incumbency" 
		    output      = "true">	
					
			 <cfparam name="SystemFunctionId"   type="string"  default="">				
			 <cfparam name="Object"             type="string"  default="Position">	
			 <cfparam name="ObjectKeyValue1"    type="string"  default="">	
			 <cfparam name="ValidationCode"     type="string"  default="">	
			 
			 <cfset result.pass = "OK">
			 			 
			 <cfquery name="status"
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT    PositionParentId, GroupCode, GroupListCode, OfficerUserId, OfficerLastName, OfficerFirstName, Created
                FROM      PositionParentGroup
                WHERE     GroupCode = 'Status' 
				AND       PositionParentId IN
                             (SELECT     PositionParentId
                               FROM      Position
                               WHERE     PositionNo = '#ObjectKeyValue1#')
			 </cfquery>	
						 
			 <cfquery name="get"
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   PersonAssignment
				    WHERE  PositionNo      = '#ObjectKeyValue1#'	
					AND    DateEffective   <= getDate()
					AND    DateExpiration  >= getDate()
					AND    Incumbency      = 0		
					AND    AssignmentStatus IN ('0','1')	
					AND    AssignmentType  = 'Actual'
			</cfquery>		
																												
			<cfif get.recordcount gte "1" 
			      and (status.GroupListCode eq "01" or status.GroupListCode eq "")>
					
				<cfinvoke method    = "getValidationStruct" 					   
				   ValidationCode   = "#ValidationCode#"
				   PassCode			= "No"
				   returnvariable   = "result">	
				 			   
			<cfelseif get.recordcount eq "0" and status.GroupListCode gt "01">
			
				<cfinvoke method    = "getValidationStruct" 					   
				   ValidationCode   = "#ValidationCode#"
				   PassCode			= "No"
				   returnvariable   = "result">	
				   
				<cfset result.passmemo = "No lien found">  				   
			
			</cfif>			
			
			<cfreturn result>
			 	   						 				
	</cffunction>	
	
	<!--- tagging --->
	
	<cffunction name    = "XBTagging" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "Check Tagging" 
		    output      = "true">	
					
			 <cfparam name="SystemFunctionId"   type="string"  default="">				
			 <cfparam name="Object"             type="string"  default="Position">	
			 <cfparam name="ObjectKeyValue1"    type="string"  default="">	
			 <cfparam name="ValidationCode"     type="string"  default="">	
			 
			 <cfset result.pass = "OK">
			 			 
			 <cfquery name="Tagging"
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT    *
                FROM      PositionGroup
                WHERE     PositionGroup LIKE 'MYA%' 
				AND       PositionNo = '#ObjectKeyValue1#'
			 </cfquery>	
						 
			 <cfquery name="Position"
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    *
                FROM      PositionParent
                WHERE     PositionParentId IN
                             (SELECT     PositionParentId
                               FROM      Position
                               WHERE     PositionNo = '#ObjectKeyValue1#')					
			</cfquery>		
																												
			<cfif (Position.Fund eq "32SZA" or Position.Fund eq "32CTI") and Tagging.recordcount eq "0">
					
				<cfinvoke method    = "getValidationStruct" 					   
				   ValidationCode   = "#ValidationCode#"
				   PassCode			= "No"
				   returnvariable   = "result">					   
			
			</cfif>			
			
			<cfreturn result>
			 	   						 				
	</cffunction>
	
	<!--- tagging --->
	
	<cffunction name    = "Recruitment" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "Check Tagging" 
		    output      = "true">	
					
			 <cfparam name="SystemFunctionId"   type="string"  default="">				
			 <cfparam name="Object"             type="string"  default="Position">	
			 <cfparam name="ObjectKeyValue1"    type="string"  default="">	
			 <cfparam name="ValidationCode"     type="string"  default="">	
			 
			 <cfset result.pass = "OK">
			 
			 <cfquery name="Position"
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    *
                FROM      Position
                WHERE     PositionNo = '#ObjectKeyValue1#'					
			</cfquery>		
			 			
			<cfquery name="Encumbency" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 SELECT *
					 FROM   PersonAssignment
					 WHERE  PositionNo      = '#ObjectKeyValue1#'
					 AND    AssignmentStatus IN ('0','1')
					 AND    AssignmentType = 'Actual'
					 AND    Incumbency = 100
					 AND    DateEffective  <= CAST(GETDATE() AS Date) 
					 and    DateExpiration >= CAST(GETDATE() AS Date)				
					 AND    DateEffective  < '#DateFormat(Position.DateExpiration,client.dateSQL)#'
			</cfquery>	
			
			<cfquery name="Track" 
			     datasource="AppsVacancy" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
					 SELECT *
					 FROM   Document
					 WHERE  DocumentNo IN (SELECT DocumentNo FROM DocumentPost WHERE PositionNo      = '#ObjectKeyValue1#')
					 AND    Status = '0'					
			</cfquery>	
																															
			<cfif Position.VacancyActionClass eq "Inspira" 
			     and Encumbency.recordcount eq "0" 
				 and Track.recordcount eq "0">
					
				<cfinvoke method    = "getValidationStruct" 					   
				   ValidationCode   = "#ValidationCode#"
				   PassCode			= "No"
				   returnvariable   = "result">					   
			
			</cfif>			
			
			<cfreturn result>
			 	   						 				
	</cffunction>
	
	<cffunction name    = "LienConflict" 
		    access      = "remote" 
		    returntype  = "any" 
		    displayname = "Check Lien overlap" 
		    output      = "true">	
					
			 <cfparam name="SystemFunctionId"   type="string"  default="">				
			 <cfparam name="Object"             type="string"  default="Position">	
			 <cfparam name="ObjectKeyValue1"    type="string"  default="">	
			 <cfparam name="ValidationCode"     type="string"  default="">	
			 
			 <cfset result.pass = "OK">
			 
			 <cfquery name="Lien"
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   TOP 1 *
				FROM     PersonAssignment PA
                WHERE    Incumbency = 0 
				AND      AssignmentStatus IN ('0', '1')
				AND      PositionNo = '#ObjectKeyValue1#'
				ORDER BY DateEffective DESC
			 </cfquery>								 
			 
			 <cfquery name="Encumbency"
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   TOP 1 *
				FROM     PersonAssignment PA
                WHERE    Incumbency = 100 
				AND      AssignmentStatus IN ('0', '1')
				AND      PositionNo = '#ObjectKeyValue1#'
				AND      DateExpiration >= getDate()
				AND      PersonNo != '#Lien.PersonNo#'
				ORDER BY DateEffective DESC					
			</cfquery>				
																															
			<cfif Lien.recordcount gte "1" and Encumbency.DateExpiration gt Lien.DateExpiration>
					
				<cfinvoke method    = "getValidationStruct" 					   
				   ValidationCode   = "#ValidationCode#"
				   PassCode			= "No"
				   returnvariable   = "result">					   
			
			</cfif>			
			
			<cfreturn result>
			 	   						 				
	</cffunction>	
	
					
		
</cfcomponent>	
