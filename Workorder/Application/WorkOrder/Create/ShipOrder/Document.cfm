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

<!--- --------CUSTOM FORM DATA ENTRY --------- --->
<!--- ---------------------------------------- --->
<!--- --Deliver service for Kuntz data entry-- --->
<!--- ---------------------------------------- --->
<!--- ---------------------------------------- --->

<cfparam name="url.workorderid"   default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.workorderline" default="1">

<cfparam name="url.customerid"    default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.scope"         default="entry">
<cfparam name="url.context"       default="backoffice">

<cfparam name="url.serviceitem"   default="#type.code#">

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<cfoutput>

<cfif url.workorderid neq "00000000-0000-0000-0000-000000000000">

<tr><td height="30" class="clsNoPrint">

		<!--- top menu --->
				
		<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">		  		
						
			<cfset ht = "34">
			<cfset wd = "34">
					
			<tr>								        
					<cf_tl id="Service Request" var="1">
					<cf_menutab item         = "1" 
				            iconsrc          = "Logos/Procurement/Log.png" 
							iconwidth        = "#wd#" 
							iconheight       = "#ht#" 
							class            = "highlight"
							name             = "#lt_text#">			

<!----													
					<cf_tl id="MAP" var ="1">									
					<cf_menutab item         = "2" 
					            iconsrc      = "maps.png" 
								iconwidth    = "#wd#" 
								iconheight   = "#ht#" 
								name         = "#lt_text#"
								tabid         = "disabled"								
								source       = "#SESSION.root#/workorder/application/workorder/create/shiporder/documentmap.cfm?country={country}&city={city_order}&address={address_order}&postalcode={postalcode_order}&latitude={cLatitude}&longitude={cLongitude}">
										
					<cf_tl id="Instructions" var ="1">									
							<cf_menutab item  = "3" 
					            iconsrc       = "Logos/Task.png" 
								iconwidth     = "#wd#" 
								iconheight    = "#ht#" 									
								name          = "#lt_text#"
								tabid         = "disabled"
								source        = "#SESSION.root#/workorder/application/workorder/create/shiporder/documentinstructions.cfm">			
--->
								
					<cf_tl id="Billing" var ="1">									
							<cf_menutab item  = "4" 
					            iconsrc       = "Logos/Procurement/Pending.png" 
								iconwidth     = "#wd#" 
								iconheight    = "#ht#" 									
								name          = "#lt_text#"
								button        = "yes"
								tabid         = "disabled"
								source        = "#SESSION.root#/workorder/application/workorder/create/shiporder/documentbilling.cfm">											
				
				<td width="30%"></td>																	 		
				
				</tr>
		</table>

	</td>
 </tr>
 
 </cfif>
 
 </cfoutput>
 
<tr><td height="100%">

	<table width="100%" 
	      border="0"
		  height="100%"
		  cellspacing="0" 
		  cellpadding="0" 
		  align="center" 
	      bordercolor="d4d4d4">
		  		  	 					
			<cf_menucontainer item="1" class="regular">									  		  											
				 <cfinclude template="DocumentForm.cfm">									 					  
			<cf_menucontainer>
			
			<cf_menucontainer item="2" class="hide"/>
			<cf_menucontainer item="3" class="hide"/>
			<cf_menucontainer item="4" class="hide"/>		
									
	</table>	

</td></tr>

</table>
