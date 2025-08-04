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
<!------------------------------------------------------------------------------------------------------
 -----------------------------------------------------------------------------------------------------
 
Application:	Any
Project:		Any
Filename:		dcHTMLRect.cfm
Programmers:	Peter Coppinger <peter@digital-crew.com>
				
Purpose:		Part of dcComponent engine!
				Sets up easy to use paths to component data.
				Included by each dcComponent

CHANGE LOG:
30 Jan 2002		Document created.
05 Jan 2002		Structure and Naming improved

 ----------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------>

<!--- START: Paths to STYLE Resources  (from main.cfm main tag handler file) --->

	<!--- Relative Style Path from Caller of DCCOM tag file e.g. path ../dcComponents/styles/[STYLE]/dcMyComponent/title.gif --->
	<cfset RelStylePath = "#ATTRIBUTES.dcCom_RelPath#components/#ATTRIBUTES.component#/styles/#ATTRIBUTES.comstyle#/">
	
	<!--- File Path to to selected Style folder e.g. path c:/example/dcComponents/styles/[STYLE]/dcMyComponent/data.cfm --->
	<cfset FileStylePath = "#ATTRIBUTES.dcCom_filePath#components/#ATTRIBUTES.component#/styles/#ATTRIBUTES.comstyle#/">

	<!--- File Path to to selected Style folder e.g. path ../dcComponents/styles/[STYLE]/dcMyComponent/data.cfm --->
	<cfset IncludeStylePath = "styles/#ATTRIBUTES.comstyle#/">
	
<!--- END: Paths to STYLE Resources --->


<!--- START: Define Path to main tag directory resource --->

	<!--- Relative Shared Path from caller of DCCOM tag file e.g. path ../dcComponents/shared/dcMyComponent/workerfile.cfm --->
	<cfset RelSharedPath = "#ATTRIBUTES.dcCom_RelPath#components/#ATTRIBUTES.component#/">
	
	<!--- File Path to Shared resources e.g. path c:/example/dcComponents/shared/dcMyComponent/workerfile.cfm --->
	<cfset FileSharedPath = "#ATTRIBUTES.dcCom_filePath#components/#ATTRIBUTES.component#/">

<!--- END: Define Path to main tag directory resource --->
