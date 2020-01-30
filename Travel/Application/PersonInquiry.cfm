<!--- 
	PersonInquiry.cfm
	Page for searching for persons to display in the Person Selection page.

	Search by: Name, mission ID number, Nationality
	
	Modification History:

--->

<HTML><HEAD><TITLE>Person Inquiry</TITLE></HEAD>
<!---
<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>"> 
--->
<link href="../../../../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<body onLoad="window.focus()">

<cfquery name="Mission" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT M.Mission	
	FROM ORGANIZATION.DBO.Ref_Mission M, Position P, PersonAssignment
	ORDER BY M.Mission
</cfquery>

<cfquery name="Nation" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#" cachedwithin="#CreateTimeSpan(0,2,0,0)#">
    SELECT DISTINCT N.code, N.name FROM Ref_Nationality N, EMPLOYEE.DBO.Person P
	WHERE N.Name > 'A'
	AND   N.Code = P.Nationality
	ORDER BY N.name
</cfquery>

<!--- Search form --->
<p></p>
<b><font face="BondGothicLightFH">

<form action="PersonInquiryResult.cfm" method="post">

<cfparam name="URL.FormName" default="Myform">
<cfparam name="URL.FieldName" default="MyField">

<cfoutput>
<input type="hidden" name="FormName"  value="#URL.FormName#">
<input type="hidden" name="FieldName" value="#URL.FieldName#">
<input type="hidden" name="IncidentNo"  value="#URL.ID#">
</cfoutput>

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr bgcolor="#002350">
  <td height="20" class="label">&nbsp;<b>Person Inquiry</b></td>
  </tr>
  
  <tr>
  <td>  
  
  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">
  
  <tr bgcolor="6688aa"><td height="10"></td></tr>
  <tr><td class="header">&nbsp;&nbsp;Instructions:</td></tr>
  <tr><td class="header">&nbsp;&nbsp;1. Use this page to control records to display in the resulting list.</td></tr>
  <tr><td class="header">&nbsp;&nbsp;2. Click the <b>Incl.</b> radio button to include values a selection box.</td></tr>
  <tr><td class="header">&nbsp;&nbsp;3. For multiple selection, click a list item while holding down the CTRL key.</td></tr>

  <tr bgcolor="white" valign="top">
	<td>&nbsp;
	
	<table>
	
    <td></td>
	<!--- Field: LastName=CHAR;40;FALSE --->
	<input type="hidden" name="Crit2_FieldName" value="P.LastName">	
	<input type="hidden" name="Crit2_FieldType" value="CHAR">
	<tr><td width="50"></td>
	<td align="left">    
      <font size="1" face="Tahoma" color="#6688AA"><b>Last name:</b></font>
    </td>
	<td colspan="3"><font color="#000000">
		<select name="Crit2_Operator">
			<option value="BEGINS_WITH">begins with
			<option value="ENDS_WITH">ends with
			<option value="CONTAINS">contains
			<option value="EQUAL">is
			<option value="NOT_EQUAL">is not
			<option value="SMALLER_THAN">before
			<option value="GREATER_THAN">after
		</select></font>
		<font color="#6688AA">&nbsp;</font>
		<font color="#000000"><input type="text" name="Crit2_Value" size="20"></font>	
	</td>
	</tr>

	<!--- Field: FirstName=CHAR;40;FALSE --->
	<input type="hidden" name="Crit3_FieldName" value="P.FirstName">	
	<input type="hidden" name="Crit3_FieldType" value="CHAR">
	<tr><td></td>
	<td align="left">
       <font color="#6688AA" size="1" face="Tahoma"><b>First name:</b></font>
    </td>
	<td colspan="3"><font color="#000000">
		<select name="Crit3_Operator">		
			<option value="BEGINS_WITH">begins with
			<option value="ENDS_WITH">ends with
			<option value="CONTAINS">contains
			<option value="EQUAL">is
			<option value="NOT_EQUAL">is not
			<option value="SMALLER_THAN">before
			<option value="GREATER_THAN">after		
		</select>
		</font>
		<font color="#6688AA">&nbsp; </font>
		<font color="#000000">		
		<input type="text" name="Crit3_Value" size="20">
		</font>	
	</td>
	</tr>
	
	<!--- Field: Mission ID=CHAR;20;TRUE --->
	<input type="hidden" name="Crit1_FieldName" value="PD.DocumentNo">	
	<input type="hidden" name="Crit1_FieldType" value="CHAR">
	<tr>
	<td></td>
	<td align="left">
        <font size="1" face="Tahoma" color="#6688AA"><b>Mission ID:</b></font>
    </td>
	<td colspan="3"><font color="#000000">
		<select name="Crit1_Operator">
			<option value="BEGINS_WITH">begins with
			<option value="ENDS_WITH">ends with
			<option value="CONTAINS">contains
			<option value="EQUAL">is
			<option value="NOT_EQUAL">is not
			<option value="SMALLER_THAN">before
			<option value="GREATER_THAN">after
		</select></font>
		<font color="#6688AA">&nbsp; </font>
		<font color="#000000"><input type="text" name="Crit1_Value" size="20"></font>	
	</td>
	</tr>	
	
	<tr><td>&nbsp;</td></tr>
	
     <!--- Field: Nationality=CHAR;40;FALSE --->
	<td width="30"> </td>
	<td align="left" valign="top">
      <font size="1" face="Tahoma" color="#6688AA"><b>Nationality:</b></font><P>
      <font color="#000000" face="Tahoma" size="1">	
		<input type="radio" name="Nation" value="0" checked></font><font face="Tahoma" size="1" color="#6688AA">Incl.
      </font>
      <font color="#000000" face="Tahoma" size="1">
    	<input type="radio" name="Nation" value="1"></font><font face="Tahoma" size="1" color="#6688AA">Excl.
      </font>  	
	</td>
	
	<td>
    	<font color="#000000">
    	<select name="Nationality" size="15" multiple>
	    <cfoutput query="Nation">		
			<option value="'#Code#'"selected>#Name#</option>
		</cfoutput>
	    </select></font>
	</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	</table>	 
</table>	

</td></tr>	

<tr bgcolor="6688aa"><td height="10"></td></tr>

</table>
	
<hr>
<!--- show Close and Submit buttons --->
<input class="input.button1" type="button" name="OK"    value="    Close    " onClick="window.close()">
<input class="input.button1" type="submit" name"Search" value="     Submit   ">

</FORM>
</BODY></HTML>