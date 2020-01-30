	
<cfparam name="URL.Mode" default="view">
<cfparam name="URL.id1" default="">

<cfif url.id1 neq "">

	<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Organization
		WHERE OrgUnit = '#URL.ID1#'
	</cfquery>

</cfif>	

<cfif url.mode neq "Excel">

	<cfoutput>
	
	<script language="JavaScript">	
	
		function show(bx) {
		se  = document.getElementsByName("l"+bx)
		se1 = document.getElementById("l"+bx+"_collapse")
		se2 = document.getElementById("l"+bx+"_expand")
		
		count = 0
		
		if (se1.className == "regular") 
		{ se1.className = "hide";
		  se2.className = "regular";
		  while (se[count])
			{ se[count].className = "regular"; 
			  count++; }
		}
		else
		{ se1.className = "regular"
		  se2.className = "hide"
		  while (se[count])
			{ se[count].className = "hide"; 
			  count++; }
		}  
		
		}
		
		function moredetail(bx,act,id) {
		 
			icM  = document.getElementById(bx+"Min")
		    icE  = document.getElementById(bx+"Exp")
			se   = document.getElementById("e_"+bx+"a");
			se1  = document.getElementById("e_"+bx+"b");
			frm  = document.getElementById("i"+bx);
				 		 
			if (se.className=="hide") {		    
			   	 icM.className  = "regular";
			     icE.className  = "hide";
				 se.className   = "regular";
				 se1.className  = "regular";			
				 window.open("#SESSION.root#/ProgramREM/Application/Indicator/Audit/IndicatorAuditGraph.cfm?h=200&ts="+new Date().getTime()+"&id=" + id + "&period=#URL.Period#", "i"+bx)
		         window.scrollBy(255,255)
			 } else {		     
			   	 icM.className = "hide";
			     icE.className = "regular";
				 se.className  = "hide"
				 se1.className  = "hide";
			 }			 		
		  }	
		 
		function target(prg,per) {
		     w = #CLIENT.width# - 100;
		     h = #CLIENT.height# - 150;
			 window.open("#SESSION.root#/ProgramREM/Application/Program/Indicator/TargetView.cfm?ProgramCode="+prg+"&Period="+per+"&layout=&mode=edit","_blank", "left=40, top=40, width=" + w + ", height= " + h + ", toolbar=no, status=yes, menubar=no, scrollbars=no, resizable=yes")	
		}
		
		function printme() {
		     w = #CLIENT.width# - 100;
		     h = #CLIENT.height# - 150;
			 window.open("#SESSION.root#/ProgramREM/Application/Indicator/Audit/IndicatorSummary.cfm?Mission=#URL.Mission#&Mandate=#URL.Mandate#&ID1=#Org.OrgUnit#&ID2=#url.id2#&Period=#URL.Period#&Mode=print","_blank", "left=40, top=40, width=" + w + ", height= " + h + ", toolbar=no, status=yes, menubar=no, scrollbars=yes, resizable=yes")
		}
	  
	</script> 
	
	</cfoutput> 
	

</cfif>

<body>

<!--- create table --->

<cfparam name="fileNo" default="7">

<CF_DropTable dbName="AppsQuery" 
              tblName="#SESSION.acc#ProgramMonitoring#FileNo#"> 
			
<CF_DropTable dbName="AppsQuery" 
              tblName="#SESSION.acc#Targets#FileNo#"> 				  
	
<CF_DropTable dbName="AppsQuery" 
              tblName="#SESSION.acc#Milestones#FileNo#"> 	
			
<CF_DropTable dbName="AppsQuery" 
              tblName="#SESSION.acc#Actuals#FileNo#"> 				  		  
		  
<cfquery name="Check"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">			  
	SELECT * 
	FROM   Ref_Audit
	WHERE  Period = '#URL.Period#'
</cfquery>		  

<cfif check.recordcount lte "2">

	<cf_waitEnd>
	<cf_message message="Problem, no indicator measurement dates found for this period. Please contact your administrator">
	<cfabort>

</cfif>
			  
<cfquery name="SubPeriod"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">			  
	SELECT * 
	FROM Ref_SubPeriod
</cfquery>

<cfquery name="CreateTable"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	CREATE TABLE dbo.#SESSION.acc#ProgramMonitoring#FileNo# (
		[TargetId]  uniqueidentifier  NOT NULL ,
		[Actual_init] [float] NULL ,
		[Status_init] [varchar] (2) NULL ,
		[Target_current] [float] NULL ,
		[Target_currentAlternate] [varchar] (200) NULL ,
		[Actual_current] [float] NULL ,
		[Status_current] [varchar] (2) NULL ,
		<cfloop query="SubPeriod">
		[Target_#subperiod#] [float] NULL ,
		[Actual_#subperiod#] [float] NULL ,
		[Status_#subperiod#] [varchar] (2) NULL ,
		[Trend_#subperiod#] [float] NULL ,
		</cfloop>
		[OfficerUserId] [varchar] (20) NULL)
</cfquery>

<cf_OrganizationSelect OrgUnit = "#Org.Orgunit#">

<!--- retrieve the target --->

<cfquery name="Target"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">		
	SELECT    DISTINCT PI.TargetId, 
	                   TG.TargetValue, 
					   TG.TargetAlternate, 
					   TG.SubPeriod 
	INTO      userQuery.dbo.#SESSION.acc#Targets#FileNo#
	FROM      ProgramIndicatorTarget TG INNER JOIN
		      ProgramIndicator PI ON TG.TargetId = PI.TargetId INNER JOIN
		      ProgramPeriod Pe ON PI.ProgramCode = Pe.ProgramCode AND PI.Period = Pe.Period
	WHERE     Pe.OrgUnit IN (SELECT OrgUnit 
	                         FROM Organization.dbo.Organization 
							 WHERE Mission    = '#URL.Mission#'
							  AND  MandateNo  = '#URL.Mandate#'
				              AND  HierarchyCode >= '#HStart#' 
	         			      AND  HierarchyCode < '#HEnd#') 
	  AND     Pe.Period = '#URL.Period#' 
	  AND     Pe.RecordStatus != '9'  
	  AND     PI.RecordStatus != '9'    
</cfquery>

<!--- populate the targets --->

<cfloop query="subperiod">

    <cfif CurrentRow eq "1">

		<cfquery name="Targets"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
			INSERT INTO  dbo.#SESSION.acc#ProgramMonitoring#FileNo#
			(TargetId, [Target_#subperiod#], Target_CurrentAlternate, OfficerUserId)  
			SELECT    TargetId, TargetValue, TargetAlternate, '#SESSION.acc#'
			FROM      dbo.#SESSION.acc#Targets#FileNo#
			WHERE     Subperiod = '#SubPeriod.SubPeriod#' 
		</cfquery> 
	
	<cfelse>
	
		<cfquery name="Targets"
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
			UPDATE #SESSION.acc#ProgramMonitoring#FileNo#
			SET [Target_#subperiod#] =  TargetValue 
			FROM  dbo.#SESSION.acc#ProgramMonitoring#FileNo# M, 
			      dbo.#SESSION.acc#Targets#FileNo# T
			WHERE M.TargetId = T.TargetId
			AND   T.Subperiod = '#SubPeriod.SubPeriod#'
		</cfquery> 
	
	</cfif> 

</cfloop>

<!--- populate the actual - 1--->

<cfquery name="Milestones"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">			  
	SELECT   'Init' AS Milestone, '#URL.Period#' as Period, MIN(AuditDate) AS AuditDate
	INTO     userQuery.dbo.#SESSION.acc#Milestones#FileNo#
	FROM     Ref_Audit A
	WHERE    Period = '#URL.Period#'
	  UNION
	SELECT   R.Subperiod AS Milestone, '#URL.Period#' as Period, MAX(AuditDate) AS AuditDate
	FROM     Ref_Subperiod R INNER JOIN
	         Ref_Audit A ON R.SubPeriod = A.SubPeriod
	WHERE    Period = '#URL.Period#'		 
	GROUP BY R.SubPeriod
	 UNION
	SELECT   'Current' as Milestone, '#URL.Period#' as Period, MAX(AuditDate) AS AuditDate
	FROM      Ref_Audit 
	WHERE     AuditDate < getDate()
	
	AND       AuditDate IN (
							SELECT    TOP 1 R.AuditDate
							FROM      ProgramIndicatorAudit M INNER JOIN
							          Ref_Audit R ON M.AuditId = R.AuditId INNER JOIN
							          ProgramIndicator ON M.TargetId = ProgramIndicator.TargetId INNER JOIN
							          Program ON ProgramIndicator.ProgramCode = Program.ProgramCode
							WHERE     M.AuditTargetValue > 0 
							AND       R.AuditDate < GETDATE() 
							AND       Program.Mission = '#URL.Mission#'
							ORDER BY R.AuditDate DESC
						   )
						  
	AND       Period = '#URL.Period#' 
	ORDER BY AuditDate
</cfquery>

<cfquery name="Delete"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">			  
DELETE FROM userQuery.dbo.#SESSION.acc#Milestones#FileNo#
WHERE Milestone = 'Current'
AND   AuditDate IN (SELECT AuditDate 
                    FROM userQuery.dbo.#SESSION.acc#Milestones#FileNo#
					WHERE Milestone != 'Current')
</cfquery>

<!--- populate the actual - 2 --->

<cfquery name="Actuals"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">		
SELECT DISTINCT A.TargetId, 
                A.AuditTargetValue, 
				A.AuditStatus,
				S.Milestone
INTO      userQuery.dbo.#SESSION.acc#Actuals#FileNo#
FROM      ProgramIndicatorAudit A INNER JOIN
          ProgramIndicator PI ON A.TargetId = PI.TargetId INNER JOIN
          ProgramPeriod Pe ON PI.ProgramCode = Pe.ProgramCode AND PI.Period = Pe.Period INNER JOIN
          Ref_Audit ON A.AuditId = Ref_Audit.AuditId INNER JOIN
          userQuery.dbo.#SESSION.acc#Milestones#FileNo# S ON Ref_Audit.AuditDate = S.AuditDate
		  AND Ref_Audit.Period = S.Period
WHERE     (PI.Period = '#URL.Period#') 
AND       A.AuditStatus >= '1'
AND       A.source = 'Manual'
AND       Pe.OrgUnit IN (SELECT OrgUnit 
                  FROM Organization.dbo.Organization 
				 WHERE Mission    = '#URL.Mission#'
				  AND  MandateNo  = '#URL.Mandate#'
	              AND  HierarchyCode >= '#HStart#' 
       			  AND  HierarchyCode < '#HEnd#') 
 AND       Pe.RecordStatus != '9'  				  
</cfquery>

<cfquery name="Milestones"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">			  
	SELECT *  
	FROM #SESSION.acc#Milestones#FileNo#
</cfquery>

<cfset cond = "">

<cfloop query="Milestones">
  
        <cfif milestone neq "Init">

			<cfif cond eq "">
				<cfset cond = "Actual_#milestone# IS NOT NULL or Target_#milestone# IS NOT NULL">
			<cfelse>
				<cfset cond = "#cond# OR Actual_#milestone# IS NOT NULL OR Target_#milestone# IS NOT NULL">
			</cfif>	
		
		</cfif>
		
		<cfif auditdate lte now()>
    	
			<cfquery name="Actuals"
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">	
				UPDATE #SESSION.acc#ProgramMonitoring#FileNo#
				SET [Actual_#milestone#] =  AuditTargetValue,
				    [Status_#milestone#] =  AuditStatus
				FROM #SESSION.acc#ProgramMonitoring#FileNo# M, #SESSION.acc#Actuals#FileNo# T
				WHERE M.TargetId = T.TargetId
				AND   T.Milestone = '#Milestones.Milestone#' 
			</cfquery> 
			
			<!--- removed
			<cfif URL.mode eq "print">
			
				<cfquery name="Update"
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
					UPDATE #SESSION.acc#ProgramMonitoring#FileNo#
					SET [Actual_#milestone#] =  0
					WHERE [Actual_#milestone#] is NULL
				</cfquery> 
			
			</cfif>
			--->
		
		</cfif>
			
</cfloop>

<CF_DropTable dbName="AppsQuery" 
              tblName="#SESSION.acc#ProgramExcel"> 	
			  
	<cfquery name="Present"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT     P.ProgramCode, 
		           P.ProgramClass, 
				   P.ProgramName AS ProgramName, 
				   R.IndicatorDescription AS IndicatorDescription, 
		           R.IndicatorCode AS IndicatorCode, 
				   R.ProgramCategory AS ProgramCategory, 
				   R.IndicatorType AS IndicatorType, 
				   R.IndicatorPrecision, 
		           R.TargetDirection, 
				   R.TargetRange, 			  
				   RC.Description AS CategoryDescription, 
				   L.LocationCode AS LocationCode, 
				   L.LocationName AS LocationName, 
				   Audit.* 
		<cfif URL.Mode eq "Excel">
			INTO   userQuery.dbo.#SESSION.acc#ProgramExcel
		</cfif>		   
		FROM       ProgramPeriod Pe INNER JOIN
	               ProgramIndicator PI ON Pe.ProgramCode = PI.ProgramCode AND Pe.Period = PI.Period INNER JOIN
	               Ref_Indicator R ON PI.IndicatorCode = R.IndicatorCode INNER JOIN
	               userQuery.dbo.#SESSION.acc#ProgramMonitoring#FileNo# Audit ON PI.TargetId = Audit.TargetId INNER JOIN
	               Ref_ProgramCategory RC ON R.ProgramCategory = RC.Code INNER JOIN
	               Program P ON PI.ProgramCode = P.ProgramCode LEFT OUTER JOIN
	               Employee.dbo.Location L ON PI.LocationCode = L.LocationCode
		WHERE      P.ProgramClass != 'Project' <!--- hanno disable --->
		AND 	   (#cond# OR Target_currentAlternate is not NULL) 
		AND 	   Pe.RecordStatus != '9' 
		ORDER BY   R.ProgramCategory, 
		           P.ProgramCode, 
				   L.LocationCode, 
				   R.IndicatorCode 	
				   
	</cfquery>
	
    <CF_DropTable dbName="AppsQuery" 
              tblName="#SESSION.acc#ProgramMonitoring#FileNo#"> 
			  
	<CF_DropTable dbName="AppsQuery" 
              tblName="#SESSION.acc#Targets#FileNo#"> 				  
			  
	<CF_DropTable dbName="AppsQuery" 
              tblName="#SESSION.acc#Milestones#FileNo#"> 	
			  
	<CF_DropTable dbName="AppsQuery" 
              tblName="#SESSION.acc#Actuals#FileNo#"> 
			  
<cfif URL.mode eq "excel">
	<cfset client.table1 = "#SESSION.acc#ProgramExcel">		
<cfelse>
	<cfif Present.Recordcount eq "0">
		<cf_message message="Problem no indicators have been defined for this program for period #URL.Period#" return="No">
	<cfelse>	
	  			  	
		<cfinclude template="IndicatorSummaryView.cfm">
		
	</cfif>	
</cfif>

