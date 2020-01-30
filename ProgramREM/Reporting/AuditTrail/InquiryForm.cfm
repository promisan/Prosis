<HTML><HEAD>
    <TITLE>Document - Inquiry Search Form</TITLE>
</HEAD><BODY bgcolor="#FFFFFF">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">


<cfoutput>
<table width="100%">
<TD><font size="4"><b>Audit trail</b></font>
</TD>
<TD><img src="#SESSION.root#/images/locate.JPG" alt="" border="0" align="right"></TD>
</table>
</cfoutput>
<hr>

<cfquery name="Parameter"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM  Parameter
</cfquery>

<cfquery name="Group"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM  Ref_ProgramGroup
</cfquery>

<cfquery name="Status"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT ProgramStatus
	FROM  Program
</cfquery>


<!--- Search form --->
<cfform action="InquiryResult.cfm" name="program">
 <table width="70%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="silver">

 <tr>
    <td height="26" class="top3nd">
	  <b>&nbsp;List by any or all of the criteria below:</b>
	</td>
	<td align="right" class="top3nd">
	<input class="button7" type="reset"  value=" Reset  ">
    <input class="button7" type="submit" value=" Submit ">&nbsp;
	</td>
 </tr> 	
 
</table> 
  
<cf_tableTop size = "70%" omit="true">  
  
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">

	<tr><td height="1" colspan="1" class="regular"></td></tr>
	
	
	<tr><td height="4"></td></tr>
	<tr><td height="1" colspan="4" bgcolor="D6D6D6"></td></tr>
	<tr><td height="4"></td></tr>
	 
	<TR>
	
	<td colspan="1" class="regular"><b>Status:</td>
		    
	<td colspan="3">
	
	  <select name="ProgramStatus" size="1">
	    <cfoutput query="Status">
		<option value="#ProgramStatus#">
		  #ProgramStatus#
		</option>
		</cfoutput>
	    </select>
	     	
	</TD>
	</tr>
	
	<tr><td height="4"></td></tr>
	<tr><td height="1" colspan="4" bgcolor="D6D6D6"></td></tr>
	<tr><td height="4"></td></tr>
	
	<tr>
	
	<td colspan="1" class="regular"><b>Group:</td>
	
	<td colspan="3">
	
		   <select name="ProgramGroup" size="1">
		   <option value="All" selected>All
	    <cfoutput query="Group">
		<option value="#Code#">
		  #Description#
		</option>
		</cfoutput>
	    </select>
	</td>
	
	</tr>
	
	<tr><td height="4"></td></tr>
	<tr><td height="1" colspan="4" bgcolor="D6D6D6"></td></tr>
	<tr><td height="4"></td></tr>
	
	<tr>
	
	<td colspan="1" class="regular"><b>Entered:</td>
	
	<td colspan="3">
	<table><tr><td>
	<cf_intelliCalendarDate8
		FieldName="Start" 
		Default="#Dateformat(Now()-7, CLIENT.DateFormatShow)#"
		Class="regular"
		AllowBlank="TRUE">
		</td><td>
      <cf_intelliCalendarDate8
		FieldName="End" 
		Default="#Dateformat(Now(), CLIENT.DateFormatShow)#"
		Class="regular">	
		</td></tr></table>		
	</td>
	
	</tr>
	
		
	<tr><td height="4"></td></tr>
	
	<tr><td height="1" colspan="4" bgcolor="D6D6D6"></td></tr>
	<tr><td height="3"></td></tr>
    <tr><td colspan="4" align="right">
        <input class="button7" type="submit" name="submit"  value="  Submit  ">&nbsp;
    </td></tr>

</table>

<cf_tableBottom size = "70%">

</CFFORM>

</BODY></HTML>