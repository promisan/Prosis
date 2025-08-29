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
<cfquery name="getTask" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   RequestTask	
		WHERE  RequestId    = '#URL.ID#'
		AND    TaskSerialNo = '#URL.serialNo#'			
	</cfquery>		

<cfoutput>

	#numberformat(getTask.TaskUoMQuantity,'__._')#
		
	 <input type="hidden" name="#url.serialno#_taskquantity" id="#url.serialno#_taskquantity" value="#numberformat(getTask.TaskUoMQuantity,'__._')#"
	     readonly onchange="taskedit('#url.id#','#url.serialno#','taskquantity',this.value)">		
		 		   
</cfoutput>		   