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
<cfparam name="Attributes.Name" 			default="PresentationColor">
<cfparam name="Attributes.Mode" 			default="Extended">
<cfparam name="Attributes.Value" 			default="white">
<cfparam name="Attributes.Style" 			default="">
<cfparam name="Attributes.Ajax" 			default="No">


<cfoutput>
	
<input type = "color"
	name    = "#Attributes.Name#"  
	id      = "#Attributes.Name#"  
	value   = "#Attributes.Value#"
	<cfif Attributes.Style neq "">
		style   = "#Attributes.Style#"
	</cfif>
	
	/>

</cfoutput>	


<cfif attributes.mode neq "Extended">

		<cfsavecontent variable="vjson">{"showPaletteOnly":true,"showPalette":true,"showAlpha":true,"color":"<cfoutput>#Attributes.Value#</cfoutput>","palette":
		[<cfif attributes.mode eq "limited" or attributes.mode gte 10>
			["black", "DarkGray", "white", "WhiteSmoke", "Linen"],
			["Crimson", "red", "IndianRed", "Coral", "Orange"]
		</cfif>
		<cfif attributes.mode gte 20>,
			["magenta", "Violet" , "PaleVioletRed", "LightPink", "Plum"],
			["Chocolate", "DarkSalmon",  "blanchedalmond", "yellow",  "Khaki"]
		</cfif>
		<cfif attributes.mode gte 30>
			,[ "DarkSlateBlue", "blue", "CornflowerBlue", "lightblue", "PaleGoldenRod"],
			[ "green", "Olive", "Teal", "MediumAquaMarine",  "Turquoise"]
		</cfif>]}</cfsavecontent>
	
		<cfset vjson = Replace(vjson,chr(13),"","ALL")>
		<cfset vjson = Replace(vjson,chr(10),"","ALL")>
		<cfset vjson = Replace(vjson,chr(9),"","ALL")>		
		<cfset vjson = Replace(vjson," ","","ALL")>		

		<cfoutput>
			<input type="hidden" id="__#Attributes.Name#" name="__#Attributes.Name#" value='#vjson#'>
		</cfoutput>

		<cfif Attributes.Ajax eq "No">
			<script>
				$(document).ready(function() {
					try {
						var config = $('#__<cfoutput>#Attributes.Name#</cfoutput>').val();
						var obj = jQuery.parseJSON(config);
						$("#<cfoutput>#Attributes.Name#</cfoutput>").spectrum(obj);
					} 
					catch (e) {
						// alert(e);
					}						
				});
			</script>     
		</cfif>
		

</cfif>

