<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->

<cf_dialogProcurement>

<script>

function hl(itm,fld,reqno){

     ln1 = document.getElementById(reqno+"_1");
		 	 	 		 	
	 if (fld != false){
		 ln1.className = "highLight1";
	
	 }else{
	 ln1.className = "header";		
	
	 }
  }

</script>

<cfset PurchaseRemarks = "">
	
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="navigation_table">
		
    <TR class="line labelmedium2 fixlengthlist">
	   <td height="19">&nbsp;</td>
	   <td height="19">&nbsp;</td>
	   <td><cf_tl id="Description"></td>
	   <td align="right"><cf_tl id="Qty"></td>
	   <td align="right"><cf_tl id="UoM"></td>
	   <td align="right"><cf_tl id="Currency"></td>
	   <td align="right"><cf_tl id="Price"></td>
	   <td align="right"><cf_tl id="Amount"></td>
	   <td align="right"></td>
    </TR>
			
	<cfif Requisition.recordcount eq "0">
		<tr><td height="6"   colspan="9"></td></tr>
		<tr><td class="labelmedium" colspan="9" align="center"><cf_tl id="REQ041"></td></tr>
		<tr><td height="5"   colspan="9"></td></tr>
	</cfif>			

	<cfoutput query="Requisition" group="RequisitionPurpose">
				
		<cfif RequisitionPurpose neq "">	
		
		<cfset purchaseremarks = RequisitionPurpose>
								
  	    <tr height="20">
			<td colspan="10"><b>#RequisitionPurpose#</b></td>		   
		</tr>
		</cfif>
	
		<cfoutput>
		
		<tr id="#requisitionno#_1" class="navigation_row labelmedium2 line fixlengthlist">
		
		   <td height="23" align="center">
			 
			  <cfif PurchaseExist eq "">
			      <input type="checkbox" name="QuotationId" id="QuotationId" value="'#QuotationId#'" onClick="hl(this,this.checked,'#RequisitionNo#')">
			  <cfelse>
				  <img src="#SESSION.root#/images/stop3.gif" width="13" height="13" border="0" alt="Purchase already exisits">			  
			  </cfif>
		 		   
		   </td>
    	   <td>&nbsp;</td>		  
		   <td>#VendorItemDescription#</td>
    	   <td align="right">#QuotationQuantity#</td>
		   <td align="right">#QuotationUoM#</td>
		   <td align="right">#Currency#</td>
		   <td align="right">#NumberFormat(QuoteAmount/QuotationQuantity, ",.__")#</td>
		   <td align="right">#NumberFormat(QuoteAmount,",.__")#&nbsp;</td>		   
		   <td align="center" style="padding-top:1px">		   
			   	<cf_img icon="edit" onclick="ProcQuoteEdit('#quotationid#','view');">		  								   
		   </td>
		</tr>
				
		</cfoutput>
	
	</cfoutput>
				
</table> 
 
 <cfset AjaxOnLoad("doHighlight")>				