
<cfparam name="URL.class"  default="">
<cfparam name="URL.balancestatus"  default="0">

<!--- check for leave manager access --->	 
	 
<cfinvoke component  = "Service.Access" 
	 method         = "RoleAccess"				  	
	 role           = "'LeaveClearer'"		
	 returnvariable = "manager">	
	 
<cfif manager eq "Granted">
	<cfset access = "ALL">
<cfelse>
	<cfset access = "NONE">	
</cfif>	 

<cfquery name="qType" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_LeaveType
	WHERE    LeaveType       = '#URL.LeaveType#'
</cfquery>

<cfquery name="qPerson" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   P.*, N.Name as NationName
	FROM     Person as P INNER JOIN System.dbo.Ref_Nation N ON P.Nationality = N.Code
	WHERE    P.PersonNo       = '#URL.ID#'
</cfquery>

<cfquery name="Class" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_LeaveTypeClass
	WHERE    LeaveType       = '#URL.LeaveType#'
	AND      Code = '#url.class#'
</cfquery>

<!--- we obtain the last or current mission assignment of this person --->

<cfquery name="qAssignment" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     vwAssignment
	WHERE    PersonNo = '#URL.ID#'
	AND      AssignmentStatus in ('0','1')
	AND 	 Incumbency > 0
	AND 	 DateEffective <= #now()#
	ORDER BY DateEffective DESC
</cfquery>

<cfif qAssignment.recordcount eq "0">

<cfquery name="qAssignment" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     vwAssignment
	WHERE    PersonNo = '#URL.ID#'
	AND      AssignmentStatus in ('0','1')	
	AND 	 DateEffective <= #now()#
	ORDER BY DateEffective DESC
</cfquery>

</cfif>

<!--- determined expiration date of the person --->
<cfset ExpirAs = qAssignment.dateExpiration>
<cfset Mission = qAssignment.Mission>

<cfquery name="Balance" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT       Year(DateEffective) as LeaveYear,
	             L.*,
	             R.Description as ContractDescription 
	    FROM     PersonLeaveBalance L,
   				 Ref_ContractType R
		WHERE    L.PersonNo      = '#URL.ID#' 
		AND      L.LeaveType     = '#URL.LeaveType#'
		AND      L.BalanceStatus = '#url.balancestatus#'
		<cfif url.class eq "">
		AND      L.LeaveTypeClass is NULL
		<cfelse>
		AND      L.LeaveTypeClass = '#url.class#'
		</cfif>
		AND      L.ContractType = R.ContractType
		ORDER BY Year(DateEffective) DESC, DateEffective DESC
</cfquery>

<cfset oPA = CreateObject("component","Service.Process.Employee.PersonnelAction")/>
<cfset rEOD = oPA.getEOD(Type="SQL",PersonNo="#url.id#",Mission="#Mission#")/>
		
<cfset last = '1'>

<cfset prior = Balance.ContractType>

<cfset vTitleLabelStyle = "font-size:80%;">

<table width="99%" align="center" class="<cfoutput>clsPrintContentDetail_#URL.LeaveType#</cfoutput>">
	<tr>
		<td style="display:none;" class="<cfoutput>clsPrintContentDetail_#URL.LeaveType#_Printout</cfoutput>">
			<table width="100%" class="formpadding">
						
				<cfoutput query="Balance" group="LeaveYear">
			
					<cfset vLastDayYear = createDate(LeaveYear,12,31)>
					<cfif LeaveYear eq YEAR(now())>
						<cfset vLastDayYear = now()>
					</cfif>
					<cfif vLastDayYear gt ExpirAs>
						<cfset vLastDayYear = ExpirAs>
					<cfelse>
						<cfset vLastDayYear	= dateformat(vLastDayYear,client.dateSQL)>
					</cfif>
					
					<!--- obtain data for the header -f the print --->

					<cfquery name="qAssignment" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT  PA.*,
								O.OrgUnitName,
								O.OrgUnitCode
						FROM    PersonAssignment as PA 
								INNER JOIN Organization.dbo.Organization O ON PA.OrgUnit = O.OrgUnit
						WHERE   PA.PersonNo = '#URL.ID#'
						AND 	PA.AssignmentStatus IN ('0','1')
						AND 	PA.Incumbency > 0
						AND 	'#vLastDayYear#' BETWEEN PA.DateEffective AND PA.DateExpiration
						ORDER BY DateEffective DESC
						
					</cfquery>
										
					<cfif qAssignment.recordcount eq "0">
					
						<cfquery name="qAssignment" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT  PA.*,
									O.OrgUnitName,
									O.OrgUnitCode
							FROM    PersonAssignment as PA 
									INNER JOIN Organization.dbo.Organization O
										ON PA.OrgUnit = O.OrgUnit
							WHERE   PA.PersonNo = '#URL.ID#'
							AND 	PA.AssignmentStatus IN ('0','1')						
							AND 	'#vLastDayYear#' BETWEEN PA.DateEffective AND PA.DateExpiration
							ORDER BY DateEffective DESC
						</cfquery>
					
					</cfif>

					<cfquery name="qContract" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT  PC.*,
								L.Description as LocationName,
								CT.Description as ContractTypeDescription,
								ASt.Description as AppointmentStatusDescription
						FROM    PersonContract as PC 
								INNER JOIN Payroll.dbo.Ref_PayrollLocation L
									ON PC.ServiceLocation = L.LocationCode
								INNER JOIN Ref_ContractType CT
									ON PC.ContractType = CT.ContractType
								INNER JOIN Ref_AppointmentStatus ASt
									ON PC.AppointmentStatus = ASt.Code
						WHERE   PC.PersonNo      = '#URL.ID#'
						AND 	PC.RecordStatus != '9'
						AND 	PC.Mission       = '#Mission#'
						AND 	'#vLastDayYear#' BETWEEN PC.DateEffective AND PC.DateExpiration
						ORDER BY DateEffective DESC
					</cfquery>

					<tr class="clsPrintContentDetail_#URL.LeaveType#_Line clsPrintContentDetail_#URL.LeaveType#_#LeaveYear#">
						<td style="border:1px solid ##C0C0C0; font-size:150%; font-weight:bold; padding:5px;" class="labellarge">
							<cf_tl id="Balance" var="1">
							#LeaveYear# #ucase(qType.Description)# <cfif url.class neq "">#ucase(class.description)#</cfif> #ucase(lt_text)# 
						</td>
					</tr>
					<tr class="clsPrintContentDetail_#URL.LeaveType#_Line clsPrintContentDetail_#URL.LeaveType#_#LeaveYear#">
						<td style="border:1px solid ##C0C0C0;">
							<table width="100%">
								<tr class="labelmedium">
									<td style="padding:5px; font-weight:bold;"><span style="#vTitleLabelStyle#;"><cf_tl id="Name">:</span><br>#ucase(qPerson.FullName)#</td>
									<td style="border-left:1px solid ##C0C0C0; padding:5px;"><span style="#vTitleLabelStyle#;"><cf_tl id="IndexNo (PersonNo)">:</span><br>#qPerson.IndexNo# (#qPerson.PersonNo#)</td>
									<td style="border-left:1px solid ##C0C0C0; padding:5px;"><span style="#vTitleLabelStyle#;"><cf_tl id="EOD">:</span><br>#dateFormat(rEOD, client.DateFormatShow)#</td>
									<td style="border-left:1px solid ##C0C0C0; padding:5px;"><span style="#vTitleLabelStyle#;"><cf_tl id="Nationality">:</span><br>#qPerson.NationName#</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr class="clsPrintContentDetail_#URL.LeaveType#_Line clsPrintContentDetail_#URL.LeaveType#_#LeaveYear#">
						<td style="border:1px solid ##C0C0C0;">
							<table width="100%">
								<tr class="labelmedium <cfif qContract.recordCount gt 0>line</cfif>">
									<td style="padding:5px; font-weight:bold;" width="18%"><span style="#vTitleLabelStyle#;"><cf_tl id="Report as of">:</span><br>#dateFormat(vLastDayYear, client.DateFormatShow)#</td>
									<td style="border-left:1px solid ##C0C0C0; padding:5px;" colspan="2"><span style="#vTitleLabelStyle#;"><cf_tl id="Function Title">:</span><br>#qAssignment.FunctionDescription#</td>
									<td style="border-left:1px solid ##C0C0C0; padding:5px;" colspan="2"><span style="#vTitleLabelStyle#;"><cf_tl id="Unit">:</span><br>#qAssignment.OrgUnitCode# - #qAssignment.OrgUnitName#</td>
								</tr>
								<cfif qContract.recordCount gt 0>
									<tr class="labelmedium">
										<td></td>
										<td style="border-left:1px solid ##C0C0C0; padding:5px;"><span style="#vTitleLabelStyle#;"><cf_tl id="Grade">:</span><br>#qContract.ContractLevel#/#qContract.ContractStep#</td>
										<td style="border-left:1px solid ##C0C0C0; padding:5px;"><span style="#vTitleLabelStyle#;"><cf_tl id="Location">:</span><br>#qContract.LocationName#</td>
										<td style="border-left:1px solid ##C0C0C0; padding:5px;"><span style="#vTitleLabelStyle#;"><cf_tl id="Appointment">:</span><br>#qContract.ContractTypeDescription#</td>
										<td style="border-left:1px solid ##C0C0C0; padding:5px;"><span style="#vTitleLabelStyle#;"><cf_tl id="Appointment Status">:</span><br>#qContract.AppointmentStatusDescription#</td>
									</tr>
								</cfif>
							</table>
						</td>
					</tr>

					<cfoutput></cfoutput>
				</cfoutput>
			</table>
		</td>
	 </tr>
	 <tr><td height="15">&nbsp;</td></tr>
	<tr>
		<td>
			<table width="100%" class="navigation_table" border="0" cellspacing="0" cellpadding="0" align="center">
			   <TR class="labelmedium line">
			    <td style="width:80%;padding-left:4px"><cf_tl id="Contract"></td>
			    <TD style="min-width:90px;padding-left:3px" width="100"><cf_tl id="Start"></TD>
				<TD style="min-width:90px;padding-left:3px" width="100"><cf_tl id="End"></TD>	
				<TD style="min-width:130px;padding-left:5px"><cf_tl id="Reason"></TD>
				<TD style="min-width:80px;padding-left:3px" align="right" width="60"><cf_tl id="Adjust"></TD>		
				<td style="min-width:80px;padding-left:3px" align="right" width="60"><cf_tl id="Opening"></td>	
				<td style="min-width:80px;padding-left:3px" align="right" width="60"><cf_tl id="Accrual"></td>		
				<TD style="min-width:80px;padding-left:3px" align="right" width="60"><cf_tl id="Taken"></TD>
				<TD align="right" style="min-width:80px;padding-right:4px"><cf_tl id="Closing"></TD>
				<cfif qtype.leaveAccrual eq "2" and access eq "ALL">
				<TD align="right" style="min-width:80px;padding-right:4px"><cf_tl id="Action"></TD>
				<cfelse>
				<td></td>
				</cfif>
			</TR>
			
			<cfoutput query="Balance" group="LeaveYear">
				 <tr class="line labelmedium clsPrintContentDetail_#URL.LeaveType#_Line clsPrintContentDetail_#URL.LeaveType#_#LeaveYear#">
					 <td rowspan="2" colspan="6" style="font-size:22px;padding-left:5px" class="labelmedium">
					 		<table>
					    		<tr>
					    			<td class="clsNoPrint" style="padding-bottom:3px; padding-right:5px;">
										<cf_tl id="Print" var="1">
										<cf_button2 
											mode		= "icon"
											type		= "Print"
											title       = "#lt_text#" 
											id          = "Print"					
											height		= "15px"
											width		= "20px"
											imageHeight = "20px"
											printContent = ".clsPrintContentDetail_#URL.LeaveType#"
											printCallback = "$('.clsPrintContentDetail_#URL.LeaveType#_Line').hide(); $('.clsPrintContentDetail_#URL.LeaveType#_Printout, .clsPrintContentDetail_#URL.LeaveType#_#LeaveYear#').show();">
					    			</td>
					    			<td class="labelmedium">
					    				#LeaveYear# 
										<cfif url.class neq "">
											<font size="3">#class.description#</font>
										</cfif>
					    			</td>
					    		</tr>
					    	</table>
					 </td>
					 
					 <cfquery name="SUM" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   SUM(Credit) as Credit,
							         SUM(Adjustment) as Adjustment,
									 SUM(Taken) as Taken			           
						    FROM     PersonLeaveBalance
							WHERE    PersonNo      = '#URL.ID#' 
							AND      LeaveType     = '#URL.LeaveType#'
							AND      BalanceStatus = '#url.balancestatus#'
							<cfif url.class eq "">
						   	AND      LeaveTypeClass is NULL
							<cfelse>
						  	AND      LeaveTypeClass = '#url.class#'
							</cfif>
							AND      Year(DateEffective) = '#leaveYear#'				
					</cfquery>	
					
				</tr>
				
				<tr style="height:28px;border-top:1px solid silver;" class="clsPrintContentDetail_#URL.LeaveType#_Line clsPrintContentDetail_#URL.LeaveType#_#LeaveYear#">	
											 		
					<TD style="background-color:##C0F1C180;font-size:15px;padding-right:3px;border-left:1px solid silver;border-right:1px solid silver" align="right">#NumberFormat(sum.Credit,".__")#</TD>
					<!---
					<TD style="padding-left:3px" align="right"><cfif Adjustment eq "0">..<cfelse>#NumberFormat(sum.Adjustment,"__.__")#</cfif></TD>
					--->			
					<TD style="background-color:##A6D2FF80;font-size:15px;padding-right:3px;border-right:1px solid silver" align="right"><cfif sum.Taken eq "0">..<cfelse>#NumberFormat(sum.Taken,".__")#</cfif></TD>
					<TD align="right" bgcolor="<cfif Balance lt 0>red</cfif>" style="<cfif Balance lt 0>color:white</cfif>;font-size:15px;padding-right:4px;border-right:1px solid silver">#NumberFormat(Balance,"__.__")#</TD>				 
								
				</tr>
				
				<cfset eff = dateEffective>
				 	
				<cfoutput>
						
					<cfif ContractType neq prior>
					    <tr class="clsPrintContentDetail_#URL.LeaveType#_Line clsPrintContentDetail_#URL.LeaveType#_#LeaveYear#"><td height="1" colspan="8" class="top2"></td></tr>
					</cfif>
					
					<cfset opening = Balance+Taken-Credit>
					
					<cfif opening eq balance 
					       and taken eq "0" 
						   and credit eq "0" 
						   and leavetype neq "annual"
						   and currentrow neq "1" 
						   and currentrow neq recordcount 
						   and adjustment eq "0">
							
					  			   
					<cfelse>
												
						<TR class="navigation_row labelit line clsPrintContentDetail_#URL.LeaveType#_Line clsPrintContentDetail_#URL.LeaveType#_#LeaveYear#" style="height:12px;">	
							<cfif ContractType neq prior or currentrow eq 1>	
								<td style="min-width:120px;padding-left:9px;border-right:1px solid silver;border-left:0px solid silver">#ContractDescription#</td>
							<cfelseif daysinmonth(dateexpiration) neq day(dateexpiration)>
								<td style="padding-left:30px;border-right:1px solid silver;border-left:0px solid silver">..<font color="008000"><cf_tl id="Contract amendment"></td>
							<cfelse>				
								<td style="padding-left:30px;border-right:1px solid silver;border-left:0px solid silver"><cf_tl id="same"></td>
							</cfif>		
							<td align="center" style="padding-left:3px;border-right:1px solid silver">#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
							<td align="center" style="padding-left:3px;border-right:1px solid silver">#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</td>		
							
							<cfif Adjustment eq "0" or Memo eq "Threshold Reduction">
							<TD colspan="2" style="padding-right:3px;border-right:1px solid silver" align="right"></TD>	
							<cfelse>
							<td style="background-color:##ffffaf80;padding-left:5px;border-right:0px solid silver">#Memo#:</td>
							<td align="right" style="background-color:##FED7CF80;padding-right:3px;border-right:1px solid silver">#NumberFormat(Adjustment,"__.__")#</td>			
							</cfif>
							<TD style="background-color:##ffffaf80;padding-right:3px;border-right:1px solid silver" align="right">#NumberFormat(Balance+Taken-Credit,"__.__")#</TD>			
							<cfif Credit eq "0">
							<TD  style="background-color:##f1f1f180;padding-right:3px;border-right:1px solid silver" align="right"></TD>		
							<cfelse>
							<td align="right" style="background-color:##C0F1C180;padding-right:3px;border-right:1px solid silver">#NumberFormat(Credit,".__")#</td>			
							</cfif>
							<cfif Taken eq "0">
							<TD style="padding-right:3px;border-right:1px solid silver" align="right"></TD>
							<cfelse>
							<td align="right" style="background-color:##A6D2FF80;padding-right:3px;border-right:1px solid silver">#NumberFormat(Taken,".__")#</td>
							</cfif>
							<TD align="right" style="background-color:##e4e4e480;padding-right:4px;border-right:1px solid silver">#NumberFormat(Balance,".__")#</TD>		
							<cfif qType.leaveAccrual eq "2">
							<td style="padding:2px">							
							<cfif Balance gte "1" and dateEffective lte now() and access eq "ALL">
							<input class="button10s" onclick="balancecorrection('#personNo#','#BalanceId#')" style="font-size:11px;height:16px;width:100px" type="button" name="Distribute" value="Distribute">
							</cfif>
							</td>
							<cfelse>							
							</cfif>
						</tr>				
						<cfset prior = Balance.ContractType>
									
					</cfif>
										
				</cfoutput>
			
			</cfoutput>
			
			</table>	
		</td>
	</tr>

	<cfoutput>
		<tr>
			<td style="display:none;" class="clsPrintContentDetail_#URL.LeaveType#_Printout">
				<table width="100%" class="formpadding">
					<tr><td style="padding-top:100px;">&nbsp;</td></tr>
					<tr>
						<td width="50%">
							<table width="70%" align="center">
								<tr>
									<td style="border-bottom:1px solid ##C0C0C0; padding:10px;">&nbsp;</td>
								</tr>
							</table>
						</td>
						<td>
							<table width="70%" align="center">
								<tr>
									<td style="border-bottom:1px solid ##C0C0C0; padding:10px;">&nbsp;</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<table width="70%" align="center">
								<tr>
									<td align="center">#ucase("#qPerson.FirstName# #qPerson.LastName#")#</td>
								</tr>
							</table>
						</td>
						<td>
							<table width="70%" align="center">
								<tr>
									<td align="center"><cf_tl id="Chief of Section" var="1">#ucase(lt_text)#</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</cfoutput>
	<tr><td style="height:10px"></td></tr>
</table>

<cfset ajaxonload("doHighlight")>

<script>
	Prosis.busy('no')
</script>