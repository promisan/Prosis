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
<cfparam name="client.fmission" 	default="">
<cfparam name="client.programcode"  default="">
<cfparam name="client.sortedby" 	default="Category">

<cf_tl id="Add"    var="vAdd">
<cf_tl id="Back"   var="vBack">
	
<cfoutput>
	
<cfsavecontent variable="option">
	
</cfsavecontent>

<cf_listingscript>

<cf_screentop html="No" jquery="Yes">

	<cfsavecontent variable="myoption">
	
			<cfquery name="getLookup" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_ParameterMission M
				<!--- has occurency in Item --->
				WHERE	Mission IN
							(
								SELECT DISTINCT Mission
								FROM	Item
								WHERE	Operational = 1
								UNION
								SELECT DISTINCT Mission 
					            FROM   ItemUoMMission 
								WHERE  Operational = 1
							)
				<!--- enabled for this module --->					
				AND     Mission IN (SELECT DISTINCT Mission
				                    FROM   Organization.dbo.Ref_MissionModule
									WHERE  Mission = M.Mission
									AND    SystemModule = 'Warehouse')					
			</cfquery>
			
			<table><tr>
			
			<td>				
			
			<select name="filterMission" 
					id="filterMission" 								
					class="regularxl"
					onchange="javascript: dofilter();">
				<option value="">-- All --</option>
				<cfloop query="getLookup">
				  <option value="#getLookup.mission#" <cfif client.fmission eq getLookup.mission>selected</cfif>>#getLookup.mission#</option>
			  	</cfloop>
			</select>			
			
			<input type="hidden" value="#url.used#" id="filterUsed">
			
			</td>
			<td style="padding-left:3px">
			<input type="button" class="button10g" name="Search" id="Search" value="#vBack#" onClick="history.back()">
			</td>
			<td style="padding-left:3px">
			<input type="button" class="button10g" name="Insert" id="Insert" value="#vAdd#" onClick="recordedit('','')">
			</td>
			
			<!--- not longer needed 
			
			<td style="padding-left:10px">
				<cfinvoke component = "Service.Presentation.TableFilter"  
				   method           = "tablefilterfield" 							   
				   name             = "filtersearch"
				   style            = "font:15px;height:25;width:120"
				   rowclass         = "clsItemRow"
				   rowfields        = "ccontent">
			</td>
			--->
					
			
			</tr>
			</table>
					
	</cfsavecontent>


<table width="98%" border="0" height="100%" align="center">

<tr>
<td height="20">
<cfset Page         = "0">
<cfset add          = "0">
<cfset option       = myoption>
<cfinclude template = "../HeaderMaintain.cfm"> 
</td>
</tr>

<script language="JavaScript">

	function recordedit(id,mis) {
        ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID=" + id + "&fmission=" + document.getElementById('filterMission').value, "EditItem"+id);
	}
	
	function dofilter() {
	    
		_cf_loadingtexthtml='';
		Prosis.busy('yes');
		var val1 = document.getElementById('filterMission').value;
		var val2 = document.getElementById('filterUsed').value;
		// var val3 = document.getElementById('sortedBy').value;
		ptoken.navigate('ItemSearchResultListing.cfm?systemfunctionid=#url.idmenu#&fmission='+val1+'&used='+val2+'&programcode=#url.programcode#','divDetail');
	}

</script>

</cfoutput>

<cf_dialogMaterial>
<cf_presentationScript>

<tr><td height="100%">
	<table height="100%" width="100%">				
		<tr>
			<td valign="top" style="height:100%;padding-left:4px;padding-right:4px">
			<cf_divscroll style="height:99%">		
				<cf_securediv id="divDetail" bind="url:ItemSearchResultListing.cfm?systemfunctionid=#url.idmenu#&used=#url.used#&fmission=#client.fmission#&programcode=#url.programcode#&ts=#GetTickCount()#">
			</cf_divscroll>	
			</td>
		</tr>
	</table>
</td>
</tr>
</table>