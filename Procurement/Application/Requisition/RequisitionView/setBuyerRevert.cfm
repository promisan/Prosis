
<cftransaction>

<!--- check if purchase exists --->

<!--- 1. do not allow if PO exists --->
					 
<cfquery name="CheckStatus" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM PurchaseLine 
	WHERE RequisitionNo = '#URL.id#'
</cfquery>

<cfif CheckStatus.recordcount eq "1">
	<font color="red">It seems the line was already processed</font>
	<cfabort>
</cfif>

<!--- 2. check if job and/or quote exists which needs to be reverted
					 so the buyer can make this job for himsefl --->

<cfquery name="get" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   RequisitionLine 
		WHERE  RequisitionNo = '#URL.id#'
</cfquery>

<cfif get.JobNo neq "">
		
	<cfquery name="get" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  * 
		FROM    JobActor 
		WHERE   JobNo = '#get.JobNo#'
		AND     ActorUserId = '#url.actoruserid#'
		AND     Role = 'ProcBuyer'
	</cfquery>
			
	<cfif get.recordcount gte "1">
			
		<cfquery name="Clean" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM RequisitionLineQuote	
			WHERE  RequisitionNo = '#URL.id#'
		</cfquery>		
		
		<cfquery name="ResetJob" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE RequisitionLine
			SET    JobNo = NULL
			WHERE  RequisitionNo = '#URL.id#'
		</cfquery>		
	
	</cfif>		

</cfif>

<!--- 3. remove buyer and if this is the only buyer left then we reset this to assignment again --->

<cfquery name="Clear" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM RequisitionLineActor
	WHERE  RequisitionNo = '#URL.id#'
	AND    Role          = 'ProcBuyer'
	AND    ActorUserId   = '#url.actoruserid#'
</cfquery>		

<cfquery name="check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   RequisitionLineActor
	WHERE  RequisitionNo = '#URL.id#'
	AND    Role = 'ProcBuyer'	
</cfquery>		

<cfif check.recordcount eq "0">
	
	<cfquery name="Update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE RequisitionLine
		SET    ActionStatus  = '2i'
		WHERE  RequisitionNo = '#URL.id#'
	</cfquery>	
		
	<cf_assignId>
	
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
     VALUES ('#URL.id#', 
	         '#rowguid#',
	         '2i', 
			 getdate(), 
			 'Reverted to Buyer assignment',
			 '#SESSION.acc#', 
			 '#SESSION.last#', 
			 '#SESSION.first#')
	</cfquery>	

</cfif>		

</cftransaction>	

<font color="2F97FF"><b>removed</font>

