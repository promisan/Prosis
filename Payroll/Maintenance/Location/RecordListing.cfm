<!--- Create Criteria string for query from data entered thru search form --->

<cfparam name="url.layoutmode" default="missions">

<cf_divscroll>

<cfset Header = "Payroll Location">
<cfset page="0">
<cfinclude template="../HeaderPayroll.cfm">  

<cfajaximport tags="cfwindow,cfform">

<cfoutput>

<script language = "JavaScript">

function recordadd(grp) {
	window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=500, height=400, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1,mission,layoutmode) {

	window.open("RecordEdit.cfm?mission="+mission+"&layoutmode="+layoutmode+"&id1=" + id1, "Edit", "left=80, top=80, width=800, height=600, toolbar=no, status=yes, scrollbars=no, resizable=yes");

}

function recordrefresh(mission,layoutmode) {
  _cf_loadingtexthtml='';	
  ColdFusion.navigate('RecordListingDetail.cfm?idmenu=#url.idmenu#&mission='+mission+'&layoutmode='+layoutmode,'divDetail_'+mission);
}

function toggleDetail(id) {

	var control = document.getElementById('detail_'+id);

	var vClassName = 'regular';
	
	if (control.className == 'regular') {
		vClassName = 'hide';
	}
	else
	{
		vClassName = 'regular';
	}
	control.className = vClassName;
}

function changeView() {
	var control = document.getElementById('layoutview');
	window.location = 'RecordListing.cfm?idmenu=#url.idmenu#&layoutmode=' + control.value;
}

</script>	

</cfoutput>

<table width="92%" align="center" cellspacing="0" cellpadding="0">

<tr><td height="10"></td></tr>
<tr>
	<td colspan="2" align="right" valign="middle" class="labelit">
		Layout:
		<select name="layoutView" id="layoutview" class="regularxl" onchange="javascript: changeView();">
			<option value="missions" <cfif url.layoutmode eq 'missions'>selected</cfif>>By Entity
			<option value="listing" <cfif url.layoutmode eq 'listing'>selected</cfif>>Listing
		</select>
	</td>
</tr>
<tr><td height="10"></td></tr>
<tr>
	<td colspan="2">
		<cfset vNumberCols = 7>
		<cfif url.layoutmode eq "listing">
			<cfset vNumberCols = 8>
		</cfif>
		<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			<tr><td colspan="<cfoutput>#vNumberCols#</cfoutput>" class="linedotted"></td></tr>
			<tr class="cellcontent">
			    <td width="2%" style="padding-left:30px" align="center"></td>
			    <td width="8%" align="center"><cf_tl id="Code"></td>
				<td width="10%" align="center"><cf_tl id="Country"></td>
				<td width="20%"><cf_tl id="Description"></td>
				<td width="15%" align="center"><cf_tl id="Effective"></td>
				<td width="15%" align="center"><cf_tl id="Expiration"></td>
				<cfset designationsWidth = "20%">
				<cfif url.layoutmode eq "listing">
				<cfset designationsWidth = "10%">
				<td width="10%" align="center"><cf_tl id="Associated Entities"></td>
				</cfif>
				<td width="<cfoutput>#designationsWidth#</cfoutput>" align="center"><cf_tl id="D"></td>
			</tr>
			<tr><td colspan="<cfoutput>#vNumberCols#</cfoutput>" class="linedotted"></td></tr>
			
			<cfif url.layoutmode eq "listing">
				<tr>
					<td colspan="<cfoutput>#vNumberCols#</cfoutput>">
						<cfdiv id="divDetail_0" bind="url: RecordListingDetail.cfm?mission=0&layoutmode=#url.layoutmode#">
					</td>
				</tr>
			</cfif>
			
			<cfif url.layoutmode eq "missions">
			
				<cfquery name="Missions"
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT 	DISTINCT M.Mission
					FROM   	Ref_PayrollLocation L
							LEFT OUTER JOIN Ref_PayrollLocationMission M
								ON L.LocationCode = M.LocationCode
					ORDER BY M.Mission
				</cfquery>
				
				<cfoutput query="Missions">
					<tr class="line">
						<td colspan="1" valign="middle" align="center" valign="bottom">
							<cf_img icon="expand" toggle="Yes" onClick="toggleDetail('#Mission#');">
						 </td>
							 
						 <td onClick="toggleDetail('#Mission#');" style="cursor:pointer;padding-bottom:5px;font-size:23px;height:45px"  colspan="#vNumberCols-1#" valign="bottom" class="labellarge">						 	
							<cfif Mission eq ""><font color="808080">Unassigned<cfelse>#Mission#</cfif>							
						 </td>
				
					</tr>					
					<tr>
						<td colspan="#vNumberCols#" id="detail_#mission#" style="padding-left:40px" class="hide">
							<cfset url.mission = mission>
							<cfinclude template="RecordListingDetail.cfm">
						</td>
					</tr>
				</cfoutput>
				
			</cfif>
		</table>
	</td>
</tr>
</table>

</cf_divscroll>