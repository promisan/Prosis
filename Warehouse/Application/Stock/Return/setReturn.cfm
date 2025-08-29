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
<!--- set the return --->
<!--- -------------- --->

<cfset return = 0>

<cfset stg = evaluate("form.loc_#left(transactionid,8)#")>	
<cfloop index="loc" list="#stg#">
	
	<cfparam name="form.loc_#left(url.transactionid,8)#_#left(loc,8)#" default="">
		
	<cfset val = evaluate("form.loc_#left(url.transactionid,8)#_#left(loc,8)#")>
	
	<cftry>			
		<cfset return = return+val>
	<cfcatch></cfcatch>
	</cftry>
	
</cfloop>

<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  SUM(TransactionQuantity) as Total
		FROM    ItemTransaction
	    WHERE   Mission = '#url.mission#'
		AND     TransactionType IN ('1','3')	
		AND     ReceiptId IN (
				    SELECT     ReceiptId
				    FROM       ItemTransaction 
				    WHERE      TransactionId  = '#url.TransactionId#' 				
			    )			
</cfquery>

<cfif get.Total gte return>
	<cfoutput>#return#</cfoutput>
<cfelse>
    <cfoutput><font color="FF0000"><cf_tl id="invalid"></font></cfoutput>
</cfif>
