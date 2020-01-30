
<cfquery name="Check" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			   SELECT * 
			   FROM   RequisitionLine	   
			   WHERE  RequisitionNo      = '#URL.ID#'			  	
</cfquery>

<cfif Check.recordcount eq "0">

		<script>
		    alert('Requisition no longer exists. Please create a new requisition.')						
		</script>	
		 
		<cfabort>

</cfif>



<cfoutput>

	<cfparam name="url.acc"     default="">
	<cfparam name="url.amount"  default="1">
	<cfparam name="url.memo"    default="">
	
	<cfset amount = replaceNoCase(url.amount,",","","ALL")>
		
	<cfif not LSIsNumeric(amount)>
	
		<cfset url.id2 = ""> 	
		<cfinclude template="FundingDetail.cfm">	
		
		<script>
		    alert('Incorrect Amount')
		</script>	 
		
		<cfabort>
					
	</cfif>
		
	<cfif URL.ID2 neq "new">	
					  					
		 <cfquery name="Update" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			   UPDATE RequisitionLineFundingDetail 
			   SET    AccountInfo        = '#url.acc#',
			          AccountMemo        = '#url.memo#',
			          Amount             = '#amount#',
					  OfficerUserid      = '#session.acc#',
					  OfficerLastName    = '#session.last#',
					  OfficerFirstName   = '#session.first#',
					  Created            = getDate()				  					   
			   WHERE  RequisitionNo      = '#URL.ID#'
			   AND    FundingId          = '#URL.FundingID#'		
			   AND    DetailNo           = '#url.id2#'
	   	</cfquery>			
	
	<cfelse>
	
		  <cfquery name="Check" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		    SELECT MAX(DetailNo) as Last
			FROM   RequisitionLineFundingDetail F
			WHERE  RequisitionNo = '#URL.ID#'
			AND    FundingId     = '#URL.fundingid#'
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
					 AccountInfo ,
					 AccountMemo,
					 Amount,
					 OfficerUserid,
					 OfficerLastName,
					 OfficerFirstName)
			      VALUES 
				  	('#URL.ID#',
				  	  '#URL.FundingId#',
				      '#m#',
					  '#url.acc#',
					  '#url.memo#',
					  '#amount#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
			</cfquery>		
					
	</cfif>
	
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
	     VALUES ('#URL.ID#', 
		         '2f', 
				  getDate(), 
				 'Set IMIS funding account',
				 '#url.acc# #url.memo#',
				 '#SESSION.acc#', 
				 '#SESSION.last#', 
				 '#SESSION.first#')
	</cfquery>
	
	 <cfset url.id2 = ""> 	
	 <cfinclude template="FundingDetail.cfm">						   
	
</cfoutput>