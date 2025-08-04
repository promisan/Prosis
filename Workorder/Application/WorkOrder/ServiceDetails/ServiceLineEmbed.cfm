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

<!--- ------------------- --->
<!--- pending development --->
<!--- ------------------- --->

<cfoutput>

 <cfquery name="Check" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    WorkOrderLineTopic R 
		WHERE   R.WorkOrderId = '#WorkOrderId#'			
		AND     R.WorkOrderLine = '#WorkOrderLine#'
	 </cfquery>
					 
		<cfif check.recordcount eq "0">
			   			   
			 <img src="#SESSION.root#/Images/features.gif"
			     	alt="Topics / Features for this line"
				    id="d#box#_min"
			     	border="0"
				  	height="12"
				 	width="12"
				  	align="absmiddle"
			     	class="regular"
			     	style="cursor: pointer;"
					<!--- 	onClick="object('#box#','#workorderid#','#workorderline#')" --->>
				 
				 <cfelse>
				 
			  <img src="#SESSION.root#/Images/agent.gif"
			     	alt="Topics/Features"
				    id="d#box#_min"
			     	border="0"
				  	height="12"
				 	width="12"
				  	align="absmiddle"
			     	class="regular"
			     	style="cursor: pointer;"
			     	onClick="object('#box#','#workorderid#','#workorderline#')">
				 				 
				 </cfif>
				 
				<img src="#SESSION.root#/Images/icon_collapse.gif"
			     alt="Hide"
			     id="d#box#_max"
			     border="0"
				  height="12"
				 width="12"
				 align="absmiddle"
			     class="hide"
			     style="cursor: pointer;"
			     onClick="object('#box#','#workorderid#','#workorderline#')">
				 
</cfoutput>				 