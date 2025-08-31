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
<cf_param name="url.acc" 		  default="#session.acc#" type="string">
<cf_param name="url.width" 		  default="54px"			type="string">
<cf_param name="url.height" 	  default="44px"			type="string">
<cf_param name="url.destination"  default="EmployeePhoto" type="string">
<cf_param name="url.style" 		  default="" 				type="string">

<cfoutput>

	<cf_assignid>
	
	<cfif FileExists("#SESSION.rootDocumentPath#\#url.destination#\#url.acc#.jpg") and url.acc neq "">
		
		<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
		<cfset mid = oSecurity.gethash()/>
		
		<cftry>
			<cfdirectory action="CREATE" directory="#SESSION.rootDocumentPath#\CFRStage\EmployeePhoto">
			<cfcatch></cfcatch>
	    </cftry>
				
		<cffile action="COPY"
				source="#SESSION.rootDocumentpath#\#url.destination#\#url.acc#.jpg"
				destination="#SESSION.rootDocumentPath#\CFRStage\EmployeePhoto\#url.acc#.jpg" nameconflict="OVERWRITE">
			
		<img src="#SESSION.root#/CFRStage/getFile.cfm?id=#url.acc#.jpg&mode=EmployeePhoto&mid=#mid#"
			border="0px"
			style="display:block; cursor:pointer; height:#url.height#; width:#url.width#; #url.style#"
			align="absmiddle">

	<cfelse>
	
		<img src="#SESSION.root#/Images/Logos/no-picture-male.png"			
			title="Click here to add a Profile Picture"
			border="0px"
			align="absmiddle"
			style="display:block; cursor:pointer; height:#url.height#; width:#url.width#; #url.style#">

	</cfif>

</cfoutput>