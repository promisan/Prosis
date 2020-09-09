
<!--- day schedule --->

<!--- we apply the schedule into the worktime for this day at runtime --->

<cfparam name="url.thisdate" default="">
<cfparam name="url.status"   default="0">

<cfif url.thisdate neq "">
	<cfset selectedDate = ParseDateTime("#url.thisdate#")>
	<cfset url.seldate = dateFormat(selectedDate,'DD/MM/YYYY')>
</cfif>	

<cfset dateValue = "">
<CF_DateConvert Value="#url.seldate#">
<cfset DTE = dateValue>

<!--- this no longer creates a schedule for people anymore --->

<!--- provision to remove contract days --->


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

<table style="border:1px solid silver">

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
	and       Description NOT LIKE '%Differential%'
</cfquery>

<cfloop index="hr" from="#parameter.hourstart#" to="#parameter.hourend#" step="1">
		
	<cfif hr gte "1"> <!--- STL starting from 1 oclick in the morning until 22:59 at night --->		
		 		
		<tr class="labelmedium navigation_row line" style="height:15px">
													
			<cfif hr lt 0>
			    <cfset hour = "#24+hr#">
			<cfelseif hr lt "10">
				<cfset hour = "0#hr#">
			<cfelse>
				<cfset hour = "#hr#">
			</cfif>
							
			<td style="min-width:40;padding-left:4px" align="center">#hour#</td>
			
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
				
				<td>			
					<table width="100%" style="height:100%">			
					<tr style="height:100%">		
						    
						<td style="background-color:#color#;border-left:1px solid silver;padding-left:15px;min-width:60;">												
							<cf_HourSlots hourslots="#schedule.hourslots#" slot="#slot#">								
						</td>		
							
						<td style="background-color:#color#;font-size:12px">		
																		
							   <cfif get.BillingMode eq "Contract" and get.ActionClass neq "Break">	
							   
							   	   <input type="hidden" name="BillingMode_#hr#_#slot#" value="Covered">		
								   					 					   
								   <cf_tl id="Contract covered">:&nbsp;#get.ActionClass#
								 							   
							   <cfelseif get.source eq "overtime" and get.SourceId neq url.overtimeid>
							   
							   	   <cf_tl id="Overtime request">								   
								   <input type="hidden" name="BillingMode_#hr#_#slot#" value="Covered">
							   
							   <cfelse>		
							   
							   		<cfif url.status gte "2">
									
									#get.BillingMode#
									
									<cfelseif overtime.recordcount eq "0">	
																		
										<select name="BillingMode_#hr#_#slot#" class="regularxl" style="border:0px;width:200px;<cfif get.actionClass eq 'break'>background-color:#color#</cfif>;">
										    <cfif get.recordcount eq "0" or get.actionClass eq "break">
											<option value=""></option>											
											</cfif>
											<option value="Overtime"><cf_tl id="Overtime"></option>		
											<option value="Contract"><cf_tl id="Contract"></option>		
																			
										</select>	
									
									<cfelse>	
																											 
									 	<select name="BillingMode_#hr#_#slot#" class="regularxl" style="border:0px;width:200px;<cfif get.actionClass eq 'break'>background-color:#color#</cfif>"
										  onchange="ptoken.navigate('setHourModality.cfm?field=BillingMode&id=_#hr#_#slot#&value='+this.value,'process')">
										    <cfif get.recordcount eq "0" or get.actionClass eq "break">
											<option value=""></option>											
											</cfif>
											<option value="Contract"><cf_tl id="Contract"></option>
											<cfloop query="modality">
											<option value="#SalaryTrigger#" <cfif get.BillingMode eq salarytrigger>selected</cfif>>#Description#</option>
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
									
									<cfif url.status eq "1">
									
										<select name="BillingPayment_#hr#_#slot#" id="BillingPayment_#hr#_#slot#" class="#cl#" style="width:92%;border:0px;">
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
											<cfelse><cf_tl id="Payment"></cfif>	
										</td>
										<td>
										<input type="hidden" name="BillingPayment_#hr#_#slot#" id="BillingPayment_#hr#_#slot#" value="0">
										</td>
										</tr>
										</table>								
																			
									</cfif>
								
								</cfif>
								
							</td>
									
					</tr>				
				</table>
			</td>
			</cfloop>
					
			</tr>		
				
			
	</cfif>
	
</cfloop>

</cfoutput>	

</table>