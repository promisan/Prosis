
<!--- saving --->

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset DTE = dateValue>

<!--- remove todays entries --->

<cfquery name="Delete" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		DELETE FROM   FunctionBucketForecast
		WHERE  BucketId        = '#url.bucketid#'		
		AND    Mission         = '#url.mission#'		
		AND    RuleCode        = '#url.rule#'
		AND    TransactionDate = #dte#		
		AND    Source          = 'Manual'
		AND    Created > getDate()-1	
</cfquery>	

<cfquery name="Current" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT sum(TransactionQuantity) as TransactionQuantity
		FROM   FunctionBucketForecast
		WHERE  BucketId        = '#url.bucketid#'		
		AND    Mission         = '#url.mission#'		
		AND    RuleCode        = '#url.rule#'
		AND    Source          = 'Manual'
		AND    TransactionDate = #dte#			
</cfquery>	

<cfif Current.TransactionQuantity eq "">
    <cfset cur = 0>
<cfelse>
	<cfset cur = Current.TransactionQuantity>  
</cfif>

<cfif url.quantity neq cur>

	<cfset diff = url.quantity - cur> 

	<cfquery name="Insert" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		INSERT INTO FunctionBucketForecast
			(BucketId,
			 RuleCode,
			 Mission,
			 TransactionType,
			 TransactionDate,
			 TransactionQuantity,
			 Source,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
		VALUES
		  ('#url.bucketid#',
		   '#url.rule#',
		   '#url.mission#',
		   '1',
		   #dte#,
		   '#diff#',
		   'Manual',
		   '#SESSION.acc#',
		   '#SESSION.last#',
		   '#SESSION.first#')			
	</cfquery>	

</cfif>

Updated