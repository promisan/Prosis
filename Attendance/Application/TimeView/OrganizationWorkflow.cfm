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
<cfquery name="Param" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT   *
	  FROM     Parameter	
</cfquery>

<cfset breakminutes = (Param.HoursInDay - Param.HoursWorkDefault) * 60>

<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   * 
    FROM     OrganizationObject
	WHERE    ObjectKeyValue4 =  '#URL.AjaxId#'
</cfquery>

<cfquery name="Get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM   OrganizationAction
		WHERE  OrgUnitActionId = '#URL.AjaxId#'
</cfquery>

<cfquery name="Unit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM   Organization
		WHERE  OrgUnit = '#get.OrgUnit#'
</cfquery>

<cfquery name="getPersons" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT 	DISTINCT P.PersonNo, 
				        P.LastName, 
						P.ListingOrder,
						P.FirstName, 
						A.FunctionDescription, 
						A.LocationCode,
						P.IndexNo, 
						A.AssignmentNo, 
						A.DateEffective, 
						A.DateExpiration,
						(SELECT   TOP 1 ContractLevel
						 FROM     PersonContract
						 WHERE    PersonNo     = P.PersonNo
						 AND      Mission      = Pos.Mission
						 AND      ActionStatus IN ('0','1')
						 AND      DateEffective <= '#get.CalendarDateEnd#'
						 ORDER BY DateEffective DESC) as PersonGrade
						 
	  FROM 	Person P 
	        INNER JOIN PersonAssignment A ON P.PersonNo = A.PersonNo
			INNER JOIN Position Pos ON A.PositionNo = Pos.PositionNo
				
	  WHERE   P.PersonNo = A.PersonNo
	  <!--- the unit of the operational assignment --->
	  AND     A.OrgUnit = '#get.Orgunit#'
	  -- AND     A.Incumbency       > '0'
	  AND     A.AssignmentStatus IN ('0','1')
	  -- AND     A.AssignmentClass  = 'Regular'	<!--- not needed anymore as loaned people have leave as well --->		
	  AND     A.AssignmentType   = 'Actual'
	  AND     A.DateEffective   <= '#get.CalendarDateEnd#'
	  AND     A.DateExpiration  >= '#get.CalendarDateStart#'							
 </cfquery>	
 


<cfoutput>

<table width="98%" align="center">

	<tr id="box_#URL.AjaxId#">
	
		<td id="#URL.AjaxId#">
	
		<table width="100%">
			
			<tr><td style="padding-top:10px;height:50px;" valign="top">
			
				<table width="100%">
				
				   <tr class="line">
				      <td class="labelmedium" style="font-weight:250;padding-left:3px;font-size:23px"><cf_tl id="Attendance compensation summary in hours"></td>
				   </tr>
				   
				   <tr><td style="padding-left:5px">
				   
				   <table width="100%" class="navigation_table">
				   
					     <cfquery name="Overtime" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							   SELECT     BillingMode, 
									      BillingPayment,									  									  
									      SUM(Hours) as Hours,			 
									      SUM(OvertimePayroll) as OvertimePayroll,
									      COUNT(DISTINCT PersonNo) AS Staff
								 
						   	   FROM (	
															
								SELECT     W.PersonNo,
								           W.CalendarDate,
										   WD.BillingMode, 
								           WD.BillingPayment, 
										   SUM(WD.HourSlotMinutes) / 60 AS Hours,
											  
										   <!--- express overtime to be settled to a maximum --->
					
										   CASE WHEN BillingMode != 'Contract' 
										   THEN (CASE WHEN SUM(CONVERT(float, HourSlotMinutes)) / 60 >= #Param.HoursWorkDefault# 
												      THEN (SUM(CONVERT(float, HourSlotMinutes))-#breakminutes#) / 60  <!--- limit overtime to the break --->
											 	      ELSE SUM(CONVERT(float, HourSlotMinutes)) / 60 END) 
					                       ELSE 0 END AS OvertimePayroll			
											  					                   
										   
								FROM       PersonWorkDetail AS WD INNER JOIN
						                   PersonWork AS W ON WD.PersonNo = W.PersonNo AND WD.CalendarDate = W.CalendarDate AND WD.TransactionType = W.TransactionType
								WHERE      W.OrgUnit        = '#get.OrgUnit#' 
								AND        WD.BillingMode  <> 'Contract' <!--- all what is not contract covered --->
								AND        WD.CalendarDate >= '#get.CalendarDateStart#' 
								AND        WD.CalendarDate <= '#get.CalendarDateEnd#' 
								AND        WD.TransactionType = '1'
								<cfif getPersons.recordcount gte "1">
								AND        WD.PersonNo IN (#quotedvalueList(getPersons.PersonNo)#)
								<cfelse>
								AND        1=0
								</cfif>
						        GROUP BY   W.PersonNo,
								           W.CalendarDate,
										   WD.BillingMode, 
								           WD.BillingPayment
							    ) as D	
								
								GROUP BY      BillingMode, 
								              BillingPayment
											  
								ORDER BY 	  BillingMode, 
								              BillingPayment	  	
											  
											 								 
						</cfquery>						
						
						<tr class="labelmedium2 line">
						
						<td style="padding-left:3px"><cf_tl id="Compensation"></td>
						<td style="padding-left:1px"><cf_tl id="Through"></td>
						<td align="right" style="width:70px;padding-left:2px"><cf_tl id="Staff"></td>						
						<td align="right" style="width:100px;padding-right:10px"><cf_tl id="Schedule"></td>
						<td align="right" style="width:100px;padding-right:10px"><cf_tl id="Adjusted"></td>
						<td align="right" style="width:100px;padding-right:10px"><cf_tl id="Applied">(hh:mm)</td>						
						
						</tr>
						
					   <cfloop query="Overtime">
					   
					   	<tr class="line labelmedium2 navigation_row">
							
							<td style="padding-left:4px">
							
							<cfquery name="Item" 
							datasource="AppsPayroll" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT       *
								FROM         Ref_PayrollTrigger
								WHERE        SalaryTrigger = '#BillingMode#'
							</cfquery>
							
							#Item.Description#</td>
							
							<td><cfif BillingPayment eq "1"><cf_tl id="Payroll"><cfelse><cf_tl id="Time"></cfif></td>
							<td align="right" style="padding-left:4px">#Staff#</td>								
							<td align="right" style="padding-right:10px">#Hours#</td>	
							<td align="right" style="padding-right:10px">#OvertimePayroll#</td>	
							<td align="right" style="padding-right:10px">
							
								<cfquery name="Payroll" 
								datasource="AppsPayroll" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">							
									SELECT    SUM(OD.OvertimeHours) AS Hours, 
									          SUM(OD.OvertimeMinutes) AS Minutes 											  
											  
									FROM      PersonOvertime AS O INNER JOIN
						                      PersonOvertimeDetail AS OD ON O.PersonNo = OD.PersonNo AND O.OvertimeId = OD.OvertimeId
									WHERE     O.Source          = 'Schedule' 
									AND       O.SourceId        = '#URL.AjaxId#'
									AND       OD.BillingPayment = '#billingPayment#'
									AND       SalaryTrigger     = '#BillingMode#'
								</cfquery>
								
								<cfif Payroll.recordcount eq "0">
								
								<cf_tl id="Pending">
								
								<cfelse>
								
									<cfset h = Payroll.Hours>
									<cfset m = Payroll.minutes>
									
									<cfif m gte "60">
									   <cfset hm = int(m/60)>
									   <cfset h = h + hm>
									   <cfset m = m - (hm*60)>
									</cfif>
									
									#h#:<cfif m lt "10">0</cfif>#m#
									
								</cfif>	
														
							</td>											
						</tr>
						
					   </cfloop>
					   
					    <cfquery name="Night" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
					   	    SELECT   'NightDiff' as BillingMode, 
						             SUM(WD.HourSlotMinutes) / 60 AS Hours, 
                                     COUNT(DISTINCT WD.PersonNo) AS Staff
							FROM     PersonWorkDetail AS WD INNER JOIN
			                         PersonWork AS W ON WD.PersonNo = W.PersonNo AND WD.CalendarDate = W.CalendarDate AND WD.TransactionType = W.TransactionType
							WHERE    W.OrgUnit = '#get.OrgUnit#' 							
							AND      WD.CalendarDate >= '#get.CalendarDateStart#' 
							AND      WD.CalendarDate <= '#get.CalendarDateEnd#' 
							AND      WD.PersonNo IN (#quotedvalueList(getPersons.PersonNo)#)
							AND      WD.TransactionType = '1'
							AND      WD.ActivityPayment = '1'						
							
						</cfquery>
						
						<cfloop query="Night">
						
						   	<tr class="line labelmedium2 navigation_row">
								
								<td style="padding-left:4px">
								<cfquery name="Item" 
								datasource="AppsPayroll" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT       *
									FROM         Ref_PayrollTrigger
									WHERE        SalaryTrigger = '#BillingMode#'
								</cfquery>
								
								#Item.Description#</td>
								<td><cf_tl id="Payroll"></td>	
								<td align="right" style="padding-left:4px">#Staff#</td>															
								<td align="right" style="padding-right:10px">#Hours#</td>
								<td align="right" style="padding-right:10px">#Hours#</td>
								<td align="right" style="padding-right:10px">
								
								<cfquery name="Payroll" 
								datasource="AppsPayroll" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">							
									SELECT    SUM(OD.OvertimeHours) AS Hours, 
									          SUM(OD.OvertimeMinutes) AS Minutes
									FROM      PersonOvertime AS O INNER JOIN
						                      PersonOvertimeDetail AS OD ON O.PersonNo = OD.PersonNo AND O.OvertimeId = OD.OvertimeId
									WHERE     O.Source = 'Schedule' 
									AND       O.SourceId = '#URL.AjaxId#'
									AND       SalaryTrigger = '#BillingMode#'
								</cfquery>
								
								<cfif Payroll.recordcount eq "0">
								
								<cf_tl id="Pending">
								
								<cfelse>
								
								<cfset h = Payroll.Hours>
								<cfset m = Payroll.minutes>
								
								<cfif m gte "60">
								   <cfset hm = int(m/60)>
								   <cfset h = h + hm>
								   <cfset m = m - (hm*60)>
								</cfif>
								
								#h#:<cfif m lt "10">0</cfif>#m#
								
								</cfif>
								
								</td>									
							</tr>
						
					   </cfloop>	
				   
				   </table>
				   </td>
				   </tr>				   
				   
				</table>
				
			</td></tr>
			
			<cfset ajaxonload("doHighlight")>
						
			<tr><td style="padding-left:4px;padding-right:4px">
				
			<cfset link = "Attendance/Application/TimeView/OrganizationListing.cfm?ajaxid=#url.ajaxid#&ID0=#get.OrgUnit#&ID2=#Object.Mission#">
					
			<cf_ActionListing 
				    EntityCode       = "OrgAction"
					EntityClass      = "#Unit.WorkSchemaEntityClass#"
					EntityGroup      = ""
					EntityStatus     = ""		
					Mission          = "#Object.Mission#"
					OrgUnit          = "#get.OrgUnit#"
					ObjectReference  = "Timesheet #Unit.OrgUnitName# #dateformat(get.CalendarDateStart,'YYYY/MM')#"			    
					ObjectKey4       = "#URL.AjaxId#"
					AjaxId           = "#URL.AjaxId#"
					ObjectURL        = "#link#"
					Show             = "Yes"		
					Toolbar          = "Yes">
					
			</td></tr>
			
		</table>	
	
		</td>
	</tr>
	
</table>

</cfoutput>	
		
<script>
	Prosis.busy('no')
</script>		
