
<cfajaximport tags="cfform,cfdiv,cfwindow">

<cfset cnt = 0>
<cfset documententrystatus = "1">

<cf_dialogOrganization>
<cf_dialogAsset>
<cf_DialogProcurement>
<cf_DialogMaterial>
<cf_dialogLedger>
<cf_dialogREMProgram>
<!--- traveller --->
<cf_dialogStaffing>
<cf_dialogLookup>


<cf_ActionListingScript>
<cf_FileLibraryScript>
<cf_LayoutScript>

<cf_PresentationScript>
<cf_CalendarScript>

<cf_textareascript>	

<cftry>
		
	<cfquery name="Invoice" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Invoice
		WHERE  InvoiceId = '#URL.ID#'
	</cfquery>
	
	<cfquery name="InvoiceIncoming" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   InvoiceIncoming
		WHERE  Mission = '#Invoice.Mission#'
		AND    OrgUnitOwner  = '#Invoice.OrgUnitOwner#'
		AND    OrgUnitVendor = '#Invoice.OrgUnitVendor#'
		AND    InvoiceNo     = '#Invoice.InvoiceNo#'
	</cfquery>
	
	<cfcatch>

	<cf_message message="Invoice Record no longer exist" return="no">
	<cfabort>
	
	</cfcatch>

</cftry>

<cfif Invoice.recordcount eq "0">
	<cf_message 
		  message = "Invoice was removed from database. Operation not aborted."
		  return = "no">
	 <cfabort>
</cfif>		


<cf_screentop height="100%" 
	    layout="webapp" 
		banner="green" 
		band="no" 	
		scroll="No" 
		jQuery="Yes"
		SystemModule="Procurement"
		FunctionClass="Window"
		FunctionName="Invoice Matching"
		menuaccess="context"
		html="No" 
		label="i:#InvoiceIncoming.InvoiceReference#">	
					
	
<cfif Invoice.ActionStatus eq "1">		
		
	<cfquery name="ResetMissing" 
	    datasource="AppsPurchase" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    UPDATE Invoice
		SET    ActionStatus = '0'
		WHERE  InvoiceId = '#URL.ID#'
		AND    InvoiceId NOT IN (SELECT ReferenceId 
		                         FROM   Accounting.dbo.TransactionHeader
								 WHERE  ReferenceId is not NULL)		
								 
	</cfquery>		

<cfelseif Invoice.ActionStatus is "9">

	<cfquery name="ResetWorkflow" 
	    datasource="AppsPurchase" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    UPDATE Organization.dbo.OrganizationObject
		SET    Operational = 0			
		WHERE  ObjectKeyValue4 = '#URL.ID#'
	</cfquery>

</cfif>

	<cfquery name="DeleteRecord" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		 DELETE FROM InvoiceFunding
		 WHERE  InvoiceId = '#URL.ID#' 		
	</cfquery>
	
	<cfquery name="FundedRecord" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		   INSERT INTO InvoiceFunding
		            (InvoiceId,Fund,ProgramPeriod,ProgramCode,ActivityId,ObjectCode,Amount)		
					 
			SELECT  InvoiceId,
			        Fund,
					Period,
					ProgramCode,
					ActivityId,
					ObjectCode, 
					SUM(Amount) as Amount
			
			FROM   (						 
					 	 
					SELECT     I.InvoiceId, 
					           F.Fund, 
							   F.Period, 
							   F.ProgramCode, 
							   F.ActivityId, 
							   F.ObjectCode, ROUND(F.Amount /
		                          (SELECT    SUM(Amount) 
		                           FROM      PurchaseFunding
									<!---  20/4/2016 ---  WHERE      (PurchaseNo = IP.PurchaseNo)), 2) * I.DocumentAmount AS Amount --->
								   WHERE     (PurchaseNo = IP.PurchaseNo)) * IP.AmountMatched, 2) AS Amount
					FROM      Invoice AS I INNER JOIN
				              InvoicePurchase AS IP ON I.InvoiceId = IP.InvoiceId INNER JOIN
		        		      PurchaseFunding AS F ON IP.PurchaseNo = F.PurchaseNo
					WHERE     I.InvoiceId = '#url.id#'
					
					GROUP BY  IP.PurchaseNo,
					          I.InvoiceId, 
							  F.Fund, 
							  F.Period, 
							  F.ProgramCode, 
							  F.ActivityId,
							  F.ObjectCode, 
							  F.Amount, 
							  IP.AmountMatched 
							  
					) as sub
					
			GROUP BY InvoiceId,Fund,Period,ProgramCode,ActivityId,ObjectCode
						  
	</cfquery>
			
<cfquery name="Parameter1" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#Invoice.Mission#' 
</cfquery>

<!--- posted or not --->

<cf_verifyOperational module = "Accounting" Warning   = "No">

<cfif operational eq "1">

	<cfquery name="Check" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   TransactionHeader
		WHERE  ReferenceId = '#Invoice.InvoiceId#'
	</cfquery>
	
<cfelse>

	<cfset check.recordcount = "0">	

</cfif>

<cfquery name="Action" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   P.*,R.InvoiceWorkflow, R.ReceiptEntry
	FROM     InvoicePurchase IP INNER JOIN
	         Purchase P ON IP.PurchaseNo = P.PurchaseNo INNER JOIN
	         Ref_OrderType R ON P.OrderType = R.Code
	WHERE    InvoiceId = '#URL.ID#' 
	</cfquery>
		
<cfinvoke component="Service.Access"  
  method="ProcApprover" 
  orgunit="#Invoice.OrgUnitOwner#"  
  returnvariable="accessreq">	
 
 <cfif Parameter1.InvoiceTemplate neq "">
    <cfset tmp = "#Parameter1.InvoiceTemplate#"> 
<cfelse>
	<cfset tmp = "Procurement/Inquiry/Print/Invoice/Routing.cfr">  
</cfif> 
  
<cfoutput>  

	<script>
	
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
	function ask(status) {
	  
		if (confirm("Do you want to "+status+" this invoice ?"))	{
		    Prosis.busy('yes')
			return true 
		} 
		return false
		}	
	
	function closeout() {	
		try {
		if (window.opener){
			window.opener.history.go()
			} } catch(e) {}
		window.close()	
	}
	
	function printout(mode,id) {
		  ptoken.open("<cfoutput>#SESSION.root#</cfoutput>/Tools/Mail/MailPrepareOpen.cfm?id="+mode+"&ID1="+id+"&ID0=<cfoutput>#tmp#</cfoutput>","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	}	
	
	function hl(itm,fld) {
	     
	     if (ie){
	          while (itm.tagName!="TR")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TR")
	          {itm=itm.parentNode;}
	     }	 	 	 		 	
		 if (fld != false){		
			 itm.className = "highLight1 line labelmedium";
		 } else {
			itm.className = "regular line labelmedium";		
		 }			
		 total()		  	 
	  } 
	      
	function total(act) {				
		_cf_loadingtexthtml='';	
		ptoken.navigate('InvoiceMatchStatus.cfm?action='+act+'&ID=#URL.ID#','match','','','POST','invoice')			
	}	
	
	var ptday  = new Array();
	var ptdisc  = new Array();
	var ptdisd  = new Array();
	
	<cfquery name="Terms" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM Ref_Terms 
	</cfquery>
	
	<cfloop query="Terms">
	   ptday[#Code#]   = "#PaymentDays#";
	   ptdisc[#Code#]  = "#Discount#";
	   ptdisd[#Code#]  = "#DiscountDays#";
	</cfloop>
	
	function terms(selected) {
	     invoice.actiondiscount.value      = ptdisc[selected];
		 invoice.actiondiscountdays.value  = ptdisd[selected];
		 invoice.actiondays.value          = ptday[selected]; 
	}
	
	function more(invid) {
			
		icM  = document.getElementById('icomments');
		box  = document.getElementById('bcomments');
		vExp = document.getElementById('vExp');
		vMin = document.getElementById('vMin');	
	
		if (box.className=="hide") {
		 
	     	 icM.className  = "regular";
			 vExp.className = "hide";
			 vMin.className = "regular";
			 box.className  = "regular"		
			 ptoken.navigate('#SESSION.root#/Procurement/Application/Invoice/Workflow/MarkDown/DocumentMemo.cfm?header=1&invoiceId='+invid,'icomments')		
		 } else {
		   	 icM.className = "hide";
			 vExp.className = "regular";
			 vMin.className="hide";		
			 box.className  = "hide" 
		 }					 		 
	  }
	
	function moreattachments(invid,vrow,vmission) {
			
		icM  = document.getElementById('iattachments_'+vrow);	
		vExp = document.getElementById('vExp_'+vrow);
		vMin = document.getElementById('vMin_'+vrow);	
		box =  document.getElementById('mattachments_'+vrow);	
	
		if (box.className == "hide") {
		 
	     	 icM.className = "regular";
			 vExp.className = "hide";
			 vMin.className= "regular";
			 box.className = "regular"		
			 ptoken.navigate('#SESSION.root#/Procurement/Application/Invoice/InvoiceEntry/InvoiceEntryAttachment.cfm?Mission='+vmission+'&Id='+invid,'iattachments_'+vrow)		
		 } else {
		   	 icM.className   = "hide";
			 vExp.className  = "regular";
			 vMin.className  = "hide";		
			 box.className   = "hide" 
		 }					 		 
	  }
	  
	function saveMemo(vinv,vmemo) {
		text=document.getElementById('InvoiceMemo');
		vtext=text.value;	
		ptoken.navigate('#SESSION.root#/Procurement/Application/Invoice/Workflow/MarkDown/DocumentMemo.cfm?InvoiceId='+vinv+'&memoid='+vmemo+'&InvoiceMemo='+vtext,'icomments');
		
	}
	
	function DeleteMemo(vinv,vmemo){   
		ptoken.navigate('#SESSION.root#/Procurement/Application/Invoice/Workflow/MarkDown/DocumentMemo.cfm?InvoiceId='+vinv+'&memoid='+vmemo+'&Action=delete','icomments');   
	}
	
	function EditMemo(vinv,vmemo) {   
		ptoken.navigate('#SESSION.root#/Procurement/Application/Invoice/Workflow/MarkDown/DocumentMemo.cfm?InvoiceId='+vinv+'&memoid='+vmemo+'&Action=edit','icomments');
	}			
		 	
	</script>	

</cfoutput>  

<cfparam name="URL.HTML" default="Yes">
		 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">

    <cfif url.html eq "Yes">
		
	<cf_layoutarea 
	   	position  = "header"
	   	name      = "reqtop"
	   	minsize	  = "50px"
		maxsize	  = "50px"
		size 	  = "50px">	
		
			<cf_ViewTopMenu label="Invoice Matching and Processing" menuaccess="context" background="blue" systemModule="Procurement">
						 			  
	</cf_layoutarea>		
	
	</cfif>
	
	<cf_layoutarea position="center" name="box" overflow="scroll">
				
		<cf_divscroll style="height:99%">		
			<cfinclude template="InvoiceMatchEdit.cfm">
		</cf_divscroll>			
					
	</cf_layoutarea>		
	
	<cf_wfactive objectKeyValue4="#url.id#">
	
	<cfif wfexist eq "1">
	  
	<cf_layoutarea 
	    position    = "left" 
		name        = "commentbox" 
		maxsize     = "500" 		
		size        = "25%" 		
		minsize     = "360"
		initcollapsed = "true"
		collapsible = "true" 
		splitter    = "true"
		overflow    = "scroll">
					
		<cf_divscroll style="height:99%">
			<cf_commentlisting objectid="#url.id#"  ajax="No">		
		</cf_divscroll>
							
	</cf_layoutarea>	
	
	</cfif>
		
</cf_layout>	