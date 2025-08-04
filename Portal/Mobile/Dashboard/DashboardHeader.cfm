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
<script>
	toggleSidebar();
</script>

<cfquery name="getApplication" 
	datasource="AppsSystem">		 
		SELECT  *
		FROM    #client.lanPrefix#Ref_ModuleControl	 
		WHERE	SystemModule = 'PMobile'
		AND		FunctionClass = 'PMobile'
		AND		FunctionName = '#url.appId#'
		AND		Operational = 1
</cfquery>

<cfquery name="getMenu" 
	datasource="AppsSystem">		 
		SELECT  *
		FROM    #client.lanPrefix#Ref_ModuleControl	 
		WHERE	SystemFunctionId = '#url.systemfunctionid#'
		AND		Operational = 1
</cfquery>

<cf_mobileRow>
	<cf_mobileCell class="col-lg-12 text-center m-t-md">
		<h2>
			<cfoutput>#UCASE('#url.mission# #getMenu.functionMemo#')#</cfoutput>
		</h2>
		<p>
			<cfoutput>#getMenu.functionInfo#</cfoutput>
		</p>
	</cf_mobileCell>
</cf_mobileRow>

<!--- <cfquery name="getCostCenters" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT	DISTINCT
				Warehouse,
				WarehouseName
		FROM	#session.acc#_mobileStats
		ORDER BY
				WarehouseName ASC
</cfquery>

<cf_mobileRow>
	<form class="form-horizontal">
		<cf_mobileCell class="col-sm-12 col-lg-6">
			<div class="form-group" style="padding:10px;">
				<label class="control-label"><cf_tl id="Cost Center"></label>
				<select class="form-control" name="pCostCenter" id="pCostCenter">
					<option value="" <cfif url.costCenter eq "">selected</cfif>> <cf_tl id="All">
					<cfoutput query="getCostCenters">
						<option value="#Warehouse#" <cfif url.costCenter eq Warehouse>selected</cfif>> #WarehouseName#
					</cfoutput>
				</select>
			</div>
		</cf_mobileCell>
		<cf_mobileCell class="col-sm-12 col-lg-6">
			<div class="form-group" style="padding:10px;">
				<label class="control-label"><cf_tl id="Period"></label>
				<select class="form-control" name="pDays" id="pDays">
					<option value="0" <cfif url.days eq 0>selected</cfif>> <cf_tl id="Today">
					<option value="1" <cfif url.days eq 1>selected</cfif>> <cf_tl id="Yesterday">
					<option value="7" <cfif url.days eq 7>selected</cfif>> 7 <cf_tl id="days">
					<option value="14" <cfif url.days eq 14>selected</cfif>> 14 <cf_tl id="days">
					<option value="30" <cfif url.days eq 30>selected</cfif>> 30 <cf_tl id="days">
					<option value="60" <cfif url.days eq 60>selected</cfif>> 60 <cf_tl id="days">
					<option value="90" <cfif url.days eq 90>selected</cfif>> 90 <cf_tl id="days">
					<option value="180" <cfif url.days eq 180>selected</cfif>> 180 <cf_tl id="days">
					<option value="365" <cfif url.days eq 365>selected</cfif>> 365 <cf_tl id="days">
				</select>
			</div>
		</cf_mobileCell>
	</form>
</cf_mobileRow> --->