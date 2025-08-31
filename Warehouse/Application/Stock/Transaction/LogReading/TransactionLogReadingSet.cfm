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
<cfparam name="url.refreshMain" default="0">

<cfset val = url.value>
<cfset val = replace("#val#",",","")>
<cfset val = replace("#val#"," ","")>
<cfset val = trim(val)>

<cfoutput>
	<cfif not LSIsNumeric(val) and val neq "">	
		<cfoutput>
			<cf_tl id = "You recorded an invalid meter reading" var ="vMeter">
			<script>
			alert("#vMeter# [#val#]")
			</script>
		</cfoutput>
		<cfabort>
	</cfif>
</cfoutput>

<!--- saving the reading values --->

<cfoutput>
	<cf_logpoint filename="transactionLogReadingLog.txt" mode="append">
		#url.field# = <cfif val neq "">'#val#'<cfelse>null</cfif>
	</cf_logpoint>
</cfoutput>

<cfif url.field eq "opening">
	
	<cfquery name="reading" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE ItemWarehouseLocation 
		SET    ReadingOpening = <cfif val neq "">'#val#'<cfelse>null</cfif>, 
		       ReadingDate    = getDate()
		WHERE  Warehouse = '#url.warehouse#'	
		AND    Location  = '#url.location#'	
		AND    ItemNo    = '#url.itemno#'
		AND    UoM       = '#url.UoM#' 				
	</cfquery>

<cfelseif url.field eq "closing">
	
	<cfquery name="reading" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE ItemWarehouseLocation 
		SET    ReadingClosing = <cfif val neq "">'#val#'<cfelse>null</cfif>
		WHERE  Warehouse = '#url.warehouse#'	
		AND    Location  = '#url.location#'	
		AND    ItemNo    = '#url.itemno#'
		AND    UoM       = '#url.UoM#' 				
	</cfquery>

</cfif>

<cfif url.refreshMain eq 1>
	<cfoutput>
		<script>
			ColdFusion.navigate('../Transaction/LogReading/TransactionLogReading.cfm?warehouse=#url.warehouse#&location=#url.location#&ItemNo=#url.itemno#&UoM=#url.uom#','readingbox');
		</script>
	</cfoutput>
</cfif>

<cf_compression>
	