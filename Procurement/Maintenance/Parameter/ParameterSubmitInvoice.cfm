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
