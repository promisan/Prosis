<!--
    Copyright © 2025 Promisan

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
<cfparam name="url.idmenu" default="">

<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	Ref_WarehouseCity
		WHERE  	Mission = '#url.mission#'
		AND		City = '#url.city#'
</cfquery>

<cfquery name="Countrec" 
	datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT 	*
		FROM  	Warehouse
		WHERE  	Mission = '#url.mission#'
		AND		City = '#url.city#'
</cfquery>

<script language="JavaScript">

function ask(mission,city) {
	if (confirm("Do you want to remove this record ?")) {	
		ptoken.navigate('RecordPurge.cfm?mission='+mission+'&city='+city,'processDelete');
	}	
}	

</script>

<cf_screentop height="100%" 
	  label="City" 
	  option="Maintain #url.city#" 
	  scroll="Yes" 
	  layout="webapp" 
	  banner="yellow" 
	  menuAccess="Yes" 
	  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#&mission=#url.mission#&city=#url.city#" method="POST" name="dialog">

<table width="95%" align="center" class="formpadding">

	<tr><td height="6"></td></tr>
    <cfoutput>
    <tr class="labelmedium2">
    <td width="20%">Entity:</td>
    <td>
	   	#get.mission#
		<input type="hidden" name="mission" id="mission"  class="regularxxl" value="#get.mission#">
    </td>
	</tr>
	
	<tr class="labelmedium2">
    <td class="labelmedium2" width="20%">Region:</td>
    <td>
	   	#get.city#
		<input type="hidden" name="city" id="city" class="regularxxl" value="#get.city#">
    </td>
	</tr>
	
	<tr class="labelmedium2">
    <td>Order:</td>
    <td>
  	   <cfinput type="Text" name="listingOrder" value="#get.listingOrder#" message="Please enter a numeric listing order" required="Yes" 
	     size="1" validate="integer" maxlength="3" class="regularxxl" style="text-align:center;">
    </td>
	</tr>
			
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="40">
		<table>
			<tr>
				<td>
					<cf_tl id = "Save" var ="1">
					<cf_button 
						type		= "submit"
						mode        = "silver"
						label       = "#lt_text#" 
						id          = "save"
						width       = "100px" 					
						color       = "636334"
						fontsize    = "11px">
				</td>
				<cfif Countrec.recordcount eq 0>
				<td width="5"></td>
				<td>
					<cf_tl id = "Delete" var ="1">
					<cf_button 
						type		= "button"
						mode        = "silver"
						label       = "#lt_text#"
						onclick		= "return ask('#url.mission#','#url.city#');" 
						id          = "delete"
						width       = "100px" 					
						color       = "636334"
						fontsize    = "11px">
				</td>
				</cfif>
			</tr>
		</table>
	</td>	
	
	</tr>
	
	<tr><td id="processDelete"></td></tr>
	
</table>

</cfform>	

<cf_screenbottom layout="webapp">
	