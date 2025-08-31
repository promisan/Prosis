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
<cfparam name="url.systemfunctionid" default="">

<cfset itm = 0>		

<cf_tl id="Recapitulation" var="vRecap">

<cfset itm = itm+1>	
<cf_menutab item       = "#itm#" 
            iconsrc    = "Logos/Workorder/Summary.png" 
			iconwidth  = "#wd#" 
			padding    = "2"
			targetitem = "1"
			class      = "highlight1"
			iconheight = "#ht#" 
			name       = "#vRecap#"
			source     = "../../Assembly/Items/HalfProduct/Summary/SummaryView.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">

<cf_tl id="Produced Items" var="vProducts">

<cfset itm = itm+1>		
<cf_menutab item       = "#itm#" 
            iconsrc    = "Logos/Workorder/FinalProduct.png" 
			iconwidth  = "#wd#" 
			padding    = "2"
			targetitem = "1"			
			iconheight = "#ht#" 
			name       = "#vProducts#"
			source     = "../../Assembly/Items/HalfProduct/ItemView.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">

<cf_tl id="Cost of Production" var="vCosts">

<cfset itm = itm+1>						
<cf_menutab item       = "#itm#" 
            iconsrc    = "Logos/WorkOrder/BOM-Cost.png" 
			iconwidth  = "#wd#" 
			iconheight = "#ht#"
			targetitem = "1"
			padding    = "2"
			name       = "#vCosts# "
			source     = "../../Assembly/Items/BOM/ItemView.cfm?mode=halfproduct&systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">				
			
		
<cfset itm = itm+1>		
<cf_tl id="Ledger Posting" var="vPosting">
<cf_menutab item       = "#itm#" 
            iconsrc    = "Logos/WorkOrder/Charge.png" 
			iconwidth  = "#wd#" 
			padding    = "3"
			targetitem = "1"
			iconheight = "#ht#"
			name       = "#vPosting#"
			source     = "../../Assembly/Items/HalfProduct/Summary/PostingListing.cfm?workorderid=#URL.workorderId#&workorderline=#url.workorderline#&systemfunctionid=#url.systemfunctionid#">

<!---
			
<cfif workorder.actionstatus lte "1">
				
	<cf_tl id="Earmark Stock to Order" var="vEarmark">
	<cfset itm = itm+1>		
	<cf_menutab item       = "#itm#" 
	            iconsrc    = "Logos/Workorder/Earmarkstock.png" 
				iconwidth  = "#wd#" 
				padding    = "3"
				targetitem = "1"			
				iconheight = "#ht#" 
				name       = "#vEarmark#"
				source     = "../../Assembly/Earmarkstock/EarmarkView.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">
				
</cfif>

--->
				
<cfif children.recordcount eq "0" and transferstatus neq "disable">			
				
		<cfset itm = itm+1>		
		<cf_tl id="Edit Line and Notes" var="vEditLines">
		<cf_menutab item       = "#itm#" 
		            iconsrc    = "Logos/Workorder/Notes.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					targetitem = "1"
					padding    = "2"
					name       = "#vEditLines#"
					source     = "ServiceLineForm.cfm?openmode=#url.openmode#&tabno=1&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">		
				
</cfif>			
				
<cfif accessProcess neq "NONE">	

	<cfset itm = itm+1>		
	<cf_tl id="Actions" var="vActions">
	<cf_menutab item       = "#itm#" 
	            iconsrc    = "Logos/Workorder/Service-Object.png" 
				iconwidth  = "#wd#" 
				targetitem = "1"
				padding    = "2"
				iconheight = "#ht#" 
				name       = "#vActions#"
				source     = "Action/WorkAction.cfm?workorderid=#URL.workorderId#&workorderline=#url.workorderline#&tabno=1">	
			
</cfif>					