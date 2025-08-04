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
<cfquery name="qDelete" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE ItemMasterStandardCost
	WHERE 
           ItemMaster 		= '#URL.id1#' AND
		   Mission   		= '#URL.id2#' AND
		   TopicValueCode	= '#URL.id3#' AND
		   CostElement		= '#URL.id4#' AND
		   DateEffective	= '#URL.id5#' AND
		   Location			= '#URL.id6#' 
</cfquery>


<cfoutput>
<script>
	ptoken.navigate('Budgeting/CostElementList.cfm?id1=#URL.id1#','dExisting');
</script>
</cfoutput>