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
<cfparam name="url.orgunit"     default="0">
<cfparam name="url.positionno"  default="">
	
<CF_DateConvert Value="#url.selecteddate#">

<cfinvoke component = "Service.Access"  
	method           = "workorderprocessor" 
	mission          = "#url.mission#" 	
	orgunit          = "#url.orgunit#"					  
	returnvariable   = "access">  
		
	<cfset DTS = dateValue>
	
	<cfquery name="Position" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT   DISTINCT P.PositionNo, 
		         P.FunctionDescription, 
				 Pe.PersonNo, 
				 Pe.LastName, 
				 Pe.FirstName,
				 G.PostOrder
	    FROM     Position P INNER JOIN
	             PersonAssignment PA ON P.PositionNo = PA.PositionNo INNER JOIN
	             Person Pe ON PA.PersonNo = Pe.PersonNo INNER JOIN Ref_PostGrade G
				 ON G.PostGrade = P.PostGrade
	    WHERE    P.OrgUnitOperational = '#url.orgunit#' 
						
		<!--- not needed a assignment rules
		AND      P.DateEffective   <= #dts+30# 
		AND      P.DateExpiration  >= #dts# 
		 --->
		 
		<cfif access neq "ALL">
		<!--- person can inquire only his own --->
		AND      Pe.PersonNo = '#client.personno#'  
		</cfif>
		 
		AND      PA.Incumbency = 100 
		AND      PA.AssignmentStatus IN ('0','1')
		
		<!--- is indeed working in that period --->
		AND      PA.DateEffective  <= #dts# 
		AND      PA.DateExpiration >= #dts#
		
		<!--- this position is enabled in one of the schedules --->
	 	
		AND      P.PositionNo IN ( SELECT   WSP.PositionNo
							       FROM     WorkSchedulePosition AS WSP 
							       WHERE    WSP.PositionNo = P.PositionNo 
								   AND      WSP.CalendarDate >= #dts#
								 )	
		
		ORDER BY G.PostOrder ASC
	</cfquery>		
	
	<cfif Position.recordcount eq "0">
		
		<cfquery name="Position" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT   DISTINCT P.PositionNo, 
			         P.FunctionDescription, 
					 Pe.PersonNo, 
					 Pe.LastName, 
					 Pe.FirstName,
					 G.PostOrder
		    FROM     Position P INNER JOIN
		             PersonAssignment PA ON P.PositionNo = PA.PositionNo INNER JOIN
		             Person Pe ON PA.PersonNo = Pe.PersonNo INNER JOIN Ref_PostGrade G
				 ON G.PostGrade = P.PostGrade
		    WHERE    P.OrgUnitOperational = '#url.orgunit#' 
							
			<!--- not needed a assignment rules
			AND      P.DateEffective   <= #dts+30# 
			AND      P.DateExpiration  >= #dts# 
			 --->
			 
			<cfif access neq "ALL">
			<!--- person can inquire only his own --->
			AND      Pe.PersonNo = '#client.personno#'  
			</cfif>
			 
			AND      PA.Incumbency = 100 
			AND      PA.AssignmentStatus IN ('0','1')
			
			<!--- is indeed working in that period --->
			AND      PA.DateEffective  <= #dts# 
			AND      PA.DateExpiration >= #dts#
			ORDER BY G.PostOrder ASC		
		</cfquery>		
	
	</cfif>		  
			
	<!--- valid poisition / assignments for this date and unit --->
	
	<table width="100%" class="navigation_table">
	
	    <tr><td height="5"></td></tr>
		
		<cfif access eq "ALL">
		
			<cfoutput>
			<tr class="navigation_row line" onclick="try{schedule()}catch(e){};calendarmonth(document.getElementById('currentdate').value,'none','standard','seldate','orgunit=#url.orgunit#')">
			<td class="labelit" style="height:22px;padding-right:7px;font-size:15px;height:25px">
			  <table>
			  <tr class="labelmedium"> 
				  <td rowspan="2" style="width:30px"><cf_img icon="select"></td><td><font color="808080"><cf_tl id="All specialists"></font></td>
			  </tr>		
			  </table>
			</td>
			</tr>		
			</cfoutput>			
		
		</cfif>
	
		<cfoutput query="Position">
		
			<cfif positionno eq url.positionno>
			<cfset cl = "D3E9F8">		
			<cfelse>		
			<cfset cl = "transparent">
			</cfif>
			<tr class="navigation_row line" style="background-color:#cl#" onclick="try{schedule()}catch(e){};calendarmonth(document.getElementById('currentdate').value,'none','standard','seldate','orgunit=#url.orgunit#&positionno=#PositionNo#&personno=#personno#')">
			<td class="labelit" style="height:22px;padding-right:7px;font-size:15px;height:25px">
			  <table>
			  <tr class="labelmedium2"> 
				  <td rowspan="2" style="width:30px"><cf_img icon="select"></td><td>#FunctionDescription#</font></td>
			  </tr>
			  <tr class="labelmedium2" style="height:15px">
				  <td colspan="1" style="font-size:17px;padding-left:0px">#FirstName#, #LastName#</td>
			  </tr>		  
			  </table>
			</td>
			</tr>
		</cfoutput> 
		
		<cfif access eq "ALL">
		
			<cfset url.positionno = "">
			
		<cfelse>
		
			<cfset url.positionno = Position.PositionNo>
			<cfif url.positionno eq "">
				<cfset url.positionno = "999999">				
			</cfif>
			
		</cfif>
	 
    </table>

	<cfif url.PositionNo eq "">
		<cfquery name="qCurrentUnit"
				datasource="AppsWorkOrder"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
			SELECT *
			FROM Employee.dbo.PersonAssignment PA
			WHERE PersonNo = '#client.personNo#'
		AND DateEffective  <= #dts#
			AND DateExpiration >= #dts#
			AND Incumbency = 100
			AND AssignmentStatus IN ('0','1')
			AND EXISTS
			(
			SELECT 'x'
			FROM Employee.dbo.WorkSchedulePosition WP
			WHERE WP.PositionNo = PA.PositionNo
			)
		</cfquery>
		<cfif qCurrentUnit.recordcount neq 0>
			<cfset URL.positionNo = qCurrentUnit.PositionNo>
			<cfset URL.personNo = Client.personNo>
		</cfif>
	</cfif>
	
    <cfset ajaxonload("doHighlight")>
	