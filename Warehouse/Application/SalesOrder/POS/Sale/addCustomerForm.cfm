<cf_tl id="Add Customer" var="qlabel">

<cf_screentop height="97%" html="No" scroll="Yes" banner="gray" user="No" jQuery="yes" layout="webapp" label="#qlabel#" focuson="none">

<cfparam name="url.customerid" default="">
<cfparam name="url.mode" default="entry">

<cfoutput>

<cf_calendarScript>
<cf_dialogstaffing>
<cf_windowNotification marginTop="-15px">
<cfajaxproxy cfc="Service.Process.EDI.Manager" jsclassname="EDI" />

<script language="JavaScript">
	
	var active_color     = {'background-color':'##c2d8ec','font-size':'12px','color':'##000000','font-weight':'bold'};
	var clear_color      = {'background-color':'##ededed','font-size':'12px','color':'##000000','font-weight':'normal'};
	var _validate_       = "";
	
	$(document).ready(function() {
	
		 original = $('##reference').val()
	     ref = original.replace(/[^0-9]/g, ''); 
		 
		 if (ref.length<($('##reference').val().length/2)) {
			 $('##reference').val('');
			 $('##name').val(original);
	 		 $('##reference').focus();
		 } else {
			getReferenceName();
	  		 $('##name').focus();
		 }
	});
		
	function show_error_reference(form, ctrl, value, msg) {
	    Prosis.notification.show('Error', msg, 'error', 2500); //error, success, information       
	}  
	
	function check_reference(form, ctrl, value) {
	
		 var validator = new EDI();
		 validator.setSyncMode()
		 try{
		 	var vreturn = validator.CustomerValidate('#url.mission#','1',value,'appsOrganization');		 	
		 	// console.log(vreturn);		 	
		 	if (vreturn.STATUS=="OK")
			 	return true;
		 	else
			 	return false;
		}catch(ex) {
			alert(ex.message);	
		}		
	}

	function getReferenceName() {
		var validator = new EDI();
		validator.setSyncMode()
		try{
			vReference = $('##reference').val()
			var vreturn = validator.CustomerValidate('#url.mission#','1',vReference,'appsOrganization');
			console.log(vreturn);
			if (vreturn.STATUS=="OK") {
				$('##name').val(vreturn.NAME)
			}
		}catch(ex) {
			console.log(ex);
		}
	}
	
    function validatecustomer(mis,whs,mde) {
		document.formcustomer.onsubmit() 
		if(!_CF_error_exists) {
	    	ptoken.navigate('#SESSION.root#/warehouse/application/SalesOrder/POS/Sale/addCustomerSubmit.cfm?mode='+mde+'&mission='+mis+'&warehouse='+whs,'customerresult','','','POST','formcustomer')
	    }  	  
	}

</script>

</cfoutput>

<cfquery name="Parameter" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Parameter
</cfquery>

<cfoutput>

<cfform name="formcustomer" onsubmit="return false">

<table width="100%" height="98%" border="0" bgcolor="white" cellspacing="0" cellpadding="0" align="center" class="formpadding">
 	  
  <tr class="hide" height="2"><td colspan="2" id="customerresult"></td></tr>
      
  <tr>
    <td width="100%" class="header" valign="top">
		
    <table border="0" width="93%" align="center" class="formpadding">
		
    <TR class="labelmedium">
    <TD><cf_tl id="Customer Reference">: <font color="FF0000">*</font></TD>
    <TD>
	
	<cf_tl id="Please enter" var="1" class="message">
		
	<cfinput type="Text"
	       name="reference"
		   id="reference"
	       value="#url.reference#"
		   class="regularxl enterastab"
	       required="Yes" 		   
		   message="#lt_text# #CLIENT.IndexNoName#"		
		   onError="show_error_reference"  
		   onvalidate="check_reference"
		   onChange="getReferenceName()"
		   size="10"
	       maxlength="10">
		
	</TD>
	</TR>	
   		
	<!--- Field: Name --->
    <TR class="labelmedium">
	    <TD><cf_tl id="Name">: <font color="FF0000">*</font></TD>
	    <TD>
		
			<cf_tl id="Please enter name" var="1" class="message">	
			<cfinput type="Text" 
			name="name" 
			id="name" 
			value="" 
			class="regularxl enterastab" 
			message="#lt_text#" 
			required="Yes" 
			onError="show_error_reference"
			size="50" 
			maxlength="60">
			
		</TD>
	</TR>
			
    <!--- Field: BirthDate --->
    <TR class="labelmedium">
	    <TD><cf_tl id="Birth date">:</TD>
	    <TD>
		
			  <cf_intelliCalendarDate9
				FieldName="DOB" 
				Default=""									    
				class="regularxl enterastab"		
				AllowBlank="True">	
			
		</TD>
	</TR>
	
	 <!--- Field: eMail --->
    <TR class="labelmedium">
	    <TD><cf_tl id="eMail">: </TD>
    	<TD>
		
		<cf_tl id="Please enter a valid eMail" var="1" class="message">		
		<cfinput type="Text" name="eMailAddress" class="regularxl enterastab" message="#lt_text#" validate="email" value="" required="No" size="40" maxlength="50">
		
		</TD>
	</TR>
	
	
	
    <!--- Field: Phone No. --->
    <TR class="labelmedium">
	    <cf_tl id="Please enter a PhoneNo" var="1" class="message">		
	    <TD  title="#lt_text#"><cf_tl id="Phone No">:</TD>
	    <TD>
			
			<cfinput type="Text" name="PhoneNumber" class="regularxl enterastab" message="#lt_text#" value="" required="No" size="30" maxlength="30">
			
		</TD>
	</TR>
	
	 <!--- Field: Mobile No. --->
    <TR class="labelmedium">
	    <cf_tl id="Please enter a MobileNo" var="1" class="message">	
	    <TD title="#lt_text#"><cf_tl id="Mobile No">:</TD>
	    <TD>			
			<cfinput type="Text" name="MobileNumber" class="regularxl enterastab" message="#lt_text#" value="" required="No" size="30" maxlength="30">			
		</TD>
	</TR>
	
	<tr class="labelmedium">
		<td><cf_tl id="Postal Code"> :</td>
		<td>
		
		 <cf_textInput
			  form      = "formcustomer"
			  type      = "ZIP"
			  mode      = "regularxl"
			  name      = "PostalCode"
		      value     = ""
		      required  = "No"
			  size      = "8"
			  maxlength = "8"
			  label     = "&nbsp;"
			  style     = "text-align: center;">	
					  
		</td>
	</tr>
	
	<tr class="labelmedium">
		<td><cf_tl id="Tax Exemption"> :</td>
		<td style="height:30px">
		    <table>
			<tr class="labelmedium">
			<td style="padding-left:0px"><input name="TaxExemption" class="radiol enterastab" type="radio" value="1"></td>
			<td style="padding-left:4px"><cf_tl id="Yes"></td>
			<td style="padding-left:7px"><input name="TaxExemption" class="radiol enterastab" type="radio" value="0" checked></td>
			<td style="padding-left:4px"><cf_tl id="No"></td>
			</tr>
			</table>
		</td>
	</tr>
	
	
		   
	<TR class="line">
        <td class="labelmedium" valign="top" style="padding-top:5px"><cf_tl id="Remarks">:</td>
        <TD><textarea style="border-radius:2px;width:95%;height:50;font-size:15;padding:4px" class="regular enterastab" name="Memo"></textarea> </TD>
	</TR>
			
	
    <tr><td colspan="2" height="30" align="center">  
	
		<table cellspacing="0" cellpadding="0" class="formspacing">
			<tr>		
				<td>			
				<cf_tl id="Close" var="1">	
				<input type="button" value="#lt_text#" class="button10g" style="width:150;height:26" onclick="parent.ProsisUI.closeWindow('customeradd',true)">			
				</td>			
				<td>					
				<cf_tl id="Submit" var="1">
				<input type="button" value="#lt_text#" class="button10g" style="width:150;height:26" onclick="validatecustomer('#url.mission#','#url.warehouse#','#url.mode#')">			
				</td>			
			</tr>
		</table>
										               
     </td>

	</table>
	
	</td></tr>
		
</table>	

</cfform>

</cfoutput>


