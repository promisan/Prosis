<HTML><HEAD>
    <TITLE>Staff Inquiry</TITLE>
   <link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>"> 
   
</HEAD><body onLoad="window.focus()">

<b><font face="BondGothicLightFH">

<cfquery name="Nation" 
datasource="WarehousePMSS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#"
cachedwithin="#CreateTimeSpan(0,2,0,0)#">
    SELECT CODE, NAME 
    FROM Ref_Nationality
	WHERE NAME > 'A'
	ORDER BY NAME
</cfquery>

<!--- Search form --->
</font></b>
<p>

<b><font face="BondGothicLightFH">

</p>
<form action="IndexSearchResult.cfm" method="post">

<cfoutput>
<INPUT type="hidden" name="FormName"  value="#URL.FormName#">
<INPUT type="hidden" name="FieldName" value="#URL.FieldName#">
</cfoutput>

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr bgcolor="#002350">
  <td height="20" class="label">&nbsp;<b>Searchwrwrwerw</b></td>
  </tr>
  
  <tr><td>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">
<tr bgcolor="6688aa"><td height="10"></td></tr>

<tr bgcolor="white" valign="top">
<td>

    &nbsp;<TABLE>
	
    <Td></TD>
	<!--- Field: Staff.LastName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit2_FieldName" value="Staff.LastName">
	
	<INPUT type="hidden" name="Crit2_FieldType" value="CHAR">
	<TR><td width="50"></td>
	<TD align="left">
    
      <font size="1" face="Tahoma" color="#6688AA"><b>Last name:</b></font>
    </TD>
	<TD><font color="#000000"><SELECT name="Crit2_Operator">
			<OPTION value="CONTAINS">contains
			<OPTION value="BEGINS_WITH">begins with
			<OPTION value="ENDS_WITH">ends with
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
			<OPTION value="GREATER_THAN">after
		</SELECT></font><font color="#6688AA">&nbsp; </font><font color="#000000">
		
	<INPUT type="text" name="Crit2_Value" size="20"><font color="#6688AA">
    </font></font>
	
	</TD>
	</TR>

	<!--- Field: Staff.FirstName=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit3_FieldName" value="Staff.FirstName">
	
	<INPUT type="hidden" name="Crit3_FieldType" value="CHAR">
	<TR><TD></TD>
	<TD align="left">
       <font color="#6688AA">
       <font size="1" face="Tahoma"><b>First name:</b></font> </font>
    </TD>
	<TD><font color="#000000"><select name="Crit3_Operator">
		
			<option value="CONTAINS">contains
			<OPTION value="BEGINS_WITH">begins with
			<OPTION value="ENDS_WITH">ends with
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
			<OPTION value="GREATER_THAN">after
		
		</SELECT></font><font color="#6688AA">&nbsp; </font><font color="#000000">
		
	<INPUT type="text" name="Crit3_Value" size="20"><font color="#6688AA">
    </font></font>
	
	</TD>
	</TR>

    <!--- Field: Staff.Gender=CHAR;40;FALSE --->
	<INPUT type="hidden" name="Crit4_FieldName" value="Staff.Gender">
	
	<INPUT type="hidden" name="Crit4_FieldType" value="CHAR">
	<INPUT type="hidden" name="Crit4_Operator" value="CONTAINS">
		<TR>
		<TD></TD>
	<TD align="left">
          <font size="1" face="Tahoma" color="#6688AA"><b>Gender:</b></font>
    </TD>
	
	<TD>
	
	<font color="#000000">
	
	<input type="radio" name="Crit4_Value" value="M"></font><font size="1" face="BondGothicLightFH" color="#6688AA">Male</font><font size="1" color="#6688AA">&nbsp;
    </font><font color="#000000" size="1">
    <input type="radio" name="Crit4_Value" value="F"></font><font size="1" face="BondGothicLightFH" color="#6688AA">Female</font><font size="1" color="#6688AA">&nbsp;
    </font><font color="#000000" size="1">
	<input type="radio" name="Crit4_Value" value="" checked></font><font color="#6688AA"><font size="1" face="BondGothicLightFH">Both</font><font size="1">
    </font>
	
	</font>
	
	</TD>
	</TR>
	
<!--- Field: Staff.IndexNo=CHAR;20;TRUE --->
	<INPUT type="hidden" name="Crit1_FieldName" value="Staff.IndexNo">
	
	<INPUT type="hidden" name="Crit1_FieldType" value="CHAR">
	<TR><TD></TD>
	<TD align="left">
        <font size="1" face="Tahoma" color="#6688AA"><b>Index No:
    </b></font>
    </TD>
	<TD><font color="#000000"><SELECT name="Crit1_Operator">
			<OPTION value="CONTAINS">contains
			<OPTION value="BEGINS_WITH">begins with
			<OPTION value="ENDS_WITH">ends with
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
			<OPTION value="GREATER_THAN">after
		</SELECT></font><font color="#6688AA">&nbsp; </font><font color="#000000">
		
	<INPUT type="text" name="Crit1_Value" size="20"><font color="#6688AA">
    </font></font>
	
	</TD>
	</TR>	
	
    <!--- Field: Staff.Nationality=CHAR;40;FALSE --->
	<TR><TD></TD>
	<TD align="left">
      <font size="1" face="Tahoma" color="#6688AA"><b>Nationality:</b></font><P>
      <font color="#000000" face="Tahoma" size="1">
	
	<input type="radio" name="Nation" value="0"></font><font face="Tahoma" size="1" color="#6688AA">Incl.
      </font>
	<p>
    <font color="#000000" face="Tahoma" size="1">
    <input type="radio" name="Nation" value="1" checked></font><font face="Tahoma" size="1" color="#6688AA">Excl.
    </font>
  	
	</TD>
	
	<TD>
    	<font color="#000000">
    	<select name="Nationality" size="15" multiple>
	    <cfoutput query="Nation">
		
		<option value="'#Code#'"selected>
		#Name#
		</option>
		</cfoutput>
	    </select></font><font color="#6688AA">&nbsp; </font>
		
	    <p></TD>
	</TR>
	</TABLE>
	 
</table>	

</TD></TR>	

<tr bgcolor="6688aa"><td height="10"></td></tr>

</TABLE>
	
<HR>

<input class="input.button1" type="button" name="OK"    value="    Close    " onClick="window.close()">
<input class="input.button1" type="submit" name"Search" value="     Submit   ">


</FORM>

</BODY></HTML>