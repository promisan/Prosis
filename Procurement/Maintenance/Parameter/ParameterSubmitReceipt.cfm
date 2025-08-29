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
<cfquery name="Update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_ParameterMission
	SET  	ReceiptPrefix            = '#Form.ReceiptPrefix#', 
	    	ReceiptSerialNo          = '#Form.ReceiptSerialNo#',
    		ReceiptTemplate          = '#Form.ReceiptTemplate#',
	    	ReceiptPriorApproval     = '#Form.ReceiptPriorApproval#',
    		ReceiptItemPrice         = '#Form.ReceiptItemPrice#',		
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
	SET    ReceiptReference1  = '#Form.ReceiptReference1#',
	       ReceiptReference2  = '#Form.ReceiptReference2#',
		   ReceiptReference3  = '#Form.ReceiptReference3#',
		   ReceiptReference4  = '#Form.ReceiptReference4#'
</cfquery>

<cfinclude template="ParameterEditReceipt.cfm">

	
