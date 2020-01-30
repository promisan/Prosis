<cfparam name="attributes.template"				default="">
<cfparam name="attributes.removeHTMLSpaces"		default="0">
<cfparam name="attributes.sendToFile"			default="0">

<cfif trim(attributes.template) neq "">
	<cfsavecontent variable="vTheMainContent">
		<cfinclude template="#attributes.template#">
	</cfsavecontent>

	<!--- reducing output --->
	<cfset vTheMainContent = replace(vTheMainContent,"	","","ALL")>
	<cfset vTheMainContent = replace(vTheMainContent,"#chr(13)#","","ALL")>
	<cfif trim(lcase(attributes.removeHTMLSpaces)) eq "yes" OR trim(lcase(attributes.removeHTMLSpaces)) eq "1">
		<cfset vTheMainContent = replace(vTheMainContent,"&nbsp;","","ALL")>
	</cfif>

	<!--- outputting --->
	<cfoutput>#preserveSingleQuotes(vTheMainContent)#</cfoutput>

	<!---send to file--->
	<cfif trim(lcase(attributes.sendToFile)) eq "yes" OR trim(lcase(attributes.sendToFile)) eq "1">
		<cfsilent>
			<cfoutput>
				<cf_logpoint filename="__logMinimized.txt">
					#vTheMainContent#
				</cf_logpoint>
			</cfoutput>
		</cfsilent>
	</cfif>
</cfif>