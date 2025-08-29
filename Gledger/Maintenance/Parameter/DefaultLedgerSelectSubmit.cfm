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
<cfswitch expression="#URL.ID#">

	<cfcase value="Budget">
	
	    <cfquery name="Check" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_AccountReceipt
			WHERE   GLAccount   = '#URL.IDSelect#' 
		</cfquery>
			
		<cfquery name="Update" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE Ref_AccountReceipt
				SET     GLAccount   = '#URL.IDSelect#' 
				WHERE   Fund        = '#URL.ID1#'
				AND ObjectCode = '#URL.ID2#' 
		</cfquery>
					
	</cfcase>

</cfswitch>

<cfoutput>
	
	<script>     
		 parent.document.getElementById('refresh#url.id1#_#url.id2#').click()	
		 parent.ColdFusion.Window.destroy('mydialog',true)	
	</script>

</cfoutput>
