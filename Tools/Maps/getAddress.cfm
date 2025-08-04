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

<cfparam name="url.coordinates" default="">
<cfparam name="attributes.coordinates" default="#url.coordinates#">

<cfparam name="url.latitude"  default="">
<cfparam name="url.longitude" default="">

<cfif attributes.coordinates neq "">
									  
	<cfloop index="val" list="#attributes.coordinates#" delimiters=":,">
							
		<cfif url.latitude eq "">
		    <cfset url.latitude  = "#val#">
		<cfelse>
		    <cfset url.longitude = "#val#">
		</cfif>
							
	</cfloop>
	
</cfif>	

		<cfinvoke component="service.maps.googlegeocoder3" 
	          method="googlegeocoder3" 
			  returnvariable="details">	  
	
			  <cfinvokeargument name="latlng" value="#url.latitude#,#url.longitude#">			
			  <cfinvokeargument name="ShowDetails" value="false">
			  
		</cfinvoke>	  

<cfoutput>

    <table><tr><td class="labelmedium" style="padding-right:4px">

	#details.Formatted_Address# <!--- <font face="Arial" size="1">[#url.latitude#:#url.longitude#]</font> --->
	
	</td></tr></table>

</cfoutput>
	
	