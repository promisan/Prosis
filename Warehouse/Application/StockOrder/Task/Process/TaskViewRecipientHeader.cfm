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
<cfparam name="headermode" default="header">

<cfif headermode eq "header">	
	<cfset st = "">
<cfelse>
	<cfset st = "font-size:1px;color:white">
</cfif> 

<cfoutput>

<tr>
	<td class="labelit" style="#st#;padding-left:20px"><!--- <cf_tl id="Mode"> ---></td>	
	<td class="labelit" style="#st#" width="10%"><cf_tl id="Request No"></td>													
	<td class="labelit" style="#st#" width="11%"><cf_tl id="Request Date"></td>
	<td class="labelit" style="#st#" width="12%"><cf_tl id="Contact"></td>
	<td class="labelit" style="#st#" width="13%"><cf_tl id="Product"></td>
	<td class="labelit" style="#st#" align="right" width="8%"><cf_tl id="Request Qty"></td>	
	<td class="labelit" style="#st#" align="right" width="8%"><cf_tl id="Approved Qty"></td>	
	<td class="labelit" style="#st#" align="center" width="10%"><cf_tl id="Task Order"></td>																
	<td class="labelit" style="#st#" width="18%"><cf_tl id="Issuing Facility"></td>			
	<td class="labelit" style="#st#" width="1%"><cf_tl id="Shipping Date"></td>								
	<td class="labelit" style="#st#" align="right" width="12%" colspan="2" align="right"><cf_tl id="Pending Balance"></td>		
	<td class="labelit" style="#st#" align="right"></td>						
</tr>

<cfif headermode eq "header">
	<tr><td colspan="13" class="line"></td></tr>
</cfif>

</cfoutput>