<HTML><HEAD>
	<TITLE>Parameters - Edit Form</TITLE>
</HEAD><body bgcolor="#FFFFFF" leftmargin="3" topmargin="3" rightmargin="3" bottommargin="3">
 <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
 
<cfinclude template="Insertdata.cfm">

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Parameter 
</cfquery>

<cfquery name="Period" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Period 
	WHERE  ActionStatus = '0'
</cfquery>

<cfquery name="Currency" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM Currency
</cfquery>

<script language="JavaScript">

	function save() {
	    document.parameter.submit()
	}

</script>

<cf_divscroll>

<cfset Page         = "0">
<cfset add          = "0">
<cfset Header       = "Parameters">
<cfinclude template = "../HeaderMaintain.cfm"> 

<cfform action="ParameterSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="parameter">

<table width="94%" cellspacing="0" cellpadding="0" align="center">

	<tr><td height="3" colspan="1"></td></tr>
	
	 <!--- Field: Currency --->
    <tr class="labelmedium">
    <td width="200">Enterprise base Currency:</td>
    <td align="left">
	
	  <table><tr class="labelmedium"><td>
	  <cfselect name="BaseCurrency"
          tooltip="Please do not change unless instruction by  vendor"
          visible="Yes"
          enabled="Yes"
		  class="regularxl"
          onchange="javascript:save()">
   		    <cfoutput query="Currency">
        	<option value="#Currency#" <cfif Currency is #Get.BaseCurrency#>selected</cfif>>#Currency#</option>
         	</cfoutput>
	      </cfselect>
		  </td>		  
		
		  <td style="padding-left:10px">Attention:</td>
		 		  
		  <td style="padding-left:10px"><font color="red"><b>Change</b> the base currency ONLY after you verified this with Promisan b.v. Once a base currency is set it can not be changed without data fixes.</td>
		  
		 </td></tr></table> 
	
    </td>
	</tr>
	
	<tr><td colspan="2" class="line"></td></tr>
		
	<cfquery name="MissionSelect" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission IN (SELECT Mission 
						   FROM   Organization.dbo.Ref_MissionModule 
						   WHERE  SystemModule = 'Accounting')
	</cfquery>
	
	<tr><td colspan="2">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
	
	<tr class="line labelmedium">
		<td>Entity</td>
		<td>Administration level</td>
		<td>Default Period</td>
		
				
		<!--- the field below is not enabled but can be used to disable PersonAccount creation --->
		
		<td style="cursor: help;">
		<cf_UItooltip tooltip="Generates an employee account for each employee as recorded in the Staffing table with an active assignment">Employee Account</cf_UItooltip>
		</td>
		<td>Tax Exemption</td>
		
		<td>Presentation Amount format</td>
	</tr>
	
	<cfoutput query="MissionSelect">
	
		<tr class="line navigation_row labelmedium">
		
			<td>#Mission#</td>
			<td>
			    <input type="radio" name="#Mission#_AdministrationLevel" value="tree" onClick="javascript:save()" <cfif MissionSelect.AdministrationLevel is "tree">checked</cfif>>
				Entity
				<input type="radio" name="#Mission#_AdministrationLevel" value="Parent" onClick="javascript:save()" <cfif MissionSelect.AdministrationLevel is "Parent">checked</cfif>>
				Parent Unit
		    </td>
			<td>
			
			<!--- auto adjust if the period is closed --->
			
			<cfquery name="CheckOpen" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   Ref_ParameterMission
				WHERE  Mission = '#Mission#'
				AND    CurrentAccountPeriod IN (SELECT AccountPeriod 
				                                FROM   Period 
												WHERE  ActionStatus = '0')	
			</cfquery>
			
			<cfif CheckOpen.recordcount eq "0">
			
				<cfquery name="Update" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE Ref_ParameterMission
					SET   CurrentAccountPeriod = '#Period.AccountPeriod#',
						OfficerUserId 	 = '#SESSION.ACC#',
						OfficerLastName  = '#SESSION.LAST#',
						OfficerFirstName = '#SESSION.FIRST#',
						Created          =  getdate()
					WHERE  Mission = '#Mission#'			
				</cfquery>		
			
			</cfif>
			
			  <select name="#Mission#_currentaccountperiod" class="regularxl" onChange="save()">
		   		    <cfloop query="Period">
		        	<option value="#AccountPeriod#" <cfif AccountPeriod is MissionSelect.CurrentAccountPeriod>selected</cfif>>
					#AccountPeriod#
					</option>
		         	</cfloop>
			  </select>
				  
		    </td>
			
			<td>
			    <input type="radio" name="#Mission#_EmployeeAccount" value="1" onClick="save()" <cfif MissionSelect.EmployeeGLAccount is "1">checked</cfif>>
				Yes
				<input type="radio" name="#Mission#_EmployeeAccount" value="0" onClick="save()" <cfif MissionSelect.EmployeeGLAccount is "0">checked</cfif>>
				No
		    </td>
			
			<td>
			    <input type="radio" name="#Mission#_TaxExemption" value="1" onClick="save()" <cfif MissionSelect.TaxExemption is "1">checked</cfif>>
				Yes
				<input type="radio" name="#Mission#_TaxExemption" value="0" onClick="save()" <cfif MissionSelect.TaxExemption is "0">checked</cfif>>
				No
		    </td>
			
			<td>
			    <input type="radio" name="#Mission#_AmountPresentation" value="1" onClick="save()" <cfif MissionSelect.AmountPresentation is "1">checked</cfif>>
				0,000,00
				<input type="radio" name="#Mission#_AmountPresentation" value="2" onClick="save()" <cfif MissionSelect.AmountPresentation is "2">checked</cfif>>
				0,000
				<input type="radio" name="#Mission#_AmountPresentation" value="3" onClick="save()" <cfif MissionSelect.AmountPresentation is "3">checked</cfif>>
				0.0
		    </td>
				
		</tr>
			
	</cfoutput>
	
</table>

</cfform>

<cf_divscroll>

