
<!--- get the requisition amount --->

<cfquery name="get" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT *
	FROM   RequisitionLineFunding F, RequisitionLine R
	WHERE  F.FundingId     = '#URL.fundingid#'
	AND    R.RequisitionNo = F.RequisitionNo   
	AND    R.RequisitionNo = '#url.requisitionno#' 
</cfquery>	

<!--- loop through the accounts --->

<cfquery name="accounts" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT *
	FROM   stAccountInfo
	WHERE  Mission      = '#get.Mission#'
	AND    Period       = '#get.Period#'
	AND    AccountFund  = '#get.Fund#'	
</cfquery>		

<cftransaction>

<cfoutput>

	<cfset valinfo = "">

	<cfloop query="accounts">
				
		<cfset info   = evaluate("form.info_#currentrow#")>
		<cfset amount = evaluate("form.amount_#currentrow#")>		
		<cfset amount = replace("#amount#",",","")>
		
		<cfif LSIsNumeric(amount) and amount neq "0">
		
			<cfset valinfo = "#valinfo# #info#">
							
			<cfquery name="check" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			    SELECT *
				FROM   RequisitionLineFundingDetail
				WHERE  RequisitionNo = '#URL.requisitionNo#'  
				AND    FundingId     = '#URL.fundingid#'
				AND    AccountInfo   = '#info#'
			</cfquery>	
			
			<cfif check.recordcount eq "0">
			
			  <cfquery name="Check" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				    SELECT max(detailNo) as Last
					FROM   RequisitionLineFundingDetail F
					WHERE  RequisitionNo = '#URL.RequisitionNo#'
					AND    FundingId = '#URL.fundingid#'
			   </cfquery>		
			   
			   <cfif Check.last neq "">
					<cfset m = check.last+1>
				<cfelse>
				    <cfset m = 1>	
				</cfif>
				
				<cfquery name="Insert" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO RequisitionLineFundingDetail 
				         (RequisitionNo,
						 FundingId,
						 DetailNo,
						 AccountInfo,
						 <!---  AccountMemo, --->
						 Amount,
						 OfficerUserid,
						 OfficerLastName,
						 OfficerFirstName)
				      VALUES 
					  	( '#URL.RequisitionNo#',
					  	  '#URL.FundingId#',
					      '#m#',
						  '#info#',
						  <!---  '#url.memo#', --->
						  '#amount#',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#')
				</cfquery>			
							
			<cfelse>
			
				<cfquery name="update" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				    UPDATE RequisitionLineFundingDetail
					SET    Amount           = '#amount#',
						   OfficerUserid    = '#session.acc#',
						   OfficerLastName  = '#session.last#',
						   OfficerFirstName = '#session.first#',
						   Created          = getDate()
					WHERE  RequisitionNo = '#URL.requisitionNo#'  
					AND    FundingId     = '#URL.fundingid#'
					AND    AccountInfo   = '#info#'
				</cfquery>	
						
			</cfif>
					
		<cfelse>
		
			<cfquery name="delete" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			    DELETE FROM RequisitionLineFundingDetail
				WHERE  RequisitionNo = '#URL.requisitionNo#'  
				AND    FundingId     = '#URL.fundingid#'
				AND    AccountInfo   = '#valinfo#'
			</cfquery>	
				
		</cfif>
					
	</cfloop>
	
	<cfquery name="InsertAction" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO RequisitionLineAction 
				 (RequisitionNo, 
				  ActionStatus, 
				  ActionDate, 
				  ActionMemo,
				  ActionContent,
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName) 
	     VALUES ('#URL.requisitionNo#', 
		         '2f', 
				  getDate(), 
				 'Set IMIS funding account',
				 '#valinfo#',
				 '#SESSION.acc#', 
				 '#SESSION.last#', 
				 '#SESSION.first#')
	</cfquery>

</cfoutput>

</cftransaction>

<script language="JavaScript">
    returnValue = 3
	window.close()	
</script>
