<!--- Create Criteria string for query from data entered thru search form --->

<cfparam name="client.fmission" 	default="">
<cfparam name="client.programcode"  default="">
<cfparam name="client.sortedby" 	default="Category">

<cf_tl id="Add"    var="vAdd">
<cf_tl id="Back"   var="vBack">
	
<cfoutput>
	
<cfsavecontent variable="option">
	<input type="button" class="button10g" name="Search" id="Search" value="#vBack#" onClick="history.back()">
	<input type="button" class="button10g" name="Insert" id="Insert" value="#vAdd#" onClick="recordedit('','')">
</cfsavecontent>

<cf_screentop html="No" jquery="Yes">

<table width="96%" height="100%" align="center">
<tr><td height="20">
<cfset Page         = "0">
<cfset add          = "0">
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
		var val3 = document.getElementById('sortedBy').value;
		ptoken.navigate('ItemSearchResultDetail.cfm?idmenu=#url.idmenu#&fmission='+val1+'&used='+val2+'&sortedBy='+val3+'&programcode=#url.programcode#','divDetail');
	}

</script>

</cfoutput>

<cf_dialogMaterial>
<cf_presentationScript>

<tr><td height="100%" style="padding:5px">

	<table height="100%" width="100%">
		<tr>
			<td align="left" style="padding-left:10px;height:20px">
				<table width="100%">
					<tr>
						<td align="50%">
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
							<td class="labelit"><cf_tl id="Entity">:</td>
							<td>
							<select name="filterMission" 
									id="filterMission" 								
									class="regularxl"
									onchange="javascript: dofilter();">
								<option value="">-- Any --</option>
								<cfoutput query="getLookup">
								  <option value="#getLookup.mission#" <cfif client.fmission eq getLookup.mission>selected</cfif>>#getLookup.mission#</option>
							  	</cfoutput>
							</select>
							
							<cfoutput>
							<input type="hidden" value="#url.used#" id="filterUsed">
							</cfoutput>
							</td>
							<td style="padding-left:10px">
								<cfinvoke component = "Service.Presentation.TableFilter"  
								   method           = "tablefilterfield" 							   
								   name             = "filtersearch"
								   style            = "font:15px;height:25;width:120"
								   rowclass         = "clsItemRow"
								   rowfields        = "ccontent">
							</td>
							
							<td class="labelit"><cf_tl id="Sorted by">:</td>
							
							<td>
								<select name="sortedBy" 
									id="sortedBy" 								
									class="regularxl"
									onchange="javascript: dofilter();">
									
									<cfset lSorted="Category,ItemDescription,Classification"/>
									<cfoutput>
									<cfloop list="#lSorted#" index="iSorted">
										<option value="#iSorted#" <cfif client.sortedby eq "#iSorted#">selected</cfif>><cf_tl id="#iSorted#"></option>	
									</cfloop>										
									</cfoutput>
								</select>								
								
							</td>	
							
							</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td style="height:100%;padding:4px">
			<cf_divscroll style="height:96%">		
				<cf_securediv id="divDetail" bind="url:ItemSearchResultDetail.cfm?idmenu=#url.idmenu#&used=#url.used#&fmission=#client.fmission#&programcode=#url.programcode#&sortedby=#client.sortedby#&ts=#GetTickCount()#">
			</cf_divscroll>	
			</td>
		</tr>
	</table>

</td>
</tr>
</table>