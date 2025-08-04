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

<cf_screentop height="100%" jquery="Yes" scroll="Yes" html="No">

<cf_calendarscript>

<cfquery name="CurrencyList" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Currency
</cfquery>

<cfquery name="Threshold" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM OrganizationThreshold
	WHERE ThresholdId = '#URL.ID#'
</cfquery>

<cfset url.id = threshold.orgunit>

<cfinclude template="../UnitView/UnitViewHeader.cfm">
 
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
  <tr><td>

<cfform action="ThresholdEditSubmit.cfm" method="POST" name="accountedit">

<cfoutput query = "Threshold">

<input type="hidden" name="OrgUnit"     id="OrgUnit"     value="#OrgUnit#">
<input type="hidden" name="ThresholdId" id="ThresholdId" value="#ThresholdId#">

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="100%" style="font-size:22px;height:45px;padding-left:6px" align="left" class="labellarge">
	   	 <cf_tl id="Update Threshold"></font>
	 </td>
  </tr> 	
  
  <tr><td class="linedotted"  colspan="1"></td></tr>
  
 <tr>
    <td width="100%" style="padding:8px">
	    <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">
						
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Threshold type">:</TD>
		<TD class="labelmedium">
	        <INPUT type="radio" class="enterastab" disabled name="ThresholdType" id="ThresholdType" value="Payable" <cfif ThresholdType eq "Payable">checked</cfif>> <cf_tl id="Payable">
			<INPUT type="radio" class="enterastab" disabled name="ThresholdType" id="ThresholdType" value="Receivable" <cfif ThresholdType eq "Receiable">checked</cfif>> <cf_tl id="Receivable">:
		</TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium" width="140"><cf_tl id="Effective date">:</TD>
	    <TD>	
			  <cf_intelliCalendarDate9
				FieldName="DateEffective" 
				Default="#Dateformat(DateEffective, CLIENT.DateFormatShow)#"
				AllowBlank="False" class="regularxl enterastab">			
		</TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Currency">:</TD>	
		<TD>
				 
		 <select name="Currency" id="Currency" class="regularxl enterastab">
		  	<cfloop query="CurrencyList">
			<option value="#Currency#" <cfif currency eq Threshold.Currency>selected</cfif>> #Currency#</option>
			</cfloop>
		 </select>
		 
		</TD>	  
		</TR>
		
		<TR>
	    <TD class="labelmedium"><cf_tl id="Amount">:</TD>
	   	<TD>
			<cf_tl id="Amount" var="vEnterName" class="message">
			
			<cfinput type="Text"
		       name="AmountThreshold"
			   value="#AmountThreshold#"
		       message="#vEnterName#"
			   validate="float"
		       required="Yes"
		       visible="Yes"
		       enabled="Yes"
		       size="10"
			   style="text-align:right"
		       maxlength="10"
		       class="regularxl enterastab">
		</TD>
		
		</TR>
			
		<TR>
	    <TD class="labelmedium"><cf_tl id="Memo">:</TD>
	   	<TD>
			<cf_tl id="Memo" var="vEnterName" class="message">
			
			<cfinput type="Text"
		       name="Memo"
		       message="#vEnterName#"
			   value="#Memo#"
		       required="No"
		       visible="Yes"
		       enabled="Yes"
		       size="80"
		       maxlength="80"
		       class="regularxl enterastab">
		</TD>
		
		</TR>
		
		</cfoutput>
				
	   <tr><td height="1" colspan="2" class="linedotted"></td></tr>
	
	   <tr> 
	   	  <td height="23" align="center" colspan="2">
		  	<cfoutput>
				<cf_tl id="Reset" var="vReset">
				<cf_tl id="Back" var="vCancel">
				<cf_tl id="Save" var="vSave">
				
			   	<input class="button10g" type="reset"  name="Reset" id="reset" value=" #vReset# ">
	    		<input type="button" 	 name="cancel" id="cancel" value="#vCancel#" class="button10g" onClick="history.back()">
			    <input class="button10g" type="submit" name="Submit" id="Submit" value="#vSave#" >
			</cfoutput>
	     </td>
	   </tr>
	 	
	</table>
	
	 </td>
	   </tr>
	 	
	</table>
		  
  </CFFORM>
  
   </td>
	   </tr>
	 	
	</table>
