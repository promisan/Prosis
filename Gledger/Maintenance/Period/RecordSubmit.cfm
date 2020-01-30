
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.Reconcile" default="0">


<cfif ParameterExists(Form.Insert)> 

		<cfquery name="Verify" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Period
			WHERE 
			AccountPeriod  = '#Form.AccountPeriod#' 
		</cfquery>
		
	 <cfif #Verify.recordCount# is 1>
		   
		   <script language="JavaScript">
		   
		     alert("A period with this code has been registered already!")
		     
		   </script>  
  
   <cfelse>
   
      <cfset dateValue = "">
	<CF_DateConvert Value="#DateFormat(Form.PeriodDateStart,CLIENT.DateFormatShow)#">
	<cfset STR = #dateValue#>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#DateFormat(Form.PeriodDateEnd,CLIENT.DateFormatShow)#">
	<cfset END = #dateValue#>

	<cfquery name="Insert" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Period
		         (AccountPeriod,
				 Description,
				 AccountYear,
				 Reconcile,
				 PeriodDateStart,
				 PeriodDateEnd,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		  VALUES ('#Form.AccountPeriod#', 
		          '#Form.Description#',
				  '#Form.AccountYear#',
				  '#Form.Reconcile#',
				  #STR#,
		          #END#,
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
	  </cfquery>
		  
    </cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

    <cfset dateValue = "">
	<CF_DateConvert Value="#DateFormat(Form.PeriodDateStart,CLIENT.DateFormatShow)#">
	<cfset STR = #dateValue#>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#DateFormat(Form.PeriodDateEnd,CLIENT.DateFormatShow)#">
	<cfset END = #dateValue#>

	<cfquery name="Update" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Period
		SET 
		Description           = '#Form.Description#',
		AccountYear           = '#FORM.AccountYear#',
		Reconcile			  = '#Form.Reconcile#',
		PeriodDateStart       = #STR#,
		PeriodDateEnd         = #END#,
		ActionStatus          = '#Form.ActionStatus#'
		WHERE AccountPeriod   = '#Form.AccountPeriod#'
	</cfquery>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

 <cfquery name="CountRec" 
      datasource="AppsLedger" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT AccountPeriod
      FROM TransactionHeader
      WHERE AccountPeriod  = '#Form.AccountPeriod#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		      <script language="JavaScript">
    
	   alert("Period is in use. Operation aborted.")
     
     </script>  
	 
    <cfelse>
		
	<cfquery name="Delete" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM Period WHERE AccountPeriod  = '#Form.AccountPeriod#' 
    </cfquery>
	
	</cfif>
		
</cfif>	

<script language="JavaScript">
     window.close()
	 opener.history.go()
</script>  
