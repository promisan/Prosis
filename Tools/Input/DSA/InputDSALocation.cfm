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
<cfparam name="URL.selected" default="">

<cfquery name="GetLocation" 
		datasource="AppsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_PayrollLocation 					
		WHERE    LocationCountry = '#url.Country#' 	
		AND      HotelRate = 0
		AND      (DateExpiration is NULL or DateExpiration > getDate())
</cfquery>	

<cfif passtru eq "">
   <cfset sc = "#function#(this.value,'#url.selected#')">
<cfelse>
   <cfset sc = "#function#('#passtru#',this.value,'#url.line#','#url.selected#')">
</cfif>

<select name="<cfoutput>#url.name#</cfoutput>" style="min-width:99%;border:0px;border-right:1px solid silver;width:100%;" class="<cfoutput>#url.class#</cfoutput> enterastab" onchange="<cfoutput>#sc#</cfoutput>">
	<cfoutput query="getLocation">
		<option value="#LocationCode#" <cfif trim(LocationCode) eq trim(url.selected)>selected</cfif>>#Description#</option>
	</cfoutput>
</select>

<cfif function neq "">

	<cfif url.selected neq "" and findNoCase(url.selected,valueList(GetLocation.LocationCode))>						
	    <cfset frm = url.selected>
	    <cfset sel = url.selected>
	<cfelse>
	    <cfset frm = url.selected>
		<cfset sel = getLocation.LocationCode>				
	</cfif>			

	<cfif passtru eq "">			
	   <cfset sc = "#function#('#init#')">
	<cfelse>						
	   <cfset sc = "#function#('#passtru#','#sel#','#url.line#','#frm#')">
	</cfif>
												
	<cfoutput>					
		<script language="JavaScript">				
		#sc#
		</script>
	</cfoutput>		
	
</cfif>	