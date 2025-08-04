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

<cfquery name="set"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE SalaryScale
		SET    Operational = '#url.operational#'
		WHERE  ScaleNo = '#url.scaleNo#'			
</cfquery>

<cfquery name="get"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM SalaryScale
		WHERE ScaleNo = '#url.scaleNo#'		  
</cfquery>
	
<cfif get.operational eq "1">
	 <cf_tl id="Active">
<cfelse>
	 <cf_tl id="Disabled">
</cfif>

<cfoutput>

<script language="JavaScript">
	parent.ptoken.navigate('RateViewTree.cfm?idmenu=#url.idmenu#&location=#get.servicelocation#&schedule=#get.salaryschedule#&mission=#get.mission#&operational=#url.operational#','treeview')
	document.getElementById('header').style.background = <cfif get.operational eq '1'>'eaeaea'<cfelse>'FF8080'</cfif>
	$('##operational',window.parent.document).val('#url.operational#');
</script>

</cfoutput>


