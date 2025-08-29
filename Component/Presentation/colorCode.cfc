<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfcomponent>

	<!--- Color Code From File --->
	<cffunction name="colorFile" output="false" returntype="string" access="public">
		<cfargument name="fileName" type="string" required="true" />
		<cfargument name="lineNumbers" type="boolean" default="true" />
		
		<cfset var local = StructNew() />
		
		<cftry>
			
		<cffile action="read" file="#arguments.fileName#" variable="local.fileContents" />
		
		<cfcatch>
		<cfoutput>
		<br>
		<font size="3" color="FF0000">
		Sorry, your template <b>#arguments.fileName#</b> could not be located. <br><br>Please check path.
		</font>
		</cfoutput>
		<cfabort>
		</cfcatch>
		
		</cftry>
		
		<cfreturn colorString(local.fileContents, arguments.lineNumbers) />
		
	</cffunction>
		
	<!--- Color Code From String --->
	<cffunction name="colorString" output="false" returnType="string" access="public">
		<cfargument name="dataString" type="string" required="true" />
		<cfargument name="lineNumbers" type="boolean" default="true" />
		
		<cfset var local = StructNew() />

		<cfset local.data = trim(arguments.dataString) />		
		<cfset local.eof = false >

		<!--- replace 4 spaces with tab --->
		<cfset local.data = replace(local.data, "    ", chr(9), "all") />
        
		<!--- replace 3 spaces with tab --->
		<cfset local.data = replace(local.data, "   ", chr(9), "all") />
        
		<!--- Convert all quoted values to blue --->
		<cfset local.data = REReplaceNoCase(local.data, """([^""]*)""", "«span style=""color: ##0000ff""»""\1""«/span»", "all") />

		<!--- Convert all multi-line script comments to yellow background --->
		<cfset local.data = REReplaceNoCase(local.data, "(<!---(.*?)--->)", "«span style=""color: ##000000; background-color: ##FFFF99""»\1«/span»", "all") />
			
		<!--- Convert all single-line script comments to gray --->
		<cfset local.data = REReplaceNoCase(local.data, "(\/\/[^#chr(13)#]*)", "«span style=""color: ##9a9a9a""»«em»\1«/em»«/span»", "all") />

		<!--- Convert special characters so they do not get interpreted literally /> italicize and boldface --->
		<cfset local.data = REReplaceNoCase(local.data, "&([[:alpha:]]{2,}) />", "«strong»«em»&amp;\1 />«/em»«/strong»", "all") />
	
		<!--- Convert many standalone (not within quotes) numbers to blue, ie. myValue = 0 --->
		<cfset local.data = REReplaceNoCase(local.data, "(gt|lt|eq|is|,|\(|\))([[:space:]]?[0-9]{1,})", "\1«span style=""color: ##0000ff""»\2«/span»", "all") />
	
		<!--- Convert normal tags to navy blue --->
		<cfset local.data = REReplaceNoCase(local.data, "<(/?)((!d|b|c(e|i|od|om)|d|e|f(r|o)|h|i|k|l|m|n|o|p|q|r|s|t(e|i|t)|u|v|w|x)[^>]*)>", "«span style=""color: ##000080""»<\1\2>«/span»", "all") />
	
		<!--- Convert all table-related tags to teal --->
		<cfset local.data = REReplaceNoCase(local.data, "<(/?)(t(a|r|d|b|f|h)([^>]*)|c(ap|ol)([^>]*))>", "«span style=""color: ##008080""»<\1\2>«/span»", "all") />
	
		<!--- Convert all form-related tags to orange --->
		<cfset local.data = REReplaceNoCase(local.data, "<(/?)((bu|f(i|or)|i(n|s)|l(a|e)|se|op|te)([^>]*))>", "«span style=""color: ##ff8000""»<\1\2>«/span»", "all") />
	
		<!--- Convert all tags starting with "a" to green, since the others aren't used much and we get a speed gain --->
		<cfset local.data = REReplaceNoCase(local.data, "<(/?)(a[^>]*)>", "«span style=""color: ##008000""»<\1\2>«/span»", "all") />
	
		<!--- Convert all image and style tags to purple --->
		<cfset local.data = REReplaceNoCase(local.data, "<(/?)((im[^>]*)|(sty[^>]*))>", "«span style=""color: ##800080""»<\1\2>«/span»", "all") />
	
		<!--- Convert all ColdFusion, SCRIPT and WDDX tags to maroon --->
		<cfset local.data = REReplaceNoCase(local.data, "<(/?)((cf[^>]*)|(sc[^>]*)|(wddx[^>]*))>", "«span style=""color: ##800000""»<\1\2>«/span»", "all") />
	
		<!--- Convert all multi-line script comments to gray --->
		<cfset local.data = REReplaceNoCase(local.data, "(\/\*[^\*]*\*\/)", "«span style=""color: ##808080""»«em»\1«/em»«/span»", "all") />
	
		<!--- Convert left containers to their ASCII equivalent --->
		<cfset local.data = REReplaceNoCase(local.data, "<", "&lt;", "all") />

		<!--- Convert right containers to their ASCII equivalent --->
		<cfset local.data = REReplaceNoCase(local.data, ">", "&gt;", "all") />

		<!--- Line Numbers --->
        <cfif arguments.lineNumbers>
			<cfset local.data = replace(local.data,chr(9),"&nbsp;&nbsp;&nbsp;&nbsp;","all") />
			<cfset local.tempData = "" />
            <cfloop index="local.i" from="1" to="#listLen(local.data, "#chr(13)#")#">
                <cfset local.line = listGetAt(local.data, local.i, "#chr(13)#") />
                <cfset local.line = replace(local.line, "#chr(10)#", "", "all") />
                <cfset local.tempData = local.tempData & "«span style=""color: ##444444; background-color: ##EEEEEE""»#repeatString("&nbsp;", 4-len(local.i))##local.i#:«/span»«span style=""background-color: ##FFFFFF""»&nbsp;</span>#local.line#<br />" />
            </cfloop>
            <cfset local.data = local.tempData />
        <cfelse>
            <cfset local.data = "<pre>#local.data#</pre>" />
		</cfif>

		<!--- Revert all pseudo-containers back to their real values to be interpreted literally (revised) --->
		<cfset local.data = REReplaceNoCase(local.data, "«([^»]*)»", "<\1>", "all") />

		<cfreturn local.data>
	</cffunction>

</cfcomponent>