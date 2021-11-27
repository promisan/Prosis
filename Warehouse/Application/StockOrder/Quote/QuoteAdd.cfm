
<cfparam name="url.requestNo" default="">
<cfset url.customerid   = "00000000-0000-0000-0000-000000000000">
<cfset url.addressid    = "00000000-0000-0000-0000-000000000000">


<cfif url.requestNo neq "">

	<cfquery name="getHeader" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT   TOP 1 *,   (SELECT TOP 1 PriceSchedule 
				  FROM   CustomerRequestLine 
				  WHERE  RequestNo = P.RequestNo) as PriceSchedule
		FROM     CustomerRequest P
		WHERE   RequestNo = '#url.requestNo#'				
	</cfquery>

<cfelse>
	
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
		SELECT   TOP 1 *, 
		         (SELECT TOP 1 PriceSchedule 
				  FROM   CustomerRequestLine 
				  WHERE  RequestNo = P.RequestNo) as PriceSchedule
		FROM     CustomerRequest P
		WHERE    Warehouse     = '#url.warehouse#'
		AND      OfficeruserId = '#session.acc#'
		ORDER BY RequestNo DESC							
	</cfquery>

</cfif>

<cfoutput>

<CFParam name="Attributes.height" default="660">
<CFParam name="Attributes.width"  default="980">	
<CFParam name="Attributes.Modal"  default="true">	
	
<table width="100%">

	  <cfset link   = "#SESSION.root#/warehouse/application/stockorder/Quote/QuoteAdd.cfm?mission=#url.mission#&">	

	  <cfset jvlink = "ProsisUI.createWindow('dialogquotebox','Quote','',{x:100,y:100,height:document.body.clientHeight-80,width:#Attributes.width#,modal:#attributes.modal#,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/StockOrder/Quote.cfm?mission=#url.mission#&datasource=appsMaterials&close=Yes&class=Customer&box=boxquote&link=#link#&dbtable=&des1=requestno&filter1=mission&filter1value=#url.mission#&filter2=&filter2value=','dialogquotebox')">		

      <tr class="labelmedium2 line fixlengthlist">
		  <td style="padding-left:10px;padding-top:3px" id="priceschedule">
		  
		        <cfif getHeader.priceschedule neq "">
		  
		            <cfinclude template="getQuoteSchedule.cfm">
				
				<cfelse>
				
				    <cf_tl id="Number">:
		  					
				</cfif>
						  
		  </td>
		  <td id="quotebox" style="padding-left:7px;font-size:20px">
		  
		  <cfif getHeader.recordcount gte "1">
		  <a href="javascript:stockquote('#getHeader.RequestNo#','')">#getHeader.RequestNo#</a>
		  <cfelse>		  
		  #getHeader.RequestNo#
		  </cfif>
		  </td>
		  <td align="right">
		  <button type="button" onclick="#jvlink#" class="button10g" style="width:40px">
		  <img src="#SESSION.root#/Images/Search-R-Blue.png" width="26"></button></td>
	  </tr>
	  
	  <cfset link   = "#SESSION.root#/warehouse/application/stockorder/Quote/applyCustomer.cfm?requestno=#getHeader.RequestNo#&">			
	  <cfset jvlink = "ProsisUI.createWindow('dialogcustomerbox','Customer','',{x:100,y:100,height:document.body.clientHeight-80,width:#Attributes.width#,modal:#attributes.modal#,center:true});ptoken.navigate('#SESSION.root#/Tools/SelectLookup/Customer/Customer.cfm?mission=#url.mission#&datasource=appsMaterials&close=Yes&class=Customer&box=customerbox&link=#link#&dbtable=&des1=customerid&filter1=&filter1value=&filter2=&filter2value=','dialogcustomerbox')">		
	
	  <tr class="labelmedium2 line fixlengthlist">
		  <td valign="top" style="padding-top:4px;padding-left:10px;padding-top:5px"><cf_tl id="Customer">:</td>
		  
		  <td id="customerbox" style="padding-top:2px">
		  
		   <cfif getHeader.customerid neq "">				  
							  
				<cfquery name="getCustomer" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
					SELECT   *
					FROM     Customer
					WHERE    CustomerId = '#getHeader.customerid#'					
				</cfquery>
				
				<table>
				<cfloop query="getCustomer">
					<tr class="labelmedium2"><td>#CustomerSerialNo#</td></tr>
					<tr class="labelmedium2"><td>#CustomerName#</td></tr>
				</cfloop>
				</table>
			
			</cfif>  
		  
		  </td>
		  <td align="right">
		    <button type="button" onclick="#jvlink#" class="button10g" style="width:40px">                                                       
				<img src="#SESSION.root#/Images/Search-R-Blue.png" width="26"></button>				
			
		  </td>
	  </tr>
				
	  <tr class="labelmedium2 line fixlengthlist">
		  <td style="padding-left:10px"><cf_tl id="eMail">:</td>
		  <td colspan="2" id="boxmail">
		    <input onchange="setquote('#getHeader.RequestNo#','mail')" class="regularxxl" type="text" 
		    id="customermail" name="CustomerMail" 
		    style="padding-left:4px;width:100%;background-color:f1f1f1;border:0px"></td>
	  </tr>
	  
	    <tr class="labelmedium2 line fixlengthlist">
		  <td style="padding-left:10px"><cf_tl id="Memo">:</td>
		  <td colspan="2" id="boxmail">
		    <textarea onchange="setquote('#getHeader.RequestNo#','remarks')" class="regularxl" type="text" 
		    id="remarks" name="remarks" 
		    style="font-size:14px;height:42px;padding:4px;width:100%;background-color:f1f1f1;border:0px"></textarea>
			</td>
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

</cfoutput>

<cfoutput>	

<script>
   document.getElementById('requestno').value    = "#getHeader.RequestNo#"
   document.getElementById('boxlines').innerHTML = ""
   
   <!--- refresh content --->
   <cfif getHeader.requestNo neq "">
       ptoken.navigate('getQuoteLine.cfm?action=add&requestno=#getHeader.RequestNo#&warehouse=#getHeader.Warehouse#&action=view','boxlines') 				
	   document.getElementById('boxaction').className = "regular"
   </cfif>
   
</script>

</cfoutput>