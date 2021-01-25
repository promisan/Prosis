
<cf_screentop height="100%" jquery="Yes" scroll="No" html="No" menuaccess="context">

<cfoutput>
	
	<script>
	
		_cf_loadingtexthtml='';	
				
	</script>

</cfoutput>

<cf_CalendarScript>
<cf_dialogPosition>

<cfquery name="Currency" 
datasource="AppsLedger"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Currency
</cfquery>

<cfquery name="MissionList" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission IN (SELECT Mission FROM Organization.dbo.Ref_Mission WHERE Operational = 1)
</cfquery>

<cfquery name="SalarySchedule" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  SalarySchedule
	WHERE SalarySchedule IN (SELECT   TOP 1 SalarySchedule 
						     FROM     Employee.dbo.PersonContract
							 WHERE    ActionStatus = '1'
							 AND      PersonNo = '#URL.ID#'
							 ORDER BY Created DESC)
</cfquery>

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
				WHERE  L.PersonNo          = '#url.id#'
				AND    L.ContractType      = R.ContractType
				AND    L.AppointmentStatus = A.Code
				AND    L.ActionStatus     != '9'
				ORDER BY L.DateEffective DESC 
		 	</cfquery>	

<cfquery name="Entitlement" 
datasource="AppsPayroll"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_PayrollItem
	WHERE  Source IN ('Miscellaneous','Deduction')
	ORDER BY Source DESC
	<!---
	AND  PayrollItem IN (SELECT PayrollItem
	                     FROM 	SalarySchedulePayrollItem
						 WHERE  Operational = 1 
						 AND    SalarySchedule IN (SELECT SalarySchedule 
						                           FROM   Employee.dbo.PersonContract
												   WHERE  PersonNo = '#URL.ID#'))	
												   --->
</cfquery>


<cfset openmode = "show">

<cf_divscroll>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
<tr><td>
<cfinclude template="../PersonViewHeaderToggle.cfm">
</td>
</tr>

<tr><td>
  
<cfform action="MiscellaneousEntrySubmit.cfm" method="POST" name="MiscellaneousEntry">

<cfoutput>
   <input type="hidden" name="PersonNo" value="#URL.ID#">
   <input type="hidden" name="IndexNo"  value="#URL.ID1#">
</cfoutput>

<table width="98%" frame="hsides" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="100%" style="font-size:30px;height:50px;font-weight:200" align="left" valign="middle" class="labellarge">
	<cfoutput>	   
    	&nbsp;<cf_tl id="Miscellaneous Payroll entry"></b>
	</cfoutput>	
    </td>
  </tr> 	
  
  <tr><td colspan="1" class="line"></td></tr>
     
  <tr>
    <td width="98%" align="center" style="padding-left:20px">
    <table border="0" cellpadding="0" cellspacing="0" width="97%" align="center" class="formpadding formspacing">
	  
	  <TR class="labelmedium">

	    <TD width="120"><cf_tl id="Entity">:</TD>
    	<TD width="90%">
	
		<table><tr class="labelmedium">
		
		   <td>
	
		    <cfselect name="mission" id="mission"
			  size="1" 
			  message="Select a cost category" 
			  query="MissionList"		 
			  value="Mission" 
			  display="Mission" 
			  selected="#currentcontract.mission#"
			  visible="Yes" enabled="Yes" required="Yes" class="regularxl"/>
		  		  
		  </td>
		  
		  <TD style="padding-left:10px;min-width:120px"><cf_tl id="Cost Category">:</TD>
		  <TD>
			    <cfselect name="entitlement" id="entitlement"
				  size="1" 
				  message="Select a cost category" 
				  query="Entitlement"
				  group="Source" 
				  value="PayrollItem" 
				  display="PayrollItemName" 
				  visible="Yes" enabled="Yes" required="Yes" class="regularxl"/>				
		  </TD>
		  
		  </tr>
		  </table>
				
	</TD>
	</TR>
		
	
	<TR class="labelmedium">
    <TD><cf_tl id="Reference">:</TD>
    <TD><input type="text" name="documentReference" class="regularxl" size="30" maxlength="30"></TD>
	</TR>
	
	<TR class="labelmedium">
    <TD style="width:15%"><cf_tl id="Document date">:</TD>
    <TD>	
		  <cf_intelliCalendarDate9
		FormName="MiscellaneousEntry"
		FieldName="DocumentDate" 
		class="regularxl"
		DateFormat="#APPLICATION.DateFormat#"
		Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
		AllowBlank="False">	
		
	</TD>
	</TR>
		
	<TR class="labelmedium">
    <TD><cf_tl id="Class">:</TD>
    <TD><table>
		<tr class="labelmedium">
		<td><INPUT type="radio" class="radiol" name="EntitlementClass" value="Payment" checked></td><td class="labelmedium" style="padding-left:5px;padding-right:10px"><cf_tl id="Payment">/<cf_tl id="Earning"></td>
		<td><INPUT type="radio" class="radiol" name="EntitlementClass" value="Deduction"></td><td class="labelmedium" style="padding-left:5px;padding-right:10px"><cf_tl id="Deduction">/<cf_tl id="Recovery"></td>		
		<td><INPUT type="radio" class="radiol" name="EntitlementClass" value="Contribution"></td><td class="labelmedium" style="padding-left:5px"><cf_tl id="Contribution"></td>		
		</tr>
		</table>
		
	</TD>
	</TR>
	
    <TR class="labelmedium">
    <TD valign="top" style="padding-top:5px"></TD>
    <TD>	
	
	    <table style="width:610px">
		   <tr class="line labelmedium">
		       <td></td>
		       <td><cf_tl id="Due"></td>			   
			   <td><cf_tl id="Flow"></td>
			   <td><cf_tl id="Payroll"></td>
			   <td><cf_tl id="Currency"></td>
			   <td align="right"><cf_tl id="Amount"></td> 
		  </tr>
		  
		  <cfloop index="itm" from="1" to="12">
		  
		  	<cfoutput>
					  
			   <tr class="labelmedium line">
			   
			   	   <td style="padding-left:4px;padding-right:4px"><cfoutput>#itm#.</cfoutput></td>
				   
				   <td style="min-width:140px;padding-top:2px;padding-left:6px;border-left:1px solid silver;border-right:1px solid silver"> 
				   
				   		<cfif itm eq "1">
				   
				   		<cf_intelliCalendarDate9
							FormName="MiscellaneousEntry"
							FieldName="DateEffective_#itm#"
							style="border:0px"
							class="regularxl enterastab" 
							DateFormat="#APPLICATION.DateFormat#"
							Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
							AllowBlank="False">	
							
						<cfelse>
						
							<cfset dte = dateAdd("m",itm-1,now())>
													
							<cf_intelliCalendarDate9
								FormName="MiscellaneousEntry"
								FieldName="DateEffective_#itm#"
								style="border:0px"
								class="regularxl enterastab" 
								DateFormat="#APPLICATION.DateFormat#"
								Default="#Dateformat(dte, CLIENT.DateFormatShow)#"
								AllowBlank="True">	
						
						
						</cfif>	
						
			       </td>
				   
				   <TD style="min-width:150px">
					   <cfdiv id="entityclass_#itm#"
					    bind="url:getEntityClass.cfm?personno=#url.id#&mission={mission}&entitlement={entitlement}&itm=#itm#">	  		
				   </TD>
				   
				   <td style="min-width:140px;padding-top:2px;padding-left:6px;border-left:1px solid silver;border-right:1px solid silver"> 
				   
				   		<cfif itm eq "1">
				   
				   		<cf_intelliCalendarDate9
							FormName="MiscellaneousEntry"
							FieldName="PayrollStart_#itm#"
							style="border:0px"
							class="regularxl enterastab" 
							DateFormat="#APPLICATION.DateFormat#"
							Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
							AllowBlank="False">	
							
						<cfelse>
						
							<cfset dte = dateAdd("m",itm-1,now())>
													
							<cf_intelliCalendarDate9
								FormName="MiscellaneousEntry"
								FieldName="PayrollStart_#itm#"
								style="border:0px"
								class="regularxl enterastab" 
								DateFormat="#APPLICATION.DateFormat#"
								Default="#Dateformat(dte, CLIENT.DateFormatShow)#"
								AllowBlank="True">	
						
						
						</cfif>	
						
			       </td>
				   
				   <td style="min-width:60px;border-left:1px solid silver;border-right:1px solid silver;padding-right:4px">
				   
						<cfif salaryschedule.paymentCurrency neq "">
				           <cfset cur = salaryschedule.paymentCurrency>
						<cfelse>
						   <cfset cur = APPLICATION.BaseCurrency>
						</cfif>
					
					  	<select name="Currency_#itm#" size="1" class="regularxl enterastab" style="border:0px;width:100%">
						<option value=""></option>
						<cfloop query="Currency">
						<option value="#Currency#" <cfif cur eq Currency>selected</cfif>>
				    		#Currency#
						</option>
						</cfloop>
					    </select>
						
				   </td>
				   <td style="border-left:1px solid silver;border-right:1px solid silver;text-align;min-width:90px">
				   
				   		<cfif itm eq "1">
				   
					       <cfinput type="Text" style="border:0px;text-align:right;padding-right:4px;width:90%" name="Amount_#itm#" 
						    onchange="ptoken.navigate('getActors.cfm?personno=#url.personno#','actor','','','POST','MiscellaneousEntry')"
						    message="Please enter a correct amount" validate="float" required="Yes" size="12" maxlength="16" class="regularxl enterastab">
							
						<cfelse>
						
						   <cfinput type="Text" style="border:0px;text-align:right;padding-right:4px;width:90%" name="Amount_#itm#" 
						   onchange="ptoken.navigate('getActors.cfm?personno=#url.personno#','actor','','','POST','MiscellaneousEntry')"
						    message="Please enter a correct amount" validate="float" required="No" size="12" maxlength="16" class="regularxl enterastab">
												
						</cfif>
		
				   </td> 
				   
				   
			  </tr>
		  
		  	</cfoutput>
			
		  </cfloop>
		   
		 </table>	
		
	</TD>
	</TR>	
	
	<tr id="actors" class="hide">
	   <td valign="top" style="padding-top:8px"><cf_tl id="Authorization by">:</td>
	   <td id="actor"></td>
    </tr>
					   
	<TR class="labelmedium">
        <td valign="top" style="padding-top:5px"><cf_tl id="Remarks">:</td>
        <TD><textarea style="width:99%;padding:3px;font-size:13px" class="regular" rows="2" name="Remarks"></textarea> </TD>
	</TR>
		
	<TR class="labelmedium">
    <TD><cf_tl id="Attachment">:</TD>
    <TD>		
				   	   
	<cf_filelibraryN
		DocumentPath="PersonalCost"
		SubDirectory="#rowguid#" 
		Filter=""
		LoadScript="Yes"
		Insert="yes"
		Remove="yes"
		Listing="yes">
			
	</TD>
	</TR>			
	
   <tr><td colspan="1" height="4"></td></tr>				
   <tr><td height="1" colspan="2" class="line"></td></tr>
   <tr><td colspan="1" height="4"></td></tr>

   <tr><td colspan="2" align="center" height="32">
   <cfoutput>
   <cf_tl id="Cancel" var="1">
   <input type="button" name="cancel" value="#lt_text#" class="button10g" onClick="history.back()">
   <!---
   <cf_tl id="Reset" var="1">   
   <input class="button10g" type="reset"  name="Reset" value=" #lt_text# ">
   --->
   <cf_tl id="Save" var="1">   
   <input class="button10g" type="submit" name="Submit" value=" #lt_text# ">

   
   </cfoutput>
   </td>
   </tr>
   
   </CFFORM>

</table>

</cf_divscroll>


