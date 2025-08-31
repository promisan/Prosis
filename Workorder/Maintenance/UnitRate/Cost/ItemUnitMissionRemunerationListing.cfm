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

<!-- <cfform name="webdialog" action="itemUnitMissionSubmit.cfm" method="POST" target="processUnitMission"> -->
<table class="navigation_table">
	<tr class="line labelmedium" style="height:20px">
		<td><cf_tl id="Position Grade"></td>
		<td style="padding-right:10px;" align="right"><cf_tl id="Amount"></td>
		<td><cf_tl id="Position Grade"></td>
		<td style="padding-right:10px;" align="right"><cf_tl id="Amount"></td>
		<td><cf_tl id="Position Grade"></td>
		<td style="padding-right:10px;" align="right"><cf_tl id="Amount"></td>
	</tr>	
	<cfset i = 1>
	<cfoutput query="getGrades">
	    
	    <cfif i eq "1">
		<tr class="navigation_row labelmedium fixlengthlist">				
		</cfif>
			
			<td style="padding-left:15px; padding-right:10px">#PostGradeDisplay#</td>
			<td style="border:1PX SOLID SILVER">
				<cfset vPostGradeId = trim(replace(Postgrade," ","_","ALL"))>
				<cfset vPostGradeId = replace(vPostGradeId,"-","_","ALL")>
				<cfinput type="text" name="postgrade_#vPostGradeId#" id="postgrade_#vPostGradeId#" 
				 validate="numeric" value="#Remuneration#" class="regularxl" style="border:0px;width:75px; background-color:##f1f1f180;text-align:right; padding-right:5px;">
			</td>
			
		<cfif i eq "3">	
		</tr>
		<cfset i = 1>
		<cfelse>
		<cfset i = i+1>
		</cfif>
	</cfoutput>
</table>
<!-- </cfform> -->

<cfset ajaxOnLoad("doHighlight")>