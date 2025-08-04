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

<cf_screentop height="100%" html="No" jquery="Yes" scroll="Yes" menuaccess="context">

<cf_CalendarScript>
<cf_dialogPosition>

<cfoutput>

<cfparam name="url.accessmode" default="view">
<cfparam name="url.action" default="0">

<script>
function goback() {
    Prosis.busy('yes')
    ptoken.open("EmployeeEntitlement.cfm?ID=#URL.ID#&systemfunctionid=#url.systemfunctionid#", "_self");
}
</script>

</cfoutput>

<cfquery name="Entitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonEntitlement
	WHERE  PersonNo = '#URL.ID#'
	AND    EntitlementId = '#URL.ID1#'
</cfquery>

<!--- check for active workflow --->  
<cf_wfActive entitycode="EntEntitlement" objectkeyvalue4="#url.id1#">	

<cfparam name="URL.Mode" default="">

<cfif (Entitlement.Status lte "1" or url.accessmode eq "edit") and (url.mode eq "backend" or url.mode eq "Staffing")>

	<cfset accessmode = "edit">

<cfelse>
	
	<cfset accessmode = "view">

</cfif>


<cfquery name="Trigger" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_PayrollTrigger
	WHERE  SalaryTrigger = '#Entitlement.SalaryTrigger#'	
</cfquery>

<cfquery name="TriggerGroup" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_PayrollTriggerGroup
	WHERE  SalaryTrigger = '#Entitlement.SalaryTrigger#'	
</cfquery>

<cfquery name="SalarySchedule" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   SalarySchedule
	WHERE  SalarySchedule IN (SELECT SalarySchedule 
	                          FROM   SalaryScheduleComponent C, Ref_PayrollComponent R
			 				  WHERE  C.ComponentName = R.Code
							  AND    SalaryTrigger = '#Entitlement.SalaryTrigger#')
</cfquery>

<cfform action="EntitlementEditTriggerSubmit.cfm" 
   method="POST" 
   name="EntitlementEdit" 
   onSubmit="return verify(EntitlementEntry.entitlement.value)">

<cfif url.action eq "0">
	
	<table cellpadding="0" cellspacing="0" width="99%" align="center" class="formpadding">

	<tr><td height="10" style="padding-left:7px">	
		  <cfset ctr      = "0">		
	      <cfset openmode = "open"> 
		  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
		 </td>
	</tr>	
	
	</table>
	
</cfif>	

<cfif entitlement.recordcount eq "0">

	   <table width="100%" align="center"><tr><td class="labellarge" width="100%" align="center">
		   <font color="FF0000"><cf_tl id="Record has been removed"></td></tr>
	   </table>
	   
	   <cfquery name="clear" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE  Organization.dbo.OrganizationObject 
			WHERE   ObjectKeyValue4 = '#url.id1#'		
		</cfquery>

<cfelse>


<cfoutput>
	<input type="hidden" name="PersonNo"      value="#URL.ID#"  class="regular">
	<input type="hidden" name="EntitlementId" value="#URL.ID1#" class="regular">
</cfoutput>

	<table width="98%" border="0" align="center" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	 
	 <cfif Entitlement.Status eq "9" or Entitlement.Status eq "8">
		
		<tr><td></td></tr>
		<tr bgcolor="FFFF00"><td style="border:1px solid silver" class="labelmedium2" colspan="3" align="center">Attention, this record is no longer applicable or effective</font></td></tr>

     <cfelse>		
	 
	 	<cfif url.action eq "1">
	 
	 	<tr><td></td></tr>
		<tr><td style="border:1px solid silver" class="labelmedium2" colspan="3" align="center">Attention, this record currently applicable and effective</font></td></tr>
		
		</cfif>
			
	 </cfif>	 	  
	  
	 <tr class="line">
	    <td width="98%" height="28"  style="font-size:28px" valign="middle" class="labellarge">
		
		<cfif url.action eq "1">
				
			    <cf_tl id="Financial entitlement">
		
		<cfelse>
		
			<cfif accessmode eq "edit">
			
				<cfoutput>
			     <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Logos/Payroll/Entitlement.png" height="64" alt=""  border="0" align="absmiddle">
		    	<font color="gray"><cf_tl id="Edit financial entitlement"></b></font>
				</cfoutput>
			
			<cfelse>
			
				<cfoutput>
			     <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Logos/Payroll/Entitlement.png" height="64" alt=""  border="0" align="absmiddle">
		    	<font color="gray">&nbsp;<cf_tl id="Financial entitlement"></b></font>
				</cfoutput>
			
			
			</cfif>
		
		</cfif>
		
	    </td>
	  </tr> 	    
	  	
	  <cfoutput>
	     
	  <tr>
	    <td width="100%">
	    <table width="98%" align="center" class="formpadding">
		
	    <TR><TD style="height:5px"></TD></TR>		
		
		<TR class="labelmedium2">
	    <TD style="min-width:200px"><cf_tl id="Entitlement">:</TD>
	    <TD style="min-width:400px">
		
			<cfif accessmode eq "edit">
		
				 <input type="text" name="SalaryTrigger" style="background-color:e4e4e4" value="#Entitlement.SalaryTrigger#" size="30" maxlength="30" readonly class="regularxxl">		
				 
			<cfelse>
			
				#Trigger.Description#
			
			</cfif>	 
			
			<cfif TriggerGroup.recordcount gte "2">
			
			    <input type="hidden" name="EntitlementGroup" value="#Entitlement.EntitlementGroup#">
			
				/ #Entitlement.EntitlementGroup# 
			
			</cfif>			
	  
		</TD>
		</TR>	
		
		<TR class="labelmedium2">
	    <TD><cf_tl id="Salary schedule">:</TD>
	    <TD>
		
			<cfif accessmode eq "edit">
			
			  	<select name="SalarySchedule" size="1" class="regularxxl">
				<cfloop query="SalarySchedule">
				<option value="#SalarySchedule.SalarySchedule#" <cfif Entitlement.SalarySchedule eq SalarySchedule>selected</cfif>>
		    		#SalarySchedule# #Description#
				</option>
				</cfloop>
			    </select>
				
			<cfelse>
			
				<cfquery name="getSchedule" 
					datasource="AppsPayroll"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   SalarySchedule
						WHERE  SalarySchedule = '#Entitlement.SalarySchedule#'
					</cfquery>
			
				#getSchedule.Description#
			
			</cfif>	
			
		</TD>
		</TR>
		
		 
	 
	    <TR class="labelmedium2">
	    <TD><cf_tl id="Effective date">:</TD>
	    <TD>
		
			<cfif accessmode eq "edit">
		
			  <cf_intelliCalendarDate9
			FormName="EntitlementEdit"
			FieldName="DateEffective" 
			class="regularxxl"
			DateFormat="#APPLICATION.DateFormat#"
			Default="#Dateformat(Entitlement.DateEffective, CLIENT.DateFormatShow)#">	
			
			<cfelse>
			
			<b>#Dateformat(Entitlement.DateEffective, CLIENT.DateFormatShow)#
			
			</cfif>
			
		</TD>
		</TR>
			
		<TR class="labelmedium2">
	    <TD><cf_tl id="Expiration date">:</TD>
	    <TD>
		
			<cfif accessmode eq "edit">
		
			  <cf_intelliCalendarDate9
				FormName   = "EntitlementEdit"
				FieldName  = "DateExpiration" 
				class      = "regularxxl"
				DateFormat = "#APPLICATION.DateFormat#"
				Default    = "#Dateformat(Entitlement.DateExpiration, CLIENT.DateFormatShow)#">	
				
			<cfelse>
			
				<b>#Dateformat(Entitlement.DateExpiration, CLIENT.DateFormatShow)#
			
			</cfif>	
			
		</TD>
		</TR>
				
		<cfif Trigger.enableAmount eq "1">
		
		<TR class="labelmedium2">
		    <TD width="170"><cf_tl id="Start date of reimbursement">:</TD>
		    <TD>
			
			<cfif accessmode eq "edit">
			
				<cfif Entitlement.EntitlementDate neq "">
				
					 <cf_intelliCalendarDate9
						FieldName="EntitlementDate" 					
						Class="regularxxl enterastab"
						DateFormat="#APPLICATION.DateFormat#"
						Default="#Dateformat(Entitlement.EntitlementDate, CLIENT.DateFormatShow)#"
						AllowBlank = "False">	
				
				<cfelse>
				
					  <cf_intelliCalendarDate9
						FieldName="EntitlementDate" 					
						Class="regularxxl enterastab"
						DateFormat="#APPLICATION.DateFormat#"
						Default="#Dateformat(Entitlement.DateEffective, CLIENT.DateFormatShow)#"
						AllowBlank = "False">	
						
				</cfif>		
			
			<cfelse>
			
				<cfif Entitlement.EntitlementDate neq "">
				
					#Dateformat(Entitlement.EntitlementDate, CLIENT.DateFormatShow)#
				
				<cfelse>
				
					#Dateformat(Entitlement.DateEffective, CLIENT.DateFormatShow)#
				
				</cfif>
			
			</cfif>
				
				</td>
			</tr>
		
		<TR id="enableamount" class="labelmedium2">
	    <TD><cf_tl id="Submitted Amount">:</TD>
		
		<cfquery name="Currency" 
			datasource="AppsLedger"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT *
		    FROM Currency
		</cfquery>
	
		<cfif accessmode eq "edit">
	
    	<TD>
	
			<cfset cur = APPLICATION.BaseCurrency>
					
			<table cellspacing="0" cellpadding="0">
			<tr>
			<td>
		
		  	<select name="Currency" size="1" class="regularxxl">
			<cfloop query="Currency">
			<option value="#Currency#" <cfif entitlement.currency eq Currency>selected</cfif>>
	    		#Currency#
			</option>
			</cfloop>
		    </select>
			
			</td>
			
			<td style="padding-left:4px">
			
		    <cfinput type="Text" value="#entitlement.amount#" class="regularxxl"  name="Amount" message="Please enter a correct amount" validate="float" required="Yes" size="12" maxlength="16" style="text-align: center">
			
			</td>
			</tr>
			</table>
			
		</TD>
		
		<cfelse>
		
			<td>#entitlement.currency# #numberformat(entitlement.amount,"_.__")#</td>		
	
		</cfif>
		
		</TR>	
		
		</cfif>		
			
		<TR class="labelmedium2">
	    <TD><cf_tl id="Reference2">:</TD>
	    <TD>
		
			<cfif accessmode eq "edit">
	
			    <input type="text" class="regularxxl" name="documentReference" value="#Entitlement.DocumentReference#" class="regular" size="30" maxlength="30">		
				
			<cfelse>
			
				<b><cfif Entitlement.DocumentReference eq "">--<cfelse>#Entitlement.DocumentReference#</cfif>
			
			</cfif>	
		</TD>
		</TR>
		
		
		<cfif Trigger.SalaryTrigger eq trigger.triggerDependent 
				and Trigger.TriggerCondition eq "Dependent">
		
			<TR class="labelmedium2" id="dependentbox">
		    <TD class="labelmedium2" valign="top" style="padding-top:4px"><cf_tl id="Qualifying dependents">:</TD>
		    <TD>			
					
				<cfif accessmode eq "edit">
				
				<cfquery name="Dependents" 
				datasource="AppsEmployee"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   *
				    FROM     PersonDependent
					WHERE    PersonNo = '#URL.ID#'
					AND      ActionStatus IN ('1','2')			
				</cfquery>
				
				<table>
				<cfloop query = "dependents">		 
					<tr class="labelmedium2 <cfif currentrow lt recordcount>line</cfif>">
						<td>#FirstName# #LastName#</td>						
						<td style="padding-left:6px">#Relationship#</td>
						<td style="padding-left:6px">#dateformat(birthdate,client.dateformatshow)# (#datediff("yyyy",BirthDate,now())#)</td>
						
						<cfquery name="GetPrior" 
						datasource="AppsPayroll"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT   *
						    FROM     PersonDependentEntitlement
							WHERE    PersonNo            = '#URL.ID#'
							AND      DependentId         = '#dependentid#'
							AND      SalaryTrigger       = '#Trigger.SalaryTrigger#'		
							AND      ParentEntitlementId = '#url.id1#'		
							AND      Status != '9'							
						</cfquery>
						
						<cfif getPrior.recordcount gte "1">
						    <td style="padding-left:10px"><input type="checkbox" name="dependents" value="#dependentid#" class="radiol" checked></td>
						<cfelse>
			    			<td style="padding-left:10px"><input type="checkbox" name="dependents" value="#dependentid#" class="radiol"></td>
						</cfif>	
						
					</tr>	
				</cfloop>
				</table>
				
				<cfelse>
				
					<cfquery name="Dependents" 
					datasource="AppsEmployee"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT   *
					    FROM     PersonDependent P
						WHERE    PersonNo = '#URL.ID#'
						AND      ActionStatus IN ('1','2')	
						AND      EXISTS (		
						
								SELECT   'X'
							    FROM     Payroll.dbo.PersonDependentEntitlement
								WHERE    PersonNo            = P.PersonNo
								AND      DependentId         = P.DependentId
								AND      SalaryTrigger       = '#Trigger.SalaryTrigger#'		
								AND      ParentEntitlementId = '#url.id1#'		
								AND      Status != '9'	)	
					</cfquery>
					
					<cfif dependents.recordcount eq "0">
					
						<table><tr><td><cf_tl id="None"></td></tr></table>
					
					</cfif>
					
					<table>
					<cfloop query = "dependents">		 
						<tr class="labelmedium2 <cfif currentrow lt recordcount>line</cfif>">
							<td>#FirstName#</td>
							<td style="padding-left:4px">#LastName#</td>
							<td style="padding-left:4px">#dateformat(birthdate,client.dateformatshow)#</td>
						</tr>
					</cfloop>
					</table>	
				
				</cfif>
			
			</td>
			</tr>
		
		</cfif>
				
		<TR class="labelmedium2">
	        <td valign="top" style="padding-top:4px" width="100"><cf_tl id="Remarks">:</td>
	        <TD>
			
			<cfif accessmode eq "edit">
			
					<textarea class="regular" style="font-size:13px;padding:3px;width:96%" rows="3" name="Remarks">#Entitlement.Remarks#</textarea> 
					
			<cfelse>
			
				<b><cfif Entitlement.Remarks eq "">--<cfelse>#Entitlement.Remarks#</cfif>
			
			</cfif>		
									
			</TD>
		</TR>
					
			<cfif accessmode eq "edit">
			
				<tr><td></td></tr>
					
				<TR><TD align="center" colspan="2" class="line">
							    	
							<script language="JavaScript">
							
								function save() {
								
									if (confirm("Saving will generate a new entitlement which will have to be cleared.\n\nContinue ?"))	{
									return true 
									} else { return false }
								}	
															
							</script>
					
							<table>
							   <tr><td height="30" align="center">
							   
								   <cf_tl id="Back" var="1">
							   	   <input type="button" name="cancel" value="#lt_text#" class="button10g" onClick="goback()">			   
								   </td>
								   <td style="padding-left:1px">
								   <cfif Entitlement.Status eq "2">
								   <cf_tl id="Update" var="1">							   
								   <input class="button10g" type="submit" name="Submit" value="#lt_text#" onclick="return save()">
								   <cfelse>
								   <cf_tl id="Update" var="1">							   							   
								   <input class="button10g" type="submit" name="Submit" value="#lt_text#">
								   </cfif>
								   </td>
								   
							   </tr>
						   </table>
			   
			   </TD></TR>	
		   
		   <cfelse>		
		   
		   		<cfif url.refer neq "Workflow" and url.action neq "1">   		   	
		
					<TR class="line"><TD colspan="2" class="line">					    	
											
							<table width="100%" bgcolor="FFFFFF">
							   <tr><td height="30" align="center">
								   <cf_tl id="Back" var="1">
							   	   <input type="button" name="cancel" value="#lt_text#" class="button10g" onClick="goback()">			   							 							   
							   </td></tr>
						   </table>
				   
				   </TD></TR>	
				   
			   </cfif>
		   
		    </cfif>
			
		</cfoutput>		
	
		<cfquery name="Person" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Person
			WHERE PersonNo = '#URL.ID#' 
		</cfquery>
		
		<cfquery name="OnBoard" 
			  datasource="AppsEmployee" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT TOP 1 *
				FROM      PersonAssignment
				WHERE     PersonNo        = '#URL.ID#' 
				AND       DateEffective  <= '#Dateformat(Entitlement.DateExpiration, CLIENT.DateSQL)#'
				AND       DateExpiration >= '#Dateformat(Entitlement.DateEffective, CLIENT.DateSQL)#'
				AND       AssignmentStatus IN ('0','1') 
				AND       Incumbency = '100'
				OR		 1=1
				ORDER BY  DateExpiration DESC				
		</cfquery>
			
		<cfquery name="Start" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM      PersonAssignment
			WHERE     PersonNo = '#URL.ID#' 
			AND       DateEffective <= '#Dateformat(Entitlement.DateEffective, CLIENT.DateSQL)#'
			AND       DateExpiration >= '#Dateformat(Entitlement.DateEffective, CLIENT.DateSQL)#'
			AND       AssignmentStatus IN ('0','1') 
			ORDER BY  DateExpiration DESC
		</cfquery>
				
		<cfif OnBoard.recordcount eq "0">
		<tr><td colspan="2" class="labelmedium2">
				<font>Problem, no active assignment found for selected entitlement period</font>
			</td>
		</tr>		
		
		<cfelse>
		
		<cfquery name="Start" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM      PersonAssignment
			WHERE     PersonNo = '#URL.ID#' 
			AND       DateEffective <= '#Dateformat(Entitlement.DateEffective, CLIENT.DateSQL)#'
			AND       DateExpiration >= '#Dateformat(Entitlement.DateEffective, CLIENT.DateSQL)#'
			AND       AssignmentStatus IN ('0','1') 
			ORDER BY  DateExpiration DESC
		</cfquery>
		
		<cfif start.recordcount eq "0">
		
		<tr><td colspan="2" class="labelmedium2" align="center">
				<font color="FF0000">Alert : no active assignment found for the effective date of this entitlement</font>
				</td>
		</tr>		
		
		</cfif>
		
		<cfif Entitlement.Status eq "9" and wfStatus eq "Open">
	
			<!--- finish the workflow --->
		
		<cfelse>	
		
			<cfif url.accessmode eq "view">
			
				<cfquery name="currentContract" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    SELECT TOP 1 L.*, 
				           R.Description as ContractDescription, 
					       A.Description as AppointmentDescription
				    FROM   PersonContract L, 
					       Ref_ContractType R,
						   Ref_AppointmentStatus A
					WHERE  L.PersonNo          = '#URL.ID#'
					AND    L.ContractType      = R.ContractType
					AND    L.AppointmentStatus = A.Code
					AND    L.ActionStatus     != '9'
					ORDER BY L.DateEffective DESC 
			 	</cfquery>	
			
				<tr>
					<td colspan="2" class="labelmedium2" align="center">
			
					<cfset link = "Staffing/Application/Employee/Entitlement/EntitlementEditTrigger.cfm?ID=#url.id#&ID1=#Entitlement.EntitlementId#">
			
					<cf_ActionListing 
					    EntityCode       = "EntEntitlement"
						EntityClass      = "Standard"
						EntityGroup      = "Rate"
						EntityStatus     = ""
						Mission			 = "#currentContract.Mission#"		
						OrgUnit          = "#OnBoard.OrgUnit#"
						PersonNo         = "#Person.PersonNo#"
						ObjectReference  = "#Entitlement.SalaryTrigger#"
						ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
					    ObjectKey1       = "#Entitlement.PersonNo#"
						ObjectKey4       = "#Entitlement.EntitlementId#"
						ObjectURL        = "#link#"
						Show             = "Yes"
						CompleteFirst    = "No">
					
					</td>
				</tr>	
				
			  </cfif>	
			
			</cfif>
			
		</cfif>	
		
	</TABLE>
	
	</td>
	</tr>
	
	</table>
	

</cfif>

</CFFORM>
