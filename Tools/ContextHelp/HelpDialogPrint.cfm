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
<cfquery name="HelpId" 
datasource="AppsSystem"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  HelpProjectTopic
	WHERE TopicId   = '#URL.TopicId#' 
</cfquery>

<cfdocument 
          format="PDF"
          pagetype="letter"
          margintop="0.2"
          marginbottom="0.2"
          marginright="0.2"
          marginleft="0.2"
          orientation="portrait"
          unit="in"
          encryption="none"
          fontembed="Yes"
          backgroundvisible="Yes">			
		  
			
	<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
	
		
	<cfoutput query="helpid">
	<table width="100%" height="100%" cellspacing="0" cellpadding="0">
	<tr><td>
	
		<table width="100%" cellspacing="0" cellpadding="0">
		<tr><td height="23">
		<font size="4">			
		&nbsp;#ProjectCode# - #TopicName#</td>
		<td align="right"></td>
		</tr>
		
		</table>
	</td></tr>
	<tr><td bgcolor="808080" height="1"></td></tr>
	<tr><td valign="top" height="95%">
	
	<table width="97%" align="center">
	<tr><td height="10"></td></tr>
	
			 
	<tr><td style="border: 1px solid silver;"></td></tr>
	<tr><td>#HelpId.UITextQuestion#</td></tr>
	<tr><td height="10"></td></tr>
	
		
	<tr><td style="border: 1px solid silver;"></td></tr>
	<tr><td>#HelpId.UITextAnswer#</td></tr>
	</table>
	
	</td>
	</tr>
	
	</table>
	
	</cfoutput>
	
</cfdocument>


