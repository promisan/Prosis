
<!--- ceiling save --->

<cf_tl id="Incorrect ceiling amount" var="1">

<cfif url.amount eq "">
	 <cfabort>
</cfif>

<cfset amt = replace("#url.amount#"," ","","ALL")>
<cfset amt = replace("#amt#",",","","ALL")>

<cfif not LSIsNumeric(amt)>
	<cfoutput>
	<script>
		alert("#lt_text# (#amt#)")
	</script>
	</cfoutput>
	<CFABORT>

</cfif>

<cfquery name="Edition" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_AllotmentEdition
	WHERE    EditionId = '#URL.EditionId#'
</cfquery>

<cfquery name="Parameter" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#Edition.Mission#'
</cfquery>

<cfquery name="Check" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT * 
  FROM   ProgramAllotment
  WHERE  ProgramCode  = '#URL.ProgramCode#'
  AND    Period       = '#URL.Period#'
  AND    EditionId    = '#URL.EditionId#' 
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="INSERT" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO ProgramAllotment
                      (ProgramCode, 
					   Period, 
					   EditionId, 					   					 
					   OfficerUserId, 
					   OfficerLastName, 
					   OfficerFirstName)
	VALUES     ('#url.programcode#',
	            '#url.period#',
				'#url.editionid#',							
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')
	</cfquery>			

</cfif>

<cfquery name="Check" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT * 
  FROM   ProgramAllotmentCeiling
  WHERE  ProgramCode  = '#URL.ProgramCode#'
  AND    Period       = '#URL.Period#'
  AND    EditionId    = '#URL.EditionId#'
  AND    Resource     = '#URL.Resource#'  
</cfquery>


<cfif Check.recordcount eq "1">

	<cfquery name="UPDATE" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  UPDATE ProgramAllotmentCeiling
	  SET    Currency = '#APPLICATION.BaseCurrency#', 
	         <cfif Parameter.BudgetAmountMode eq "0">
			 Amount = #amt# 
			 <cfelse>
	         Amount = #amt*1000#  
			 </cfif>
	  WHERE  ProgramCode  = '#URL.ProgramCode#'
	  AND    Period       = '#URL.Period#'
	  AND    EditionId    = '#URL.EditionId#'
	  AND    Resource     = '#URL.Resource#'  
	</cfquery>

<cfelse>

	<cfquery name="INSERT" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO ProgramAllotmentCeiling
                      (ProgramCode, 
					   Period, 
					   EditionId, 
					   Resource, 
					   Currency, 
					   Amount, 
					   OfficerUserId, 
					   OfficerLastName, 
					   OfficerFirstName)
	VALUES     ('#url.programcode#',
	            '#url.period#',
				'#url.editionid#',
				'#url.resource#',
				'#APPLICATION.BaseCurrency#',
				<cfif Parameter.BudgetAmountMode eq "0">
				'#amt#',
				<cfelse>
				'#amt*1000#',
				</cfif>
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')
	</cfquery>			

</cfif>


<cfquery name="Ceiling" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT * 
  FROM   ProgramAllotmentCeiling
  WHERE  ProgramCode  = '#URL.ProgramCode#'
  AND    Period       = '#URL.Period#'
  AND    EditionId    = '#URL.EditionId#'
  AND    Resource     = '#URL.Resource#'  
</cfquery>

<cfquery name="Budget" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    SUM(Amount) AS Total
	FROM      ProgramAllotmentDetail
	WHERE     ProgramCode  = '#URL.ProgramCode#'
	  AND     Period       = '#URL.Period#'
	  AND     EditionId    = '#URL.EditionId#'
	  AND     ObjectCode IN
                          (SELECT    Code
                            FROM     Ref_Object
                            WHERE    Resource = '#URL.Resource#')
</cfquery>

<cfoutput>

				
<cfif Ceiling.Amount lt Budget.Total and Budget.Total neq "" and Ceiling.Amount gt 0>

      <script>	
	    	  
		  se = document.getElementsByName("b#url.editionid#_#url.resource#")
		  count = 0
		  while (se[count]) {
		      se[count].className = "highlight5"
			  count++
		  }		  
		  ptoken.navigate('AllotmentClear.cfm?programcode=#url.programcode#&period=#url.period#&editionid=#url.editionid#','box#url.editionid#')		 	  
		  
	  </script>
	 
<cfelse>

	 <script>
	 
		  se = document.getElementsByName("b#url.editionid#_#url.resource#")
		  count = 0	 
		  while (se[count]) {	     
		      se[count].className = "regular"
			  count++
		  }	 
		  ptoken.navigate('AllotmentClear.cfm?programcode=#url.programcode#&period=#url.period#&editionid=#url.editionid#','box#url.editionid#')		   
		  
	  </script>
	 	  	
</cfif>	

</cfoutput>