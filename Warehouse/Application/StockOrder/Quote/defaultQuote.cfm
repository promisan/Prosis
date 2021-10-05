
<cfprocessingdirective suppresswhitespace="Yes" pageencoding="utf-8">

<cf_tl id="Quotation" var="mQuotation">

<cf_screentop html="No">

<cfoutput>

 <cfquery name="get"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   CustomerRequest 
	WHERE  RequestNo       = '#form.Requestno#'						
</cfquery>

<cfquery name="mission"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Mission 
	WHERE  Mission    = '#get.Mission#'						
</cfquery>

<cfquery name="warehouse"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Warehouse
	WHERE  Warehouse   = '#get.Warehouse#'						
</cfquery>

<cfquery name="customer"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Customer
	WHERE  CustomerId   = '#get.CustomerId#'						
</cfquery>

<cfset pheight = "700">
<cfset pconten = "500">
<cfset pdiscla = "200">


<table align="center" style="width:100%;height:100%">

   <tr><td valign="top" style="height:#pheight#px;font-size:35px;">
   
	   <table style="width:100%">
	   
	   <!--- top banner --->
	   <tr class="labelmedium2">
	   <td colspan="3" style="height:40px;font-size:40px">#get.Mission# #mQuotation#</td>
	   </tr>
	    <tr class="labelmedium2">
	   <td colspan="2" style="height:40px;font-size:18px"><cf_tl id="Our Reference">:&nbsp;#get.RequestNo#</td>
	   <td colspan="1" align="right" style="height:40px;font-size:18px"><cf_tl id="Date">:&nbsp;#dateformat(get.Created,client.dateformatshow)#</td>
	   </tr>
	   
	   <tr><td style="height:5px"></td></tr>
	   
	   <!--- top boxes --->
	   <tr class="labelmedium2">
	   
	   <td style="border:0px solid silver;padding:5px;width:48%;height:100px;background-color:##BFECFB">
	   	   
	        <table class="formspacing">
			    <tr class="labelmedium"><td style="background-color:##BFECFE;height:21px;padding-left:5px">#Mission.MissionName#</td></tr>
				<tr class="labelmedium"><td style="background-color:##BFECFE;height:21px;padding-left:5px">#Warehouse.WarehouseName#</td></tr>
				<tr class="labelmedium"><td style="background-color:##BFECFE;height:21px;padding-left:5px">#Warehouse.Address#</td></tr>
				<tr class="labelmedium"><td style="background-color:##BFECFE;height:21px;padding-left:5px">#Warehouse.Contact# #Warehouse.EMailAddress#</td></tr>
			</table>
	   </td>
	   <td style="width:4%"></td>
	   <td style="border:0px solid silver;padding:5px;width:48%;height:100px;background-color:##e1e1e1">   
	        <table>
			    <tr class="labelmedium"><td style="height:25px;padding-left:5px"><cfif customer.customername neq "">#Customer.CustomerName#<cfelse><cf_tl id="On request"></cfif></td></tr>
				<tr class="labelmedium"><td style="height:25px;padding-left:5px">#Customer.PostalCode#</td></tr>
				<tr class="labelmedium"><td style="height:25px;padding-left:5px">#Customer.MobileNumber#</td></tr>
				<tr class="labelmedium"><td style="height:25px;padding-left:5px">#get.CustomerMail#</td></tr>
			</table>
		  </td>
	   </tr>
	   
	   <tr><td style="height:20px"></td></tr>
	   
	   <!--- body --->
	   <tr class="labelmedium2">
	   <td colspan="3" valign="top" style="border-bottom:0px solid silver;height:#pconten#px;font-size:20px;background-color:##fafafa">
	      
		   <table style="width:100%">
		     			 
		     <tr class="line labelit" style="background-color:##eaeaea">
			        <td style="height:30px;padding-left:4px"><cf_tl id="No"></td>
				    <td style="padding-left:4px"><cf_tl id="Item"></td>
					<td style="width:200px"><cf_tl id="Description"></td>
					<td><cf_tl id="UoM"></td>
					<td style="text-align:right;padding-right:4px"><cf_tl id="Price"></td>
					<td style="text-align:right;padding-right:4px"><cf_tl id="Qty"></td>
					<td style="text-align:right;padding-right:4px"><cf_tl id="Amount"></td>
		     </tr>			  
			 
				 <cfquery name="Lines"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM   CustomerRequestLine L INNER JOIN Item I ON I.ItemNo = L.ItemNo
					WHERE  RequestNo       = '#form.Requestno#'						
				</cfquery>
			 
			 <cfloop query="Lines">
			 
			  <tr class="line labelit">
			        <td style="height:30px;padding-left:4px">#currentrow#</td>
				    <td style="padding-left:4px">#ItemNoExternal#</td>
					<td style="width:200px">#ItemDescription#</td>
					<td>#TransactionUoM#</td>
					<td style="text-align:right;padding-right:4px">#numberformat(SalesUnitPrice,',.__')#</td>
					<td style="text-align:right;padding-right:4px">#numberformat(TransactionQuantity,',.__')#</td>
					<td style="text-align:right;padding-right:4px">#numberformat(SalesAmount,',.__')#</td>
		     </tr>			 
			 
			 </cfloop> 		
			 
			 <cfif get.Remarks neq "">
			 
			 <tr class="labelmedium2"><td colspan="7" style="padding-top:6px" align="center">#get.Remarks#</td></tr>
			 </cfif>	  
				  
		   </table>
		      
	   </td>   
	   </tr> 
	   
	   <!--- bottom boxes --->
	   	   
	   <tr>
		   <td style="padding-top:10px">
		   
		      <table width="100%" class="formpadding" style="height:100px;background-color:##ffffaf;border:0px solid silver">
									 
					<tr><td style="height:4px"></td></tr>
									
					<tr class="labelmedium">
					    <td style="padding-left:10px" colspan="3"><cf_tl id="Officer"></td>
						<td id="qteamount" style="padding-left:4px;font-weight:bold;border:1px solid silver">#session.first# #session.last#</td>
						<td style="width:4px"></td>
					</tr>
					<tr class="labelmedium">
					    <td style="padding-left:10px" colspan="3"><cf_tl id="Date">/<cf_tl id="Time"></td>
						<td id="qtetax" style="padding-left:4px;font-weight:bold;border:1px solid silver">
						#dateformat(now(),"#client.dateformatshow#")# #timeformat(now(),"HH:MM")#"</td>
					</tr>
					<tr class="labelmedium">
					    <td style="padding-left:10px" colspan="3"><cf_tl id="Mail"></td>
						<td id="qtetotal" style="padding-left:4px;font-weight:bold;border:1px solid silver">#client.eMail#</td>
					</tr>
					
					<tr><td style="height:4px"></td></tr>
			   
			  </table>		   
		   
		   </td>
		   
		   <td></td>
		   
		   <td style="padding-top:10px">
		   
			   <table width="100%" class="formpadding" style="height:100px;background-color:##BFECFB; border:0px solid silver">
					   				   
					 <cfquery name="getTotal" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">			
								SELECT   sum(SalesAmount) as Amount,
								         sum(SalesTax)    as Tax,
										 sum(SalesTotal)  as Total				
								FROM     CustomerRequestLine
								WHERE    RequestNo       = '#form.RequestNo#'						
					</cfquery>
					
					<tr><td style="height:4px"></td></tr>
									
					<tr class="labelmedium">
					    <td align="right" style="padding-right:10px" colspan="3"><cf_tl id="Amount"></td>
						<td align="right" id="qteamount" style="font-size:18px;padding-right:4px;font-weight:xbold;border:1px solid silver">#numberformat(getTotal.Amount,',.__')#</td>
						<td style="width:4px"></td>
					</tr>
					<tr class="labelmedium">
					    <td align="right" style="padding-right:10px" colspan="3"><cf_tl id="Tax"></td>
						<td align="right" id="qtetax" style="font-size:18px;padding-right:4px;font-weight:xbold;border:1px solid silver">#numberformat(getTotal.Tax,',.__')#</td>
					</tr>
					<tr class="labelmedium">
					    <td align="right" style="padding-right:10px" colspan="3"><cf_tl id="Total"></td>
						<td align="right" id="qtetotal" style="font-size:18px;padding-right:4px;font-weight:xbold;border:1px solid silver">#numberformat(getTotal.Total,',.__')#</td>
					</tr>
					
					<tr><td style="height:4px"></td></tr>
			   
			   </table>
		   
		   </td>
	   
	   </tr>	   
	   
	   </table>
   
   </td></tr>
   
   <cfquery name="Text"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   WarehouseJournal
		WHERE  Warehouse   = '#get.Warehouse#'		
		AND    Area        = 'Sale'
		AND    Currency    = '#Lines.SalesCurrency#'				
	</cfquery>
	   
   <cfsavecontent variable="disclaimertext">
	<table>
	<tr><td style="font-size:13px">#Text.Transactionmemo#</td></tr>	
	</table>
   </cfsavecontent>
   
   <!--- footer --->
           
   <tr class="labelmedium"><td align="center" valign="middle" style="padding-top:8px;border-top:1px solid silver;height:#pdiscla#px;font-size:13px">#disclaimertext#</td></tr>

</table>

</cfoutput>

</cfprocessingdirective>

