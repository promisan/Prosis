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
<cf_submenuLogo module="Insurance" selection="Faqs">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>General Questions and answers</title>
</head>
<body>

<cf_screentop height="100%" scroll="yes" html="No">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<table width="99%">
<tr><td height="5"></td></tr>
<tr><td width="50">

</td>
<td><font face="Verdana" size="5"></td></tr>
<tr><td height="8"></td></tr>
</table>

<cfquery name="QA" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   *
FROM      HelpProjectTopic
WHERE     ProjectCode = '#URL.ID#' 
AND       LanguageCode = '#client.Languageid#'
AND       UITextSource = 'Local'
AND       UITextAnswer is not NULL  
AND       TopicClass = 'General'
</cfquery>

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
<cfoutput query="QA"  >
<tr><td colspan="2" height="20"><font size="2" color="808080">&nbsp;#TopicName#</td></tr>
<tr><td colspan="2" height="1" bgcolor="silver"></td></tr>
<tr><td height="6"></td></tr>
<tr><td width="40" align="center">

<img src="#SESSION.root#/Images/pointer.gif"
	  	 alt="#UITextHeader#"
	     border="0"
	     align="absmiddle"
	     style="cursor: pointer;">
</td><td width="96%"><font color="0080FF">#UITextQuestion#</td></tr>
<tr><td height="5"></td></tr>
<tr><td align="center">
<img src="#SESSION.root#/Images/help_answer.gif"
	  	 alt="#UITextHeader#"
	     border="0"
	     align="absmiddle"
	     style="cursor: pointer;">
</td><td width="96%">#UITextAnswer#</td></tr>
<tr><td height="6"></td></tr>
</cfoutput>
</table>


</body>
</html>
