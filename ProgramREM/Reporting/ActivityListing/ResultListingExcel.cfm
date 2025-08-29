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
<cfcontent type="application/msexcel">
<cfheader name="Content-Disposition" value="filename=reviewpanel.xls">

<cfparam name="URL.Lay" default="Components">
<cfparam name="URL.ID3" default="All">

<cfparam name="URL.page" default="1">
<cfset #CLIENT.sort# = #URL.Sort#>

<cfquery name="SearchAction" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM ProgramSearch
  WHERE SearchId = '#URL.ID1#'
</cfquery>
  
<cfset cond = "">

<cfswitch expression="#URL.ID#">

<cfcase value="ORG">
 <cfset cond = "AND M.MasterOrgUnit = '#URL.ID2#'">
 <cfif #URL.ID3# neq "All">
     <cfset cond = cond & " AND Pe.Period = '#URL.ID3#'">
 </cfif>
</cfcase>

</cfswitch>

<cfswitch expression = #URL.Sort#>
     	 
     <cfcase value="OrgUnitCode">  <cfset orderby = "P.OrgUnitCode"></cfcase>
    
</cfswitch>

  
<!--- Query returning search results --->

<cfquery name="SearchResultA" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT R.ProgramId
  FROM ProgramSearchResult R, ProgramPeriod Pe, Program P, ProsisOLAP.dbo.Organization M
  WHERE R.SearchId = #URL.ID1#
  AND   R.ProgramId = Pe.ProgramId
  AND   Pe.ProgramCode = P.ProgramCode
  AND   P.OrgUnit = M.OrgUnit
        #PreserveSingleQuotes(cond)#
     </cfquery>
   
   <cfquery name="SearchResult" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT DISTINCT Pe.ProgramCode, P.ProgramName, Pe.Period, P.Reference, P.OfficerFirstName, P.OfficerLastName, P.Created, P.OrgUnitCode
  FROM ProgramSearchResult R, ProgramPeriod Pe, #CLIENT.LanPrefix#Program P, ProsisOLAP.dbo.Organization M
  WHERE R.SearchId = #URL.ID1#
  AND   R.ProgramId = Pe.ProgramId
  AND   Pe.ProgramCode = P.ProgramCode
  AND   P.OrgUnit = M.OrgUnit
  AND   (P.ParentCode is NULL or P.ParentCode = '')
         #PreserveSingleQuotes(cond)#
  ORDER BY #orderby#		 
     </cfquery>

<HTML><HEAD>
    <TITLE>Search - Result Listing Excel</TITLE>

</HEAD><body>

<form method="post" name="result">

<input type="hidden" name="ID" value="<cfoutput>#URL.ID#</cfoutput>">
<input type="hidden" name="ID1" value="<cfoutput>#URL.ID1#</cfoutput>">
<input type="hidden" name="ID2" value="<cfoutput>#URL.ID2#</cfoutput>">
<input type="hidden" name="ID3" value="<cfoutput>#URL.ID3#</cfoutput>">
<input type="hidden" name="page1" value="<cfoutput>#URL.Page#</cfoutput>">
<input type="hidden" name="lay" value="<cfoutput>#URL.Lay#</cfoutput>">

<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr>
    <td colspan="6">&nbsp;
	
    	<cfoutput>
		Search: <b>#SearchAction.OfficerFirstName# #SearchAction.OfficerLastName#</b> &nbsp;Date: <b>#DateFormat(SearchAction.Created)#</b>
    	</cfoutput>
	   		
	</td>
	
 
  </tr>
  
  <tr>  
  
  <tr>
  
    
  <td colspan="6">
  
  <table width="100%" border="0" bgcolor="#C9D3DE">
    
  <tr>
  <td width="6">&nbsp;

  <cfoutput>Name: <b>#SearchAction.Description#</b> &nbsp;Matching programs/components: <b>#SearchResultA.recordcount#</b> </cfoutput>
   
  </td>
    
  </tr>
   </table>
  
  </td>
  
  </tr>
  <td width="100%" colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<TR>
    <td width="8%" bgcolor="#FFFF00">Code</td>
    <td width="32%" bgcolor="#FFFF00" colspan="2">Program Name</td>
    <TD width="27%" bgcolor="#FFFF00">Reference</TD>
    <TD width="20%" bgcolor="#FFFF00">Entered by</TD>
    <TD width="10%" bgcolor="#FFFF00">Initated</TD>

</TR>
    
<cfset currrow = 0>   
   
<cfoutput query="SearchResult" group="#URL.Sort#">
   
<TR>
<TD valign="top">&nbsp;#SearchResult.ProgramCode#</TD>
<TD valign="top" colspan="2">#SearchResult.ProgramName#</TD>
<td valign="top">#Reference#</td>
<TD valign="top">#SearchResult.OfficerFirstName# #SearchResult.OfficerLastName#</TD>
<TD valign="top">#DateFormat(SearchResult.Created, CLIENT.DateFormatShow)#</TD>

</TR>

<!--- Begin new block COMPONENTS--->


<cfif #URL.Lay# eq "Components">

	<cfquery name="Components" 
	datasource="AppsProgram" >
	SELECT P.*, O.OrgUnitName, Pe.Period, Pe.ProgramId
    From #CLIENT.LanPrefix#Program P, ProgramPeriod Pe, ProgramSearchResult R, 
			#CLIENT.LanPrefix#Organization.dbo.Organization O
	WHERE  R.SearchId     = #URL.ID1#
	AND    R.ProgramId    = Pe.ProgramId
	AND    Pe.ProgramCode = P.ProgramCode
	AND    P.ParentCode = '#SearchResult.ProgramCode#'
	AND    Pe.Period      = '#SearchResult.Period#'
	AND    O.OrgUnit = P.OrgUnit
	ORDER BY ListingOrder
	</cfquery>

  <cfloop query="Components">
   
   <tr bgcolor="f6f6f6">
     <TD >&nbsp;#Components.ProgramCode#</TD>
	<td colspan="3" >#Components.ProgramName#</td>
	<td colspan="2" align="left" >&nbsp;#OrgUnitName#</td>
   </tr>
	
	
			<cfquery name="SubComponents" 
			datasource="AppsProgram" >
			SELECT P.*, O.OrgUnitName, Pe.Period, Pe.ProgramId
            From #CLIENT.LanPrefix#Program P, ProgramPeriod Pe, ProgramSearchResult R, 
					#CLIENT.LanPrefix#Organization.dbo.Organization O
        	WHERE  R.SearchId     = #URL.ID1#
	        AND    R.ProgramId    = Pe.ProgramId
        	AND    Pe.ProgramCode = P.ProgramCode
         	AND    P.ParentCode   = '#Components.ProgramCode#'
         	AND    Pe.Period      = '#Components.Period#'
          	AND    O.OrgUnit = P.OrgUnit
           	ORDER BY ListingOrder
			</cfquery>
			
			<cfloop query="SubComponents">
			
		   <tr bgcolor="FFFFCE">
			
		   	 <TD class="regular">&nbsp;&nbsp;&nbsp;#Components.ProgramCode#</TD>
			<td colspan="3" >#Components.ProgramName#</td>
			<td colspan="2" align="left" >&nbsp;&nbsp;#SubComponent.OrgUnitName#</td>
		    </tr>
						
		  </cfloop> 
	
     
  </cfloop> 
  
</cfif>

<!--- End new block --->



</cfoutput>

<tr><td height="10" colspan="6" bgcolor="#000000"></td></tr>
</TABLE>

</td></tr>

</table>

</td></tr>

</Table>

</form>

</BODY></HTML>