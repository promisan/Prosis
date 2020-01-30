
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="Add Period" 
			  label="Add Period" 
			  menuAccess="Yes" 
			  banner="gray"
			  systemfunctionid="#url.idmenu#">

<cf_dialogLedger>
<cf_calendarscript>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="92%" align="center" cellspacing="0" cellpadding="0"  class="formpadding formspacing">

	<tr><td></td></tr>
	<tr><td></td></tr>
	
    <TR class="labelmedium">
    <TD>Period:</TD>
    <TD>
  	   <cfinput class="regularxl" type="Text" name="AccountPeriod" value="" message="Please enter the period" required="Yes" size="6" maxlength="6">
    </TD>
	</TR>
		
	<TR class="labelmedium">
    <TD>Description:</TD>
    <TD>
  	    <cfinput class="regularxl" type="Text" name="Description" value="" message="Please enter the description of your period" required="Yes" size="30" maxlength="30">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Fiscal Year:</TD>
    <TD>
  	    <cfinput class="regularxl" type="Text" name="AccountYear" message="Please enter the fiscal year of the period" validate="integer" required="Yes" size="4" maxlength="4" style="text-align: left;">
    </TD>
	</TR>

	<TR class="labelmedium">
    <TD>Enable reconciliation<br>future periods:</TD>
    <TD>
  	    <cfinput class="radiol" type="checkbox" name="Reconcile" id="Reconcile" style="text-align: left;" value="1">
    </TD>
	</TR>
	
					
	<TR class="labelmedium">
    <TD>Date Start:</TD>
    <TD>
	<cf_intelliCalendarDate9
			FieldName="PeriodDateStart" 
			Default=""
			class="regularxl"
			AllowBlank="False">	
  	  </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Date End:</TD>
    <TD>
	<cf_intelliCalendarDate9
			FieldName="PeriodDateEnd" 
			Default=""
			class="regularxl"
			AllowBlank="False">	
  	  </TD>
	</TR>
	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="6">
	
	<tr><td colspan="2" align="center">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" value=" Submit ">
	</td></tr>	
	
</TABLE>
	
</CFFORM>