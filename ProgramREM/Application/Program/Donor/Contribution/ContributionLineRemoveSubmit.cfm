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

<cftransaction>
	
	<cfquery name="qLines" 
	    datasource="AppsProgram" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		DELETE FROM ContributionLinePeriod
		WHERE  ContributionLineId = '#URL.ContributionLineId#'		   
	</cfquery>	
	
	<cfquery name="qLines" 
	    datasource="AppsProgram" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		DELETE FROM ContributionLineLocation
		WHERE  ContributionLineId = '#URL.ContributionLineId#'		   
	</cfquery>	
	
	<cfquery name="qLines" 
	    datasource="AppsProgram" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		DELETE FROM ContributionLineProgram
		WHERE  ContributionLineId = '#URL.ContributionLineId#'		   
	</cfquery>	
	
	<cfquery name="qLines" 
	    datasource="AppsProgram" 
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		DELETE FROM ContributionLine
		WHERE  ContributionLineId = '#URL.ContributionLineId#'		   
	</cfquery>	

</cftransaction>

<cfoutput>
<script>
	$('##r_#URL.ContributionLineId#').hide();
	$('##l_#URL.ContributionLineId#').remove();
</script>
</cfoutput>