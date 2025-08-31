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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"><HTML><HEAD>

<TITLE>Indicator</TITLE>
	
</HEAD>
	
<cf_wait text="Initializing">

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Indicator">
		
<cfquery name="Combinations" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    Pe.ProgramCode, Pe.Period, R.IndicatorCode, PL.LocationCode
INTO      userQuery.dbo.#SESSION.acc#Indicator
FROM      ProgramPeriod Pe INNER JOIN
          ProgramCategory PC ON Pe.ProgramCode = PC.ProgramCode INNER JOIN
          Ref_Indicator R ON PC.ProgramCategory = R.ProgramCategory INNER JOIN
          Program P ON Pe.ProgramCode = P.ProgramCode INNER JOIN
          Ref_IndicatorMission RM ON R.IndicatorCode = RM.IndicatorCode AND P.Mission = RM.Mission LEFT OUTER JOIN
          ProgramLocation PL ON Pe.ProgramCode = PL.ProgramCode
WHERE     (P.Mission = '#URL.Mission#')
</cfquery>		

<cfquery name="Update" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE #SESSION.acc#Indicator 
	SET    LocationCode = ''
	WHERE  LocationCode is NULL
</cfquery>		

<cfquery name="InsertIndicator" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO ProgramIndicator
            (ProgramCode, Period, IndicatorCode, LocationCode, OfficerUserId)
SELECT     R.ProgramCode, R.Period, R.IndicatorCode, R.LocationCode, 'Generated' AS Expr1
FROM        ProgramIndicator PI RIGHT OUTER JOIN
            userQuery.dbo.#SESSION.acc#Indicator R ON 
			     PI.ProgramCode = R.ProgramCode 
			 AND PI.Period = R.Period 
			 AND PI.IndicatorCode = R.IndicatorCode 
			 AND PI.LocationCode = R.LocationCode
GROUP BY R.ProgramCode, R.Period, R.IndicatorCode, R.LocationCode, PI.TargetId
HAVING      (PI.TargetId IS NULL)  
</cfquery>	

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Indicator">

<cfquery name="CombinationsTarget" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     ProgramIndicator.TargetId, Ref_Subperiod.SubPeriod
INTO       userQuery.dbo.#SESSION.acc#Indicator
FROM       ProgramIndicator CROSS JOIN
           Ref_Subperiod
</cfquery>	

<cfquery name="CombinationsTarget" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO ProgramIndicatorTarget
           (TargetId, SubPeriod, TargetValue)
SELECT     R.TargetId, R.SubPeriod,'0'
FROM        ProgramIndicatorTarget PT RIGHT OUTER JOIN
            userQuery.dbo.#SESSION.acc#Indicator R ON PT.TargetId = R.TargetId AND PT.SubPeriod = R.SubPeriod
GROUP BY R.TargetId, R.SubPeriod, PT.Created
HAVING      (PT.Created IS NULL)
</cfquery>	

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Indicator">

<cfquery name="CombinationsAudit" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT    PI.TargetId, A.AuditId, S.Source, S.IndicatorCode
INTO      userQuery.dbo.#SESSION.acc#Indicator
FROM      ProgramIndicator PI INNER JOIN
          Ref_IndicatorSource S ON PI.IndicatorCode = S.IndicatorCode CROSS JOIN
          Ref_Audit A
</cfquery>	

<cfquery name="CombinationsAudit" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO ProgramIndicatorAudit
           (TargetId, AuditId,Source)
SELECT     R.TargetId, R.AuditId, R.Source
FROM        ProgramIndicatorAudit PT RIGHT OUTER JOIN
            userQuery.dbo.#SESSION.acc#Indicator R ON PT.TargetId = R.TargetId 
			                                   AND PT.AuditId = R.AuditId
											   AND PT.Source = R.Source
GROUP BY R.TargetId, R.AuditId, R.Source, PT.Created 
HAVING      (PT.Created IS NULL)
</cfquery>	

<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Indicator">

<cfoutput>
<script>
	window.location = "RecordListing.cfm?idmenu=#url.idmenu#"
</script>
</cfoutput>

 