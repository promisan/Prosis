<cfparam name="attributes.id" 	default = "">
<cfparam name="attributes.src" 	default = "">

<cfoutput>
<cfif thisTag.executionmode is 'start'>


     <cfset tagdata = getbasetagdata("CF_PRESENTER")>
     
     <cfif tagdata.thisTag.executionmode neq 'inactive'>
		<!--- nada --->
     <cfelse>

       	<cfif tagdata.attributes.details eq "">
			<cfif attributes.src eq "">
				<cfset tagdata.attributes.details = "'#attributes.id#'">
			<cfelse>
				<cfset tagdata.attributes.details = "#attributes.src#">	
			</cfif>	
		<cfelse>
			<cfif attributes.src eq "">
				<cfset tagdata.attributes.details = "#tagdata.attributes.details#,'#attributes.id#'">
			<cfelse>
				<cfset tagdata.attributes.details = "#tagdata.attributes.details#,#attributes.src#">	
			</cfif>	
		</cfif>
		
		
     </cfif>

	
	<cfif attributes.src eq "" and attributes.id neq "">	
		<div id="#attributes.id#">
	</cfif>
	
<cfelse>

	<cfif attributes.src eq "" and attributes.id neq "">	
		<cfsavecontent variable="vreturn">
				#thisTag.GeneratedContent#
				</div>
		</cfsavecontent>

		<cfset thisTag.GeneratedContent = vreturn>
	</cfif>
	
</cfif>
</cfoutput>
