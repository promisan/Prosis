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

