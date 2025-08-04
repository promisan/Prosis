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

<cfset qty = replaceNoCase(FORM.Quantity,",","")> 
<cfset prc = replaceNoCase(FORM.Price,",","")> 

<cfquery name="qUpdate" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	 
	UPDATE WorkOrderLineResource 
	SET    Quantity     = '#qty#',
	       Price        = '#prc#',
	       Memo         = '#Left(Trim(FORM.Remarks),100)#',
		   ResourceMode = '#Form.ResourceMode#'
    WHERE  ResourceId   = '#URL.ResourceId#'    									  
</cfquery>

<cfoutput>
<script>
	ColdFusion.Window.hide('adddetail');
	try {
		window.applyfilter('1','','#URL.ResourceId#')
	}
	catch(e){}	
</script>
</cfoutput>