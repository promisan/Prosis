
<cfprocessingdirective suppresswhitespace="Yes" pageencoding="utf-8">

<cf_tl id="Quotation" var="mQuotation">

<cf_screentop html="No">

 <cfquery name="get"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   CustomerRequest 
	WHERE  RequestNo       = '#url.id1#'						
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

<cfquery name="Parameter"
datasource="AppsInit" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Parameter
	WHERE HostName = '#CGI.HTTP_HOST#'					
</cfquery>

<cfquery name="customer"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Customer
	WHERE  CustomerId   = '#get.CustomerId#'						
</cfquery>

<cfparam name="Form.Image" default="Yes">

<cfset pheight = "700">
<cfset pconten = "650">
<cfset pdiscla = "200">

<cfoutput>

<table style="width:96%;height:100%">

   <tr><td valign="top" style="height:#pheight#px;font-size:35px;">
   
	   <table style="width:100%">
	   
	   <cfimage name="vLogo" action="read" source="#parameter.LogoPath#\#parameter.LogoFileName#"/>
	   <cfset vLogo = "<img src='data:image/*;base64,#toBase64(vLogo)#' style='width:160px;height=120px'>">
	   
	   <tr class="labelmedium2">
		   <td colspan="1" style="height:40px;font-size:10px">#vLogo#</td>
		   <td colspan="2" align="right" style="height:40px;font-size:24px"><b><font size="4">#get.Mission#</font></b><br>#mQuotation#</td>
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
				    <tr class="labelmedium"><td style="font-size:15px;background-color:##BFECFE;height:21px;padding-left:5px">#Mission.MissionName#</td></tr>
					<tr class="labelmedium"><td style="font-size:15px;background-color:##BFECFE;height:21px;padding-left:5px">#Warehouse.WarehouseName#</td></tr>
					<tr class="labelmedium"><td style="font-size:15px;background-color:##BFECFE;height:21px;padding-left:5px">#Warehouse.Address#</td></tr>
					<tr class="labelmedium"><td style="font-size:15px;background-color:##BFECFE;height:21px;padding-left:5px">#Warehouse.Contact# #Warehouse.EMailAddress#</td></tr>
				</table>
		   </td>
		   <td style="width:4%"></td>
		   <td style="border:0px solid silver;padding:5px;width:48%;height:100px;background-color:##e1e1e1">   
		        <table>
				    <tr class="labelmedium"><td style="font-size:15px;height:25px;padding-left:5px"><cfif customer.customername neq "">#Customer.CustomerName#<cfelse><cf_tl id="On request"></cfif></td></tr>
					<tr class="labelmedium"><td style="font-size:15px;height:25px;padding-left:5px">#Customer.PostalCode#</td></tr>
					<tr class="labelmedium"><td style="font-size:15px;height:25px;padding-left:5px">#Customer.MobileNumber#</td></tr>
					<tr class="labelmedium"><td style="font-size:15px;height:25px;padding-left:5px">#get.CustomerMail#</td></tr>
				</table>
		   </td>
	   
	   </tr>
	   
	   <tr><td style="height:20px"></td></tr>
	   
	   <!--- body --->
	   <tr class="labelmedium2">
	   <td colspan="3" valign="top" style="border-bottom:0px solid silver;height:#pconten#px;font-size:20px;background-color:##fafafa">
	      
		   <table style="width:100%">
		     			 
		     <tr class="line labelit" style="font-size:13px;background-color:##eaeaea">
			        <td style="height:30px;padding-left:4px"><cf_tl id="No"></td>
				    <td style="padding-left:4px"><cf_tl id="Item"></td>
					<td style="width:200px"><cf_tl id="Description"></td>
					<cfif form.image eq "Yes">	
					<td><cf_tl id="Photo"></td>
					</cfif>		
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
					FROM   CustomerRequestLine L 
					       INNER JOIN Item I ON I.ItemNo = L.ItemNo
					WHERE  RequestNo = '#url.id1#'						
			 </cfquery>				
			 
			 <cfloop query="Lines">
			 
				  <cfif scheduleprice neq salesprice>
					  <cfset span = "2">
				  <cfelse>
					  <cfset span = "1">
				  </cfif>	 
			 
				  <tr class="line labelit">
				  
				        <td rowspan="#span#" style="height:30px;padding-left:4px">#currentrow#</td>
					    <td rowspan="#span#" style="padding-left:4px">#ItemNoExternal#</td>
						<td rowspan="#span#" style="width:200px">#ItemDescription#</td>
						
						<cfif form.image eq "Yes">	
						
						      <cfquery name="image" 
								datasource="appsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">	
							  	  SELECT TOP 1 ImagePath 
								  FROM   Materials.dbo.ItemImage 
								  WHERE  ItemNo = '#ItemNo#'	
							 </cfquery> 
							 
							 <td rowspan="#span#">
							 <cfif image.recordcount gte "1">
							 
							 <cftry>
					 
							 <cfimage name="vImg" action="read" source="#session.rootDocument#/#image.ImagePath#"/>
	         	    		 <cfset vImg  = "<img src='data:image/*;base64,#toBase64(vImg)#' style='border:1px solid silver;width:60px;height=40px'>">
							 #vImg#						 						 
							 <cfcatch></cfcatch>
							 </cftry>
							 
							 </cfif>
							 </td>							 
						
						</cfif>			
						
						<td>#TransactionUoM#</td>
						<td style="text-align:right;padding-right:4px">#numberformat(TransactionQuantity,',.__')#</td>
						
						<cfif scheduleprice eq salesprice>	
										
							<td style="text-align:right;padding-right:4px">#numberformat(SalesUnitPrice,',.__')#</td>				
							<td style="text-align:right;padding-right:4px">#numberformat(SalesAmount,',.__')#</td>
							
						<cfelse>		
						
							<!--- pending to adjust  if the price does not include tax --->			
							<cfset sprice =  SchedulePrice * (1 / 1 - taxpercentage) > 
							
							<td style="height:33px;text-decoration: line-through;text-align:right;padding-right:4px">#numberformat(sprice,',.__')#</td>														
							<td style="height:33px;text-decoration: line-through;text-align:right;padding-right:4px">#numberformat(sprice*transactionQuantity,',.__')#</td>
						
						</cfif>
						
			     </tr>		
			 
				 <cfif scheduleprice neq salesprice>
					<tr class="labelit" style="border-bottom:1px solid gray;font-size:14px;">							
						<td colspan="3" align="right" style="background-color:##D02032;color:white;width:100px;padding-right:4px;padding-top:2px"><cf_tl id="Your price"></td>									
						<td style="background-color:##BFECFE;color:white;text-align:right;padding-right:4px;padding-top:2px">#numberformat(SalesUnitPrice,',.__')#</td>			
						<td style="background-color:##BFECFE;color:white;text-align:right;padding-right:4px;padding-top:2px">#numberformat(SalesAmount,',.__')#</td>				
					</tr>	
				</cfif>				 
							 
			 </cfloop> 		
			 
			 <cfif get.Remarks neq "">
			 
			 <tr class="labelmedium2"><td colspan="8" style="padding-top:6px" align="center">#get.Remarks#</td></tr>
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
								WHERE    RequestNo       = '#url.id1#'						
					</cfquery>
					
					<tr><td style="height:4px"></td></tr>
									
					<tr class="labelmedium">
					    <td align="right" style="padding-right:10px" colspan="3"><cf_tl id="Amount"></td>
						<td align="right" id="qteamount" style="font-size:18px;padding-right:4px;font-weight:xbold;border:1px solid silver">#numberformat(getTotal.Amount,',.__')#</td>
						<td style="width:4px"></td>
					</tr>
					<tr class="labelmedium">
					    <td align="right" style="padding-right:10px" colspan="3"><cf_tl id="Tax"></td>
						<td align="right" id="qtetax"   style="font-size:18px;padding-right:4px;font-weight:xbold;border:1px solid silver">#numberformat(getTotal.Tax,',.__')#</td>
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
   
   </td>
   </tr>
   
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
	<table><tr><td style="font-size:13px">#Text.Transactionmemo#</td></tr></table>
   </cfsavecontent>
   
   <!--- footer --->
           
   <tr class="labelmedium">
       <td align  = "center" 
	       valign = "middle" 
           style  = "padding-top:8px;border-top:1px solid silver;height:#pdiscla#px;font-size:13px">#EncodeForHTML(disclaimertext)#</td>
   </tr>

</table>

</cfoutput>

</cfprocessingdirective>

