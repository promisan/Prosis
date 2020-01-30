<cfparam name="Attributes.chartLocation"	default="">
<cfparam name="Attributes.Style"			default="Default">
<cfparam name="Attributes.CustomStyle"		default="">
<cfparam name="Attributes.ShowLegend"		default="0">


<!--- Return value --->
<cfset vReturnValue = "">

<cfif ListFirst(SERVER.ColdFusion.ProductVersion, ",") gte 11>

	<!--- Initial variables --->
	<cfset vAbsPath = lcase(Attributes.chartLocation)>
	<cfset vRoot = lcase(session.rootPath)>
	<cfset vPathLevel = replace(vAbsPath,vRoot,"")>
	<cfset vPathLevel = "\"&vPathLevel>
	
	<!--- Clean path --->
	<cfloop condition="find('\\',vPathLevel) neq 0">
		<cfset vPathLevel = replace(vPathLevel,"\\","\","ALL")>
	</cfloop>
	
	<!--- Get the level count --->
	<cfset vLevelCount = ListLen(vPathLevel, "\") - 1>
	
	<!--- Generate the ../ --->
	<cfset vBackPath = "">
	<cfloop from="1" to="#vLevelCount#" index="backIndex">
		<cfset vBackPath = vBackPath & "../">
	</cfloop>
	
	<cfset vShowLegendPath = "">
	<cfif Attributes.ShowLegend eq 1>
		<cfset vShowLegendPath = "_Legend">
	</cfif>
	
	<cfset vReturnValue = vBackPath & "Tools/Charts/Styles/chartStyle_" & Attributes.Style & vShowLegendPath & ".cfm">
	
	<cfif trim(Attributes.CustomStyle) neq "">
		<cfset vReturnValue = vBackPath & Attributes.CustomStyle>
	</cfif>
	
<cfelse>

	<cfset vReturnValue = "default">
	
</cfif>

<cfset caller.chartStyleFile = vReturnValue>