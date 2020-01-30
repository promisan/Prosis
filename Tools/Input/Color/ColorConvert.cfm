<cffunction name="Complement">
	<cfargument name="strnumber" type="string">
	<cfargument name="limit" >

	<cfset vresult = strnumber>	
	<cfloop index="j" from="1" to="#limit-Len(strnumber)#">
		<cfset vresult = 0 & vresult>
	</cfloop>

	<cfreturn vresult>
</cffunction>



<cfparam name="attributes.rgb" default="">
<cfparam name="attributes.variable" default="result">

<cfset strcolor = attributes.rgb>

<cfset strcolor = replaceNoCase(strcolor,"rgb","","all")>
<cfset strcolor = replaceNoCase(strcolor,"(","","all")>
<cfset strcolor = replaceNoCase(strcolor,")","","all")>
<cfset strcolor = replaceNoCase(strcolor,"##","","all")>

<cfset result = "##">
<cfloop list="#strcolor#" index="i">
	<cfif isNumeric(i)>
		<cfset result = result & Complement(FormatBaseN(i, 16 ),2)>
	<cfelse>
		<cfset result = result & i>	
	</cfif>
</cfloop>

<cfset result = replaceNoCase(result,"##","","all")>

<cfset "caller.#attributes.variable#" = result> 