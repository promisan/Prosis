<!--- CF Personal Appointment Calendar by Kerry Reutens --->

<!--- Set Varibles Start --->
<cfparam name="URL.startyear"   default="#year(now())#">
<cfparam name="URL.startmonth"  default="#month(now())#">
<cfparam name="URL.ID0" default="">

<cfset dateob   =  CreateDate(URL.startyear,URL.startmonth,1)>
<cfset dateend  = CreateDate(Year(dateob),Month(dateob),DaysInMonth(dateob))>

<cfquery name="Unit" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	
	    SELECT 	O.Mission  <!--- this normally is the mission of the tree from where it was selected --->
								
		FROM 	Person P INNER JOIN PersonAssignment A ON P.PersonNo = A.PersonNo
				INNER JOIN Position Pos ON A.PositionNo = Pos.PositionNo 
				INNER JOIN Organization.dbo.Organization O ON A.OrgUnit = O.OrgUnit
				
		WHERE   A.PersonNo        = '#URL.ID#'
		AND     A.AssignmentStatus IN ('0','1')
		-- AND     A.AssignmentClass  = 'Regular' <!-- not needed loan staff can also have leave --->
		AND     A.AssignmentType   = 'Actual'
		AND     A.DateEffective   <= #dateend#
		AND     A.DateExpiration  >= #dateob#	
		ORDER BY Incumbency DESC 	<!--- first 100% --->
		
</cfquery>

<cfparam name="mission" default="#unit.mission#">

<cfinvoke component = "Service.Process.Employee.Attendance"  
	   method       = "LeaveAttendance" 
	   PersonNo     = "#url.id#" 		
	   Mission      = "#Mission#"	   					  
	   StartDate    = "#dateformat(dateob,client.dateformatshow)#"
	   EndDate      = "#dateformat(dateend,client.dateformatshow)#">	


<cfquery name="Colors" 
    datasource="AppsEmployee" 
 	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT 	 *
	FROM     Ref_TimeClass
	ORDER BY ListingOrder
</cfquery>	   

<table width="96%" border="0" align="center">

<tr><td height="4"></td></tr>

<tr><td width="100%" align="center" class="clsPrintContent">

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
				
		<tr>
		<td width="100%" colspan="2" align="center">
		
				<!--- display calendar start --->
				
					<table width="100%">
					<tr class="line">
					<td colspan="4" align="left">
						<cfoutput>
							<table>
								<tr>
									<td bgcolor="ffffff" style="font-size:35px;height:50" class="labelmedium">
										#Unit.Mission# #MonthAsString(Month(DateOb))# #Year(Dateob)#
									</td>
									<td style="padding-left:10px;" class="clsNoPrint">
										<span id="printTitle" style="display:none;">#Unit.Mission# #MonthAsString(Month(DateOb))# #Year(Dateob)#</span>
										<cf_tl id="Print" var="1">
										<cf_button2 
											mode		= "icon"
											type		= "Print"
											title       = "#lt_text#" 
											id          = "Print"					
											height		= "30px"
											width		= "35px"
											printTitle	= "##printTitle"
											printContent = ".clsPrintContent">
									</td>
								</tr>
							</table>
						</cfoutput>
					</td>
					
					<td colspan="3" align="right" class="labelmedium" style="font-size:17px" bgcolor="FFFFFF">
					
						<cfset prev_date=DateAdd("m",-1,dateob)>
						<cfset next_date=DateAdd("m",1,dateob)>
						<cfoutput>
							<table>
								<tr>
									<td class="labelmedium clsNoPrint" style="font-size:17px" bgcolor="FFFFFF">
										<a href="javascript:ptoken.navigate('#SESSION.root#/attendance/application/TimeSheet/CalMonth.cfm?ID0=#URL.ID0#&id=#URL.ID#&day=1&startmonth=#Month(prev_date)#&startyear=#Year(prev_date)#','contentbox1')" class="caltxtbold"><cf_tl id="Previous Month"></a> 
										- 
										<a href="javascript:ColdFusion.navigate('#SESSION.root#/attendance/application/TimeSheet/CalMonth.cfm?ID0=#URL.ID0#&ID=#URL.ID#&day=1&startmonth=#Month(next_date)#&startyear=#Year(next_date)#','contentbox1')" class="caltxtbold"><cf_tl id="Next Month"></a>					
									</td>
								</tr>
							</table>
						</cfoutput>
					
					</td>
					
					</tr>
					
					<!---
					<tr class="line">
					<td colspan="7">

						<table width="100%" align="center">
							<tr><td></td></tr>
							<tr class="labelit">
							<cfoutput>
							<cfloop query="Colors">
								<td align="center" style="min-width:90;font-size:12px;;background-color:###ViewColor#80" bgcolor="#ViewColor#">#Description#</td>
							</cfloop>
							</cfoutput>
							</tr>
						</table>
												
				    </td></tr>			
					--->	
										
					<tr>
						<cfloop index="wk" from="1" to="7">
						<cfoutput>
						<td width="100" class="labelmedium" align="center" bgcolor="e4e4e4">#left(DayOfWeekAsString(wk),3)#</td>
						</cfoutput>
						</cfloop>						
					</tr>
										
					<!--- Now we need to display the weeks of the month. --->
					<!---  The logic here is not too complex. We know that every 7 days we need to start a new table row. The only hard part is figuring out how much we need to pad the first and last row. To figure out how much we need to pad, we just figure out what day of the week the first of the month is. if it is wednesday, then we need to pad for sunday,monday, and tuesday. 3 days. --->
					<tr>
					<cfset FIRSTOFMONTH=CreateDate(Year(DateOb),Month(DateOb),1)>
					<cfset TOPAD=DayOfWeek(FIRSTOFMONTH) - 1>
					<cfset PADSTR=RepeatString("<td width=100 bgcolor=f5f5f5>&nbsp;</td>",TOPAD)>
					<cfoutput>#PADSTR#</cfoutput>
					<cfset DW=TOPAD>
																													
					<cfloop index="X" from="1" to="#DaysInMonth(DateOb)#">
											
						<cfquery name="work" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
	                       password="#SESSION.dbpw#">
							SELECT 	*
							FROM 	PersonWorkClass P INNER JOIN Ref_TimeClass R ON P.TimeClass = R.TimeClass
							WHERE   PersonNo        = '#URL.ID#'
							AND 	CalendarDate    = #Createdate(URL.startyear,URL.startmonth,X)#
							AND     TransactionType = '1'						
						</cfquery>
						
						<cfset maxk = work.recordcount>
					
					<cfoutput>
					
					<td valign="top" height="83" width="190" 
					    align="center" 						      
					    style="cursor:pointer;padding:2px;border:1px solid silver"
						onClick="entryhour('#url.id#','#x#','#url.startmonth#','#url.startyear#','0','','month')">
								           						
 						<table onMouseOver="hl(this,true,'#x#-#url.startmonth#-#url.startyear#')" onMouseOut="hl(this,false,'')" 
						       width="100%" height="100%">
                                 
							<tr>
							<td style="padding-left:4px" colspan="2" class="label"><cfoutput>#X#</cfoutput></td>									
							</tr>
							<tr>
							
							<cfif work.recordcount EQ 0>	
							
							    <td colspan="2" valign="top"><span class="caltxt">				
							    <span class="caltxt">&nbsp;</span>
								
							<cfelse>	
							
							    <td colspan="2" valign="top">							    
								<table width="100%" height="100%">
								<tr class="labelmedium">
																												
								<cfloop query="work">									
																			
									<td align="center" style="background-color:###ViewColor#80">
									    <span class="caltxt">	
										
																	
																			
										<cfset h = int(TimeMinutes/60)>
										<cfif (TimeMinutes Mod 60) eq "0">
										#h#:00
										<cfelse>
										#h#:#right((TimeMinutes Mod 60) *101, 2)# <!--- 101 is used as a mask, just to make sure that the minutes always have 2 digits --->		
										</cfif>
																							    										
									</td>
																	
								</cfloop>
																																														
								</tr>
																		
								</table>
													
							</cfif>
							</td>
							</tr>
						
						</table>

					    </td>
												
						</cfoutput>
						
   						<cfset DW=DW + 1>
    					<cfif DW EQ 7>
	    			    	</tr>
		    		    	<cfset DW=0>
			    		    <cfif X LT DaysInMonth(DateOb)><tr></cfif>
				    	    </cfif>
					</cfloop>
					
					<!--- Now we need to do a pad at the end, just to make our table "proper"  we can figure out how much the pad should be by examining DW --->
					
					<cfset TOPAD=7 - DW>
					<cfif TOPAD LT 7>
						<cfset PADSTR=RepeatString("<td width=100 bgcolor=f5f5f5>&nbsp;</td>",TOPAD)>
						<cfoutput>#PADSTR#</cfoutput>
					</cfif>
					</tr>
					
					
															
					<tr class="line">
					<td colspan="7">

						<table width="100%" align="center">
							<tr><td></td></tr>
							<tr class="labelit">
							<cfoutput>
							<cfloop query="Colors">
								<td align="center" style="min-width:90;font-size:12px;background-color:###ViewColor#80" bgcolor="#ViewColor#">#Description#</td>
							</cfloop>
							</cfoutput>
							</tr>
						</table>
						</td>
						</tr>
					</table>
						
				</td></tr>
	</table>
	
	<table><tr><td height="4"></td></tr></table>
	
</td></tr>
</table>
