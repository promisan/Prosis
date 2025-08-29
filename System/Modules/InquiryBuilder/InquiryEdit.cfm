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
<cfparam name="URL.SystemFunctionId" default="">
<cfparam name="URL.FunctionSerialNo" default="1">

<cfif URL.SystemFunctionId eq "">

	<cf_screentop height="100%" scroll="Yes" label="Listing Builder" option="Define configuration for an interactive listing" jQuery="Yes" layout="webapp" banner="gray">

	<cf_assignId>
	<cfset url.systemfunctionid = rowguid>
	
	<cfset cl = "hide">
	
<cfelse>

	<cfset cl = "regular">	
		
</cfif>	

<cfquery name="Header" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ModuleControl
	WHERE SystemFunctionId = '#URL.SystemFunctionId#'	
</cfquery>

<cfset new = "0">

<cfif Header.recordcount eq "0">

	<cfinclude template="InquiryScript.cfm">

	<cfset new = "1">
	
	<!---

	<cfquery name="Clean" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_ModuleControl
		WHERE MenuClass     = 'Builder'
		AND   Operational   = 0
		AND   SystemModule  = '#URL.SystemModule#'
		AND   FunctionClass = '#URL.FunctionClass#'
		AND   OfficerUserId = '#SESSION.acc#'
	</cfquery>	
	
	--->
	
	<cfquery name="counted" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ModuleControl
		WHERE  MenuClass     = 'Builder'		
		AND    SystemModule  = '#URL.SystemModule#'
		AND    FunctionClass = '#URL.FunctionClass#'		
	</cfquery>	
	
	<cftry>

		<cfquery name="Insert" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ModuleControl
			(SystemFunctionId,
			 SystemModule,
			 FunctionClass,
			 FunctionName,
			 MenuClass,
			 FunctionDirectory,
			 FunctionPath,
			 EnableAnonymous,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,
			 Operational)
			VALUES
			('#URL.SystemFunctionId#',
			 '#URL.SystemModule#',
			 '#URL.FunctionClass#',
			 '[listing #counted.recordcount#]',
			 'Builder',
			 'Tools/Listing',
			 'Listing/Inquiry.cfm',
			 '0',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#','0')	
		</cfquery>
	
	<cfcatch>

		<cfquery name="Check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * FROM Ref_ModuleControl
			WHERE SystemModule = '#URL.SystemModule#'
			AND   FunctionName = '[listing #counted.recordcount#]'
			AND   FunctionClass = '#URL.FunctionClass#'			
		</cfquery>
		
		<cfset url.systemfunctionid = check.systemfunctionid>
	
	</cfcatch>
	
	</cftry>
		
	<cfquery name="Header" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ModuleControl
		WHERE SystemFunctionId = '#URL.SystemFunctionId#'	
	</cfquery>

</cfif>

<cfquery name="Check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ModuleControlDetail
	WHERE SystemFunctionId = '#URL.SystemFunctionId#'
	AND  FunctionSerialNo  = '#URL.FunctionSerialNo#'
</cfquery>

<cfif Check.recordcount eq "0">

<cfquery name="Insert" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO Ref_ModuleControlDetail
	(SystemFunctionId,QueryDataSource,OfficerUserId,OfficerLastName,OfficerFirstName)
	VALUES
	('#URL.SystemFunctionId#','AppsSystem','#SESSION.acc#','#SESSION.last#','#SESSION.first#')	
</cfquery>

</cfif>

<cfquery name="List" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ModuleControlDetail
	WHERE  SystemFunctionId = '#URL.SystemFunctionId#'
	AND    FunctionSerialNo = '#URL.FunctionSerialNo#'
</cfquery>

<cfoutput>

<table width="100%" bgcolor="ffffff" style="height:100%">

<tr><td valign="top" style="padding:5px;height:100%">

<cf_divscroll>

<cfform name="inquiryform" id="inquiryform" style="height:98.5%">

<table width="97%" align="center">
  	
	<tr><td colspan="2"><cfinclude template="InquiryEditQuery.cfm"></td></tr>  	
			
	<tr id="detailfunction" name="detailfunction" class="#cl#">
	
	   <td colspan="2" valign="top" style="height:100%;padding-top:4px">
	    	
	   	<cfif URL.SystemFunctionId eq "">
		
			<cfdiv id="fields"/>	
			
		<cfelse>
	
			<cf_securediv id="fields"
			bind="url:#SESSION.root#/System/Modules/InquiryBuilder/InquiryEditFields.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#">	
		
		</cfif>
			
	   </td>
	</tr>
		
	<tr><td colspan="2">
	
		<table width="100%" cellspacing="0" class="formpadding">			
			<tr><td><cfinclude template="InquiryEditSettings.cfm"></td></tr>				
		</table>
	
	</td>
	</tr>
	
</table>

</cfform>

</cf_divscroll>

</td></tr>

<tr style="border-top:1px solid silver"><td colspan="2" height="1" id="deploy"></td></tr>
	
	<tr><td colspan="1" align="center" style="padding-top:5px;padding-bottom:4px">	
	   <cf_securediv id="bottom" 
	       bind="url:#SESSION.root#/System/Modules/InquiryBuilder/SubBottom.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#&datasource={querydatasource}">	
	</td>
	<td class="hide" id="result" align="right"></td>
	</tr>		

</table>

<cfif URL.SystemFunctionId neq "">

		<script>
		     show('regular')			 
		</script>
		
</cfif>	

</cfoutput>
