
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
