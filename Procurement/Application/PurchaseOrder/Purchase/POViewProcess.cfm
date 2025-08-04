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
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<!--- delete vendor --->

<cf_screentop  
    layout       = "webapp" 
	html         = "no" 	
	scroll       = "No"	
	jQuery       = "Yes"
	menuAccess   = "context">

<cfparam name="url.reqno"        default="0">
<cfparam name="url.reinstatereq" default="true">

<cfparam name="Form.RequisitionNo" default="'#url.reqno#'">

<cf_tl id="Processing" var="1">
<cfset vProcessing= "#lt_text#">	

<cf_tl id="Purchase order" var="1">
<cfset vPurchase=#lt_text#>
	
<cf_tl id="REQ045" var="1">
<cfset vReq045=#lt_text#>

	<cftransaction>
	
	<cfif url.reinstatereq eq "true">

		<!--- Reset link --->
		<cfquery name="Update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE  RequisitionLine
			SET     ActionStatus = '2k'
			WHERE   RequisitionNo IN (#PreserveSingleQuotes(Form.RequisitionNo)#)
		</cfquery>
		
		<cfquery name="InsertAction" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO RequisitionLineAction 
					 (RequisitionNo, 
					  ActionStatus, 
					  ActionDate, 
					  ActionMemo,				
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
			SELECT   RequisitionNo,'2k',getdate(),'Reinstated Requisition from Purchase','#SESSION.acc#','#SESSION.last#','#SESSION.first#'
			FROM 	 RequisitionLine
			WHERE    RequisitionNo IN (#PreserveSingleQuotes(Form.RequisitionNo)#)  	   
		</cfquery>
	
	<cfelse>
	
		<!--- cancel the requisition --->
	
		<cfquery name="Update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE  RequisitionLine
			SET     ActionStatus = '9'
			WHERE   RequisitionNo IN (#PreserveSingleQuotes(Form.RequisitionNo)#)
		</cfquery>
		
		<cfquery name="InsertAction" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO RequisitionLineAction 
					 (RequisitionNo, 
					  ActionStatus, 
					  ActionDate, 
					  ActionMemo,				
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
			SELECT   RequisitionNo,'9',getdate(),'Removed Requisition from Purchase','#SESSION.acc#','#SESSION.last#','#SESSION.first#'
			FROM 	 RequisitionLine
			WHERE    RequisitionNo IN (#PreserveSingleQuotes(Form.RequisitionNo)#)  	   
		</cfquery>
	
	
	</cfif>
		
	<!--- Reset link --->
	<cfquery name="Update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Job
		SET    ActionStatus = '0'
		WHERE  JobNo IN (SELECT JobNo 
		                FROM    RequisitionLineQuote 
						WHERE   RequisitionNo IN (#PreserveSingleQuotes(Form.RequisitionNo)#))
	</cfquery>
	
	<!--- Remove lines --->
	<cfquery name="Delete" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM PurchaseLine
		WHERE  RequisitionNo IN (#PreserveSingleQuotes(Form.RequisitionNo)#)
	</cfquery>
	
	<!--- check if PO has invoices --->
	
	<cfquery name="CheckPO" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Purchase
		WHERE  PurchaseNo = '#URL.ID1#'
	</cfquery>
	
	<cfquery name="CheckLine" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   PurchaseLine
		WHERE  PurchaseNo = '#URL.ID1#'
	</cfquery>
	
	<cfquery name="CheckInvoice" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   InvoicePurchase
		WHERE  PurchaseNo = '#URL.ID1#'
	</cfquery>
	
	<cfif CheckPo.recordcount eq "1" and 
	    CheckLine.recordcount eq "0" and 		
		CheckInvoice.recordcount eq "0" and 
		url.removepo eq "true">
	
		<!--- Remove purchase header --->
		<cfquery name="Remove" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Purchase
			WHERE  PurchaseNo = '#URL.ID1#' 
		</cfquery>
		
		<cf_message message = "#vPurchase# [#URL.ID1#] #vReq045#" return="close">
				
	<cfelse>	
	
		<cfoutput>
		
			<script language="JavaScript">	 
	   			ptoken.location("POView.cfm?ID1=#URL.ID1#&Role=#URL.Role#&mode=view")					 
			</script>
		
		</cfoutput>
	
	</cfif>
		
	</cftransaction>
	
