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

<!--- ------------------------------------------------------------------------------------------------------------ --->
<!--- this menu is for a process in which stock is both obtained (proocured/earmerked from other) and then shipped --->
<!--- ------------------------------------------------------------------------------------------------------------ --->
<!--- ---------used by Hicosa and could work for sherwin as well as they move into projects ---------------------- --->
<!--- ------------------------------------------------------------------------------------------------------------ --->

<cfparam name="url.systemfunctionid" default="">

<cfset itm = 1>		

<cf_tl id="Recapitulation" var="vRecap">

<cf_menutab item       = "#itm#" 
            iconsrc    = "Logos/Workorder/Summary.png" 
			iconwidth  = "#wd#" 
			padding    = "3"
			targetitem = "1"
			class      = "highlight1"
			iconheight = "#ht#" 
			name       = "#vRecap#"
			source     = "../../Assembly/Items/FinalProduct/Summary/SummaryView.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">
	
<cf_tl id="Ordered Items" var="vProducts">

<cfset itm = itm+1>		
<cf_menutab item       = "#itm#" 
            iconsrc    = "Logos/Workorder/FinalProduct.png" 
			iconwidth  = "#wd#" 
			padding    = "3"
			targetitem = "1"			
			iconheight = "#ht#" 
			name       = "#vProducts#"
			source     = "../../Assembly/Items/FinalProduct/ItemView.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">
			
<cfset itm = itm+1>		
<cf_tl id="Outsourced Items" var="vProcurement">
<cf_menutab item       = "#itm#" 
            iconsrc    = "Logos/Workorder/Acquired-Product.png" 
			iconwidth  = "#wd#" 
			padding    = "3"
			targetitem = "1"
			iconheight = "#ht#" 
			name       = "#vProcurement#"
			source     = "Requisition/RequisitionListing.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#&systemfunctionid=#url.systemfunctionid#">				
			
<cfif workorder.actionstatus lte "1">
				
	<cf_tl id="Earmark for Order" var="vEarmark">
	<cfset itm = itm+1>		
	<cf_menutab item       = "#itm#" 
	            iconsrc    = "Logos/Workorder/Reserve-Product.png" 
				iconwidth  = "#wd#" 
				padding    = "3"
				targetitem = "1"			
				iconheight = "#ht#" 
				name       = "#vEarmark#"
				source     = "../../Assembly/Earmarkstock/EarmarkView.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">
				
</cfif>		

<cf_tl id="BOM Service Costs" var="vCosts">
<cfset itm = itm+1>						
<cf_menutab item       = "#itm#" 
            iconsrc    = "Logos/Workorder/BOM-Cost.png" 
			iconwidth  = "#wd#" 
			iconheight = "#ht#"
			targetitem = "1"
			padding    = "2"
			name       = "#vCosts# "
			source     = "../../Assembly/Items/BOM/ItemView.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">				
				
<cfif children.recordcount eq "0" and transferstatus neq "disable">			
				
		<cfset itm = itm+1>		
		<cf_tl id="Edit Line and Notes" var="vEditLines">
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Note.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					targetitem = "1"
					padding    = "3"
					name       = "#vEditLines#"
					source     = "ServiceLineForm.cfm?openmode=#url.openmode#&tabno=1&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">		
				
</cfif>			
				
<cfif accessProcess neq "NONE">	

	<cfset itm = itm+1>		
	<cf_tl id="Actions" var="vActions">
	<cf_menutab item       = "#itm#" 
	            iconsrc    = "Tasks.png" 
				iconwidth  = "#wd#" 
				targetitem = "1"
				padding    = "3"
				iconheight = "#ht#" 
				name       = "#vActions#"
				source     = "Action/WorkAction.cfm?workorderid=#URL.workorderId#&workorderline=#url.workorderline#&tabno=1">	
			
</cfif>					