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

<!---
  <cfdiv bind="url:service.Process.Materials.Lot.checklot('#PO.mission#',{TransactionLot_#rw#})" id="validatelot">
  --->
  
  
<cfparam name="url.Mission"        default="">
<cfparam name="url.TransactionLot" default="0">
  
<cfparam name="Attributes.Mission"        default="#url.mission#">
<cfparam name="Attributes.TransactionLot" default="#url.transactionlot#">
 
<cfif attributes.TransactionLot neq "">

	<cfinvoke component = "Service.Process.Materials.Lot"  
		   method           = "checklot" 
		   mission          = "#Attributes.Mission#" 
		   transactionlot   = "#Attributes.TransactionLot#"
		   returnvariable   = "result">	
	
	<cfif result eq "1">
		<font color="008000">Exists</font>
	<cfelse>
		<font color="FF8000">New</font>
	</cfif>  
	
</cfif> 