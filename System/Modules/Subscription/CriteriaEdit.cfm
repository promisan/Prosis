<HTML><HEAD>
	<TITLE>Edit Form</TITLE>
</HEAD><body bgcolor="#FFFFFF" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfif #URL.ID# eq "">
 <cfset URL.ID = "000000000-0000-0000-0000-000000000000}">
</cfif>

<script language="JavaScript">

function show(box)

{

se = document.getElementById("list")
se.className = "Hide"

var cnt = 1

while (cnt < 6) {
    se = document.getElementById("l"+cnt)
    se.className = "Hide" 
	cnt++}

if (box == 'list') {
	se = document.getElementById(box)
	se.className = "Regular"
	}
	
if (box == 'lookup') {
	se = document.getElementById("list")
	se.className = "Regular"
	cnt = 1
	while (cnt < 6) {
    se = document.getElementById("l"+cnt)
    se.className = "regular" 
	cnt++ }
	
	}	
}

</script>

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ReportControlCriteria 
WHERE ControlId = '#URL.ID#'
AND CriteriaName = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this parameter ?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>

<CFFORM action="CriteriaSubmit.cfm" method="post" enablecab="yes" name="dialog">

<cf_dialogTop text="Report/View input parameter">

<!--- Entry form --->

<input type="hidden" name="ControlId" id="ControlId" value="<cfoutput>#URL.ID#</cfoutput>">

<table width="95%" align="center">

 <TR>
    <TD class="regular">Parameter name:</TD>
    <TD class="regular"> 
	    
		<input type="Hidden" name="CriteriaNameOld" id="CriteriaNameOld" value="<cfoutput>#get.CriteriaName#</cfoutput>">
	
		<cfinput type="Text" class="regular" name="CriteriaName" value="#get.CriteriaName#" 
		message="Please enter a criteria screen name" required="Yes" size="30" maxlength="30">
			
	</TD>
 </TR>
 
 <tr><td height="4"></td></tr>
 
 <TR>
    <TD class="regular">Description:</TD>
    <TD class="regular"> 
		<cfinput type="Text" class="regular" name="CriteriaDescription" value="#get.CriteriaDescription#" 
		message="Please enter a description" required="Yes" size="70" maxlength="80">
	</TD>
 </TR>

 <tr><td height="4"></td></tr>
	
	<TR>
    <TD class="regular">Order:</TD>
    <TD class="regular">
	<cfif #Get.CriteriaOrder# eq "">
	 <cfinput type="Text" name="CriteriaOrder" 
	   value="0" message="Please enter a valid order" validate="integer" required="Yes" size="2" maxlength="2" class="amount">
	<cfelse>
	 <cfinput type="Text" name="CriteriaOrder" value="#Get.CriteriaOrder#" 
	   message="Please enter a valid order" validate="integer" required="Yes" size="2" maxlength="2" class="amount">
	</cfif>   
    </TD>
	</TR>
	
 <tr><td height="4"></td></tr>	
 	
	<TR>
    <TD class="regular">Input validation:</TD>
    <TD class="regular"> 
	
	  <input type="radio" name="CriteriaType" id="CriteriaType" value="Text" onClick="javascript:show('none')" <cfif #Get.CriteriaType# eq "Text" or #get.CriteriaType# eq "">checked</cfif>>Text
	  <input type="radio" name="CriteriaType" id="CriteriaType" value="Integer" onClick="javascript:show('none')" <cfif #Get.CriteriaType# eq "Integer">checked</cfif>>Integer
	  <input type="radio" name="CriteriaType" id="CriteriaType" value="Date" onClick="javascript:show('none')" <cfif #Get.CriteriaType# eq "Date">checked</cfif>>Date
	  <input type="radio" name="CriteriaType" id="CriteriaType" value="List" onClick="javascript:show('list')" <cfif #Get.CriteriaType# eq "List">checked</cfif>>List
	  <input type="radio" name="CriteriaType" id="CriteriaType" value="Lookup" onClick="javascript:show('lookup')" <cfif #Get.CriteriaType# eq "Lookup">checked</cfif>>Lookup (Query)	  
				
	</TD>
	</TR>
		
	<tr><td height="5"></td></tr>
	
	<cfif #Get.CriteriaType# eq "List" or #Get.CriteriaType# eq "Lookup">
	  <cfset cl = "Regular">
	<cfelse>
	  <cfset cl = "Hide"> 
	</cfif>
	
	<tr id="list" class="<cfoutput>#cl#</cfoutput>">
	<td valign="top" class="regular">List/Query:</td>
    <TD class="regular">
	   <textarea cols="60" class="regular" rows="10" name="CriteriaValues"><cfoutput>#Get.CriteriaValues#</cfoutput></textarea>
    </TD>
	</TR>
	
	<cfif #Get.CriteriaType# eq "Lookup">
	  <cfset cl = "Regular">
	<cfelse>
	  <cfset cl = "Hide"> 
	</cfif>
	
	<tr id="l0" class="<cfoutput>#cl#</cfoutput>"><td height="4"></td></tr>
	
	<TR id="l1" class="<cfoutput>#cl#</cfoutput>">
    <TD class="regular">Field value:</TD>
    <TD class="regular"> 
		<cfinput type="Text" class="regular" name="LookupFieldValue" value="#get.LookupFieldValue#" 
		message="Please enter a description" required="No" size="30" maxlength="30">
	</TD>
 </TR>
 
   <tr id="l2" class="<cfoutput>#cl#</cfoutput>"><td height="4"></td></tr>
	
	<TR id="l3" class="<cfoutput>#cl#</cfoutput>">
    <TD class="regular">Field display:</TD>
    <TD class="regular"> 
		<cfinput type="Text" class="regular" name="LookupFieldDisplay" value="#get.LookupFieldDisplay#" 
		message="Please enter a description" required="No" size="30" maxlength="30">
	</TD>
 </TR>
 
    <tr id="l4" class="<cfoutput>#cl#</cfoutput>"><td height="4"></td></tr>
	
	<TR id="l5" class="<cfoutput>#cl#</cfoutput>">
    <TD class="regular">Select Multiple:</TD>
    <TD class="regular"> 
	  <input type="radio" name="LookupMultiple" id="LookupMultiple" value="0" <cfif #Get.LookupMultiple# eq "0" or #get.CriteriaType# eq "">checked</cfif>>No
	  <input type="radio" name="LookupMultiple" id="LookupMultiple" value="1" <cfif #Get.LookupMultiple# eq "1">checked</cfif>>Yes

	</TD>
 </TR>
 
 <tr><td height="4"></td></tr>
	
	<TR>
    <TD class="regular">Width (in pixels):</TD>
    <TD class="regular">
	<cfif #Get.CriteriaOrder# eq "">
	 <cfinput type="Text" name="CriteriaWidth" 
	   value="100" message="Please enter a width" validate="integer" required="Yes" size="2" maxlength="2" class="amount">
	<cfelse>
	 <cfinput type="Text" name="CriteriaWidth" value="#Get.CriteriaWidth#" 
	   message="Please enter a width" validate="integer" required="Yes" size="2" maxlength="2" class="amount">
	</cfif>   
    </TD>
	</TR>
 
 <tr><td height="5"></td></tr>
 
 <TR>
    <TD class="regular">Default value:</TD>
    <TD class="regular"> 
		<cfinput type="Text" class="regular" name="CriteriaDefault" value="#get.CriteriaDefault#" 
		message="You must enter a default value" required="Yes" size="70" maxlength="80">
	</TD>
 </TR>
 
 <tr><td height="4"></td></tr>
 <tr><td height="1" colspan="2" bgcolor="silver"></td></tr>
 <tr><td height="4"></td></tr>
 
 <tr>
	<td colspan="2" align="right">
	<input class="button7" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
	<input class="button7" type="submit" name="Delete" id="Cancel" value=" Delete " onclick="return ask()">
	<input class="button7" type="submit" name="Update" id="Update" value=" Update ">&nbsp;
  </td>
  
  </tr>
  
  </table>

</CFFORM>

</BODY></HTML>