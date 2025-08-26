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
<cfparam name="URL.MID" default="-">
<!---- Added by dev dev on 9/22/2010 ---->
<cf_screentop html="no" jquery="yes">

<cfoutput>
	
	<script language="JavaScript">
			
	parent.window.treeselect.value = "&mode=#URL.mode#&ID1=#URL.ID1#&mission=#URL.ID2#&mandate=#URL.ID3#&mid=#url.mid#"
	
	// alert(parent.document.getElementById("SystemFunctionId").value)
	
	ptoken.location("AllotmentActionListing.cfm?Period=" + parent.document.getElementById("PeriodSelect").value + 
				"&Edition=" + parent.document.getElementById("edition").value + 
				"&ProgramGroup=" + parent.document.getElementById("ProgramGroup").value +				
				"&UNIT=#URL.UNIT#&mode=#URL.mode#&ID1=#URL.ID1#&id2=#URL.ID2#&id3=#URL.ID3#&systemfunctionid=#url.systemfunctionid#&mid=#url.mid#")
	
	</script>

</cfoutput>
