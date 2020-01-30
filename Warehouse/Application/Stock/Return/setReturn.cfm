
<!--- -------------- --->
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
