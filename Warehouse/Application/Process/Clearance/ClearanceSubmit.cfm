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


