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

<cfparam name="url.ProgramName"    default="">
<cfparam name="url.ProgramCategory" default="">

<cfset FileNo = round(Rand()*100)>
<cfset fileNo = "#SESSION.acc#_#fileNo#">

<CF_DropTable dbName="AppsQuery" 
      tblName="ProgramIndicatorWeight#fileNo#"> 
	
<!--- set base score --->	
  
<cfquery name="Score"
datasource="appsProgram">	
  		
SELECT  OrgUnit, 
		HierarchyCode,
        ProgramCode, 
		ProgramCategory, 
		ProgramCategoryName,
		OrgUnitName, 
		ProgramName, 
		<cfif url.ProgramName eq "">
		Count(DISTINCT IndicatorCode) as Indicators,	
		SUM(IndicatorWeight) AS MaxScore, 	
		<cfelse>
		IndicatorCode,
		IndicatorDescription,
		TargetId,
		IndicatorWeight AS MaxScore, 
		</cfif>				
		0 as Result,
		999.9 AS ResultExternal, 
		999.9 AS ResultManual,
		0 as MissingAudits
INTO    userquery.dbo.ProgramIndicatorWeight#fileNo#			
FROM    stProgramIndicatorWeight
WHERE   Tree = '#URL.Tree#' 
AND     Period = '#URL.Period#'
<cfif url.ProgramName neq "">
AND     ProgramCategory = '#URL.ProgramCategory#'
AND     ProgramName     = '#URL.ProgramName#'
	<cfif URL.OrgUnit neq "0">	
	AND     OrgUnit         = '#URL.OrgUnit#'  
	</cfif>
<cfelse>
GROUP BY HierarchyCode, OrgUnitName, ProgramCategoryName, ProgramCategory, ProgramCode, ProgramName, OrgUnit
</cfif>

<cfif url.ProgramName eq "">

	UNION

	SELECT  0 as OrgUnit, 
			'0' as HierarchyCode,
	        '0' as ProgramCode, 
			ProgramCategory, 
			ProgramCategoryName,
			'Overall' as OrgUnitName, 
			ProgramName, 
			<cfif url.ProgramName eq "">
			Count(DISTINCT IndicatorCode) as Indicators,	
			SUM(IndicatorWeight) AS MaxScore, 	
			<cfelse>
			IndicatorCode,
			IndicatorDescription,
			TargetId,
			IndicatorWeight AS MaxScore, 
			</cfif>		
			0 as Result,
			999.9 AS ResultExternal, 
			999.9 AS ResultManual,
			0 as MissingAudits
		
	FROM    stProgramIndicatorWeight
	WHERE   Tree = '#URL.Tree#' 
	AND     Period = '#URL.Period#'		
	GROUP BY ProgramCategoryName, ProgramCategory, ProgramName	

</cfif>

</cfquery>

<!--- phase 2 : scores --->

<CF_DropTable dbName="AppsQuery" 
      tblName="ProgramIndicatorScore#fileNo#"> 

<cfquery name="Score"
datasource="appsProgram">	
SELECT   '0' as OrgUnit, 
         '9' as ProgramCode, 
		 ProgramCategory, 
		 ProgramName, 
		 AuditSource, 
		 Source, 
		 <cfif url.ProgramName neq "">
		 	IndicatorCode,
			AuditResultScore AS Score
		 <cfelse>
			SUM(AuditResultScore) AS Score
		 </cfif>
INTO     userquery.dbo.ProgramIndicatorScore#fileNo#	
FROM     stProgramIndicatorMeasure
WHERE    Tree      = '#URL.Tree#' 
AND      Period    = '#URL.Period#'
AND      AuditDate = '#date#'
<cfif url.ProgramName neq "">
	AND     ProgramCategory = '#URL.ProgramCategory#'
	AND     ProgramName     = '#URL.ProgramName#'
	<cfif url.OrgUnit neq "0">
	AND     OrgUnit         = '#URL.OrgUnit#'  
	</cfif>
<cfelse>
	GROUP BY ProgramCategory, ProgramName, Source,AuditSource
</cfif>

UNION

SELECT   OrgUnit, 
         ProgramCode, 
		 ProgramCategory, 
		 ProgramName, 
		 AuditSource, 
		 Source, 		 
		 <cfif url.ProgramName neq "">
		 	IndicatorCode,
			AuditResultScore AS Score
		 <cfelse>
			SUM(AuditResultScore) AS Score
		 </cfif>
FROM     stProgramIndicatorMeasure
WHERE    Tree      = '#URL.Tree#' 
AND      Period    = '#URL.Period#'
AND      AuditDate = '#date#'   
<cfif url.ProgramName neq "">
	AND     ProgramCategory = '#URL.ProgramCategory#'
	AND     ProgramName     = '#URL.ProgramName#'
	<cfif URL.OrgUnit neq "0">
	AND     OrgUnit         = '#URL.OrgUnit#' 
	</cfif>
<cfelse>
	GROUP BY OrgUnit, ProgramCategory, ProgramCode, ProgramName, Source, AuditSource 
</cfif>


</cfquery>

<!--- phase 3 : merging --->

<!--- if target is manual update external with manual otherwise text external --->
<cfquery name="ScoreSet0"
datasource="appsQuery">	
	UPDATE    ProgramIndicatorWeight#fileNo#
	SET       ResultExternal = Audit.Score,
			  ResultManual   = Audit.Score,
			  Result = 1
	FROM      ProgramIndicatorWeight#fileNo# PI INNER JOIN
	          ProgramIndicatorScore#fileNo# Audit ON PI.OrgUnit = Audit.OrgUnit 
			                                AND PI.ProgramName = Audit.ProgramName 
											AND PI.ProgramCategory = Audit.ProgramCategory 
											<cfif url.ProgramName neq "">
											AND PI.IndicatorCode= Audit.IndicatorCode
											</cfif>
	<!--- WHERE     Audit.AuditSource = 'External' --->
	WHERE      Audit.Source != 'Manual'
</cfquery>

<!--- if manual update manual and update external is external is 999 --->
<cfquery name="ScoreSet1"
datasource="appsQuery">	
	UPDATE    ProgramIndicatorWeight#fileNo#
	SET       ResultManual   = Audit.Score,
	          Result = 1
	FROM      ProgramIndicatorWeight#fileNo# PI INNER JOIN
	          ProgramIndicatorScore#fileNo# Audit ON PI.OrgUnit = Audit.OrgUnit 
			                                AND PI.ProgramName      = Audit.ProgramName 
											AND PI.ProgramCategory  = Audit.ProgramCategory
											<cfif url.ProgramName neq "">
											AND PI.IndicatorCode= Audit.IndicatorCode
											</cfif>
	<!--- WHERE     Audit.AuditSource = 'Manual' --->
	WHERE      Audit.Source = 'Manual'
</cfquery>

<!--- if manual update manual and update external is external is 99999 --->
<cfquery name="ScoreSet2"
datasource="appsQuery">	
UPDATE    ProgramIndicatorWeight#fileNo#
SET       ResultExternal = Audit.Score,
          Result = 1
FROM      ProgramIndicatorWeight#fileNo# PI INNER JOIN
          ProgramIndicatorScore#fileNo# Audit ON PI.OrgUnit = Audit.OrgUnit
		                                 AND PI.ProgramName = Audit.ProgramName 
										 AND PI.ProgramCategory = Audit.ProgramCategory
										 <cfif url.ProgramName neq "">
										AND PI.IndicatorCode= Audit.IndicatorCode
										</cfif>
WHERE     Audit.AuditSource = 'Manual'		  
AND       Audit.Source = 'Manual'
AND       ResultExternal = 999.9
</cfquery>

<cfquery name="ScoreSet2"
datasource="appsQuery">	
UPDATE    ProgramIndicatorWeight#fileNo#
SET       ResultExternal = 0, ResultManual = 0
WHERE     Result = 0
</cfquery>


