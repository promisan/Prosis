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

<cfquery name="Delete" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM ServiceItemTab
	WHERE 	mission = '#URL.ID1#'
	AND 	code = '#URL.ID2#'
	AND		tabName = '#URL.ID3#'
</cfquery>


<cfoutput>
<script language="JavaScript">   
	ColdFusion.navigate('#SESSION.root#/workorder/maintenance/ServiceItemTab/ServiceItemTabListing.cfm?ID1=#URL.ID2#','contentbox2')
</script> 
</cfoutput>