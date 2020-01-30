
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

<cf_divscroll>
<table width="100%" cellspacing="0" cellpadding="0" bgcolor="ffffff">

<tr><td valign="top" style="padding:5px">

<cfform name="inquiryform" id="inquiryform">

<table width="97%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr><td colspan="2">			
		<cfinclude template="InquiryEditQuery.cfm">		
	</td></tr>  		
	
	<tr id="detailfunction" name="detailfunction" class="#cl#">
	
	   <td colspan="2">
	   
	   	<cfif URL.SystemFunctionId eq "">
		
			<cfdiv id="fields"/>	
			
		<cfelse>
	
			<cfdiv id="fields"
			bind="url:#SESSION.root#/System/Modules/InquiryBuilder/InquiryEditFields.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#"/>	
		
		</cfif>
	
	   </td>
	</tr>
	
	<tr><td colspan="2" style="padding-top:5px">
	
		<table width="100%" cellspacing="0" class="formpadding">
		<!---
			<tr><td style="padding-left:3px" class="labellarge"><b>Application settings</td></tr>
			<tr><td class="linedotted"></td></tr>	
			--->
			<tr><td>
			<cfinclude template="InquiryEditSettings.cfm">	
			</td></tr>	
			<tr><td class="line"></td></tr>		
		</table>
	
	</td>
	</tr>
	
	<tr><td colspan="2" height="1" id="deploy"></td></tr>
	
	<tr><td colspan="1" align="center">	
	   <cfdiv id="bottom" 
	       bind="url:#SESSION.root#/System/Modules/InquiryBuilder/SubBottom.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#&datasource={querydatasource}">	
	</td>
	<td class="regular" id="result" align="right"></td>
	</tr>		

</table>

</cfform>

</td></tr></table>

</cf_divscroll>

<cfif URL.SystemFunctionId neq "">

		<script>
		     show('regular')			 
		</script>
		
</cfif>	

</cfoutput>
