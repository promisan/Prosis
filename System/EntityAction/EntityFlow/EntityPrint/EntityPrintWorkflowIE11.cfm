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
<cfset url.showPrintButton = 0>
<cfhtmltopdf
	overwrite="yes"
	unit="in" 
	pagetype="A4"
	orientation="portrait"
	destination="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\Print_#URL.EntityCode#_#URL.EntityClass#_#URL.PublishNo#.pdf">
		<cfinclude template="EntityPrintWorkflow.cfm"> 	
</cfhtmltopdf>

<cfoutput>
	<script>
		parent.window.location = '#SESSION.root#/CFRStage/User/#SESSION.acc#/Print_#URL.EntityCode#_#URL.EntityClass#_#URL.PublishNo#.pdf';
	</script>
</cfoutput>