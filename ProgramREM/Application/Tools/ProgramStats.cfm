
<cftry>

  <cfquery name="Drop"
	datasource="appsProgram">
      if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[vwAuditMonth]') 
	 and OBJECTPROPERTY(id, N'IsView') = 1)
     drop view [dbo].[vwAuditMonth]
  </cfquery>
  
	  <cfcatch></cfcatch>
  
  </cftry>
      
<cfquery name="CreateView"
	datasource="appsProgram">
	CREATE VIEW dbo.vwAuditMonth
	AS
	SELECT     TOP 100 PERCENT DateYear, DateMonth, MAX(AuditDate) AS AuditDate
	FROM         dbo.Ref_Audit
	WHERE     (ShowGraph = '1')
	GROUP BY DateYear, DateMonth
	ORDER BY DateYear, DateMonth
</cfquery>


<CF_DropTable dbName="AppsProgram" full="1"
              tblName="stProgramIndicatorWeight"> 	

<cfquery name="CreateIndicator"
	datasource="appsProgram">
SELECT     TOP 100 PERCENT P.Mission AS Tree, Pe.OrgUnit, Org.OrgUnitName,  Org.HierarchyCode, C.Description as ProgramCategoryName, P.ProgramCode, P.ProgramName, Pe.Period, I.ProgramCategory, 
           PI.IndicatorCode, I.IndicatorDescription, '0' AS AuditResult, I.IndicatorWeight, PI.TargetId, I.TargetDirection, I.TargetRange, GETDATE() AS Created
INTO       dbo.stProgramIndicatorWeight
FROM       Ref_Indicator I INNER JOIN
           Program P INNER JOIN
           ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN
           ProgramIndicator PI ON Pe.ProgramCode = PI.ProgramCode AND Pe.Period = PI.Period ON I.IndicatorCode = PI.IndicatorCode INNER JOIN
           Organization.dbo.Organization Org ON Pe.OrgUnit = Org.OrgUnit INNER JOIN
		   Ref_ProgramCategory C ON I.ProgramCategory = C.Code
WHERE      Pe.RecordStatus <> '9' AND PI.RecordStatus <> '9'
ORDER BY P.Mission, Pe.Period, Org.HierarchyCode, Pe.OrgUnit, PI.IndicatorCode
</cfquery>

<CF_DropTable dbName="AppsProgram" full="1"
              tblName="stProgramIndicatorMeasure"> 				  			  

<!--- update indicator audit result table --->
<cfquery name="CreateIndicator"
	datasource="appsProgram">
	SELECT   TOP 100 PERCENT P.Mission AS Tree, 
             Pe.OrgUnit, 
			 Org.OrgUnitName,
			 Org.HierarchyCode,
			 P.ProgramCode, 
			 P.ProgramName,
			 Pe.Period, 
			 PI.IndicatorCode,
			 I.ProgramCategory, 
			 I.IndicatorDescription, 
			 PA.Source, 
			 PT.TargetId,
			 PT.TargetValue, 
             PA.AuditTargetValue AS AuditValue, 
			 '0' as AuditResult, 
			 0 as AuditResultScore,
			 Aud.AuditDate, 
			 PA.Created AS Uploaded, 
			 PA.AuditStatus, 
			 I.IndicatorWeight, 
			 I.TargetDirection, 
             I.TargetRange, 
			 I.AuditSource,
			 PA.MeasurementId,
			 getDate() as Created
	INTO     dbo.stProgramIndicatorMeasure					  
	FROM     Ref_Indicator I INNER JOIN
             Program P INNER JOIN
             ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN
             ProgramIndicator PI ON Pe.ProgramCode = PI.ProgramCode AND Pe.Period = PI.Period ON I.IndicatorCode = PI.IndicatorCode INNER JOIN
             ProgramIndicatorTarget PT ON PI.TargetId = PT.TargetId INNER JOIN
             Ref_Audit Aud INNER JOIN
             ProgramIndicatorAudit PA ON Aud.AuditId = PA.AuditId ON PT.SubPeriod = Aud.SubPeriod AND PI.TargetId = PA.TargetId AND 
             Pe.Period = Aud.Period
             INNER JOIN
			 Organization.dbo.Organization Org ON Pe.OrgUnit = Org.OrgUnit
			 
	<!---		  
	WHERE     (P.Mission = 'HRPO') 
	AND       (Pe.Period = 'P07-08') 
	AND       (Aud.AuditDate = '10/31/2007') 
	--->
	WHERE     (Pe.RecordStatus <> '9') 
	AND       (PI.RecordStatus <> '9')
	ORDER BY P.Mission, Pe.Period, Org.HierarchyCode, Pe.OrgUnit, PI.IndicatorCode, Aud.AuditDate, PA.Source 
</cfquery>

<!--- update if passes the target --->

<cfquery name="Update1"
	datasource="appsProgram">
UPDATE   stProgramIndicatorMeasure
SET      AuditResult = '2', AuditResultScore = IndicatorWeight
WHERE     (AuditValue >= TargetValue) AND (TargetDirection = 'Up')
</cfquery>

<cfquery name="Update1b"
	datasource="appsProgram">
UPDATE    stProgramIndicatorMeasure
SET       AuditResult = '1', AuditResultScore = IndicatorWeight/2
WHERE     AuditValue >= TargetValue-(TargetValue*(TargetRange/100)) AND (TargetDirection = 'Up')
AND   AuditResult = '0'
</cfquery>

<cfquery name="Update2"
	datasource="appsProgram">
UPDATE    stProgramIndicatorMeasure
SET       AuditResult = '2', AuditResultScore = IndicatorWeight
WHERE     (AuditValue <= TargetValue) AND (TargetDirection = 'Down')
</cfquery>

<cfquery name="Update2b"
	datasource="appsProgram">
UPDATE   stProgramIndicatorMeasure
SET      AuditResult = '1', AuditResultScore = IndicatorWeight/2
WHERE    AuditValue <= TargetValue+(TargetValue*(TargetRange/100)) 
AND      TargetDirection = 'Down'
AND      AuditResult = '0'
</cfquery>

  
  
