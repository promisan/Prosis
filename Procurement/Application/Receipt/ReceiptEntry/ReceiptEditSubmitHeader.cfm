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
		
<cfset dateValue = "">
<CF_DateConvert Value="#Form.ReceiptDate#">
<cfset dte = dateValue>
 
<cfparam name="Form.ReceiptReference1" default="">
<cfparam name="Form.ReceiptReference2" default="">
<cfparam name="Form.ReceiptReference3" default="">
<cfparam name="Form.ReceiptReference4" default="">
<cfparam name="Form.CostDescription" default="">
						
 <cfquery name="Header" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Receipt
	SET PackingSlipNo     = '#Form.PackingSlipNo#',
	      ReceiptReference1 = '#Form.ReceiptReference1#', 
		  ReceiptReference2 = '#Form.ReceiptReference2#',
		  ReceiptReference3 = '#Form.ReceiptReference3#',
		  ReceiptReference4 = '#Form.ReceiptReference4#',
		  ReceiptDate       = #dte#,
		  ReceiptRemarks    = '#Form.ReceiptRemarks#'
	WHERE ReceiptNo = '#URL.ID#'	
  </cfquery>
  
     
  <cfif form.CostDescription neq "">
  
	<cfquery name="get" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT *
		FROM    ReceiptCost
		WHERE   ReceiptNo    = '#URL.ID#'	
		
	</cfquery>
	
	<cfif get.recordcount eq "0">
      
	    <cfquery name="InsertCost" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			INSERT INTO ReceiptCost
					 (ReceiptNo, 
					  Description,				  
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
			SELECT  ReceiptNo,
				    '#Form.CostDescription#', 
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#'
			FROM    Receipt
			WHERE   ReceiptNo    = '#URL.ID#'	
			
			
		</cfquery>
	
	<cfelse>
	
		<cfquery name="Update" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE ReceiptCost
			SET    Description = '#form.costdescription#'
			WHERE  CostId = '#get.CostId#' 
		</cfquery>
	
	</cfif>
	
</cfif>	

<script>
    Prosis.busy('yes')
	history.go()
</script>
	
	



