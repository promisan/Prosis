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
<cfset vDateStart = DateAdd("h", 0, dte)>
<cfset vDateEnd = DateAdd("h", 24, dte)>

<cfquery name="qAssetAction" 
datasource = "AppsMaterials"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   AssetItemAction
	WHERE  AssetId        = '#qAssets.AssetId#' 
	AND    ActionDate >= #vDateStart#
	AND    ActionDate <= #vDateEnd#
	AND    ActionCategory = '#URL.Code#'
	AND    ActionType     = 'Detail'
</cfquery>									

<cfset j = 0>
<cfset vHour = 0 >



<cfloop query="qAssetAction">
	   <cfset Edit = TRUE>
	   <cfset vHour   = TimeFormat(ActionDate,"HH")>
	   <cfset vMinute = TimeFormat(ActionDate,"mm")>			   
	   <cfif TransactionId neq "">
	   		<cfset Edit = FALSE>
	   </cfif>
	   <cfset i = TimeFormat(ActionDate,"H-mm")>													
	   <cfset mode="">
	   <cfinclude template="TransactionLine.cfm">
	   <cfset j=j+1>
</cfloop>


<!--- the new empty line --->
<cfset vHour = vHour + 1>	
<cfset vMinute = "00">			   
<cfset i = "#vHour#-00">
<cfset mode="add">
<cfset Edit = TRUE>
<cfinclude template="TransactionLine.cfm">
