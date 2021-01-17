

<cfset add          = "1">
<cfset save         = "0"> 

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>

<script>

function recordadd(grp) {
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=600, height=500, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1){
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=600, height=500, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<tr><td>

	<cf_divscroll>
	
		<table width="100%" align="center">
		
			<tr height="20">
				<td></td>
				<td style="padding-left:20px">
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
					<cfselect name="missionL" query="MissionList" value="Mission" display="Mission" queryposition="below" class="regularxxl" group="Owner">
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

</td>

</tr>

</table>



