

<cfquery name="Detail" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    DELETE FROM Ref_ModuleControlDetailField
	WHERE SystemFunctionId = '#URL.SystemFunctionId#'
	AND  FunctionSerialNo = '#url.FunctionSerialNo#'
	AND  FieldId = '#URL.FieldId#'
</cfquery>

<cfset url.id2 = "">

<cfinclude template="InquiryEditFields.cfm">