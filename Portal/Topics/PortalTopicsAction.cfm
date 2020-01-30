
<cfif URL.ID neq "">

   <cfswitch expression="#URL.Act#">
   
   <cfcase value="min">
   
   <cfquery name="Delete" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE UserModule 
	SET    Status = '0'
	WHERE  SystemFunctionId = '#URL.ID#'
	AND    Account = '#SESSION.acc#'
   </cfquery>
      
   <!--- nothing to show --->
   
   
   </cfcase>
   
   <cfcase value="max">
   
   <cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE UserModule 
	SET    Status = '1'
	WHERE  SystemFunctionId = '#URL.ID#'
	AND    Account = '#SESSION.acc#'
   </cfquery>
	      
	<cfquery name="get" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   M.FunctionMemo, 
		         M.FunctionPath, 
				 U.Status, 
				 U.Account, 
				 U.SystemFunctionId
		FROM     Ref_ModuleControl M, UserModule U
		WHERE    M.SystemFunctionId = U.SystemFunctionId 
		AND      M.SystemModule = 'Portal' 
		AND      M.Operational  = '1' 
		AND      M.MenuClass    = 'Topic'
		AND      U.Account      = '#SESSION.acc#' 
		AND      M.SystemFunctionId = '#url.id#'
		ORDER BY U.OrderListing, M.FunctionClass, M.MenuOrder 
	</cfquery>
   
    <cfset scope = "topic">
	<cfset systemfunctionid = url.id>	
	<cfinclude template="#get.FunctionPath#/Topic.cfm">
   
   </cfcase>

   </cfswitch>

</cfif>