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
<cfparam name="url.name" 	default="">
<cfparam name="url.type" 	default="SelfService">
<cfparam name="url.newname" default="">
<cfparam name="url.format" 	default="html">

<cfset vBL = "">

<cfif lcase(url.format) eq "html">
	<cfset vBL = "<br>">
</cfif>

<cfif lcase(url.format) eq "text">
	<cfset vBL = "<newPortalScriptLine>">
</cfif>

<cfsavecontent variable="myPortal">
	<cfoutput>
		SELECT	* 
		FROM	Ref_ModuleControl
		WHERE	SystemModule = '#url.type#' 
		AND		FunctionClass = '#url.type#'
		AND		FunctionName = '#url.name#'
		UNION ALL
		SELECT	* 
		FROM	Ref_ModuleControl
		WHERE	SystemModule = '#url.type#' 
		AND		functionClass = '#url.name#'
	</cfoutput>
</cfsavecontent>

<cfsavecontent variable="myNewPortal">
	<cfoutput>
		SELECT	* 
		FROM	Ref_ModuleControl
		WHERE	SystemModule = '#url.type#' 
		AND		FunctionClass = '#url.type#'
		AND		FunctionName = '#url.newname#'
		UNION ALL
		SELECT	* 
		FROM	Ref_ModuleControl
		WHERE	SystemModule = '#url.type#' 
		AND		functionClass = '#url.newname#'
	</cfoutput>
</cfsavecontent>

<cfsavecontent variable="deleteStatement">
	<cfoutput>
		DELETE	Ref_ModuleControl #vBL#
		FROM	Ref_ModuleControl M #vBL#
		WHERE	EXISTS #vBL#
				( #vBL#
					SELECT	* #vBL#
					FROM #vBL#
						( #vBL#
							#myNewPortal# #vBL#
						) D #vBL#
					WHERE	D.SystemFunctionId = M.SystemFunctionId #vBL#
					AND		D.SystemModule = M.SystemModule #vBL#
					AND		D.FunctionClass = M.FunctionClass #vBL#
					AND		D.FunctionName = M.FunctionName #vBL#
					AND		D.MenuClass = M.MenuClass #vBL#
				);
	</cfoutput>
</cfsavecontent>

<cfquery name="getPortal" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
		 #preserveSingleQuotes(myPortal)#
</cfquery>

<cfquery name="getLanguages" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
		 SELECT 	*
		 FROM		Ref_SystemLanguage
		 WHERE		Operational = 2
</cfquery>

<cfsavecontent variable="insertStatement">
	
	<cfoutput query="getPortal">
	
		<cfset vFunctionClass = replace(FunctionClass,"'","''","ALL")>
		<cfif vFunctionClass eq url.name>
			<cfset vFunctionClass = url.newname>
		</cfif>
		
		<cfset vFunctionName = replace(FunctionName,"'","''","ALL")>
		<cfif vFunctionName eq url.name>
			<cfset vFunctionName = url.newname>
		</cfif>
		
		<cfset vFunctionDirectory = replace(FunctionDirectory,"'","''","ALL")>
		<cfif FindNoCase("Custom/Portal/"&url.name, vFunctionDirectory)>
			<cfset vFunctionDirectory = replace(FunctionDirectory,"Custom/Portal/"&url.name,"Custom/Portal/"&url.newname,"ALL")>
		</cfif>
		
		<cf_AssignId>
		
		<cfset vFunctionId = rowguid>
		
		
		INSERT INTO Ref_ModuleControl
           (
		   SystemFunctionId 
           ,SystemModule 
           ,FunctionClass 
           ,FunctionName 
           ,MenuClass 
           ,MenuOrder 
           ,MainMenuItem 
           <cfif ApplicationServer neq "">,ApplicationServer </cfif>
           <cfif FunctionMemo neq "">,FunctionMemo </cfif>
           <cfif FunctionInfo neq "">,FunctionInfo </cfif>
           <cfif FunctionHost neq "">,FunctionHost </cfif>
           <cfif FunctionBackground neq "">,FunctionBackground </cfif>
           <cfif FunctionVirtualDir neq "">,FunctionVirtualDir </cfif>
           <cfif FunctionDirectory neq "">,FunctionDirectory </cfif>
           <cfif FunctionPath neq "">,FunctionPath </cfif>
           <cfif FunctionCondition neq "">,FunctionCondition </cfif>
           <cfif FunctionIcon neq "">,FunctionIcon </cfif>
           <cfif FunctionContact neq "">,FunctionContact </cfif>
           <cfif ScriptName neq "">,ScriptName </cfif>
           <cfif ScriptConstant neq "">,ScriptConstant </cfif>
           <cfif ScriptVariable1 neq "">,ScriptVariable1 </cfif>
           <cfif ScriptVariable2 neq "">,ScriptVariable2 </cfif>
           <cfif ScreenWidth neq "">,ScreenWidth </cfif>
           <cfif ScreenHeight neq "">,ScreenHeight </cfif>
           <cfif FunctionTarget neq "">,FunctionTarget </cfif>
           ,EnableAnonymous 
           <cfif AccessDatasource neq "">,AccessDatasource </cfif>
           ,AccessRole 
           ,AccessUserGroup 
           ,AccessUser 
           ,EnforceReload 
           ,BrowserSupport 
           ,Operational 
           ,OfficerUserId 
           ,OfficerFirstName 
           ,OfficerLastName 
		   )
     VALUES
           (
		   '#vFunctionId#'
           ,'#replace(SystemModule,"'","''","ALL")#' 
           ,'#vFunctionClass#' 
           ,'#vFunctionName#' 
           ,'#replace(MenuClass,"'","''","ALL")#' 
           ,'#replace(MenuOrder,"'","''","ALL")#' 
           ,'#replace(MainMenuItem,"'","''","ALL")#' 
           <cfif ApplicationServer neq "">,'#replace(ApplicationServer,"'","''","ALL")#' </cfif>
           <cfif FunctionMemo neq "">,'#replace(FunctionMemo,"'","''","ALL")#' </cfif>
           <cfif FunctionInfo neq "">,'#replace(FunctionInfo,"'","''","ALL")#' </cfif>
           <cfif FunctionHost neq "">,'#replace(FunctionHost,"'","''","ALL")#' </cfif>
           <cfif FunctionBackground neq "">,'#replace(FunctionBackground,"'","''","ALL")#' </cfif>
           <cfif FunctionVirtualDir neq "">,'#replace(FunctionVirtualDir,"'","''","ALL")#' </cfif>
           <cfif FunctionDirectory neq "">,'#vFunctionDirectory#' </cfif>
           <cfif FunctionPath neq "">,'#replace(FunctionPath,"'","''","ALL")#' </cfif>
           <cfif FunctionCondition neq "">,'#replace(FunctionCondition,"'","''","ALL")#' </cfif>
           <cfif FunctionIcon neq "">,'#replace(FunctionIcon,"'","''","ALL")#' </cfif>
           <cfif FunctionContact neq "">,'#replace(FunctionContact,"'","''","ALL")#' </cfif>
           <cfif ScriptName neq "">,'#replace(ScriptName,"'","''","ALL")#' </cfif>
           <cfif ScriptConstant neq "">,'#replace(ScriptConstant,"'","''","ALL")#' </cfif>
           <cfif ScriptVariable1 neq "">,'#replace(ScriptVariable1,"'","''","ALL")#' </cfif>
           <cfif ScriptVariable2 neq "">,'#replace(ScriptVariable2,"'","''","ALL")#' </cfif>
           <cfif ScreenWidth neq "">,'#replace(ScreenWidth,"'","''","ALL")#' </cfif>
           <cfif ScreenHeight neq "">,'#replace(ScreenHeight,"'","''","ALL")#' </cfif>
           <cfif FunctionTarget neq "">,'#replace(FunctionTarget,"'","''","ALL")#' </cfif>
           ,'#replace(EnableAnonymous,"'","''","ALL")#' 
           <cfif AccessDatasource neq "">,'#replace(AccessDatasource,"'","''","ALL")#' </cfif>
           ,'#replace(AccessRole,"'","''","ALL")#' 
           ,'#replace(AccessUserGroup,"'","''","ALL")#' 
           ,'#replace(AccessUser,"'","''","ALL")#' 
           ,'#replace(EnforceReload,"'","''","ALL")#' 
           ,'#replace(BrowserSupport,"'","''","ALL")#' 
           ,'#Operational#' 
           ,'#SESSION.acc#' 
           ,'#SESSION.first#' 
           ,'#SESSION.last#' 
		   );
		   #vBL#
	
	<cfloop query="getLanguages">
	
		<cfquery name="getLanguageFields" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">		 
				 SELECT 	*
				 FROM		Ref_ModuleControl_Language
				 WHERE		SystemFunctionId = '#getPortal.SystemFunctionId#'
				 AND		LanguageCode = '#Code#'
				 AND		Mission = ''
		</cfquery>
		
		INSERT INTO Ref_ModuleControl_Language
	           (SystemFunctionId
	           ,LanguageCode
	           ,Mission
	           ,Operational
	           ,FunctionName
	           ,FunctionMemo
	           ,OfficerUserId
			   )
	     VALUES
	           (
			   '#vFunctionId#'
	           ,'#Code#'
	           ,''
	           ,1
	           ,'#getLanguageFields.FunctionName#'
	           ,'#getLanguageFields.FunctionMemo#'
	           ,'#SESSION.acc#'
			   )
	    #vBL#
		
	</cfloop>
	
  	#vBL#

	</cfoutput>

</cfsavecontent>



<cfsavecontent variable="updatePortal">
	<cfoutput>
	#vBL#
	--*******************************************************************************#vBL#
	--*******************************************************************************#vBL#
	-- PLEASE DOUBLE CHECK THE NEW NAME (#ucase(url.newname)#) #vBL#
	-- OTHERWISE IF IT ALREADY EXISTS IT WILL BE REPLACED #vBL#
	-- AND YOU MAY LOSE PREVIOUS CONFIGURATIONS #vBL#
	--*******************************************************************************#vBL#
	--*******************************************************************************#vBL#
	#vBL##vBL##vBL#
	
	Use System; 
	
	#vBL##vBL##vBL#
	--Clear previous configuration for "#ucase(url.newname)#" Portal (in case it exists) #vBL#
	--THIS STATEMENT WILL REMOVE ANY PREVIOUS CONFIGURATION FOR PORTAL "#ucase(url.newname)#"
	#vBL#
	#deleteStatement# 
	
	#vBL##vBL##vBL#
		
	--Insert new Portal configuration for "#ucase(url.newname)#" Portal
	#vBL#
	#insertStatement# 
	
	#vBL#
	</cfoutput>
</cfsavecontent>

<cfoutput>
	#updatePortal#
</cfoutput>


