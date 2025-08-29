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
<cfparam name="url.selecteddate"     default="#now()#">

<cfif url.selecteddate gte now()-1>
	<cfset accessmode = "edit">
<cfelse>
	<cfset accessmode = "view">
</cfif>


<cfquery name  = "getHierarchy" 
    datasource= "AppsOrganization" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">  	
		SELECT	* 
		FROM	Organization 
		WHERE	OrgUnit IN (SELECT OrgUnit 
		                    FROM   Employee.dbo.WorkScheduleOrganization 
							WHERE  WorkSchedule = '#url.workschedule#')
	  	ORDER BY HierarchyCode
		
</cfquery>

<cf_verifyOperational 
         datasource= "AppsWorkOrder"
         module    = "WorkOrder" 		
		 Warning   = "No">		

	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding navigation_table">
	
	<tr><td colspan="7" style="height:24;padding-left:4px" class="labelmedium linedotted">Positions <cfoutput>(#dateformat(url.selecteddate,client.dateformatshow)#)</cfoutput>:</td></tr>	
	<tr class="hide"><td colspan="7" height="4" id="positionprocess"></td></tr>
	
	<cfloop query="getHierarchy">
	
		<cfquery name  = "getOrgUnits" 
		    datasource= "AppsOrganization" 
		    username  = "#SESSION.login#" 
			password  = "#SESSION.dbpw#">  
							
				SELECT	 * 
				FROM	 Organization 
				WHERE	 Mission   = '#Mission#'
				AND      MandateNo = '#MandateNo#'	
				AND      ((HierarchyCode LIKE '#HierarchyCode#.%' and  OrgUnit NOT IN (#quotedValueList(getHierarchy.OrgUnit)#)) or OrgUnit = '#OrgUnit#')
				ORDER BY HierarchyCode								
		</cfquery>		
		
		<cfif getOrgUnits.recordCount gt 0>
		
			<cfoutput>
			<tr class="linedotted">
				<td width="3%" style="padding-left:4px">
				
					<input type="checkbox" 
							id		=	"parentUnit_#replace(getHierarchy.HierarchyCode,'.','','ALL')#" 
							name	=	"parentUnit_#replace(getHierarchy.HierarchyCode,'.','','ALL')#" 
							class	=	"cls#replace(getHierarchy.HierarchyCode,'.','','ALL')#"
							onclick	=	"checkAllScheduleChildren('#replace(getHierarchy.HierarchyCode,'.','','ALL')#');">
							
				</td>
				<td colspan="5" style="padding-left:5px;color:gray;" class="labellarge"><b>#getOrgUnits.OrgUnitName#</td>
			</tr>
			
			</cfoutput>
			
		</cfif>

		<cfloop query="getOrgUnits">
			
			<cfquery name  = "getPositions" 
			    datasource= "AppsEmployee" 
			    username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">  
				
					SELECT	  P.*,
					          WS.WorkSchedule,
							  W.Description,
							  
							  <cfif operational eq "1">
							  							  							  
							   (
							   SELECT count(*) 
							   FROM   WorkOrder.dbo.WorkOrder W,
							          WorkOrder.dbo.WorkOrderLineSchedule WLS, 
									  WorkOrder.dbo.WorkOrderLineSchedulePosition WLSP
							   WHERE  WLS.ScheduleId   = WLSP.ScheduleId
							   AND    W.WorkOrderId    = WLS.WorkOrderId
							   AND    WLSP.PositionNo  = P.PositionNo
							   AND    WLS.WorkSchedule = WS.WorkSchedule
							   AND    W.ActionStatus   = '1' 
							   AND    WLS.ActionStatus = '1' 
							   AND    WLSP.isActor IN ('1','2')
							   ) as Tasks,
							   
							  <cfelse>
							  
							  '0' as Tasks, 
							  
							  </cfif>
							  
							  ( SELECT HierarchyCode
							    FROM   Organization.dbo.Organization 
								WHERE  OrgUnit = P.OrgUnitOperational) AS HierarchyCode,
								
							  ( SELECT count(*) 
							    FROM   WorkSchedulePosition W
								WHERE  W.PositionNo   = P.PositionNo 
								AND	   W.WorkSchedule = '#url.workschedule#' 
								AND    W.CalendarDate = #url.selecteddate#) as Enabled,
								
							  ( SELECT PointerBreak 
							    FROM   WorkSchedulePosition W
								WHERE  W.PositionNo   = P.PositionNo 
								AND	   W.WorkSchedule = '#url.workschedule#' 
								AND    W.CalendarDate = #url.selecteddate#) as PointerBreak,	
								
							   ( SELECT count(*) 
							     FROM   WorkSchedulePosition W
								 WHERE  W.PositionNo    = P.PositionNo 
								 AND	W.WorkSchedule != '#url.workschedule#' 
								 AND    W.CalendarDate  = #url.selecteddate#) as OtherSchedule							  
						   	
					FROM	  Position P INNER JOIN 
					          Ref_PostGrade R ON P.PostGrade = R.PostGrade LEFT OUTER JOIN
							  WorkSchedulePosition WS ON WS.PositionNo = P.PositionNo AND WS.CalendarDate = #url.selecteddate# LEFT OUTER JOIN WorkSchedule W ON W.Code = WS.WorkSchedule
					
					WHERE     P.Mission            = '#mission#'
					AND       P.MandateNo          = '#MandateNo#'
					AND       P.OrgUnitOperational = '#OrgUnit#'
					
					AND 	  P.DateEffective <= #url.selecteddate#
					AND       P.DateExpiration > #url.selecteddate#
										
					ORDER BY  WS.WorkSchedule,PostOrder,FunctionDescription ASC
					
			</cfquery>		
			
			<!---
			<cfoutput>#cfquery.executiontime#</cfoutput>
			--->


			<cfif getPositions.recordCount gt 0 and getHierarchy.HierarchyCode neq getPositions.HierarchyCode>
			
				<cfoutput>
				<tr class="linedotted">
					<td width="3%"></td>
					<td width="5%">
					   <cfif accessmode eq "edit">
						<input type="checkbox" id="parentUnit_#replace(getOrgUnits.HierarchyCode,'.','','ALL')#" 
							name="parentUnit_#replace(getOrgUnits.HierarchyCode,'.','','ALL')#" 
							class="cls#replace(getOrgUnits.HierarchyCode,'.','','ALL')#"
							onclick="checkAllScheduleChildren('#replace(getOrgUnits.HierarchyCode,'.','','ALL')#');">
					   </cfif>		
					</td>
					<td colspan="4" style="padding-left:5px;height:30px;" class="labellarge"><b>#OrgUnitName#</b></td>
				</tr>
				
				</cfoutput>
				
			</cfif>


			<cfoutput query="getPositions" group="Description">
			
				<tr><td colspan="4" class="labelmedium" style="padding-left:50px">#Description#</td></tr>
			
			<cfoutput>

				<cfif enabled gte "1">
				<tr bgcolor="FFFF00" class="labelmedium navigation_row">
				<cfelse>
				<tr class="labelmedium navigation_row">
				</cfif>
					<td bgcolor="white"></td>
					<td width="5%"></td>
					<td width="5%">
						<cfif accessmode eq "edit">
							<cfset selVisibility = "">
							<cfif tasks gt 0>
								<cfset selVisibility = "display:none;">
							</cfif>
							<table width="100%" height="100%">
								<tr>
									<td style="#selVisibility#">
										<input type="checkbox" name="selected" value="'#PositionNo#'" class="cls#replace(HierarchyCode,'.','','ALL')#" <cfif enabled gte "1">checked</cfif>>
									</td>
								</tr>
							</table>
						</cfif>
					</td>
					<td width="15%">
						<cfif enabled eq "0"><font color="808080"></cfif>
						<cfif currentrow eq "1">
							<cf_space spaces="20">
						</cfif>
						<a href="javascript:EditPosition('#mission#','#mandateno#','#PositionNo#')"><cfif SourcePostNumber eq "">#PositionNo#<cfelse>#SourcePostNumber#</cfif></a>
					</td>
					<td><cfif enabled eq ""><font color="808080"></cfif>#FunctionDescription#</td>
					<td>
					<cfif accessmode eq "edit" and enabled neq "">

						<cfset cur = pointerbreak>
						<cfif cur eq "">
							<cfset cur = "-">
						</cfif>

					    <select class="regularh" name="pointerBreak_#positionNo#" id="pointerBreak_#positionNo#" onchange="ColdFusion.navigate('#session.root#/staffing/application/workschedule/Planning/setPositionBreak.cfm?pointerbreak='+this.value+'&workschedule=#workschedule#&positionno=#positionno#&date=#urlencodedformat(url.selecteddate)#','positionprocess')">

						<cfloop index="pt" list="-1.5,-1,-0.5,-,0.5,1,1.5">
						<option value="#pt#" <cfif pt eq cur>selected</cfif>>#pt#</option>
						</cfloop>
						</select>

					    <!---
						<input type="text" name="pointerBreak" value="#PointerBreak#" class="enterastab"
						 onchange="ColdFusion.navigate('#session.root#/staffing/application/workschedule/Planning/setPositionBreak.cfm?pointerbreak='+this.value+'&workschedule=#workschedule#&positionno=#positionno#&date=#urlencodedformat(url.selecteddate)#','positionprocess')" maxlength="10" style="padding-left:3px;border:1px dotted silver;width:50">
						 --->
					</cfif>
					</td>
					<td style="padding-right:6px"><cfif enabled eq ""><font color="808080"></cfif>#PostGrade#</td>

					<cfif OtherSchedule gte "1">

					<td bgcolor="C9F3FC" style="border-right:1px dotted silver;border-bottom:1px dotted silver;padding-bottom:1px;padding-left:4px">

							<cfquery name  = "getOther"
						    datasource= "AppsEmployee"
						    username  = "#SESSION.login#"
							password  = "#SESSION.dbpw#">
								SELECT DISTINCT R.Description
								FROM   WorkSchedulePosition W, WorkSchedule R
								WHERE  W.WorkSchedule  = R.Code
								AND    W.PositionNo    = '#positionno#'
								AND    W.WorkSchedule != '#url.workschedule#'
		   					    AND    W.CalendarDate  = #url.selecteddate#
							</cfquery>

							<cfloop query="getOther">
								 #description# <cfif currentrow lt recordcount>;</cfif>
							</cfloop>

						</td>

					<cfelse>

					<td></td>

				 </cfif>

				 </tr>

			</cfoutput>

			</cfoutput>	 
					
		</cfloop>



		<tr><td height="4"></td></tr>

	</cfloop>
	
	</table>
	
	<cfset ajaxonload("doHighlight")>

