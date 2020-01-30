
<cfquery name="Current" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Request
	WHERE   RequestId  = '#Form.RequestId#'
</cfquery>

<cfquery name="history" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  sum(TransactionQuantity) as Fulfilled
	FROM    ItemTransaction
	WHERE   CustomerId  = '#Form.RequestId#'
</cfquery>

<cfif FORM.RequestedQuantity lt history.Fulfilled>
  <cf_waitEnd Frm="result">	

  <cf_tl id="You can't lower the quantity" var="1">
  <cfset msg1="#lt_text#">
  
  <cf_tl id="below the quantity" var="1">
  <cfset msg2="#lt_text#">
  
  <cf_tl id="that was already fulfilled" var="1">
  <cfset msg3="#lt_text#">
  
  <cf_tl id="for this request." var="1">
  <cfset msg4="#lt_text#">
  
  <cf_message message = "#msg1# #msg2# #msg3# #msg4#"
  return = "back">
  <cfabort>
</cfif>

<cfset status = "2">
<cfif FORM.RequestedQuantity eq Current.RequestedFulfilled>
   <cfset status = "3">
</cfif>	

<cfquery name="Update" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE  Request
	SET 	ItemNo            = '#Form.ItemNo#',
			StandardCost      = '#Form.StandardCost#',
			Warehouse         = '#Form.warehousenew#',
			RequestedQuantity = '#Form.RequestedQuantity#',
			RequestedAmount   = '#Form.RequestedAmount#',
			ReviewRemarks     = '#Form.ReviewRemarks#',
			Status            = '#Status#'
	WHERE   RequestId  = '#Form.RequestId#'
</cfquery>

<script language="JavaScript">
     window.close() 
	 opener.location.reload()
</script>  

