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
    <TITLE>Employee Inquiry</TITLE>
    <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
</HEAD><body onLoad="window.focus()">

<b><font face="BondGothicLightFH">


<cfquery name="Criteria" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT *
	 FROM ProgramSearchLine A, Ref_SearchClass C
	 WHERE SearchId = '#URL.ID#'
	 AND A.SearchClass = C.SearchClass
	 ORDER BY ListingOrder, ListingGroup 
</cfquery>	

<table>
<tr><td height="10"></td></tr>
</table>

<table width="85%" border="1" cellspacing="0" cellpadding="0" align="center">

  <tr>
    <td height="20" class="regular">
	  <b>&nbsp;Program/Project search criteria:</b>
	</td>
 </tr> 	
   
</table>

<cf_tabletop size="85%" omit="true">   

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="6688AA" class="formpadding">

<!---
<TR>
    <td width="5%" class="top4n">&nbsp;</td>
    <TD width="15%"  class="top4n">Group</TD>
    <TD width="25%"  class="top4n">Aspect</TD>
    <TD width="50%"  class="top4n">Selected</TD>
	<TD width="5%"  class="top4n">&nbsp;</TD>
</TR>

<TR><td height="2" colspan="3" class="regular"></td></TR>
--->

<cfoutput query="Criteria" group="ListingOrder">
<TR><td></td><td colspan="2"><b>&nbsp;#ListingGroup#</b></td>
    <td align="right" class="regular">
	<!---
	<cfif #ListingGroupEdit# eq "1">
	<a href="Search4.cfm?ID=#URL.ID#">[edit]</a>
	</cfif>
	--->
	</td>
</tr>
<TR><td></td><td height="1" colspan="3" class="top"></td></TR>
<CFOUTPUT group="SelectDescription">
<TR>
    <td colspan="2"></td>
    <TD>#Description#</TD>
    <TD><cfif #SelectDescription# eq "">ANY<cfelse>#SelectDescription#</cfif></TD>
</TR>
</CFOUTPUT>
<TR><td height="2" colspan="3" class="regular"></td></TR>
</CFOUTPUT>
</table>

<cf_tableBottom size="85%">

<p>

</BODY></HTML>