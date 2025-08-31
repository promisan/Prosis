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
<cf_param name="url.destination" 		default="" type="string">
<cf_param name="url.validationactionid" default="" type="string">

<cfquery name="get" 
	datasource="appsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   ValidationAction
	WHERE  ValidationActionId = '#url.validationactionid#'
</cfquery>	

<cfquery name="qAction" 
	datasource="appsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Validation
	WHERE  ValidationCode = '#get.validationCode#'
</cfquery>	

<cf_screentop label="#qAction.ValidationTitle#"    
   bannerheight="50" 
   banner="red" 
   height="100%"
   layout="webapp">

<cfoutput>

<table width="100%" height="100%" bgcolor="ffffff">

	<tr><td style="border-bottom:1px solid black;height:40px">
		<table width="100%" height="100%">		
			<tr>
				<td align="left" class="labelmedium" style="font-size:19px;padding-left: 15px;">	
				<font color="0080C0">			
					<cf_tl id="#qAction.ValidationInstructions#">
				</font>	
				</td>		
			</tr>			
		</table>		
	</td></tr>
	<tr class="hide">
		<td>
		
		<cfset vid = replaceNoCase(url.validationactionid,"-","","ALL")> 
			
		<input type="button" name="test" id="validationrefresh" value="test" 
		onClick="opener.document.getElementById('content_#get.systemfunctionid#_#vid#_refresh').click()">
		
		</td>
	</tr>
	<tr><td height="100%" style="padding-bottom:8px;padding-top:6px">	
		<cfset destination = replaceNocase(url.destination,"|","&","ALL")> 
		<iframe src="#SESSION.root##destination#&entryscope=validation" width="100%" height="100%" frameborder="0"></iframe>	
	</td></tr>
	<tr><td align="center" bgcolor="E04937" style="border-top:1px solid black;height:20px" class="labellarge"></td></tr>

</table>
</cfoutput>