<cfparam name="URL.TransactionId" default="">
<cfparam name="URL.SalesPersonNo" default="">
<cfparam name="URL.CustomerId" default="">
<cfparam name="URL.Warehouse"  default="">
<cfparam name="url.addressid"  default="00000000-0000-0000-0000-000000000000">

<cfquery name="getTransaction" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
		SELECT   *
		FROM   vwCustomerRequest
		<cfif url.transactionid neq "">
		WHERE    TransactionId = '#url.transactionid#'			
		<cfelse>
		WHERE    1=0
		</cfif>
</cfquery>


<cfif getTransaction.recordcount neq 0>
	<cfset URL.addressId = getTransaction.AddressId>
</cfif>	

<cfif URL.CustomerId neq "" and URL.Warehouse neq "" and URL.TransactionId eq "" and URL.SalesPersonNo eq "">

		<cfquery name="getDefault" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT   SalesPersonNo,COUNT(1) as Total 
			FROM     vwCustomerRequest
			WHERE    Warehouse  = '#URL.Warehouse#'
			AND      CustomerId = '#URL.CustomerId#'
			GROUP BY SalesPersonNo
			ORDER BY Count(1) DESC
		</cfquery>
		
		<cfif getDefault.recordcount neq 0>
			<cfset URL.SalesPersonNo = getDefault.SalesPersonNo>
		<cfelse>
			<cfset URL.SalesPersonNo = CLIENT.PersonNo>
		</cfif>

</cfif>

<cfif url.Mission eq "" or url.MissionOrgUnitID eq "">
	<cfquery name="getMiandOrg" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   TOP 1 *
			FROM     Materials.dbo.Warehouse
			WHERE    Warehouse  = '#URL.Warehouse#'
			ORDER BY CREATED DESC
	</cfquery>
	<cfif getMiandOrg.recordCount gte 1>
		<cfset url.Mission 			=  getMiandOrg.mission>
		<cfset url.MissionOrgUnitId	=  getMiandOrg.MissionOrgUnitId>
	</cfif>
</cfif>

<cfquery name="personlist" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	    SELECT *
		FROM   Person
		WHERE  PersonNo IN (SELECT    PA.PersonNo
							FROM      PersonAssignment PA INNER JOIN
				                      Position P ON PA.PositionNo = P.PositionNo
							WHERE     PA.DateEffective  < GETDATE() 
							AND       PA.DateExpiration > GETDATE() 
							AND       P.Mission = '#URL.mission#' 
							<cfif URL.MissionOrgUnitId neq "">
							AND       P.OrgUnitOperational IN (SELECT OrgUnit 
							                                   FROM   Organization.dbo.Organization
															   WHERE  MissionOrgUnitId = '#URL.MissionOrgUnitId#')
							</cfif>								   
							AND       PA.AssignmentStatus IN ('0', '1') 
							AND       PA.Incumbency > 0)	
							
		OR PersonNo = '#CLIENT.PersonNo#'  <!--- the person that has logged in --->		
		OR PersonNo = '#getTransaction.SalesPersonNo#'  <!--- the person that was selected in --->
																		 	   							   
</cfquery>

<cfoutput>

<select name="#URL.saleid#" id="#URL.saleid#" style="font-size:16px;height:100%;width:100%;border:0px;" class="regularXXL"
	onchange="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/Warehouse/Application/SalesOrder/POS/Sale/applySaleHeader.cfm?TransactionId=#URL.TransactionId#&field=#URL.field#&personno='+this.value+'&requestno='+document.getElementById('RequestNo').value,'salelines')">	
	<option value="">--<cf_tl id="Unassigned">--</option>
	<cfloop query="personlist">
		<option value="#PersonNo#" <cfif URL.SalesPersonNo eq PersonNo>selected</cfif>>#FirstName# #LastName#</option>
	</cfloop>
	
</select>

</cfoutput>										