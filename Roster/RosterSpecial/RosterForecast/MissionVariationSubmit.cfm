<!--
    Copyright © 2025 Promisan

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