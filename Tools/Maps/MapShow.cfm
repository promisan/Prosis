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
<cfparam name="url.latitude"         default="">
<cfparam name="url.longitude"        default="">

<cfparam name="attributes.scope"     default="embed">
<cfparam name="attributes.script"    default="yes">
<cfparam name="attributes.mode"      default="edit">
<cfparam name="attributes.width"     default="400">
<cfparam name="attributes.height"    default="300">
<cfparam name="attributes.latitude"  default="#url.latitude#">
<cfparam name="attributes.longitude" default="#url.longitude#">
<cfparam name="attributes.country"   default="">
<cfparam name="attributes.city"   	 default="">
<cfparam name="attributes.address" 	 default="">
<cfparam name="attributes.format"    default="map">
<cfparam name="attributes.zoomlevel" default="15">

<cf_mapscript scope = "#attributes.scope#"
              mode  = "#attributes.mode#"
			  width = "#attributes.width#" 
			  height= "#attributes.height#">

<cfoutput>

<table width="#attributes.width+4#" height="#attributes.height+40#">
	 
</cfoutput>
	
<tr>
	<td height="100%" id="mapcontent" align="center">
	
			
	<cfset url.longitude = attributes.longitude>
	<cfset url.latitude  = attributes.latitude>
	<cfset url.country   = attributes.country>
	<cfset url.city      = attributes.city>
	<cfset url.address   = attributes.address>
	<cfset url.mode      = attributes.mode>
	<cfset url.width     = attributes.width>
	<cfset url.height    = attributes.height>
	<cfset url.scope     = attributes.scope>
	<cfset url.format    = attributes.format>
	<cfset url.zoomlevel = attributes.zoomlevel>
		
		
	<cfinclude template="MapContent.cfm">

	</td>
</tr>

<!---
	
<cfif attributes.mode eq "edit">	
	
	<tr>
			<td height="20" align="center">
			<table cellspacing="0" cellpadding="0" class="formspacing">
			<tr>				
			<td><a href="javascript:mapaddress()" class="labelit"><font color="#0080C0"><cf_tl id="Show Address"></a></td>	
			<td>&nbsp;|&nbsp;</td>
			<!---
			<td><a href="javascript:mapzip()">Show Postal Code</a></td>
			<td>&nbsp;|&nbsp;</td>
			--->
			<td><a href="javascript:mapcoord()" class="labelit"><font color="#0080C0"><cf_tl id="Show Coordinates"></a></td>		
			</tr>
			</table>
			</td>
	</tr>

</cfif>	

--->

</table>	
