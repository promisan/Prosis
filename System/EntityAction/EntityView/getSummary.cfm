
<cf_myClearancesPrepare mode="table">

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
  <cfset cl = "green">
<cfelse>
  <cfset cl = "red">   
</cfif>

<cfoutput>
<table align="center">
	<tr class="labelit">			
		<td valign="bottom" style="padding-left:6px;font-size:21px"><cfif getAction.recordcount eq "0"><cf_tl id="No"><cfelse><font color="#cl#">#getAction.recordcount#</cfif></td>
		<td valign="bottom" style="padding-left:3px;font-size:21px"><cfif getAction.recordcount eq "1"><cf_tl id="action"><cfelse><cf_tl id="actions"></cfif><cf_tl id="and"></td>
		<td valign="bottom" style="padding-left:3px;font-size:21px"><cfif tot eq "0"><cf_tl id="No"><cfelse><font color="#cl#">#tot#</font></cfif></td>
		<td valign="bottom" style="padding-left:3px;font-size:21px"><cfif tot eq "1"><cf_tl id="Batch clearance"><cfelse><cf_tl id="Batch clerances"></cfif></td>	
	</tr>
	<tr>	
		<td colspan="4" class="labelmedium" style="font-weight:200;font-size:16px;padding-left:10px">
		<font color="0080C0">Refresh your view to reflect recent updates (#timeformat(now(),"HH:MM:SS")#)</font>
		</td>
	</tr>
</table>
</cfoutput>
