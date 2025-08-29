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
<cfparam name="url.wf" default="0">

<cfquery name="Parameter" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_ParameterMission
		WHERE     Mission = '#URL.Mission#'		
	</cfquery>
	
<cfif Parameter.PersonActionEnable eq "0" or 
      Parameter.PersonActionNo eq "" or 
	  Parameter.PersonActionPrefix eq "">

	<input type="text" name="PersonnelActionNo" class="regularxxl"  size="12" maxlength="20">

<cfelse>

   | number will be generated | 

</cfif>	

<!--- we reset also the position --->

<cfif url.wf eq "0">
	
	<script>
	    try {
		document.getElementById('PositionNo').value = ""
		document.getElementById('Position').value = ""
		document.getElementById('assignmentbox').innerHTML = ""
		} catch(e) {}
	</script>

</cfif>