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
<cf_screentop html="No" jquery="Yes">

<cfparam name="client.fmission" default="">

<cfset Page         = "0">
<cfset add          = "1">

<cf_presentationScript>

<cfoutput>

<script>

	function recordadd() {
	     ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "AddWarehouse", "left=40, top=40, width=#client.width-80#, height=920, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}

	function edit(id) {
	     ptoken.open("RecordEditTab.cfm?idmenu=#url.idmenu#&ID1=" + id, "EditWarehouse"+id)
		 // "left=40, top=40, width=#client.width-80#, height=#client.height-100#, toolbar=no, status=yes, scrollbars=no, resizable=yes");		  
	}
	
	function dofilter() {
		var val1 = document.getElementById('filterMission').value;
		ptoken.navigate('RecordListingDetail.cfm?idmenu=#url.idmenu#&fmission='+val1,'divDetail');
	}

</script>	

</cfoutput>

<table width="97%" align="center" style="height:100%">

	<tr><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>
    
	<tr>
		<td align="left" style="height:10px;padding-left:20px">
			<table>
				<tr>
					<td class="labelit"><cf_tl id="Entity">:</td>
					<td style="padding-left:4px">
					
						<cfquery name="getLookup" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT 	*
							FROM 	Ref_ParameterMission M
							<!--- enabled for this module --->					
							WHERE   Mission IN (SELECT DISTINCT Mission
							                    FROM   Organization.dbo.Ref_MissionModule
												WHERE  Mission = M.Mission
												AND    SystemModule = 'Warehouse')					
						</cfquery>
						
						<select name="filterMission" 
								id="filterMission" 
								class="regularxl"
								onchange="javascript: dofilter();">
							<option value="">-- Any --</option>
							<cfoutput query="getLookup">
							  <option value="#getLookup.mission#" <cfif client.fmission eq getLookup.mission>selected</cfif>>#getLookup.mission#</option>
						  	</cfoutput>
						</select>
					</td>
					<!--- <td width="50%" align="right">
						<table>
							<tr>
								<td width="10" height="10" bgcolor="A8CEFD" style="border-color:808080;border-style:solid;border-width:1px;"></td>
								<td>&nbsp;Managed</td>
								<td width="5"></td>
								<td width="10" height="10" bgcolor="96FA87" style="border-color:808080;border-style:solid;border-width:1px;"></td>
								<td>&nbsp;Used</td>
								<td width="5"></td>
								<td width="10" height="10" bgcolor="FDCD86" style="border-color:808080;border-style:solid;border-width:1px;"></td>
								<td>&nbsp;Managed and Used</td>
								<td width="5"></td>
							</tr>
						</table>
					</td> --->
				
					<td style="padding-left:5px">
						<cfinvoke component = "Service.Presentation.TableFilter"  
						   method           = "tablefilterfield" 
						   filtermode       = "direct"
						   name             = "filtersearch"
						   style            = "font:14px;height:25;width:120"
						   rowclass         = "clsWarehouseRow"
						   rowfields        = "ccontent">
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr>
		<td style="height:100%;padding-left:20px">
		  <cf_divscroll>
			<cf_securediv id="divDetail" bind="url:RecordListingDetail.cfm?fmission=#client.fmission#">
		  </cf_divscroll>	
		</td>
	</tr>
	
</table>

