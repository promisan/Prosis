<cfparam name="attributes.id"			default="side-menu">
<cfparam name="attributes.sublevel"		default="no">

<cfset vSubLevel = "">
<cfif trim(lcase(attributes.sublevel)) eq "1" or trim(lcase(attributes.sublevel)) eq "yes">
	<cfset vSubLevel = "nav-second-level">
<cfelse>
	<cfif trim(lcase(attributes.sublevel)) eq "2" or trim(lcase(attributes.sublevel)) eq "yes">
		<cfset vSubLevel = "nav-third-level">
	</cfif>
</cfif>


<cfif thisTag.ExecutionMode is "start">
	<cfoutput>
		<ul class="nav #vSubLevel#" id="#attributes.id#">
	</cfoutput>
<cfelse>
	</ul>
</cfif>	