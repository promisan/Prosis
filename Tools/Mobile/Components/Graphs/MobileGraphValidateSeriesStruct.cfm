<cfparam name="attributes.struct"	default="#StructNew()#"  type="struct">

<cfset vSeries = attributes.struct>

<cfif not StructKeyExists(vSeries, "type")>
	<cfset vSeries.type = "">
</cfif>

<cfif not StructKeyExists(vSeries, "name")>
	<cfset vSeries.name = "">
</cfif>

<cfif not StructKeyExists(vSeries, "query")>
	<cfset vSeries.query = "">
</cfif>

<cfif not StructKeyExists(vSeries, "label")>
	<cfset vSeries.label = "">
</cfif>

<cfif not StructKeyExists(vSeries, "value")>
	<cfset vSeries.value = "">
</cfif>

<cfif not StructKeyExists(vSeries, "color")>
	<cfset vSeries.color = "green">
</cfif>

<cfif not StructKeyExists(vSeries, "colorMode")>
	<cfset vSeries.colorMode = "regular">
</cfif>

<cfif not StructKeyExists(vSeries, "transparency")>
	<cfset vSeries.transparency = "0.6">
</cfif>

<cfset caller.vSeries = vSeries>