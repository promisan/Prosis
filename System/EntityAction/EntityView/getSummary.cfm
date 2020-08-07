
<!--- full summary --->
<cf_myClearancesPrepare mode="table" role="1">

<cfquery name="getAction" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT     OA.ActionId
	 FROM       OrganizationObjectAction OA 
	            INNER JOIN    OrganizationObject O                ON OA.ObjectId  = O.ObjectId 
				INNER JOIN    userQuery.dbo.#SESSION.acc#Action D  ON OA.ActionId  = D.ActionId 
				INNER JOIN    Ref_Entity E                        ON O.EntityCode = E.EntityCode 
				INNER JOIN    Ref_EntityActionPublish P           ON OA.ActionPublishNo = P.ActionPublishNo AND OA.ActionCode = P.ActionCode 				
	 WHERE      P.EnableMyClearances = 1 
	  AND       O.ObjectStatus = 0
	  AND       O.Operational = 1  
	  AND       E.ProcessMode != '9'		
	  <!--- hide concurrent actions that were completed --->
	  AND       OA.ActionStatus != '2'		  	 
</cfquery>

<cfquery name="Roles" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_AuthorizationRole
	WHERE    Role IN ('ProcReqCertify','ProcReqObject','ProcReqReview','ProcReqApprove','ProcReqBudget','ProcManager','ProcBuyer')	
	ORDER BY ListingOrder
</cfquery>	

<cfset tot = 0>

<cfloop query="Roles">
	
	<cfinvoke component = "Service.PendingAction.Check"  
	   	method           = "#Role#"
	   	returnvariable   = "batch">
			
	<cfquery name="getBatch" dbtype="query">
		SELECT   SUM(Total) as Total
		FROM     batch
	</cfquery>	
				
	<cfif getBatch.total neq "">			
		<cfset tot = tot+getBatch.Total>
	</cfif>

</cfloop>

<!--- presentation --->

<cfif getAction.recordcount eq "0">
	<cfset cl = "##59C25B">
<cfelse>
	<cfset cl = "##EF5555">
</cfif>

<cfoutput>

	<div style="color:#cl#">
	
	 <table style="border:0px solid silver;font-size:20px">
		<tr>		
		<td style="color:#cl#;font-size:20px">
		<cfif getAction.recordcount eq "0"><cf_tl id="No"> <cfelse>#getAction.recordcount#</cfif>
		<cfif getAction.recordcount eq "1"><cf_tl id="action"><cfelse><cf_tl id="actions"></cfif><cf_tl id="and">
		<cfif tot eq "0"><cf_tl id="No"><cfelse>#tot#</cfif>
		<cfif tot eq "1"><cf_tl id="Batch clearance"><cfelse><cf_tl id="Batch clerances"></cfif>
		</td>
	</tr>	
	</table>
	
	</div>
	<div>
	    <table style="border:0px solid silver;font-size:18px">
		<tr>		
		<td>
		<cf_tl id="Refresh your view to reflect recent updates"> (#timeformat(now(),"HH:MM:SS")#)
		</td>
		</tr>	
		</table>
	</div>

</cfoutput>
