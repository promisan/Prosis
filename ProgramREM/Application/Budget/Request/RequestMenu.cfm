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

<table width="99%" cellspacing="0" cellpadding="0">

<tr class="labelmedium2">
   	
    <td align="left" style="padding-left:10px">
	<!---
	<cf_tl id="Reload" var="1">	
	<input type="button" name="Refresh" value="#lt_text#" style="width:110;height:25;font-size:12px" 
	   class="button10g" onclick="reload(document.getElementById('ObjectSelect').value)">
	--->
	</td>	
	
	<cfinvoke component="Service.Process.Program.ProgramAllotment"  <!--- get access levels based on top Program--->
			Method         = "RequirementStatus"
			ProgramCode    = "#URL.ProgramCode#"
			Period         = "#URL.Period#"	
			EditionId      = "#URL.editionID#" 
			ReturnVariable = "RequirementLock">	
			 	 			
	<cfif RequirementLock eq "0">			
	
		<cfif Object.recordcount gte "1">
	    <td style="padding-left:2px">
		
		 	<cf_tl id="Add New" var="1">
			<input type="button" 
			    name="Add" 
				value="#lt_text#" 
				style="width:110;height:25;border:1px solid silver" 
				class="button10g" 
				onclick="Prosis.busy('yes');alldetinsert('#url.editionid#_#url.objectcode#','#url.editionid#',ObjectSelect.value,'','add','dialog')">
			
		</td>	
		</cfif>
		
		<td style="padding-left:2px">
		
			<cf_ProgramPeriodEdition mission="#program.unitMission#" period="#url.period#" editionid="#url.editionid#">
					
			<select name="EditionSelect" class="regularxl" style="border:0px;background-color:f1f1f1;width:150px" onchange="period(this.value,document.getElementById('ObjectSelect').value)">
			<cfloop query="Edition">
				<option value="#Editionid#" <cfif editionid eq url.editionid>selected</cfif>>#Description#</option>
			</cfloop>
			</select>		
		
		</td>
				
		<td style="padding-left:2px">	
				
			<!-- <cfform> -->	
			<cfselect name="ObjectSelect" 
			   group="Category" 
			   value="Code" 
			   query="Object"
			   display="Description" 
			   selected="#url.objectcode#" 
			   visible="Yes" 
			   enabled="Yes" 
			   style="width:250px;border:0px;;background-color:f1f1f1"
			   onchange="object(this.value);" 
			   id="ObjectSelect" 
			   class="regularxl"/>		
			  <!-- </cfform> --> 
		</td>
	
	</cfif>   
		
	<td id="selected" class="hide">
		<input type="text" id="selectme" name="selectme" value="#url.objectcode#">
	</td>
	
	<td width="80%" align="right" style="padding-right:10px;"><cf_tl id="Officer">:&nbsp;<font color="808080">#SESSION.last# #SESSION.first#</font></td>
				
</tr>
</table>

</cfoutput>
