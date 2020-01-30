
<cf_divscroll>

<cfset add          = "1">
<cfset save         = "0"> 

<cfinclude template = "../HeaderMaintain.cfm"> 	

<cfoutput>

<script>

function recordadd(grp) {
     window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=600, height=700, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1){
     window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=600, height=700, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<table width="100%" align="center">

	<tr height="20">
		<td></td>
		<td>
			<cfquery name="MissionList"
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT 	*,
						ISNULL((SELECT MissionOwner FROM Organization.dbo.Ref_Mission WHERE Mission = M.Mission),'Undefined') as Owner
				FROM 	Ref_ParameterMission M
				ORDER BY Owner
			</cfquery>
			
			<!-- <cfform name="dummy"> -->
			<cfselect name="missionL" query="MissionList" value="Mission" display="Mission" queryposition="below" class="regularxl" group="Owner">
				<option value="">-- Any Entity --
			</cfselect>
			<!-- </cfform> -->
		</td>
	</tr>
	
	<tr height="20">
		<td colspan="2" style="padding-top:5px">
			<cfdiv id="divDetail" bind="url:RecordListingDetail.cfm?pmission={missionL}">
		</td>
	</tr>

</table>

</cf_divscroll>



