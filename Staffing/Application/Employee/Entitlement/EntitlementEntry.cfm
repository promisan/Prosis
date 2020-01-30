<cf_screentop height="100%" html="No" scroll="Yes" jquery="Yes" menuaccess="context">

<cf_dialogPosition>
<cf_CalendarScript>
<cfajaximport>

<cfoutput>

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
	
	var effp = ""
	var endp = ""
	
	function checking(){
	
		eff = document.getElementById("DateEffective").value	
		end = document.getElementById("DateExpiration").value		
		ent   = document.getElementById("entitlement").value	
			
		if ((eff != effp || end != endp) && (ent != ""))	{
		effp = eff
		endp = end	
		prior()
		}
		mytimer = setTimeout('checking()', 500);
	}
	
	function prior() {
				
		_cf_loadingtexthtml='';		
		ent = document.getElementById("entitlement").value		
		ptoken.navigate('EntitlementPriorPasstru.cfm?id=#url.id#&trg=&ent='+ent,'exist')	
		 
	}

</script>


</cfoutput>

<cfquery name="defaultSchedule" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   SalarySchedule
	WHERE  SalarySchedule IN (SELECT TOP 1 SalarySchedule 
						      FROM   Employee.dbo.PersonContract
							  WHERE  PersonNo = '#URL.ID#'
							  AND    ActionStatus != '9'
							  ORDER BY Created DESC)
			 
</cfquery>

<cfquery name="Schedules" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT SalarySchedule, PaymentCurrency
    FROM   SalarySchedule
	WHERE  SalarySchedule IN (SELECT SalarySchedule 
						      FROM   Employee.dbo.PersonContract
							  WHERE  PersonNo = '#URL.ID#'
							  AND    ActionStatus != '9')
	UNION
	
	SELECT SalarySchedule, PaymentCurrency
    FROM   SalarySchedule
	WHERE  SalarySchedule IN (SELECT PostSalarySchedule 
						     FROM   Employee.dbo.PersonContractAdjustment
							 WHERE  PersonNo = '#URL.ID#'
							 AND    ActionStatus != '9')						 
</cfquery>

<cfif Schedules.recordcount eq "0">
	
	<cfquery name="Schedules" 
	datasource="AppsPayroll"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT SalarySchedule, PaymentCurrency 
	    FROM   SalarySchedule
	</cfquery>

</cfif>

<cfquery name="Entitlement" 
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
								
	AND   PayrollItem NOT IN (SELECT PayrollItem 
	                          FROM SalaryScheduleComponent) 
							  
	AND   PayrollItem NOT IN (SELECT PayrollItem FROM Ref_PayrollGroupItem WHERE Code = 'Final')						  
	
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
	
	AND   PayrollItem NOT IN (SELECT PayrollItem FROM Ref_PayrollGroupItem WHERE Code = 'Final')
													   					
</cfquery>

<cfquery name="Currency" 
datasource="AppsLedger"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Currency
</cfquery>

<table cellpadding="0" cellspacing="0" width="99%" align="center" class="formpadding">

	<tr><td height="10" style="padding-left:7px">	
		  <cfset ctr      = "0">		
	      <cfset openmode = "open"> 
		  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
		 </td>
	</tr>	
	
</table>

<cf_assignId>

<cfform action="EntitlementEntrySubmit.cfm?Status=#URL.Status#&entitlementId=#rowguid#" method="POST" name="EntitlementEntry" onSubmit="return verify(EntitlementEntry.entitlement.value)">

<table width="96%" align="center" border="0" cellspacing="0" cellpadding="0">
  <tr><td>
	
	<cfoutput>
	<input type="hidden" name="PersonNo" value="#URL.ID#" class="regular">
	</cfoutput>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  
  <tr>
    <td width="100%" style="height:40px;font-size:26px;font-weight:200;"  valign="bottom" align="left" class="labellarge">
	<cfoutput>
	 <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Logos/Payroll/Entitlement.png" height="64" alt=""  border="0" align="absmiddle">
	&nbsp;<cf_tl id="Personal financial entitlement">
	</cfoutput>
    </td>
  </tr> 
  
  <tr><td style="height:3px"></td></tr>	
    
  <tr><td class="line"></td></tr>
  
         
  <tr>
    <td height="100%" width="100%">
	
    <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding formspacing">
	
    <TR><TD height="5"></TD></TR>		
	
	<TR class="labelmedium">
    <TD style="width:20%;padding-left:20"><cf_tl id="Schedule">:</TD>
    <TD>
    	
    	<cfoutput>
		  	<select name="SalarySchedule" size="1" class="regularxl">
				<cfloop query="Schedules">
				<option value="#SalarySchedule#" <cfif SalarySchedule eq DefaultSchedule.SalarySchedule>selected</cfif>>
		    		#SalarySchedule#
				</option>
				</cfloop>
		    </select>
		</cfoutput>
		
	</TD>
	</TR>
  
    <TR class="labelmedium">
    <TD style="padding-left:20"><cf_tl id="Effective">:</TD>
    <TD>
	
		  <cf_intelliCalendarDate9
			FieldName="DateEffective" 
			Scriptdate="prior"
			manual="False"
			class="regularxl"
			Default="#Dateformat(now(), CLIENT.DateFormatShow)#">	
		
	</TD>
	</TR>
	
	<TR class="labelmedium">
    <TD style="padding-left:20"><cf_tl id="Expiration">:</TD>
    <TD>
	
	  <cf_intelliCalendarDate9
			FormName="EntitlementEntry"
			FieldName="DateExpiration" 
			Script="prior"
			Manual="True"
			class="regularxl"
			Default=""
			AllowBlank="TRUE">	
			
	</TD>
	</TR>
	
	<cfquery name="Dependent" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   PersonDependent
			WHERE  PersonNo = '#url.ID#'
			AND    ActionStatus != '9'					
	</cfquery>
							
	<TR class="labelmedium">
	    <TD style="padding-left:20"><cf_tl id="Applies to">:</TD>
		<TD>
		<select name="DependentId" class="regularxl enterastab">
			<option value=""><cf_tl id="Staffmember"></option>
			<cfoutput query="Dependent">
				<option value="#dependentid#">#FirstName# #LastName# [#Gender#] #dateformat(BirthDate,CLIENT.DateFormatShow)#</option>
			</cfoutput>
		</select>	
		</td>
	</tr>		
			
	<TR class="labelmedium">
    <TD style="padding-left:20"><cf_tl id="Payroll Item">:</TD>
    <TD>
	  	<cfselect name="entitlement"
          size="1"
          required="Yes"
          id="entitlement"
          class="regularxl"
		  message="Please select a payroll item"
          onChange="javascript:prior(this.value)">
			<option value=""><cf_tl id="select"></option>
			<cfoutput query="Entitlement">
				<option value="#PayrollItem#">#PayrollItemName#</option>
			</cfoutput>
	    </cfselect>
	</TD>
	</TR>		
	
	<TR class="labelmedium">
    <TD style="padding-left:20"><cf_tl id="Rate">:</TD>
    <TD>
	
		<cfif schedules.paymentCurrency neq "">
           <cfset cur = schedules.paymentCurrency>
		<cfelse>
		   <cfset cur = APPLICATION.BaseCurrency>
		</cfif>
		
		<table cellspacing="0" cellpadding="0"><tr><td>
	
	  	<select name="Currency" size="1" class="regularxl">
		<cfoutput query="Currency">
		<option value="#Currency#" <cfif cur eq Currency>selected</cfif>>
    		#Currency#
		</option>
		</cfoutput>
	    </select>
		
		</td>
		
		<td style="padding-left:4px">
		
	    <cfinput type="Text" 
		   class="regularxl" value="0"  
		   name="Amount" 
		   message="Please enter a correct amount" 
		   validate="float" required="Yes" size="12" maxlength="16" style="text-align: right;padding-right:3px">
		
		</td></tr></table>
			
	</TD>
	</TR>		
	
    <TR class="labelmedium">
    <TD style="padding-left:20"><cf_tl id="Rate application">:</TD>
    <TD>
	
	    <table>
			<tr class="labelmedium">
			<td><INPUT type="radio" class="radiol" name="Period" value="DAY"></td><td style="padding-left:4px">Daily</td>
			<td style="padding-left:8px"><INPUT type="radio" class="radiol" name="Period" value="WORKDAY"></td><td style="padding-left:4px">Daily: workdays only)</td>
			<td style="padding-left:8px"><INPUT type="radio" class="radiol" name="Period" value="MONTHF" checked></td><td style="padding-left:4px">Monthly</td>
			<td style="padding-left:8px"><INPUT type="radio" class="radiol" name="Period" value="MONTH"></td><td style="padding-left:4px">Monthly: contractual days)</td>
			<td style="padding-left:8px"><INPUT type="radio" class="radiol" name="Period" value="MONTHW"></td><td style="padding-left:4px">Monthly: contractual-lwop days</td>
			</tr>
		</table>
		
	</TD>
	</TR>
		
	<TR class="labelmedium">
    <TD style="padding-left:20"><cf_tl id="Source Document">:</TD>
    <TD><input type="text" name="documentReference" class="regularxl" size="20" maxlength="20"></TD>
	</TR>
	
	<TR class="labelmedium">
        <td style="padding-left:20" class="labelmedium" valign="top" style="padding-top:7px"><cf_tl id="Remarks">:</td>
        <TD><textarea rows="3" style="font-size:13px;padding:3px;width:90%" name="Remarks" class="regular"></textarea> </TD>
	</TR>
	
	<cf_filelibraryscript>
	
	<tr>
		<td class="labelmedium"><cf_tl id="Attachment">:</td>
		<td><cfdiv bind="url:EntitlementEntryAttachment.cfm?id=#url.id#&entitlementid=#rowguid#" id="att"></td>			
	</tr>			
	
	
	
	<tr><td colspan="2" height="1" class="line"></td></tr> 
	
	<tr><td colspan="2" id="exist"></td></tr>

	<tr><td colspan="2" align="center" height="30"> 	  
	  <input type="button" name="cancel" value="Back" class="button10g" onClick="history.back()">
	  <input class="button10g" type="submit" name="Submit" value=" Save ">
    </td></tr> 
   
</table>

</td></tr>

</table>

</CFFORM>


<script>
	prior()
</script>
