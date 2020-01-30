<cfparam name="Attributes.Input" default="">
<cfparam name="Attributes.InputOld" default="">

<cfif ListLen(Attributes.Input) gt 1>
	<cfset output = "#ListFirst(Attributes.Input)#">
<cfelseif Attributes.InputOld eq "">	
	<cfset output="#Attributes.Input#">	
<cfelse>
	<cfset output = "">
</cfif>

<cfset Caller.inputoutput = "#output#">
