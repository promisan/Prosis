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
<cf_screentop html="no" jquery="yes">

<cf_textareascript>

<cfquery name="qModule" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_SystemModule 
	WHERE  SystemModule = '#URL.module#'
</cfquery>

	<cfoutput>
	
	 <table width="98%" height="100%" border="0" cellspacing="0" align="center" cellpadding="0">
	 
	        <tr><td valign="top" style="height:40px" colspan="3" class="labellarge">
			Please record a functional description of module #URL.module#. This maybe used for presentation purposes on a website.
			</td></tr>
			
			 <tr>
			 	
			 	<td height="30" style="padding-left:0px">
							     
				  <input style = "width:160px;height:24px;font-size:13px;padding:4px"
				     class     = "button10g" 
					 onclick   = "updateTextArea();ptoken.navigate('FunctionEditSubmit.cfm?module=#url.module#','process','','','POST','entry')" 
					 type      = "button" 
					 name      = "update" 
					 id        = "update" 
					 value     = "Apply">
				  
				 </td>
				 <td width="10%"></td>
			 </tr>
	 
	 		<tr class="hide"><td id="process"></td></tr>
							
			<tr>
				
				<td colspan="3" valign="top" width="90%" height="90%" style="padding-top:6px;padding-right:40px">
								
				<cfform style="height:100%" method="POST" name="entry">	
				
				   <cf_textarea name="FunctionEditMemo"                                        
					   height         = "400"
					   toolbar        = "full"
					   expand		  = "No"
					   loadscript     = "Yes"
					   skin           = "flat"
					   resize         = "true"
					   init           = "yes"
					   color          = "ffffff">#qModule.ModuleMemo#</cf_textarea>
			   
			   </cfform>
							 
				</td>
				
			 </tr>			
															  
	</table> 	
	
	</cfoutput>
