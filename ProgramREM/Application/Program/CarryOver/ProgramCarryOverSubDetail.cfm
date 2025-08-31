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
<cfoutput>

<cfquery name="Components2" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT   P.ProgramCode, P.ProgramName, P.Reference, P.Exist
    FROM     tmp#SESSION.acc#Program P
	WHERE    P.ParentCode = '#SubComponents.ProgramCode#'
	ORDER BY ListingOrder
	</cfquery>

  <cfloop query="Components2">
   
   <tr bgcolor="FFFFFF" class="linedotted navigation_row">
    <td bgcolor="FFFFFF"></td>
	<td width="3%" valign="top" class="header" style="padding-left:30px">
	   <!---  <img src="#SESSION.root#/Images/join.gif" alt="" width="19" height="15" border="0" align="bottom"> --->
	    </td>
    <td colspan="3" style="padding-left:40px"  class="labelit">#Components2.ProgramName#</A></td>
	<TD colspan="1" class="labelit"><cfif Reference neq "">#Components2.Reference#<cfelse>#Components2.ProgramCode#</cfif></TD>
	<td colspan="1" align="center">
	
	<cfoutput>
	
     <cfif Exist eq "0">
       <input type="checkbox" name="selected" value="#Components2.ProgramCode#">
	 <cfelse>
	   <img src="#SESSION.root#/Images/check.png" height="13" WIDTH="15" alt=""  border="0" align="bottom">
     </cfif>
	 
	</cfoutput>
	 
    </td>
	</tr>
	
	<cfset programlist = "#programlist#,#Components2.ProgramCode#">
     
  </cfloop>   

</cfoutput>   


