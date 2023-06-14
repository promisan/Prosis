
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

<cf_calendarscript>

 <cfquery name="Org" 
	datasource="AppsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     Organization
		WHERE    OrgUnit = '#url.id0#'
</cfquery>		


<cfinvoke component = "Service.Process.Payroll.PayrollItem"  
	   method           = "PayrollItem"   
	   returnvariable   = "accessItem">	   

<cfif accessItem eq "">

	<table width="98%" align="center" class="formpadding">
	
		<tr><td><cfinclude template="../PersonViewHeaderToggle.cfm"></td></tr>	
		<tr class="labelmedium2"><td style="font-size:16px;padding-top:4px" align="center"><cf_tl id="You do not have access to record records"></td></tr>
	
	</table>	

<cfelse>				   
	
	<cf_screentop height="100%" html="no" jquery="Yes" layout="webapp" label="Attendance">
	
	<cfform method="POST" name="MiscellaneousEntry">
	
	<cfoutput>
	
		<table class="formpadding formspacing" style="width:100%">
		    <tr class="labelmedium2">
			      <td style="padding-left:4px"><cf_tl id="Schedule"></td>
			      <td>
				  <table>
				     <tr class="labelmedium2">
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
						  onchange="_cf_loadingtexthtml='';	ptoken.navigate('getScheduleDate.cfm?mission=#org.mission#&schedule='+this.value,'processdate')"
						  query="Schedule"						  
						  value="SalarySchedule" 
						  display="Description" class="regularxxl"/>		
					   
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
					  </tr>
				  </table>				  			  
				  
				  </td>
			 </tr>
						
			<tr class="labelmedium2">
			
			    <td style="padding-left:4px"><cf_tl id="Item"></td>				   
					
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
				
					<!---					
									
					<cfquery name="Entitlement" 
					datasource="AppsPayroll"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
					    SELECT *
					    FROM  Ref_PayrollItem
						WHERE PayrollItem IN ( SELECT  C.PayrollItem 
						                       FROM    Ref_PayrollComponent C INNER JOIN Ref_PayrollTrigger E ON C.SalaryTrigger  = E.SalaryTrigger 
											   AND     E.TriggerGroup IN ('Personal')
											 )
												
						AND   PayrollItem NOT IN (SELECT SSC.PayrollItem 
						                          FROM   SalaryScheduleComponent AS SSC 
							                          INNER JOIN Ref_PayrollComponent AS PC ON SSC.ComponentName = PC.Code 
													  INNER JOIN Ref_PayrollTrigger AS TR ON PC.SalaryTrigger = TR.SalaryTrigger
												  WHERE  TR.TriggerGroup <> 'Personal')
												  								  
						AND   PayrollItem NOT IN (SELECT PayrollItem FROM Ref_PayrollGroupItem WHERE Code = 'Final')						  
						
						AND Source != 'Miscellaneous'							
							
						UNION		
															   
						SELECT *
					    FROM  Ref_PayrollItem
						
						WHERE PayrollItem IN (SELECT PayrollItem
						                      FROM 	 SalarySchedulePayrollItem
											  WHERE  Operational = 1 
											  AND    SalarySchedule IN (SELECT SalarySchedule
											                           FROM    SalaryScheduleMission
																	   WHERE Mission = '#org.mission#'))	
							
						AND   PayrollItem NOT IN (SELECT SSC.PayrollItem 
						                          FROM   SalaryScheduleComponent AS SSC 
							                          INNER JOIN Ref_PayrollComponent AS PC ON SSC.ComponentName = PC.Code 
													  INNER JOIN Ref_PayrollTrigger AS TR ON PC.SalaryTrigger = TR.SalaryTrigger
												  WHERE  TR.TriggerGroup <> 'Personal')
							
						AND   PayrollItem NOT IN (SELECT PayrollItem FROM Ref_PayrollGroupItem WHERE Code = 'Final')
						
						AND Source != 'Miscellaneous'		
						
						ORDER BY Source										   											   
																			   					
					</cfquery>
					
					--->
							
			     <td>
				 
				   <cfselect name="entitlement" id="entitlement"
						  size    = "1" 
						  message = "Select a item type" 
						  query   = "Entitlement"
						  group   = "Source" 
						  value   = "PayrollItem" 
						  display = "PayrollItemName" class="regularxxl"/>				
				 
				 </td> 
				 
			</tr>
						
			<TR class="labelmedium2">
			    <TD style="padding-left:4px"><cf_tl id="Class">:</TD>
			    <TD><cfoutput>
				    <table>
					<tr class="labelmedium2">
						<td><INPUT type="radio" class="radiol" id="EntitlementClass" name="EntitlementClass" value="Payment" checked></td>
						<td style="padding-left:5px;padding-right:10px"><cf_tl id="Payment">/<cf_tl id="Earning"></td>
						<td><INPUT type="radio" class="radiol" id="EntitlementClass" name="EntitlementClass" value="Deduction"></td>
						<td style="padding-left:5px;padding-right:10px"><cf_tl id="Deduction">/<cf_tl id="Recovery"></td>											
					</tr>
					</table>	
					</cfoutput>	
				</TD>
			</TR>						
			
			<tr class="line"><td colspan="2"></td></tr>	
			
			<tr>
			<td colspan="2" id="content" style="padding:5px" valign="top"></td>
			</tr>
					
			
		</table>
				
		 <script>
			 ptoken.navigate('commissionListingDetail.cfm?mission=#org.mission#&orgunit=#org.orgunit#','content','','','POST','MiscellaneousEntry')
		 </script>
	
	</cfoutput>
	
	</cfform>
	
</cfif>	
