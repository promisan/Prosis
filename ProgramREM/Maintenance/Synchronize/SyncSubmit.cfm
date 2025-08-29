<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="URL.Base" default="0">
<cfparam name="Form.ProgramCode" default="">
<cfparam name="Form.Destination" default="">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfif #Form.ProgramCode# eq "">

	<cf_message message="No program area selected" return="no">
	<cfabort>

</cfif>

<cfif form.period neq url.period>

	<cfif form.destination eq "">
	   <cfset form.destination = "''">
	</cfif>

<cfelseif Form.Destination eq ""> 

	<cf_message message="No destination unit selected" return="no">
	<cfabort>

</cfif>

<body>

<!--- steps 

1. define org units to be distributed to 
2. retrieve programs
3. insert programs
4. insert period
5. insert category
6. insert indicator
7. blank targets
8. generate measurements

--->

<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   *
FROM     Program
WHERE    ProgramCode IN (#preserveSingleQuotes(Form.ProgramCode)#) 
</cfquery>

<cfquery name="Destination" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   OrgUnit, OrgUnitCode
FROM     Organization Org
WHERE    OrgUnit  IN (#Form.Destination#) 
<cfif form.period neq url.period>
OR OrgUnit = '#Form.Base#'
</cfif>
</cfquery>

<cfoutput query="Destination">

    <cfset unit = '#OrgUnitCode#'>
	
	<cfif Form.Retain eq "0">

	    <cfloop query="Program">
		
			<cfset prg = "#ProgramCode#">
		
			<cfquery name="Select" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM  Program
			WHERE ProgramCode LIKE '%-#unit#'
			AND   ProgramClass = 'Component'					  
			</cfquery>
			
			<cfloop query="Select">
			
				<cfif #ProgramCode# eq "#prg#-#unit#">
				
				    <cfquery name="Select" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						DELETE FROM   Program
						WHERE  ProgramCode = '#prg#-#unit#'
					</cfquery>
					
				</cfif>
			
			</cfloop>
		
		</cfloop>
	
	</cfif>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td>Init : #OrgUnitCode#</td></tr>
	</table>
	<cfflush>

</cfoutput>	

<cfoutput query = "Destination">
	
	<cfset unit = OrgUnitCode>
	
	<cftransaction>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td>Insert : #OrgUnitCode#</td></tr>
	</table>
	<cfflush>
	  	
		<cfquery name="Program" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Program
				   (Mission,
				   ProgramCode,
		           ProgramClass, 
				   ProgramName, 
				   ProgramDescription, 
				   ProgramGoal, 
				   ProgramObjective, 
				   ListingOrder, 
				   ProgramScope, 
				   <!---
				   ParentCode, 
		           ProgramHierarchy, 
				   --->
				   ProgramStatus, 
				   StatusUrgency, 
				   StatusImportancy, 
				   StatusNecessity, 
				   OfficerUserId, 
				   OfficerLastName, 
		           OfficerFirstName)
		SELECT     P.Mission,
		           P.ProgramCode+'-#unit#',
		           P.ProgramClass, 
				   P.ProgramName, 
				   P.ProgramDescription, 
				   P.ProgramGoal, 
				   P.ProgramObjective, 
				   P.ListingOrder, 
				   P.ProgramScope, 
				   <!---
				   P.ParentCode, 
		           P.ProgramHierarchy, 
				   --->
				   P.ProgramStatus, 
				   P.StatusUrgency, 
				   P.StatusImportancy, 
				   P.StatusNecessity, 
				   '#SESSION.acc#', 
				   '#SESSION.last#', 
		           '#SESSION.first#'
		FROM       Program P
		WHERE      ProgramCode IN (#preserveSingleQuotes(Form.ProgramCode)#) 
		AND        (ProgramCode+'-#unit#') NOT IN (SELECT  ProgramCode
								FROM    Program
								WHERE   ProgramCode LIKE '%-#unit#')
		</cfquery>
			
		<cfquery name="ProgramPeriod" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ProgramPeriod
				(ProgramCode, 
				 Period, 
				 OrgUnit, 
				 OrgUnitImplement, 
				 PeriodHierarchy,
				 PeriodParentCode,
				 Reference, 
				 RecordStatus, 
				 Status, 
				 OfficerUserId, 
				 OfficerLastName, 
			     OfficerFirstName)
		 SELECT  Pe.ProgramCode+'-#unit#',
		         '#Form.Period#',
		         '#OrgUnit#', 
				 '#OrgUnit#',
				 Pe.PeriodHierarchy,
				 Pe.PeriodParentCode,
				 Pe.Reference, 
				 Pe.RecordStatus, 
				 Pe.Status, 
				 '#SESSION.acc#', 
				 '#SESSION.last#', 
		         '#SESSION.first#'
		FROM     ProgramPeriod Pe
		WHERE    ProgramCode IN (#preserveSingleQuotes(Form.ProgramCode)#) 
		AND      Period = '#URL.Period#'
		AND      (ProgramCode+'-#unit#') NOT IN (SELECT  ProgramCode
						FROM    ProgramPeriod
						WHERE   ProgramCode LIKE '%-#unit#'
						AND     Period = '#Form.Period#') 
		</cfquery>
		
		<cfquery name="ProgramCategory" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ProgramCategory
				(ProgramCode, 
				 ProgramCategory, 
				 Status, 
				 OfficerUserId, 
				 OfficerLastName, 
			     OfficerFirstName)
		 SELECT  Pc.ProgramCode+'-#unit#',
		         Pc.ProgramCategory,
		         Pc.Status, 
				 '#SESSION.acc#', 
				 '#SESSION.last#', 
		         '#SESSION.first#'
		FROM     ProgramCategory Pc
		WHERE    ProgramCode IN (#preserveSingleQuotes(Form.ProgramCode)#) 
		AND      (ProgramCode+'-#unit#') NOT IN (SELECT  ProgramCode
									             FROM    ProgramCategory
								                 WHERE   ProgramCode LIKE '%-#unit#')
	    </cfquery>
		
		<cfquery name="ProgramIndicator" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO ProgramIndicator
				(ProgramCode, 
				 Period, 
				 IndicatorCode,
				 LocationCode,
				 Remarks,
				 RecordStatus, 
				 OfficerUserId, 
				 OfficerLastName, 
			     OfficerFirstName)
		 SELECT  PI.ProgramCode+'-#unit#',
		         '#Form.Period#',
				 PI.IndicatorCode,
				 PI.LocationCode,
				 PI.Remarks,
				 PI.RecordStatus, 
				 '#SESSION.acc#', 
				 '#SESSION.last#', 
		         '#SESSION.first#'
		FROM     ProgramIndicator PI
		WHERE    ProgramCode IN (#preserveSingleQuotes(Form.ProgramCode)#) 
		AND      Period = '#URL.Period#'
		AND      RecordStatus != '9'
		AND      (ProgramCode+'-#unit#') NOT IN (SELECT  ProgramCode
								                 FROM    ProgramIndicator
	                 							 WHERE   ProgramCode LIKE '%-#unit#'
												 AND     Period = '#Form.Period#') 
		</cfquery>
		
		<cfquery name="SubPeriod" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM Ref_SubPeriod
		</cfquery>
		
		<cfset prog = replace("#preserveSingleQuotes(Form.ProgramCode)#", "'", "", "ALL")>
				
			<cfloop query="SubPeriod">
			
				<CFTRY>
			
				<cfquery name="ProgramTarget" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO ProgramIndicatorTarget
						(TargetId, 
						 TargetValue,
						 SubPeriod)
				 SELECT  PI.TargetId,
				         0,
				         '#subperiod#'
				FROM     ProgramIndicator PI
				WHERE    ProgramCode = '#prog#-#unit#' 
				AND      Period = '#Form.Period#'
				AND      RecordStatus != '9'
				AND      (ProgramCode+'-#unit#') NOT IN (SELECT  ProgramCode
									FROM    ProgramIndicator PI, ProgramIndicatorTarget PT
									WHERE   ProgramCode LIKE '%-#unit#'
									AND     Period = '#Form.Period#'
									AND PI.TargetId = PT.TargetId)
				</cfquery>		
				
				<CFCATCH></CFCATCH>	
				</CFTRY>
				
			</cfloop>
		
		</cftransaction>
	
</cfoutput>

<cfoutput>
<script language="JavaScript">
	alert("Indicators have been synchronised")
	parent.ColdFusion.Window.hide('process')
</script>
</cfoutput>
