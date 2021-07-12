
<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop html="No" jquery="Yes">

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">

<table width="98%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

<tr><td>
<cfinclude template = "../HeaderMaintain.cfm"> 	
</td>
</tr>

<cfoutput>

	<script>
	
		function recordadd(grp) {
			ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&fmission="+document.getElementById("fmis").value+"&ID1=", "AddPromotion", "left=80, top=80, width=960, height= 800, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}
		
		function recordedit(id1) {
			ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&fmission="+document.getElementById("fmis").value+"&ID1=" + id1, "EditPromotion");
		}
		
		function recordpurge(id1,mis) {
			if (confirm('Do you want to remove this promotion and all of its details ?')) {
				ptoken.navigate('RecordPurge.cfm?idmenu=#url.idmenu#&id1='+id1+'&fmission='+mis,'divListing');
			}
		}
		
		function applyfilter(f,reset) {
			ptoken.navigate('RecordListingDetail.cfm?idmenu=#url.idmenu#&fmission='+document.getElementById('fmis').value+'&filter='+f,'divListing');	
			if (reset == 1) filters.filter[1].checked = true;
		}
	
	</script>

</cfoutput> 

<cfquery name="qMis" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_ParameterMission
	WHERE 	Mission IN (SELECT Mission 
                		FROM Organization.dbo.Ref_MissionModule 
		  				WHERE SystemModule = 'Warehouse')
</cfquery>

<tr>
	<table width="95%" align="center">
		<form name="filters" id="filters">
		<tr>
			
			<td>
			<select class="regularxl" name="fmis" id="fmis" onchange="javascript: applyfilter('active',1);">
				<option value="">-- Any --
				<cfoutput query="qMis">
					<option value="#Mission#">#Mission#
				</cfoutput>
			</select>
		</td>
		<td align="right" class="labelmedium">
			<label style="font:16px" onclick="javascript: applyfilter('all',0);"><input class="radiol" type="Radio" name="filter" id="filter" value="all"> All &nbsp;</label>
			<label style="font:16px" onclick="javascript: applyfilter('active',0);"><input class="radiol" type="Radio" name="filter" id="filter" value="active" checked> Active &nbsp;</label>
			<label style="font:16px" onclick="javascript: applyfilter('expired',0);"><input class="radiol" type="Radio" name="filter" id="filter" value="expired"> Expired</label>
		</td>
		</tr>
		</form>
	</table>	
</tr>
<tr><td height="25">&nbsp;</td></tr>
<tr>
	<td>

		<cf_securediv id="divListing" bind="url:RecordListingDetail.cfm?idmenu=#url.idmenu#&fmission=&filter=active">

	</td>
</tr>

</table>

</cf_divscroll>