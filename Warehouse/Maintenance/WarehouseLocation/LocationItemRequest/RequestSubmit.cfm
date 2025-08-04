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

<cfset form.ScheduleInterval = replace(form.ScheduleInterval,',','','ALL')>
<cfset form.ScheduleDayMonth = replace(form.ScheduleDayMonth,',','','ALL')>
<cfset form.ScheduleQuantity = replace(form.ScheduleQuantity,',','','ALL')>
<cf_tl id="This effective date has already defined a scheduled request." var = "msg1">

<cfset selDate = replace("#form.ScheduleEffective#","'","","ALL")>
<cfset dateValue = "">
<cf_dateConvert Value="#SelDate#">
<cfset vDateEffective = dateValue>

<cfif url.ScheduleEffective eq "">

	<cfquery name="validate" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT	*
		FROM	ItemWarehouseLocationRequest
		WHERE	Warehouse = '#url.warehouse#'
		AND     Location = '#url.location#'		
		AND		ItemNo = '#url.itemNo#'
		AND		UoM = '#url.UoM#'
		AND		ScheduleEffective = #vDateEffective#
	</cfquery>

	<cfif validate.recordCount eq 0>

		<cfquery name="insert" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">		 		 	  
				 INSERT INTO ItemWarehouseLocationRequest
				 	(
						Warehouse,
						Location,
						ItemNo,
						UoM,
						ScheduleEffective,
						ScheduleMode,
						ScheduleInterval,
						ScheduleDayMonth,
						ScheduleQuantity,
						ShipToMode,
						<cfif trim(form.sourceWarehouse) neq "">SourceWarehouse,</cfif>
						<cfif trim(form.RequestType) neq "">RequestType,</cfif>
						<cfif trim(form.RequestAction) neq "">RequestAction,</cfif>
						<cfif trim(form.ScheduleMemo) neq "">ScheduleMemo,</cfif>
						Operational,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				 VALUES
				 	(
						'#url.warehouse#',
						'#url.location#',
						'#url.itemNo#',
						'#url.uom#',
						#vDateEffective#,
						'#form.ScheduleMode#',
						#form.ScheduleInterval#,
						#form.ScheduleDayMonth#,
						#form.ScheduleQuantity#,
						'#form.ShipToMode#',
						<cfif trim(form.sourceWarehouse) neq "">'#form.SourceWarehouse#',</cfif>
						<cfif trim(form.requestType) neq "">'#form.requestType#',</cfif>
						<cfif trim(form.RequestAction) neq "">'#form.RequestAction#',</cfif>
						<cfif trim(form.ScheduleMemo) neq "">'#form.ScheduleMemo#',</cfif>
						#form.operational#,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
		</cfquery>
		
		<cfoutput>
			<script>
				ColdFusion.Window.hide('mydialog');
				ColdFusion.navigate('../LocationItemRequest/Request.cfm?warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.itemno#&UoM=#url.uom#','contentbox2');
			</script>
		</cfoutput>
	
	<cfelse>
		<cfoutput>
			<script>
				alert('#msg1#');
			</script>
		</cfoutput>
	</cfif>

<cfelse>
	
	<cfquery name="update" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">		 		 	  
			UPDATE 	ItemWarehouseLocationRequest
		 	SET		ScheduleMode		= '#form.ScheduleMode#',
					ScheduleInterval 	= #form.ScheduleInterval#,
					ScheduleDayMonth	= #form.ScheduleDayMonth#,
					ScheduleQuantity 	= #form.ScheduleQuantity#,
					ShipToMode			= '#form.ShipToMode#',
					SourceWarehouse		= <cfif trim(form.sourceWarehouse) neq "">'#form.SourceWarehouse#'<cfelse>null</cfif>,
					RequestType			= <cfif trim(form.requestType) neq "">'#form.requestType#'<cfelse>null</cfif>,
					RequestAction		= <cfif trim(form.requestAction) neq "">'#form.requestAction#'<cfelse>null</cfif>,
					ScheduleMemo		= <cfif trim(form.ScheduleMemo) neq "">'#form.ScheduleMemo#'<cfelse>null</cfif>,
					Operational			= #form.operational#
			WHERE	Warehouse		 	= '#url.warehouse#'
			AND     Location 			= '#url.location#'		
			AND		ItemNo 				= '#url.itemNo#'
			AND		UoM 				= '#url.UoM#'
			AND		ScheduleEffective 	= #vDateEffective#
	</cfquery>

	<cfoutput>
			<script>
				ColdFusion.Window.hide('mydialog');
				ColdFusion.navigate('../LocationItemRequest/Request.cfm?warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.itemno#&UoM=#url.uom#','contentbox2');
			</script>
		</cfoutput>

</cfif>