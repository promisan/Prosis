
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


