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
	
<cf_compression>		

<cfquery name="Check"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     ItemTransaction
	WHERE    TransactionBatchNo = '#URL.BatchNo#'
	AND      ActionStatus = '0'
</cfquery>

<cfoutput>
	
<cfif check.recordcount eq "0">

	<script language="JavaScript">
	try {  document.getElementById("actionbox").className = "regular" } catch(e) {}		
	</script>
				
	<cf_tl id="Confirm" var="1">
		
	<cf_button onclick="batchdecision('confirm')" 
		   name="Confirm" 
		   id="Confirm"
		   mode="greenlarge" 
		   label="#lt_text#" 
		   label2="transaction" 
		   icon="images/selectDocument.gif">		   
				   
</cfif>

</cfoutput>
