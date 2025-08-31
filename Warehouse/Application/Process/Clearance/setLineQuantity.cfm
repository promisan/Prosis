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
<cfquery name="Item" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT ItemNo 
	FROM   Request
	WHERE  RequestId = '#URL.ID#'
</cfquery>

<cfquery name="Update" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    UPDATE Request
	SET    RequestedQuantity = '#quantity#' 
	WHERE  RequestId = '#URL.ID#'
</cfquery>

<cfquery name="Line" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Request	
	WHERE  RequestId = '#URL.ID#'
</cfquery>

<cfoutput>

	#NumberFormat(Line.RequestedAmount,'__,____.__')#

	<script>
		ColdFusion.navigate('setLineTotal.cfm?role=sorting=#url.sorting#&mission=#line.mission#&status=#line.status#&reference=#Line.Reference#','boxoverall')
	</script>

</cfoutput>



