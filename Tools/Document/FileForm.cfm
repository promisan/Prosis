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
<cf_param name="url.id" default="" type="String">
<cf_param name="url.id1" default="" type="String">
<cf_param name="url.box" default="" type="String">
<cf_param name="url.dir" default="" type="String">
<cf_param name="url.documentserver" default="" type="String">
<cf_param name="url.host" default="" type="String">
<cf_param name="url.pdfscript" default="" type="String">
<cf_param name="url.reload" default="" type="String">
<cf_param name="url.mode" default="" type="String">

<!--- holder of the form --->

<cf_divscroll zindex  = "9100" 
          modal       = "no" 
		  float       = "yes" 
		  width       = "530px" 
		  height      = "380px" 
		  id          = "#url.box#_holdercontent" 
		  close       = "yes"				    
		  overflowy   = "hidden">	
					  
<cf_tableround mode="modal" line="0" totalwidth="516px" totalheight="390px">		
	<cfinclude template="FileFormDialog.cfm">								
</cf_tableround>

</cf_divscroll>	