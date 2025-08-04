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
<HTML><HEAD>
<TITLE>Contract - Entry Form</TITLE>
</HEAD><body bgcolor="#FFFFFF" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="file:///P|/Intranet/<cfoutput>#client.style#</cfoutput>"> 

<cf_dialogPosition>
<cfinclude template="ComponentViewHeader_kw.cfm">


<script>

function verify(myvalue) { 
	
	if (myvalue == "") { 
	
			alert("You did not define a salary scale")
			document.ContractEntry.search.focus()
			document.ContractEntry.search.select()
			document.ContractEntry.search.click()
			return false
			}			
	}		

</script>


<cfquery name="Class" 
datasource="AppsREMProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT CODE
    FROM Ref_ActivityClass
	ORDER BY CODE
</cfquery>

<cfquery name="Period" 
datasource="AppsREMProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Period
    FROM Ref_Period
	ORDER BY Period
</cfquery>


<!--- removed from line below ''onSubmit="return verify(ContractEntry.salaryschedule.value)"--->

<cfform action="ActivityEntrySubmit.cfm" method="POST" name="ActivityEntry" >

<cfoutput><input type="hidden" name="ProgramCode" value="#URL.ProgramCode#" class="regular"></cfoutput>

<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#002350">
  <tr>
    <td width="100%" height="30" align="left" valign="middle" bgcolor="#002350">
	<cfoutput>
    	<font face="tahoma" size="2" color="FFFFFF"><b>&nbsp;Register Activity</b></font>
	</cfoutput>
    </td>
  </tr> 	
  
  <tr>
    <td width="100%" height="16" align="left" bgcolor="#6688aa">
	<cfoutput>
	     <font face="tahoma" size="1" color="FFFFFF">&nbsp;Activity details</font>
	</cfoutput>
    </td>
  </tr> 	
     
  <tr>
    <td width="100%" class="header">
    <table width="100%">
	
    <TR><TD class="header">&nbsp;</TD></TR>		

    
  
    <TR>
    <TD class="header">&nbsp;&nbsp;Date:</TD>
    <TD class="regular">&nbsp;
	
		  <cf_intelliCalendarDate
		FormName="ActivityEntry"
		FieldName="ActivityDate" 
		DateFormat="#APPLICATION.DateFormat#"
		Default="#Dateformat(now(), CLIENT.DateFormatShow)#">	
		
	</TD>
	</TR>
	
	<tr><td height="2" colspan="1" class="header"></td></tr>
	
	  <TR>
    <TD class="header">&nbsp;&nbsp;Class:</TD>
    <TD class="regular">&nbsp;
	
    <select name="ActivityClass" message="Class" required="No">
	    <cfoutput query="Class">
		<option value="#Code#">
		#CODE#
		</option>
		</cfoutput>
	    
   	</select>	
		
	</TD>
	</TR>
	
	<tr><td height="2" colspan="1" class="header"></td></tr>
	
	  <TR>
    <TD class="header">&nbsp;&nbsp;Period:</TD>
    <TD class="regular">&nbsp;
	
    <select name="ActivityPeriod" message="Period" required="No">
	    <cfoutput query="Period">
		<option value="#Period#">
		#Period#
		</option>
		</cfoutput>
	    
   	</select>	
		
	</TD>
	</TR>
	
	<tr><td height="2" colspan="1" class="header"></td></tr>
	
	    <TR>
    <TD class="header">&nbsp;&nbsp;Sub Period:</TD>
    <TD class="regular">&nbsp;
		<cfinput type="Text" class="regular" style="text-align: center" name="ActivityPeriodSub" message="Please enter a valid number" validate="integer" required="No" size="4" maxlength="4" readonly="">		
	</TD>
	</TR>


	<tr><td height="2" colspan="1" class="header"></td></tr>
	
	   
	<TR>
        <td class="header">&nbsp;&nbsp;Description:</td>
        <TD class="regular">&nbsp;&nbsp;<textarea cols="40" rows="3" name="ActivityDescription"></textarea> </TD>
	</TR>
	
	<TR><TD class="header">&nbsp;</TD></TR>	
	
	<tr><td height="1" colspan="2" class="top"></td></tr>

</TABLE>

   <table width="100%" bgcolor="#FFFFFF"><td align="right">
   <input type="button" name="cancel" value="Cancel" class="button1" onClick="history.back()">
   <input class="button1" type="submit" name="Submit" value=" Save ">
   <input class="button1" type="reset"  name="Reset" value=" Reset ">&nbsp;
   </td>
   </table>

</table>

</CFFORM>

</BODY></HTML>