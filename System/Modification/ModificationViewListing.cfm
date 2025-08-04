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

<cfparam name="URL.observationclass"   default="Amendment">
<cfparam name="URL.context"            default="status">
<cfparam name="URL.contextid"          default="">

<cfoutput>
	
	<script>
	
		function addRequest(context,oclass) {		
		    w = #CLIENT.width# - 80;
		    h = #CLIENT.height# - 150;				
			ptoken.open("#SESSION.root#/System/Modification/DocumentEntry.cfm?observationclass=" + oclass + "&context=" + context + "&ts="+new Date().getTime(), "amendment", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, scrollbars=no, resizable=yes");		
		}
				
	</script>	

</cfoutput>

<cf_ListingScript>

<cfquery name="Entity" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM    Ref_Entity
  <cfif url.observationclass eq "Inquiry">
  WHERE   EntityCode  = 'SysTicket'
  <cfelse>
  WHERE   EntityCode  = 'SysChange'
  </cfif>
</cfquery>
  
<cfquery name="Parameter" 
	datasource="appsSystem">
	SELECT   *
    FROM     Parameter
</cfquery>

<cfset currrow = 0>

<cfif url.observationclass eq "Inquiry">
		
	<cf_wfpending entityCode="SysTicket"  
      table="#SESSION.acc#wfSysTicket" mailfields="No" includecompleted="No">		

	 <cfinclude template="ModificationTicketListing.cfm">

<cfelse>

	<cf_wfpending entityCode="SysChange"  
      table="#SESSION.acc#wfSysChange" mailfields="No" includecompleted="No">		
	  
	 <cfinclude template="ModificationAmendmentListing.cfm">	

</cfif>

<!--- open access for observation in case of observation mode --->



	