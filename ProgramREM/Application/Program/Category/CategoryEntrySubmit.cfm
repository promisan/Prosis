
<cfparam name="Form.ProgramCategory" type="any" default="''">
<cfparam name="Form.ParentCode"      type="any" default="">
<cfparam name="Area"                 type="any" default="">

<!--- validation if de minimum requirements are met for this mission --->

<cfquery name="Mission" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT O.Mission 
	FROM   ProgramPeriod Pe INNER JOIN Organization.dbo.Organization O ON Pe.OrgUnit = O.OrgUnit
	WHERE  ProgramCode = '#url.programcode#'
	AND    Period      = '#url.period#'
</cfquery>	

<!--- we check if the control table has any values to contain the group --->

<cfquery name="isContained" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT	'X'
	FROM	Ref_ProgramCategoryControl
	WHERE	Mission        = '#Mission.Mission#'
	AND     ControlElement = 'Group'	
</cfquery>	

<cfquery name="BaseSet" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  M.*, R.Description
	FROM    Ref_ParameterMissionCategory M INNER JOIN Ref_ProgramCategory R	
	        ON M.Category = R.Code AND Mission = '#mission.mission#'
	AND		M.Obligatory = '1'
	AND     M.BudgetEarmark = 0
	AND     R.Area != 'Risk' <!--- reserved word --->
	
	<!--- kherrera(20150625): To differentiate RRR from a regular project  --->
	
	<cfif isContained.recordcount gte "1">
	
	AND		EXISTS (  SELECT	'X'
					  FROM		Ref_ProgramCategoryControl
				  	  WHERE	    Mission        = '#Mission.Mission#'
			 		  AND		Code           = R.Code
					  AND       ControlElement = 'Group'
					  AND       ControlValue IN ( SELECT ProgramGroup
								        	      FROM   ProgramGroup 
									              WHERE  ProgramCode = '#Form.ParentCode#' )
				
		    )
			
	</cfif>	
		
</cfquery>

<cfloop query="BaseSet">
	
	<cfquery name="check" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ProgramCategory
		WHERE    Code IN (#preserveSingleQuotes(Form.ProgramCategory)#) 
		AND      AreaCode = '#Category#'
		
	</cfquery>	
	
	<!---
	
	<cfif check.recordcount eq "0">
	
		 <cf_alert message = "You need to select a #Description#. Operation not allowed!" return = "back">
		 <cfabort>
	
	</cfif>
	
	--->

</cfloop>

<cfquery name="ResetCategorization" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  PC
	SET     Status = '9'
	FROM 	ProgramCategory PC
	WHERE   ProgramCode = '#Form.ProgramCode#'
	AND	    EXISTS (  SELECT	'X'
					  FROM	ProgramCategoryPeriod PCPx
					  WHERE	PCPx.ProgramCode = PC.ProgramCode
					  AND	PCPx.ProgramCategory = PC.ProgramCategory
					  AND	PCPx.Period = '#url.period#'
		    )
	<cfif area neq "">	
	AND     PC.ProgramCategory IN (SELECT Code 
	                               FROM   Ref_ProgramCategory 
								   WHERE  Area = '#Area#') 
	</cfif>
	
</cfquery>

<cfset url.status = "1">

<cfloop index="Item" 
        list="#Form.ProgramCategory#" 
        delimiters="' ,">

		<cfinclude template="CategoryEntrySubmitItem.cfm">
		
</cfloop>		
