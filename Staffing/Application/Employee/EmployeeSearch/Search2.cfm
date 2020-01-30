
<HTML><HEAD>
    <TITLE>Employee Inquiry</TITLE>
    <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
</HEAD><body onLoad="window.focus()">

<cfform action="Search2Submit.cfm?Mission=#URL.Mission#" method="POST" enablecab="Yes" name="search">


<!--- <cfform action="javascript:ShowResult()" method="POST"> --->

<table width=85% border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#002350">

 <tr bgcolor="#002350">
    <td height="30" class="BannerN">
	  <b>&nbsp;Employee profile:</b>
	</td>
	<td align="right" class="BannerN">
	<cfoutput>
	<cf_tl id="Reset" var="1">
	<input class="button1" type="reset"  value=" #lt_text#  ">
	<cf_tl id="Continue" var="1">
	<input type="submit" name="Submit" value="  #lt_text#  " class="button1">
	</cfoutput>	
    &nbsp;
	</td>
 </tr> 	
   
  <tr><td colspan="2">

<cfquery name="Nationality" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_Nation
</cfquery>

<cfquery name="SalarySchedule" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT SalarySchedule 
    FROM SalarySchedule
</cfquery>

<cfquery name="Entitlement" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT SalaryTrigger, Description 
    FROM Ref_PayrollTrigger
	WHERE (TriggerGroup = 'Entitlement' OR TriggerGroup = 'Insurance')
	AND (Description is not null)
</cfquery>

<cfquery name="Grade" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_PostGrade
	ORDER By PostOrder
</cfquery>

<!--- Search form --->

</font>

<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

<tr><td>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">
 
<TR bgcolor="6688aa">  
   <td colspan="1" height="20" class="top">&nbsp;<cf_tl id="Status"></td>
   <td colspan="1" class="top"><cf_tl id="Identification"></td>
   <td colspan="1" class="top"><cf_tl id="Gender">&nbsp;</td> 
</TR>
	<!--- Field: Staff.OnBoard=CHAR;20;TRUE --->
<TR>
   <td height="5" colspan="3" valign="middle"></td>
</TR> 
	
<TR><td width="25%" class="regular">

    <table border="0" cellspacing="0" cellpadding="0">
       <tr><td class="regular"><input type="radio" name="EmployeeStatus" value="OnBoard" checked><cf_tl id="On board"></td></tr>
       <tr><td class="regular"><input type="radio" name="EmployeeStatus" value="History"><cf_tl id="History"></td></tr>
	   <tr><td class="regular"><input type="radio" name="EmployeeStatus" value="All"><cf_tl id="All"></td></tr>
	</table>	

   </td>	
	
   <TD class="regular" width="58%">	
   
   <table border="0" cellspacing="0" cellpadding="0">
   <tr>
   <TD class="regular"><cf_tl id="Index No">:&nbsp;</TD>
   <TD><INPUT type="text" name="IndexNo" size="20" class="regular"></td>
   </tr>
   <tr>
   <TD class="regular"><cf_tl id="Last name">:&nbsp;</TD>
   <TD><INPUT type="text" name="LastName" size="30" class="regular"></td>
   </tr>
    <tr>
   <TD class="regular"><cf_tl id="First name">:&nbsp;</TD>
   <TD><INPUT type="text" name="FirstName" size="20" class="regular"></td>
   </tr>
   </table>
 	
   </TD>
	
    <td class="regular" width="17%">
	<table border="0" cellspacing="0" cellpadding="0">
    <tr><td class="regular"><input type="radio" name="Gender" value="M"><cf_tl id="Male"></td></tr>
	<tr><td class="regular"><input type="radio" name="Gender" value="F"><cf_tl id="Female"></td></tr>
	<tr><td class="regular"><input type="radio" name="Gender" value="B" checked><cf_tl id="Both"></td></tr>
	</table>		
  </td>
  
  <TR>
   <td height="3" colspan="6" valign="middle"></td>
   </TR>   

</TR>		

<tr><td width="100%" colspan="3">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

<TR bgcolor="002350">
     <td height="2" colspan="6" valign="middle"></td>
   </TR>     

   <TR bgcolor="6688aa">  
    <td width="33%" height="20" colspan="2" class="top">&nbsp;<cf_tl id="Nationality"></td>
	<td colspan="2" class="top">&nbsp;</td>
	<td colspan="2" class="top">&nbsp;</td>
   </TR>
   
   <TR>
   <td height="3" colspan="6" valign="middle"></td>
   </TR>   
		
	
	<TD valign="top" class="regular">

	<input type="radio" name="NationalityStatus" value="ANY" checked><cf_tl id="ANY">
	<p>
	<input type="radio" name="NationalityStatus" value="ALL"><cf_tl id="ALL">
    
	</TD>
	<TD>
    	<select name="Nationality" size="8"  required="No" multiple>
	    <cfoutput query="Nationality">
		<option value="'#Code#'">#Name#</option>
		</cfoutput>
	   	</select>
	</TD>	
	</TR>	
	
	<TR>
   <td height="5" colspan="6" valign="middle"></td>
</TR> 		

</table>

</td></tr>

<tr><td width="100%" colspan="3">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

<TR>
   <td height="5" colspan="6" valign="middle"></td>
</TR>   

<TR bgcolor="002350">
   <td height="2" colspan="6" valign="middle"></td>
</TR>  

   <tr><td colspan="6">
   
   <table width="100%" border="0" cellspacing="0" cellpadding="0">
   
   <TR bgcolor="6688aa">  
   <td width="25%" height="20" class="top">&nbsp;<cf_tl id="Criteria"></td>
   <td width="25%" class="top">&nbsp;<cf_tl id="Expiration"></td>
   <td width="25%" class="top">&nbsp;<cf_tl id="Criteria"></td>
   <td width="25%" class="top">&nbsp;<cf_tl id="Expiration"></td>
   </TR> 
   
   <TR>
   <td height="3" colspan="4" valign="middle"></td>
   </TR>  
   
   <tr>
   <td class="regular" colspan="1">&nbsp;<cf_tl id="Contract expiration"></td>
   <td colspan="1">  <cf_intelliCalendarDate
		FieldName="ContractExpiration" 
		Default=""
		AllowBlank="True">
   </td>
   </tr>
   
   
   <TR>
   <td height="3" colspan="4" valign="middle"></td>
   </TR>  
   
   </table>
   
   </td></tr>
      
   <TR bgcolor="002350">
     <td height="2" colspan="6" valign="middle"></td>
   </TR>     

   <TR bgcolor="6688aa">  
   <td colspan="2" height="20" class="top">&nbsp;<cf_tl id="Salary group"></td>
   <td colspan="2" class="top">&nbsp;<cf_tl id="Grade"></td>
   <td colspan="2" class="top">&nbsp;<cf_tl id="Entitlement"></td>
   </TR>
   
   <TR>
   <td height="3" colspan="6" valign="middle"></td>
   </TR>   
   
   	
	
	<TD valign="top" class="regular">

	<input type="radio" name="SalaryScheduleStatus" value="ANY" checked><cf_tl id="ANY">	<p>
    <input type="radio" name="SalaryScheduleStatus" value="ALL"><cf_tl id="ALL">	 
		</TD>
	
	<TD>
    	
    	<select name="SalarySchedule" size="8" multiple required="No">
	    <cfoutput query="SalarySchedule">
		<option value="'#SalarySchedule#'">#SalarySchedule#</option>
		</cfoutput>
	   	</select>
		
	</TD>	
		
    <!--- Field: Staff.Expereince=CHAR;40;FALSE --->
	
	<td valign="top" class="regular">

	<input type="radio" name="GradeStatus" value="ANY" checked><cf_tl id="ANY"> 
	<p>
    <input type="radio" name="GradeStatus" value="ALL"><cf_tl id="ALL"> 
	
	</td>
	<td align="left" class="regular">
    	
    	<select name="Grade" size="8" multiple required="No">
	    <cfoutput query="Grade">
		<option value="'#PostGrade#'">#PostGrade#</option>
		</cfoutput>
	   	</select>
	</td>	
	   
	
	<TD valign="top" class="regular">

	<input type="radio" name="TriggerStatus" value="ANY" checked><cf_tl id="ANY">
	<p>
	<input type="radio" name="TriggerStatus" value="ALL"><cf_tl id="ALL"> 
    
	</TD>
	<TD>
    	<select name="Trigger" size="8"  required="No" multiple>
	    <cfoutput query="Entitlement">
		<option value="'#SalaryTrigger#'">#Description#</option>
		</cfoutput>
	   	</select>
	</TD>	
	</TR>	
	
	
	<TR>
   <td height="5" colspan="6" valign="middle"></td>
</TR> 		

</TABLE>

</td></tr>

</TABLE>

</td></tr>

</TABLE>

</td></tr>

</TABLE>


<HR>

<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr>
<td align="right" valign="middle" class="regular">
<!---
<button name="Prior" value="Next" type="button" onClick="history.back()">
<img src="<cfoutput>#SESSION.root#</cfoutput>/images/prev.gif" alt="" border="0"> &nbsp;<b>Back</b>&nbsp;  
</button>
--->
<button name="Prios" value="Prior" type="submit"><b><cf_tl id="Submit"></b>
<img src="../../../../Images/next.gif" border="0"> 
</button>


</td></tr>
</table>

</CFFORM>

</BODY></HTML>