
<cf_screentop label="" height="100%" scroll="yes" html="No" menuaccess="context">

<cf_calendarScript>

<cfquery name="Bank" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT Max(Code) as Code,Description
    FROM Ref_Bank
	WHERE Operational = 1
	GROUP BY Description
	ORDER BY Description
</cfquery>

<cfquery name="Currency" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Currency
</cfquery>

<cfoutput>

<table width="99%" align="center">

	<tr><td height="10" style="padding-left:7px">	
		  <cfset ctr      = "0">		
	      <cfset openmode = "open"> 
		  <cfinclude template="../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">		  
		 </td>
	</tr>	
	
</table>

<table width="94%" align="center">
<tr><td>

	<table width="100%" align="center">
	
	   <tr>
	    <td width="100%" align="left" class="labellarge" style="padding-left:12px;height:40px;font-size:25px">	
		
		 <table>
		 <tr>
		 <td>
		    <cf_space spaces="20">   
			<img src="#SESSION.root#/Images/BankAccounts.png" height="68" alt=""  border="0" align="absmiddle">			
		 </td>
		 <td height="24" style="padding-left:15px;font-size:27px;padding-top:14px;font-weight:200" class="labelmedium2"><cf_tl id="Register bankaccount"></td>	
	     </tr> 		
		 </table>
		 
		 </td>
	  </tr>	 
	    
	  <tr>
	    <td style="padding-top:6px;padding-left:22px" width="100%">
		
			<cfform action="AccountEntrySubmit.cfm" method="POST" name="accountentry">
			
			<input type="hidden" name="PersonNo" value="#URL.ID#" class="regular">
		
		    <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">
					
		    <TR style="height:40px" class="line">
		    <TD style="width:180px" class="labelmedium2"><cf_tl id="Effective date">:</TD>
		    <TD>	
				<table><tr><td>
				
				  <cf_intelliCalendarDate9
				FieldName="DateEffective" 
				Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
				class="regularxxl enterastab"
				AllowBlank="False">	
				
				</td>
				
				<!---
				
				<TD class="labelmedium2" style="padding-left:20px"><cf_tl id="Expiration date">:</TD>
		        <TD>	
				  <cf_intelliCalendarDate9
				FieldName="DateExpiration" 
				Default=""
				class="regularxxl enterastab"
				AllowBlank="True">	
				
			    </TD>			
				
				--->
				
				</tr>
				</table>
				
			</TD>
			</TR>
							
			<TR>
		    <TD class="labelmedium2" style="height:32px"><cf_tl id="Destination">:</TD>
		    <TD class="labelmedium2">	
				<INPUT type="radio" class="enterastab" name="Destination" value="Personal" checked> <cf_tl id="Personal">
				<INPUT type="radio" class="enterastab" name="Destination" value="Beneficiary"> <cf_tl id="Beneficiary">
				
			</TD>
			</TR>
				
		    <TR>
		    <TD class="labelmedium2"><cf_tl id="Bank name">:</TD>
		   	
		    <TD>
			  	<select name="BankCode" size="1" class="regularxxl enterastab">
				<cfloop query="Bank">
				<option value="#Code#">
		    		#Description#
				</option>
				</cfloop>
			    </select>
			</TD>
			
			</TR>
				
			<TR>
		    <TD class="labelmedium2" style="padding-left:10px;"><cf_tl id="Bank Address">:</TD>
		   	<TD>
			<input type="text" name="BankAddress" style="width:95%" size="40" maxlength="80" class="regularxxl enterastab">
			 </TD>
			
			</TR>
				
			<TR>
		    <TD class="labelmedium2" style="padding-left:10px;"><cf_tl id="Bank Telephone">:</TD>
		   	<TD class="labelmedium2">
			<input type="text" name="BankTelephoneNo" id="BankTelephoneNo" value="" size="10" maxlength="20" class="regularxxl enterastab">
			</TD>
			
			</TR>
				
			<TR>
		    <TD class="labelmedium2" style="height:32px"><cf_tl id="Account type">:</TD>
			<TD class="labelmedium2">
		        <INPUT type="radio" class="enterastab" name="AccountType" value="Checking" checked> <cf_tl id="Checking">
				<INPUT type="radio" class="enterastab" name="AccountType" value="Savings"> <cf_tl id="Savings">
				<INPUT type="radio" class="enterastab" name="AccountType" value="Credit"> <cf_tl id="Credit Card">		
			</TD>
			</TR>
				
			<TR>
		    <TD class="labelmedium2"><cf_tl id="Account Name">:</TD>
		   	<TD>
				<cf_tl id="Please enter account name" var="vAccountMessage" class="message">
				<cfinput type="Text"
			       name="AccountName"
			       message="#vAccountMessage#"
			       required="Yes"
			       visible="Yes"
			       enabled="Yes"
			       size="50"
			       maxlength="80"
			       class="regularxxl enterastab">
			</TD>
			
			</TR>	
				
			<TR>
		    <TD class="labelmedium2"><cf_tl id="Account No">:</TD>
		    <TD>
				 <cf_tl id="You must enter a bank account no" var="vAccountNameMessage" class="message">
				 <cfinput type="Text"
			       name="accountno"
			       message="#vAccountNameMessage#"
			       validate="noblanks"
			       required="Yes"
			       visible="Yes"
			       enabled="Yes"
			       size="20"
			       maxlength="35"
			       class="regularxxl enterastab">
		    </TD>
			
			</TR>
			
			<cf_tl id="You must enter a ABA no" var="vABAMessage" class="message">
				
			<TR>
		    <TD class="labelit" style="padding-left:10px;"><cf_tl id="ABA">:</TD>
		    <TD><cfinput type="text" message="#vABAMessage#" class="regularxxl enterastab" name="AccountABA" validate="noblanks" size="10" maxlength="20"></TD>
			
			</TR>
			
			<cf_tl id="You must enter a SWIFT no" var="vSwiftMessage" class="message">
			
			<TR>
		    <TD class="labelit" style="padding-left:10px;"><cf_tl id="Swift code">:</TD>
		    <TD><cfinput type="text" message="#vSWIFTMessage#" class="regularxxl enterastab" name="SwiftCode" validate="noblanks" size="11" maxlength="11"></TD>
			
			</TR>
			
			<TR>
		    <TD class="labelit" style="padding-left:10px;"><cf_tl id="IBAN">:</TD>
		    <TD class="labelmedium2"><input type="text" class="regularxxl enterastab" value="" name="IBAN" id="IBAN" size="25" maxlength="35"></TD>
			
			</TR>
			
			<TR>
		    <TD class="labelmedium2"><cf_tl id="Account currency">:</TD>
			
			 <TD>
				 	 
			<cfquery name="Schedule" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM SalarySchedule
					WHERE SalarySchedule = '#Contract.SalarySchedule#'
			</cfquery>
				 
			 <select name="AccountCurrency" class="regularxxl enterastab">
			  	<cfloop query="Currency">
				<option value="#Currency#" <cfif currency eq schedule.paymentcurrency>selected</cfif>> #Currency#</option>
				</cfloop>
				</select>
			</TD>
			  
			</TR>

			<tr><td height="8"></td></tr>			
		   	<tr><td height="1" colspan="2" class="line"></td></tr>
		    <tr><td height="5"></td></tr>	

			<TR>
		        <td class="labelmedium2" valign="top" style="padding-top:6px;"><cf_tl id="Pay through">:</td>
		        <TD valign="top" style="padding-top:0px;">
		        	<cf_securediv id="divAccountMission" bind="url:AccountMission.cfm?PersonNo=#url.id#&AccountId=">
		        </TD>
			</TR>
					   
			<TR>
		        <td class="labelmedium2"><cf_tl id="Remarks">:</td>
		        <TD><textarea cols="50" style="padding;3px;font-size:14px;width:95%" class="regular" rows="3" name="Remarks"></textarea> </TD>
			</TR>
			
			<tr><td height="4"></td></tr>
				
			<tr><td height="1" colspan="2" class="line"></td></tr>
		
		   <tr>
		   <td height="35" colspan="2" align="center">
		   
		     <cf_tl id="Cancel" var="vCancel">
			 <cf_tl id="Save" var="vSave">
			 
		     <input type="button" name="cancel" value="#vCancel#" class="button10g" onClick="history.back()">
		     <input class="button10g" type="submit" name="Submit" value="#vSave#">
		   
		   </td>
		   </tr>
		  
		</table>
		
			</CFFORM>
		
		   </td>
		   </tr>
		  
	</table>
	
	</td>
	</tr>
	  
</table>

</cfoutput>


