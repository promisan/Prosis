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
    <TITLE>City search</TITLE>
   <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
   
</HEAD><body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" onLoad="window.focus()">

</p>
<form action="KeyWordSearchResult.cfm" method="post" target="result">


<cfparam name="URL.FormName" default="">
<cfparam name="URL.fldid" default="">
<cfparam name="URL.Filter" default="">

<cfoutput>
<INPUT type="hidden" name="FormName" id="FormName"      value="#URL.FormName#">
<INPUT type="hidden" name="ExperienceId" id="ExperienceId"  value="#URL.fldid#">
<INPUT type="hidden" name="Filter" id="Filter"       value="#URL.Filter#">
</cfoutput>

<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="e4e4e4">

<tr>
<td height="22" class="top3nd"><b>&nbsp;<font face="Verdana">Function Builder Keywords</b>
</td></tr>

<tr><td>

    <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
	<tr><td height="3"></td></tr>
 	
	<TR>
	<TD>Name:</TD>
	
	<TD>
	
	<INPUT type="text" name="Experience" id="Experience" size="50"> 	
	</TD>
	</TR>
			
	<cfquery name="ExperienceClass" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   DISTINCT C.ExperienceClass, C.Description
		FROM     Ref_Experience R INNER JOIN
                 Ref_ExperienceClass C ON R.ExperienceClass = C.ExperienceClass
		WHERE    C.Parent = '#URL.Filter#' 
	</cfquery>	

	<TR>
	<TD>Area:</TD>
	<TD>
	
		<select name="Class" id="Class">
		    <option value="">-------------  All  ------------</option>
			<cfoutput query="ExperienceClass">
			<option value="#ExperienceClass#">#Description#</option>
			</cfoutput>
		</select>
		
	</TD>
	</TR>
	
	<tr><td height="2"></td></tr>
		
	<tr><td height="1" colspan="3" bgcolor="silver" align="right"></td></tr>
	
	<tr><td height="20" colspan="3" align="right">
	
	<input class="buttonNav" type="submit" name"Search" id="Search" value="      Submit Search      ">
	
	</td></tr>
	
	<tr><td height="5"></td></tr>
	

</table>	

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">

<TR>
        <TD>
		   <iframe src="KeywordMessage.cfm" name="result" id="result" width="100%" height="430" marginwidth="0" marginheight="0" hspace="0" vspace="0" align="left" scrolling="no" frameborder="0"></iframe>
	    </TD>
</TR>

</table>

</FORM>

</BODY></HTML>