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

<cfoutput>
	
	<cfquery name="Update"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE ItemTransaction
		SET    ActionStatus = '#URL.act#'
		<!---, 
		       ActionUserId    = '#SESSION.acc#',
			   ActionDate      = getDate()
			   --->
		WHERE TransactionId = '#URL.TransactionId#'
	</cfquery>
			
	<cfif url.act eq "0">
	
		 <cfquery name="resetAction" 
            datasource="AppsMaterials" 
            username="#SESSION.login#" 
            password="#SESSION.dbpw#">
                DELETE FROM ItemTransactionAction
				WHERE  TransactionId = '#url.transactionid#'
				AND    ActionCode = 'Consolidated'				
         </cfquery>	
									 
		 <img src="#SESSION.root#/Images/button.jpg"
	     border="0" onclick="setlinestatus('#transactionid#','1')" height="14" width="14" align="absmiddle" style="cursor: pointer;">
				 
	<cfelse>
	
		<cfquery name="recordAction" 
            datasource="AppsMaterials" 
            username="#SESSION.login#" 
            password="#SESSION.dbpw#">
              INSERT INTO [dbo].[ItemTransactionAction]
                        (TransactionId,ActionCode,ActionStatus,OfficerUserId,OfficerLastName,OfficerFirstName)
               VALUES ('#url.transactionid#',
                       'Consolidated',
                       '5',                        
                       '#session.acc#',
                       '#session.Last#',
                       '#session.First#')
        </cfquery>
				 
	   <img src="#SESSION.root#/Images/TransactionType/validate.png"
	     border="0"
		 onclick="setlinestatus('#transactionid#','0')"
		 align="absmiddle"
		 height="16" width="14"
	     style="cursor: pointer;">
				 
	</cfif>

</cfoutput>

<script>
	checkconfirm()
</script>

