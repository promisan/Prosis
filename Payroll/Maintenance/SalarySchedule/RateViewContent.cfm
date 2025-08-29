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
<cfparam name="url.mission" default="">

<cfif url.mission eq "">
	  <cfabort>
</cfif>

<cf_layoutscript>
<cfajaximport tags="cfform">
		 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
	    position="left" 
		name="treebox" 
		maxsize="300" 		
		size="260" 
		collapsible="true"		
		splitter="true">
		
		<table width="100%" height="100%">

			<tr class="line labelmedium"  style="height:40px">
				<td align="center" style="padding-left:5px;height:40px">
				<cfoutput>	
				<select name="operational" id="operational" class="regularxl" style="background-color:f1f1f1;height:28px;font-size:18px;width:90%" onchange="ptoken.navigate('RateViewTree.cfm?idmenu=#url.idmenu#&location=#url.location#&schedule=#url.schedule#&mission=#url.mission#&operational='+this.value,'treeview')">
						<option value="1" selected><cf_tl id="Active"></option>
						<option value="0"><cf_tl id="Deactivated"></option>
				</select>
				</cfoutput>
				</td>
			</tr>
			
			<tr>
				<td id="treeview" style="height:100%">				
				<cfinclude template="RateViewTree.cfm">			
				</td>
			</tr>
		</table>	
			
	</cf_layoutarea>
	
	<cf_layoutarea  position="center" name="box">
				
			<iframe name="right"
		        id="right"
		        width="100%"
		        height="100%"				
				scrolling="no"
		        frameborder="0"></iframe>
									
	</cf_layoutarea>			
		
</cf_layout>
