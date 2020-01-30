<cfquery name="getGrades" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT 
				P.Postgrade,
				PG.PostGradeDisplay,
				PG.PostOrder,
				ISNULL((
					SELECT 	Amount
					FROM   	WorkOrder.dbo.ServiceItemUnitMissionRemuneration
					WHERE	1=1
					<cfif trim(url.CostId) neq "">
						AND 	CostId = '#url.CostId#'
					<cfelse>
						AND 1=0
					</cfif>
					AND 	Postgrade = P.Postgrade
				), 0) as Remuneration
		FROM   	Position P 
				INNER JOIN Ref_PostGrade PG 	
					ON P.Postgrade = PG.Postgrade
		WHERE	Mission = '#url.Mission#'
		ORDER BY PG.PostOrder ASC
</cfquery>

<!--<cfform name="webdialog" action="itemUnitMissionSubmit.cfm" method="POST" target="processUnitMission">-->
<table class="navigation_table">
	<tr class="line labelmedium" style="height:20px">
		<td colspan="2"><cf_tl id="Position Grade"></td>
		<td style="padding-right:10px;" align="right"><cf_tl id="Amount"></td>
	</tr>	
	<cfoutput query="getGrades">
		<tr class="navigation_row labelmedium" style="height:26px">
			<td>#PostGrade#</td>
			<td style="padding-left:15px; padding-right:10px;">#PostGradeDisplay#</td>
			<td style="padding-left:15px; padding-right:10px;border:1PX SOLID SILVER">
				<cfset vPostGradeId = trim(replace(Postgrade," ","_","ALL"))>
				<cfset vPostGradeId = replace(vPostGradeId,"-","_","ALL")>
				<cfinput type="text" name="postgrade_#vPostGradeId#" id="postgrade_#vPostGradeId#" validate="numeric" value="#Remuneration#" class="regularxl" style="border:0px;width:75px; text-align:right; padding-right:5px;">
			</td>
		</tr>
	</cfoutput>
</table>
<!--</cfform>-->

<cfset ajaxOnLoad("doHighlight")>