
<cfquery name="Update" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE Ref_ParameterMission
	SET	ReceiptPrefix            = '#Form.ReceiptPrefix#', 
		ReceiptSerialNo          = '#Form.ReceiptSerialNo#',
		ReceiptTemplate          = '#Form.ReceiptTemplate#',
		ReceiptPriorApproval     = '#Form.ReceiptPriorApproval#',
		OfficerUserId 	 		 = '#SESSION.ACC#',
		OfficerLastName  		 = '#SESSION.LAST#',
		OfficerFirstName 		 = '#SESSION.FIRST#',
		Created          		 =  getdate()				 				
	WHERE 	Mission              = '#url.Mission#'
</cfquery>

<cfquery name="Update" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE Ref_CustomFields
SET ReceiptReference1  = '#Form.ReceiptReference1#',
    ReceiptReference2  = '#Form.ReceiptReference2#',
	ReceiptReference3  = '#Form.ReceiptReference3#',
	ReceiptReference4  = '#Form.ReceiptReference4#'
</cfquery>


<cfinclude template="ParameterEditReceipt.cfm">

	
