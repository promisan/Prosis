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
<cfquery name="ListElement" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM ClassFunctionElement
		WHERE ClassFunctionId = '#url.Id#' and ElementCode='#url.ElementCode#'
</cfquery>	

<cfoutput>
			
	
		<table width="100%" height="100%" bgcolor="f4f4f4" cellspacing="0" cellpadding="0" class="formpadding">
				
		<cfform method="post" 
		  name="classForm#url.elementcode#">

  		<tr>
		<td width="100%" style="border: 1px solid Silver;">
		
		  <cf_Textarea 
		  		 name="T_#url.elementCode#" 				 			 
				 toolBar="Default" 	
				 toolbaronfocus="Yes"
				 tooltip="Comments,Relevant Information"			 
				 richtext="true" 
				 skin="silver">
		
		 		#ListElement.TextContent#
				
		  </cf_textarea>		
		 </td> 
		 </tr>	
		 
		   <tr>
			<td  height="10" width="100%" align="center">
			<input type="submit" value=" Save " class="button10g" onclick = "javascript:save_text('#url.id#','#url.elementcode#','classForm#url.elementcode#')">
			</td>
		</tr>
		 
		 </cfform>
		 	
		</table>


</cfoutput>