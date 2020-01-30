
<cfset i = 0>

<cfparam name="form.assetId" default="">

<cfif Form.AssetId neq "">

<cfloop index="itm" list="#Form.AssetId#" delimiters=",">
	<cfset i = i+1>
</cfloop>

</cfif>

<cfoutput><font size="4" color="008000"><b>#i#</b></cfoutput>

