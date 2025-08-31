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
<cfoutput>

<cfif url.accept eq "1">

    <cf_tl id="Cancel" var="1">
	
	<input type="button"  value="#lt_text#" class="button10g" onclick="parent.ProsisUI.closeWindow('attachdialog')">
		
		<input type="submit" 
		    name="save" 
			id="save"  
			value="Attach File" 
			class="button10g" 
			onclick="document.getElementById('save').className='hide';document.getElementById('busy').className='regular'">			
		
<cfelse>

   <table align="center"><tr><td align="center" class="labelmedium">
	 <font color="FF0000"><cf_tl id="Stop">:<b><cf_tl id="This file extension not supported"></font>
	</td></tr></table>
		
</cfif>		
</cfoutput>
