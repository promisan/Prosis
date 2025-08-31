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
	
	<cffunction name="LookupOptions" returnType="string">
			
		<cfoutput>
		
			<cf_tl id = "contains"    var = "vContains">
			<cf_tl id = "begins with" var = "vBegins">
			<cf_tl id = "ends with"   var = "vEnds">
			<cf_tl id = "is"          var = "vIs">
			<cf_tl id = "is not"      var = "vIsNot">
			<cf_tl id = "before"      var = "vBefore">
			<cf_tl id = "after"       var = "vAfter">												
			
			<cfsavecontent variable = "content">
			
				<OPTION value="CONTAINS">#vContains#
				<OPTION value="BEGINS_WITH">#vBegins#
				<OPTION value="ENDS_WITH">#vEnds#
				<OPTION value="EQUAL">#vIs#
				<OPTION value="NOT_EQUAL">#visNot#
				<OPTION value="SMALLER_THAN">#vBefore#
				<OPTION value="GREATER_THAN">#vAfter#
				
			</cfsavecontent>
			
		</cfoutput>
	
		<cfreturn content>
		
	</cffunction>
		
</cfcomponent>
