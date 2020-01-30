
<!--- -------------------------------------------------------- --->
<!--- script to stall a job = 8------------------------------- --->
<!--- -------------------------------------------------------- --->

<cftransaction>
	
	<cfquery name="Job" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE  Job
		SET     ActionStatus = '8',
		        ActionDate = getDate(),
				ActionUserId = '#SESSION.acc#'
		WHERE   JobNo = '#Object.ObjectKeyValue1#' 
	</cfquery>
	
	<cfquery name="Lines" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    * 
		FROM      RequisitionLine
		WHERE     RequisitionNo NOT IN (SELECT RequisitionNo 
		                                FROM   PurchaseLine 
										WHERE  ActionStatus < '9')
		AND       JobNo = '#Object.ObjectKeyValue1#' 
	</cfquery>
	
	<cfset st = "9">
		
	<cfloop query="Lines">
	
		<!---  1. update requisition lines --->
		<cfquery name="Update" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE RequisitionLINE
			 SET    ActionStatus    = '#st#' 
			 WHERE  RequisitionNo   = '#RequisitionNo#'
		</cfquery>
								
		<cf_assignId>
						
		<!---  2. enter action --->
		<cfquery name="InsertAction" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO RequisitionLineAction 
					 (RequisitionNo, 
					  ActionId,
					  ActionStatus, 
					  ActionDate,		
					  ActionMemo,						 
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
			 SELECT RequisitionNo, 
			        '#rowguid#',
			        '#st#', 
					getDate(),
					'Cancelled from Job',									
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#'
			 FROM  RequisitionLine
			 WHERE RequisitionNo = '#RequisitionNo#'
		</cfquery>
	
	</cfloop>

</cftransaction>

