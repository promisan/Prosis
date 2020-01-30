
<cfparam name="Form.InvTagMode" default="Multiple">

<cfquery name="Update" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_ParameterMission
	SET   InvoiceDueDays                = '#Form.InvoiceDueDays#',
		  EnforceCurrency               = '#Form.EnforceCurrency#',
		  EnableInvTag                  = '#Form.EnableInvTag#',
		  InvTagMode                    = '#Form.InvTagMode#',
		  InvTagProgram                 = '#Form.InvTagProgram#',
		  InvoiceLineCreate             = '#Form.InvoiceLineCreate#',
		  InvoiceRequisition            = '#Form.InvoiceRequisition#',
		  InvoiceAdvance                = '#Form.InvoiceAdvance#',
		  AdvanceGLAccount              = '#Form.AdvanceGLAccount#',
		  ReceiptGLAccount              = '#Form.ReceiptGLAccount#',
		  InvoicePriorIssue             = '#Form.InvoicePriorIssue#',
		  InvoicePriorReceipt           = '#Form.InvoicePriorReceipt#',
		  InvoiceMatchPriceActual       = '#Form.InvoiceMatchPriceActual#',
		  InvoiceMatchDifference        = '#Form.InvoiceMatchDifference#',
		  InvoiceMatchDifferenceAmount  = '#Form.InvoiceMatchDifferenceAmount#',
		  DifferenceGLAccount           = '#Form.DifferenceGLAccount#',
		  InvoicePostingMode            = '#Form.InvoicePostingMode#',
		  InvoiceTemplate               = '#Form.InvoiceTemplate#',
	 	  OfficerUserId 	 		    = '#SESSION.ACC#',
		  OfficerLastName  				= '#SESSION.LAST#',
		  OfficerFirstName 				= '#SESSION.FIRST#',
		  Created          				=  getdate()		 				  		
	WHERE Mission                     = '#url.Mission#'
</cfquery>

<cfinclude template="ParameterEditInvoice.cfm">
