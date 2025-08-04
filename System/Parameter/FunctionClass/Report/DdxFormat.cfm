<!--
    Copyright © 2025 Promisan

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
<cfquery name="QClass" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM Class
		order by ClassId
</cfquery>

<cfoutput>
<cfloop query="QClass">

	<cfset fname=#QClass.ClassName#>
	<cfset fname=replace(fname," ","_","ALL")>
	<PDF result="s#fname#" >
		<PDF source="#fname#"  bookmarkTitle="Overview" includeInTOC="true"/>
		
		<cfquery name="QfType" 
			datasource="AppsControl" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT DISTINCT Class.ClassName, ClassFunction.ClassFunctionType,Ref_FunctionType.Name,Ref_FunctionType.ListingOrder
				FROM         ClassFunction INNER JOIN
			                 Class ON ClassFunction.ClassId = Class.ClassId INNER JOIN
							 Ref_FunctionType ON Ref_FunctionType.Code=ClassFunction.ClassFunctionType
				WHERE ClassFunction.ClassId='#QClass.ClassId#'			 
				ORDER BY Ref_FunctionType.ListingOrder
		</cfquery>

		
		<cfloop query="QfType">
			<PDF source="#fname#_Details_#QfType.ClassFunctionType#"  bookmarkTitle="#QfType.Name#" includeInTOC="true"/>											
		</cfloop>
		
		
	</PDF>	

</cfloop>
</cfoutput>



	 
