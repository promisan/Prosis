
<cf_screentop height="100%" label="Salary Schedule Implementation #URL.mission#" banner="gray" layout="webapp" band="No" jquery="Yes" scroll="No">

<script>
	function applyaccount(acc) {
	   ptoken.navigate('setAccount.cfm?account='+acc,'processmanual')
	} 
</script>

<cf_dialogLedger>
<cf_calendarscript>
	
<cfform style="height:100%" action="MissionEditSubmit.cfm?idmenu=#URL.idmenu#&mission=#URL.mission#&schedule=#URL.schedule#" method="POST">


	<cfquery name="Get" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM SalaryScheduleMission
	WHERE    SalarySchedule = '#URL.Schedule#'
	AND      Mission = '#URL.Mission#'
	</cfquery>
		
	<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formspacing formpadding">
	
	<cfoutput>
   	<tr><td height="20"></td></tr>
   	
	<TR>
    <TD width="20%"  class="labelmedium"><cf_tl id="Effective Date">:</TD>
    <TD class="labellarge">
	
	  <cf_intelliCalendarDate9
		FieldName="DateEffective" 
		class="regularxl"
		Default="#dateformat(get.DateEffective,CLIENT.DateFormatShow)#"
		AllowBlank="False">	
  	
    </TD>
        
	</TR>
		
		<cf_verifyOperational 
         datasource= "appsSystem"
         module    = "Accounting" 
		 Warning   = "No">
		 
	<cfif Operational eq "1"> 
		
		<cfquery name="GL" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM Ref_Account
		WHERE    GLAccount = '#get.GLAccount#'
		</cfquery>	
		
		<TR>
	    <TD  class="labelmedium"><cf_tl id="Payroll GL Account">:</TD>
	    <TD>	
			    <cfoutput>	 
			    <img src="#SESSION.root#/Images/contract.gif" alt="Select item master" name="img3" 
					  onMouseOver="document.img3.src='#SESSION.root#/Images/button.jpg'" 
					  onMouseOut="document.img3.src='#SESSION.root#/Images/contract.gif'"
					  style="cursor:pointer; margin-top:-5px;" alt="" width="23" height="25" border="0" align="absmiddle" 
					  onclick="selectaccountgl('#URL.mission#','glaccount','','','applyaccount','')">

				    <input type="text" name="glaccount" id="glaccount" size="6" value="#GL.glaccount#" class="regularxl" readonly style="text-align: center;">
			    	<input type="text" name="gldescription" id="gldescription" value="#GL.description#" class="regularxl" size="40" readonly style="text-align: center;">
				    <input type="hidden" name="debitcredit" id="debitcredit" value="">
			   </cfoutput>
		
	     </TD>
		</TR>
	
	</cfif>

	<tr><td id="processmanual"></td></tr>
	
	<tr><td class="line" colspan="2" align="center" height="30">
	
	<cfquery name="Check"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM   EmployeeSalary
		WHERE  SalarySchedule = '#URL.Schedule#'
		AND    Mission = '#URL.Mission#'
		</cfquery>
	
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	<cfif check.recordcount eq "0">
	<input class="button10g" type="submit" name="Delete" value=" Delete ">
	</cfif>
    <input class="button10g" type="submit" name="Update" value=" Update ">
		
	</td></tr>
	
	</cfoutput>
		
	
		
</cfform>	

<script>
	doCalendar();
</script>