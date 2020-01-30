<cfparam name="url.idmenu" default="">

<cf_screentop html="Yes" 
			  label="Accrual record" 
			  height="100%" 
			  layout="webapp" 
			  banner="yellow" 
			  jquery="yes"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">			  

<cfquery name="get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_LeaveType
	WHERE     LeaveType = '#url.id#'
</cfquery>			  

<cfquery name="LeaveType" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_LeaveType
	WHERE     LeaveAccrual = '#get.LeaveAccrual#' 
</cfquery>


<cfquery name="Contract" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ContractType
</cfquery>

<cfinclude template="RecordScript.cfm">
<cf_calendarScript>
<cfajaximport tags="cfform">
<cfdiv id="divNewElement" style="display:none;">

<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
<tr class="hide"><td><iframe name="formTarget" id="formTarget"></iframe></td></tr>
<tr><td>
<cfform action="RecordSubmit.cfm" method="POST" name="dialog" id="dialog" target="formTarget" style="height:100%">

<!--- Entry form --->

<table width="95%" cellspacing="0" cellpadding="0" class="formpadding formspacing" align="center">

    <tr><td height="3"></td></tr>
	
    <TR>
    <td class="labelmedium" width="140">Leavetype:</td>
    <TD>
		<select name="LeaveType" id="LeaveType" class="regularxl">
		   <cfoutput query="LeaveType">
     	   	<option value="#LeaveType.LeaveType#" <cfif URL.ID eq LeaveType.LeaveType>selected</cfif>>#LeaveType.Description#</option>
       	   </cfoutput>	
	    </select>	
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Contract:</TD>
    <TD>
	<select name="ContractType" id="ContractType" class="regularxl">
		   <cfoutput query="Contract">
     	   	  <option value="#Contract.ContractType#">#ContractType# #Description#</option>
       	   </cfoutput>	
	    </select>
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Effective:</TD>
    <TD>
	<cf_intelliCalendarDate9
		FieldName="dateeffective" 
		class="regularxl"
		Default="01/01/2000"
		AllowBlank="No">	
	</TD>
	</TR>
		
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium">Accrual period:</TD>
    <TD class="labelmedium">
	    <INPUT type="radio" name="CreditPeriod" id="CreditPeriod" value="Month" checked onclick="toggleCreditCalculation(this);"> Month 
		<INPUT type="radio" name="CreditPeriod" id="CreditPeriod" value="Contract" onclick="toggleCreditCalculation(this);"> Contract duration
	</TD>
	</TR>
	
	<cfset vCreditDetailBGColor = "FFFEE6">
	<cfset vDisplayCreditCalculation = "">
	<cfset vDisplayCreditEntitlement = "display:none;">
			
	<TR class="clsCreditCalculation" style="<cfoutput>background-color:#vCreditDetailBGColor#; #vDisplayCreditCalculation#</cfoutput>">
    <TD class="labelmedium">Credit UoM:</TD>
    <TD class="labelmedium">
	  <cfif get.LeaveAccrual eq "1">
	  
	  	  <cfinput type="Text"
		           name="CreditFull" 
				   id="CreditFull"
				   value="0" 
				   message="Please enter a credit" 
				   style="text-align: center;" 
				   validate="float" 
				   class="regularxl"
				   required="Yes" 
				   size="5" 
				   maxlength="5">
				   
	  <cfelse>
	      <input type="hidden" name="CreditFull" id="CreditFull" value="0">	   
	  </cfif> 
      <INPUT type="radio" name="CreditUoM" id="CreditUoM" value="Day" checked> Days (default)
	  <INPUT type="radio" name="CreditUoM" id="CreditUoM" value="Hour"> Hours
	  
    </TD>
	</TR>
	
	<cfif get.LeaveAccrual eq "1">
	
		<TR class="clsCreditCalculation" style="<cfoutput>background-color:#vCreditDetailBGColor#; #vDisplayCreditCalculation#</cfoutput>">
	    <TD class="labelmedium">Credit Calculation:</TD>
	     <TD class="labelmedium">
		    <table width="100%">
				<tr class="labelmedium"><td><INPUT type="radio" class="radiol" name="Calculation" id="Calculation" value="Day" checked></td>
				    <td style="padding-left:5px">Pro-rated per day (0.5 days)</td>
				</tr>
				<tr class="labelmedium"><td><INPUT type="radio" class="radiol" name="Calculation" id="Calculation" value="WorkDay"></td>
				    <td style="padding-left:5px">Pro-rated per Work day (0.5 days)</td>
				</tr>
				<tr class="labelmedium"><td><INPUT type="radio" class="radiol" name="Calculation" id="Calculation" value="Formula"></td>
				    <td style="padding-left:5px">UN Formula (2;16)</td>
				</tr>	
			</table>
		</TD>
		</TR>
	
	</cfif>
	
	<TR class="clsCreditEntitlement" style="<cfoutput>#vDisplayCreditEntitlement#</cfoutput>">
    <TD class="labelmedium" valign="top" style="padding-top:5px;">Entitlement:</TD>
    <TD class="labelmedium" valign="top" style="padding-top:3px;">
  	   <cfdiv id="divCreditEntitlement" bind="url:getCreditEntitlement.cfm?leaveType=&contractType=&dateEffective=">
    </TD>
	</TR>
		
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium">Carry Over (max):</TD>
   	
	<TD>
	  <table cellspacing="0" cellpadding="0">
	  <tr>
	   
	   <td>
  	   <cfinput class="regularxl" type="Text" name="CarryOverMaximum" id="CarryOverMaximum" message="Please enter a maximum" style="width:40;text-align: center;" validate="numeric" required="Yes" size="8" maxlength="6">
	   </td>
	   
	   <td style="padding-left:10px" class="labelmedium">Apply on:</td>
	   
	   <td style="padding-left:10px">
	   <cfinput type="Text" class="regularxl" name="CarryOverOnMonth" id="CarryOverOnMonth" range="1,12" value="1" message="Please enter a month No" validate="integer" required="Yes" 
	  			 size="2" maxlength="2" style="text-align: center;">
	   </td>
	   
	   <td style="padding-left:2px" class="labelmedium">=</td>
	   <td style="padding-left:6px" class="labelmedium">
	     <cfdiv bind="url:GetMonth.cfm?mth={CarryOverOnMonth}">
	   </td>
	   </tr>
	   
	   </table>
    </TD>	
  
	</TR>
			
	<TR>
    <TD class="labelmedium">Maximum in Credit Period:</TD>
    <TD class="labelmedium">
  	   <cfinput class="regularxl" type="Text" name="AccumulationPeriod" id="AccumulationPeriod" value="0" message="Please enter a number of months" style="text-align: center;" validate="integer" required="Yes" size="4" maxlength="4">&nbsp;&nbsp;Months
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Maximum in Overall Balance:</TD>
    <TD>
  	   <cfinput class="regularxl" type="Text" name="MaximumBalance" id="MaximumBalance" value="100" message="Please enter a maximum" style="text-align: center;" validate="integer" required="Yes" size="4" maxlength="4">
    </TD>
	</TR>	
	
	<TR>
    <TD class="labelmedium">Advance credits:</TD>
    <TD>
  	   <cfinput class="regularxl" type="Text" name="AdvanceInCredit" id="AdvanceInCredit" value="4" message="Please enter a number" style="width:30;text-align: center;" validate="integer" required="Yes" size="2" maxlength="3">
    </TD>
	</TR>
	
	<tr><td height="1" colspan="2"class="line"></td></tr>	
	<tr>			
	<td align="center" colspan="2" height="30">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value="Save">	
	</td>		
	</tr>
		
</TABLE>

</CFFORM>

</td></tr></table>

<cf_screenbottom layout="innerbox">


