
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="Edit Period" 
			  label="Edit Period" 
			  menuAccess="Yes" 
			  banner="gray"
			  line="no"
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Period
	WHERE  AccountPeriod = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this period ?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>

<cf_dialogLedger>

<!--- Entry form --->


<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="90%" align="center" cellspacing="0" cellpadding="0" class="formpadding formspacing">

    <tr><td style="height:6px"></td></tr>
	
    <cfoutput>
    <TR class="labelmedium">
    <TD>Period:</TD>
    <TD>
  	   <input type="text"
       name="AccountPeriod"
       value="#get.accountperiod#"
       size="6"
       maxlength="6"
       readonly	   
       class="regularxl"
       style="text-align: center;background: ffffcf;">
    </TD>
	</TR>
	
	<cf_calendarscript>
					
	<TR class="labelmedium">
    <TD>Date Start:</TD>
    <TD>
		<cf_intelliCalendarDate9
		    class="regularxl"
			FieldName="PeriodDateStart" 
			Default="#dateformat(get.PeriodDateStart,CLIENT.DateFormatShow)#"
			AllowBlank="False">	
  	  </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Date End:</TD>
    <TD>
		<cf_intelliCalendarDate9
			FieldName="PeriodDateEnd" 
			class="regularxl"
			Default="#dateformat(get.PeriodDateEnd,CLIENT.DateFormatShow)#"
			AllowBlank="False">	
  	  </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Description:</TD>
    <TD>
  	    <cfinput class="regularxl" type="Text" name="Description" value="#get.description#" message="Please enter the description of your period" required="Yes" size="30" maxlength="30">
    </TD>
	</TR>
	
		
	<TR class="labelmedium">
    <TD>Enable transaction reconciliation in future periods:</TD>
    <TD>
  	    <cfinput class="regularxl" value="1" type="checkbox" name="Reconcile" id="Reconcile" style="text-align: left;" checked="#get.Reconcile eq 1?'Yes':'No'#">
    </TD>
	</TR>
	
	
	<TR class="labelmedium">
    <TD>Status:</TD>
    <TD class="labelit">
		<input type="radio" class="radiol" name="ActionStatus" value="0" <cfif get.actionStatus eq "0">checked</cfif>>Open
		<input type="radio" class="radiol" name="ActionStatus" value="1" <cfif get.actionStatus eq "1">checked</cfif>>Close
	 </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Fiscal Year:</TD>
    <TD>
  	    <cfinput class="regularxl" type="Text" name="AccountYear" value="#get.accountyear#" message="Please enter the fiscal year of the period" validate="integer" required="Yes" size="14" maxlength="20" style="text-align: center;">
    </TD>
	</TR>		
	
	</cfoutput>
	
	<tr><td colspan="2" align="center" height="1">
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="1">

	<tr><td colspan="2" align="center">
	
		<input class="button10g" style="width:100px" type="button" name="Cancel" value="Cancel" onClick="window.close()">
		<input class="button10g" style="width:100px" type="submit" name="Delete" value="Delete" onclick="return ask()">
		<input class="button10g" style="width:100px" type="submit" name="Update" value="Update">

	</td></tr>
			
</TABLE>

</CFFORM>

</BODY></HTML>