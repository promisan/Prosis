
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
     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#&fmission=", "Add", "left=80, top=80, width= 600, height=340, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1,mis) {
     ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1 + "&fmission=" + mis, "Edit", "left=80, top=80, width=600, height=500, toolbar=no, status=yes, scrollbars=no, resizable=yes");
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