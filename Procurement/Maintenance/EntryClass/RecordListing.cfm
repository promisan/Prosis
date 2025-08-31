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
<cf_screentop html="no" jquery="yes">

<cfquery name="qMis" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_ParameterMission
	WHERE 	Mission IN (SELECT Mission 
                		FROM Organization.dbo.Ref_MissionModule 
		  				WHERE SystemModule = 'Procurement')
</cfquery>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Order Class">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="96%" border="0" bordercolor="silver" align="center" bordercolor="silver" cellspacing="0" cellpadding="0" class="formpadding">

<cfoutput>

<script>

function recordadd() {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#&fmission=", "Add", "left=80, top=80, width= 600, height=540, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1,mis) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1 + "&fmission=" + mis, "Edit", "left=80, top=80, width=700, height=600, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<tr><td height="8"></td></tr>
<tr>
	<td colspan="2">
		<table>
			<tr>
				<td>
				<select class="regularxl" name="fmis" id="fmis">
					<option value="">-- Not filtered --					
					<cfoutput query="qMis">
						<option value="#Mission#">#Mission#
					</cfoutput>
					<option value="[NOT ASSIGNED]">NOT ASSIGNED
				</select>
				</td>
			</tr>
		</table>
	</td>
</tr>

<tr>
	<td colspan="2">
		<cfdiv id="divListing" bind="url:RecordListingDetail.cfm?idmenu=#url.idmenu#&fmission={fmis}">
	</td>
</tr>

</TABLE>

</cf_divscroll>