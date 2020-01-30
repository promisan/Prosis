
<cfparam name="Form.ProgramCategory" type="any" default="''">
<cfparam name="Form.ParentCode" type="any" default="">
<cfparam name="Area" type="any" default="">

<!--- validation if de minimum requirements are met for this mission --->

<cfquery name="BaseSet" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  M.*, R.Description
	FROM    Ref_ParameterMissionCategory M INNER JOIN Ref_ProgramCategory R	
	        ON M.Category = R.Code AND Mission = (SELECT Mission FROM Program WHERE ProgramCode = '#url.programcode#')
	AND		M.Obligatory = '1'
	AND     M.BudgetEarmark = 0
	AND     R.Area != 'Risk' <!--- reserved word --->
	
	<!--- kherrera(20150625): To differentiate RRR from a regular project  --->
	
	AND		EXISTS
		(
			SELECT	'X'
			FROM	Ref_ProgramGroupCategory
			WHERE	Code IN (
								SELECT ProgramGroup
								FROM   ProgramGroup 
								WHERE  ProgramCode = '#Form.ParentCode#'
							)
			AND		Category = R.Code
		)
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

<cfquery name="ResetGroup" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE PC
	SET    Status = '9'
	FROM 	ProgramCategory PC
	WHERE   ProgramCode = '#Form.ProgramCode#'
	AND	    EXISTS	 
		   (
			  SELECT	'X'
			  FROM	ProgramCategoryPeriod PCPx
			  WHERE	PCPx.ProgramCode = PC.ProgramCode
			  AND	PCPx.ProgramCategory = PC.ProgramCategory
			  AND	PCPx.Period = '#url.period#'
		   )
	<cfif area neq "">	
	AND    PC.ProgramCategory IN (SELECT Code FROM Ref_ProgramCategory WHERE Area = '#Area#') 
	</cfif>
</cfquery>

<cfset url.status = "1">

<cfloop index="Item" 
        list="#Form.ProgramCategory#" 
        delimiters="' ,">

		<cfinclude template="CategoryEntrySubmitItem.cfm">
		
</cfloop>		
