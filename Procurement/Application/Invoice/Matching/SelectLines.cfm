<cf_screentop height="100%" scroll="No" html="No">

<cf_dialogProcurement>

<script language="JavaScript">

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){
 
     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 	 	
					 	
	 if (fld != false){
		
	 itm.className = "highLight1";
		 
	 }else{
		
     itm.className = "regular";		
	
	 }
	 
	 check()
	
  }
  
  
function check() {

     se  = parent.document.getElementById('receipt');
	 se.value = "";	 
     sel = document.getElementsByName('selected');
	 count = 0;	 
	 while (sel[count]) {	 
		 if (sel[count].checked == true) {
			 se.value = se.value+","+sel[count].value
			 }
		count++	 
	 }
    }   

  
function selall(itm,fld) {
    
     sel = document.getElementsByName('selected')
	 count = 0
	 
	 while (sel[count]) {
	 	 	 	 		 	
	 if (fld != false){
		
	 sel[count].checked = true
	 itm = sel[count]
	 
	 if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 itm.className = "highLight1";
	 
	 
	 }else{
	 
	 sel[count].checked = false
	 
	 itm = sel[count]
	 
	 if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 itm.className = "regular";
	 
	 }
	 count++
	 }
	 
	 check()
	
  }
  
</script> 

<cfparam name="URL.OrgUnitVendor" default="2091">

<cfquery name="Lines" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     P.PurchaseNo AS PurchaseNo, 
           P.Mission AS Mission, 
		   P.Period AS Period, 
		   PR.*, 
		   Accounting.dbo.TransactionLine.ReferenceId AS Matched
FROM       PurchaseLineReceipt PR INNER JOIN
           PurchaseLine PL ON PR.RequisitionNo = PL.RequisitionNo AND PR.RequisitionNo = PL.RequisitionNo INNER JOIN
           Purchase P ON PL.PurchaseNo = P.PurchaseNo AND PL.PurchaseNo = P.PurchaseNo LEFT OUTER JOIN
           Accounting.dbo.TransactionLine ON PR.ReceiptId = Accounting.dbo.TransactionLine.ReferenceId
WHERE      P.OrgUnitVendor = '#URL.OrgUnitVendor#'
AND        PR.ActionStatus = '1'
ORDER By PurchaseNo
</cfquery>

<cfset cnt = 0>

<TITLE>Extended result</TITLE>
  
<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
   
<tr bgcolor="#DCDCB8">
    <td width="75" align="center" ><cf_tl id="ReceiptNo"></td> 
    <td align="center">Item</td> 
	<td align="center">No</td> 
	<td width="80" align="center">Quantity</td> 
	<td align="center">UoM</td> 
	<td width="30" align="center">Curr.</td> 
	<td width="100" align="center">Cost price</td> 
	<td width="100" align="center">Tax</td> 
	<td width="100" align="center">Total</td> 
	<td align="center" width="35"><input type="checkbox" name="selectall" id="selectall" value="" onClick="javascript:selall(this,this.checked)"></td>
</tr>
<cfset cnt = cnt + 25>

<cfoutput query="Lines" group="PurchaseNo">
	<tr>
	    <td colspan="10" align="left" bgcolor="CECEA2">&nbsp;<b><a href="javascript:ProcPOEdit('#Purchaseno#','view')">#PurchaseNo#</a></b></td> 
	</tr>
	<cfset cnt = cnt + 20>
<cfoutput>

    <cfif Matched eq "">
		<tr>
		    <td align="center"><a href="javascript:receipt('#ReceiptNo#','receipt')">#ReceiptNo#</a></td> 
			<td>#ReceiptItem#</td> 
			<td>#ReceiptItemNo#</td> 
			<td align="center">#ReceiptQuantity#</td> 
			<td align="center">#ReceiptUoM#</td> 
			<td align="center">#Currency#</td> 
			<td align="right">#numberformat(ReceiptAmountCost,",.__")#</td> 
			<td align="right">#numberformat(ReceiptAmountTax,",.__")#</td> 
			<td align="right">#numberformat(ReceiptAmount,",.__")#</td> 
			<td align="center">
			
			    <input type="checkbox" 
			      name="selected" 
				  id="selected"
				  value="'#ReceiptId#'" 
				  onClick="javascript:hl(this, this.checked)"></td>
		</tr>
		<cfset cnt = cnt + 25>
	</cfif>
</cfoutput>
</cfoutput>
 
</table>

<script language="JavaScript">
  
    {
  	frm  = parent.document.getElementById("line");
	he = <cfoutput>#cnt#</cfoutput>;
	frm.height = he
	}
		
</script>


