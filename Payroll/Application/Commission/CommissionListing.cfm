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

<!--- 

data entry screen

Define the payroll item
Set the date : driven by the current payroll status
Set the payroll schedule (currency)

Show the staff for the unit
Prior amounts (3 month) that was settled
Amount
Memo

Do not allow to enter the month amount if the schedule month = 2

--->

<cfparam name="url.ajaxid" default="">

<cf_calendarscript>
<cf_actionlistingscript>
<cf_dialogstaffing>
<cfajaximport tags="cfdiv">

<cfif url.ajaxid neq "">

        <cfquery name="Action" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">												
				SELECT      *
				FROM        Organization.dbo.OrganizationAction AS A 
				WHERE       OrgUnitActionId  = '#url.ajaxid#'				
		</cfquery>	
			
		<cfset url.id0 = action.OrgUnit>
		
</cfif>			

<cfquery name="Org" 
	datasource="AppsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT   *
	    FROM     Organization
		WHERE    OrgUnit = '#url.id0#'
</cfquery>	
	
<cfoutput>

<script>

 _cf_loadingtexthtml='';	
 
 function getdetail() {
   	ptoken.navigate('commissionListingDetail.cfm?ajaxid=#url.ajaxid#&mission=#org.mission#&orgunit=#org.orgunit#','content','','','POST','MiscellaneousEntry')
 }	

</script>

</cfoutput>

<cfinvoke component = "Service.Process.Payroll.PayrollItem"  
	   method           = "PayrollItem"   
	   returnvariable   = "accessItem">	   

<cfif accessItem eq "">

	<table width="98%" align="center" class="formpadding">
			
		<tr class="labelmedium2"><td style="font-size:16px;padding-top:4px" align="center"><cf_tl id="You do not have access to access this function"></td></tr>
	
	</table>	

<cfelse>			
		
	<cfif url.ajaxid neq "">
	
	      <cf_screentop height="100%" html="yes" jquery="Yes" layout="webapp" label="Commission">
	
			<cfquery name="Get" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">												
				SELECT      *
				FROM        PersonMiscellaneous AS M INNER JOIN
				            Organization.dbo.OrganizationAction AS A ON M.SourceId = A.OrgUnitActionId
				WHERE       A.OrgUnit             = '#org.Orgunit#' 					 
				AND         M.Source              = 'Unit'	
				AND         M.SourceId            = '#url.ajaxid#'				
			</cfquery>	
			
	<cfelse>
	
		<cf_screentop height="100%" html="no" jquery="Yes" layout="webapp" label="Attendance">		
	
	</cfif>
		
	<cfform method="POST" name="MiscellaneousEntry">
	
		<cfoutput>
		
			<table class="formpadding" style="width:98%" align="center">
			
			    <tr><td style="height:6px"></td></tr> 
			
			    <cfif url.ajaxid neq "">	
					
					<tr class="labelmedium2">	 
						<td style="padding-left:4px"><cf_tl id="Unit"></td>
						<td>#Org.Mission#/#Org.OrgUnitName#</td>
					</tr>
						 
				</cfif> 
						
			
			    <tr class="labelmedium2">
				      <td style="padding-left:4px"><cf_tl id="Schedule"></td>
				      <td>
					  <table>
					  
					     <tr class="labelmedium2">						   
						   
						     <cfif url.ajaxid neq "">							 
							  <td>#get.workaction# #dateformat(get.calendardateend,client.dateformatshow)#</td>						  
							  <input type="hidden" name="SalarySchedule" value="#get.WorkAction#">
							 							 
							 <cfelse>
							 
							     <td>
						   
								     <cfquery name="Schedule" 
										datasource="AppsPayroll"
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
									      SELECT      SS.SalarySchedule, SS.Description
				                          FROM        SalaryScheduleMission AS SSM INNER JOIN
				                                      SalarySchedule AS SS ON SSM.SalarySchedule = SS.SalarySchedule
				                          WHERE       SSM.Mission = '#org.mission#'					   
								    </cfquery>
									
									<cfselect name="salaryschedule" id="salaryschedule"
										  size="1" 
										  message="Select a schedule" 
										  onchange="_cf_loadingtexthtml='';	ptoken.navigate('getScheduleDate.cfm?mission=#org.mission#&schedule='+this.value,'processdate');getdetail()"
										  query="Schedule"						  
										  value="SalarySchedule" display="Description" class="regularxxl"/>		
						   
						         </td>
						   
								 <td style="padding-left:4px"><cf_tl id="Date"></td>
						         <td id="processdate" style="padding-left:10px">
						   
								 <cfquery name="Period" 
									datasource="AppsPayroll"
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT    TOP 1 Mission, SalarySchedule, PayrollStart, PayrollEnd
										FROM      SalarySchedulePeriod
										WHERE     Mission = '#org.mission#' 
										AND       CalculationStatus IN ('0', '1', '2') 
										AND       SalarySchedule = '#Schedule.SalarySchedule#' 
								   </cfquery>	
								  
								   #dateformat(Period.PayrollEnd,client.dateformatshow)#
								   			   
								  </td>
								  
								</cfif>  
						  </tr>
					  </table>				  			  
					  
					  </td>
				 </tr>
							
				<tr class="labelmedium2">
				
				    <td style="padding-left:4px"><cf_tl id="Item"></td>				   
														
				     <td>
					 
					    <cfif url.ajaxid neq "">
						
						    <cfquery name="Entitlement" 
								datasource="AppsPayroll"
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT   *
								    FROM     Ref_PayrollItem
									WHERE    PayrollItem = '#get.PayrollItem#'
							</cfquery>		
								
							#entitlement.PayrollItemName#								
							<input type="hidden" name="PayrollItem" value="#get.PayrollItem#">
												
						<cfelse>
					 
						     <cfquery name="Entitlement" 
								datasource="AppsPayroll"
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT   *
								    FROM     Ref_PayrollItem
									WHERE    Source IN ('Miscellaneous','Deduction')
									AND      Operational = 1
									AND      PayrollItem IN (#preservesingleQuotes(accessItem)#)
									ORDER BY Source DESC		
								</cfquery>					
						 
							   <cfselect name="payrollitem" id="payrollitem"
									  size    = "1" 
									  message = "Select a item type" 
									  query   = "Entitlement"
									  onchange = "getdetail()"
									  group   = "Source" 
									  value   = "PayrollItem" 
									  display = "PayrollItemName" class="regularxxl"/>		
								  
						  </cfif>		  		
					 
					 </td> 
					 
				</tr>
							
				<TR class="labelmedium2">
				    <TD style="padding-left:4px"><cf_tl id="Class">:</TD>
				    <TD>
					
					    <cfif url.ajaxid neq "">
						
						    #get.EntitlementClass#
							
							 <input type="hidden" name="EntitlementClass" value="#get.EntitlementClass#">
						
						<cfelse>
						
						    <table>
							<tr class="labelmedium2">
								<td><INPUT type="radio" class="radiol" id="EntitlementClass" name="EntitlementClass" value="Payment" checked onclick="getdetail()"></td>
								<td style="padding-left:5px;padding-right:10px"><cf_tl id="Payment">/<cf_tl id="Earning"></td>
								<td><INPUT type="radio" class="radiol" id="EntitlementClass" name="EntitlementClass" value="Deduction" onclick="getdetail()"></td>
								<td style="padding-left:5px;padding-right:10px"><cf_tl id="Deduction">/<cf_tl id="Recovery"></td>											
							</tr>
							</table>	
												
						</cfif>
						
					</TD>
				</TR>		
				
				<TR class="labelmedium2">
				    <TD style="padding-left:4px"><cf_tl id="Memo">:</TD>
				    <TD>
					
					    <cfif url.ajaxid neq "">
						
						    #get.Remarks#
							
							 <input type="hidden" name="Remarks" value="#get.Remarks#">
						
						<cfelse>
						
						  <input type="text" class="regularxxl" name="Remarks" style="width:95%" maxlength="100">
												
						</cfif>
						
					</TD>
				</TR>								
				
				<tr class="line"><td colspan="2"></td></tr>	
				
				<tr>
				<td colspan="2" id="content" style="padding:5px" valign="top"></td>
				</tr>					
				
			</table>
					
			 <script>
				 getdetail()
			 </script>
		
		</cfoutput>
	
	</cfform>
	
</cfif>	
