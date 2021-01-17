
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
              scroll="No" 
			  label="Execution Period / Enterprise mapping" 			  
			  layout="webapp" 
			  banner="gray"
			  jQuery="Yes"
  			  menuAccess="Yes" 
              systemfunctionid="#url.idmenu#">
 
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Period
	WHERE Period = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Period?")) {
		return true 	
	}	
	return false	
}	

</script>

<cfajaximport tags="cfform">

<!--- edit form --->

<table width="95%" height="100%" align="center" class="formpadding formspacing">

<tr><td height="100%">

<cfform style="height:100%" action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="100%" height="100%" align="center" class="formpadding">

<tr><td height="40">

<table width="100%" class="navigation_table formpadding">
	
	<tr><td height="2"></td></tr>
    <cfoutput>
	
    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD colspan="2" class="regular">
  	   <input type="text" disabled name="Period" value="#get.Period#" size="10" maxlength="10" class="regularxxl">
	   <input type="hidden" name="periodOld" value="#get.Period#" size="10" maxlength="10" class="regular">
    </TD>
	</TR>
		
	<cf_calendarscript>	
	<TR class="labelmedium2">
    <TD>Period:</TD>
    <TD colspan="2">
		<table cellspacing="0" cellpadding="0"><tr><td>
		 <cf_intelliCalendarDate9
			FieldName="DateEffective" 
			class="regularxxl"
			Default="#DateFormat(Get.DateEffective, CLIENT.DateFormatShow)#"
			AllowBlank="False">
		</td><td align="center" width="20">-</td>
		<td>
			<cf_intelliCalendarDate9
			FieldName="DateExpiration" 
			class="regularxxl"
			Default="#DateFormat(Get.DateExpiration, CLIENT.DateFormatShow)#"
			AllowBlank="False">	
		</td></tr></table>
	    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Class:</TD>
    <TD colspan="2">
	  <table><tr><td>
	 <cfinput type="text" name="PeriodClass" value="#get.PeriodClass#" message="Please enter a class" required="yes" size="10"
	   maxlenght = "10" class= "regularxxl">
	    </td>
		<TD style="padding-left:4px" class="labelmedium">Description:</TD>
		<TD style="padding-left:4px" colspan="2">
			
		  	   <cfinput type = "text" 
			       name      = "Description" 
				   value     = "#get.Description#" 
				   message   = "please enter a description" 
				   required  = "yes" 
				   size      = "30" 
		    	   maxlenght = "50" 
				   class     = "regularxxl">
				   
		</TD>
		</TR>
	    </table>
	</td> 
		
	<TR>
   
	</TR>
		
	<TR class="labelmedium2">
    <td>Show in Period Selection:</td>
	<td>
  	  <input type="radio" class="radiol" name="IncludeListing" value="1" <cfif Get.IncludeListing eq "1">checked</cfif>>Yes
	  <input type="radio" class="radiol" name="IncludeListing" value="0" <cfif Get.IncludeListing eq "0">checked</cfif>>No
    </TD>
	</TR>	
		
	<TR class="labelmedium2">
    <td width="100">Usage:</td>
	<td width="80%">
	
	<table>
	 <tr class="labelmedium2">
	  <td>
      <input type="radio" class="radiol" name="isPlanningPeriod" value="1" <cfif Get.isPlanningPeriod eq "1">checked</cfif> onclick="document.getElementById('planperiod').className='regular'"></td><td class="labelmedium">Execution- AND Plan Period </td>
	  <td>&nbsp;</td>
	  <cfif get.isPlanningPeriod eq "1">
	   <cfset cl = "regular">	   
	  <cfelse>
	   <cfset cl = "hide">
	  </cfif>
	  <td id="planperiod" class="#cl#">
	  
		  <table cellspacing="0" cellpadding="0">
		  <tr class="labelmedium2">
		     <td class="labelmedium" style="padding-right:10px">covering entry for periods until:</td>
		  	 <td>
			  <cf_intelliCalendarDate9
				FieldName="isPlanningPeriodExpiry" 
				class="regularxxl"
				Default="#DateFormat(Get.isPlanningPeriodExpiry, CLIENT.DateFormatShow)#"
				AllowBlank="True">	
			</td>
			<td style="padding-left:10px" class="labelmedium">
	  	    <input type="radio" class="radiol" name="isPlanningPeriod" value="0" <cfif Get.isPlanningPeriod eq "0">checked</cfif> onclick="document.getElementById('planperiod').className='hide'">
			</td>
		    <td class="labelmedium">Execution only</td>	
		  </tr>
		  </table>
	  
	  </td>	 
	  </tr>
	</table> 
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <td width="100"><cf_UIToolTip tooltip="Defines if this period will be shown as a period for grouping of requisition, purchaseorder and invoices. Shown in the left panel for selection">Procurement&nbsp;Grouping:</cf_UIToolTip></td>
	<td width="70%">
  	  <input type="radio" class="radiol" name="Procurement" value="1" <cfif Get.Procurement eq "1">checked</cfif>>Yes
	  <input type="radio" class="radiol" name="Procurement" value="0" <cfif Get.Procurement eq "0">checked</cfif>>No
    </TD>
	</TR>
	
   </cfoutput>
			
   <!--- check --->
		
   <cf_verifyOperational module="Accounting" Warning="No">
  	
	<cfquery name="MissionSelect" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   DISTINCT Mission
			FROM     Ref_MissionModule
			WHERE    SystemModule IN ('Program','Procurement') 
	</cfquery>	
		
	<cfset ln = 0>
	
</table>

</td></tr>	

<tr><td height="20" style="padding-left:2px;padding-right:2px">

	<table width="100%"><tr>
	
	<cf_menuScript>
	
		<cfset ht = "40">
		<cfset wd = "40">
	
		<cf_menutab item       = "1" 
	            iconsrc    = "Logos/System/Tree.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				padding    = "2"
				class      = "highlight1"
				name       = "Entities and Execution">			
					
		<cf_menutab item       = "2" 
	            iconsrc    = "Logos/Attendance/DayView.png" 
				iconwidth  = "#wd#" 
				iconheight = "#ht#" 
				padding    = "2"
				iframe     = "auditdates"
				name       = "Audit Dates"
				source     = "iframe:AuditView.cfm?o=2&ID=#url.id1#&box=contentbox2">
				
		<td width="20%"></td>
		
		</tr>
	
	</table>
</td></tr>
		
<tr><td height="100%">
   
	<table width="100%" height="100%">
		
		<cf_menucontainer item="1" class="regular">
			<cfinclude template="RecordEditMission.cfm">
		</cf_menucontainer>		
				
		<cf_menucontainer item="2" class="hide" iframe="auditdates">
			
	</table>	

</td>
</tr>	
		
</TABLE>

</CFFORM>

</td></tr>

</table>	

<cf_screenbottom layout="webapp">
