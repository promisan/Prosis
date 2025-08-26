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

<!--- passtru template --->

<cfparam name="URL.UNIT" default="-">
<cfparam name="URL.ID1"  default="Tree">
<!---- Added by dev dev on 9/22/2010 ---->
<cfparam name="URL.Mode" default="PRG">

<cf_screentop jquery="Yes" html="No">

<cfoutput>
	
	<script language="JavaScript">
	
	parent.Prosis.busy('yes')
	
	parent.window.treeselect.value = "&mode=#URL.mode#&ID1=#URL.ID1#&mission=#URL.ID2#&mandate=#URL.ID3#"
	
	// alert(parent.document.getElementById("SystemFunctionId").value)
	
	ptoken.location("AllotmentViewGeneral.cfm?Period=" + parent.document.getElementById("PeriodSelect").value + 
				"&Edition=" + parent.document.getElementById("edition").value + 
				"&ProgramGroup=" + parent.document.getElementById("ProgramGroup").value +
				"&SystemFunctionId=" + parent.document.getElementById("SystemFunctionId").value +
				"&UNIT=#URL.UNIT#&mode=#URL.mode#&ID1=#URL.ID1#&mission=#URL.ID2#&mandate=#URL.ID3#")
	
	</script>

</cfoutput>
