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
<cfquery name="update" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   UPDATE    RequestTask
   SET ShipToMode = '#url.mode#'
   WHERE     Taskid = '#url.taskid#'  
</cfquery>

<cfquery name="get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT    *
   FROM      RequestTask
   WHERE     Taskid = '#url.taskid#'  
</cfquery>

<cf_compression>

<cfoutput>
						
<cfif get.ShipToMode eq "Deliver">

	<a href="javascript:ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/task/process/taskViewShipToMode.cfm?taskid=#taskid#&mode=Collect','f#taskid#_shiptomode')">						
	<font color="0080C0">COLLECTION</font>
	</a>
	
<cfelse>

	<a href="javascript:ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/task/process/taskViewShipToMode.cfm?taskid=#taskid#&mode=Deliver','f#taskid#_shiptomode')">												
	<font color="0080C0">DELIVERY</font>
	</a>

</cfif>		

</cfoutput>