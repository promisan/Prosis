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
<cfquery name="Program" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM   Program
   WHERE  ProgramCode = '#URL.ProgramCode#'
</cfquery>

<cfif Program.recordcount eq "1">

	<cf_screenTop height="100%" 
		    label="Move #Program.ProgramClass# - #Program.ProgramName#" 
			bannerheight="60" 
			border="0" 	
			band="no"
			user="no"
			html="no"
			banner="gray"
			jquery="Yes"
			line="No"		
			scroll="yes" 
			TreeTemplate="Yes"
			layout="webapp">
		
<cfelse>

	<cf_screenTop height="100%" 
		    label="Select" 
			TreeTemplate="Yes"
			bannerheight="60" 
			border="0" 	
			band="no"
			html="No"
			user="no"
			banner="gray"
			jquery="Yes"
			line="No"		
			scroll="yes" 
			layout="webapp">


</cfif>		
	
<cfoutput>
			
	<script>
				
		function programselected(pid,org) {
			    
	    	<cfif url.applyscript neq "">			
			try {
				parent.#url.applyscript#(pid,'#url.scope#',org);	
			} catch(e) {}	
		    </cfif>		
			parent.ProsisUI.closeWindow('programwindow',true);				
			}
		
	</script>		
		
	<table height="99%" width="100%">
		<tr>
			<td valign="top" style="min-width:290px;padding-left:4px;border-right: solid 1px silver">
			<cfinclude template="ProgramTree.cfm">
			</td>			
			<td width="80%" valign="top"><cf_divscroll id="right"></cf_divscroll></td>
		</tr>
	</table>		
		
</cfoutput>

<cf_screenbottom layout="webapp">
