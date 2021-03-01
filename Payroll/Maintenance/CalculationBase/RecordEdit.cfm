<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="blue" 
			  bannerforce="blue"
			  jquery="Yes"
			  label="Salary Base" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfparam name="URL.ID1" default="">

<cfquery name="Get"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_CalculationBase
	WHERE Code = '#URL.ID1#'
</cfquery>

<cfquery name="Check"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM SalaryScalePercentage
	WHERE CalculationBase = '#URL.ID1#'
</cfquery>

<cfquery name="Schedule"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM SalarySchedule
</cfquery>


<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cf_divscroll>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- edit form --->

<table width="96%" align="center" class="formpadding formspacing">

	 <cfoutput>

    <tr style="height:40px">
	<td colspan="6">
		
	<table>
    <TR>
    <TD style="padding-left:5px" class="labelmedium2"><cf_tl id="Name">:</TD>
    <TD>
	  <table><tr><td>
  	   <cfinput type="text" name="Code" value="#get.Code#" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxxl">
       <input type="hidden" name="Codeold" value="#get.Code#" class="regular">
	   
	    </td>
		
		<td style="padding-left:3px">
    
	  	   <cfinput type="Text" name="Description" value="#get.Description#" message="please enter a description" required="Yes" visible="Yes" enabled="Yes" showautosuggestloadingicon="True" size="30" maxlength="40" requerided="yes" class="regularxxl">
		  
		  </td></tr>
		  </table>
    </TD>
	</tr>
	
	<tr>
	
    <TD style="padding-left:5px;min-width:90" class="labelmedium2"><cf_tl id="Calculate">:</TD>
    <td width="100%" colspan="2" class="labelit" style="padding-top:3px;border:0px solid silver">
	    <table><tr class="labelmedium2">
		<td style="padding-left:4px"><input type="radio" class="radiol" name="BaseAmount" value="0" <cfif get.baseamount eq 0 or get.baseamount eq "">checked</cfif>></td>
		<td style="width:120px;padding-left:3px;">Payable&nbsp;amount</td>
		<td style="padding-left:9px"><input type="radio" class="radiol" name="BaseAmount" value="2" <cfif get.baseamount eq 2>checked</cfif>></td>
		<td style="width:220px;padding-left:3px;">Contract -/- LWOP</td>
		<td style="padding-left:9px"><input type="radio" class="radiol" name="BaseAmount" value="3" <cfif get.baseamount eq 3>checked</cfif>></td>
		<td style="width:120px;padding-left:3px;">Contract&nbsp;amount</td>
		<td style="padding-left:9px"><input type="radio" class="radiol" name="BaseAmount" value="1" <cfif get.baseamount eq 1>checked</cfif>></td>
		<td style="width:120px;padding-left:3px;">Full&nbsp;entitlement</td></tr>
		</table>
    </td>
	</TR>
	
	</table>
	
	</td></tr>
	
	<cfset cnt = "0">
	
	<cfloop query="schedule">
	
	<cfset cnt = cnt+1>
		
	<cfif cnt eq "1"><TR></cfif>
	
	<td style="padding:1px;border:1px solid silver;width:33%">
	
	<table width="100%" cellspacing="0" cellpadding="0" border="0">
	
	<tr class="line"><td bgcolor="E6E6E6" class="labelmedium2" style="padding:5px">#Description#</td></tr>
	<tr>
				
		<cfquery name="Item"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   DISTINCT R.PayrollItem, 
			         R.PayrollItemName, 
					 R.PrintOrder,
					 C.Period,
			         (SELECT I.Code
					  FROM Ref_CalculationBaseItem I
					  WHERE I.SalarySchedule = '#SalarySchedule#'
					  AND   R.PayrollItem = I.PayrollItem
					  AND   I.Code = '#URL.ID1#') as Code  
			FROM     SalaryScheduleComponent C INNER JOIN
			         Ref_PayrollItem R ON C.PayrollItem = R.PayrollItem 
			WHERE    SalarySchedule = '#SalarySchedule#'			
			AND      R.PaymentMultiplier != '0'			 
			ORDER BY C.Period DESC,R.PrintOrder
		</cfquery>
		
		<cfquery name="Selected"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  PayrollItem
			FROM    Ref_CalculationBaseItem I
		    WHERE   I.SalarySchedule = '#SalarySchedule#'
			AND     I.Code = '#URL.ID1#'
		</cfquery>
				    
	    <TD>
						
 			<cf_UIselect name="PayrollItem_#SalarySchedule#"
			  multiple 			  
			  class="regularxl" 
			  selected="#valueList(Selected.PayrollItem)#"			  
		      value="PayrollItem" 
		      group="Period" 
			  query="#Item#" 
			  display="PayrollItemName" 
			  visible="Yes"/>
		  
					
	    </TD>
	</TR>
	</table>
	</td>
	
	<cfif cnt eq "3">
		<cfset 	cnt = "0">
	</cfif>
	
	</cfloop>
		
	</cfoutput>
	
	<tr><td></td></tr>
	<tr><td colspan="4" class="line"></td></tr>
	<tr><td colspan="4" align="center" height="30">

	<cfif url.id1 eq "">
			
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    	<input class="button10g" type="submit" name="Insert" value=" Save ">
	
	<cfelse>	
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		<cfif check.recordcount eq "0">
	    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
		</cfif>
	    <input class="button10g" type="submit" name="Update" value=" Update ">
	</cfif>
	
	</td></tr>
	
</TABLE>
	
</CFFORM>

</cf_divscroll>
