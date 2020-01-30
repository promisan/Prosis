<cfquery name="Get"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Ref_PayrollItem
	WHERE 	PayrollItem = '#URL.ID1#'
</cfquery>

<cfquery name="Param"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	*
	FROM 	Parameter	
</cfquery>

<cfquery name="Schedule"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	M.*, S.Description
	FROM 	SalaryScheduleMission M INNER JOIN SalarySchedule S ON S.SalarySchedule = M.SalarySchedule
	WHERE   Operational = 1
	ORDER BY Mission, S.ListingOrder
</cfquery>

<cfform method="POST" id="formschedule" name="formschedule" onsubmit="return false">

<table width="95%" align="center" class="formspacing">

		<tr><td id="processaccount" class="hide"></td></tr>
				
		<input type="hidden" id="PayrollItem" name="PayrollItem" value="<cfoutput>#get.PayrollItem#</cfoutput>">			
		
		<cfquery name="ObjectList" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM Ref_Object				
		</cfquery>
			
		<cfset row = 0>
	
		<cfoutput query="Schedule" group="Mission">
		
		<tr class="line"><td class="labelmedium" style="font-weight:200;padding-top:13px;font-size:26px" colspan="6">#Mission#</td></tr>
		
		<cfoutput>
		
			<cfset row = row + 1>
			
			<cfquery name="Check"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT 	*
				FROM 	SalarySchedulePayrollItem
				WHERE 	Mission       = '#Mission#'
				AND  	SalarySchedule = '#SalarySchedule#'
				AND 	PayrollItem     = '#get.PayrollItem#'
			</cfquery>
				
			<input type="hidden" id="missionselect_#row#" name="missionselect_#row#" value="#mission#">
										
			<tr>
				<td colspan="6">
					<table width="100%" cellspacing="0" cellpadding="0">
					<tr><td class="labelmedium" style="font-weight:200;height:50px;padding-top:13px;font-size:26px">#Description# <font size="2">#SalarySchedule#</font>
					</td><td align="right" valign="bottom" class="labelmedium" style="padding-bottom:3px;font-weight:200;">			
						<cf_UItooltip tooltip="Allow this element to be selected as a direct manual entry per employee for the following schedules"><cf_tl id="Operational">:</cf_UItooltip>
				  		<input type="checkbox" id="scheduleselect_#row#" class="radiol" name="scheduleselect_#row#" <cfif check.operational eq "1">checked</cfif>>&nbsp;
						</td>
					</tr>
					</table>
				</td>
			</tr>	
			
			<cfquery name="Account" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_Account
				WHERE  GLAccount = '#Check.GLAccount#'
						
			</cfquery>
			
			<cfquery name="AccountLiability" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_Account
				WHERE  GLAccount = '#Check.GLAccountLiability#'
						
			</cfquery>
												
			<tr class="labelmedium">
							    						
				<td style="padding-left:10px" width="100"><cf_tl id="Ledger Cost">:</td>
				
				<td><table>							
					
					<tr>
					<td style="padding-left:1px">				    
						<input type="text" id="glaccount_#row#" name="glaccount_#row#" size="11" value="#Check.GLAccount#"  class="regularxl" readonly style="background-color:ffffcf;width:100;padding-left:4px">
					</td>
					<td style="padding-left:2px">	
					    <input type="text" id="glaccountname_#row#" name="glaccountname_#row#"  value="#Account.Description#" class="regularxl" size="40" readonly style="background-color:ffffcf;width:100%;padding-left:4px">						
				    </td>
					
					<td style="padding-left:14px">					
						<cf_img icon="edit" onClick="selectaccountgl('#Mission#','glaccount','','','applyaccount','#row#')">						  
					</td>
					
					<td style="padding-left:5px;padding-right:5px">					
						<cf_img icon="delete" onClick="removeAccount('#row#');">
					</td>	
					</tr>
					
					</table>
					</td>				
								 						
					<td style="padding-left:7px" width="100"><cf_tl id="Liability">:</td>
					
					<td><table>
						<tr>
													
						<td style="padding-left:1px">				    
							<input type="text" id="glaccountliability_#row#" name="glaccountliability_#row#" size="11" value="#Check.GLAccountLiability#"  class="regularxl" readonly style="background-color:ffffcf;width:102;padding-left:4px">
						</td>
						<td style="padding-left:2px">	
							<input type="text" id="glaccountliabilityname_#row#" name="glaccountliabilityname_#row#"  value="#AccountLiability.Description#" class="regularxl" readonly style="background-color:ffffcf;width:228;padding-left:4px">
						</td>
						
						<td style="padding-left:14px">						
							<cf_img icon="edit" onClick="selectaccountgl('#Mission#','glaccountliability','','','applyaccount','#row#')">									  
						</td>
							
						<td style="padding-left:4px;padding-right:5px">						
							<cf_img icon="delete" onClick="removeLiability('#row#');">								
						</td>									
						</tr>
						</table>
					</td>		
								
			</tr>
			
			<cfif Param.PostingMode eq "1">
			
				<!--- show by parent --->
				
				<cfquery name="getParent" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Employee.dbo.Ref_PostGradeParent		
					WHERE  Code IN (SELECT P.PostGradeParent
									FROM   SalaryScheduleServiceLevel AS L INNER JOIN Employee.dbo.Ref_PostGrade AS P ON L.ServiceLevel = P.PostGrade
									WHERE  L.SalarySchedule = '#Schedule.SalarySchedule#')
													
				</cfquery>
			
				<cfloop query="getParent">
				
				<cfquery name="CheckMe"
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT 	*
					FROM 	SalarySchedulePayrollItemParent
					WHERE 	Mission          = '#Schedule.Mission#'
					AND  	SalarySchedule   = '#Schedule.SalarySchedule#'
					AND 	PayrollItem      = '#get.PayrollItem#'
					AND     PostGradeParent  = '#Code#'
				</cfquery>
					
				<cfquery name="Account" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_Account
					WHERE  GLAccount = '#CheckMe.GLAccount#'
							
				</cfquery>
				
				<tr style="height:14px">
				
				<td class="labelmedium" style="padding-top:5px;padding-left:20px">#schedule.mission# #Code#</td>
				
				<td><table>							
						
						 <td style="padding-left:1px">				    
							<input type="text" id="glaccount_#row#_#currentrow#" name="glaccount_#row#_#currentrow#" size="11" value="#CheckMe.GLAccount#"  class="regularxl" readonly style="width:100;padding-left:4px">
						 </td>
						 <td style="padding-left:2px">	
						    <input type="text" id="glaccountname_#row#_#currentrow#" name="glaccountname_#row#_#currentrow#"  value="#Account.Description#" class="regularxl" size="40" readonly style="width:100%;padding-left:4px">						
					    </td>
						
						<td style="padding-left:14px">						
							<cf_img icon="edit" onClick="selectaccountgl('#schedule.Mission#','glaccount','','','applyaccount','#row#_#currentrow#')">														  
						 </td>
						
						<td style="padding-left:4px;padding-right:5px">						
							<cf_img icon="delete" onClick="removeAccount('#row#_#currentrow#');">													
						</td>	
						
						</table>
						</td>
				
				</tr>
				</cfloop>
				
			<cfelseif Param.PostingMode eq "2">	
						
				<!--- show by class --->
				
				<cfquery name="getClass" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Employee.dbo.Ref_PostClass
					WHERE  PostClass IN (SELECT DISTINCT PostClass 
					                     FROM   Employee.dbo.Position 
										 WHERE  Mission = '#Schedule.Mission#')																		
				</cfquery>
			
				<cfloop query="getClass">
				
				<cfquery name="CheckMe"
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT 	*
					FROM 	SalarySchedulePayrollItemClass
					WHERE 	Mission          = '#Schedule.Mission#'
					AND  	SalarySchedule   = '#Schedule.SalarySchedule#'
					AND 	PayrollItem      = '#get.PayrollItem#'
					AND     PostClass        = '#PostClass#'
				</cfquery>
					
				<cfquery name="Account" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_Account
					WHERE  GLAccount = '#CheckMe.GLAccount#'							
				</cfquery>
				
				<tr style="height:10px" class="labelit">
				
				<td style="padding-left:30px">#PostClass#:</td>
				
				<td><table>							
					 <tr>
						 <td style="padding-left:1px">				    
							<input type="text" id="glaccount_#row#_#currentrow#" name="glaccount_#row#_#currentrow#" size="11" value="#CheckMe.GLAccount#"  class="regularh" readonly style="width:100;padding-left:4px">
						 </td>
						 <td style="padding-left:2px">	
						    <input type="text" id="glaccountname_#row#_#currentrow#" name="glaccountname_#row#_#currentrow#"  value="#Account.Description#" class="regularh" size="40" readonly style="width:100%;padding-left:4px">						
					    </td>
						
						<td style="padding-left:14px">						
							<cf_img icon="edit" onClick="selectaccountgl('#schedule.Mission#','glaccount','','','applyaccount','#row#_#currentrow#')">														  
						 </td>
						
						<td style="padding-left:4px;padding-right:5px">						
							<cf_img icon="delete" onClick="removeAccount('#row#_#currentrow#');">													
						</td>	
					</tr>
					</table>
				</td>
				
				<cfquery name="Account" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_Account
					WHERE  GLAccount = '#CheckMe.GLAccountLiability#'							
				</cfquery>
				
				<td style="padding-left:30px">#PostClass#:</td>
				<td>
					<table>							
						<tr>
						<td style="padding-left:1px">				    
							<input type="text" id="glaccountliability_#row#_#currentrow#" name="glaccountliability_#row#_#currentrow#" size="11" value="#CheckMe.GLAccountLiability#"  class="regularh" readonly style="width:100;padding-left:4px">
						</td>
						<td style="padding-left:2px">	
						    <input type="text" id="glaccountliabilityname_#row#_#currentrow#" name="glaccountliabilityname_#row#_#currentrow#"  value="#Account.Description#" class="regularh" size="40" readonly style="width:100%;padding-left:4px">						
					    </td>
						
						<td style="padding-left:14px">						
							<cf_img icon="edit" onClick="selectaccountgl('#schedule.Mission#','glaccountliability','','','applyaccount','#row#_#currentrow#')">														  
						</td>
						
						<td style="padding-left:4px;padding-right:5px">						
							<cf_img icon="delete" onClick="removeLiability('#row#_#currentrow#');">													
						</td>	
						</tr>
					</table>				
				</td>			
				</tr>
				
				</cfloop>			
			
			</cfif>
						
			<tr class="labelmedium line hide" style="height:30px">
							   		
				<td style="padding-left:3px" width="100"><cf_tl id="Budget Object">:</td>
				<td>
					 <select name="objectcode_#row#" id="objectcode_#row#" class="regularxl" style="width:320">
					      <option value=""></option>
					      <cfloop query="ObjectList">
						     <option value="#Code#" <cfif Check.ObjectCode eq Code> SELECTED</cfif>>
							 #Code# #Description#
							 </option>
						   </cfloop>
			 	    </select>
				</td>
				<td style="padding-left:6px" width="100"><cf_tl id="Item Master">:</td>
				<td colspan="3">
					<cfdiv bind="url:ItemMaster.cfm?row=#row#&mission=#mission#&schedule=#salaryschedule#&item=#get.PayrollItem#&object={objectcode_#row#}" 
				  		id="master_#row#">				
				</td>				
												
			</tr>			
							
		</cfoutput>
		
	</cfoutput>	
		
	<TR>
	<tr><td height="5"></td></tr>
	<tr><td colspan="6" class="line"></td></tr>
	<tr><td height="5"></td></tr>
	<tr>
		<td colspan="6" align="center" height="30">
   			<input class="button10g" style="width:250px" type="button" name="Insert" value="Save" onclick="validate()">
		</td>
	</tr>
		
</table>

</cfform>