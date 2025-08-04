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

<cf_screentop height="100%" title="Application Code Inquiry" scroll="no" html="No" jQuery="Yes" TreeTemplate="Yes">

<cf_layoutscript>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

<cf_layout attributeCollection="#attrib#">	

	<cf_layoutarea 
          position="top"
          name="controltop"         
		  overflow="hidden"
          splitter="true">	
		  
		 <cfinclude template="PostFileMenu.cfm">
		  
	</cf_layoutarea>		  

	<cf_layoutarea 
	    position="left" name="tree" maxsize="400" size="260" collapsible="true" splitter="true">
	
			<table width="100%" height="100%" class="tree formpadding">
			<tr><td valign="top">
			
				<cfform>
					<cf_UItree name="idfolder" font="tahoma" fontsize="11" bold="No" format="html" required="No">
						 <cf_UItreeitem bind="cfc:service.Tree.FolderTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#SESSION.rootpath#')">
					</cf_UItree>
				</cfform>


			</td></tr>
			</table>
		
	</cf_layoutarea>	
	
	<cf_layoutarea 
	    position="center" name="boxfiles">				
	
	   <iframe name="right" id="right" width="100%" height="100%" scrolling="no" frameborder="0" border="0"></iframe>
		   
	</cf_layoutarea>	

</cf_layout>	   
