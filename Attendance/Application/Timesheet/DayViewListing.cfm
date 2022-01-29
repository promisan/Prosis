
<!--- shitfkey --->


<cfparam name="url.mode" default="view">

<script>
	
	function sel(id) {
	 if (id.checked == true) { id.checked = false 
	 } else { 
	    id.checked = true }  
	}

</script>

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset dte = dateValue>

<cfparam name="url.day"              default="#day(dte)#">
<cfparam name="url.startmonth"       default="#month(dte)#">
<cfparam name="url.startyear"        default="#year(dte)#">
<cfparam name="url.transactiontype"  default="1">
<cfparam name="url.edit"  			 default="0">

<cfquery name="getOrganizationAction" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	OrganizationAction
	WHERE 	OrgUnit IN (
				SELECT 	PAx.OrgUnit 
				FROM 	Employee.dbo.PersonAssignment PAx 
						INNER JOIN Employee.dbo.Position POx 
							ON PAx.PositionNo = POx.PositionNo 
				WHERE 	PAx.AssignmentStatus IN ('0','1')
				AND 	#dte# BETWEEN PAx.DateEffective AND PAx.DateExpiration
				AND		PAx.PersonNo = '#URL.id#'
			)
	AND     #dte# BETWEEN CalendarDateStart AND CalendarDateEnd
    AND     WorkAction = 'Attendance'	
</cfquery>

<cfif getOrganizationAction.recordCount eq "0" OR getOrganizationAction.actionStatus eq "0">
	<cfset url.edit = "1">
</cfif>

<cfquery name="workdate" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
	  FROM   PersonWork S 
	  WHERE  PersonNo = '#URL.id#'
	  AND    CalendarDate = #dte#
	  AND    TransactionType = '#url.transactiontype#'
</cfquery>

<cfinvoke component      = "Service.Access"  
	    method            = "RoleAccess"  		 
		Unit              = "#workdate.OrgUnit#"
		Role              = "'HROfficer','Timekeeper'"
		AccessLevel       = "'1','2'"
		returnvariable    = "access">		
			
<table width="100%" height="100%">
	   
    <cfoutput>
		
	<tr class="hide"><td id="process"></td></tr>
	
	<tr class="line" style="height:20px">
	  <td height="40" class="clsPrintContent" style="min-width:500px">
	  
	  <table> 
	  <tr>
	  <td style="width:36px;" class="clsNoPrint">
		  
	  <cfif url.mode eq "View">
		  <cfset dd = dateformat(dte,"dd")>
		  <cfif dd gte "2">
		  <img src="#Client.VirtualDir#/Images/Back.png" height="32" width="32" style="cursor:pointer" alt="" border="0" onclick="gotodate('#URL.ID#','#dd-1#','#Month(dte)#','#Year(dte)#','1')">
		  </cfif>
	  </cfif>
	  
	  </td>
	  
	  <td align="center" class="labelmedium" style="font-weight:300;min-width:330px;height:48px;font-size:27px;border:0px solid gray">	 	   
	  <cfoutput>#DayofWeekAsString(DayOfWeek(dte))# #dateFormat(dte, "d")# #left(MonthAsString(month(dte)),3)#&nbsp;#year(dte)#&nbsp;</cfoutput>
	  </td>
	  
	  <td style="padding-left:1px" class="clsNoPrint">
	  	  
	  <cfif url.mode eq "View">
		  <cfif dd lt daysInMonth(dte)>
		  <img src="#Client.VirtualDir#/images/next.png" height="32" width="32"  style="cursor:pointer" alt="" border="0" onclick="gotodate('#URL.ID#','#dd+1#','#Month(dte)#','#Year(dte)#','1')">
		  </cfif>
	  </cfif>
	  
  	  </td>
	  	
	  <cfquery name="workcheck" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
		  FROM   PersonWork S 
		  WHERE  PersonNo        = '#URL.id#'
		  AND    CalendarDate    = '#dateformat(dte-1,client.dateSQL)#'
		  AND    TransactionType = '#url.transactiontype#'
	  </cfquery>	
	  
	   <cfquery name="date" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
		  FROM   PersonWorkDetail S 
		  WHERE  PersonNo        = '#URL.id#'
		  AND    CalendarDate    = #dte#
		  AND    TransactionType = '#url.transactiontype#'
	  </cfquery>
	 	 	     	
	  <cfif workcheck.recordcount gte "1" and date.recordcount eq "0">			    
		
		 <td align="right" class="labelmedium" style="font-size:19px;min-width:220px">
		 	
			<cfif access eq "GRANTED">
						  
		    <cfif (workdate.actionstatus eq "0" OR workdate.recordCount eq 0) and url.mode eq "View"  and url.edit eq "1">
						  	 
			 <a href="javascript:hourcopy('#url.id#','#url.date#','#dateformat(dte-1,CLIENT.DateFormatShow)#','day')">			
			   <cf_tl id="Inherit">:#DayofWeekAsString(DayOfWeek(dte-1))# #dateFormat(dte-1, "d")# #left(MonthAsString(month(dte-1)),3)#
			 </a>	
			 
			</cfif>
			
			</cfif> 
		 		 
		 </td>
				 					 
      </cfif>		  
	  
	  <td align="right" width="100%" class="clsNoPrint">	   
	 
	  <table>
	  
	  	<tr> 
		  		  
		  <cfquery name="assign" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT 	P.*, O.OrgUnitName, O.Mission
				   	FROM 	PersonAssignment P, 
					        Organization.dbo.Organization O
				  	WHERE	P.PersonNo        = '#URL.ID#'
					  AND   P.DateEffective   <= #dte# 
					  AND   P.DateExpiration  >= #dte#
					  AND   P.Incumbency      > '0'
					  AND   P.AssignmentStatus IN ('0','1')				 
				      AND   P.AssignmentType  = 'Actual'
				      AND   P.OrgUnit         = O.OrgUnit				  	 
			</cfquery>
		  	
			<!---  	
			<cfif workdate.leaveId eq "">
			--->
			
			 <cfquery name="parameter" 
			  datasource="AppsEmployee" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT *
				  FROM   Parameter 
				  WHERE  Identifier = 'A'				  
			  </cfquery>		  
			  
			  <cfoutput>
				  
				  	  <!---			 			  
					  <cfif workcheck.source eq "Manual">
					  --->
					  
					  	  <cfif access eq "GRANTED">
						  
						  <cfif (workdate.actionstatus eq "0" OR workdate.recordCount eq 0) and url.mode eq "View" and url.edit eq "1">
					  					  
							  <td align="right" class="labelmedium2 fixlength" style="padding-left:4px;padding-right:4px;font-size:17px">
							  <a href="javascript:entryhour('#url.id#',document.getElementById('datefield').value,document.getElementById('monthfield').value,document.getElementById('yearfield').value,'')">
							  <cf_tl id="Record slots"></a>
							  </td>
						  
						  </cfif>
						  
						  </cfif>
						  
						  <cfif url.edit eq "0">
						  	<td align="right" class="labelmedium" style="font-size:15px">
								<font color="red">[<cf_tl id="You can no longer amend this record">]</font>
							</td>
						  </cfif>
						  
						  <cfif assign.recordcount eq "0">		  
				    
							  <td>|</td>
							  <td align="right" class="labelmedium2 fixlength" style="font-size:15px">
								  <cf_space spaces="30">
							      <img src="#Client.VirtualDir#/Images/Alert-Red.png" height="24" width="24" border="0" style="position:relative;top:2px;left:4px">
							      <span style="color:red;position:relative;top:-4px;"><cf_tl id="Assignment"></span>
							  </td>
							  				  
						  </cfif>	
						  
						  <cfif access eq "GRANTED">  
					 					
						      <cfif (workdate.actionstatus eq "0" OR workdate.recordCount eq 0) and url.mode eq "View" and url.edit eq "1">
							  
								  <td style="padding-left:4px;padding-right:4px">|</td>
								  <td align="right" class="labelmedium2 fixlength" title="Removes all recorded time for this date" style="padding-left:4px;padding-right:4px;font-size:17px">								 
								  	<a href="javascript:hourdel('#URL.ID#','#url.date#','','','day')">
								  	<font color="red"><cf_tl id="Undo scheduling"></font>
								  	</a>								  
								  </td>
							  
							  </cfif>	
						  
						  </cfif>	
						  
						  <td style="padding-left:8px;">|</td>
						  
						  <td align="right" class="labelmedium" style="padding-left:4px">
						    
						   		<cfquery name  = "Employee" 
								     datasource= "AppsEmployee" 
									 username  = "#SESSION.login#" 
									 password  = "#SESSION.dbpw#">               
						               	SELECT *
					               	    FROM   Person
					               	    WHERE  PersonNo = '#URL.ID#'
					            </cfquery>
								
								<span id="printTitle" style="display:none;"><cfoutput>#Employee.FirstName# #Employee.LastName#</cfoutput></span>
								
								<cf_tl id="Print" var="1">
								<cf_button2 
									mode		= "icon"
									type		= "Print"
									title       = "#lt_text#" 
									id          = "Print"					
									height		= "24px"
									width		= "24px"
									imageHeight = "20px"
									printTitle	= "##printTitle"
									printContent = ".clsPrintContent">
		
						  </td>
						
					  <!---	  
					  </cfif>
					  --->
				  
			  </cfoutput>		  				  
			  
			<!---  
			</cfif>
			--->
			
			</tr>
			
		</table>	
	  
	  </td>	  
     </tr>
	 
	 </table>
	 </td></tr>	 
	 
	 </cfoutput>
	 	 	 
	 <tr style="height:100%">
	 <td class="clsPrintContent">
	 
	 <cf_divscroll>
	 
		 <table width="99%" class="navigation_table">		 
			 	
			<cfset cd = "">	
			<cfset prior = "">
			<cfset lve = "">
			
			<!--- obtain the correct schedule for this date --->
			
			<cfquery name="getSchedule" 
			  	datasource="AppsEmployee" 
			  	username="#SESSION.login#" 
			  	password="#SESSION.dbpw#">
		    	  SELECT   *
				  FROM     PersonWorkSchedule S 
				  WHERE    PersonNo      = '#URL.id#'
				  AND      DateEffective <= #dte#
				  ORDER BY DateEffective DESC
			</cfquery>
				
			<cfloop index="hr" from="#parameter.hourstart#" to="#parameter.hourend#" step="1">
			
			    <cfquery name="schedule" 
			  	datasource="AppsEmployee" 
			  	username="#SESSION.login#" 
			  	password="#SESSION.dbpw#">
			      SELECT *
				  FROM   PersonWorkSchedule S 
				  WHERE  PersonNo         = '#URL.id#'
				  <cfif getSchedule.recordcount gte "1">
				  AND    DateEffective    = '#getschedule.dateEffective#'
				  AND    Mission          = '#getschedule.mission#'
				  <cfelse>
				  AND    1=0
				  </cfif>
				  AND    WeekDay          = #dayofweek(dte)#
				  AND    CalendarDateHour = '#hr#'
				</cfquery>
				
				<cfquery name="PersonalSchedule" 
			  	datasource="AppsEmployee" 
			  	username="#SESSION.login#" 
			  	password="#SESSION.dbpw#">
				
			      SELECT   D.HourSlot, 
						   D.HourSlots,
						   D.ActionClass,
				           D.ActionCode, 
						   D.LocationCode,
						   
						   (SELECT ViewColor         FROM Ref_WorkAction   WHERE ActionClass = D.ActionClass) as ViewColor,
						   (SELECT ActionDescription FROM Ref_WorkAction   WHERE ActionClass = D.ActionClass) as ClassDescription,	
						   (SELECT ActionColor       FROM Ref_WorkActivity WHERE ActionCode  = D.ActionCode)  as ActionColor,		
						   (SELECT ActionDescription FROM Ref_WorkActivity WHERE ActionCode  = D.ActionCode)  as ActionDescription,				  
				           
						   D.LeaveId,
						   D.ActionMemo
						 						   
				  FROM     PersonWorkDetail D
				  WHERE    PersonNo         = '#URL.id#'
				  AND      CalendarDate     = #dte#
				  AND      TransactionType  = '2'
				  AND      CalendarDateHour = '#hr#'				
				  ORDER BY HourSlot
				</cfquery>				
						
				<cfquery name="slots" 
			  	datasource="AppsEmployee" 
			  	username="#SESSION.login#" 
			  	password="#SESSION.dbpw#">
				
			      SELECT   D.HourSlotId,
				           D.HourSlot, 
						   D.HourSlots,
						   D.ActionClass,
				           D.ActionCode, 
						   D.LocationCode,
						   D.BillingMode,
						   D.BillingPayment,
						   D.ActivityPayment,
						   
						   (SELECT ViewColor         FROM Ref_WorkAction   WHERE ActionClass = D.ActionClass) as ViewColor,
						   (SELECT ActionDescription FROM Ref_WorkAction   WHERE ActionClass = D.ActionClass) as ClassDescription,	
						   (SELECT ActionColor       FROM Ref_WorkActivity WHERE ActionCode  = D.ActionCode)  as ActionColor,		
						   (SELECT ActionDescription FROM Ref_WorkActivity WHERE ActionCode  = D.ActionCode)  as ActionDescription,				  
				           
						   D.LeaveId,
						 					   
						   D.ActionMemo,
						   D.OfficerLastName,
						   D.OfficerUserId,
						   D.Created				
						  
						   
				  FROM     PersonWorkDetail D
				  WHERE    PersonNo         = '#URL.id#'
				  AND      CalendarDate     = #dte#
				  AND      TransactionType  = '#url.transactiontype#'
				  AND      CalendarDateHour = '#hr#'				
				  ORDER BY HourSlot
				</cfquery>
				
																
				<cfif personalschedule.recordcount gte "1">		
				    <cfif personalschedule.ActionColor neq "">							
					    <cfset color = "#personalschedule.ActionColor#"> 	
					<cfelse>
						<cfset color = "#personalschedule.ViewColor#"> 
					</cfif>
					<cfif left(color,4) eq "ffff">
						<cfset fcolor = "black">	
					<cfelse> 
						<cfset fcolor = "white">	
					</cfif>
					<cfset memo   = personalschedule.actionMemo>							
				<cfelseif slots.recordcount gte "1">									
				    <cfset color = "ffffaf"> 	
					<cfset fcolor = "black">	
					<cfset memo   = "">									
				<cfelseif schedule.recordcount eq "0">
					<cfset color = "f9f9f9">	
					<cfset fcolor = "black">	
					<cfset memo   = "">			
				<cfelse>
				    <!--- has a week schedule --->
					<cfset color = "F2F6FF">	
					<cfset fcolor = "black">	
					<cfset memo   = "">			
				</cfif>
						
				<tr class="labelmedium navigation_row line" style="height:13px;">
				
				<cfoutput>
					
					<cfif hr lt 0>
					    <cfset hour = "#24+hr#">
					<cfelseif hr lt "10">
						<cfset hour = "0#hr#">
					<cfelse>
						<cfset hour = "#hr#">
					</cfif>
									
					<td width="125" 
					style="<cfif assign.recordcount gte '1'>cursor: pointer;</cfif>;padding-left:4px;border-right: 1px Silver;<cfif color eq 'f9f9f9'>;font-size:8px<cfelse>;height:24px;font-size:17px</cfif>" align="left"
				    bgcolor="#color#">
																				
					<cfif assign.recordcount gte "1" and workdate.actionstatus eq "0" and access eq "GRANTED">		
					    <a href="javascript:entryhour('#url.id#','#url.day#','#url.startmonth#','#url.startyear#','#hr#','1')">
						<cfif schedule.recordcount eq "0">						
						<font color="#fcolor#">#hour#:00</font>
						<cfelse>
						<font color="#fcolor#">#hour#<font color="#fcolor#" size="1">:00</font>
						</cfif>
						</a>
					<cfelse>
						<cfif schedule.recordcount eq "0">						
						<font color="#fcolor#">#hour#:00</font>
						<cfelse>
						<font color="#fcolor#">#hour#<font color="#fcolor#" size="1">:00</font>
						</cfif>
					</cfif>
								
					</td>
				
				</cfoutput>
						
				<cfif slots.recordcount gte "1">
						
					<td height="100%">
					<table height="100%" width="100%">
							
					<cfoutput query="slots" group="hourslot">				
					
						<cfif slots.recordcount gte "1">		
										    		
						    <cfif slots.ActionColor neq "">			
								<cfset colorC = slots.viewColor>
								<cfset colorA = slots.ActionColor>
							<cfelse>			
								<cfset colorC = slots.viewColor>
								<cfset colorA = slots.viewColor>
							</cfif>					
						<cfelse>
							<cfset color = "fafafa">
						</cfif>
							 
						<tr class="labelmedium <cfif hourslots neq hourslot>line</cfif>" style="height:14px;">
							
							<td bgcolor="#colorC#" align="center" width="2"></td>							
							<td bgcolor="#colorC#" align="center" style="padding-left:5px;min-width:60">																		
								<cf_HourSlots hourslots="#hourslots#" slot="#hourslot#">											
							</td>
							
							<td align="center" style="background-color:###colorA#80;border-left:1px solid silver;border-right:1px solid silver;min-width:30;height:20px;padding-top:4px" class="clsNoPrint">
												  					
								<cfif leaveId eq "" <!--- record not from leave --->
								    and workdate.actionstatus eq "0" <!--- not closed --->
									and url.mode eq "View"
									and access eq "GRANTED" 
									and url.edit eq "1">	
								     <cf_img icon="delete"  
									    onclick="_cf_loadingtexthtml='';hourdel('#URL.ID#','#url.date#','#hr#','#hourslot#','day')">										
								</cfif>	
							
							</td>
							
							<td align="center" style="background-color:##ffffcf80;border-left:1px solid silver;border-right:1px solid silver;min-width:150">
																					
							<cfif workdate.actionstatus eq "0" and url.mode eq "View" and access eq "GRANTED" and url.edit eq "1">
							
								<cfquery name="Modality" 
										datasource="AppsPayroll" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT    * 
										FROM      Ref_PayrollTrigger
										WHERE     TriggerGroup = 'Overtime'
										and       Description NOT LIKE '%Differential%'
								</cfquery>		
								
								<table style="height:100%">
								
								<tr>
								<td valign="top" style="height:100%">
											 
								 	<select name="BillingMode" class="regularxl" style="border:0px;width:200px" onchange="ptoken.navigate('setHourModality.cfm?id=#hourSlotid#&field=BillingMode&value='+this.value,'process')">
										<option value="Contract"><cf_tl id="Contract"></option>
										<cfloop query="modality">
										<option value="#SalaryTrigger#" <cfif slots.BillingMode eq salarytrigger>selected</cfif>>#Description#</option>
										</cfloop>
									</select>	
								
								</td>
								
								<cfif slots.billingMode eq "Contract">
								    <cfset cl = "hide">
								<cfelse>
									<cfset cl = "regularxl">   
								</cfif>
								
								<td valign="top" style="height:100%;min-width:70px;border-left:1px solid silver">										 
								 	<select name="BillingPayment" id="BillingPayment#hourSlotid#" class="#cl#" style="width:95%;border:0px;" onchange="ptoken.navigate('setHourModality.cfm?id=#hourSlotid#&field=BillingPayment&value='+this.value,'process')">
										<cfloop index="itm" list="0,1">
										     <option value="#itm#" <cfif slots.BillingPayment eq itm>selected</cfif>><cfif itm eq "1"><cf_tl id="Pay"><cfelse><cf_tl id="Time"></cfif></option>
										</cfloop>	
									</select>	
								
								</td>
								
								<td style="padding-left;3px;border-left:1px solid silver"  valign="top" style="height:100%">
								
									<select name="ActivityPayment" class="regularxl" style="min-width:50px;border:0px;" onchange="ptoken.navigate('setHourModality.cfm?id=#hourSlotid#&field=ActivityPayment&value='+this.value,'process')">
									   <cfloop index="itm" list="0,1">
										<option value="#itm#" <cfif slots.ActivityPayment eq itm>selected</cfif>><cfif itm eq "0">--<cfelse>ND</cfif></option>
										</cfloop>									
									</select>	
								
								</td>	
								
								</tr>
								
								</table>
							
							<cfelse>
							
							#BillingMode# / #ActivityPayment#
							
							</cfif>
							</td>
														
							<td width="99%" style="background-color:###colorA#4D;font-weight:400;border-right:9px solid ###colorC#;font-size:14px;padding-left:5px;">

							<table width="100%" height="100%">
							
							<!--- filter: alpha(opacity=30);-moz-opacity: .30;opacity: .30 --->		
																
							<cfif actionCode neq "0">							
								
								<tr class="labelmedium" style="height:20px">
											
								    <cfif cd eq actioncode>
									
									    <td style="padding-left:15px">...</td>
										
										<cfif actionMemo neq prior>:				   
										
										    <td style="padding-left:5px;font-size:14px">									
									    	<cfif workdate.actionstatus eq "0">
											<a href="javascript:entryhour('#url.id#','#url.day#','#url.startmonth#','#url.startyear#','#hr#','#hourslot#')">
											</cfif>										
											#actionMemo#
											</a>										
											</td>
										
										</cfif>
														   
									<cfelse>		
																											
										<td style="padding-left:5px;padding-right:8px;font-size:14px">
									    	<a href="javascript:activity('#actioncode#')">#ActionDescription#:</a>
										</td>
										
										<cfif workdate.actionstatus eq "0" and access eq "GRANTED" and url.edit eq "1">
										<td style="padding-left:5x;;padding-right:8px;font-size:14px">
											<a href="javascript:entryhour('#url.id#','#url.day#','#url.startmonth#','#url.startyear#','#hr#','#hourslot#')">
												<cfif actionMemo neq "">
												<font color="808080">#actionMemo#</font>
												<cfelse>
												<i><font color="808080"><cf_tl id="Open schedule">
												</cfif>
											</a>	
										</td>
										<cfelse>
										<td style="padding-left:5x;;padding-right:8px;font-size:14px">
											<cfif actionMemo neq "">
											<font color="808080">#actionMemo#</font>												
											</cfif>												
										</td>
										</cfif>																		   
										
									</cfif>	
									
									<td align="right" id="#hourslotid#" style="font-size:10px;width:100px;border-left:1px solid gray;background-color:##ffff0080;padding-right:4px">#OfficerLastName#<br>#dateformat(Created,client.dateformatshow)# #timeformat(Created,"HH:MM")#</td>
																
									<cfset cd = actioncode>
																	
								</tr>								
								
							<cfelse>
															
								<tr class="labelmedium" style="height:20px">
							    
									<cfif workdate.actionstatus eq "0">
										<td style="padding-left:5px;padding-right:8px;font-size:14px">
										    <a href="javascript:entryhour('#url.id#','#url.day#','#url.startmonth#','#url.startyear#','#hr#','#hourslot#')">
											#ClassDescription#</a> #Memo#</td>
									<cfelse>
										<td style="padding-left:5px;padding-right:8px;font-size:14px">#ClassDescription# #Memo#</td>
									</cfif>
								
									<cfif cd neq actioncode and LocationCode neq "">
										<td style="padding-left:5px;;padding-right:5px">in #LocationCode#</td>
									<cfelse>
										<td></td>
									</cfif>	
								
									<cfif actionMemo neq prior>	
									    <td style="padding-left:5px;padding-right:8px;font-size:14px">
									    <cfif actionMemo neq "">#actionMemo#</cfif>
										</td>
									<cfelse>
										<td></td>	
									</cfif>
									
									<td align="right" id="#hourslotid#" style="font-size:10px;width:100px;border-left:1px solid gray;background-color:##ffff0080;padding-right:4px">#OfficerLastName#<br>#dateformat(Created,client.dateformatshow)# #timeformat(Created,"HH:MM")#</td>										
									
								</tr>							
																
							</cfif>
							
							<cfif leaveid neq "" and leaveid neq lve>
								
									<tr class="labelmedium" style="height:20px">
								
									<cfquery name="getLeave" 
									  	datasource="AppsEmployee" 
									  	username="#SESSION.login#" 
									  	password="#SESSION.dbpw#">
								    	  SELECT *
										  FROM   PersonLeave L INNER JOIN Ref_LeaveTypeClass R ON L.LeaveType = R.LeaveType AND L.LeaveTypeClass = R.Code
										  WHERE  Leaveid = '#leaveid#' 
										</cfquery>
										<td colspan="3" style="border-left:1px solid gray;padding-left:15px;background-color:##d4d4d480;;padding-right:15px;font-size:14px;border-right:1px solid gray">
										<cf_tl id="Leave request">:&nbsp;<a href="javascript:leaveopen('#url.id#','#leaveid#','attendance','workflow')">#getLeave.OfficerLastName# #dateformat(getLeave.created,client.dateformatshow)# - #timeformat(getLeave.Created,"HH:MM")# : #getLeave.Description#</a>
										</td>
								
									</tr>
									
							</cfif>										
														
							<cfset lve   = leaveid>
							<cfset cd    = actioncode>
							<cfset prior = actionmemo>	
							
							</table>	
							
							</td>							
																				
						</tr>	
												
					</cfoutput>		
					
					</table>
					
					</td>
									
				
				</cfif>
						
				</tr>
				
				<tr><td colspan="2" class="line"></td></tr>
									
			</cfloop>
		
			</table>
		
		</cf_divscroll>
		
		</td></tr>

</table>

<cfoutput>

<cfset ajaxonload("doHighlight")>

<script>

	<!--- refresh the cell of that person and date --->
    
	 try {		        
		 opener.opendaterefresh('#URL.id#','#day(dte)#','#month(dte)#','#year(dte)#')						
	  } catch(e) {}
			  
	  Prosis.busy('no')	

</script>


</cfoutput>