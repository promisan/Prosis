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
<CFSET LibraryDirectory = #SESSION.rootPath#&"\asset\barscanFiles">
<CFSET IsOverwriteEnabled = "NO">

<!--- upload file with unique name --->
<CFFILE
	action="UPLOAD"
	fileField="UploadedFile"
	destination="#LibraryDirectory#\"
	nameConflict="MAKEUNIQUE"
>


<!--- new name of the uploaded file --->
<CFIF Form.ServerFile is ''>
	<CFSET NewServerFile = File.ClientFile>
<CFELSE>
	<CFSET NewServerFile = Form.ServerFile>
</CFIF>


<!--- check whether the new file name already exists in the directory --->
<CFDIRECTORY
	name="CheckFile"
	action="LIST"
	directory="#LibraryDirectory#\"
	filter="#NewServerFile#"
>
<CFIF CheckFile.RecordCount is 0
	or File.ClientFile is File.ServerFile>
	<CFSET FileAlreadyExists = "NO">
<CFELSE>
	<CFSET FileAlreadyExists = "YES">
</CFIF>


<HTML><HEAD>
    <TITLE>Barscan - File Received</TITLE>
</HEAD><BODY bgcolor="#FFFFFF">


<!--- if file name already exists and overwrite is allowed delete file and throw an error --->
<CFIF FileAlreadyExists and not IsOverwriteEnabled>

	<!--- delete file --->
	<CFSET TempFilePath = "#LibraryDirectory#\#File.ServerFile#">
	<CFFILE
		action="DELETE"
		file="#TempFilePath#"
	>
	
<table width="100%">
<TD><font size="4"><b><cf_tl id="Barscan File Library"></b></font>
</TD>
<TD><img src="../../warehouse.JPG" alt="" width="30" height="30" border="1" align="right"></TD>
</table>
<hr>		

	<FONT size="+2" color="ff0000"><B><cf_tl id="File Already Exists"></B></FONT>
	<P>
	Press Back button and use different file name.

<!--- ... else rename the file --->
<CFELSE>

	<!--- rename file --->
	<CFSET SourceName = LibraryDirectory & '\' & File.ServerFile>
	<CFSET DestinationName = LibraryDirectory & '\' & NewServerFile>
	<CFFILE
		action="RENAME"
		source="#SourceName#"
		destination="#DestinationName#"
	>	
	
<table width="100%">
<TD><font size="4"><b><cf_tl id="Barscan File Library"></b></font>
</TD>
<TD><img src="../../warehouse.JPG" alt="" width="30" height="30" border="1" align="right"></TD>
</table>
<hr>	

	<FONT size="+2"><B><cf_tl id="File Received"></B></FONT>
	<P>
	File was successfully received.
	<hr>
	<P>
	[<b><font face="Tahoma" size="2"><A href="Barscan_FileLibrary.cfm"><cf_tl id="Library"></A></font></b>]
</CFIF>	

</BODY></HTML>