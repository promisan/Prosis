<!--- keeps the link to the job --->

<cftransaction>
		
	<cfquery name="ResetLines" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    UPDATE RequisitionLine
	    SET    ActionStatus = '9'
	    WHERE  RequisitionNo IN (SELECT RequisitionNo 
	                             FROM   PurchaseLine 
								 WHERE  PurchaseNo = '#URL.PurchaseNo#') 
	</cfquery>		
				
	<!---  3. enter action --->
	<cfquery name="InsertAction" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO RequisitionLineAction 
					 (RequisitionNo, 
					  ActionStatus, 
					  ActionDate, 
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
		 SELECT    RequisitionNo, 
		            '9',
		            getDate(), 
				    '#SESSION.acc#', 
				    '#SESSION.last#', 
				    '#SESSION.first#'
		 FROM       PurchaseLine 
		 WHERE      PurchaseNo = '#URL.PurchaseNo#'
	</cfquery>
				
	<cfquery name="PurchaseLine" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		   	UPDATE PurchaseLine
			SET    ActionStatus = '9'
		    WHERE  PurchaseNo = '#URL.PurchaseNo#' 
	</cfquery>
	
	<cfquery name="Purchase" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		    UPDATE Purchase
		    SET    ActionStatus        = '9',
			       RecordStatus        = '9',
				   RecordStatusDate    = getDate(),
				   RecordStatusOfficer = '#session.acc#'
		    WHERE  PurchaseNo = '#URL.PurchaseNo#' 
	</cfquery>

</cftransaction>

<font color="FF0000"><cf_tl id="Obligation is cancelled"></font>
	