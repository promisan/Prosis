<cf_screentop height="100%" html="No" scroll="Yes" jquery="Yes" menuaccess="context">

<cfparam name="url.accessmode" default="view">

<cf_dialogPosition>
<cf_CalendarScript>

<script>

function verify(myvalue) { 

	if (myvalue == "") { 

		alert("You did not define an entitlement")
		document.EntitlementEntry.search.focus()
		document.EntitlementEntry.search.select()
		document.EntitlementEntry.search.click()
		return false
		}
	
}		

</script>

<cfquery name="Entitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *, ISNULL(DateExpiration,'12/31/9999') as DateExpirationCorrected
    FROM   PersonEntitlement
	WHERE   EntitlementId = '#URL.ID1#'
</cfquery>

<!--- check for active workflow --->  
<cf_wfActive entitycode="EntEntitlement" objectkeyvalue4="#url.id1#">	

<cfset url.id = Entitlement.personNo>

<cfquery name="SalarySchedule" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT SalarySchedule, PaymentCurrency
    FROM   SalarySchedule
	WHERE  SalarySchedule IN (SELECT SalarySchedule 
						      FROM   Employee.dbo.PersonContract
							  WHERE  PersonNo = '#URL.ID#'
							  AND    ActionStatus != '9') OR  SalarySchedule = '#Entitlement.SalarySchedule#'						  
	UNION
	
	SELECT SalarySchedule, PaymentCurrency
    FROM   SalarySchedule
	WHERE  SalarySchedule IN (SELECT PostSalarySchedule 
						     FROM   Employee.dbo.PersonContractAdjustment
							 WHERE  PersonNo = '#URL.ID#'
							 AND    ActionStatus != '9')						 
</cfquery>


<cfquery name="Currency" 
datasource="AppsLedger"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Currency
</cfquery>

<cfparam name="URL.Mode" default="">
<cfparam name="URL.Action" default="0">

<cfif (Entitlement.Status lte "1" or url.accessmode eq "edit") and (url.mode eq "backend" or url.mode eq "Staffing")>
	<cfset accessmode = "edit">
<cfelse>	
	<cfset accessmode = "view">
</cfif>

<cfform action="EntitlementEditSubmit.cfm" method="POST" name="EntitlementEdit" onSubmit="return verify(EntitlementEntry.entitlement.value)">

<table cellpadding="0" cellspacing="0" width="99%" align="center">

   <cfif url.action eq "0">

		<tr><td height="10" style="padding-left:7px">	
			  <cfset ctr      = "0">		
		      <cfset openmode = "open"> 
			  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
			 </td>
		</tr>	
	
	</cfif>
	
</table>

<table><td height="1"></td></table>

<cfoutput>
	<input type="hidden" name="PersonNo"      value="#URL.ID#">
	<input type="hidden" name="EntitlementId" value="#URL.ID1#">
</cfoutput>

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

 <cfif Entitlement.Status eq "9" or Entitlement.Status eq "8">
		
	<tr bgcolor="FFFF00"><td style="border:1px solid silver" class="labelmedium2" colspan="3" align="center">Attention, this record is no longer applicable or effective</font></td></tr>
	
 <cfelse>
 
	 <cfif url.action eq "1">
	 
	 	<tr><td></td></tr>
		<tr><td style="border:1px solid silver" class="labelmedium2" colspan="3" align="center">Attention, this record currently applicable and effective</font></td></tr>
		
	</cfif>
 				
  </cfif>	

  <cfoutput>
  	
  <tr class="line">
    <td width="100%" height="45" align="left" valign="middle" class="labellarge">
	 <table><tr>
	 <cfif url.action eq "0"><td>
	 <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Logos/Payroll/Entitlement.png" height="56" alt=""  border="0" align="absmiddle">
	 </td>
	 </cfif>
	 <td style="font-size:28px;font-weight:200;padding-left:4px">
	  <cf_tl id="Personal financial entitlement">
	 </td> 
	 </tr></table>
     </td>
  </tr> 	
   
  <tr>
    <td width="100%" style="padding-left:20px">
	
	    <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formspacing formpadding">
		<tr><td height="4"></td></tr>  	
		<TR class="labelmedium2">
	    <TD width="14%"><cf_tl id="Salary schedule">:</TD>
	    <TD width="70%">
		
		    <cfif accessmode eq "edit">
		  	
				<select name="SalarySchedule" size="1" class="regularxxl">
				<cfloop query="SalarySchedule">
				<option value="#SalarySchedule.SalarySchedule#" <cfif Entitlement.SalarySchedule eq "#SalarySchedule.SalarySchedule#">selected</cfif>>
	    			#SalarySchedule.SalarySchedule#
				</option>
				</cfloop>
			    </select>
			
			<cfelse>
				#Entitlement.SalarySchedule#
			</cfif>
			
		</TD>
		</TR>
					
		<TR class="labelmedium2">
	    <TD><cf_tl id="Reference">:</TD>
	    <TD>
	    <cfif accessmode eq "edit">
	    <input type="text" name="documentReference" value="#Entitlement.DocumentReference#" class="regularxxl" size="20" maxlength="20">		
		<cfelse>
		
		<cfif Entitlement.DocumentReference eq "">--<cfelse>#Entitlement.DocumentReference#</cfif>
		
		</cfif>
		</TD>
		</TR>
		
		<TR class="labelmedium2">
	    <TD><cf_tl id="Entitlement">:</TD>
	    <TD height="25">		
		
			<cfquery name="Entit" 
			datasource="AppsPayroll"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM Ref_PayrollItem
				WHERE PayrollItem = '#Entitlement.PayrollItem#'
			</cfquery>
					    
		    <cfif Entitlement.Status neq "0" or accessmode eq "view">
				#Entit.PayrollItemName#
			    <input type="hidden" name="entitlement" value="#Entitlement.PayrollItem#" class="disabled" size="30" maxlength="30" readonly>
		    <cfelse>
				<cfquery name="qEntitlements" 
				datasource="AppsPayroll"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  Ref_PayrollItem
					WHERE PayrollItem IN (SELECT   C.PayrollItem 
					                       FROM    Ref_PayrollComponent C, 
												   Ref_PayrollTrigger E
										   WHERE   C.SalaryTrigger  = E.SalaryTrigger 
											  AND  E.TriggerGroup IN ('Personal'))
												
					AND   PayrollItem NOT IN (SELECT S.PayrollItem 
					                          FROM SalaryScheduleComponent S) 
					AND Source != 'Miscellaneous'							
					
					
					UNION		
														   
					SELECT *
				    FROM  Ref_PayrollItem
					WHERE PayrollItem NOT IN (SELECT S.PayrollItem FROM SalaryScheduleComponent S) 
					
					AND   PayrollItem IN (SELECT PayrollItem
					                      FROM 	 SalarySchedulePayrollItem
										  WHERE  Operational = 1 AND SalarySchedule IN (SELECT SalarySchedule 
															                           FROM   Employee.dbo.PersonContract
																					   WHERE  PersonNo = '#URL.ID#'))	
					AND Source != 'Miscellaneous'												   											   
					
					
																   					
				</cfquery>		    
			    	
			  	<cfselect name="entitlement"
		          size="1"
		          required="Yes"
		          id="entitlement"
		          class="regularxxl"
				  message="Please select a payroll item">
					<cfloop query="qEntitlements">
						<option value="#qEntitlements.PayrollItem#" <cfif qEntitlements.PayrollItem eq Entitlement.PayrollItem>selected</cfif>>#PayrollItemName#</option>
					</cfloop>
			    </cfselect>
		    </cfif>	
		    	
		    			
		
		</TD>
		</TR>	
			
		<TR class="labelmedium2">
	    <TD><cf_tl id="Effective period">:</TD>
	    <TD>
		
		    <cfif accessmode eq "edit">
			
				<table><tr><td>
		
				  <cf_intelliCalendarDate9
				FieldName="DateEffective" 
				class="regularxxl"
				Default="#Dateformat(Entitlement.DateEffective, CLIENT.DateFormatShow)#">	
				
				</td>
				<td style="padding-left:4px;padding-right:4px">-</td>
				<td>
				
				 <cf_intelliCalendarDate9
				FieldName="DateExpiration" 
				class="regularxxl"
				Default="#Dateformat(Entitlement.DateExpiration, CLIENT.DateFormatShow)#">	
				
				</td></tr></table>
			
			<cfelse>
			
				#Dateformat(Entitlement.DateEffective, CLIENT.DateFormatShow)# - <cfif Entitlement.DateExpiration eq "">end of contract<cfelse>#Dateformat(Entitlement.DateExpiration, CLIENT.DateFormatShow)#</cfif>
			
			</cfif>
			
		</TD>
		</TR>
		
		<cfif Entitlement.dependentid neq "">
		
			<cfquery name="Dependent" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   PersonDependent
					WHERE  PersonNo      = '#URL.ID#'
					AND    DependentId   = '#Entitlement.dependentid#'
					AND    ActionStatus != '9'	
			</cfquery>
			
			<cfif dependent.recordcount eq "1">
			
				<input type="hidden" name="DependentId" value="#Entitlement.dependentid#">
						
				<tr class="labelmedium2">
				    <td height="21"><cf_tl id="Applies to">:</TD>
					<td width="80%">
					 #Dependent.FirstName# #Dependent.LastName# #Dependent.Relationship# [#Dependent.Gender#] #dateformat(Dependent.BirthDate,CLIENT.DateFormatShow)#
					</td>
				</tr>		
			
			<cfelse>
			
				<cfquery name="Dependent" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   PersonDependent
						WHERE  PersonNo = '#url.ID#'
						AND    ActionStatus != '9'					
				</cfquery>
										
				<TR class="labelmedium2">
				    <TD style="padding-left:20"><cf_tl id="Applies to">:</TD>
					<TD>
					
					<cfif accessmode eq "edit">
					
					<select name="DependentId" class="regularxxl enterastab">
						<option value=""><cf_tl id="Staffmember"></option>
						<cfloop query="Dependent">
							<option value="#dependentid#">#FirstName# #LastName# [#Gender#] #dateformat(BirthDate,CLIENT.DateFormatShow)#</option>
						</cfloop>
					</select>	
					
					<cfelse>
					
					<cfquery name="Dependent" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   PersonDependent
						WHERE  PersonNo = '#url.ID#'
						AND    DependentId   = '#Entitlement.dependentid#'					
					</cfquery>
					
					<cfif dependent.recordcount eq "0"><cf_tl id="Staffmember"><cfelse>
					#Dependent.FirstName# #Dependent.LastName#
					</cfif>
					
					</cfif>
					</td>
				</tr>		
						
			</cfif>
			
		
		</cfif>
			
		<TR class="labelmedium2">
	    <TD><cf_tl id="Amount">:</TD>
	    <TD>
		
			<cfif accessmode eq "edit">
		
		  	<select name="Currency" size="1" class="regularxxl">
			<cfloop query="Currency">
			<option value="#Currency.Currency#" <cfif Entitlement.Currency eq "#Currency.Currency#">selected</cfif>>
	    		#Currency.Currency#
			</option>
			</cfloop>
		    </select>

		    <cfinput style="text-align:right" class="regularxl" type="Text" name="Amount" value="#Entitlement.Amount#" message="Please enter a correct amount" validate="float" required="Yes" size="8" maxlength="16">
			
			<cfelse>
			
			#Entitlement.Currency# #numberformat(Entitlement.Amount,",.__")#
			
			</cfif>
			
				
		</TD>
		</TR>		
		
	    <TR class="labelmedium2">
	    <TD><cf_tl id="Period">:</TD>
	    <TD>
		
		    <cfif accessmode eq "edit">
			<INPUT type="radio" class="radiol" name="Period" value="DAY"     <cfif Entitlement.Period eq "DAY">checked</cfif>> <cf_tl id="Daily">&nbsp;
			<INPUT type="radio" class="radiol" name="Period" value="WORKDAY" <cfif Entitlement.Period eq "WORKDAY">checked</cfif>> <cf_tl id="Daily (workdays only)">&nbsp;
			<INPUT type="radio" class="radiol" name="Period" value="MONTHF"  <cfif Entitlement.Period eq "MONTHF">checked</cfif>> <cf_tl id="Monthly"> 
			<INPUT type="radio" class="radiol" name="Period" value="MONTH"   <cfif Entitlement.Period eq "MONTH">checked</cfif>> <cf_tl id="Monthly"> (contractual days)
			<INPUT type="radio" class="radiol" name="Period" value="MONTHW"  <cfif Entitlement.Period eq "MONTHW">checked</cfif>> <cf_tl id="Monthly"> (contractual-lwop days)
			<cfelse>
			#Entitlement.Period#
			</cfif>
			
		</TD>
		</TR>
		
		<TR class="labelmedium2">
	        <td valign="top" style="padding-top:4px"><cf_tl id="Remarks">:</td>
	        <TD>
			<cfif accessmode eq "edit">
			<textarea class="regular" style="font-size:14px;padding:3px;width:90%"  rows="4" name="Remarks">#Entitlement.Remarks#</textarea>
			<cfelse>
			<cfif Entitlement.Remarks eq "">--<cfelse>#Entitlement.Remarks#</cfif>
			</cfif>			
			</TD>			
		</TR>
				
		</cfoutput>
		
			<cf_filelibraryscript>
			
			<tr class="labelmedium2">
				<td><cf_tl id="Attachment">:</td>
				<td><cfdiv bind="url:EntitlementEntryAttachment.cfm?id=#url.id#&entitlementid=#URL.ID1#" id="att"></td>			
			</tr>		
		
		<cfif entitlement.contractid eq "">
							
			<cfparam name="URL.Mode" default="">
														
		    <cfif accessmode eq "edit" and (URL.Mode eq "Staffing" or url.mode eq "Backend")>
						
				<tr><td height="35" colspan="2" align="center" class="line">
		
				   <input type="button" name="cancel" value="Back" class="button10g" onClick="history.back()">
				   <input class="button10g" type="submit" name="Submit" value=" Save ">
				   </td>
			   </tr>	   
			  	   
		    <cfelse>
								   
		       <!---
			   <table width="100%" bgcolor="#FFFFFF"><td align="center">
			   <input type="button" name="cancel" value="Back" class="button10g" onClick="history.back()">
			   </td>
			   </table>
			   --->
		    
		   </cfif>
		   
		   <cfif entitlement.status neq "9">
				
			<tr><td colspan="2" class="labelmedium2">
				
				<cfquery name="Person" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     Person
					WHERE    PersonNo = '#URL.ID#' 
				</cfquery>
				
				<cfquery name="OnBoard" 
				  datasource="AppsEmployee" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
					SELECT    TOP 1 *
					FROM      PersonAssignment
					WHERE     PersonNo        = '#URL.ID#' 				
					AND       DateEffective  <= '#Dateformat(Entitlement.DateExpirationCorrected, CLIENT.DateSQL)#'
					AND       DateExpiration >= '#Dateformat(Entitlement.DateEffective, CLIENT.DateSQL)#'
					AND       AssignmentStatus IN ('0','1') 
					AND       Incumbency = '100'
					ORDER BY  DateExpiration DESC				
				</cfquery>

				
								
				<cfif OnBoard.recordcount eq "0">
	
					<tr>
						<td colspan="2" class="labelmedium2" align="center">
						<font>
						<cf_tl id="Problem, no active assignment found for selected entitlement period">
						</font>
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
						AND       DateEffective  <= '#Dateformat(Entitlement.DateEffective, CLIENT.DateSQL)#'
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
																
							<tr>
							<td colspan="2" class="labelmedium2" align="center">
							
							<cfif Entitlement.PayrollItem eq "">
																			
								<cfset link = "Staffing/Application/Employee/Entitlement/EntitlementEditTrigger.cfm?ID=#Entitlement.PersonNo#&ID1=#Entitlement.EntitlementId#">
												
							<cfelse>
													
								<cfset link = "Staffing/Application/Employee/Entitlement/EntitlementEdit.cfm?ID=#Entitlement.PersonNo#&ID1=#Entitlement.EntitlementId#">
							
							</cfif>
						
							<cf_ActionListing 
							    EntityCode       = "EntEntitlement"
								EntityClass      = "Standard"
								EntityGroup      = "Individual"
								EntityStatus     = ""
								OrgUnit          = "#OnBoard.OrgUnit#" 
								PersonNo         = "#Person.PersonNo#"
								ObjectReference  = "#Entitlement.PayrollItem#"
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
				 	
			 </td>
			 </tr>
			 
			 </cfif>
			 
		 </cfif>
	
	</TABLE>
</td>
</tr>
 
</table>

</CFFORM>
