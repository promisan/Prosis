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
<cfoutput>

<table width="100%" height="54" cellspacing="0" cellpadding="0" 
 align="center" background="#SESSION.root#/Images/BG_Header.jpg" style="background-repeat:repeat-x">
<tr><td>

<table width="98%" height="54" cellspacing="0" cellpadding="0" align="center" id="banner">

<!---

      <cfquery name="Employee" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
	    FROM Person
	    WHERE PersonNo = '#URL.ID#'
	  </cfquery>
				
	 <tr>
	    <td valign="bottom">		
		<font face="Verdana" size="4">
			#Employee.firstName# #Employee.LastName#					
		</font>
	    </td>	
	 </tr>
	 	
	  <cfquery name="LastGrade" 
	     datasource="AppsEmployee" 		
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">         
         SELECT   TOP 1 *
         FROM     PersonContract
         WHERE    PersonNo = '#URL.ID#'
		 AND      ActionStatus != '9'
         ORDER BY DateEffective DESC
      </cfquery>      	
	  
	  <cfquery name="PersonAssignment" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT  TOP 1 A.*, P.SourcePostNumber, O.Mission, O.OrgUnitName, M.MissionOwner
		    FROM    PersonAssignment A, 
			        Position P,
			        Organization.dbo.Organization O, 
				    Organization.dbo.Ref_Mission M
			WHERE   A.OrgUnit = O.OrgUnit
			  AND   A.PersonNo = '#URL.ID#'
			  AND   M.Mission = O.Mission 
			  AND   A.PositionNo = P.PositionNo
			  AND   A.AssignmentStatus IN ('0','1')
			  ORDER BY A.DateEffective DESC
	    </cfquery>
	
	<tr>
         <td>&nbsp;&nbsp;&nbsp;<cfif personassignment.recordcount eq "0">No assignment info found.<cfelse>#PersonAssignment.Mission# #PersonAssignment.OrgUnitName#</cfif> | #LastGrade.ContractLevel# / #LastGrade.ContractStep#</td>   
    </tr>   
	
	--->
	
</table>

</td></tr>

</table>

</cfoutput>