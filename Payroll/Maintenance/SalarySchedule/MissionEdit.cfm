	
<cfform onsubmit="return false" name="formmission" method="POST">

	<cfquery name="Get" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM SalaryScheduleMission
	WHERE    SalarySchedule = '#URL.Schedule#'
	AND      Mission = '#URL.Mission#'
	</cfquery>
		
	<table width="95%" align="center" class="formpadding formspacing">
	
	<cfoutput>
	 	
	<TR class="labelmedium">
	
	    <TD width="20%"><cf_tl id="Effective Date">:</TD>
	    <TD>
		
		  <cf_intelliCalendarDate9
				FieldName="DateEffective" 
				class="regularxxl"
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
			
			<TR class="labelmedium">
		    <TD><cf_tl id="Payroll Account">:</TD>
		    <TD>	
				    <cfoutput>	 
				    <img src="#SESSION.root#/Images/contract.gif" alt="Payroll Account" name="img3" 
						  onMouseOver="document.img3.src='#SESSION.root#/Images/button.jpg'" 
						  onMouseOut="document.img3.src='#SESSION.root#/Images/contract.gif'"
						  alt="" width="25" height="28" border="0" align="absmiddle" 
						  onclick="selectaccountgl('#URL.mission#','glaccount','','','applyaccount','')">
	
					    <input type="text"   name="glaccount"     id="glaccount"     size="6" value="#GL.glaccount#" class="regularxxl" readonly style="text-align: center;">
				    	<input type="text"   name="gldescription" id="gldescription" value="#GL.description#" class="regularxxl" size="40" readonly style="text-align: center;">
					    <input type="hidden" name="debitcredit"   id="debitcredit"   value="">
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
		
		<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="ProsisUI.closeWindow('misdialog')">
		<cfif check.recordcount eq "0">
		<input class="button10g" type="submit" name="Delete" value="Delete" onclick"missioneditsubmit('#url.schedule#','#url.mission#','delete')>
		</cfif>
	    <input class="button10g" type="submit" name="Update" value="Update " onclick="missioneditsubmit('#url.schedule#','#url.mission#','update')">
		
	</td></tr>
	
	</cfoutput>
	
	</table>
				
</cfform>	

<cfset ajaxOnLoad("doCalendar")>
