<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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