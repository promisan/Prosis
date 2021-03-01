
<cfparam name="url.idmenu" default="">

<cf_screentop html="Yes" 
	  label="Accrual Record" 
	  height="100%" 
	  layout="webapp" 
	  banner="gray" 
	  menuAccess="Yes" 
	  scroll="no"
	  jquery="yes"
	  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_LeaveTypeCredit
	WHERE  CreditId = '#URL.ID1#'
</cfquery>	  

<cfquery name="getLeave" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_LeaveType
	WHERE     LeaveType = '#get.LeaveType#'
</cfquery>	  

<cfquery name="LeaveType" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_LeaveType
	WHERE  LeaveAccrual = '#getLeave.LeaveAccrual#'    
</cfquery>

<cfquery name="Contract" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ContractType
</cfquery>
 
<cfinclude template="RecordScript.cfm">
<cf_calendarScript>
<cfajaximport tags="cfform">


<table width="96%" height="100%" align="center" class="formpadding formspacing">

<cfdiv id="divNewElement" style="display:none;">

<tr class="hide"><td><iframe name="formTarget" id="formTarget"></iframe></td></tr>

<tr><td>

<cf_divscroll>

	<cfform action="RecordSubmit.cfm" method="POST" name="dialog" id="dialog" target="formTarget" style="height:98%">
	
	<cfoutput>
		<input type="hidden" name="CreditId" id="CreditId" value="#get.CreditId#" size="20" maxlength="20"class="regular">
	</cfoutput>
	
	<!--- edit form --->
	
	<table width="95%" align="center" class="formpadding formspacing">
	
		<tr><td height="4"></td></tr>
	    <TR class="labelmedium2">
	    <td width="120"><cf_tl id="Leave Type">:</td>
	    <TD>
		
		    <select name="LeaveType" id="LeaveType" class="regularxxl">
			   <cfoutput query="LeaveType">
	     	   	<option value="#LeaveType.LeaveType#" <cfif Get.LeaveType eq LeaveType.LeaveType>selected</cfif>>#LeaveType.Description#</option>
	       	   </cfoutput>	
		    </select>
		
		    </TD>
		</TR>
			
		<TR class="labelmedium2">
	    <TD><cf_tl id="Applies to Contract">:</TD>
	    <TD>
		    <select name="ContractType" id="ContractType" class="regularxxl">
			   <cfoutput query="Contract">
	     	   	<option value="#Contract.ContractType#" <cfif Get.ContractType eq Contract.ContractType>selected</cfif>>#Description# [#ContractType#]</option>
	       	   </cfoutput>	
		    </select>
		</TD>
		</TR>
		
		
		
		<TR class="labelmedium2">
	    <TD>Effective:</TD>
	    <TD>
		
			<cf_intelliCalendarDate9
				FieldName="dateeffective" 
				class="regularxxl"
				Default="#DateFormat(Get.DateEffective, CLIENT.DateFormatShow)#"
				AllowBlank="No">	
			
		</TD>
		</TR>
		
		<tr class="line"><td colspan="2"></td></tr>
			
		<TR class="labelmedium2">
	    <TD>Accrual period:</TD>
	    <TD>
		    <INPUT type="radio" class="radiol" name="CreditPeriod" id="CreditPeriod" value="Month" <cfif Get.CreditPeriod eq "Month">checked</cfif> onclick="toggleCreditCalculation(this);"> Month 
			<INPUT type="radio" class="radiol" name="CreditPeriod" id="CreditPeriod" value="Contract" <cfif Get.CreditPeriod eq "Contract">checked</cfif> onclick="toggleCreditCalculation(this);"> Contract
		</TD>
		</TR>
		
		<cfset vCreditDetailBGColor = "FFFEE6">
		<cfset vDisplayCreditCalculation = "">
		<cfset vDisplayCreditEntitlement = "display:none;">
		<cfif get.CreditPeriod eq "Contract">
			<cfset vDisplayCreditCalculation = "display:none;">
			<cfset vDisplayCreditEntitlement = "">
		</cfif>
		
		<TR class="labelmedium2 clsCreditCalculation" style="<cfoutput>background-color:#vCreditDetailBGColor#; #vDisplayCreditCalculation#</cfoutput>">
	    <TD style="padding-left:10px">Credit:</TD>
	    <TD>
		
		   <cfif getLeave.LeaveAccrual eq "1">
		  
		  	  <cfinput type      = "Text"
			           name      = "CreditFull" 
					   id        = "CreditFull"
					   value     = "#Get.CreditFull#" 
					   message   = "Please enter a credit" 
					   style     = "text-align: center;width:50;" 
					   validate  = "float" 
					   class     = "regularxxl"
					   required  = "Yes" 
					   size      = "5" 
					   maxlength = "5">
					   
		   <cfelse>
		   
		      <input type="hidden" name="CreditFull" id="CreditFull" value="0">	   
			  
		   </cfif> 
		   
	  	   <INPUT type="radio" class="radiol" name="CreditUoM" id="CreditUoM" value="Day"  <cfif Get.CreditUoM eq "Day">checked</cfif>> days (default)
		   <INPUT type="radio" class="radiol" name="CreditUoM" id="CreditUoM" value="Hour" <cfif Get.CreditUoM eq "Hour">checked</cfif>> hours
		   
	    </TD>
		</TR>
		
		<cfif getLeave.LeaveAccrual eq "1">
				
			<TR class="labelmedium2 clsCreditCalculation" style="<cfoutput>background-color:#vCreditDetailBGColor#; #vDisplayCreditCalculation#</cfoutput>">
		    <TD valign="top" style="padding-top:5px;padding-left:10px">Credit Calculation:</TD>
		    <TD valign="top" style="padding-top:3px;">
			    <table width="100%">
					<tr class="labelmedium2"><td><INPUT type="radio" class="radiol" name="Calculation" id="Calculation" value="Day" <cfif Get.Calculation eq "Day">checked</cfif>></td>
					    <td style="padding-left:5px">Pro-rated per day (0.5 days)</td>
					</tr>
					<tr class="labelmedium2"><td><INPUT type="radio" class="radiol" name="Calculation" id="Calculation" value="WorkDay" <cfif Get.Calculation eq "WorkDay">checked</cfif>></td>
					    <td style="padding-left:5px">Pro-rated per Work day (0.5 days)</td>
					</tr>
					<tr class="labelmedium2"><td><INPUT type="radio" class="radiol" name="Calculation" id="Calculation" value="Formula" <cfif Get.Calculation eq "Formula">checked</cfif>></td>
					    <td style="padding-left:5px">UN Formula (2;16)</td>
					</tr>	
				</table>
			</TD>
			</TR>
		
		</cfif>
		
		<TR class="labelmedium2 clsCreditEntitlement" style="<cfoutput>#vDisplayCreditEntitlement#</cfoutput>">
	    <TD valign="top" style="padding-top:5px;">Entitlement:</TD>
	    <TD valign="top" style="padding-top:3px;">
	  	   <cf_securediv id="divCreditEntitlement" 
		     bind="url:getCreditEntitlement.cfm?leaveType=#get.leavetype#&contractType=#get.contracttype#&dateEffective=#get.DateEffective#">
	    </TD>
		</TR>
				
		<TR class="labelmedium2">
	    <TD>Annual carry over (max):</TD>
	    <TD>
		  <table>
		   <tr>
		   <td>
	  	   <cfinput class="regularxxl" type="Text" name="CarryOverMaximum" id="CarryOverMaximum" value="#Get.CarryOverMaximum#" message="Please enter a maximum" style="width:40;text-align: center;" validate="numeric" required="Yes" size="8" maxlength="3">
		   </td>
		   <td style="padding-left:10px" class="labelmedium2">apply per:</td>
		   <td style="padding-left:10px">
		   <cfinput class="regularxxl" type="Text"  name="CarryOverOnMonth" id="CarryOverOnMonth" value="#Get.CarryOverOnMonth#" range="0,12" message="Please enter a month No" validate="integer" required="Yes" 
		   size="4" maxlength="4" style="width:40px;text-align: center;">
		   </td>
		   <td class="labelmedium2">=</td>
		   <td style="padding-left:6px" class="labelmedium2">
		     <cfdiv bind="url:GetMonth.cfm?mth={CarryOverOnMonth}">
		   </td>
		   </tr>
		   </table>
	    </TD>
		</TR>
			
		<TR class="labelmedium2">
	    <TD>Maximum in Credit Period (Use of overtime):</TD>
	    <TD>
	  	   <cfinput type="Text" class="regularxxl" name="AccumulationPeriod" id="AccumulationPeriod" value="#Get.AccumulationPeriod#" message="Please enter a number of months" style="width:40px;text-align: center;" validate="integer" required="Yes" maxlength="2">&nbsp;&nbsp;Months
	    </TD>
		</TR>
			
		<TR class="labelmedium2">
	    <TD>Maximum balance allowed:</TD>
	    <TD>
	  	   <cfinput type="Text" class="regularxxl" name="MaximumBalance" id="MaximumBalance" value="#Get.MaximumBalance#" message="Please enter a maximum" style="width:40px;text-align: center;" validate="integer" required="Yes" size="4" maxlength="4">
	    </TD>
		</TR>
			
		<TR class="clsCreditCalculation <cfif get.CreditPeriod eq 'Contract'>hide</cfif> labelmedium2">
	    <TD>Overdraw in months:</TD>
	    <TD>
	  	   <cfinput type="Text" class="regularxxl" name="AdvanceInCredit" id="AdvanceInCredit" value="#Get.AdvanceInCredit#" message="Please enter a number" style="width:40px;text-align: center;" validate="integer" required="Yes" size="3" maxlength="2">
	    </TD>
		</TR>
			
		<tr><td height="1" colspan="2" class="line"></td></tr>
		<tr><td colspan="2" align="center" height="30">	
		<input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()">
		<input class="button10g" type="submit" name="Update" id="Update" value="Update">
		</td></tr>
						
	</table>
	
	</CFFORM>

</cf_divscroll>

</td>
</tr>

</TABLE>
