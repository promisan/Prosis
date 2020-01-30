<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Add Currency" 
			  scroll="No" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  jquery="Yes"
			  systemfunctionid="#url.idmenu#">

<cf_dialogLedger>

<cfajaximport tags="cfwindow">	

<script>
	
	function applyinvoice(acc) {
	   ptoken.navigate('setAccount.cfm?mode=invoice&account='+acc,'process')
	}  	
	
	function applysale(acc) {
	   ptoken.navigate('setAccount.cfm?mode=sale&account='+acc,'process')
	}  

</script>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="94%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr class="hide" ><td id="process"></td></tr>
    <tr><td height="5"></td></tr>
    <TR>
    <TD class="labelmedium">Acronym:</TD>
    <TD>
  	   <cfinput type="Text" class="regularxl" name="Currency" value="" message="Please enter the currency acronym" required="Yes" size="4" maxlength="4">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	    <cfinput type="Text" class="regularxl" name="Description" value="" message="Please enter the description of your currency" required="Yes" size="30" maxlength="30">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Effective:</TD>
    <TD>
	
		<cf_calendarscript>
	
		  <cf_intelliCalendarDate9
		FieldName="EffectiveDate" 
		class="regularxl"
		Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
		AllowBlank="False">	
	
	</TD>
	</TR>
			
	<TR>
    <TD class="labelmedium">Opening Exchange rate:</TD>
    <TD><table cellspacing="0" cellpadding="0">
		<tr>
		<td>
  	    <cfinput type="Text" class="regularxl" name="ExchangeRate" message="Please enter the exchange rate to the base currency" validate="float" required="Yes" size="10" maxlength="20" style="text-align: right;">
		</td>
		<td style="padding-left:5px" class="labelmedium">= equivalent to 1 <cfoutput>#application.BaseCurrency#</cfoutput></td>
		</tr>
		</table>
		
    </TD>
	</TR>
			
	<TR>
    <TD class="labelmedium">Default Invoice tax:</TD>
    <TD>
	  
	    <cfoutput>		  
	  
	       <input type="Text" name="glaccount1" id="glaccount1" size="6" class="regularxl" readonly>
    	   <input type="text" name="gldescription1" id="gldescription1" value="" class="regularxl" size="50" readonly>
		   <input type="hidden" name="debitcredit1" id="debitcredit1" value="" class="regularxl" size="6" readonly>
		    <img src="#SESSION.root#/Images/search.png" alt="Select account" name="img3" 
				  onMouseOver="document.img3.src='#SESSION.root#/Images/contract.gif'" 
				  onMouseOut="document.img3.src='#SESSION.root#/Images/search.png'"
				  style="cursor: pointer;" alt="" width="20" height="20" border="0" align="absmiddle" 
				  onClick="selectaccountgl('','','','','applyinvoice')">
				  
		</cfoutput>				  
		
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Default Sales tax:</TD>
    <TD>
	
  		 <cfoutput>	 
		 
		       <input type="Text" name="glaccount2" id="glaccount2" size="6" class="regularxl" readonly>
    	   <input type="text" name="gldescription2" id="gldescription2" value="" class="regularxl" size="50" readonly>
		   <input type="hidden" name="debitcredit2" id="debitcredit2" value="" class="regularxl" size="6" readonly>
		    <img src="#SESSION.root#/Images/search.png" alt="Select account" name="img5" 
				  onMouseOver="document.img5.src='#SESSION.root#/Images/contract.gif'" 
				  onMouseOut="document.img5.src='#SESSION.root#/Images/search.png'"
				  style="cursor: pointer;" alt="" width="20" height="20" border="0" align="absmiddle" 
				  onClick="selectaccountgl('','','','','applysale')">				  
		
		</cfoutput>   
		
	</TD>
	</TR>	
	
	<TR>
    <TD class="labelmedium">Procurement:</TD>
    <TD>
	<input type="checkbox" class="radiol" name="EnableProcurement" value="1" checked>
	
	</TD>
	</TR>	
	
	<tr><td colspan="2" height="3"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td colspan="2" height="35" align="center">
	
		<input type="button" class="button10g" name="Cancel" value=" Cancel " onClick="window.close()">
		<input type="submit" class="button10g" name="Insert" value=" Submit ">
		
	</td>
	</tr>
		
</TABLE>
			
</CFFORM>