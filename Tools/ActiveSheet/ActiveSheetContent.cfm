
<cfparam name="Attributes.resolution"  default="40">
<cfparam name="Attributes.content"  default="">
<cfparam name="Attributes.module"  default="CaseFile">

<cfif attributes.module eq "CaseFile">

	<cfinclude template="CaseFile/ActiveSheetContent.cfm">

</cfif>