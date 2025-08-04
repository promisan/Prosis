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
<cfsavecontent variable="content" >
	<cfinclude template="OrgTreePrintBody.cfm">
</cfsavecontent>


<cftry>
	<cfdirectory action="CREATE" 
	             directory="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#">
	<cfcatch></cfcatch>
</cftry>
	
<cftry>
	<cffile action="WRITE" file="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#URL.Mission#.htm" output="#content#">
	<cfcatch></cfcatch>
</cftry>

<cfhtmltopdf
	overwrite="yes"
	unit="in" 
	pagetype="A4"
	orientation="landscape"
	destination="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#URL.Mission#.pdf" 
	source="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#URL.Mission#.htm">
</cfhtmltopdf>

<cfoutput>
	<script>
		window.location = '#SESSION.root#/CFRStage/User/#SESSION.acc#/#URL.Mission#.pdf'
	</script>
</cfoutput>