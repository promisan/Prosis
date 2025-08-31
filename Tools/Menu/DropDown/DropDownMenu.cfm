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

<cfparam name="Attributes.Navigation" default="1">
<cfparam name="Attributes.MenuStart" default="1">
<!--- JM added this on 02/02/2010 in order to allow closing for a particular Id --->
<cfparam name="Attributes.AjaxId"    default="">

<div style="position:absolute; width:280px; background-color: F6F6F6; z-index:99999; border: 1px solid c1c1c1; border-radius:10px">

	<table width="100%" border="0" class="navigation_table">
		
	<tr><td width="100%" bgcolor="e1e1e1" style="border-top-left-radius:10px;border-top-right-radius:10px">
	
	<cfif Attributes.ajaxid neq "">
		
		<table width="100%" align="center" onClick="cmclear('#attributes.ajaxid#');" onMouseOver="hl(this,true,'')" onMouseOut="hl(this,false,'')">
			
			<tr class="line" bgcolor="e1e1e1"> 
			  <td style="padding-left:4px;padding-right:3px" height="25" class="labelmedium"><cf_tl id="Submenu"></td>
			  <td align="right" style="padding-left:4px;padding-right:2px">
			  <cf_img icon="delete">
			</td>
			</tr>
						
		</table>	
		
	</cfif>
	
	</td></tr>
				
	<cfloop index="No" from="#Attributes.MenuStart#" to="#Attributes.MenuRows#" step="1">
	
		<cfparam name="Attributes.MenuShow#No#" default="Show">
		<cfset Status   = Evaluate("Attributes.MenuStatus" & #No#)>
		<cfset Name     = Evaluate("Attributes.MenuName" & #No#)>
		<cfset Action   = Evaluate("Attributes.MenuAction" & #No#)>
		<cfset Icon     = Evaluate("Attributes.MenuIcon" & #No#)>
		<cfset Show     = Evaluate("Attributes.MenuShow" & #No#)>
		
		<cfparam name="Attributes.MenuLine#No#" default="No">
		<cfset Line     = Evaluate("Attributes.MenuLine" & #No#)>		  	  
		
		<cfif Show eq "Show">
		
			<tr class="navigation_row">
			<td>
	
				<table width="100%" 				
					align="center" onClick="#Action#" onMouseOver="hl(this,true,'#Status#')" onMouseOut="hl(this,false,'')" class="formpadding">
					
					<tr style="height:30px" class="labelmedium2 linedotted"> 
					  <td align="center" style="padding-left:4px;width:40px">				  
					  <img src="#Icon#" style="height:18px;width:18px" border="0" align="middle">
					  </td>
					  <td style="padding-left:4px">#Name#</td>
					</tr>
					
				</table>
			
			</td>
			</tr>
			
		</cfif>
		
	</cfloop> 	
			
	</table>
	
</div>

<cfif attributes.navigation eq "1">
	<cfset ajaxonload("doHighlight")>
</cfif>

</cfoutput>	 

