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
<cfquery name="Warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    *
    FROM      Warehouse
    WHERE     Warehouse = '#url.warehouse#'    									  
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    *
    FROM      Ref_ParameterMission
    WHERE     Mission = '#warehouse.mission#'    									  
</cfquery>

<cfquery name="Production" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT    *
    FROM      Warehouse
    WHERE     WarehouseClass = '#Parameter.WarehouseProduction#' OR Warehouse = '#url.warehouse#'   									  
</cfquery>

<cf_tl id="Stock reservation" var="tStockReservation">

<cf_screentop height="100%" layout="webapp" banner="gray" scroll="No" label="#tStockReservation#" user="no">

<table width="91%" cellspacing="5" cellpadding="2" align="center" class="formpadding formspacing">

	<tr><td style="padding-top:5px" colspan="2" class="labelmedium"> <cf_tl id="Transfer and earmark selected stock to the below facility" class="message"></td></tr>
	<tr><td colspan="2"  class="line"></td></tr>
	<tr><td class="labelmedium"><cf_tl id="Facility">:</td>
	    <td>
		
		<cfoutput>	
		
		<select id="destinationwarehouse" name="destinationwarehouse" 
		    class="regularxl" onchange="_cf_loadingtexthtml='';ColdFusion.navigate('Items/Earmark/getDestinationLocation.cfm?warehouse='+this.value,'destinationlocationbox')">			
			<cfloop query="Production">
					<option value="#warehouse#" <cfif url.warehouse eq warehouse>selected</cfif>>#WarehouseName#</option>
			</cfloop>
		</select>
		
		</cfoutput>	
		
		
		</td>
	</tr>
	    <td class="labelmedium"><cf_tl id="Location">:</td>
	    <td id="destinationlocationbox">		
		<cfinclude template="getDestinationLocation.cfm">	
		</td>
	</tr>
	
	<tr><td colspan="2" valign="bottom" align="center" style="height:60">
	
		  <!--- transfer --->	
		  
		  <cfoutput>
			
			<cf_tl id="Reserve Stock" var="tReserve">
		  <input type="button" 
			  style="width:190;height:26;font-size:12" 			 
			  onclick="Prosis.busy('yes');ptoken.navigate('#session.root#/workorder/application/Assembly/Items/Earmark/BOMEarmarkSubmit.cfm?mode=#url.mode#&action=8&workorderid=#url.workorderid#&workorderline=#workorderline#&warehouse=#url.warehouse#&category=#url.category#&pointersale=#url.pointersale#&destinationwarehouse='+document.getElementById('destinationwarehouse').value+'&destinationlocation='+document.getElementById('destinationlocation').value,'process','','','POST','fGeneration');ColdFusion.Window.destroy('dialogdestination',true);"
			  value="#tReserve#"
			  class="button10g">
			  
		</cfoutput>	  
		  
		  </td>
	</td></tr>
	
</table>