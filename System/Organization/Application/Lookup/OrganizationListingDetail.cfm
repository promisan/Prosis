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

	<tr class="labelmedium2 navigation_row line fixlengthlist">
	
		<td style="padding-top:4px;padding-left:4px;padding-right:4px;width:50px">
		
			<cfswitch expression="#URL.Source#">					
						
				<cfcase value="ProcurementJob">
					
				   <a href="javascript:job('#OrgUnit#')" 
					  onMouseOver="document.img0_#orgunit#.src='../../../../Images/button.jpg'" 
					  onMouseOut="document.img0_#orgunit#.src='../../../../Images/view.jpg'">
				       <img src="../../../../Images/view.jpg" alt="" 
					      name="img0_#orgunit#" 
						  id="img0_#orgunit#" 
						  width="14" 
						  height="14" 
						  border="0" 
						  align="middle" 
						  onClick="selectunit('#OrgUnit#')">
				    </a>
				
				</cfcase>
				
				<cfdefaultcase>
				
				   <cf_img icon="select" navigation="Yes" tooltip="Select" onclick="selectunit('#OrgUnit#')">
				  						
				</cfdefaultcase>
			
			</cfswitch>
		
		</td>
		<td>#OrgUnitCode#</td>
		<TD>#OrgUnitName#</TD>
		<TD>#OrgUnitNameShort#</TD>
	
    </tr>

</cfoutput>

<cfset ajaxonload("doHighlight")>

