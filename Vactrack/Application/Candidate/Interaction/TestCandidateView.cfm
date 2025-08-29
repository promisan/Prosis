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
<cfparam name="url.actionsessionid" default="">

<cfquery name="action" 
	 datasource="appsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT  *
		FROM    OrganizationObjectAction OA INNER JOIN OrganizationObject O ON OA.ObjectId = O.ObjectId
		WHERE   ActionId = '#url.actionid#'
</cfquery>

<cfquery name="websession" 
	 datasource="appsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
     SELECT    DC.DocumentNo, DC.PersonNo, DC.LastName, DC.FirstName, S.ActionId, S.SessionDocumentId, 
	           S.SessionPlanStart, S.SessionPlanEnd, S.SessionActualStart, S.SessionActualEnd, S.SessionIP, 
               S.SessionPasscode, S.Operational, S.Created, C.ActionCode
	 FROM      Vacancy.dbo.DocumentCandidate AS DC INNER JOIN
               Vacancy.dbo.DocumentCandidateReview AS C ON DC.DocumentNo = C.DocumentNo AND DC.PersonNo = C.PersonNo LEFT OUTER JOIN
               OrganizationObjectActionSession AS S ON C.ReviewId = S.EntityReference
	WHERE      DC.DocumentNo = '#action.ObjectKeyValue1#' <!--- we could inspect Ref_Entity to set here the correct value for the ObjectkeyValue1..4 --->
	AND        C.ActionCode  = '#action.actioncode#'
	AND        DC.EntityClass IS NULL 
	AND        DC.Status IN ('1', '2')
</cfquery>

<cf_divscroll>

<table width="95%" align="center" class="navigation_table">

<tr class="labelmedium line">
   <td style="padding-left:3px"><cf_tl id="Candidate"></td>
   <td style="padding-left:3px"><cf_tl id="Active"></td>
   <td style="padding-left:3px" colspan="2"><cf_tl id="Session availability"></td>  
   <td style="padding-left:3px"><cf_tl id="First Opened"></td>
   <td style="padding-left:3px"><cf_tl id="IP"></td>
   <td><cf_tl id="Last Submitted"></td>  
</tr>

<cfoutput query="websession">
	
	<tr class="labelmedium navigation_row line" style="height:32px">
	   <td style="padding-left:3px;font-size:15px">#FirstName# #LastName#</td>
	   <td align="center" style="font-size:15px"><cfif operational eq "1"><cf_tl id="Yes"></cfif></td>
	   <td style="padding-left:3px;background-color:##e1e1e180;font-size:15px">#dateformat(sessionplanstart,client.dateformatshow)# #timeformat(sessionplanstart,"HH:MM")#</td>
	   <td style="padding-left:3px;background-color:##e1e1e180;font-size:15px">#dateformat(sessionplanend,client.dateformatshow)# #timeformat(sessionplanend,"HH:MM")#</td>
	   <td style="font-size:15px;padding-left:3px">#dateformat(sessionactualstart,client.dateformatshow)# #timeformat(sessionactualstart,"HH:MM")#</td>
	   <td style="font-size:15px">#sessionIP#</td>
	  <td style="font-size:15px">#dateformat(sessionactualend,client.dateformatshow)# #timeformat(sessionactualend,"HH:MM")#</td>
	</tr>

</cfoutput>

<tr><td colspan="7" style="padding-top:4px" align="center" >
<input class="button10g" value="Close" onclick="ProsisUI.closeWindow('testview')" type="button" name="Close"></td></td></tr>
</table>

</cf_divscroll>

<cfset ajaxonload("doHighlight")>



