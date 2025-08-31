<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfquery name="Funding" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   RequisitionLineFunding
	WHERE  FundingId = '#url.fundingid#'
</cfquery>	

<cfquery name="get" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   RequisitionLine
	WHERE  RequisitionNo = '#Funding.RequisitionNo#'
</cfquery>	

<cfset amount = Funding.Percentage * get.RequestAmountBase>

<cfif url.percentage eq "">
	<cfset percent = 0>
<cfelse>
	<cfset percent = url.percentage>	
</cfif>

<cfset percent = percent/100>

<cfif not LSIsNumeric(percent)>
	
	<script>
	    alert('Incorrect value')
	</script>	 		
	<cfabort>
	
</cfif>

<cfquery name="get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">			
	SELECT   *			  
	FROM     RequisitionLineFundingActivity
	WHERE    FundingId  = '#url.fundingid#'
	AND      ActivityId = '#url.activityid#'	
</cfquery>		

<!--- check if the total is above 100% --->

<cfif get.recordcount eq "0">

	<cfquery name="insert" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
		INSERT INTO RequisitionLineFundingActivity

			(RequisitionNo,
			 FundingId,
			 ActivityId,
			 Percentage,
			 Created)
			 
		VALUES (

			'#url.requisitionno#',
			'#url.fundingid#',
			'#url.activityid#',
			'#percent#',
			getDate()
			)
	</cfquery>	
	
	<cfset amt = amount * percent>
	
	<cfoutput>#numberformat(amt,",_.__")#</cfoutput>	

<cfelse>

    <cfquery name="update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
		UPDATE   RequisitionLineFundingActivity
		SET      Percentage = '#percent#'
		WHERE    FundingId = '#url.fundingid#'
		AND      ActivityId = '#url.activityid#'	
	</cfquery>	
	
	<cfset amt = amount * percent>
	
	<cfoutput>#numberformat(amt,",_.__")#</cfoutput>		

</cfif>

<cfquery name="update" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
		DELETE FROM RequisitionLineFundingActivity
		WHERE    FundingId = '#url.fundingid#'
		AND      ActivityId NOT IN (SELECT ActivityId FROM Program.dbo.ProgramActivity WHERE ProgramCode = '#Funding.ProgramCode#')	
	</cfquery>	

<cfquery name="check" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">			
	SELECT   SUM(Percentage) as Percentage			  
	FROM     RequisitionLineFundingActivity
	WHERE    RequisitionNo = '#url.requisitionno#'
	AND      FundingId  = '#url.fundingid#'	
</cfquery>		

<cfif check.percentage eq "">				
 	<cfset amt = 0>				
<cfelse>
	<cfset amt = amount * check.percentage>	
</cfif>	

<cfif check.percentage neq 1>
	<cfset cl = "red">	
<cfelse>
	<cfset cl = "black">	
</cfif>

<cfoutput>
	
	<script>
	
	 document.getElementById('activitytotal').innerHTML = "<font color='#cl#'>#numberformat(amt,",_.__")#</font>"
	
	</script>

</cfoutput>




