
<cfparam name="Object.ObjectKeyValue4" default="00000000-0000-0000-0000-000000000000">




<cfquery name="get" 
    datasource="AppsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT   *
	FROM     TransactionHeader
	WHERE    TransactionId = '#Object.ObjectKeyValue4#'  
</cfquery>	

<cfquery name="getCalculationPeriod" 
    datasource="AppsPayroll" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT   *
	FROM     SalarySchedulePeriod
	WHERE    CalculationId = '#get.ReferenceId#'   
</cfquery>	

<cfset processed = 0>

<!--- removed as we have an action table now 

<cfloop query="getCalculationPeriod">
	<!--- check if directory exists --->
	<cfset per = dateformat(PayrollEnd,"YYYYMM")>
	<cfif DirectoryExists("#SESSION.rootDocumentPath#\Payslip\#Mission#_#SalarySchedule#\#per#\")>
		<cfset processed = 1>
		<cfbreak>
	</cfif>
</cfloop>

--->
	
<table width="94%" align="center">
	
	<tr>
		<td style="padding-top:25px">&nbsp;</td>
	</tr>

	<cfoutput>
	
	<cfif processed eq 0>
	
		<cfset emailValidation = 0>		
		
		<cfloop query="getCalculationPeriod">
			
				<cfquery name="StaffWithNoEmail" 
				    datasource="AppsPayroll" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					SELECT   P.PersonNo, P.FullName
					FROM     EmployeeSettlement S INNER JOIN
			                 Employee.dbo.Person P ON S.PersonNo = P.PersonNo
					WHERE    Mission        = '#Mission#'
					AND      SalarySchedule = '#SalarySchedule#'
					AND      PaymentDate    = '#PayrollEnd#'	
					AND      ( P.EmailAddress IS NULL OR LEN(P.EmailAddress) < 6 OR CHARINDEX('@',EMailAddress) < 1)
				</cfquery>	
				
				<cfif StaffWithNoEmail.RecordCount gt 0 and emailValidation eq 1>
				
					<tr><td class="labelmedium" align="center" style="color:red;"> <cf_tl id="Payslips cannot be generated because the following staff members are missing eMail address">:</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td>
							<table width="100%">
								<tr class="labelmedium line">
								    <td width="30px">No.</td>
								    <td align="left" width="150px"><cf_tl id="Person Number"></td>
									<td align="left"><cf_tl id="Name"></td>
								</tr>								
								<cfloop query="StaffWithNoEmail">
									<tr class="labelmedium">
										<td align="left">#CurrentRow#</td>
										<td align="left" >#PersonNo#</td>
										<td>#FullName#</td>
									</tr>
								</cfloop>
							</table>
						</td>
					</tr>
				<cfelse>
					<cfset emailValidation = 1>
				</cfif>
				
		</cfloop>
	
		<cfif emailValidation eq 1>
		
		<TR>
			<TD height="30" style="width:95%;height:40px;padding:5px;padding-left:5px;border:1px solid silver;border-radius:5px;" align="center" id="setdocument">	
						
				<cfquery name="MissionSchedule" 
				    datasource="AppsPayroll" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					SELECT   *
					FROM     SalaryScheduleMission
					WHERE    SalarySchedule = '#getCalculationPeriod.SalarySchedule#'   	
					AND      Mission        = '#getCalculationPeriod.Mission#'
				</cfquery>				
			
				<cfif MissionSchedule.DisableMailPayslip eq 0>
			  		<cf_tl id= "Generate and Send Payslip" var="buttonValue">
			  	<cfelse>
			  		<cf_tl id= "Generate Payslip" var="buttonValue">
			  	</cfif>				  			
				
				<input type="button" 
				       id="Send" 
					   name="Send" 
					   value="#buttonValue#" 
					   class="button10g"
				       style="height:28;width:260;border:1px solid silver" 
					   onclick="doPrepare('#Object.ObjectKeyValue4#')">			
	
				<cfset Session.Status = 0>
				
				<cfquery name="Staff" 
				    datasource="AppsPayroll" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					SELECT   P.PersonNo, P.FullName
					FROM     EmployeeSettlement S INNER JOIN
			                 Employee.dbo.Person P ON S.PersonNo = P.PersonNo
					WHERE    Mission        = '#getCalculationPeriod.Mission#'
					AND      SalarySchedule = '#getCalculationPeriod.SalarySchedule#'
					AND      PaymentDate    = '#getCalculationPeriod.PayrollEnd#'						
				</cfquery>	
				
				<cfprogressbar name="pBar" 
					    style="height:40px;bgcolor:silver;progresscolor:black;border:0px" 					
						height="20" 
						bind="cfc:service.Authorization.AuthorizationBatch.getstatus()"				
						interval="#staff.recordcount/2#" 
						autoDisplay="false" 
						width="506"/> 
					   
			</TD>		
		</TR>
		
		</cfif>
	
	<cfelse>
	
		<TR>
			<TD height="30" style="width:95%;height:40px;padding:5px;padding-left:5px;border:1px solid silver; color:red; border-radius:5px;" align="center" id="setdocument">	
				<cf_tl id="It appears that this action has already been performed. Please check with your administrator." class="message">
			</td>
		</tr>
	
	</cfif>
	
	</cfoutput>
	
</table>