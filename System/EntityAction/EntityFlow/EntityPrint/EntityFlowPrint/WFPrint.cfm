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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>


<cfdocument 
   backgroundvisible = "yes"
   format = "PDF"
   fontembed = "yes"
   marginbottom = "0.25"
   marginleft = "0.25"
   marginright = "0.25"
   margintop = "0.25"
   orientation = "portrait">

<link href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="../../../../print.css" media="print">

<cfdocumentitem type="header">
	<cfif cfdocument.currentpagenumber neq 1>
	<table width="100%" align="center" cellspacing="0" cellpadding="0">
		<tr><td width="10" height="10"></td><td></td></tr>
		<tr>
		<td align="Right">ENTITY:<td>&nbsp;&nbsp;#Entity.EntityDescription# [#Entity.EntityCode#]</b></td>
		</tr>
		<td align="Right">CLASS:<td>&nbsp;#Class.EntityClassName# [#URL.EntityClass#]</b></td>
		</tr>
	</table>	
	</cfif>
</cfdocumentitem>

<cfinclude template="FlowViewPrint.cfm">

</cfdocument>


</body>
</html>
