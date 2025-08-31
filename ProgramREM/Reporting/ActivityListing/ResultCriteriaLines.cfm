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

<table width="75%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#002350">

 <tr>
    <td height="30" class="BannerN">
	  <b>&nbsp;Search criteria:</b>
	</td>
 </tr> 	
 
</table>

<cf_tableTop size="75%" omit="true">

 <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#002350">
   
  <tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="6688AA" bgcolor="F6F6F6" class="formpadding">

<TR bgcolor="6688aa">
    <td width="5%" class="top2n">&nbsp;</td>
    <TD width="20%"  class="top2n">Group</TD>
    <TD width="35%"  class="top2n">Aspect</TD>
    <TD width="35%"  class="top2n">Selected</TD>
	<TD width="5%"  class="top2n">&nbsp;</TD>
</TR>

<TR><td height="2" colspan="3" class="regular"></td></TR>

<cfoutput query="Criteria" group="ListingOrder">

<TR><td></td><td colspan="3" class="regular"><b>&nbsp;#ListingGroup#</b></td></font></TR>
<TR><td></td><td height="1" colspan="3" class="top"></td></TR>
<CFOUTPUT>
<!--- <TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('D6DEE4'))#"> --->
<TR>
    <td colspan="2"></td>
    <TD class="regular">#Description#</TD>
    <TD class="regular">#SelectDescription#</TD>
	
</TR>
</CFOUTPUT>
<TR><td height="2" colspan="3" class="regular"></td></TR>
</CFOUTPUT>
<TR>
    <td height="5" class="top2n" colspan="5"></td>
</TR>
</table>

 </td></tr>

</table>	

<cf_tableBottom size="75%">
