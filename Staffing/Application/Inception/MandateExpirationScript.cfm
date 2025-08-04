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

<cfparam name="url.action" default="init">

<cfoutput>

<cfif url.action eq "init">
	
	<script>
	
		effec = document.getElementById("DateEffective")    
		expir = document.getElementById("DateExpiration")	
		
		if (expir.value != '') {		    
			_cf_loadingtexthtml='';	 
			ptoken.navigate('MandateExpirationScript.cfm?action=apply&id=#URL.ID#&id1=#URL.ID1#&effective='+effec.value+'&expiration='+expir.value,'DateExpiration_trigger')
		}
		
	</script>

<cfelse>
	
	<cfquery name="Get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Mandate
		WHERE  Mission   = '#URL.ID#'
		AND    MandateNo = '#URL.ID1#'		
	</cfquery>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#url.effective#">
	<cfset EFF = dateValue>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#url.expiration#">
	<cfset EXP = dateValue>

	<cfif IsDate(EXP)>
	
	<script>
	
	<cfif get.DateExpiration lt EXP>		
	  ptoken.navigate('setMandateEditPosition.cfm?show=1','positionexpirationadjust')	
	  ptoken.navigate('setMandateEditAssignment.cfm?show=1','assignmentexpirationadjust')
	<cfelse>	
	  ptoken.navigate('setMandateEditPosition.cfm?show=0','positionexpirationadjust')	
	  ptoken.navigate('setMandateEditAssignment.cfm?show=0','assignmentexpirationadjust')
	</cfif>
	</script>
	
	</cfif>
	
</cfif>

</cfoutput>