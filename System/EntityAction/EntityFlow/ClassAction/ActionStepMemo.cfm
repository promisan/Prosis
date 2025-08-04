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

<cfif URL.PublishNo eq "">

	<cfquery name="Line" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityClassAction
	WHERE ActionCode  = '#URL.ActionCode#'
	AND   EntityClass = '#URL.EntityClass#'
	AND   EntityCode  = '#URL.EntityCode#' 
	</cfquery>
	
<cfelse>

	<cfquery name="Line" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_EntityActionPublish A
	WHERE A.ActionCode    = '#URL.ActionCode#'
	AND A.ActionPublishNo = '#URL.PublishNo#'
	</cfquery>
	
</cfif>	
	
<cfoutput>

<cfform action="ActionStepMemoSubmit.cfm?actioncode=#url.actioncode#&entityclass=#url.entityclass#&entitycode=#url.entitycode#&publishNo=#url.publishno#" method="POST" name="actionform">

<table width="100%" height="686" border="0" align="center">

	<tr>
	<td style="padding-left:13px" height="35">	
		<input class="button10g" type="submit" style="width:200" onclick="updateTextArea()" name="Memo" id="Memo" value="Save">
	</td>
	</tr>	
    
	<tr>
        <td colspan="2" align="center" valign="top" style="padding-top:3px;height:100%;border: 0px solid silver;">									   
	     <cf_textarea name = "ActionSpecification" color="ffffff" height="100%">#Line.ActionSpecification#</cf_textarea>		   				
	</TR>	
	
	
</table>
	
</cfform>		

<cfset AjaxOnLoad("initTextArea")>
	
</cfoutput>	