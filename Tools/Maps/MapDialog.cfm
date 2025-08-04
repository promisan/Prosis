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

<!--- set the map size --->

<cfparam name="url.mode"        default="edit">	
<cfparam name="url.coordinates" default="">
<cfparam name="url.latitude"    default="">
<cfparam name="url.longitude"   default="">
<cfparam name="url.search"      default="Yes">
<cfparam name="url.field"       default="">

<cf_mapscript>
<cfajaximport tags="cfmap" params="#{googlemapkey='#client.googlemapid#'}#"> 

<cfloop index="val" list="#url.coordinates#" delimiters=":">
	
	<cfif url.latitude eq "">
	    <cfset url.latitude  = "#val#">
	<cfelse>
	    <cfset url.longitude = "#val#">
	</cfif>

</cfloop>

<cf_screentop height="100%" html="no" layout="webapp" user="no" label="Find location" banner="yellow" option="Google MAP integration tool">

<table width="100%" height="100%">

	<cfif url.search eq "Yes">
	
	<tr>
			<td height="20" colspan="2" align="center" style="padding:15px">
				<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">		
				    <tr><td height="1"></td></tr>	
					<tr class="labelmedium">	
					<td width="100"><cf_tl id="Country"></td>	
					<td>
													
						<cfquery name="Nation" 
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM Ref_Nation
						</cfquery>
						
						<cfif url.latitude neq "" and url.longitude neq "">
						
							<cfinvoke component="service.maps.googlegeocoder3" 
							          method="googlegeocoder3" 
									  returnvariable="details">	  	
									  <cfinvokeargument name="latlng" value="#url.latitude#,#url.longitude#">			
									  <cfinvokeargument name="ShowDetails" value="false">			  
							</cfinvoke>	  	
						
							<cfset cnt = details.Formatted_Address>
						
						<cfelse>
						
						   <cfset cnt = "">
						
						</cfif>
						
						<select name="country" id="country" required="No" class="regularxl">
						    <cfoutput query="Nation">
								<option value="#Code#" <cfif find(Name,cnt)>selected</cfif>>#Name#</option>
							</cfoutput>
					   	</select>						
					
					</tr>		
					
					<cfset city    = "">
					<cfset address = "">
					<cfloop index="val" list="#details.Formatted_Address#" delimiters=",">
					
						<cfif address eq "">
						    <cfset address  = "#trim(val)#">
						<cfelseif city eq "">
						    <cfset city = "#trim(val)#">
						</cfif>
	
					</cfloop>
							
					<cfoutput>	
					<tr>	
					<td class="labelmedium"><cf_tl id="City">:</td>	
					<td><input type="text" name="addresscity" id="addresscity" style="width:96%" value="#city#" class="regularxl"  onchange="mapaddress('dialog')"></td>
					</tr>					
					<tr>	
					<td class="labelmedium"><cf_tl id="Address">:</td>	
					<td><input type="text" name="address" id="address" style="width:96%" value="#address#" class="regularxl" onchange="mapaddress('dialog')"></td>
					</tr>	
					</cfoutput>								
				</table>
			</td>
	</tr>
	
	<cfelse>
	
	<tr><td height="10"></td></tr>
			
	</cfif>	

<tr><td height="96%" width="92%" id="mapcontent" colspan="2" align="center">	
	<cfinclude template="MapContent.cfm">
</td></tr>

</table>	

<cf_screenbottom layout="webapp">
