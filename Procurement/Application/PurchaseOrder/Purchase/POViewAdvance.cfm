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

<cfparam name="url.del" default="">

<cfif url.del neq "">

	<cfquery name="Header" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
		SELECT * FROM TransactionHeader
		WHERE   TransactionId = '#url.del#' 
	</cfquery>

	<cfquery name="Check" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
		SELECT  *
		FROM    TransactionLine
		WHERE   ParentJournal = '#Header.Journal#' 
		AND     ParentJournalSerialNo = '#Header.JournalSerialNo#'
	</cfquery>
	
	<cfif Check.recordcount eq "0">
	
		<cfquery name="Delete" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			DELETE FROM TransactionHeader
			WHERE   TransactionId = '#url.del#' 
		</cfquery>
	
	</cfif>

</cfif>

<cfoutput>
	
	<script>
			
		function requestadvance(po)	{					
			ProsisUI.createWindow('myadvance', 'Advance', '',{x:100,y:100,height:document.body.clientHeight-120,width:800,modal:true,resizable:true,center:true})    
			ptoken.navigate('#SESSION.root#/Procurement/Application/PurchaseOrder/Purchase/POViewAdvanceView.cfm?id=' + po,'myadvance') 																		
					
		}
		
		function requestadvancerefresh(po) {
		    ptoken.navigate('#SESSION.root#/Procurement/Application/PurchaseOrder/Purchase/POViewAdvance.cfm?id1='+po,'advances')		
		}	
		
	</script>
	
	<cfdiv id="advances">
		<cfinclude template="POViewAdvanceDetail.cfm">
	</cfdiv>

</cfoutput>	


