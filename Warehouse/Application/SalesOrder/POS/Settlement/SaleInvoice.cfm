<cfparam name="url.batchid"           default="">
<cfparam name="url.warehouse"         default="">
<cfparam name="url.currency"          default="">
<cfparam name="url.scope"          	  default="settlement">

<cf_tl id="Print Invoice" var="1">

<script>
	
	function saveenter() {
	
		if (window.event) {   
			  keynum = window.event.keyCode;	  
		   } else {   
			  keynum = window.event.which;	  
		   }			   
		   if (keynum == 13) {
		     document.getElementById("save").click()	   
		   }		   
	   }

</script>

<cfif url.scope neq "workflow" and url.scope neq "standalone">
	<cf_screentop height="100%" html="no" scroll="No" layout="webapp" label="#lt_text#" user="no" banner="gray">
</cfif>		

<cfoutput>

<!--- ---------------- --->
<!--- GET THE TEMPLATE --->
<!--- ---------------- --->
		
<cfquery name="getWarehouseJournal"
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	SELECT  *
		FROM    WarehouseJournal
		WHERE   Warehouse = '#url.warehouse#'
		AND		Area      = 'SETTLE'
		AND		Currency  = '#url.currency#'
</cfquery>


<table width="100%" height="100%">

<cfquery name="getAction"
      datasource="AppsLedger"
      username="#SESSION.login#"
      password="#SESSION.dbpw#">
            SELECT * 
			FROM   TransactionHeaderAction WHERE ActionId = '#url.actionid#'			          
</cfquery>  	

<cfif getAction.ActionMode eq "2">

	<!--- all relevant data in in TransactionHeaderAction --->

	<tr><td></td></tr>
	
	<tr><td height="100%" style="padding:15px;">	
	  	
		<cfif getWarehouseJournal.recordCount eq 1 and trim(getWarehouseJournal.TransactionTemplateMode2) neq "">
			<iframe src="#SESSION.root#/#getWarehouseJournal.TransactionTemplateMode2#?actionid=#url.actionid#&batchid=#url.batchid#&terminal=#url.terminal#&layout=pos" 
			  name="print" id="print" width="100%" height="100%" scrolling="yes" frameborder="0" style="border:1px dashed silver"></iframe>
		<cfelse>
			<table width="100%">
				<tr>
					<td class="labellarge" align="center" style="color:red;"><cf_tl id="The invoice printout is not properly configured !"></td>
				</tr>
			</table>
		</cfif>
			
	</td></tr>
	
	<tr><td height="60" align="center" style="padding-left:15px; padding-right:15px">
		
		<table width="100%" class="formspacing">
		
		<tr>
		
			<td class="hide" id="process"></td>
				  					
			<td align="center" id="printbox">
			
				<cf_tl id="Print" var="1">
				
				 <input type="button" 
				      class="button10g" 
				      onclick="alert('print again')" 
				      style="border:1px solid silver;height:28;width:150;font-size:13px" 					  
					  name="save" 
					  id="save"
					  value="#lt_text#">
					  
		    </td>			
					
			<cfquery name="Header" 
				   datasource="AppsMaterials" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					SELECT   WB.Mission, 
					         W.Warehouse, 
							 W.WarehouseName, 
							 W.City, 
							 W.Address, 
							 W.Telephone, 
							 M.MissionName, 
							 WB.BatchNo, 
							 C.eMailAddress, 
							 C.CustomerName, 
							 CustomerIdInvoice,
							 WB.TransactionDate, 
			                 C.Reference
				    FROM     WarehouseBatch WB INNER JOIN
			                 Warehouse W ON WB.BatchWarehouse = W.Warehouse INNER JOIN
			                 Organization.dbo.Ref_Mission M ON WB.Mission = M.Mission INNER JOIN
			                 Customer C ON WB.CustomerIdInvoice = C.CustomerId
					WHERE    WB.BatchId = '#url.batchId#'       
			</cfquery>
		
		    <!---
		    <td class="labelmedium" style="padding-top:5px;padding-left:10px;padding-right:4px"><i><cf_tl id="EMail">:</td>  
			--->

			<td style="width:95%;padding-left:2px" align="center">
						
				<input type      = "text" 
						id       = "eMailAddress" 
					    value    = "#Header.eMailAddress#"
						class    = "regularxl" 
						style    = "width:99%;height:28px;font-size:15px;text-align:center" 
						onChange = "ptoken.navigate('#session.root#/Warehouse/Application/SalesOrder/POS/Settlement/setEMailAddress.cfm?email='+this.value+'&customeridInvoice=#Header.CustomerIdInvoice#&batchid=#url.batchid#','mailbox')">
				
			</td> 					
			
			<td style="padding-left:4px;min-width:140px" align="center" id="mailbox">
				
				<cfif isValid("email","#Header.eMailAddress#")>		
					
					<cf_tl id="eMail" var="1">
						
					 <input type="button" 
					      class="button10g" 
					      onclick="ptoken.navigate('#session.root#/Warehouse/Application/SalesOrder/POS/Settlement/doInvoiceMail.cfm?batchid=#url.batchid#','mailbox')" 
					      style="border:1px solid silver;height:28;width:120;font-size:13px" 						 
						  name="save" id="save" 
						  value="#lt_text#">
						  
				</cfif>
						  
		    </td>
										  					
			<td align="right" style="padding-right:4px">
			
				<cf_tl id="Close" var="1">
				
				 <input type  = "button" 
				      class   = "button10g" 
				      onclick = "ProsisUI.closeWindow('wsettle',true)" 
				      style   = "height:28;width:120;font-size:13px;border:1px solid silver;" 					  
					  name    = "save" id="save"
					  value   = "#lt_text#">
		    </td>
						
		</tr>
		
		</table>
	
	</td></tr>

<cfelse>

	<!--- MODE = 1 manual mode so we obtain additional information on the invoiceNo --->
	<tr><td></td></tr>
	
	<tr><td height="100%" style="padding:15px;">
		<cfif session.acc eq "administrator">
		
		 <!---
		 <cfoutput>
		 	#SESSION.root#/#getWarehouseJournal.TransactionTemplateMode1#?batchid=#url.batchid#&terminal=#url.terminal#
		 </cfoutput>	 	
		 --->
		 
		</cfif> 
		 
		<cfif getWarehouseJournal.recordCount eq 1 and trim(getWarehouseJournal.TransactionTemplateMode1) neq "">
			<iframe src="#SESSION.root#/#getWarehouseJournal.TransactionTemplateMode1#?batchid=#url.batchid#&terminal=#url.terminal#" 
			  name="print" id="print" width="100%" height="100%" scrolling="yes" frameborder="0" style="border:1px dashed silver"></iframe>
		<cfelse>
			<table width="100%">
				<tr>
					<td class="labellarge" align="center" style="color:red;"><cf_tl id="The invoice printout is not properly configured !"></td>
				</tr>
			</table>
		</cfif>
			
	</td></tr>
	
	<tr><td height="60" bgcolor="f4f4f4" align="center">
			
		<table class="formspacing">		
		<tr>
				
		<cfquery name="Header" 
				   datasource="AppsMaterials" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					SELECT   WB.Mission, 
					         W.Warehouse, 
							 W.WarehouseName, 
							 W.City, 
							 W.Address, 
							 W.Telephone, 
							 M.MissionName, 
							 WB.BatchNo, 
							 C.eMailAddress, 
							 C.CustomerName, 
							 CustomerIdInvoice,
							 WB.TransactionDate, 
			                 C.Reference
				    FROM     WarehouseBatch WB INNER JOIN
			                 Warehouse W ON WB.BatchWarehouse = W.Warehouse INNER JOIN
			                 Organization.dbo.Ref_Mission M ON WB.Mission = M.Mission INNER JOIN
			                 Customer C ON WB.CustomerIdInvoice = C.CustomerId
					WHERE    WB.BatchId = '#url.batchId#'       
			</cfquery>
		
		    <!---
		    <td class="labelmedium" style="padding-top:5px;padding-left:10px;padding-right:4px"><i><cf_tl id="EMail">:</td>  
			--->
			  			  
			<td style="padding-left:10px">
						
				<input type      = "text" 
						id       = "eMailAddress" 
					    value    = "#Header.eMailAddress#"
						class    = "regularxl" 
						style    = "width:296px;height:28px;font-size:15px;text-align:center" 
						onChange = "ptoken.navigate('#session.root#/Warehouse/Application/SalesOrder/POS/Settlement/setEMailAddress.cfm?email='+this.value+'&customeridInvoice=#Header.CustomerIdInvoice#&batchid=#url.batchid#','mailbox')">
				
			</td> 					
			
			<td id="mailbox" style="padding-left:2px">
				
				<cfif isValid("email","#Header.eMailAddress#")>		
					
					<cf_tl id="eMail" var="1">
						
					 <input type="button" 
					      class="button10g" 
					      onclick="ptoken.navigate('#session.root#/Warehouse/Application/SalesOrder/POS/Settlement/doInvoiceMail.cfm?batchid=#url.batchid#','mailbox')" 
					      style="height:28;width:130;font-size:13px" 						 
						  name="save" id="save" 
						  value="#lt_text#">
						  
				</cfif>
						  
		    </td>		
		
			<td style="padding-left:9px" class="labelmedium"><cf_space spaces="40"><cf_tl id="Assigned Invoice No">:</td>  
			  
			<td style="padding-left:2px"><input type="text" id="batchreference" class="regular" style="border-radius:4px;width:140;height:28px;font:21px" onKeyUp="saveenter()"></td>	
			
			<td style="padding-right:10px">
				<cf_tl id="Save and close" var="1">
				
				 <input type="button" 
				      class="button10g" 
				      onclick="ptoken.navigate('#SESSION.root#/warehouse/application/SalesOrder/POS/Settlement/SaleInvoiceSave.cfm?actionid=#url.actionid#&batchid=#batchid#&batchreference='+document.getElementById('batchreference').value,'process')" 
				      style="height:28;width:130" 					 
					  name="save" id="save"
					  value="#lt_text#">
		    </td>
			
			<td class="hide" id="process"></td>
			
		</tr>		
		</table>
	
	</td></tr>
	
</cfif>	

</table>

</cfoutput>