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
<cfoutput>

<cfquery name="ActionSel" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Ref_Action
		WHERE ActionCode = '#url.actionCode#'			
</cfquery>

<cfquery name="Contract" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  PersonContract
		WHERE ContractId = '#url.contractid#'			
</cfquery>

<cfif ActionSel.ModeEffective eq "2">
		
	<script>
	    document.getElementById("DateEffective").value = "#dateformat(Contract.DateEffective,CLIENT.DateFormatShow)#";
		document.getElementById("boxdateeffective").className = "hide";
		document.getElementById('finalpayno').click()
	</script>
	
<cfelseif ActionSel.ModeEffective eq "3">
		
	<script>
	    document.getElementById("DateEffective").value = "#dateformat(now(),CLIENT.DateFormatShow)#";
		document.getElementById("boxdateeffective").className = "regular";
		document.getElementById('finalpayno').click()
	</script>	
	
<cfelse>
	
	<script>
		document.getElementById("DateEffective").value = "#dateformat(Contract.DateEffective,CLIENT.DateFormatShow)#";		
		document.getElementById("boxdateeffective").className = "regular";
		document.getElementById('finalpayno').click()
	</script>

</cfif>

<cfif ActionSel.ModeEffective eq "1">
	<script>		
	 datePickerController.setRangeLow("DateEffective", "#url.first#");	 
	</script> 
<cfelse>
	<script>	
	 datePickerController.setRangeLow("DateEffective", "#url.last#");	 
	</script> 
</cfif>

<cfif url.actionCode eq "3004">  <!--- wigi --->

	<script>	
		_cf_loadingtexthtml = '';	
		ptoken.navigate('setContractStep.cfm?contractid=#url.contractid#&actioncode=#url.actioncode#&effective='+document.getElementById("DateEffective").value,'boxcontractstep')		
	</script>
	
<cfelse>	

	<script>
		_cf_loadingtexthtml = '';	
		ptoken.navigate('setContractStep.cfm?contractid=#url.contractid#&actioncode=#url.actioncode#','boxcontractstep')		
	</script>

</cfif>

<cfif url.actionCode eq "3006">  <!--- separation --->
    <script>
	document.getElementById('finalpay').className = "regular"
	document.getElementById('finalpayyes').click()
	document.getElementById("DateEffective").value = "#dateformat(Contract.DateExpiration,CLIENT.DateFormatShow)#"
	</script>
</cfif>

<cfif url.actionCode eq "3001">  <!--- separation --->
    <script>
	document.getElementById('recorddate').className = "regular"	
	</script>
<cfelse>
	 <script>
	document.getElementById('recorddate').className = "hide"	
	document.getElementById('RecordEffective').value = ""
	</script>	
</cfif>

<script>	
	_cf_loadingtexthtml='';	
	ptoken.navigate('getReason.cfm?scope=edit&mission=#contract.mission#&actioncode=#url.actioncode#','groupfield')
</script>

</cfoutput>