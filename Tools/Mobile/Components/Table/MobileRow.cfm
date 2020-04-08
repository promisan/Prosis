<cfparam name="attributes.id"			default="">
<cfparam name="attributes.class"		default="">
<cfparam name="attributes.style"		default="">
<cfparam name="attributes.onclick"		default="">

<cfif thisTag.ExecutionMode is "start">
	<cfoutput>
		<div class="row #attributes.class#" style="#attributes.style#" <cfif trim(attributes.id) neq "">id="#trim(attributes.id)#"</cfif> onclick="#attributes.onclick#">
	</cfoutput>
<cfelse>
	<cfoutput>
		</div>
	</cfoutput>
</cfif>	