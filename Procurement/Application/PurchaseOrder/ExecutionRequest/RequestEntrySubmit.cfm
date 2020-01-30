
<!--- assign a modification --->
<cftransaction>
	
	<!--- validate amount --->
	
	<cfparam name="Form.ExecutionId" default="">
	
	<cfif Form.ExecutionId eq "">
		<script>
			alert("No funding selected.")
		</script>
		<CFABORT>
	</cfif>
	
	<cfif not LSIsNumeric(Form.RequestAmount)>
	
		<script>
			alert("Incorrect amouunt.")
		</script>
		<CFABORT>
	
	</cfif>
	
	<cfset amt = replace("#form.requestamount#",",","","ALL")>
	<cfset amt = replace(amt," ","","ALL")>
	
	<cfquery name="Purchase" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM Purchase
		WHERE PurchaseNo = '#Form.PurchaseNo#'	
	</cfquery>
	
	<cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#Purchase.Mission#'
	</cfquery>
	
	<cfif Parameter.ExecutionRequestReferenceCheck eq "1">
		<cfset url.Reference=Form.Reference>
		<cfinclude template="RequestReferenceCheck.cfm">
	</cfif>
	
	<cfquery name="Budget" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   PurchaseExecution
		WHERE  ExecutionId = '#Form.ExecutionId#'	
	</cfquery>
	
	<cfif budget.amount lte "0">
			<script>
			alert("Problem, budget can not be determined.")
		</script>
		<CFABORT>
	   
	</cfif>
	
	<cfquery name="Reserved" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT SUM(RequestAmount) as Amount 
		FROM   PurchaseExecutionRequest
		WHERE  ExecutionId = '#Form.ExecutionId#'	
		AND    ActionStatus != '9'
	</cfquery>
	
	<cfif reserved.amount eq "0" or reserved.amount eq "">
	    <cfset res = 0>
	<cfelse>
	    <cfset res = reserved.amount>  
	</cfif>
	
	<cfif Budget.Amount lt res+amt>
	
		<script>
			alert("Insufficient funds.")
		</script>
		<cfabort>
	
	</cfif>
	
	<cfquery name="Logging" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 INSERT INTO PurchaseExecutionRequest
				  (PurchaseNo,
				   ProgramCode,
				   ExecutionId,
				   RequestId,
				   Period,
				   OrgUnit,
				   Reference,
				   RequestDescription,
				   RequestAmount,
				   Remarks,
				   OfficerUserId, 
				   OfficerLastName, 
				   OfficerFirstName)
		 VALUES   ('#Form.PurchaseNo#',
		           '#Form.ProgramCode#',
		           '#Form.ExecutionId#', 
				   '#Form.RequestId#',
				   '#Form.Period#',
		           '#Form.OrgUnit#', 
				   '#Form.Reference#',
				   '#Form.RequestDescription#', 
				   '#amt#',
				   '#Form.Remarks#',
				   '#SESSION.acc#', 
				   '#SESSION.last#', 
				   '#SESSION.first#'
				   )		
	</cfquery>	
	
	<!--- details --->
	
	<cfquery name="Populate" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    INSERT INTO PurchaseExecutionRequestDetail
				    (RequestId,DetailDescription,DetailReference,DetailQuantity,DetailRate)
	    SELECT      '#Form.RequestId#',
		            DetailDescription,
					DetailReference,
					DetailQuantity,
					DetailRate
	    FROM        userQuery.dbo.#SESSION.acc#ExecutionRequest_#client.sessionNo# 	
	</cfquery>

	
	<cfquery name="Total" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT   SUM(DetailAmount) AS Total
		FROM         PurchaseExecutionRequestDetail
		WHERE        RequestId = '#Form.RequestId#'
	</cfquery>
		
<!----	

	
	<cfif total.total lte "0">
		<cfoutput>
		<script>
			alert("Incorrect amouunt [0]. #Form.RequestAmount#")
		</script>
		</cfoutput>
		<CFABORT>
	
	</cfif>
---->	
	
	<cfquery name="Update" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 UPDATE PurchaseExecutionRequest
			 SET    RequestAmount         = '#Total.Total#'
			 WHERE  RequestId = '#Form.RequestId#'	
	</cfquery>	
	

</cftransaction>

<!--- establish the workflow object --->

<cfset link = "Procurement/Application/PurchaseOrder/ExecutionRequest/RequestEdit.cfm?id=#Form.RequestId#">
	
<cf_ActionListing 
		EntityCode       = "ProcExecution"
		EntityGroup      = "#Form.Workgroup#"
		EntityClass      = "#Form.EntityClass#"
		EntityStatus     = "0"			
		Mission          = "#Purchase.Mission#"
		OrgUnit          = "#Form.OrgUnit#"	
		ObjectReference  = "Execution Request under No #Form.Reference#"
		ObjectReference2 = "#SESSION.first# #SESSION.last#"
		ObjectKey4       = "#Form.RequestId#"
		ObjectURL        = "#link#"
		Show             = "No"
		Toolbar          = "No"
		Framecolor       = "ECF5FF">	 
		
<cfoutput>

    <cfif url.header eq "0">
	
		<script>	
			parent.ptoken.location('#session.root#/Procurement/Application/PurchaseOrder/ExecutionRequest/ViewView.cfm?mission=#Purchase.Mission#&period=#Form.Period#&id=STA&id1=0')
		</script>
	
	<cfelse>

		<script language="JavaScript">

			try {	
				window.dialogArguments.applyfilter('','','content');
			} catch(e) {}   		
			window.close()		
		
		</script>
		
	</cfif>	

</cfoutput>		
