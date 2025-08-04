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

<cfquery name="DocParameter" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
</cfquery>

<cfquery name="Searchresult" 
datasource="appsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  O.Mission, Pos.PostGrade, Pos.PostType, O.OrgUnitName, P.FunctionNo, 
        P.FunctionDescription, P.DateEffective, P.DateExpiration, Pos.SourcePositionNo, P.AssignmentStatus
FROM    Position Pos,
        PersonAssignment P, 
        Organization.dbo.Organization O 
WHERE   P.OrgUnit = O.OrgUnit
AND     P.Source = 'VAC' 
AND     P.SourceId = '#URL.ID#' 
AND     P.SourcePersonNo = '#URL.ID1#'
AND     P.PositionNo = Pos.PositionNo
</cfquery>

<cfif #SearchResult.recordCount# neq "0">

<table width="98%" cellspacing="0" cellpadding="0" align="center"  id="assignment">

<tr><td style="padding-top:10px;">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	
    <TR bgcolor="f4f4f4" class="labelit" style="padding-top:15px; height:20px">
   	  <TD >Unit</TD>
      <TD >Postgrade</TD>
      <TD >Function</TD>
	  <TD >Position</TD>
	  <TD >Effective</TD>
      <TD >Expiration</TD>
	  <TD >Status</TD>
    </TR>	
	 	
	<cfoutput query="SearchResult">
		
	<TR style="height:20px;">
		
	<td>#Mission#-#OrgUnitName#</a></td>
    <td>#PostGrade#</a></td>
	<td>#FunctionDescription#</a></td>
	<td>#SourcePositionNo#</td>
	<td>#dateFormat(DateEffective,CLIENT.DateFormatShow)#</td>
	<td>#dateFormat(DateExpiration,CLIENT.DateFormatShow)#</td>
	<td width="70"><cfif #AssignmentStatus# eq "1">Cleared<cfelse>Not cleared</cfif></td>
	
	</tr>
	</cfoutput>  
</table>	

</td></tr>

<tr><td class="linedotted">&nbsp;</td></tr>

</table>

</cfif>
