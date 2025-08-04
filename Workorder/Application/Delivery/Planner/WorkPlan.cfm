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


<!--- manual planner, apply also to the edit screens : driver / phone / part  --->

<cfparam name="url.WorkActionId" default="">
<cfparam name="url.PositionNo"   default="0">
<cfparam name="url.OccGroup"     default="14">
<cfparam name="url.row"          default="">

<cfif url.workactionid neq "">
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#url.dts#">
	<cfset DTS = dateValue>
	
	<cfquery name="get"
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT    W.WorkPlanId,
		          W.PositionNo, 
		          W.PersonNo, 
				  
				  (SELECT TOP 1 TopicValue 
				   FROM   WorkPlanTopic  
				   WHERE  WorkPlanId = W.WorkPlanId 
				   AND    Topic = 'f004' 
				   AND    Operational = 1 ) as topic_f004,	
				  
				  D.PlanOrderCode
		FROM      WorkPlan AS W INNER JOIN
		          WorkPlanDetail AS D ON W.WorkPlanId = D.WorkPlanId			  
		WHERE     D.WorkActionId = '#url.workactionid#'
	</cfquery>	
	
	<cfif get.recordcount eq "0">
		
		<cfset pos = url.positionno>
		<cfset pln = "">	
		
		<cfquery name="gettopic"
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			SELECT    PositionNo, 
			          PersonNo, 
					  
					  (SELECT TOP 1 TopicValue 
					   FROM   WorkPlanTopic  
					   WHERE  WorkPlanId = W.WorkPlanId 
					   AND    Topic = 'f004' 
					   AND    Operational = 1 ) as Topic
					  
					 
			FROM      WorkPlan W			  
			WHERE     PositionNo = '#url.positionno#'
			AND       Mission    = '#url.mission#'
			AND       DateEffective = #DTS#
			AND       DateExpiration = #DTS#
		</cfquery>	
		
		<cfset sgn = gettopic.Topic>		
			
	<cfelse>
	
		<cfset pos = get.PositionNo>
		<cfset pln = get.PlanOrderCode>
		<cfset sgn = get.topic_f004>
		
	</cfif>
	
	<cfquery name="Actor"
		datasource="appsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">						
				
		SELECT     PA.PositionNo, 
		           PA.FunctionNo, 
				   PA.FunctionDescription, 
				   P.PersonNo, 
				   P.LastName, 
				   P.FirstName
						   					   
		FROM       Person AS P INNER JOIN
	               PersonAssignment AS PA ON P.PersonNo = PA.PersonNo INNER JOIN
		           Position AS Pos ON PA.PositionNo = Pos.PositionNo
		WHERE      PA.DateEffective <= #dts#
		AND        PA.DateExpiration >= #dts#
		AND        PA.AssignmentStatus IN ('0', '1') 
		AND        Pos.Mission = '#url.mission#' 
		AND        PA.FunctionNo IN (SELECT FunctionNo 
		                             FROM   Applicant.dbo.FunctionTitle 
									 WHERE  OccupationalGroup = '#url.occgroup#')		
		ORDER BY P.LastName 
												 			     	     
	</cfquery>	
	
	<cfquery name="PlanOrder"
		datasource="appsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">									
			SELECT   *					   					   
			FROM     Ref_PlanOrder	
			ORDER BY ListingOrder															 			     	     
	</cfquery>	
	
	<cfoutput>
	
		<cfif url.action eq "apply">
			<cfparam name="padding" default="6px">
		<cfelse>
			<cfparam name="padding" default="0px">
		</cfif>
	
		<table>
		<tr>
			<td valign="top" style="padding:#padding#">
			
			<table width="100%">	
			
			<tr class="labelmedium"><td style="padding-left:#padding#;padding-right:10px"><cf_tl id="Actor">:</td>
				<td>
				
				<cfif url.row eq "">
				    <cfset nm = "PositionNo_wp">
				<cfelse>
					<cfset nm = "PositionNo_#url.row#">
				</cfif>
																	
				<select name="#nm#" style="width:200px" class="regularxl PositionSync">
				
				    <option value="">-- Unschedule --</option>
				    <!---
				    <cfif pos eq "0">
					
					</cfif>
					--->
					<cfloop query="Actor">
						<option value="#PositionNo#" <cfif positionno eq pos>selected</cfif>>#LastName# #FirstName# [#PositionNo#]</option>
					</cfloop>	
				</select>
						
				</td>
			</tr>
			
			<cfquery name="GetList" 
			  datasource="AppsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				  SELECT   *
				  FROM     Ref_TopicList  
				  WHERE    Code = 'f004'		
				  AND      Operational = 1		
				  ORDER BY ListOrder
			</cfquery>					
			
			<tr class="labelmedium"><td style="padding-left:#padding#;padding-right:10px"><cf_tl id="Callsign">:</td>
			
				<td>	
				
				<cfif url.row eq "">
				    <cfset nm = "Topic_f004_wp">
				<cfelse>
					<cfset nm = "Topic_f004_#url.row#">
				</cfif>
																				   					   
				<select name="#nm#" style="width:200px" class="regularxl">
					<cfif pos eq "0">
						<option value=""></option>
					</cfif>													
					<cfloop query="GetList">					  
						<option value="#ListCode#" <cfif listValue eq sgn>selected</cfif>>#GetList.ListValue#</option>
					</cfloop>									
				</select>	
					
				</td>
			</tr>
			
			<tr class="labelmedium"><td style="padding-left:#padding#;padding-right:11px"><cf_tl id="Schedule">:</td>
				<td>
				
				<cfif url.row eq "">
				    <cfset nm = "PlanOrderCode_wp">
				<cfelse>
					<cfset nm = "PlanOrderCode_#url.row#">
				</cfif>
				
				<select name="#nm#" style="width:200px" class="regularxl">
					 <cfif pos eq "0">
					<option value=""></option>
					</cfif>
					<cfloop query="PlanOrder">
						<option value="#Code#" <cfif code eq pln>selected</cfif>>#Description#</option>
					</cfloop>	
				</select>
				
				</td>
			</tr>
			
			<cfif url.action eq "apply">
			
				<tr>
					<td></td>
					<td style="height:31px" colspan="1">					
					   <input type="button" type="text" name="Save" value="Update" class="button10g" onclick="applyPlan('#url.workactionid#','#url.dts#','#url.row#')">
					</td>
				</tr>
			
			</cfif>
			
			</table>
			
			</td>
			</tr>
		
		</table>
	
	</cfoutput>
	
</cfif>