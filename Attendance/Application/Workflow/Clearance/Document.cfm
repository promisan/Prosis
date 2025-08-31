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
<!--- form to process the staff for clearance, we use the event function here to store it.
    The mechnism is source and sourceid : Action and OrgUnitActionId 
--->

<cfparam name="url.wparam" default="">

<cfquery name="Param" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT   *
	  FROM     Parameter	
</cfquery>

<cfset breakminutes = (Param.HoursInDay - Param.HoursWorkDefault) * 60>

<cfquery name="get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		  
	  SELECT *
	  FROM   OrganizationAction
	  WHERE  OrgUnitActionid = '#Object.ObjectKeyValue4#'			
</cfquery>	

<cfquery name="getPersons" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  
		  SELECT *, Postorder
		  FROM (
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
			
				) as P INNER JOIN Ref_PostGrade R ON P.PersonGrade = R.PostGrade
						
			ORDER BY P.ListingOrder, R.PostOrder, P.LastName, P.DateEffective
						
	  </cfquery>	
	  
	  <cfquery name="Modality" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    * 
			FROM      Ref_PayrollTrigger
			WHERE     TriggerGroup = 'Overtime'
			and       Description NOT LIKE '%Differential%'
	</cfquery>		
	
<cf_divscroll overflowy="Scroll">	

<form name="clearanceform" style="height:100%">  

<table width="98%" height="100%" class="formpadding">

     <cfoutput>
	 
	 <tr class="labelmedium2 fixrow">
		  <td rowspan="2" style="background-color:white;padding-left:3px;border-bottom:1px solid silver;min-width:300">
		  <table align="center">
		  <tr class="labelmedium2">
		      <td align="center" style="font-size:21px"><cf_tl id="Clearance"></td>
		  </tr>
		  <tr style="font-size:18px" class="labelmedium"><td style="padding-left:30px;font-size:15px">#dateformat(get.CalendarDateStart,client.dateformatshow)#-#dateformat(get.CalendarDateEnd,client.dateformatshow)#</td></tr>
		  </table>
		  </td>
		  <td style="background-color:white;width:100%;min-width:200px;padding-left:3px;border-bottom:1px solid silver" rowspan="2"><cf_tl id="Staff"></td>	
		  <td style="background-color:white;min-width:80;padding-left:3px;border-bottom:1px solid silver" rowspan="2"><cf_tl id="Grade"></td>
		  <td style="background-color:##b0b0b0;padding-left:3px;border-bottom:1px solid silver" align="center" colspan="3"><cf_tl id="Contract"></td>
		  <td colspan="#modality.recordcount#" align="center" style="background-color:##43CD99;padding-left:3px;border-bottom:1px solid silver"><cf_tl id="Overtime">Payable</td>
		  <td colspan="#modality.recordcount#" align="center" style="background-color:##FFFF80;padding-left:3px;border-bottom:1px solid silver"><cf_tl id="Overtime">CTO</td>
		  <td align="center" style="background-color:##e5aec4;padding-left:3px;border-bottom:1px solid silver"><cf_tl id="Night"></td>
		  <td></td>
	 </tr>
	  
	 <tr style="height:10px" class="line fixrow2"> 
		  <td align="center" style="background-color:##d0d0d0;padding-left:3px;border:1px solid silver;min-width:64"><cf_tl id="Worked"></td>
		  <td align="center" style="background-color:##D0FDC4;padding-left:3px;border:1px solid silver;min-width:64"><cf_tl id="Leave"></td>
		  <td align="center" style="background-color:##e0e0e0;padding-left:3px;border:1px solid silver;min-width:64"><cf_tl id="Days"></td>
		  <cfloop query="Modality">
		  <td align="center" style="background-color:##43CD99;padding-left:3px;border:1px solid silver;min-width:64"><cf_tl id="#Description#"></td>
		  </cfloop>
		  <cfloop query="Modality">
		  <td align="center" style="background-color:##FFFF;padding-left:3px;border:1px solid silver;min-width:64"><cf_tl id="#Description#"></td>
		  </cfloop>
		  <td align="center" style="background-color:##e5aec4;padding-left:3px;border:1px solid silver;min-width:64"><cf_tl id="Diff"></td>	 
		  <td style="min-width:24px;max-width:25px"></td>
	 </tr>
	  
	 </cfoutput>
				
						
		<cfquery name="getDetails" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">	
		  
		  SELECT PersonNo,					
			     BillingMode, 
			     BillingPayment,
			     ActivityPayment,
				 Modality,
				 SUM(Days) as Days,
				 SUM(Hours) as Hours,			 
				 SUM(OvertimePayroll) as OvertimePayroll
		 
   		  FROM (	
				  
			  SELECT    PersonNo,
			            CalendarDate,
			            BillingMode, 
			            BillingPayment,
			            ActivityPayment,
						(CASE WHEN LeaveId is NULL THEN 'Work' ELSE 'Leave' END)               AS Modality,
			            SUM(CONVERT(float, HourSlotMinutes)) / (60 * #Param.HoursWorkDefault#) AS Days,					
						SUM(CONVERT(float, HourSlotMinutes)) / (60)                            AS Hours,
						
						<!--- express overtime to be settled to a maximum --->
				
				       CASE WHEN BillingMode != 'Contract' 
				       THEN (CASE WHEN SUM(CONVERT(float, HourSlotMinutes)) / 60 > #Param.HoursWorkDefault# 
							      THEN (SUM(CONVERT(float, HourSlotMinutes))-#breakminutes#) / 60  <!--- limit overtime --->
						 	      ELSE SUM(CONVERT(float, HourSlotMinutes)) / 60 END) 
                          ELSE 0 END AS OvertimePayroll			
						
			  FROM      PersonWorkDetail
			  
			  WHERE     PersonNo IN (#quotedValueList(getPersons.PersonNo)#)
			  AND       (
			  			 ActionClass IN (SELECT   ActionClass
			                             FROM     Ref_WorkAction
	        		                     WHERE    ActionParent = 'worked')
										 
						 OR 
						 LeaveId is not NULL <!--- official leave recorded from leave module then it counts as work --->
						)
		      AND	    CalendarDate >= '#get.CalendarDateStart#' 
			  AND       CalendarDate <= '#get.CalendarDateEnd#'  	
			  AND       TransactionType     = '1'
			  
			  GROUP BY  PersonNo,
			            CalendarDate,
			  			(CASE WHEN LeaveId is NULL THEN 'Work' ELSE 'Leave' END),
			            BillingMode, 
			            BillingPayment, 
						ActivityPayment			
						
				) as D
				
	  GROUP BY 	PersonNo,		  			
	  			Modality,			
	            BillingMode, 
	            BillingPayment, 
				ActivityPayment										
						
	 </cfquery>  
			
	 <cfoutput query="getPersons">
		
			<cfset per = PersonNo>
			<cfset col = "#7+modality.recordcount*2#">
					
			<tr class="navigation_row labelmedium2 line">
			
			 <td style="padding-left:5px">
			      			  
				  	   <!--- checkbox bar --->
					   
					  <cfquery name="get" 
						  datasource="AppsOrganization" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">		  
							  SELECT *
							  FROM   OrganizationActionPerson
							  WHERE  OrgUnitActionid = '#Object.ObjectKeyValue4#'	
							  AND    Personno = '#per#'		
					  </cfquery>
					  
					  <cfif url.wparam eq "view">
					  
					  	<table width="100%" height="100%">
						<tr>
							<cfif get.actionstatus eq "1">
							<td style="background-color:##e6e6e680;padding-left:2px;border-right:1px solid gray">#dateformat(get.created,"MM/DD")# #timeformat(get.created,"HH:MM")#: #get.OfficerLastName#</td>
							<cfelseif get.actionstatus eq "9">
							<td style="background-color:##FF808080;padding-left:2px;border-right:1px solid gray">#dateformat(get.created,"MM/DD")# #timeformat(get.created,"HH:MM")#: #get.OfficerLastName#</td>
							</cfif>
						</tr>
						</table>
					  
					  <cfelse>
					  
						  <table>
						  
							  <tr class="Labelmedium2">
							  <td>	
						  
								  <table>
								  <tr>								  
								  <cfloop index="itm" list="0,1,9">								  
								     <td style="padding:4px;background-color:<cfif itm eq '0'>##C0C0C080<cfelseif itm eq '1'>##00FF0080<cfelse>##FF000080</cfif>">			
									 						
									  <input type="radio" id="#PersonNo#" name="#PersonNo#" class="radiol" value="#itm#" <cfif get.actionstatus eq itm>checked</cfif>
								    onclick="_cf_loadingtexthtml='';ptoken.navigate('#session.root#/attendance/application/Workflow/Clearance/setClearance.cfm?actionstatus=#itm#&personno=#per#&id=#Object.ObjectKeyValue4#&val='+this.value,'review#personno#')">
									
									 </td>									
								   </cfloop>									 
								  </tr>
								  </table>							  			
							
						  		</td>
						  
							    <td style="padding-left:4px" id="review#personno#">
						  
								  <table style="width:100%">
										<tr class="labelmedium2">						
										<td style="height:20px;padding-left:8px;padding-top:3px">#dateformat(get.created,"MM/DD")# #timeformat(get.created,"HH:MM")#: #get.OfficerLastName#</td>
										<td align="right" style="padding-right;4px">
										
											<cfif get.actionstatus gte "1">
																							
												<img src="#SESSION.root#/Images/memo.png" height="22" alt="Enter remarks" 
												id="detail_#per#Exp" border="0" class="regular" 						
												align="middle" style="cursor: pointer;" 
												onClick="memoshow('detail_#per#','show','#Object.ObjectKeyValue4#','#PersonNo#')">
											
											    <img src="#SESSION.root#/Images/arrowdown.gif" 
												id="detail_#per#Min" alt="Hide remarks" border="0" 
												align="middle" class="hide" style="cursor: pointer;" 
												onClick="memoshow('detail_#per#','hide','#Object.ObjectKeyValue4#','#PersonNo#')">
											
											</cfif>
										
										</td>
										</tr>
									</table>
						  
							  </td>
						  
						    </tr>
					  	  </table>
				  
				  		</cfif>
				  
			  </td>
			
			  <td style="padding-left:4px">#IndexNo# #LastName#, #FirstName#</td>
			  <td style="padding-left:10px">#PersonGrade#</td>
			  
			  <cfquery name="work" dbtype="query">
		        SELECT sum(Hours) as Hours FROM getDetails WHERE PersonNo = '#PersonNo#' AND BillingMode = 'Contract' AND Modality = 'Work'
			  </cfquery>  
			  
			  <cfquery name="leave" dbtype="query">
			    SELECT sum(Hours) as Hours FROM getDetails WHERE PersonNo = '#PersonNo#' AND BillingMode = 'Contract' AND Modality = 'Leave'
			  </cfquery> 
			
			  <cfquery name="day" dbtype="query">
			    SELECT sum(Days) as Days  FROM getDetails WHERE PersonNo = '#PersonNo#' AND BillingMode = 'Contract' 
			  </cfquery> 	
			
			  <td align="right" style="padding-right:4px;padding-left:3px;border:1px solid silver">#work.hours#</td>
			  <td align="right" style="background-color:##D0FDC450;padding-right:4px;padding-left:3px;border:1px solid silver">#leave.hours#</td>
			  <td align="right" style="padding-right:4px;padding-left:3px;border:1px solid silver">#numberformat(day.days,'._')#</td>
			  
			  <cfloop index="md" list="1,0">
			  
				  <cfloop query="Modality">
				  	  
					  <cfquery name="time" dbtype="query">	
							SELECT SUM(OvertimePayroll) as Hours 
							FROM   getDetails  
							WHERE  PersonNo       = '#Per#' 
							AND    BillingMode   != 'Contract' 
							AND    BillingPayment = '#md#'		
							AND    BillingMode    = '#salaryTrigger#'				
					  </cfquery> 		  
					  
					  <cfif md eq "1">
					  	<cfset cl = "##43CD9950">
					  <cfelse>				  
					    <cfset cl = "##FFFF8050">
					  </cfif>
					  
					  <td align="right" style="background-color:#cl#;padding-right:4px;padding-left:3px;border:1px solid silver">
					  <cfif time.hours eq "">-<cfelse>#numberformat(time.hours,'._')#</cfif>
					  </td>
					  
				  </cfloop>
			  
			  </cfloop>
			  
			  <cfquery name="activity" dbtype="query">
				SELECT sum(Hours) as Hours FROM getDetails WHERE PersonNo = '#PersonNo#' AND ActivityPayment = '1'		
			  </cfquery>  
			 		  				  
			  <td align="right" style="background-color:##e5aec450;padding-right:4px;padding-left:3px;border:1px solid silver">
			  		<cfif activity.hours eq "">-<cfelse>#numberformat(activity.hours,'._')#</cfif>
			  </td>			 		
			 
			 </tr>	
			 
			 <cfif url.wparam eq "view">
				 <cfif len(get.remarks) gte "3">
				 <tr class="labelmedium line" style="height:20px"><td style="padding-left:78px" colspan="#col-1#">#get.remarks#</td></tr>
				 </cfif>
			 <cfelse>	
			 <!--- data entry --->		 
			 <tr class="hide" id="detail_#personno#"><td id="detail_#personno#_content" colspan="#col#"></td></tr>
			 </cfif>
		
		</cfoutput>
			
		</table>
			
	</td>
	</tr>

</table>

</form>		

</cf_divscroll>

<cfset ajaxonload("doHighlight")>

