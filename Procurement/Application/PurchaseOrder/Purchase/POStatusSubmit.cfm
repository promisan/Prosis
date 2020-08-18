<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
	
<cftransaction>

    <cfswitch expression="#Form.StatusAction#">
	
	<cfcase value="3">

		<cfquery name="Update" 
		   datasource="AppsPurchase" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   UPDATE Purchase
		   SET    ActionStatus = '3',
		   	      OrderDate = '#DateFormat(now(), CLIENT.DateSQL)#'
		    WHERE PurchaseNo = '#URL.ID1#' 
		</cfquery>
		
		<cfif Form.StatusAction neq Form.ActionStatusOld>
		
			<!---  3. enter action --->
			<cfquery name="InsertAction" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO PurchaseAction 
				 (PurchaseNo, ActionStatus, ActionDate, OfficerUserId, OfficerLastName, OfficerFirstName) 
				 VALUES ('#URL.ID1#', '3', getDate(), '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#')
			</cfquery>
		
		</cfif>
	
	</cfcase>
	
	<!--- return to buyer to update PO information --->
	
	<cfcase value="1">

		<cfquery name="Update" 
		   datasource="AppsPurchase" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   UPDATE  Purchase
		   SET     ActionStatus = '0',
		           OrderDate = NULL
		   WHERE   PurchaseNo = '#URL.ID1#' 
		</cfquery>
		
		<cfif Form.StatusAction neq Form.ActionStatusOld>
		
			<!---  3. enter action --->
			<cfquery name="InsertAction" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO PurchaseAction 
				 (PurchaseNo, ActionStatus, ActionDate, OfficerUserId, OfficerLastName, OfficerFirstName) 
				 VALUES ('#URL.ID1#', '7', getDate(), '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#')
			</cfquery>
		
		</cfif>
	
	</cfcase>
	
	<!--- remove purchase order and send requisition back to the requisitioner --->
	
	<cfcase value="0">
	
		<!--- keeps the link to the job --->
	
	    <cfquery name="Reset" 
		   datasource="AppsPurchase" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   UPDATE RequisitionLine
		   SET    ActionStatus = '1'
		   WHERE  RequisitionNo IN (SELECT RequisitionNo 
		                            FROM   PurchaseLine 
									WHERE  PurchaseNo = '#URL.ID1#')
		</cfquery>		
			
		<!---  3. enter action --->
		<cfquery name="InsertAction" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO RequisitionLineAction 
			        (RequisitionNo, ActionStatus, ActionDate, OfficerUserId, OfficerLastName, OfficerFirstName) 
			 SELECT RequisitionNo, '7', getDate(), '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#'
			 FROM   PurchaseLine WHERE PurchaseNo = '#URL.ID1#'
		</cfquery>
				
		<cfquery name="Delete" 
		   datasource="AppsPurchase" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   DELETE Purchase
		   WHERE  PurchaseNo = '#URL.ID1#' 
		</cfquery>
		
		<script language="JavaScript">
	 
	       alert("Purchase order has been revoked.")
		   window.close()
		   opener.history.go()
	   					 
		</script>

	</cfcase>
	
	</cfswitch>
	
</cftransaction>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfoutput>

	<script language="JavaScript">	 
	   window.location = "POView.cfm?mid=#mid#&header=#url.header#&ID1=#URL.ID1#&Mode=view"						 
	</script>

</cfoutput>
