<cfparam name="attributes.id"			default="">
<cfparam name="attributes.class"		default="">
<cfparam name="attributes.style"		default="">

<cfif thisTag.ExecutionMode is "start">
	<cfoutput>
		<div class="row #attributes.class#" style="#attributes.style#" <cfif trim(attributes.id) neq "">id="#trim(attributes.id)#"</cfif>>
	</cfoutput>
<cfelse>
	<cfoutput>
		</div>
	</cfoutput>
</cfif>	