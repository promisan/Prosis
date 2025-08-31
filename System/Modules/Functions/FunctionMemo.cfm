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
<cfquery name="Line" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*
    FROM   Ref_ModuleControl L
	WHERE  SystemFunctionId = '#URL.ID#'
</cfquery>

<cfform style="height:100%" method="POST" name="entry">
	
	<cfoutput>
	
	 <table width="100%" height="100%" align="center">
	 
	 		<tr class="hide"><td id="process"></td></tr>
							
			<tr class="line"><td valign="top" height="100%" style="padding-left:20px;padding-right:10px">			

				<cf_textarea 
					 name="FunctionInfo"  		          
					 height="90%"					 				 		 
					 color="ffffff"
					 init = "No"
					 toolbar="mini"					 
					 resize="true">#Line.FunctionInfo#</cf_textarea>
				 
				 </td>
			 </tr>			
				
			 <tr><td height="35" style="height:40px" align="center">
							     
				  <input style="width:190px;height:28px;font-size:14px;padding:4px"
				     class="button10g" 
					 onclick="updateTextArea();ColdFusion.navigate('FunctionMemoSubmit.cfm?systemfunctionid=#url.id#','process','','','POST','entry')" 
					 type="button" 
					 name="update" 
					 id="update" 
					 value ="Apply">
				  
				 </td>
			 </tr>
																  
	</table> 	
	
	</cfoutput>

</cfform>	

<cfset ajaxonload("initTextArea")>

	
