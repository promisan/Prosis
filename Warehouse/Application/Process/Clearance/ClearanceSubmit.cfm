
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.Selected" default="">

<cfif Form.Selected eq "">
<cf_tl id="You have not selected any line items." var="1">
<cf_message message = "#lt_text#"
  return = "back">
  <cfabort>
</cfif>  

<cfif form.Role neq "ReqReceipt">

<cfif form.Status eq "1">

	  <cfquery name="Approve" 
	   datasource="AppsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   UPDATE Request
	   SET    Status  = '#Form.StatusNext#'
	   WHERE  RequestId  IN (#PreserveSingleQuotes(Form.Selected)#)
	</cfquery>
	
	  <cfquery name="Logging" 
	   datasource="AppsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   INSERT INTO RequestAction
	   (RequestId,Role,Status,OfficerUserId,OfficerLastName,OfficerFirstName,ActionMemo)
	   SELECT RequestId,'#Form.Role#','1','#SESSION.acc#','#SESSION.last#','#SESSION.first#','#Form.Memo#'
	   FROM Request
	   WHERE RequestId  IN (#PreserveSingleQuotes(Form.Selected)#)
	  </cfquery>
 
<cfelseif form.Status eq "9">

	 <cfquery name="Approve" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  UPDATE Request
	  SET    Status  = '0'
	  WHERE  RequestId  IN (#PreserveSingleQuotes(Form.Selected)#)
	 </cfquery>
	
	 <cfquery name="Logging" 
	   datasource="AppsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   INSERT INTO RequestAction
	           (RequestId,Role,Status,OfficerUserId,OfficerLastName,OfficerFirstName,ActionMemo)
	   SELECT  RequestId,'#Form.Role#','0','#SESSION.acc#','#SESSION.last#','#SESSION.first#','#Form.Memo#'
	   FROM    Request
	   WHERE   RequestId  IN (#PreserveSingleQuotes(Form.Selected)#)
	  </cfquery>

</cfif>	

<cfelse>
	
	<!---
	
	<cfif form.Status eq "1">
	
	<cfquery name="Shipping" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Shipping
		SET   Status              = '2',
			  DeliveredUserId     = '#SESSION.acc#',
			  DeliveredLastName   = '#SESSION.last#',
			  DeliveredFirstName  = '#SESSION.first#',
			  DeliveryDate        = getDate(),
			  DeliveryReference   = '#FORM.Memo#'
	  	WHERE TransactionRecordNo  IN (#PreserveSingleQuotes(Form.Selected)#)
		</cfquery>
		
	<cfelseif form.Status eq "9">	
	
	<cfquery name="Shipping" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE  Shipping
		SET     Status              = '9',
				DeliveredUserId     = '#SESSION.acc#',
				DeliveredLastName   = '#SESSION.last#',
				DeliveredFirstName  = '#SESSION.first#',
				DeliveryDate        = getDate(),
				DeliveryReference   = '#FORM.Memo#'
	  	WHERE TransactionRecordNo  IN (#PreserveSingleQuotes(Form.Selected)#)
		</cfquery>
		
	</cfif>	
	
	--->

</cfif>

<cfoutput>
<script language="JavaScript">
     window.location = "Listing.cfm?idmenu=#url.idmenu#&mission=#URL.Mission#&sorting=#Form.group#"
</script> 
</cfoutput> 


