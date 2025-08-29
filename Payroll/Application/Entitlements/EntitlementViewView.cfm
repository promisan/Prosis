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
<cf_screenTop height="100%" html="No" scroll="yes" jquery="yes">

<cf_listingscript>
<cf_DialogStaffing>

<cfparam name="URL.Mission" default="">
<cfparam name="URL.Period" default="">
	
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cf_listingscript>

<cfoutput>
	
	<script>
		
		$(document).ready(function(){
			doHighlight();
		});			
	
	</script>

</cfoutput>


<table width="100%" height="100%">
    <cfif url.id eq "Loc">
	<!---
	<tr><td height="100">
		<cfinclude template="PurchaseViewLocate.cfm">
	</td></tr>
	<tr><td height="96%" valign="top">
	    <cf_divscroll style="height:100%" id="detail"/>			
	</td></tr>
	--->
	<cfelse>
	
	<tr><td height="100%" valign="top" style="padding-top:5px">
	    <cfdiv id="detail" style="height:100%">		
		 <cfif URL.ID eq "ACT">
		    <cfset url.mode = "personnelaction">
		 	<cfinclude template="../../../Staffing/Application/Employee/PersonAction/ActionListContent.cfm">
		 <cfelseif URL.ID eq "PCR">
		    <cfset url.mode = "miscellaneous">
		 	<cfinclude template="MiscellaneousViewListing.cfm">	
		 <cfelseif URL.ID eq "DEL">
		    <cfset url.mode = "delayed settlements">
		 	<cfinclude template="EntitlementBalanceListing.cfm">		
		 <cfelse>
		  	<cfinclude template="EntitlementViewListing.cfm">
		 </cfif> 
		</cfdiv>   
		</td>
	</tr>	
	</cfif>
</table>
