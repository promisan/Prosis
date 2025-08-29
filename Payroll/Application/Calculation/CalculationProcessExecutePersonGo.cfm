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
<cfquery name="Last" 
	datasource="appsPayroll"	 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   TOP 1 *
	FROM     CalculationLog	
	ORDER BY Created DESC
</cfquery>

<cfif last.recordcount eq "0">
   <cfset nextprocess = 1>
<cfelse>
   <cfset nextprocess = last.ProcessNo + 1>   
</cfif>

<cfoutput>

<table width="100%">
	<tr><td colspan="2" align="center" height="370">
		
		<button onclick="payrollprocess('#nextprocess#','#url.id#',document.getElementById('forcesettlement').value,document.getElementById('mission').value,'0'); prg = setInterval('showprogresscalculate(\'#nextprocess#\')', 5000)"			
		    class="button10g" 
			name="execute" 
			type"button"
			value="Close">
			<img src="#SESSION.root#/Images/play.png" border="0" align="absmiddle"><cf_tl id="Start">
		</button>
		
		</td>
	</tr>	
	</table>
	
</cfoutput>	