
<cfset url.customerid   = "00000000-0000-0000-0000-000000000000">
<cfset url.addressid    = "00000000-0000-0000-0000-000000000000">

<cfquery name="getHeader" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
						
	INSERT INTO CustomerRequest ( 	
	        Mission, 
			Warehouse, 				
			CustomerId,
			AddressId, 				
			Source, 
			ActionStatus,
			OfficerUserId, 
			OfficerLastName, 
			OfficerFirstName )
			
	VALUES ( '#url.Mission#', 
			 '#url.warehouse#', 
			 '#url.Customerid#', 
			 '#url.addressId#',
			 'Quote',
			 '0',
			 '#session.acc#',
			 '#session.last#',
			 '#session.first#' )
			 
</cfquery>

<cfquery name="getHeader" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	SELECT   TOP 1 *
	FROM     CustomerRequest
	ORDER BY RequestNo DESC							
</cfquery>

<cfoutput>

<CFParam name="Attributes.height" default="660">
<CFParam name="Attributes.width"  default="780">	
<CFParam name="Attributes.Modal"  default="true">	
			
<cfset link   = "#SESSION.root#/warehouse/application/stockorder/Quote/applyCustomer.cfm?requestno=#getHeader.RequestNo#&">			
<cfset jvlink = "ProsisUI.createWindow('dialogcustomerbox','Customer','',{x:100,y:100,height:document.body.clientHeight-80,width:#Attributes.width#,modal:#attributes.modal#,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Customer/Customer.cfm?datasource=appsMaterials&close=Yes&class=Customer&box=customerbox&link=#link#&dbtable=&des1=customerid&filter1=&filter1value=&filter2=&filter2value=','dialogcustomerbox')">		

<table width="100%">

      <tr class="labelmedium2 line">
		  <td style="padding-left:10px;font-size:15px"><cf_tl id="Number"></td>
		  <td colspan="2">#getHeader.RequestNo#</td>
	  </tr>
	
	  <tr class="labelmedium2 line">
		  <td valign="top" style="padding-top:4px;padding-left:10px;font-size:15px"><cf_tl id="Customer"></td>
		  
		  <td id="customerbox" style="padding-top:2px"></td>
		  <td align="right">
		    <button type="button" onclick="#jvlink#" class="button10g" style="width:50px">                                                       
				<img src="#SESSION.root#/Images/Search-R-Blue.png" width="26"></button>				
			
		  </td>
	  </tr>
				
	  <tr class="labelmedium2 line">
		  <td style="padding-left:10px;font-size:15px"><cf_tl id="eMail"></td>
		  <td colspan="2" id="boxmail" style="border-left:1px solid silver">
		    <input onchange="setquote('#getHeader.RequestNo#','mail')" class="regularxxl" type="text" 
		    id="customermail" name="CustomerMail" 
		    style="padding-left:4px;width:100%;background-color:f1f1f1;border:0px"></td>
	  </tr>
	  
	  <tr class="labelmedium" style="height:30px">
	      <td></td>
	      <td colspan="2">
		  
			  <table>
				  <tr>
					  <td><input type="radio" name="RequestClass" class="radiol" value="Quote" onclick="setquote('#getHeader.RequestNo#','class')" checked></td>
					  <td style="padding-left:3px"><cf_tl id="Quote ONLY"></td>					  
					  <td style="padding-left:3px"><input type="radio" name="RequestClass" class="radiol" onclick="setquote('#getHeader.RequestNo#','class')" value="QteReserve"></td>
					  <td style="padding-left:3px"><cf_tl id="Reservation"></td>
				  </tr>
			  </table>
		
		  </td>
		</tr>
				
</table>		

<script>
   document.getElementById('requestno').value    = "#getHeader.RequestNo#"
   document.getElementById('boxlines').innerHTML = ""
</script>

</cfoutput>