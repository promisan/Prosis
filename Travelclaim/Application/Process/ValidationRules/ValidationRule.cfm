<cfsilent>
  <proOwn>Joseph George</proOwn>
 <proDes>Template for validation Rules </proDes>
 <proCom>Made Changes to line Added 38-44, added 53-57 ,62-71 etc</proCom>
</cfsilent>

<!--- this template serves specific validations, 
each template must have the following name
ValidationRule_#validationcode# as stored in table Ref_Validation
Attention : only validations enabled for a dutystation will be performed
--->

<cfquery name="Rules" 
    datasource="appsTravelClaim">
	SELECT  V.Code, V.MessagePerson as Description
	FROM    Ref_Validation V, 
	        Ref_ValidationClass R
	WHERE   V.ValidationClass = R.Code
	AND     R.Code IN ('Rule1','Rule2','Fund','Advance') 
	AND     (Operational = 1 or Enforce = 1)
	AND     V.Code IN  (SELECT  ValidationCode
                   FROM    Ref_DutyStationValidation
                   WHERE   Mission = '#ClaimRequest.Mission#')
	ORDER BY R.ListingOrder			   
</cfquery>

<cfif fileExists("#SESSION.rootPath#/TravelClaim/Application/Process/ValidationRules/Validationvariables.cfm")>
<cfinclude template="Validationvariables.cfm">	
</cfif>

<cfloop query="Rules">   	
	
	<cfif fileExists("#SESSION.rootPath#/TravelClaim/Application/Process/ValidationRules/ValidationRule_#Code#.cfm")>
		
		<cfquery name="ValCheck" 
		    datasource="appsTravelClaim">
			SELECT *
			FROM   ClaimCalculation
			WHERE  ClaimId       = '#URL.ClaimID#'
			AND    CalculationId = '#rowguid#'
		</cfquery>	
		
		<cfif ValCheck.recordcount eq "1">
			
			<cfquery name="Record" 
			    datasource="appsTravelClaim">
				INSERT INTO ClaimValidationLog
				(CalculationId, ClaimId, ValidationCode, ValidationStart)
				VALUES
				('#rowguid#','#URL.ClaimID#','#code#',getDate())
			</cfquery>
			
			<!--- perform the validation --->	
			<cfinclude template="ValidationRule_#Code#.cfm">	
							
			<cfquery name="Record" 
			    datasource="appsTravelClaim">
				UPDATE ClaimValidationLog
				SET    ValidationEnd    = getDate(), 
				       ValidationStatus = 1
				WHERE  CalculationId    = '#rowguid#'			
				AND    ClaimId          = '#URL.ClaimID#' 
			</cfquery>
			
		<cfelse>
		
			<!--- perform the validation --->	
			<cfinclude template="ValidationRule_#Code#.cfm">	
		
		</cfif>	
		
	</cfif>	
				
</cfloop>
