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
<cfquery name="get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_AppointmentStatus PA 
		WHERE     Code = '#URL.appointmentStatus#' 			
</cfquery>	

<cfquery name="ContractSel" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      PersonContract 
		WHERE     ContractId = '#URL.contractId#' 			
</cfquery>	
	
	
<cfif get.MemoContent eq "">

	<script>
	document.getElementById('appointmentmemo').className = "hide"
	</script>
	
	<input type="hidden" name="AppointmentStatusMemo" value="">

<cfelse>

	<script>
	document.getElementById('appointmentmemo').className = "regular"
	</script>
	
	<table style="width:100%">
	<tr class="labelmedium2 line">
	   <td bgcolor="E6E6E6" style="padding-left:6px;border-right:1px solid silver"><cf_tl id="#get.MemoContent#"></td>
	   <td>
	   <cfoutput>
	   <input type="text" name="AppointmentStatusMemo" value="#ContractSel.AppointmentStatusMemo#" maxlength="100" class="regularxxl" style="border:0px;border-top:1px solid silver;background-color:ffffaf;width:100%;min-width:200px">							
	   </cfoutput>			
	   </td>
	   
   </tr>
	</table>

</cfif> 