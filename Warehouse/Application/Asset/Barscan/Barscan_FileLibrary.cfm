<!--
    Copyright © 2025 Promisan B.V.

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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<!--- parameters --->

<CFSET LibraryDirectory = #SESSION.rootPath#&"\asset\barscanFiles">

<HTML><HEAD>
    <TITLE>Barscan - Library Content</TITLE>
</HEAD><BODY bgcolor="#FFFFFF">

<table width="100%">
<TD><font size="4"><b><cf_tl id="Barscan File Library"></b></font>
</TD>
<TD><img src="../../warehouse.JPG" alt="" width="30" height="30" border="1" align="right"></TD>
</table>

<CFDIRECTORY
	action="LIST"
	directory="#LibraryDirectory#"
	name="GetFiles"
>


<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
<TR bgcolor="6699cc">
	<TD width=300><font color="#FFFFFF" face="Tahoma" size="2"><cf_tl id="File"></font></TD>
	<TD><font color="#FFFFFF" face="Tahoma" size="2"><cf_tl id="Size"></font></TD>
	<TD><font color="#FFFFFF" face="Tahoma" size="2"><cf_tl id="Last Modified"></font></TD>
</TR>

<CFSET Row = 1>
<CFOUTPUT query="GetFiles">
<CFIF Type is "FILE">
<TR bgcolor="#IIf(Row Mod 2, DE('FFFFFF'), DE('FFFFCF'))#">
	<TD width=300>
		<font face="Tahoma" size="2">
		<A href="Barscan_OpenFile.cfm/#Replace(Name,' ','','ALL')#?ServerFile=#URLEncodedFormat(Name)#">#Name#</A>
        </font>
	</TD>
	<TD><font face="Tahoma" size="2">#Size#</font></TD>
	<TD nowrap><font face="Tahoma" size="2">#DateLastModified#</font></TD>

	<CFSET Row = Row + 1>

</TR>
</CFIF>
</CFOUTPUT>

<hr>

<CFOUTPUT>
<TR bgcolor="#IIf(Row Mod 2, DE('FFFFFF'), DE('FFFFCF'))#">
	<TD colspan=3>[<b><font face="Tahoma" size="2"><A href="Barscan_FileForm.cfm"><cf_tl id="Upload New File"></A></font></b>]
</TR>
</CFOUTPUT>

</TABLE>

</BODY></HTML>