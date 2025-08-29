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
<cfparam name="url.action" default="">
<cfparam name="url.panelType" default="Junta">

<cfif url.action eq "Insert">

	<cfquery name="Member" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * FROM stJobreviewPanel
	  WHERE JobNo  =  '#url.jobno#'
	  AND PersonNo = '#URL.PersonNo#'
	  AND MemberRole = '#URL.panelType#' 
	</cfquery>
	
	<cfif Member.recordcount eq "0">

		<cfquery name="Employee" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO stJobreviewPanel
		    (JobNo,PersonNo,MemberRole,OfficerUserId,OfficerLastName,OfficerFirstName)
		VALUES(	
		'#URL.JobNo#',
		'#URL.PersonNo#',
		'#URL.panelType#',
		'#SESSION.acc#',
		'#SESSION.last#',
		'#SESSION.first#') 
		</cfquery>
	
	</cfif>
	
<cfelseif url.action eq "delete">	

	<cfquery name="Employee" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM stJobreviewPanel
	  WHERE JobNo  =  '#url.jobno#'
	  AND PersonNo = '#URL.PersonNo#'
	  AND MemberRole = '#URL.panelType#'
	</cfquery>
	
</cfif>

<cfquery name="Employee" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT F.*, E.*
	   FROM stJobreviewPanel F, Employee.dbo.Person E
	   WHERE F.JobNo  =  '#url.jobno#'
	   AND   F.PersonNo  =  E.PersonNo
 	   AND MemberRole = '#URL.panelType#' 
	</cfquery>
	
    <table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding navigation_table">			
    
	<tr class="labelit linedotted">
	   <td></td>
	   <td></td>
       <td height="15"><cfoutput>#CLIENT.IndexNoName#</cfoutput></td>
	   <TD height="15">Name</TD>
	   <TD height="15">Gender</TD>
	   <TD height="15">Nationality</TD>
	   <td width="20%" height="15">Role</td>  
	   <td></td>   
   </TR>
      
   <cfif employee.recordcount eq "0">
     <tr>
      <td colspan="8" class="labelit" align="center">There are no employees to show in this view.</td>
   </tr>
   </cfif>
   			   
   <cfoutput query="Employee">
  
   <tr class="labelit linedotted navigation_row">
   	  <td height="20">#currentrow#</td>
	  <td>
	  <cf_img icon="edit" onclick="EditPerson('#PersonNo#')">
	  </td>
      <td>#IndexNo#</td>
	  <td>#FirstName# #LastName#</td>
	  <td>#Gender#</td>
	  <td>#Nationality#</td>
	  <td>#MemberRole#</td>
	  <td>
	  <cf_img icon="delete" onclick="ColdFusion.navigate('#SESSION.root#/procurement/application/quote/reviewPanel/ReviewPanelMember.cfm?action=delete&JobNo=#URL.JobNo#&PersonNo=#PersonNo#','member')">	
	  </td>
   </tr> 
 
   <cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  DISTINCT J.JobNo, J.CaseNo, J.CaseName
		FROM    stJobReviewPanel F INNER JOIN
	            Job J ON F.JobNo = J.JobNo
		WHERE   F.JobNo  !=  '#url.jobno#'
		AND     F.PersonNo = '#PersonNo#'
		AND     J.ActionStatus = 1
 	</cfquery>
   
   <cfloop query="Check">
	   <tr>
	   	<td></td>
	    <td><a href="javascript:ProcQuote('#JobNo#','view')"><cfif CaseNo eq "">#CaseNo#<cfelse>#JobNo#</cfif></a></td> 
		<td>#CaseName#</td>
	   </tr>
   </cfloop>
     
   </CFOUTPUT>   
   
   </table>
   
   <cfset ajaxOnLoad("doHighlight")>
   