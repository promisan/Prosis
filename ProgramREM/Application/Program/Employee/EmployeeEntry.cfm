<cf_screenTop height="100%" html="No" scroll="yes" jquery="Yes">

<cf_dialogPosition>
<cfajaximport tags="cfwindow,cfdiv">

<script language = "JavaScript">

function check(myvalue) { 

if (myvalue == "") { 
		alert("You did not select an employee")
		document.AssignmentEntry.search0.focus()
		document.AssignmentEntry.search0.select()
		document.AssignmentEntry.search0.click()
		return false
		}
}		
		
</script>

<cfparam name="URL.Layout" default="Program">

<table width="100%" align="center" frame="hsides" border="0"><tr><td style="padding:10px">
	<cfset url.attach = "0">
	<cfinclude template="../Header/ViewHeader.cfm">

</td></tr>

<tr><td style="padding:10px">

<cfform action="EmployeeEntrySubmit.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Layout=#URL.Layout#" method="POST" name="EmployeeEntry">

<cfquery name="getPeriod" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_Period
		    WHERE  Period = '#URL.Period#'	  
		</cfquery>

<cfoutput>

	<input type="hidden" name="ProgramCode" id="ProgramCode" value="#URL.ProgramCode#">
	<input type="hidden" name="Period" id="Period" value="#URL.Period#">
	<input type="hidden" name="Layout" id="Layout" value="#URL.Layout#">
	
</cfoutput>

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">

    <tr>
    <td width="100%" style="height:40px" valign="middle" class="labellarge">
	   	<cf_tl id="Register program officer">
	</td>
  </tr> 	
         
  <tr>
    <td width="100%">
    <table border="0" cellpadding="0" class="formpadding" cellspacing="0" width="96%" align="center">	
     
    <TR>
    <TD class="labelmedium" width="20%"><cf_tl id="Effective">:</TD>
    <TD class="labelmedium">
	
	<cf_calendarScript>
	
	<cfif getPeriod.DateExpiration gte now()>
		<cfset str = dateformat(getPeriod.DateEffective,client.dateformatshow)>
		<cfset end = dateformat(getPeriod.DateExpiration,client.dateformatshow)>
	<cfelse>
		<cfset str = dateformat(now(),client.dateformatshow)>
		<cfset end = dateformat(getPeriod.DateExpiration,client.dateformatshow)>
	</cfif>	
	
	<table cellspacing="0" cellpadding="0"><tr><td>
		
		  <cf_intelliCalendarDate9
			FieldName="DateEffective" 
			Default="#str#"
			class="regularxl enterastab"
			AllowBlank="True">	
		
		</td><td style="padding-left:3px;padding-right:3px">-</td>
		
		<td>	

		  <cf_intelliCalendarDate9
			FieldName="DateExpiration" 
			Default="#end#"
			class="regularxl enterastab"
			AllowBlank="True">	
		
		</td>
		
		</tr></table>
			
	</TD>
	</TR>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Employee">:</TD>
		
    <TD>
	
		<table cellspacing="0" cellpadding="0">
				<tr>
				
				<td id="member">
															
				<input type="text" name="name" value="" size="40" maxlength="40" class="regularxl enterastab" readonly style="padding-left:4px">				
				<input type="hidden" name="personno" id="personno" value="" size="10" maxlength="10" readonly>
				
				</td>
				<td>
				
				<cfset link = "#SESSION.root#/ProgramREM/Application/Program/Employee/setEmployee.cfm?programcode=#url.programcode#">	
							
				 <cf_selectlookup
				    class      = "Employee"
				    box        = "member"
					button     = "yes"
					icon       = "search.png"
					iconwidth  = "29"
					iconheight = "29"
					title      = "#lt_text#"
					link       = "#link#"						
					close      = "Yes"
					des1       = "PersonNo">
						
				</td>
				</tr>
			</table>		
				
	</TD>
	</TR>	
	
	
	<TR>
        <td class="labelmedium"><cf_tl id="Role">:</td>
        <td>
		<select class="regularxl enterastab" name="Remarks">
			<option value="Project Manager">Project Manager</option>
			<option value="Project Officer">Project Officer</option>
			<option value="Other">Other</option>
		</select>
		</td>
	</TR>	
		
	<TR>
        <td valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Task">:</td>
        <TD><textarea class="regular" style="font-size:13;padding:3px;width:90%" rows="3" name="ProgramDuty"></textarea> </TD>
	</TR>
	
	
	<tr><td height="1" colspan="2" class="linedotted"></td></tr> 
	
	 <tr><td height="28" align="center" colspan="2">
	<cf_tl id="Cancel" var="1">
    <input type="button" name="cancel" value="<cfoutput>#lt_text#</cfoutput>" class="button10g" onClick="history.back()">
	<cf_tl id="Save" var="1"> 
   <input class="button10g" type="submit" name="Submit" value="<cfoutput>#lt_text#</cfoutput>">
   </td></tr> 
	
		
	</table>
	
	</td></tr>
	
	</table>
	 
</CFFORM>
