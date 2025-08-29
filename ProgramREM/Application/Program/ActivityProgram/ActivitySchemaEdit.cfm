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
<cf_divscroll>

<cfform 
	action="#session.root#/programrem/application/program/activityProgram/ActivitySchemaSubmit.cfm?programcode=#url.programcode#&period=#url.period#&activityid=#url.activityid#&refresh=1" 
	method="POST" 
	name="ActivityEntry">

	<table width="97%" align="center">
		<TR class="labelmedium">
	    <td valign="top" style="padding-top:10px;">
			<cfinclude template="ActivitySchemaView.cfm">	
		 </td>
	   </tr>	
	  	  
	   <tr><td height="38" colspan="2" align="center">
	   	 <cfoutput>
			<cf_tl id="Save"   var="vSave">
		    <input class="button10g" type="submit" name="Submit" value="#vSave#" onclick="Prosis.busy('yes');">	  
		 </cfoutput>
	   </td></tr>
	  
	  </table>
	   
	 </td></tr>
	 
	 </table>
 
</cfform>

</cf_divscroll>