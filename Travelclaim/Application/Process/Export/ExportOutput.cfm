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
<HTML><HEAD>
<TITLE>Export output file</TITLE>
</HEAD><body leftmargin="0" topmargin="0" rightmargin="0" bgcolor="FfFfFf" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfquery name="Parameter" 
  datasource="appsTravelClaim" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT *
    FROM   Parameter
</cfquery>

<cfquery name="Export" 
  datasource="appsTravelClaim" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT *
    FROM   stExportFile
	WHERE ExportNo = '#URL.ID#'
</cfquery>

<cffile action="READ" file="#Parameter.DocumentLibrary#/Export/#Export.ExportFileId#" variable="Content">

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

	<tr><td height="26" bgcolor="f4f4f4">
	<cfoutput>
	&nbsp;<img src="#SESSION.root#/Images/report1.gif" alt="" border="0" align="absmiddle">
	&nbsp;
	Export file No: <b>#Export.ExportNo#</b>
	&nbsp;
	Records:<b> #Export.SummaryLines#</b>
	&nbsp;
	Created by: <b>#Export.OfficerFirstName# #Export.OfficerLastName#</b> on: <b>#dateformat(Export.created, CLIENT.DateFormatShow)#
	</cfoutput></td></tr>
	<tr><td height="1" bgcolor="C0C0C0"></td></tr>
	<tr>
		<td align="center" width="99%">
		<textarea class="regular" style="width:100%;height:99%"><cfoutput>#content#</cfoutput>
  	    </textarea></td>
	</tr>
	<tr><td height="23" align="center"><input type="button" value="Close" class="button10g" name="close" onClick="window.close()"></td></tr>
	

</table>