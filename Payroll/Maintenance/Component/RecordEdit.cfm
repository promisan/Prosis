<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="Salary Schedule Components" 
			  label="Schedule Components" 
			  menuAccess="Yes" 
			  banner="gray"
			  line="no"
			  bannerheight="50"
			  systemfunctionid="#url.idmenu#">

<cfajaximport>

<cfparam name="URL.ID1" default="">

<cfquery name="get"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *, R.Description as TriggerDescription
	FROM     Ref_PayrollComponent C, 
	         Ref_PayrollTrigger R, 
			 Ref_PayrollItem I
	WHERE    R.SalaryTrigger = C.SalaryTrigger
	AND      C.PayrollItem = I.PayrollItem
	AND      C.Code = '#URL.ID1#'
	ORDER BY R.TriggerGroup,
	         R.SalaryTrigger, 
			 ListingOrder DESC
</cfquery>

<cfquery name="PayrollItem"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PayrollItem
	ORDER BY PayrollItemName
</cfquery>

<script language="JavaScript">
	
	function ask() {
		if (confirm("Do you want to remove this item?")) {
			return true 
		}
		return false	
	}	
	
	function apply(val) {
		
	 if (val == 'percent') {
      
	     step('hide')
		 document.getElementById('entitlementgrade').className = "hide"	 
		 document.getElementById('entitlementpointer').className = "hide"	 
		 // document.getElementById('calculationover').className  = "hide"
		 
	  } else {
	  
	  	 step('regular')
		 document.getElementById('entitlementgrade').className = "regular"	
		 document.getElementById('entitlementpointer').className = "regular"	 
		 // document.getElementById('calculationover').className  = "regular"
	  
	  }	 
	  
	  }
	
</script>

<cfform action="RecordSubmit.cfm" method="POST">

<!--- edit form --->

<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td height="5"></td></tr>
	
	<tr><td colspan="2" class="labelmedium"><font color="gray">Define a payroll component which is executed through a trigger. A single trigger can fire one or more component (which are presented as entitlements).</td></tr>
	
	<tr><td colspan="2" height="1" class="linedotted"></td></tr>
	
	<tr><td height="5"></td></tr>

    <cfoutput>

	<TR>
    <TD class="labelmedium"><cf_tl id="Trigger">:<cf_space spaces="50"></TD>
    <TD class="labelmedium">		
				
		<cfquery name="SalaryTrigger"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM Ref_PayrollTrigger
		</cfquery>
	
		<select name="SalaryTrigger" class="regularxl">
     	   <cfloop query="SalaryTrigger">
        	   <option value="#SalaryTrigger.SalaryTrigger#" <cfif get.SalaryTrigger eq SalaryTrigger>selected</cfif>>#Description#</option>
         	</cfloop>
	    </select>		
		
    </TD>
	</TR>	
	
					
    <TR>
    <TD class="labelmedium"><cf_tl id="Code">:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="Code" value="#get.code#" message="Please enter a code" required="Yes" size="20" maxlength="30" class="regularxl">
       <input type="hidden" name="CodeOld" value="#get.code#" class="regular">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Description">:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="Description" value="#get.Description#" message="please enter a description" requerided=  "yes" size="40" 
	   maxlength = "50" class= "regularxl">
    </TD>
	</TR>	
			
	<TR>
    <TD class="labelmedium"><cf_tl id="Parent">:</TD>
    <TD class="labelmedium">	
				
		<cfquery name="parent"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
			FROM     Ref_PayrollComponent C
			WHERE    SalaryTrigger = '#get.salarytrigger#'
			AND      C.Code != '#URL.ID1#'
			AND      C.ParentComponent is NULL		
		</cfquery>
	
		<select name="ParentComponent" class="regularxl">
		   <option value="">N/A</option>	
     	   <cfloop query="Parent">
        	   <option value="#Code#" <cfif get.ParentComponent eq code>selected</cfif>>#Description#</option>
         	</cfloop>
	    </select>		
		
    </TD>
	</TR>
	
	<script language="JavaScript">
	
		function formula(val) {
		  	  
			 if (val != "rate")  {		     
			     document.getElementById("formulabox").className = "hide"
				 document.getElementById("step").className = "hide"
			 } else {	   
			     document.getElementById("formulabox").className = "regular"
				 document.getElementById("formulabox").className = "regular"
				 
			 }
		 
		 }
	
	</script>	
		
	<TR>
	    <TD class="labelmedium"><cf_tl id="Payroll Group">:</TD>
	    <TD class="labelmedium">
		
			<cfif get.EntitlementGroup eq "">
				<cfset val = "Standard">
			<cfelse>
				<cfset val = get.EntitlementGroup>
			</cfif>
			
			<table>
		   <tr>
		   <td class="labelmedium">
	  	   <cfinput type="text" name="EntitlementGroup" value="#val#" message="please enter a group" required="yes" style="width:80" size="10" 
		   maxlength = "20" class= "regularxl">
		     </td>
		   <td class="labelit" style="padding-top:7px;font-size:12px;padding-left:4px">applies to runtime calculation once group value is met</td>
		   </tr>
		   </table>
	    </TD>
	</TR>
	
	<cfif "PERCENT" eq get.Period>
			<cfset cl = "hide">
		<cfelse>
			<cfset cl = "regular">
		</cfif>
		
	<TR id="entitlementpointer" class="<cfoutput>#cl#</cfoutput>">
	    <TD class="labelmedium"><cf_tl id="Pointer">:</TD>
	    <TD>
		   <table>
		   <tr>
		   <td class="labelmedium">
	  	   <cfinput type="text" name="EntitlementPointer" validate="integer" value="#get.EntitlementPointer#" message="please enter a description" required="no" size="1" 
		   maxlength= "2" class= "regularxl" style="text-align:center;width:30px">
		   </td>
		   <td class="labelit" style="padding-top:5px;font-size:12px;padding-left:4px">applies only to runtime calculation once pointer value is met</td>
		   </tr>
		   </table>
	    </TD>
	</TR>	
				
	<TR>
	    <TD class="labelmedium" style="cursor: pointer;">
			<cf_UItooltip tooltip="Show the defined entitlements under the following name on the payslip"><cf_tl id="Payslip Item">:</cf_UItooltip>
		</TD>
	    <TD class="labelmedium">
			<select name="PayrollItem" class="regularxl">
	     	   <cfloop query="PayrollItem">
	        	   <option value="#PayrollItem.PayrollItem#" <cfif get.PayrollItem eq PayrollItem.PayrollItem>selected</cfif>>#PayrollItemName# (#PayrollItem#)</option>
	         	</cfloop>
		    </select>
			
	    </TD>
	</TR>
	
	<TR>
	    <TD class="labelmedium"><cf_tl id="Multiplier">:</TD>
	    <TD class="labelmedium">
		<cfif get.SalaryMultiplier eq "">
		 <cfset m = 1>
		<cfelse>
		 <cfset m = get.SalaryMultiplier> 
		</cfif>
		
		<table>
		   <tr>
		   <td class="labelmedium">
		
			<cfinput type="Text"
		       name="SalaryMultiplier"
		       value="#m#"
			   class="regularxl"
		       validate="float"
		       required="Yes"
		       visible="Yes"
		       enabled="Yes"
			   style="text-align:center"	  
		       size="1"
		       maxlength="3">
			   
			     </td>
		   <td class="labelit" style="padding-top:7px;font-size:12px;padding-left:4px">set as negative in case amount has to be deducted from staff payroll</td>
		   </tr>
		   </table>
		  
		</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Calculation Class">:</TD>
    <TD>
	    <table><tr>
		<td>
	    <INPUT type="radio" class="radiol" name="EntitlementClass" onclick="javascript:formula('rate')" value="Rate" <cfif "Rate" eq get.EntitlementClass or get.EntitlementClass eq "">checked</cfif>></td>
		<td style="padding-left:4px"  class="labelmedium"><cf_tl id="Rate"></td>
		<td>
	    <INPUT type="radio" class="radiol" name="EntitlementClass" onclick="javascript:formula('percentage')"  value="Percentage" <cfif "Percentage" eq "#get.EntitlementClass#">checked</cfif>></td>
		<td style="padding-left:4px"  class="labelmedium"><cf_tl id="Percentage"></td>		
		</tr>
		</table>
	</TD>
	</TR>	
	
	<cfif get.EntitlementClass eq "Rate" or get.EntitlementClass eq "">
	    <cfset cl = "regular">
	<cfelse>
		<cfset cl = "hide">  
	</cfif>	
		
	<TR id="formulabox" class="<cfoutput>#cl#</cfoutput>">
	    <TD class="labelmedium"><cf_tl id="Rate UoM">:</TD>
	    <TD class="labelmedium" style="height:30px">
		<cfdiv bind="url:RecordTrigger.cfm?id={SalaryTrigger}&id1=#URL.ID1#" id="myper">
		</TD>
		</TR>		
		
		<script language="JavaScript">	
		
			function step(val) {
				se = document.getElementById("step").className = val
			}
		
		</script>
		
		<cfif "PERCENT" eq get.Period>
			<cfset cl = "hide">
		<cfelse>
			<cfset cl = "regular">
		</cfif>
			
		<TR id="entitlementgrade" class="#cl#">
	    <TD width="30%" class="labelmedium" valign="top" style="padding-top:5px"><cf_tl id="Entitlement over">:</TD>
	    <TD class="labelmedium">
		   <table cellspacing="0" cellpadding="0">
		    <tr>
			<td><INPUT class="radiol" type="radio" name="EntitlementGrade" value="REGULAR" <cfif "REGULAR" eq get.EntitlementGrade or get.EntitlementGrade eq "">checked</cfif>></td>
			<td style="padding-left:5px" class="labelmedium">Contract schedule/grade</td>
						
			<td style="padding-left:5"><INPUT class="radiol" type="checkbox" name="EntitlementGradePointer" value="1" <cfif "1" eq get.EntitlementGradePointer>checked</cfif>></td>
			<td style="padding-left:5px" class="labelmedium">No settlement if SPA schedule differs</td>
			</tr>
			
			</tr>
			<tr>
			<td><INPUT class="radiol" type="radio" name="EntitlementGrade" value="SPA" <cfif "SPA" eq get.EntitlementGrade>checked</cfif>></td>
			<td style="padding-left:5px" colspan="4" class="labelmedium">SPA schedule/grade entitlement ; if applicable, otherwise Contract</td>
			</tr>
			
			</table>
	    </TD>
	</TR>
					
	<TR id="calculationover" class="xxxxxx#cl#">
    <TD class="labelmedium" valign="top" style="padding-top:5px"><cf_tl id="Calculation over">:</TD>
    <TD class="labelmedium">
	    <table cellspacing="0" cellpadding="0" class="formpadding">
			<tr class="labelmedium">
				<td style="padding-left:0px"><INPUT class="radiol" type="radio" name="SalaryDays" value="0" <cfif "0" eq get.SalaryDays>checked</cfif>></td>
				<td style="padding-left:4px">(0) Entitlement days -/- LWOP</td>
			</tr>
			<tr class="labelmedium">
				<td style="padding-left:0px"><INPUT class="radiol" type="radio" name="SalaryDays" value="1" <cfif "1" eq get.SalaryDays or get.SalaryDays eq "">checked</cfif>></td>
				<td style="padding-left:4px">(1) Entitlement days</td>
			</tr>		
			<tr class="labelmedium">
				<td style="padding-left:0px"><INPUT class="radiol" type="radio" name="SalaryDays" value="2" <cfif "2" eq get.SalaryDays>checked</cfif>></td>
				<td style="padding-left:4px">(2) Apply full rate, regardless of days (like Medical insurance)</td>
			</tr>		
			<tr class="labelmedium">
				<td style="padding-left:0px"><INPUT class="radiol" type="radio" name="SalaryDays" value="3" <cfif "3" eq get.SalaryDays>checked</cfif>></td>
				<td style="padding-left:4px">(3) Entitlement days -/- (LWOP + Suspended)</td>
			</tr>
			<tr class="labelmedium">
				<td style="padding-left:0px"><INPUT class="radiol" type="radio" name="SalaryDays" value="4" <cfif "4" eq get.SalaryDays>checked</cfif>></td>
				<td style="padding-left:4px">(4) Entitlement days, regardless of part-time</td>
			</tr>
						
				
		</table>
	</TD>
	</TR>
	
				
	<TR id="step" class="#cl#">
    <TD class="labelmedium"><cf_tl id="Rate definition">:</TD>
    <TD class="labelmedium">
	    <INPUT class="radiol" type="radio" name="RateStep" value="9" <cfif "9" eq get.RateStep>checked</cfif>> Single Rate
	    <INPUT class="radiol" type="radio" name="RateStep" value="0" <cfif "0" eq get.RateStep>checked</cfif>> Grade (any step)
		<INPUT class="radiol" type="radio" name="RateStep" value="1" <cfif "1" eq get.RateStep or "" eq get.RateStep>checked</cfif>> Grade and Step
		<INPUT class="radiol" type="radio" name="RateStep" value="8" <cfif "8" eq get.RateStep>checked</cfif>> Manual
	</TD>
	</TR>
		
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="30">

	<cfif url.id1 eq "">
			
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    	<input class="button10g" type="submit" name="Insert" value=" Save ">
	
	<cfelse>	
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		<cfif get.recordcount eq "0">
	    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
		</cfif>
	    <input class="button10g" type="submit" name="Update" value=" Update ">
	</cfif>
	</td></tr>
	
</TABLE>
	
</CFFORM>

