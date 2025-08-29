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
<cfparam name="url.object" default="">

<cfoutput>

<table width="99%" aling="center" border="0" bgcolor="ffffff" cellspacing="0" cellpadding="0">
				
		<cfquery name="ObjectList" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT ObjectUsage,Code, Code+' '+Description as Description
			FROM   Ref_Object
			ORDER BY ObjectUsage
		</cfquery>
			
		<TR>
		    <TD colspan="2">
				<cfselect 
					name	="obj" 
					group	="ObjectUsage" 
					style	="width:360" 
					query	="ObjectList" 
					value	="Code" 
					display	="Description" 
					visible	="Yes"
					selected="#URL.object#"  
					enabled	="Yes"
					required="No" 
					class	="regularxl" 
			    	onChange="selected(this.value,'add')"
					queryPosition="below">
						<option value=""></option>	
				</cfselect>			
			</TD>
		</TR>
			
		</table>
		
</cfoutput>		