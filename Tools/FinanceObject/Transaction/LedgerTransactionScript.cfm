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

<cf_dialogLedger>
	
	<cfset root = "#SESSION.root#">
	
	<script language="JavaScript">
	
		var root = "#root#";
		
		function addledgertransaction(mis,per,org,jrn,src,srcno,srcid,box,dc,label,fun,amt) {
				
	    w = #CLIENT.width# - 100;
		h = #CLIENT.height# - 155;
		ptoken.open(root + "/Gledger/Application/Transaction/Standard/TransactionInit.cfm?mission="+mis+"&accountPeriod="+per+"&OrgUnitOwner="+org+"&Journal="+jrn+"&source="+src+"&sourceno="+srcno+"&sourceid="+srcid+"&amount="+amt+"&ts="+new Date().getTime(), "_blank", "toolbar=no,status=yes,height="+h+",width="+w+",scrollbars=no, center=yes, resizable=yes");	
		
	    }
		
	</script>	

</cfoutput>