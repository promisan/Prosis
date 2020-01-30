<HTML><HEAD>
	<TITLE>Full text search</TITLE>
</HEAD><BODY bgcolor="#FFFFFF">
 <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
 
<form action="SearchFull.cfm" method="post">
   	 	  
<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="FFFFFF">
<tr><td height="1" bgcolor="eaeaea"></td></tr>
<tr>
<td height="24" valign="middle" class="Top3n"><font size="2"><b>&nbsp;Keyword search:</b></font></td></tr>

<tr><td height="5"></td></tr>

<tr><td>

<!--- Entry form --->

<table width="97%" cellspacing="0" cellpadding="0" align="center" border="0">

    <tr><td height="10"></td></tr>
  
    <!--- Field: ProgramNo --->
    <TR><td valign="top" class="regular"><b>Find results:</b></td></tr>
	<tr><td height="5"></td></tr>
	<TR>
	   <td valign="top" class="regular">&nbsp;&nbsp;With <b>ALL</b> of the words:</td>
	   <td><input type="text" name="Criteria1" size="50" maxlength="50" class="regular"></td>
	</tr>
	<tr><td height="5"></td></tr>
	<TR>
	  <td valign="top" class="regular">&nbsp;&nbsp;With the <b>EXACT Phrase/<b>:</td>
	  <td><input type="text" name="Criteria2" size="50" maxlength="50" class="regular"></td>
	</tr>
	<tr><td height="5"></td></tr>
	<TR>
	  <td valign="top" class="regular">&nbsp;&nbsp;With <b>at least one</b> of the words:</td>
	  <td><input type="text" name="Criteria3" size="50" maxlength="50" class="regular"></td>
	</tr>
	<tr><td height="5"></td></tr>
	<TR>
	  <td valign="top" class="regular">&nbsp;&nbsp;<b>Without</b> the words:</td>
	   <td><input type="text" name="Criteria4" size="50" maxlength="50" class="regular"></td>
	</tr>
<tr><td height="10"></td></tr>

</TABLE>

</td></tr>
<tr><td height="23" align="center" valign="middle">

<input type="submit" value="Search" name="Submit">&nbsp;
</td></tr>

</table>

</form> 


</BODY></HTML>