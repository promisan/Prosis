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

<cfquery name="Asset" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   AssetItem A, Item I
	WHERE  AssetId = '#URL.Assetid#'	
	AND    A.ItemNo = I.ItemNo
</cfquery>

<!--- check access rights --->

<cfinvoke component = "Service.Access"  
   method           = "AssetHolder" 
   mission          = "#Asset.Mission#" 
   assetclass       = "#Asset.category#"
   returnvariable   = "access">	

<cfif access eq "ALL" or Access eq "EDIT">
 <cfset mode = "edit">
<cfelse>
 <cfset mode = "view">
</cfif>   

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<tr><td height="600" id="picturebox">

    <cf_PictureView documentpath="Asset"
        subdirectory="#url.assetid#"
		filter="Picture_" 							
		width="500" 
		height="500"
		mode="#mode#">		

</td></tr>

</table>