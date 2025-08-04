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
<cf_compression>

<cfquery name="getLocation"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT  *
		FROM 	WarehouseLocation
		WHERE	Warehouse = '#url.fwarehouse#'
		AND		Operational = 1 
		
</cfquery>

<cfquery name="getSelLoc"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT  TransferLocation
		FROM 	Receipt#URL.Warehouse#_#SESSION.acc#
		WHERE	Selected = '1'
		AND		TransferLocation IS NOT NULL
		
</cfquery>

<cfquery name="validateSelectedLocation"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT  *
		FROM 	WarehouseLocation
		WHERE	Warehouse = '#url.fwarehouse#'
		AND		Location = '#getSelLoc.TransferLocation#'
		AND		Operational = 1
		
</cfquery>

<cfif url.fwarehouse eq "">
	<cfquery name="updateItem"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			UPDATE	Receipt#URL.Warehouse#_#SESSION.acc#
			SET		TransferLocation = null
			WHERE   TransferWarehouse IS NULL
			
	</cfquery>
</cfif>

<cfif validateSelectedLocation.recordCount eq 0>
	<cfquery name="updateItem"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			UPDATE	Receipt#URL.Warehouse#_#SESSION.acc#
			SET		TransferLocation = null
			WHERE	Selected = '1'
			
	</cfquery>
</cfif>

<cfoutput>
<cf_tl id="Select a destination location" var="1">
<select style="height:35px;border:0px;background-color:f1f1f1;font-size:19px;"
	name="flocation" 
	id="flocation" 
	class="regularxl"	
	onchange="saveChangeTmpReceipt('#url.mission#','#url.warehouse#','TransferLocation',this.value, '', ''); refreshReceiptDetail('#url.mission#','#url.warehouse#');">
	<option value=""> -- #lt_text# --
	<cfloop query="getLocation">
		<option value="#location#" <cfif getSelLoc.TransferLocation eq location>selected</cfif>>[#location#] #description#
	</cfloop>
</select>
</cfoutput>

