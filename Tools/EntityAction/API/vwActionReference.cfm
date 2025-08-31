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
<cfparam name="attributes.objectid" default="">


<cfquery name="Actions" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     OA.ActionFlowOrder, 
		           R.ActionDescription, 
				   OA.ActionCode, 
				   OA.ActionReferenceDate, 
				   OA.ActionReferenceNo
		FROM       OrganizationObjectAction OA INNER JOIN
                   Ref_EntityActionPublish R ON OA.ActionPublishNo = R.ActionPublishNo AND OA.ActionCode = R.ActionCode
		WHERE      OA.ObjectId = '#attributes.ObjectId#' 
		   AND     OA.ActionFlowOrder IN
                          (SELECT     MAX(ActionFlowOrder)
                            FROM          OrganizationObjectAction
                            WHERE      ObjectId = OA.ObjectId AND ActionCode = OA.ActionCode) 
			AND   R.ActionReferenceEntry = 1
        ORDER BY OA.ActionFlowOrder
		</cfquery>
				
		<tr><td height="4"></td></tr>		
		<cfoutput query="Actions">
			<tr>
			<td height="22">&nbsp;&nbsp;&nbsp;#ActionDescription#</td>
			<td>
			<table width="100%" cellspacing="0" cellpadding="0">
			<tr>
			    <td width="100">#DateFormat(actionReferenceDate,CLIENT.DateFormatShow)#</td>
				<td>#ActionReferenceNo#</td>
			</tr>
			</table>		
			</td>
			</tr>
		</cfoutput>