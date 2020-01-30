
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
	
	