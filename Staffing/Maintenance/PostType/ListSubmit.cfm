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
<cfquery name="Clean"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    DELETE 
	FROM   Ref_PostTypeGrade
	WHERE  PostType = '#Url.PostType#'
</cfquery>


<cfloop index="g" from="1" to="#Form.groups#" step="1">

	<cfif isDefined("Form.PostGrade_#url.posttype#_#g#")>

		<cfset glist = Evaluate("Form.PostGrade_#url.posttype#_#g#")>


		<cfloop index="i" list="#glist#" delimiters=",">
		
			<cfquery name="Insert"
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO Ref_PostTypeGrade
				VALUES(
					'#url.PostType#',
					'#i#',
					'#SESSION.acc#',
				    '#SESSION.last#',		  
					'#SESSION.first#',
					getDate()
				)
			</cfquery>
		
		</cfloop>
	
	</cfif>
	
</cfloop>

<font color="#0080C0">
Saved!
</font>