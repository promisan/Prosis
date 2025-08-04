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

<!--- day schedule --->

<!--- we apply the schedule into the worktime for this day at runtime --->

<cfparam name="url.thisdate" default="">
<cfparam name="url.status"   default="0">

<cfinvoke component  = "Service.Access" 
	 method         = "RoleAccess"				  	
	 role           = "'LeaveClearer'"		
	 returnvariable = "manager">		   

<cfif url.status eq "5">
	<cfset access = "none">		  
<cfelseif manager eq "Granted">
	<cfset access = "all">        <!--- change hour and compensation --->
<cfelseif url.status eq "0">
	<cfset access = "hour">       <!--- change hours --->	
<cfelseif url.status eq "1">
	<cfset access = "hourdeny">   <!--- deny hours --->
<cfelseif url.status eq "2">
	<cfset access = "pay">        <!--- change compensation --->
<cfelse> 
	<cfset access = "none">		  <!--- status is 3 or 5 or 9 --->		
</cfif>

<cfif url.thisdate neq "">
	<cfset selectedDate = ParseDateTime("#url.thisdate#")>
	<cfset url.seldate = dateFormat(selectedDate,'DD/MM/YYYY')>
</cfif>	

<cfset dateValue = "">
<CF_DateConvert Value="#url.seldate#">
<cfset DTE = dateValue>

<!--- this no longer creates a schedule for people anymore --->
<!--- -------- provision to remove contract----- days --->

<cfquery name="base" 
  	datasource="AppsEmployee" 
  	username="#SESSION.login#" 
  	password="#SESSION.dbpw#">			
      DELETE   PersonWork
	  FROM     PersonWork A
	  WHERE    PersonNo         = '#URL.personno#'
	  AND      CalendarDate     = #dte#
	  AND      TransactionType  = '1'	 			  
	  AND      NOT EXISTS (SELECT 'X' 
	                       FROM   PersonWorkDetail 
						   WHERE  PersonNo        = A.PersonNo
						   AND    CalendarDate    = A.CalendarDate
						   AND    TransactionType = A.TransactionType
						   AND    BillingMode    != 'Contract')						   
</cfquery>	

<cfinvoke component = "Service.Process.Employee.Attendance"  
	   method       = "LeaveAttendance" 
	   PersonNo     = "#url.PersonNo#" 		
	   Mission      = "#url.Mission#"	   
	   Mode         = "force"					  
	   StartDate    = "#dateformat(dte,client.dateformatshow)#"
	   EndDate      = "#dateformat(dte,client.dateformatshow)#">		   

<cfquery name="schedule" 
  	datasource="AppsEmployee" 
  	username="#SESSION.login#" 
  	password="#SESSION.dbpw#">
      SELECT   TOP 1 *
	  FROM     PersonWorkSchedule S 
	  WHERE    PersonNo         = '#URL.PersonNo#'
	  AND      Mission          = '#URL.Mission#'	 
	  AND      DateEffective    <= #dte#	 
	  ORDER BY DateEffective DESC	  
</cfquery>

<cfif schedule.recordcount gte "1">

	<table>
		
	<cfoutput>
	
	<cfquery name="parameter" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM   Parameter 
			WHERE  Identifier = 'A'				  
	</cfquery>	
	
	<cfquery name="overtime" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	SELECT *
		    FROM   PersonOvertime
			WHERE  OvertimeId = '#URL.overtimeid#'
	</cfquery>
	
	<cfquery name="base" 
	  	datasource="AppsEmployee" 
	  	username="#SESSION.login#" 
	  	password="#SESSION.dbpw#">			
	     	SELECT   *						  					   
		  	FROM     PersonWorkDetail
		  	WHERE    PersonNo         = '#URL.personno#'
		  	AND      CalendarDate     = #dte#
		  	AND      TransactionType  = '1'	 			  
	</cfquery>		
	
	<!--- provision to clean indorect hours --->
	
	<cfquery name="Modality" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    * 
			FROM      Ref_PayrollTrigger
			WHERE     TriggerGroup = 'Overtime'
			AND       Description NOT LIKE '%Differential%'
	</cfquery>
	
	<!--- we set here the hour period that may deviate from the calandar date itself as sually 
	                                                 the early night belongs to the prior period --->
													 
	<cfif parameter.weekhourend lt parameter.weekhourstart>
		<cfset end = parameter.weekhourend + 24>
	<cfelse>
		<cfset end = parameter.weekhourend>	
	</cfif>
	
	<cfif url.status eq "2">
		
		<tr class="line">
			<td colspan="#schedule.hourslots#" style="padding:5px;" align="right">
				<table>
					<tr>
						<td>
							<cf_tl id="Set all as">:
						</td>	
						<td style="padding-left:5px;">
						
							<input type="radio" id="setAllTime" name="setAllType" 
							onclick="$('.clsBillingPayment').val('0');document.getElementById('submissionline').className='regular'" style="cursor:pointer;"> 
							<label for="setAllTime" style="cursor:pointer;"><cf_tl id="Time"></label>
						</td>
						<td style="padding-left:5px;">
							<input type="radio" id="setAllPay" name="setAllType" 
							onclick="$('.clsBillingPayment').val('1');document.getElementById('submissionline').className='regular'" style="cursor:pointer;"> 
							<label for="setAllPay" style="cursor:pointer;"><cf_tl id="Pay"></label>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	
	</cfif>
	
	<cfloop index="hr" from="#parameter.weekhourstart#" to="#end#" step="1">
				 		
			<tr class="labelmedium navigation_row line" style="height:15px">
														
				<cfif hr lt 0>
				    <cfset hour = "#24+hr#">
				<cfelseif hr lt "10">
					<cfset hour = "0#hr#">
				<cfelseif hr gt "24">	
					<cfset hour = "0#hr-24#">
				<cfelse>
					<cfset hour = "#hr#">
				</cfif>
								
				<td style="min-width:40;padding-left:4px" align="center">#hour#</td>
				<td>		
						
				<table width="100%" style="height:100%">	
				<tr class="labelmedium" style="height:100%">	
				
				<cfloop index="slot" from="1" to="#schedule.hourslots#">
				
					<!--- obtain data recorded --->
					
					<cfquery name="get" dbtype="query">
					  SELECT   *						  					   
					  FROM     Base
					  WHERE    CalendarDateHour = '#hr#'	
					  AND      HourSlot         = '#slot#'				  
					</cfquery>				
					
					<cfif get.billingmode eq "Contract">				
						<cfset color = "C1E0FF">	
					<cfelseif  get.source eq "overtime" and get.SourceId neq url.overtimeid>		
						<cfset color = "yellow">	 		
					<cfelse>
						<cfset color = "ffffff">	
					</cfif>								
													    
							<td style="background-color:#color#;border-left:1px solid silver;padding-left:15px;min-width:60;">												
								<cf_HourSlots hourslots="#schedule.hourslots#" slot="#slot#">								
							</td>		
								
							<td style="width:200px;background-color:#color#;font-size:12px">		
																			
								   <cfif get.BillingMode eq "Contract" and get.ActionClass neq "Break">	
								   
								   	   <input type="hidden" name="BillingMode_#hr#_#slot#" value="Covered">		
									   					 					   
									   <cf_tl id="Contract covered">:&nbsp;#get.ActionClass#
									 							   
								   <cfelseif get.source eq "overtime" and get.SourceId neq url.overtimeid>
								   
								   	   <cf_tl id="Overtime request resubmitted">								   
									   <input type="hidden" name="BillingMode_#hr#_#slot#" value="Covered">
								   
								   <cfelse>		
								   
								  						  
								   		<cfif access eq "none" or access eq "pay">
										
										<input type="hidden" name="BillingMode_#hr#_#slot#" value="#get.BillingMode#">
										
										<cfquery name="getName" 
											datasource="AppsPayroll" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												SELECT    * 
												FROM      Ref_PayrollTrigger
												WHERE     SalaryTrigger = '#get.BillingMode#'
										</cfquery>
										
										
										#getName.Description#
										
										<cfelseif overtime.recordcount eq "0">	<!--- all or hour --->
																			
											<select name="BillingMode_#hr#_#slot#" class="regularxl" style="border:0px;width:200px;<cfif get.actionClass eq 'break'>background-color:#color#</cfif>;">
											    <cfif get.recordcount eq "0" or get.actionClass eq "break">
												<option value=""></option>											
												</cfif>
												<option value="Overtime"><cf_tl id="Overtime"></option>		
												<option value="Contract"><cf_tl id="Contract"></option>																				
											</select>	
										
										<cfelseif access eq "hourdeny"> 
										
										    <!--- all or hour --->	
											
											<cfif get.BillingMode eq "">
											
											 	<input type="hidden" name="BillingMode_#hr#_#slot#" value="Covered">
											
											<cfelse>
																																						 
											 	<select name="BillingMode_#hr#_#slot#" class="regularxl" style="border:0px;width:200px;<cfif get.actionClass eq 'break'>background-color:#color#</cfif>"
												  onchange="ptoken.navigate('setHourModality.cfm?field=BillingMode&id=_#hr#_#slot#&value='+this.value,'process')">
												    <cfif get.recordcount eq "0" or get.actionClass eq "break">
														<option value=""></option>											
													</cfif>
													<option value="Contract"><cf_tl id="Contract covered"></option>											
													<cfloop query="modality">
														<cfif get.BillingMode eq salarytrigger>
													    <option value="#SalaryTrigger#" selected>#Description#</option>
														</cfif>
													</cfloop>											
												</select>	
											
											</cfif>
											
										<cfelse>
										
										    <!--- all or hour --->	
																												 
										 	<select name="BillingMode_#hr#_#slot#" class="regularxl" style="border:0px;width:200px;<cfif get.actionClass eq 'break'>background-color:#color#</cfif>"
											  onchange="ptoken.navigate('setHourModality.cfm?field=BillingMode&id=_#hr#_#slot#&value='+this.value,'process')">
											    <cfif get.recordcount eq "0" or get.actionClass eq "break">
												<option value=""></option>											
												</cfif>
												<option value="Contract"><cf_tl id="Contract covered"></option>
												<cfloop query="modality">
																							
													<cfif findNoCase(salarytrigger,quotedValueList(Base.BillingMode))> 
													    <option value="#SalaryTrigger#" <cfif get.BillingMode eq salarytrigger>selected</cfif>>#Description#</option>
													</cfif>	
													
												</cfloop>
											</select>	
											
										
										</cfif>						 
									
								   </cfif>	
									
								</td>
									
								<td valign="top" style="background-color:#color#;height:100%;min-width:70px;border-left:1px solid silver">	
																												
								    <cfif get.BillingMode eq "Contract">									
										 <cfset cl = "hide">												
									<cfelseif get.source eq "overtime" and get.SourceId neq url.overtimeid>								
										 <cfset cl = "hide">								 
									<cfelse>
									
										<cfif get.billingMode eq "Contract" or get.recordcount eq "0">
										    <cfset cl = "hide">
										<cfelse>
											<cfset cl = "regularxl">   
										</cfif>
										
										<!--- if status is 1 or access role it will allow to change this ---> 
										
										<cfif access eq "pay" or access eq "all">
										
											<select name="BillingPayment_#hr#_#slot#" id="BillingPayment_#hr#_#slot#" class="#cl# clsBillingPayment" 
											style="width:92%;border:0px;" onchange="ptoken.navigate('setHourModality.cfm?field=BillingPayment&id=_#hr#_#slot#&value='+this.value,'process')">
												<cfloop index="itm" list="0,1">
												     <option value="#itm#" <cfif get.BillingPayment eq itm>selected</cfif>><cfif itm eq "1"><cf_tl id="Pay"><cfelse><cf_tl id="Time"></cfif></option>
												</cfloop>	
											</select>	
																				
										<cfelse>	
																														
											<table>
											<tr class="labelmedium">
											<td style="padding-left:3px;padding-top:1px"> 
												<cfif get.BillingPayment eq "">
												<cfelseif get.BillingPayment eq "0"><cf_tl id="Time">
												<cfelse><cf_tl id="Pay"></cfif>	
											</td>
											<td>
											<input type="hidden" name="BillingPayment_#hr#_#slot#" id="BillingPayment_#hr#_#slot#" value="0">
											</td>
											</tr>
											</table>								
																				
										</cfif>
									
									</cfif>
									
								</td>
					
				</cfloop>			
								
				</tr>			
				</table>
				</td>
						
				</tr>						
			
	</cfloop>
	
	</cfoutput>	
	
	</table>
	
<cfelse>

	<table>
	
	<cfoutput>
	<tr class="labelmedium2"><td style="color:red">Your workschedule could not be determined for date : #date#</td></tr>
	</cfoutput>
	
	</table>

</cfif>	