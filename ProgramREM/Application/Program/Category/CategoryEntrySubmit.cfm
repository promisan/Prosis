<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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
        delimiters="',">

		<cfinclude template="CategoryEntrySubmitItem.cfm">
		
</cfloop>		

<cfquery name="UpdateGroup" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM ProgramCategoryPeriod			
		WHERE  ProgramCode      = '#Form.ProgramCode#' 
		AND    Period           = '#URL.Period#'
		<cfif area neq "">	
	    AND    ProgramCategory IN (SELECT Code 
	                               FROM   Ref_ProgramCategory 
								   WHERE  Area = '#Area#') 
	    </cfif>
		AND   ProgramCategory NOT IN (#preserveSingleQuotes(Form.ProgramCategory)#)
		 		 
</cfquery>
