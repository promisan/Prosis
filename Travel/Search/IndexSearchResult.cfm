<!--- Create Criteria string for query from data entered thru search form --->

<CF_RegisterAction 
SystemFunctionId="0101" 
ActionClass="Search" 
ActionType="Submit" 
ActionReference="Search" 
ActionScript="">   

<CFSET Criteria = ''>
<CF_Search_AppendCriteria
    FieldName="#Form.Crit1_FieldName#"
    FieldType="#Form.Crit1_FieldType#"
    Operator="#Form.Crit1_Operator#"
    Value="#Form.Crit1_Value#">
<CF_Search_AppendCriteria
    FieldName="#Form.Crit2_FieldName#"
    FieldType="#Form.Crit2_FieldType#"
    Operator="#Form.Crit2_Operator#"
    Value="#Form.Crit2_Value#">
<CF_Search_AppendCriteria
    FieldName="#Form.Crit3_FieldName#"
    FieldType="#Form.Crit3_FieldType#"
    Operator="#Form.Crit3_Operator#"
    Value="#Form.Crit3_Value#">
<CF_Search_AppendCriteria
    FieldName="#Form.Crit4_FieldName#"
    FieldType="#Form.Crit4_FieldType#"
    Operator="#Form.Crit4_Operator#"
    Value="#Form.Crit4_Value#">	
	
<cfparam name="Form.Nationality" default="">	

<cfif #Form.Nation# IS "0">
<cfif #Form.Nationality# IS NOT "">
     <cfif #Criteria# is ''>
	 <CFSET #Criteria# = "Staff.Nationality IN (#PreserveSingleQuotes(Form.Category)# )">
	 <cfelse>
	 <CFSET #Criteria# = #Criteria#&" AND Staff.Nationality IN ( #PreserveSingleQuotes(Form.Nationality)# )" >
     </cfif>
</cfif> 
</cfif>	

<!--- <cfoutput>#PreserveSingleQuotes(Criteria)#</cfoutput> ---> 

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="WarehousePMSS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT * 
    FROM Staff
    WHERE 
        #PreserveSingleQuotes(Criteria)#
		ORDER BY Staff.LastName, Staff.FirstName</cfquery>

<SCRIPT LANGUAGE = "JavaScript">
<!--
function Selected(Ind,last,first,nat,sex,dob)
{

	<CFOUTPUT>
	    var form = "#Form.FormName#";
    	var field = "#Form.FieldName#";
		eval("self.opener.document." + form + "." + field + ".value = Ind");			
		eval("self.opener.document." + form + ".LastName.value = last");
		eval("self.opener.document." + form + ".FirstName.value = first");
		eval("self.opener.document." + form + ".Gender.value = sex");
		eval("self.opener.document." + form + ".Nationality.value = nat");	
		eval("self.opener.document." + form + ".DOB.value = dob");			
	    window.close();
	</CFOUTPUT>
}
//-->
</SCRIPT>

<cf_dialogStaffing>

<HTML><HEAD>
    <TITLE>Employees</TITLE>
	<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>">

</HEAD><body bgcolor="#BFDFFF">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr bgcolor="#002350">
  <td height="20" class="label">&nbsp;<b>Result</b></td>
  </tr>
  
  <tr><td>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

<TR bgcolor="#6688aa">
    <TD>
    <font size="1" face="Tahoma" color="FFFFFF">&nbsp;</font></TD>
    <TD>
    <font size="1" face="Tahoma" color="FFFFFF">IndexNo</font></TD>
    <TD>
    <font size="1" face="Tahoma" color="FFFFFF">LastName</font></TD>
    <TD>
    <font size="1" face="Tahoma" color="FFFFFF">FirstName</font></TD>
    <TD>
    <font size="1" face="Tahoma" color="FFFFFF">Nat.</font></TD>
    <TD>
    <font size="1" face="Tahoma" color="FFFFFF">Gender</font></TD>
    <TD>
    <font size="1" face="Tahoma" color="FFFFFF">DOB</font></TD>
    <TD>
    <font size="1" face="Tahoma" color="FFFFFF">EODUN</font></TD>
</TR>

<CFOUTPUT query="SearchResult">
<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('D6DEE4'))#">
<TD><font size="1" face="Tahoma" color="000000">
<input type="button" name="select" value="..." 
onClick="javascript:Selected('#IndexNo#','#LastName#','#FirstName#','#Nationality#','#Gender#','#DateFormat(BirthDate, CLIENT.DateFormatShow)#')">

</TD>
<TD><font size="1" face="Tahoma" color="000000"><A HREF ="javascript:ShowPerson('#IndexNo#')">#IndexNo#</A></font></TD>
<TD><font size="1" face="Tahoma" color="000000">#LastName#</font></TD>
<TD><font size="1" face="Tahoma" color="000000">#FirstName#</font></TD>
<TD><font size="1" face="Tahoma" color="000000">#Nationality#</font></TD>
<TD><font size="1" face="Tahoma" color="000000">#Gender#</font></TD>
<TD><font size="1" face="Tahoma" color="000000">#DateFormat(BirthDate, CLIENT.DateFormatShow)#</font></TD>
<TD><font size="1" face="Tahoma" color="000000">#Dateformat(EODUN, CLIENT.DateFormatShow)#</font></TD>
</TR>
</CFOUTPUT>

</TABLE>

</tr></td>
</table>

<hr>

<input type="button" name="Print" value="    Print    " onClick="window.print()">
<input type="button" name="OK"    value="    Close    " onClick="window.close()">

</BODY></HTML>