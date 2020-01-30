
<!--- pending provision to show the next hierarchy under the selection that was made in the top --->

<cfquery name="getUnit" 
        dbtype="query">
		
    SELECT     PresentationOrgUnit,
			   PresentationOrgUnitName,
			   PresentationHierarchyCode,
			   COUNT(*)            AS Contracts,
			   SUM(Initiated)      AS Initiated, 
			   SUM(WithActivities) AS WithActivities, 
	           SUM(Submit)         AS Submit, 
			   SUM(Cleared)        AS Cleared, 
			   SUM(Midterm)        AS Midterm, 
			   SUM(Final)          AS Final,
			   SUM(Complete)       AS Complete
			   	
	FROM      getBase  
	WHERE     AssignmentOrgUnit is not NULL	
	     
	      
	GROUP BY  PresentationOrgUnit,
			  PresentationOrgUnitName,
			  PresentationHierarchyCode
	ORDER BY  PresentationHierarchyCode ASC
	
</cfquery>	 

<!--- to be reviewed : alert Kristhian --->
  
<cfquery name="getBehaviorAVGScore" 
	datasource="AppsEPas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  ISNULL(Base.OrgUnit, -9999) AS OrgUnit,
				ISNULL(AVG(S.ScoreWeight*1.0),0) as ScoreWeight
				
		FROM	ContractEvaluationBehavior CEB
			    INNER JOIN ContractBehavior CB
				  ON CEB.ContractId = CB.ContractId
				  AND CEB.BehaviorCode = CB.BehaviorCode
			    INNER JOIN Ref_Score S
				  ON CEB.EvaluationScore = S.Code
				  AND S.ClassScore = 'Default'
				INNER JOIN 
					(
						SELECT 	P.OrgUnit,
								P.OrgUnitName,
								P.HierarchyCode,
								B.ContractId
						FROM   	(#preserveSingleQuotes(BaseQuery)#) as B
								INNER JOIN Organization.dbo.Organization O
									ON B.ContractOrgUnit = O.OrgUnit
								INNER JOIN Organization.dbo.Organization P
									ON P.OrgUnitCode = O.HierarchyRootUnit
									AND P.Mission = O.Mission
									AND P.MandateNo = O.MandateNo
						WHERE	O.Mission = '#url.mission#'
						AND 	O.MandateNo = '#Mandate.MandateNo#'
					) AS Base
						ON Base.ContractId = CB.ContractId
		WHERE   S.ScoreWeight IS NOT NULL
		GROUP BY Base.orgunit
</cfquery>

<cfquery name="getActivityAVGScore" 
	datasource="AppsEPas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  ISNULL(Base.OrgUnit, -9999) AS OrgUnit,
				ISNULL(AVG(S.ScoreWeight*1.0),1) as ScoreWeight
				
		FROM	ContractEvaluationActivity CEA
			    INNER JOIN ContractActivity CA ON CEA.ContractId = CA.ContractId AND CEA.ActivityId = CA.ActivityId
			    INNER JOIN Ref_Score S ON CEA.EvaluationScore = S.Code AND S.ClassScore = 'Activity'
			    INNER JOIN 
					(
						SELECT 	P.OrgUnit,
								P.OrgUnitName,
								P.HierarchyCode,
								B.ContractId
						FROM   	(#preserveSingleQuotes(BaseQuery)#) as B
								INNER JOIN Organization.dbo.Organization O
									ON B.ContractOrgUnit = O.OrgUnit
								INNER JOIN Organization.dbo.Organization P
									ON P.OrgUnitCode = O.HierarchyRootUnit
									AND P.Mission = O.Mission
									AND P.MandateNo = O.MandateNo
						WHERE	O.Mission = '#url.mission#'
						AND 	O.MandateNo = '#Mandate.MandateNo#'
					) AS Base
						ON Base.ContractId = CA.ContractId
		WHERE   CA.Operational = '1'
		AND	    S.ScoreWeight IS NOT NULL
		GROUP BY Base.orgunit
</cfquery>

<cfset vNumFormat = ",._">

<table class="formpadding navigation_table">
	<tr class="labelmedium line">
 		<td width="35%"></td>
 		<td align="center" style="color:808080;"><cf_tl id="ePas"></td>
 		<td align="center" colspan="3" style="color:808080;"><cf_tl id="Compliance"> %</td> 		
 		<td align="center" colspan="2" style="color:808080;"><cf_tl id="AVG Score"></td> 		
 	</tr>
 	<tr class="labelmedium line">
 		<td width="35%"></td>
 		<td align="center" style="min-width:45px;color:808080;"><cf_tl id="Iss"></td>
 		<td align="center" style="min-width:45px;color:808080;"><cf_tl id="Cle"></td>
 		<td align="center" style="min-width:45px;color:808080;"><cf_tl id="Mid"></td>
 		<td align="center" style="min-width:45px;color:808080;"><cf_tl id="Fin"></td>
 		<td align="center" style="min-width:45px;color:808080;"><cf_tl id="Beh"></td>
 		<td align="center" style="min-width:45px;color:808080;"><cf_tl id="All"></td>
 	</tr>

 	<cfset vSumContracts = 0>
 	<cfset vSumCleared = 0>
 	<cfset vSumMidterm = 0>
 	<cfset vSumFinal = 0>
 	<cfset vSumContracts = 0>

 	<cfoutput query="getUnit">
	
	 	<tr class="labelmedium navigation_row line">
	 		<td>#PresentationOrgUnitName#</td>
	 		<td align="center" bgcolor="E6E6E6">#numberformat(Contracts , ",")#</td>
	 		<td align="center" style="border-left:1px solid silver">#numberformat((Cleared)*100/Contracts , vNumFormat)#
			
			</td>
	 		<td align="center" style="border-left:1px solid silver">#numberformat((Midterm)*100/Contracts , vNumFormat)#
			
			</td>
	 		<td align="center" style="border-left:1px solid silver">#numberformat((Final)*100/Contracts , vNumFormat)#</td>
			<td align="center" style="boder-left:1px solid silver" bgcolor="C0F1C1">
	 			<cfquery name="getScoreBehavior" dbtype="query">
				  	SELECT  *
				 	FROM    getBehaviorAVGScore	
				 	WHERE 	OrgUnit = '#PresentationOrgUnit#'		  	
				 </cfquery>	
	 			<cfif getScoreBehavior.recordCount eq 1 AND getScoreBehavior.ScoreWeight neq "">
					#numberformat(getScoreBehavior.ScoreWeight, vNumFormat)#
				<cfelse>
					#numberformat(0.0, vNumFormat)#	
				</cfif>
	 		</td>
	 		<td align="center" style="border-left:1px solid silver" bgcolor="C0F1C1">
	 			<cfquery name="getScoreActivity" dbtype="query">
				  	SELECT  *
				 	FROM    getActivityAVGScore	
				 	WHERE 	OrgUnit = '#PresentationOrgUnit#'		  	
				</cfquery>	
				<cfif getScoreActivity.recordCount eq 1 AND getScoreActivity.ScoreWeight neq "">
					#numberformat(getScoreActivity.ScoreWeight, vNumFormat)#
				<cfelse>
					#numberformat(0.0, vNumFormat)#	
				</cfif>
	 		</td>	 		
	 	</tr>
	 	<cfset vSumContracts = vSumContracts + Contracts>
	 	<cfset vSumCleared = vSumCleared + Cleared >
	 	<cfset vSumMidterm = vSumMidterm + Midterm >
	 	<cfset vSumFinal = vSumFinal + Final>
		
 	</cfoutput>
	
 	<cfoutput>
	 	<tr class="labelmedium navigation_row" style="border-top:1px dotted ##C0C0C0;">
			<td></td>
			<td align="center" bgcolor="E6E6E6" align="center"><b>#numberformat(vSumContracts , ',')#</b></td>
			<td align="center" style="border-left:1px solid silver"><b>#numberformat(vSumCleared*100/vSumContracts , vNumFormat)#</b></td>
			<td align="center" style="border-left:1px solid silver"><b>#numberformat(vSumMidterm*100/vSumContracts , vNumFormat)#</b></td>
			<td align="center" style="border-left:1px solid silver"><b>#numberformat(vSumFinal*100/vSumContracts , vNumFormat)#</b></td>			
	 		<td align="center" style="border-left:1px solid silver" bgcolor="C0F1C1">
	 			<cfquery name="getTotalScoreBehavior" dbtype="query">
				  	SELECT  AVG(ScoreWeight) as ScoreWeight
				 	FROM    getBehaviorAVGScore	
				 </cfquery>	
	 			<cfif getTotalScoreBehavior.recordCount eq 1 AND getTotalScoreBehavior.ScoreWeight neq "">
					<b>#numberformat(getTotalScoreBehavior.ScoreWeight, vNumFormat)#</b>
				<cfelse>
					#numberformat(0.0, vNumFormat)#	
				</cfif>
	 		</td>
			<td align="center" style="border-left:1px solid silver" bgcolor="C0F1C1">
	 			<cfquery name="getTotalScoreActivity" dbtype="query">
				  	SELECT  AVG(ScoreWeight) as ScoreWeight
				 	FROM    getActivityAVGScore	
				 </cfquery>	
	 			<cfif getTotalScoreActivity.recordCount eq 1 AND getTotalScoreActivity.ScoreWeight neq "">
					<b>#numberformat(getTotalScoreActivity.ScoreWeight, vNumFormat)#</b>
				<cfelse>
					#numberformat(0.0, vNumFormat)#	
				</cfif>
	 		</td>
		</tr>
	</cfoutput>
 </table>

 <cfset ajaxOnLoad("doHighlight")>