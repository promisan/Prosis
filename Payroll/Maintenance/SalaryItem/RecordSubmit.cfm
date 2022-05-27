
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.ExpirationPayment" default="1">
<cfparam name="Form.SalaryDays" default="0">

<cfif ParameterExists(Form.Insert)> 
	
	<cfquery name="Verify"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_PayrollItem
		WHERE PayrollItem = '#Form.PayrollItem#'	
	</cfquery>

   <cftransaction>

	   <cfif Verify.recordCount is 1>
	   
	   		<script language="JavaScript">
	   		     alert("A record with this code has been registered already!")     
			</script>  
	  
	   <cfelse>      
			
			<cfquery name="Insert" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_PayrollItem
			         (PayrollItem,
					  PayrollItemName,
					  EntityClass,
					  Source, 
					  AllowOverlap,
					  PaymentMultiplier, 
					  Settlement,
					  SettlementMonth,
					  ExpirationPayment, 
					  PayrollItemMemo,
					  PrintOrder,
					  PrintGroup,
					  PrintDescription,
					  PrintDescriptionLong,
					  AllowSplit,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
			  VALUES ('#Form.PayrollItem#',
	        		  '#Form.PayrollItemName#',
					  '#Form.EntityClass#',
					  '#Form.Source#',
					  '#Form.AllowOverlap#',
					  '#Form.PaymentMultiplier#',
					  '#Form.Settlement#',
					  '#Form.MonthPayment#',
					  '#Form.ExpirationPayment#',
					  '#Form.PayrollItemMemo#',
					  '#Form.PrintOrder#',
					  '#Form.PrintGroup#',
					  '#Form.PrintDescription#',
					  '#Form.PrintDescriptionLong#',
					  '#Form.AllowSplit#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
			  </cfquery>
			  
			  <cf_LanguageInput
				TableCode       = "Ref_PayrollItem" 
				Mode            = "Save"
				DataSource      = "AppsPayroll"
				Key1Value       = "#Form.PayrollItem#"
				Name1           = "PayrollItemName">
				
			  <cf_LanguageInput
				TableCode       = "Ref_PayrollItem" 
				Mode            = "Save"
				DataSource      = "AppsPayroll"
				Key1Value       = "#Form.PayrollItem#"
				Name1           = "PrintDescription">
				
			  <cf_LanguageInput
				TableCode       = "Ref_PayrollItem" 
				Mode            = "Save"
				DataSource      = "AppsPayroll"
				Key1Value       = "#Form.PayrollItem#"
				Name1           = "PrintDescriptionLong">
			  
			  <cfoutput>
				<script>
		        	window.location = 'RecordEditTab.cfm?id1=#Form.PayrollItem#&idMenu=#url.idmenu#';
					opener.history.go();
				</script> 
			  </cfoutput>
			     		  
	    </cfif>		
	
	</cftransaction>
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<cftransaction>
	
	<cfquery name="Update" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_PayrollItem
		SET PayrollItemName      = '#Form.PayrollItemName#',
			Source               = '#Form.Source#', 
			EntityClass          = '#Form.EntityClass#',
			PaymentMultiplier    = '#Form.PaymentMultiplier#', 
			Settlement           = '#Form.Settlement#',
			SettlementMonth      = '#Form.MonthPayment#',
			AllowOverlap         = '#Form.AllowOverlap#',
			ExpirationPayment    = '#Form.ExpirationPayment#', 
			PrintOrder           = '#Form.PrintOrder#',
			PayrollItemMemo      = '#Form.PayrollItemMemo#',
			PrintGroup           = '#Form.PrintGroup#',
			PrintDescription     = '#Form.PrintDescription#',
			PrintDescriptionLong = '#Form.PrintDescriptionLong#',
			AllowSplit           = '#Form.AllowSplit#',
			Operational          = '#form.Operational#'
		WHERE PayrollItem        = '#Form.PayrollItemOld#'
	</cfquery>
	
	<cf_LanguageInput
		TableCode       = "Ref_PayrollItem" 
		Mode            = "Save"
		DataSource      = "AppsPayroll"
		Key1Value       = "#Form.PayrollItem#"
		Name1           = "PayrollItemName">
		
	  <cf_LanguageInput
		TableCode       = "Ref_PayrollItem" 
		Mode            = "Save"
		DataSource      = "AppsPayroll"
		Key1Value       = "#Form.PayrollItem#"
		Name1           = "PrintDescription">
		
	  <cf_LanguageInput
		TableCode       = "Ref_PayrollItem" 
		Mode            = "Save"
		DataSource      = "AppsPayroll"
		Key1Value       = "#Form.PayrollItem#"
		Name1           = "PrintDescriptionLong">
	
	<cfoutput>
	
	    <cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
        <cfset mid = oSecurity.gethash()/>   

		<script>
		   // opener.history.go();		   
        	window.location = 'RecordEditTab.cfm?id1=#Form.PayrollItem#&idMenu=#url.idmenu#&mid=#mid#';			
		</script> 
	</cfoutput>
	
	</cftransaction>
	
</cfif>	
