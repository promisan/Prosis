
<cf_screentop height="100%" scroll="yes" bannerheight="4" title="Result">

<CFSET Criteria = ''>

<cfparam name="Form.Crit1_Value" default="">

<cfif Form.Crit1_Value neq "">
	<CF_Search_AppendCriteria
	    FieldName="#Form.Crit1_FieldName#"
	    FieldType="#Form.Crit1_FieldType#"
	    Operator="#Form.Crit1_Operator#"
	    Value="#Form.Crit1_Value#">
</cfif>	

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

<cfif Form.Nationality IS NOT "">
     <cfif Criteria is ''>
		 <CFSET Criteria = "Nationality IN (#PreserveSingleQuotes(Form.Category)# )">
	 <cfelse>
		 <CFSET Criteria = #Criteria#&" AND Nationality IN ( #PreserveSingleQuotes(Form.Nationality)# )" >
     </cfif>
</cfif> 
<table cellspacing="0" cellpadding="0" class="formpadding"><tr><td>
&nbsp;
<cf_tl id="Return" var="1">
<cfoutput>
<input type="button" class="button10g" name="Search" value="#lt_text#" onClick="history.back()">
</cfoutput>
</td></tr></table>

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT top 400 * 
    FROM Person
	<cfif #PreserveSingleQuotes(Criteria)# neq "">
	WHERE #PreserveSingleQuotes(Criteria)# 
    </cfif>
	ORDER BY LastName, FirstName</cfquery>
<cfoutput>	

<script>
<!--
function selected(per,ind,last,first,nat,sex,dob) {

	<CFOUTPUT>
	    var form = "#Form.FormName#";
	   	var field = "#Form.FieldName#";
		eval("self.opener.document." + form + ".EmployeeNo.value    = per");	
		eval("self.opener.document." + form + "." + field + ".value = ind");	
		eval("self.opener.document." + form + ".LastName.value      = last");
		eval("self.opener.document." + form + ".FirstName.value     = first");
		eval("self.opener.document." + form + ".Gender.value        = sex");
		eval("self.opener.document." + form + ".Nationality.value   = nat");	
		eval("self.opener.document." + form + ".DOB.value = dob");			
	    window.close();
	</CFOUTPUT>
}
//-->
</script>

</cfoutput>	

<cf_dialogStaffing>

<table width="99%" align="center" border="1" frame="hsides" cellspacing="0" cellpadding="0" bordercolor="silver" frame="all">
  <tr>
   <td height="24" class="top4n"><b>&nbsp;&nbsp;<cf_tl id="Select"></font></td>
   <td align="right" class="top4n"></td>
  </tr> 	

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">

<tr><td>

<table border="0" cellpadding="0" cellspacing="0" width="100%">

<TR bgcolor="f4f4f4">
    <td height="20"></td>
    <TD>&nbsp;<cf_tl id="IndexNo"></TD>
	<TD><cf_tl id="Name"></TD>
    <TD><cf_tl id="Nat."></TD>
	<TD><cf_tl id="Sex"></TD>
	<TD><cf_tl id="DOB"></TD>
	<TD><cf_tl id="Org. start">&nbsp;</TD>
   
</TR>

<CFOUTPUT query="SearchResult">
<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f4f4f4'))#">
<TD>&nbsp;

<cfset last  = Replace(LastName,"'"," ","ALL")>
<cfset first = Replace(FirstName,"'"," ","ALL")>

 <a href="javascript:selected('#PersonNo#','#IndexNo#','#Last#','#First#','#Nationality#','#Gender#','#DateFormat(BirthDate, CLIENT.DateFormatShow)#')" 
 onMouseOver="document.img0_#personno#.src='../../../../Images/button.jpg'" 
 onMouseOut="document.img0_#personno#.src='../../../../Images/insert.gif'">
   <img src="../../../../Images/insert.gif" 
    alt="" 
	name="img0_#personno#" 
	id="img0_#personno#" 
	width="14" 
	height="14" 
	border="0" 
	align="middle">
      </a>
</TD>
<TD><A HREF ="javascript:EditPerson('#PersonNo#')">#IndexNo#</A></TD>
<TD>#LastName#, #FirstName#</font></TD>
<TD>#Nationality#</font></TD>
<TD>#Gender#</font></TD>
<TD>#DateFormat(BirthDate, CLIENT.DateFormatShow)#</font></TD>
<TD>#Dateformat(OrganizationStart, CLIENT.DateFormatShow)#</font></TD>
</TR>
</CFOUTPUT>

</TABLE>

</tr></td>
</table>

<cf_screenbottom>

