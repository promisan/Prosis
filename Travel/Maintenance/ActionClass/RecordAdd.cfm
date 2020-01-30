<HTML><HEAD>
	<TITLE>Entry Form</TITLE>
</HEAD><body bgcolor="#FFFFFF" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>">

<cf_PreventCache>
 
<CFFORM action="RecordSubmit.cfm" method="post">

<table width="100%">
<TD><font size="4"><b>Add Vacancy Class:</b></font></TD>
<TD></TD>
<TD><img src="../../../warehouse.JPG" alt="" width="30" height="30" border="1" align="right"></TD>
</table>
<hr>

<!--- Entry form --->

<table width="90%" border="0" cellspacing="0" cellpadding="0">

   <!--- Field: Id --->
    <TR>
    <TD class="Header">&nbsp;Id:</TD>
    <TD>&nbsp;
		<cfinput class="regular" type="Text" name="VacancyActionClassId" message="Please enter an action class Id" required="Yes" size="2" maxlength="2">
	</TD>
	</TR>
	
	   <!--- Field: Description --->
    <TR>
    <TD class="Header">&nbsp;Description:</TD>
    <TD>&nbsp;
		<cfinput class="regular" type="Text" name="Description" message="Please enter a action class description" required="Yes" size="45" maxlength="50">
	</TD>
	</TR>

 
    <!--- Field: Operational--->
    <TR>
    <TD class="Header">&nbsp;Operational:</TD>
    <TD>&nbsp;
		<cfinput class="regular" type="checkbox" name="ListingOrder" checked="yes" required="No" value="1">
	</TD>
	</TR>

</TABLE>
<HR>	
<input class="input.button1" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
<input class="input.button1" type="submit" name="Insert" value=" Submit ">
</CFFORM>

</BODY></HTML>