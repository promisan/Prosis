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
<cfparam name="url.layout" default="window">

<cfif url.layout eq "window">
	<cf_screentop height="100%" scroll="Yes" label="HR Portal Users" banner="yellow" layout="webapp" jquery="yes">
<cfelse>
	<cf_screentop html="no" jquery="yes">
</cfif>

<script>
	function getReviewer(id,mission) {
		if ($.trim($('#revDetail_'+id).html()) == '') {
			ColdFusion.navigate('getReviewer.cfm?id='+id+'&mission='+mission+'&mode=table', 'revDetail_'+id);
		} else {
			$('#revDetail_'+id).html('');
		}
	}
</script>

<cf_dialogStaffing>
<cf_PresentationScript>

<cfquery name="Get" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT	Pos.Mission,
				ISNULL(ORoot.OrgUnit, PA.OrgUnit) as RootOrgUnit,
				ISNULL(ORoot.OrgUnitName, O.OrgUnitName) as RootOrgUnitName,
				PA.OrgUnit,
				O.OrgUnitName,
				U.Account, 
				P.*
		FROM	UserModule UM
				INNER JOIN UserNames U
					ON UM.Account = U.Account
				INNER JOIN Employee.dbo.Person P
					ON U.PersonNo = P.PersonNo
				INNER JOIN Employee.dbo.PersonAssignment PA
					ON P.PersonNo = PA.PersonNo
				INNER JOIN Employee.dbo.Position Pos
					ON PA.PositionNo = Pos.PositionNo
				INNER JOIN Organization.dbo.Organization O
					ON PA.OrgUnit = O.OrgUnit
				LEFT OUTER JOIN Organization.dbo.Organization ORoot
					ON O.HierarchyRootUnit = ORoot.OrgUnitCode
					AND	O.Mission = ORoot.Mission
					AND O.MandateNo = ORoot.MandateNo
		WHERE	UM.SystemFunctionId = 'D6C5F1C5-E1E8-9028-4DC7-4CCB0EC60283' --hr portal
		AND		UM.Status <> '9'
		AND		GETDATE() BETWEEN PA.DateEffective AND PA.DateExpiration
		AND		PA.AssignmentStatus IN ('0','1')
		AND		PA.Incumbency > 0
		ORDER BY
				Pos.Mission,
				O.HierarchyCode,
				P.LastName,
				P.FirstName
</cfquery>

<cfquery name="GetCertifierGroup" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	AP.ActionAccessUserGroup, 
				U.*
		FROM	Ref_EntityActionPublish AP
				INNER JOIN System.dbo.UserNames U
					ON AP.ActionAccessUserGroup = U.Account
		WHERE	ActionCode = 'OVT003'
		AND		AP.ActionPublishNo = 
				(
					SELECT	MAX(ActionPublishNo)
					FROM	Ref_EntityActionPublish
					WHERE	ActionCode = AP.ActionCode
		)
</cfquery>

<cf_tl id="View user" var="lblUser">
<cf_tl id="View person" var="lblPerson">

<table width="98%" align="center">
	<tr><td height="10"></td></tr>
	<tr>
		<td class="labelmedium">
			<cfinvoke component = "Service.Presentation.TableFilter"  
			   method           = "tablefilterfield" 
			   filtermode       = "direct"
			   name             = "filtersearch"
			   style            = "font:16px;height:35;width:250"
			   rowclass         = "clsRow"
			   rowfields        = "ccontent">
		</td>
		<td class="labelmedium" align="right">
			<cfoutput query="GetCertifierGroup">
				OT Certifiers are given by the user group <a href="javascript:ShowUser('#Account#')" style="color:##1760A8;" title="#lblUser#">(#Account#) #LastName# #FirstName#</a>
			</cfoutput>
		</td>
	</tr>
	<tr><td height="10"></td></tr>
</table>

<cf_divScroll height="96%">

<table width="98%" align="center" class="navigation_table">
	<tr>
		<td class="labelmedium"></td>
		<td class="labelmedium"></td>
		<td class="labelmedium" width="2%"></td>
		<td class="labelmedium" width="12%"><cf_tl id="Account"></td>
		<td class="labelmedium" width="5%"><cf_tl id="Index"></td>
		<td class="labelmedium"><cf_tl id="Name"></td>
		<td class="labelmedium"><cf_tl id="Gender"></td>
		<td class="labelmedium"><cf_tl id="Nationality"></td>
		<td class="labelmedium"><cf_tl id="Birthdate"></td>
		<td class="labelmedium" width="20%"><cf_tl id="OT Reviewers"></td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr><td></td><td></td><td colspan="8" class="line"></td></tr>
	<tr><td height="5"></td></tr>
	<cfoutput query="get" group="Mission">
		<tr class="clsRow">
			<td colspan="10" class="labellarge"><b>#Mission#</b></td>
		</tr>
		<cfoutput group="RootOrgUnit">
			<tr class="clsRow">
				<td width="20px"></td>
				<td colspan="10" class="labelmedium"><i>#UCASE(RootOrgUnitName)#</i></td>
			</tr>
			<cfoutput>
				<tr class="navigation_row clsRow">
					<td class="labelit" valign="top" width="20px"></td>
					<td class="labelit" valign="top" width="20px"></td>
					<td class="labelit" valign="top">#get.currentRow#</td>
					<td class="labelit" valign="top">
						<a href="javascript:ShowUser('#URLEncodedFormat(Account)#')" style="color:##1760A8;" title="#lblUser#" class="ccontent">
							#Account#
						</a>
					</td>
					<td class="labelit" valign="top">
						<a href="javascript:EditPerson('#personNo#')" style="color:##1760A8;" title="#lblPerson#" class="ccontent">
							<cfif trim(IndexNo) eq "">#Reference#<cfelse>#Indexno#</cfif>
						</a>
					</td>
					<td class="labelit ccontent" valign="top">#UCASE(LastName)# #FirstName#</td>
					<td class="labelit ccontent" valign="top">#Gender#</td>
					<td class="labelit ccontent" valign="top">#BirthNationality#</td>
					<td class="labelit ccontent" valign="top">#dateFormat(BirthDate,client.dateformatshow)#</td>
					<td class="labelit" valign="top">
						<img 
							src="#session.root#/images/person.gif" 
							align="middle" 
							style="cursor:pointer;" 
							title="#UCASE(LastName)# #FirstName# OT Reviewers"
							onclick="getReviewer('#personNo#','#mission#')">
						<cfdiv id="revDetail_#personNo#">
					</td>
				</tr>
				<tr class="clsRow"><td></td><td></td><td colspan="8" class="linedotted"></td></tr>
			</cfoutput>
			<tr class="clsRow"><td height="5"></td></tr>
		</cfoutput>
		<tr class="clsRow"><td height="5"></td></tr>
	</cfoutput>
</table>

</cf_divScroll>
