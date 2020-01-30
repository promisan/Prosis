
<cfquery name="Parameter" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT     *
	  FROM       Ref_ParameterMission
	  WHERE      Mission = '#Form.Mission#'	   
</cfquery>

<cfquery name="getTransactions" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT     *
	    FROM       ProgramAllotmentDetail
		WHERE      ProgramCode = '#Form.Program#'	   
	 	AND        EditionId   = '#Form.edition#'
		AND        Period      = '#Form.period#'
		AND        Status      = '0'		
		AND        Amount <> 0		
		ORDER BY   TransactionId
</cfquery>

<cfset ids = "">
<cfset amt   = 0>
<cfset den   = 0>
<cfset show  = "No">

<cfloop query="getTransactions">

	<cfset traid = replaceNoCase(transactionid,"-","","ALL")> 

	<cfparam name="Form.Decision_#traid#" default="0">
	
	<cfset de  = Evaluate("Form.Decision_#traid#")>
			
	<cfif de eq "1">	
				
		<cfif traid eq "">
		   	<cfset ids = "#transactionid#">
		<cfelse>
			<cfset ids = "#ids#,#transactionid#">
		</cfif>
		
		<cfset amt = amt + amount>
		
		<cfset show = "Yes">			
				
	</cfif>	
	
	<cfif de eq "9">
			
		<cfset den = den + amount>
		
	</cfif>	
	
</cfloop>

<cfif den eq "0" and show eq "No">

	<script>
		document.getElementById('submitbox').className='hide'
	</script>

<cfelse>

	<script>
		document.getElementById('submitbox').className='regular'
	</script>
	
	<cfoutput>
	
	  	<font size="3" color="green">#numberformat(amt,"__,__.__")#</font> <cfif den neq "0"><font  size="3" color="FF0000">#numberformat(den,"__,__.__")#</font></cfif>
	 	  
	  <cfif Parameter.EnableDonor eq "1">
	
		<!--- show donor amounts --->
	
		<script>
		   ColdFusion.navigate('DonorAllocationViewLines.cfm?datamode=all&transactionid=#ids#','amountdonor')
		</script> 
		
	  </cfif>	
		
	</cfoutput>	

</cfif>	

<!---
- Show the total of the allocation action (cleared, denied)
- Show the summary of the donor funding associated to the total 
--->