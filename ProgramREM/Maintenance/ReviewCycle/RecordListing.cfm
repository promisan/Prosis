<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop html="No" jquery="Yes">

<table width="100%" height="100%" align="center">

<cfset Page         = "0">
<cfset add          = "1">
<cfset save         = "0"> 

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<tr><td valign="top" style="height:100%">

	<form name="filters" id="filters" style="height:100%">

	<cf_divscroll>	

    <table width="98%" align="center">
	
	<cf_tl id = "Do you want to remove this review cycle and all of its details ?" var = "vPurgeMsg">
	
	<cfoutput>
	
		<script>
		
			function recordadd(grp) {
				ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&fmission="+document.getElementById("fmis").value+"&ID1=", "AddPromotion", "left=30, top=30, width= 900, height= 850, toolbar=no, status=yes, scrollbars=no, resizable=yes");
			}
			
			function recordedit(id1) {
				ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&fmission="+document.getElementById("fmis").value+"&ID1=" + id1, "EditPromotion");
			}
			
			function recordpurge(id1,mis) {
				if (confirm('#vPurgeMsg#')) {
					ptoken.navigate('RecordPurge.cfm?idmenu=#url.idmenu#&id1='+id1+'&fmission='+mis,'divListing');
				}
			}
			
			function applyfilter(f,reset) {
			    _cf_loadingtexthtml='';	
				ptoken.navigate('RecordListingDetail.cfm?idmenu=#url.idmenu#&fmission='+document.getElementById('fmis').value+'&filter='+f,'divListing');	
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
		
	<tr><td valign="top">
			
		<table width="99%" align="center" class="navigation_table">
		
			<tr class="labelmedium2 line" style="height:35px">
								
					<td>
					<select class="regularxxl" name="fmis" id="fmis" onchange="javascript: applyfilter('active',1);">
						<option value="">-- <cf_tl id="Any"> --
						<cfoutput query="qMis">
							<option value="#Mission#">#Mission#
						</cfoutput>
					</select>
					
					</td>
					<td align="right" class="labelmedium2">
					<label style="font:16px" onclick="javascript: applyfilter('all',0);"><input class="radiol" type="Radio" name="filter" id="filter" value="all"> <cf_tl id="All"> &nbsp;</label>
					<label style="font:16px" onclick="javascript: applyfilter('active',0);"><input class="radiol" type="Radio" name="filter" id="filter" value="active" checked> <cf_tl id="Active"> &nbsp;</label>
					<label style="font:16px" onclick="javascript: applyfilter('expired',0);"><input class="radiol" type="Radio" name="filter" id="filter" value="expired"> <cf_tl id="Expired"> </label>
					</td>
			</tr>
				
		</table>		
	
		</td>
	</tr>	
	
	<tr><td><cf_securediv id="divListing" bind="url:RecordListingDetail.cfm?idmenu=#url.idmenu#&fmission=&filter=active"/></td></tr>
	
	</table>
	
	</cf_divscroll>
	
	</form>
		
</td>

</tr>

</table>
	

