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

<cfparam name="page" default="1">

<cfoutput>
 <tr class="noprint">
    <td height="26" class="top4n">
	<font face="Verdana"><b>&nbsp;#Header#</b></font>
	</td>
	<td align="right" class="top4n">
	&nbsp;<button onClick="javascript:recordadd()" class="buttonFlat">Register #Header#</button>&nbsp;
	
	<cfif #page# eq "1">
	    <cfinclude template="../../Tools/PageCount.cfm">
	    <select name="page" size="1" style="background: e4e4e4;" onChange="javascript:reloadForm(this.value)">
	       <cfloop index="Item" from="1" to="#pages#" step="1">
		        <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
	       </cfloop>	 
	    </SELECT>  
	</cfif> 	
	
	</td>
  </tr> 
</cfoutput>  	