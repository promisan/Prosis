<HTML><HEAD>
    <TITLE>Barscan - Upload File</TITLE>
</HEAD><BODY bgcolor="#FFFFFF">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<table width="100%">
<TD><font size="4"><b>Upload Barscan file</b></font>
</TD>
<TD><img src="../../warehouse.JPG" alt="" width="30" height="30" border="1" align="right"></TD>
</table>
<hr>

<P>

<FORM action="Barscan_FileAction.cfm" method="post" enctype="multipart/form-data">

<TABLE cellspacing=10>

<TR>
	<TD valign="top" nowrap><B><cf_tl id="Upload as"></B>:</TD>
	<TD valign="top">
		<INPUT type="text" name="ServerFile" id="ServerFile" size="20"> <BR>
		<FONT size=-1>
		- Use this field if you want to change the name of the file
		stored in the library. Otherwise leave blank.
		</FONT>
	</TD>
</TR>

<TR>
	<TD valign="top" nowrap><B><cf_tl id="File"></B>:</TD>
	<TD valign="top">
		<INPUT type="file" name="UploadedFile" id="UploadedFile" size=30> <BR>
		<FONT size=-1>
		- Use the 'Browse...' button to locate the file on your local file system.
		</FONT>
	</TD>
</TR>

<TR>
	<TD colspan=2 align="center">
		<INPUT type="submit" value="               Upload File              ">
	</TD>
</TR>

</TABLE>

</FORM>
<hr>

[<b><font face="Tahoma" size="2"><A href="Barscan_FileLibrary.cfm"><cf_tl id="Library"></A></font></b>]

</BODY></HTML>