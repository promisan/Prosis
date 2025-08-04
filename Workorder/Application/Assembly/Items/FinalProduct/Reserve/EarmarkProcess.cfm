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

<table width="100%" class="formpadding">

	<tr><td colspan="8" class="line"></td></tr>
	
	<tr>
	
		<td class="labelit"><cf_tl id="Quantity">:</td>		
		<td id="totals" class="labellarge" style="width:70px;padding-left:6px"></td>										
		<td style="padding-left:3px;padding-right:10px" class="labelit"><cf_tl id="BatchReference">:</td>		
		<td><input type="text" name="BatchReference" class="regularxl" style="width:290px" maxsize="40"></td>		
		<td style="padding-left:3px" align="right">
		
		<cf_tl id="Transfer and Earmark" var="transfer">
		
		<cfoutput>
			<input type="button" 
			  class="button10g" 
			  onclick="Prosis.busy('yes');ptoken.navigate('#SESSION.root#/WorkOrder/Application/Assembly/EarmarkStock/EarmarkSubmit.cfm','totals','','','POST','stockform')"
			  style="font-size:12px;width:190;height:25px" 
			  name="Submit" 
			  value="#Transfer#">
		 </cfoutput> 
		
		</td>
	  
	  </tr>
  
  </table>