
<cfparam name="Attributes.AccessUserGroup"     default="0">
<cfparam name="Attributes.AccessUser"          default="0">
<cfparam name="Attributes.FunctionIcon"        default="Folder">
<cfparam name="Attributes.ApplicationServer"   default="">
<cfparam name="Attributes.ScriptName"          default="">
<cfparam name="Attributes.FunctionCondition"   default="">
<cfparam name="Attributes.BrowserSupport"      default="2">
<cfparam name="Attributes.FunctionTarget"      default="right">
<cfparam name="Attributes.MenuClass"           default="Main">
<cfparam name="Attributes.FunctionDirectory"   default="">
<cfparam name="Attributes.FunctionVirtualDir"  default="default">
<cfparam name="Attributes.FunctionPath"        default="">
<cfparam name="Attributes.FunctionMemo"        default="">
<cfparam name="Attributes.MainMenuItem"        default="1">
<cfparam name="Attributes.Operational"         default="1">
<cfparam name="Attributes.EnableAnonymous"     default="0">
<cfparam name="Attributes.AccessRole"          default="">
<cfparam name="Attributes.AccessRoleLevel"     default="0,1,2">

<cftransaction>

	<cfquery name="Check" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ModuleControl
	WHERE   SystemModule  = '#Attributes.SystemModule#' 
	AND     FunctionName  = '#Attributes.FunctionName#'
	AND     (
	         (FunctionClass = '#Attributes.FunctionClass#')
	         OR  
			 (FunctionDirectory = '#Attributes.FunctionDirectory#' AND FunctionPath = '#Attributes.FunctionPath#' AND FunctionCondition = '#attributes.functioncondition#')	
			 <cfif attributes.scriptname neq "">
			 OR
			 ScriptName = '#attributes.scriptname#'		 
			 </cfif>
			)
	</cfquery>	
				
	<cfif Check.recordcount eq "0">
		
	   <cf_assignid>
	
	   <cfquery name="System" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO  Ref_ModuleControl
		      (SystemFunctionId,
			  SystemModule, 
			  FunctionClass, 
			  FunctionName, 
			  MenuClass, 
			  MenuOrder, 
			  MainMenuItem, 
			  ApplicationServer,
			  FunctionMemo, 
			  FunctionVirtualDir,
			  <cfif Attributes.FunctionPath neq "">			  
			  FunctionDirectory,
			  FunctionPath, 
			  </cfif>			  
              FunctionCondition, 
			  FunctionIcon, 
			  ScriptName, 
			  EnableAnonymous,
			  BrowserSupport,
			  FunctionTarget, 
			  AccessUserGroup, 
			  AccessUser)
		VALUES ('#rowguid#',
		      '#Attributes.SystemModule#', 
			  '#Attributes.FunctionClass#', 
			  '#Attributes.FunctionName#', 
			  '#Attributes.MenuClass#', 
			  '#Attributes.MenuOrder#', 
			  '#Attributes.MainMenuItem#', 
			  '#attributes.applicationserver#',
			  '#Attributes.FunctionMemo#', 
			  '#Attributes.FunctionVirtualDir#', 
			  <cfif '#Attributes.FunctionPath#' neq "">
			  '#Attributes.FunctionDirectory#', 
			  '#Attributes.FunctionPath#', 
			  </cfif>			 
              '#Attributes.FunctionCondition#', 
			  '#Attributes.FunctionIcon#', 
			  '#Attributes.ScriptName#', 
			  '#Attributes.EnableAnonymous#',
			  '#Attributes.BrowserSupport#',
			  '#Attributes.FunctionTarget#', 
			  '#Attributes.AccessUserGroup#', 
			  '#Attributes.AccessUser#') 
	   </cfquery>
	   
	  <cfelse> 
	  	  
	  	   <cfset rowguid = check.systemfunctionid>
		   		   
		   <cfquery name="CheckExist" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM    Ref_ModuleControl
				WHERE   SystemModule  = '#Attributes.SystemModule#' 
				AND     FunctionClass = '#Attributes.FunctionClass#' 
				AND     FunctionName  = '#Attributes.FunctionName#' 
				AND     MenuClass     = '#Attributes.MenuClass#' 			
			</cfquery>	
	  
	      <cfif checkExist.recordcount eq "0">
		  		  	  	   	  
			  <cfquery name="System" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
	
					UPDATE Ref_ModuleControl
					SET   SystemModule       = '#Attributes.SystemModule#' ,
						  FunctionClass      = '#Attributes.FunctionClass#', 
						  FunctionName       = '#Attributes.FunctionName#',	  
						  MenuClass          = '#Attributes.MenuClass#',  
						  MenuOrder          = '#Attributes.MenuOrder#',
						  ApplicationServer  = '#attributes.applicationserver#',
						  MainMenuItem       = '#Attributes.MainMenuItem#',
						  FunctionMemo       = '#Attributes.FunctionMemo#', 
						  FunctionVirtualDir = '#Attributes.FunctionVirtualDir#', 
						  <cfif Attributes.FunctionPath neq "">
						     FunctionPath      = '#Attributes.FunctionPath#', 
							 FunctionDirectory = '#Attributes.FunctionDirectory#', 
						  <cfelse>
						     FunctionPath      = NULL, 
							 FunctionDirectory = NULL,
						  </cfif>
						  FunctionCondition = '#Attributes.FunctionCondition#', 
						  FunctionIcon      = '#Attributes.FunctionIcon#', 
						  ScriptName        = '#Attributes.ScriptName#', 
						  BrowserSupport    = '#Attributes.BrowserSupport#',
						  <!---
						  FunctionTarget    = '#Attributes.FunctionTarget#', 
						  --->
						  AccessUserGroup   = '#Attributes.AccessUserGroup#', 
						  AccessUser        =  '#Attributes.AccessUser#',
						  Operational       = '#attributes.operational#'
					WHERE SystemFunctionId  = '#Check.SystemFunctionId#' 	
							  
			   </cfquery>
		   
		   <cfelseif checkExist.recordcount eq "1">
		   
		   		<!--- update generic items --->
		   
		   		 <cfquery name="System" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
	
					UPDATE Ref_ModuleControl
					SET   MainMenuItem       = '#Attributes.MainMenuItem#',
						  FunctionMemo       = '#Attributes.FunctionMemo#', 
						  FunctionClass      = '#attributes.FunctionClass#',
						  FunctionVirtualDir = '#Attributes.FunctionVirtualDir#', 
						  <cfif Attributes.FunctionPath neq "">
						     FunctionPath      = '#Attributes.FunctionPath#', 
							 FunctionDirectory = '#Attributes.FunctionDirectory#', 
						  <cfelse>
						     FunctionPath      = NULL, 
							 FunctionDirectory = NULL,
						  </cfif>
						  FunctionCondition = '#Attributes.FunctionCondition#', 						 
						  ScriptName        = '#Attributes.ScriptName#', 
						  BrowserSupport    = '#Attributes.BrowserSupport#'
					WHERE SystemFunctionId  = '#CheckExist.SystemFunctionId#' 	
							  
			   </cfquery>
		   		 
				 <!--- do nothing, it exisits ---> 
		   
		   </cfif>
		   		
	</cfif>
	
	
	<cfif attributes.AccessRole neq "">
		
		<cfloop index="role" list="#Attributes.accessrole#">
		
			<cfquery name="CheckRole" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM    Ref_ModuleControlRole
				WHERE   SystemFunctionId = '#rowguid#'
				AND     Role = '#role#'	
			</cfquery>
			
			<cfif Checkrole.recordcount eq "0">
			
				<cfquery name="System" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO  Ref_ModuleControlRole
					      (   SystemFunctionId,
						  	  Role, 
							  OfficerUserid,
							  OfficerLastName,
							  OfficerFirstname 
						   )
					VALUES (  '#rowguid#',
					      	  '#role#', 
							  '#SESSION.acc#', 
							  '#SESSION.last#', 
							  '#SESSION.first#'
						   ) 
			   </cfquery>
			   
			   <cfloop index="itm" list="#Attributes.AccessRoleLevel#">
			   
				   <cfquery name="System" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO  Ref_ModuleControlRoleLevel
						      (   SystemFunctionId,
							  	  Role, 
								  AccessLevel
							   )
						VALUES (  '#rowguid#',
						      	  '#role#', 
								  '#itm#'
							   ) 
				   </cfquery>
			   
			   </cfloop>
		   
		    </cfif>
	
		</cfloop>
	
	</cfif>
	
	<cfset caller.rowguid = rowguid>
	
</cftransaction>	