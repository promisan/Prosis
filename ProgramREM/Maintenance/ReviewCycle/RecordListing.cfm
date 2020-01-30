<!--- Create Criteria string for query from data entered thru search form --->
<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 	

<table width="98%" align="center" cellspacing="0" cellpadding="0" >

<cf_tl id = "Do you want to remove this review cycle and all of its details ?" var = "vPurgeMsg">

<cfoutput>

	<script>
	
		function recordadd(grp) {
			window.open("RecordEdit.cfm?idmenu=#url.idmenu#&fmission="+document.getElementById("fmis").value+"&ID1=", "AddPromotion", "left=30, top=30, width= 900, height= 850, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}
		
		function recordedit(id1) {
			window.open("RecordEdit.cfm?idmenu=#url.idmenu#&fmission="+document.getElementById("fmis").value+"&ID1=" + id1, "EditPromotion", "left=30, top=30, width=900, height= 850, toolbar=no, status=yes, scrollbars=no, resizable=yes");
		}
		
		function recordpurge(id1,mis) {
			if (confirm('#vPurgeMsg#')) {
				ColdFusion.navigate('RecordPurge.cfm?idmenu=#url.idmenu#&id1='+id1+'&fmission='+mis,'divListing');
			}
		}
		
		function applyfilter(f,reset) {
			ColdFusion.navigate('RecordListingDetail.cfm?idmenu=#url.idmenu#&fmission='+document.getElementById('fmis').value+'&filter='+f,'divListing');	
			if (reset == 1) filters.filter[1].checked = true;
		}
	
	</script>

</cfoutput> 

<cfquery name="qMis" 
datasource="appsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_ParameterMission
	WHERE 	Mission IN (SELECT Mission 
                		FROM Organization.dbo.Ref_MissionModule 
		  				WHERE SystemModule = 'Program')
</cfquery>

<tr><td height="8"></td></tr>
<tr>
	<table width="95%" align="center">
		<form name="filters" id="filters">
		<tr>
			
			<td>
			<select class="regularxl" name="fmis" id="fmis" onchange="javascript: applyfilter('active',1);">
				<option value="">-- <cf_tl id="Any"> --
				<cfoutput query="qMis">
					<option value="#Mission#">#Mission#
				</cfoutput>
			</select>
		</td>
		<td align="right" class="labelmedium">
			<label style="font:16px" onclick="javascript: applyfilter('all',0);"><input class="radiol" type="Radio" name="filter" id="filter" value="all"> <cf_tl id="All"> &nbsp;</label>
			<label style="font:16px" onclick="javascript: applyfilter('active',0);"><input class="radiol" type="Radio" name="filter" id="filter" value="active" checked> <cf_tl id="Active"> &nbsp;</label>
			<label style="font:16px" onclick="javascript: applyfilter('expired',0);"><input class="radiol" type="Radio" name="filter" id="filter" value="expired"> <cf_tl id="Expired"> </label>
		</td>
		</tr>
		</form>
	</table>	
</tr>
<tr><td height="25">&nbsp;</td></tr>
<tr>
	<td>

		<cfdiv id="divListing" bind="url:RecordListingDetail.cfm?idmenu=#url.idmenu#&fmission=&filter=active">

	</td>
</tr>

</table>

</cf_divscroll>