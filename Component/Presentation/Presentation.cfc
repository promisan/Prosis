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
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Presentation Functions">
	
	<!--- 1.0 GENERAL ACCESS TO A FUNCTION --->
	
	<cffunction access="public" name="highlight" output="true" returntype="string" 	displayname="Presentation">
		
		<cfargument name="class"   default="highlight1"/>
		<cfargument name="neutral" default="regular"/>
			
		<cfsavecontent variable="style">	
		
		<cfoutput>
			
		<cfif find("MSIE","#CGI.HTTP_USER_AGENT#") or (find("Mozilla/5.0","#CGI.HTTP_USER_AGENT#") 
				and find("Trident","#CGI.HTTP_USER_AGENT#") 
				and find("rv:11","#CGI.HTTP_USER_AGENT#") 
				and find("like Gecko","#CGI.HTTP_USER_AGENT#"))>											
			onmouseover="if (this.className=='#neutral#') {this.className='#class#'} else {if (this.className !='highlight') {this.className='#class#'}}"
			onmouseout="if (this.className=='#class#') {this.className='#neutral#'}"		
		<cfelse>
			onmouseover=  "if (this.getAttribute('class')=='#neutral#') { this.setAttribute('class','#class#') } "
			onmouseout =  "if (this.getAttribute('class')=='#class#') { this.setAttribute('class','#neutral#') }"			
		</cfif>		
		
		</cfoutput>
		
		</cfsavecontent>		
		
		<cfreturn style>
		
	</cffunction>
		
	<cffunction 
		access="public" 
		name="highlight2" 
		output="true" 
		returntype="string" 	
		displayname="Presentation">
		
		<cfargument name="allowSelect" 			default="yes"/>
		<cfargument name="allowKeyNavigation" 	default="yes"/>
		<cfargument name="multiselect" 			default="no"/>
		<cfargument name="prefix" 				default="__ProsisPresentation_Row_"/>
		<cfargument name="rowCounter"			default="currentrow"/>
		<cfargument name="highlighColor"		default="FFFFCF"/>
		<cfargument name="selectedColor"		default="F9D1AA"/>
		
		<cfset vMultiselect = 0>
		<cfif lcase(multiselect) eq "yes" or lcase(multiselect) eq "true" or lcase(multiselect) eq "1">
			<cfset vMultiselect = 1>
		</cfif>
			
		<cfsavecontent variable="style">	
		
			<cfoutput>
				id="#prefix##rowCounter#" 
				onmouseover="__ProsisPresentation_HighlightRow('#prefix#', '#rowCounter#', '#highlighColor#');" 
				onmouseout="__ProsisPresentation_ClearHighlightRow('#prefix#', '#rowCounter#');" 
				<cfif lcase(allowSelect) eq "yes" or lcase(allowSelect) eq "true" or lcase(allowSelect) eq "1">
					onclick="__ProsisPresentation_SelectRow('#tableListingId#', #vMultiselect#, '#prefix#', '#rowCounter#', '#selectedColor#');"
					<cfif lcase(allowKeyNavigation) eq "yes" or lcase(allowKeyNavigation) eq "true" or lcase(allowKeyNavigation) eq "1">
						onkeydown="__ProsisPresentation_PreventScrolling(event);"
						onkeyup="__ProsisPresentation_HighlightNextRow('#tableListingId#', '#prefix#', '#rowCounter#', '#selectedColor#', event);"
					</cfif>
				</cfif>
			</cfoutput>
		
		</cfsavecontent>		
		
		<cfreturn style>
		
	</cffunction>
	
	
</cfcomponent>	
	
