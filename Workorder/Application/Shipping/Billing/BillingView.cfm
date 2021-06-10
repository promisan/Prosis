
<cfif url.id eq "STA">
	<cf_tl id="Billing of confirmed shipments" var="1">
<cfelse>
    <cf_tl id="Issue Credit Note" var="1"> 
</cfif>	

<cf_screentop scroll="No" layout="webapp" jQuery="Yes" html="No" banner="green" label="#lt_text#">

<cf_listingscript>

<cfajaximport tags="cfform,cfwindow">
<cf_dialogMaterial>
<cf_dialogOrganization>
<cf_dialogWorkOrder>
<cf_dialogLedger>
<cf_PresentationScript>

<cfquery name="workorder" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
  	SELECT * 
	FROM WorkOrder W, Customer C 
	WHERE WorkorderId = '#url.workorderid#'
	AND  W.Customerid = C.CustomerId
</cfquery>  

<!---

Show information by batch (warehouse) and allow to select the items that were confirmed already, each line will become a line in 

TransactionLine and the sum will be booked in TransactionHeader as a receivable.

Journal from WarehouseJournal.Sales.

(If there are different warehouses and they have different journals we do not allow to mix transactions, if the journal is the same we can mix)

<br>

Receivable from the journal
a/ Income  : GL account : WorkOrderGLedger.Sale

<br>

<!--- show for a workorder any shipments that were not be invoiced yet 

ItemTransactionShipping for a workorder that has InvoiceId = NULL

Allow to select one or more receipt.
Create receivable and associate the invoiceId to the ItemtransactionShipping line 
														 
Maybe goo to show in 3 sections

1. Already billed
2. Ready for billing which check box
3. Under clearance.															 

Submit will generate the payable and bring up the screen as i did for POS mode as well.
	
--->

--->

<cfoutput>

<script language="JavaScript">

	function recordedit(id) {   
	     ProsisUI.createWindow('executetask', 'Edit Shipment', '',{x:100,y:100,height:580,width:560,closable:true,modal:true,center:true})	
		 ptoken.navigate('editShipment.cfm?transactionid='+id,'executetask')
	}
	
	
	function validate(id) {	
		document.shippingeditform.onsubmit() 
		if( _CF_error_messages.length == 0 ) {         
			ptoken.navigate('editShipmentSubmit.cfm?systemfunctionid=#url.systemfunctionid#&transactionid='+id,'executetask','','','POST','shippingeditform')
		 }   	 
	}	 

	function selectAllCB(c,selector) {
		if (c.checked) {
			$(selector).prop('checked', true);
		}else{
			$(selector).prop('checked', false);
		}
		_cf_loadingtexthtml='';
		ptoken.navigate('setTotal.cfm?workorderid=#url.workorderid#','sale','','','POST','billingform');
	}
	
	function applyWorkorder() {
	   
	   _cf_loadingtexthtml='';
	   Prosis.busy('yes')	   
	   // refresh workorder box
	   ptoken.navigate('BillingEntryWorkOrder.cfm?systemfunctionid=#url.systemfunctionid#','workorder','','','POST','billingform')	 	   
	   // refresh contentbox
	   ptoken.navigate('BillingEntryDetail.cfm?systemfunctionid=#url.systemfunctionid#','mycontent','','','POST','billingform')
		
	}
	
	function doTotal() {
		_cf_loadingtexthtml='';
		ptoken.navigate('setTotal.cfm?workorderid=#url.workorderid#','sale','','','POST','billingform')
	}

</script>

</cfoutput>

<cf_LayoutScript>

<cfform name="billingform" id="billingform" style="height:100%">
		 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
	   	position  = "header"
	   	name      = "billtop"
	   	minsize	  = "50px"
		maxsize	  = "50px"
		size 	  = "50px">	
		
		<cf_ViewTopMenu label="#lt_text# #url.mission#">
			 			  
	</cf_layoutarea>		
	  
	<cf_layoutarea 
	    position    = "right" 
		name        = "treebox" 
		maxsize     = "210" 		
		size        = "180" 
		minsize     = "180"
		initcollapsed="Yes"
		collapsible = "true" 
		splitter    = "true"
		overflow    = "scroll">
								
			<cfinclude template="BillingWorkorder.cfm">
							
	</cf_layoutarea>
	
	<cf_layoutarea position="center" name="box">
		
		<cf_divscroll>
			<cfinclude template="BillingEntry.cfm">
		</cf_divscroll>
					
	</cf_layoutarea>		
	
	<cf_layoutarea position="bottom" name="bottom" collapsible="false" size="200" minsize="200">
		<table width="100%" bgcolor="EfEfEf" height="100%">			
		<tr><td valign="top" style="border-top:1px solid silver;padding-top:3px">
			<cf_divscroll style="height:100%">
			<cfinclude template="BillingPosting.cfm">	
			</cf_divscroll>
		</td></tr>
		</table>	
		
	</cf_layoutarea>		
		
</cf_layout>

</cfform>

<cf_screenbottom html="No" layout="webapp">


