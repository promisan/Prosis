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
<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM PortalLinks
WHERE PortalId = '#URL.PortalId#'
</cfquery>

<cfparam name="url.mode" default="">

<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">

<cfquery name="Custom"
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     SELECT *
		FROM Ref_ModuleControl
		WHERE SystemModule = 'SelfService'
		AND FunctionClass IN ('SelfService','Report')		
		AND MenuClass = 'Main'
		ORDER BY FunctionName
 </cfquery>
	 
<cfif url.mode eq "Custom" or url.mode eq "CustomLeft" or url.mode eq "Press">

<TR class="labelmedium">
    <td width="120">Portal:</td>
    <TD>
	<select name="SystemFunctionId" id="SystemFunctionId" class="regularxl"> 
	<cfloop query="Custom">
	   <option value="#SystemFunctionId#" <cfif get.systemfunctionid eq SystemFunctionId>selected</cfif> >#FunctionName#</option>
	</cfloop>
	
	</TD>
</TR>

<tr><td height="5" colspan="2"></td></tr> 

<cfelse>

<input type="hidden" name="SystemFunctionId" id="SystemFunctionId" value="">

</cfif>

<cfif url.mode neq "Press" or get.recordcount eq "1">

	<tr class="labelmedium">
	<td width="203">URL to link:</td>
	<td>
		<input type="Text" name="LocationURL" id="LocationURL" message="Please enter a URL" value="#Get.LocationURL#" size="50" maxlength="80" class="regularxl">
	</td>
	</tr>	
		
	<cfquery name="Functions"
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     SELECT *
		FROM Ref_ModuleControl
		WHERE FunctionClass IN ('Manuals')				
		ORDER BY FunctionName
	 </cfquery>
		
	<tr class="labelmedium">
	<td><cf_UIToolTip tooltip="string after the URL like (id=3) which is positioned after the URL">Query string</cf_UIToolTip></td>
	<td>
		<input type="Text" name="LocationString" id="LocationString" size="50" value="#Get.LocationString#" maxlength="80" class="regularxl">
	</td>
	</tr>	
	
	 <tr><td height="5" colspan="2">&nbsp;or</td></tr> 
	 
	<TR class="labelmedium">
    <td width="120">Recorded Function:</td>
    <TD>
	<select name="LocationFunctionId" id="LocationFunctionId" class="regularxl"> 
	    <option value="">n/a</option>
		<cfloop query="Functions">
		   <option value="#SystemFunctionId#" <cfif get.locationfunctionid eq SystemFunctionId>selected</cfif> >#FunctionName#</option>
		</cfloop>
	</select>
	
	</TD>
</TR>
   	
<cfelse>

	<tr>

	<td class="labelit" width="98">URL host:</td>
	<td>
   	 	<input type="text"
	       name="LocationRoot"
		   id="LocationRoot"
    	   size="50" maxlength="80"
		   value="#SESSION.rootDocument#"
	       class="regularxl">
	</td>
	</tr>	
	
	<tr><td height="5" colspan="2"></td></tr> 

	<tr><td class="labelit">Press Release:</td>
	<td>
		<input type="file"
	       name="LocationURL"
		   id="LocationURL"
    	   size="46"
		   value=""
    	   class="regularxl">
	</td> 
	</tr>
	   	
</cfif>	

</table>
   
</cfoutput>  