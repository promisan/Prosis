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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Function class Entry/Edit</title>
</head>

<body leftmargin="2" topmargin="2" rightmargin="2" bottommargin="2">
<cfoutput>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
<html>




<cfform name="AddAttr" method="post" action="AttrSubmit.cfm?id=#url.id#">
<cfif #URL.AttrName# neq "">
	<cfquery name="details" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM ClassFunctionAttribute
		WHERE ClassFunctionId = '#URL.Id#'
		and Attribute='#URL.AttrName#' 
		order by created 
	</cfquery>

	<input type="hidden" id="update" name="update" value="Yes">
	<input type="hidden" id="AttrOld" name="AttrOld" value="#URL.AttrName#">
<cfelse>
	<input type="hidden" id="update" name="update" value="No">		
</cfif>

<input type="hidden" id="ClassId" name="ClassId"  value="#URL.ID#" >

<table width="99%" cellspacing="0" cellpadding="0" class="formpadding">
	<tr>
		<td>Name:</td>
		<td valign="top">
			<input type="text" name="AttrName" id="AttrName" size="40" maxlength="20" class="regular" value="#URL.AttrName#">
		</td>
	</tr>

	<tr>
		<td>Format:</td>
		<td valign="top">
			<cfif #URL.AttrName# neq "">	
				<input type="text" name="Format" id="Format" size="50" maxlength="50" class="regular" value="#preservesinglequotes(details.Format)#" >
			<cfelse>
				<input type="text" name="Format" id="Format" size="50" maxlength="50" class="regular" value="" >	
			</cfif>
		</td>
	</tr>
	
	<tr>
		<td>Required?</td>
		<td valign="top">
			<cfif #URL.AttrName# neq "">	
				<input type="radio" name="Required" id="Required" value="0" <cfif details.required eq "0">checked</cfif>> No
				<br>
				<input type="radio" name="Required" id="Required" value="1" <cfif details.required eq "1">checked</cfif>> Yes
			<cfelse>
				<input type="radio" name="Required" id="Required" value="0" checked> No
				<br>
				<input type="radio" name="Required" id="Required" value="1" > Yes
			</cfif>
		</td>
	</tr>
	
	<tr>
		<td>Default Value:</td>
		<td valign="top">
			<cfif #URL.AttrName# neq "">	
				<input type="text" name="DefaultValue" id="DefaultValue" size="40" maxlength="20" class="regular" value="#details.DefaultValue#"  >
			<cfelse>
				<input type="text" name="DefaultValue" id="DefaultValue" size="40" maxlength="20" class="regular" value=""  >	
			</cfif>
		</td>
	</tr>

	<tr>
		<td>Description:</td>
		<td style="border: 1px solid Gray;">
		  <cf_textarea 
		  		 name="description" 
				 height="180" 				 
				 toolBar="Basic" 	
				 tooltip="Comments,Relevant Information"			 
				 richtext="true" 
				 skin="silver">
					<cfif #URL.AttrName# neq "">					 
						#details.description#				 
					</cfif>					
		 </cf_textarea>
	
		</td>
	</tr>
	
	<tr><td colspan="2" bgcolor="silver"></td></tr>	
	<tr><td align="center" colspan="2"><input value="Save" type="submit" class="button10g" name="Save" id="Save"></td></tr>
</table>
	
</cfform>	
</cfoutput>

</html>
</body>