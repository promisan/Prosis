
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfif Len(Form.FunctionName) gt 40>
	 <cf_message message = "You entered a name that exceeded the allowed size of 40 characters."
	  return = "back">
	  <cfabort>
</cfif>

<cfif Len(Form.FunctionMemo) gt 100>
	 <cf_message message = "You entered a memo that exceeded the allowed size of 100 characters."
	  return = "back">
	  <cfabort>
</cfif>

<cfparam name="Form.ScriptName" default="">
<cfparam name="Form.FunctionDirectory" default="">
<cfparam name="Form.ScreenWidth" default="">
<cfparam name="Form.FunctionBackground" default="">
<cfparam name="Form.FunctionHost" default="">
<cfparam name="Form.EnableAnonymous" default="0">
<cfparam name="Form.AccessUserGroup" default="0">
<cfparam name="Form.MainMenuItem" default="0">
<cfparam name="Form.FunctionTarget" default="right">

<!--- check roles/groups --->
 
 <cfquery name="Check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT SystemFunctionId 
	FROM Ref_ModuleControlRole
	WHERE SystemFunctionId = '#URL.ID#'
	UNION ALL
	SELECT SystemFunctionId 
	FROM Ref_ModuleControlUserGroup
	WHERE SystemFunctionId = '#URL.ID#'
</cfquery>

<cfif Check.recordcount gte "1">
	 <cfset ano = 0>
<cfelse>
	 <cfset ano = Form.EnableAnonymous>
</cfif>

<cfparam name="form.applicationserver" default="">
<cfparam name="form.hostselect"        default="">

<cfquery name="Update" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_ModuleControl
SET      FunctionName         = '#Form.FunctionName#',
         MenuClass            = '#Form.MenuClass#',
		 MenuOrder            = '#Form.MenuOrder#',		
		 FunctionIcon         = '#Form.FunctionIcon#',
		 Operational          = '#Form.Operational#', 
		 FunctionMemo         = '#Form.FunctionModuleMemo#',
		 EnableAnonymous      = '#ano#',
		 MainMenuItem         = '#Form.MainMenuItem#',
		 EnforceReload        = '#Form.EnforceReload#',
		 FunctionBackground   = '#Form.FunctionBackground#',		 
		 AccessUserGroup      = '#Form.AccessUserGroup#',
		 BrowserSupport       = '#Form.BrowserSupport#',
		 ApplicationServer    = '#Form.ApplicationServer#',
		 <cfif Form.ScriptName eq "">
		     <cfif Form.HostSelect eq "1">
			 FunctionHost       = '#Form.FunctionHost#', 
			 <cfelse>
			 FunctionHost       = NULL, 
			 </cfif>
			 FunctionDirectory  = '#Form.FunctionDirectory#', 
			 FunctionPath       = '#Form.FunctionPath#',
			 FunctionCondition  = '#Form.FunctionCondition#', 
			 FunctionTarget     = '#Form.FunctionTarget#',
			 ScriptName         = NULL,
		 <cfelse>
			 FunctionDirectory  = NULL, 
			 FunctionPath       = NULL,
			 FunctionCondition  = NULL ,
			 ScriptName         = '#Form.ScriptName#',
			 FunctionTarget     = '#Form.FunctionTarget#',
		 </cfif>
		 <cfif Form.ScreenWidth neq "">
		 	ScreenWidth  = '#Form.ScreenWidth#',
			ScreenHeight = '#Form.ScreenHeight#',
		 </cfif>
		 OfficerUserId    = '#SESSION.acc#',
		 OfficerLastName  = '#SESSION.last#',
		 OfficerFirstName = '#SESSION.first#',
		 LastModified = getDate()
WHERE    SystemFunctionId = '#URL.ID#'
</cfquery>

<cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Key1Value       = "#URL.ID#"
	Key2Value       = "#url.mission#"
	Mode            = "Save"
	Name1           = "FunctionName"	
	Operational     = "1">	

<cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Key1Value       = "#URL.ID#"
	Key2Value       = "#url.mission#"
	Mode            = "Save"
	Name1           = "FunctionMemo"	
	Operational     = "1">	
	
<cfquery name="Source" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT * FROM Ref_ModuleControl
WHERE   SystemFunctionId = '#URL.ID#'
</cfquery>	

<cfparam name="Form.Sync" default="0">
	
<cfif Form.Sync eq "1">
	
	<cfquery name="Select" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ModuleControl
		WHERE  SystemModule     = '#Source.SystemModule#'
		AND    FunctionClass    = '#Source.FunctionClass#'
		AND    SystemFunctionId != '#URL.ID#' 
	</cfquery>
	
	<cfloop query="Select">
	
		<cfquery name="Delete" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE   Ref_ModuleControlRole
		WHERE    SystemFunctionId = '#SystemFunctionId#'
		</cfquery>
		
		<cfquery name="Insert" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_ModuleControlRole
		          (SystemFunctionId, 
				   Role, 
				   Operational, 
				   OfficerUserId, 
				   OfficerLastName, 
				   Created)
		SELECT   '#SystemFunctionId#', 
		         Role, 
			     Operational,
			     OfficerUserId, 
			     OfficerLastName, 
			     Created
		FROM     Ref_ModuleControlRole 
		WHERE    SystemFunctionId = '#URL.ID#'
		</cfquery>
		
		<cfquery name="Insert" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		   	 INSERT INTO Ref_ModuleControlRoleLevel
	                  (SystemFunctionId, Role, AccessLevel) 
			 SELECT   '#SystemFunctionId#', 
		              Role, 
					  AccessLevel	   
			 FROM     Ref_ModuleControlRoleLevel
			 WHERE    SystemFunctionId = '#URL.ID#'
		</cfquery> 
	
	</cfloop>

</cfif>

 <cfoutput>	

<script>
	
	 #ajaxLink('FunctionSetting.cfm?ID=#URL.ID#&mission=#url.mission#')#
	 try {
	 opener.history.go() } catch(e) {}	 
</script>		

</cfoutput> 
		
