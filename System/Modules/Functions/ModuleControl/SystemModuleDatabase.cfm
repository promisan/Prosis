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

<cfparam name="Attributes.SystemModule" default="">
<cfparam name="Attributes.DatabaseName" default="0">
<cfparam name="Attributes.MissionTable" default="">

<!--- check role --->
<cfquery name="Check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  *
FROM    Ref_SystemModuleDatabase
WHERE   SystemModule = '#Attributes.SystemModule#' 
</cfquery>
		
<cfif Check.recordcount eq "0">

   <cfquery name="System" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO  Ref_SystemModuleDatabase
	      (SystemModule, 
		  DatabaseName,
		  MissionTable) 		
	VALUES ('#Attributes.SystemModule#', 
		  	'#Attributes.DatabaseName#', 
		 	'#Attributes.MissionTable#') 
   </cfquery>
   
<cfelse> 
  
	  <cfquery name="System" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Ref_SystemModuleDatabase
		SET  DatabaseName = '#Attributes.DatabaseName#',
		    MissionTable = '#Attributes.MissionTable#'
		WHERE   SystemModule = '#Attributes.SystemModule#' 
		</cfquery>
	
</cfif>