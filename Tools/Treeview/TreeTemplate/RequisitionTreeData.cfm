<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#attributes.Mission#' 
</cfquery>

<cfset Template = "#CLIENT.Template#">

<cfoutput>

	<cf_tl id = "Procurement Requests" var ="vRequests">
	
	<cf_UItree
			id="Proc"
			title="<span style='font-size:16px' class='labellarge'>#vRequests#</span>"
			expand="Yes">

	<cf_tl id = "Advanced search" var ="vSearch">

	<cf_UItreeitem value="Src"
			display="<span style='padding-top:3px;padding-bottom:4px;font-size:16px;font-weight:bold'>#vSearch#</span>"
			parent="Proc"
			target="right"
			href="#Template#?Mission=#URL.Mission#&ID=LOC&ID1=Locate"
			expand="Yes">

	<cf_tl id = "Request status" var ="vStatus">

	<cf_UItreeitem value="List"
			display="<span style='font-size:16px;font-weight:bold;padding-top:3px;padding-bottom:3px;'>#vStatus#</span>"
			parent="Proc"
			expand="Yes">

	<cfquery name="Status"
			datasource="AppsPurchase"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT *, (SELECT SUM(Total)
						FROM   UserQuery.dbo.#SESSION.acc#RequisitionSet_#attributes.fileno#
						WHERE  ActionStatus = P.Status) as Counted
			FROM   #client.lanPrefix#Status P
			WHERE  StatusClass = 'Requisition'
			<!--- only show relevant status that are used in the scope --->
			AND    Status IN (SELECT ActionStatus
			FROM   UserQuery.dbo.#SESSION.acc#RequisitionSet_#attributes.fileno#
			WHERE  ActionStatus = P.Status)
			AND    Status != '0'
	</cfquery>

	<cfloop query="Status">

		<cfset description = Status.description>

		<cfif Status.StatusDescription neq "" and CLIENT.LanPrefix eq "">
			<cfset title = "<span style='font-size:13px;'>#statusdescription# - <a id='status_#status#'>#counted#</a></span>">
		<cfelse>
			<cfset title = "<span style='font-size:13px;'>#description# - <a id='status_#status#'>#counted#</a></span>">
		</cfif>

		<cfif status neq "3">

			<cfif status eq "9">

				<cf_UItreeitem value="#Description#"
						display="#Title#"
						parent="List"
						target="right"
						href="#Template#?Mission=#Attributes.Mission#&ID=STA&ID1=#status#"
						expand="Yes">

			<cfelse>

				<cf_UItreeitem value="#Description#"
						display="#Title#"
						parent="List"
						target="right"
						href="#Template#?Mission=#Attributes.Mission#&ID=STA&ID1=#status#"
						expand="Yes">

			</cfif>

		<cfelse>

			<cf_tl id = "Under Execution" var ="vUnder">

			<cfset title = "#vUnder# - #counted#">

			<cf_UItreeitem value="Execution"
					display="<span style='font-size:13px'>#title#</span>"
					parent="List"
					href="#Template#?Mission=#Attributes.Mission#&ID=STA&ID1=#status#"
					target="right"
					expand="No">

			<cf_tl id = "Purchase Order" var ="vPurchase">

			<cf_UItreeitem value="Purchase Order"
					display="<span style='font-size:13px'>#vPurchase#</span>"
					parent="Execution"
					target="right"
					href="#Template#?Mission=#Attributes.Mission#&ID=STA&ID1=#status#&ID2=Purchase"
					expand="Yes">
					
			<cf_tl id ="Goods Received" var ="vGoods">

			<cf_UItreeitem value="Receipt"
					display="<span style='font-size:13px'>#vGoods#</span>"
					parent="Execution"
					expand="No">

			<cf_tl id ="Partially Received" var ="vPartiallyR">

			<cf_UItreeitem value="PartialReceipt"
					display="<span style='font-size:13px'>#vPartiallyR#</span>"
					parent="Receipt"
					target="right"
					href="#Template#?Mission=#Attributes.Mission#&ID=STA&ID1=#status#&ID2=ReceiptPartial"
					img="#SESSION.root#/Images/select.png"
					expand="Yes">

			<cf_tl id ="Fully Received" var ="vFully">

			<cf_UItreeitem value="FullReceipt"
					display="<span style='font-size:13px;'>#vFully#</span>"
					parent="Receipt"
					target="right"
					href="#Template#?Mission=#Attributes.Mission#&ID=STA&ID1=#status#&ID2=ReceiptFull"
					img="#SESSION.root#/Images/select.png"
					expand="Yes">
		

			<cf_tl id = "Settled" var ="vDisbursement">

			<cf_UItreeitem value="Disbursement"
					display="<span style='font-size:13px'>#vDisbursement#</span>"
					parent="Execution"
					expand="No">

			<cf_verifyOperational
					module    = "Accounting"
					Warning   = "No">

			<cfif Operational eq "1">

				<cf_tl id = "Partially" var ="vPartially">

				<cf_UItreeitem value="InvoicedPartial"
						display="<span style='font-size:13px'>#vPartially#</span>"
						parent="Disbursement"
						target="right"
						href="#Template#?Mission=#Attributes.Mission#&ID=STA&ID1=#status#&ID2=Invoice"
						img="#SESSION.root#/Images/select.png"
						expand="Yes">

				<cf_tl id = "Completely" var ="vDisbursed">

				<cf_UItreeitem value="InvoicedFull"
						display="<span style='font-size:13px;'>#vDisbursed#</span>"
						parent="Disbursement"
						target="right"
						href="#Template#?Mission=#Attributes.Mission#&ID=STA&ID1=#status#&ID2=InvoiceFull"
						img="#SESSION.root#/Images/select.png"
						expand="Yes">

			<cfelse>

				<!--- S mode, no longer relevant --->

				<cf_tl id = "(Partially) Invoiced" var ="vInvoiced">

				<cf_UItreeitem value="InvoicedPartial"
						display="<span style='font-size:13px;'>#vInvoiced#</span>"
						parent="Disbursement"
						target="right"
						href="#Template#?Mission=#Attributes.Mission#&ID=STA&ID1=#status#&ID2=Invoice"
						img="#SESSION.root#/Images/select.png"
						expand="Yes">

				<cf_tl id = "Fully Invoiced" var ="vfInvoiced">
				<cf_UItreeitem value="InvoicedFull"
						display="<span style='font-size:13px;'>#vfInvoiced#</span>"
						parent="Disbursement"
						target="right"
						href="#Template#?Mission=#Attributes.Mission#&ID=STA&ID1=#status#&ID2=InvoiceFull"
						img="#SESSION.root#/Images/select.png"
						expand="Yes">

			</cfif>

			
		</cfif>
	</cfloop>

<!--- -------------orgunits ---------------------------- --->
<!--- check units to be shown in its hierarchy structure --->
<!--- -------------------------------------------------- --->

	<cfquery name="getUnits"
			datasource="AppsQuery"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
		SELECT  DISTINCT OrgUnit
		FROM    #SESSION.acc#RequisitionSet_#attributes.fileno#
	</cfquery>

	<cfset orglist = quotedValueList(getUnits.OrgUnit)>

	<cfif orglist eq "">
		<cfset orglist = "0">
	</cfif>

	<cfloop query="getUnits">

		<cfquery name="Check"
				datasource="AppsOrganization"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
			SELECT  DISTINCT OrgUnitCode, ParentOrgUnit, Mission, MandateNo
			FROM    Organization
			WHERE   OrgUnit = '#OrgUnit#'
		</cfquery>

		<cfset Parent = Check.ParentOrgUnit>
		<cfset Miss   = Check.Mission>
		<cfset Mand   = Check.MandateNo>

		<cfloop condition="Parent neq ''">

			<cfquery name="LevelUp"
					datasource="AppsOrganization"
					maxrows=1
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
				SELECT  OrgUnit, ParentOrgUnit
				FROM    Organization
				WHERE   OrgUnitCode = '#Parent#'
			AND     Mission     = '#Miss#'
			AND     MandateNo   = '#Mand#'
			</cfquery>

<!--- check if record exists and add --->

			<cfif not find(LevelUp.OrgUnit,orglist)>
				<cfset orglist = "#orglist#,#levelup.orgunit#">
			</cfif>

			<cfset Parent = LevelUp.ParentOrgUnit>

		</cfloop>

	</cfloop>

<!--- generate a correct tree --->
	<cf_tl id="Requesting unit" var="vUnit">

	<cf_UItreeitem value="Org"
			display="<span style='padding-top:4px;padding-bottom:4px;font-size:16px;font-weight:bold'>#vUnit#</span>"
			parent="Proc"
			expand="No">

	<cfquery name="Level01"
			datasource="AppsOrganization"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
		SELECT   DISTINCT TreeOrder,
				 O.OrgUnitName,
				 O.OrgUnitNameShort,
				 O.OrgUnit,
				 O.OrgUnitCode,
				(SELECT SUM(Total)
				 FROM  UserQuery.dbo.#SESSION.acc#RequisitionSet_#attributes.Fileno#
				 WHERE OrgUnit IN (SELECT OrgUnit
                 				   FROM   Organization.dbo.Organization
								   WHERE  Mission           = O.Mission
								   AND    MandateNo         = O.MandateNo
								   AND    HierarchyRootUnit = O.OrgUnitCode)) as Counted
		FROM     #Client.LanPrefix#Organization O
    	WHERE    (O.ParentOrgUnit is NULL OR O.ParentOrgUnit = '')
	    AND      O.OrgUnit IN (#preservesinglequotes(orglist)#)
	    ORDER BY TreeOrder, OrgUnitName

	</cfquery>

	<cfloop query="level01">

		<cfset org1 = orgunit>

		<cfif orgunitnameshort eq "">

			<cfif len(OrgUnitName) gte "30">
				<cfset vwname = "#left(OrgUnitName,30)#..">
			<cfelse>
				<cfset vwname = "#OrgUnitName#">
			</cfif>

		<cfelse>
			<cfset vwname = orgunitnameshort>
		</cfif>

		<cfset title = "#vwname# [#counted#]">

		<cf_UItreeitem value="#OrgUnit#"
				display="<span style='font-size:13px'>#title#</span>"
				parent="Org"
				target="right"
				href="#Template#?Mission=#Attributes.Mission#&ID=ORG&ID1=#Level01.OrgUnit#"
				expand="No">

		<cfquery name="Level02"
				datasource="AppsOrganization"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT   DISTINCT TreeOrder,
				         O.OrgUnitName, 
						 O.OrgUnitNameShort, 
						 O.OrgUnit, 
						 O.OrgUnitCode,
						(SELECT ISNULL(SUM(total),0)
						 FROM   UserQuery.dbo.#SESSION.acc#RequisitionSet_#attributes.fileno#
						 WHERE  OrgUnit = O.OrgUnit) as Counted
			   FROM     #Client.LanPrefix#Organization O
			   WHERE    ParentOrgUnit = '#Level01.OrgUnitCode#'
			   AND      O.OrgUnit IN (#preservesinglequotes(orglist)#)
			   ORDER BY TreeOrder, OrgUnitName
		</cfquery>

		<cfloop query="level02">

			<cfset org2 = orgunit>

			<cfif orgunitnameshort neq "">

				<cfset vwname = orgunitnameshort>

			<cfelse>

				<cfif len(OrgUnitName) gte "30">
					<cfset vwname = "#left(OrgUnitName,30)#..">
				<cfelse>
					<cfset vwname = "#OrgUnitName#">
				</cfif>

			</cfif>

			<cfset vwname = orgunitnameshort>

			<cfset title = "#vwname# [#counted#]">

			<cf_UItreeitem value="#OrgUnit#"
					display="<span style='font-size:13px'>#title#</span>"
					parent="#org1#"
					target="right"
					href="#Template#?Mission=#Attributes.Mission#&ID=ORG&ID1=#Level02.OrgUnit#"
					expand="No">

			<cfquery name="Level03"
					datasource="AppsOrganization"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
					SELECT  DISTINCT TreeOrder, O.OrgUnitName, O.OrgUnitNameShort, O.OrgUnit, OrgUnitCode,
					        (SELECT ISNULL(SUM(total),0)
	          				 FROM   UserQuery.dbo.#SESSION.acc#RequisitionSet_#attributes.fileno#
					         WHERE  OrgUnit = O.OrgUnit) as Counted
		            FROM     #Client.LanPrefix#Organization O
				    WHERE    O.ParentOrgUnit = '#Level02.OrgUnitCode#'
				    AND      O.OrgUnit IN (#preservesinglequotes(orglist)#)
				    ORDER BY TreeOrder, OrgUnitName
			</cfquery>

			<cfloop query="level03">

				<cfset org3 = orgunit>

				<cfif orgunitnameshort neq "">

					<cfset vwname = orgunitnameshort>

				<cfelse>

					<cfif len(OrgUnitName) gte "30">
						<cfset vwname = "#left(OrgUnitName,30)#..">
					<cfelse>
						<cfset vwname = "#OrgUnitName#">
					</cfif>

				</cfif>

				<cfset title = "#vwname# [#counted#]">

				<cf_UItreeitem value = "#OrgUnit#"
						display      = "<span style='font-size:13px'>#title#</span>"
						parent       = "#org2#"
						target       = "right"
						href         = "#Template#?Mission=#Attributes.Mission#&ID=ORG&ID1=#OrgUnit#"
						expand       = "No">

				<cfquery name="Level04"
						datasource="AppsOrganization"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
						SELECT   DISTINCT TreeOrder, O.OrgUnitName, O.OrgUnitNameShort, O.OrgUnit, OrgUnitCode,
								 (SELECT ISNULL(SUM(total),0)
								  FROM   UserQuery.dbo.#SESSION.acc#RequisitionSet_#attributes.fileno#
								  WHERE  OrgUnit = O.OrgUnit) as Counted
						FROM     #Client.LanPrefix#Organization O
						WHERE    O.ParentOrgUnit = '#Level03.OrgUnitCode#'
						AND      O.OrgUnit IN (#preservesinglequotes(orglist)#)
						ORDER BY TreeOrder, OrgUnitName
				</cfquery>

				<cfloop query="level04">

					<cfset org4 = orgunit>

					<cfif orgunitnameshort neq "">

						<cfset vwname = orgunitnameshort>

					<cfelse>

						<cfif len(OrgUnitName) gte "30">
							<cfset vwname = "#left(OrgUnitName,30)#..">
						<cfelse>
							<cfset vwname = "#OrgUnitName#">
						</cfif>

					</cfif>

					<cfset title = "#vwname# [#counted#]">

					<cf_UItreeitem value="#OrgUnit#"
							display="<span style='font-size:13px'>#title#</span>"
							parent="#org3#"
							target="right"
							href="#Template#?Mission=#Attributes.Mission#&ID=ORG&ID1=#OrgUnit#"
							expand="No">

				</cfloop>

			</cfloop>

		</cfloop>

	</cfloop>

	<cfquery name="getSource"
			datasource="AppsPurchase"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">

		SELECT *
		FROM   Employee.dbo.Position
		WHERE  PositionParentId IN (

				SELECT    PPF.PositionParentId
				FROM      RequisitionLine L INNER JOIN
				          Employee.dbo.PositionParentFunding PPF ON L.RequisitionNo = PPF.RequisitionNo
				WHERE     L.Mission = '#url.mission#'
				AND       L.Period  = '#url.period#'
				AND 	  L.RequisitionNo IN
							(SELECT  RequisitionNo
							 FROM    RequisitionLineAction
							 <cfif getAdministrator("#url.mission#") eq "0">
							 WHERE    Officeruserid = '#session.acc#'
							 <cfelse>
							 WHERE    1=1
							 </cfif>
							 AND      ActionStatus >= '1' AND ActionStatus < '3')
				)
	</cfquery>

	<cfif getSource.recordcount gte "1">

		<cf_tl id = "Requested Workforce" var ="vStaff">

		<cf_UItreeitem value="staff"
				display="<span style='font-size:15px;padding-top:5px;'>#vStaff#</span>"
				target="right"
				href="#Template#?Mission=#Attributes.Mission#&ID=WRF&period=#url.period#"
				parent="Proc"
				expand="Yes">

	</cfif>

<!--- ----------------- --->
<!--- workorder classes --->
<!--- ----------------- --->

	<cfquery name="Parameter"
			datasource="AppsPurchase"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ParameterMission
			WHERE  Mission = '#attributes.Mission#'
	</cfquery>

	<cf_verifyOperational
			module="WorkOrder"
			Warning="No">

	<cfif Operational eq "1">

		<cf_tl id = "WorkOrder" var ="vWorkOrder">

		<cf_UItreeitem value="workorder"
				display="<span style='font-size:17px;padding-top:5px;padding-top:5px;padding-bottom:5px;font-weight:bold'>#vWorkOrder#</span>"
				parent="Proc"
				expand="Yes">

		<cfquery name="ServiceItem"
			datasource="AppsWorkorder"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
				SELECT *
				FROM   ServiceItemMission M, ServiceItem R
				WHERE  M.Serviceitem = R.Code
				AND    Mission = '#attributes.Mission#'
				AND    R.ServiceMode = 'WorkOrder'
		</cfquery>

		<cf_tl id = "Finished Product" var ="vFinishedProduct">
		<cf_tl id = "Raw Materials" var ="vRawMaterials">

		<cfloop query="ServiceItem">

			<cf_UItreeitem value="workorder_#ServiceItem#"
					display="#Description#"
					parent="workorder"
					target="right"
					href="#Template#?Mission=#Attributes.Mission#&ID=WOR&ID1=#Code#"
					expand="No">

			<cf_UItreeitem value="workorder_#ServiceItem#_raw"
					display="#vRawMaterials#"
					parent="workorder_#ServiceItem#"
					target="right"
					href="#Template#?Mission=#Attributes.Mission#&ID=WOR&ID1=#Code#&ID2=RAW"
					expand="No">

			<cf_UItreeitem value="workorder_#ServiceItem#_fp"
					display="#vFinishedProduct#"
					parent="workorder_#ServiceItem#"
					target="right"
					href="#Template#?Mission=#Attributes.Mission#&ID=WOR&ID1=#Code#&ID2=FP"
					expand="No">

		</cfloop>

	</cfif>

<!--- only for the support group --->

	<cfif SESSION.isAdministrator eq "Yes">

		<cf_tl id ="Audit Views" var ="vAudit">

		<cf_UItreeitem value="Views"
				display="<span style='padding-top:5px;font-size:17px;font-weight:bold'>#vAudit#</b></span>"
				parent="Proc"
				expand="no">

		<cf_tl id ="Inconsistencies" var ="vInconsistencies">

		<cf_UItreeitem value="Error"
				display="<font size='2'>#vInconsistencies#</font>"
				parent="Views"
				target="right"
				expand="Yes">

		<cf_tl id ="Invalid Status" var ="vInvalid1">

		<cf_UItreeitem value="InvalidStatus"
				display="<font size='2'>#vInvalid1#</font>"
				parent="error"
				target="right"
				href="#Template#?Mission=#Attributes.Mission#&ID=AUDIT&ID1=IST"
				expand="Yes">

		<cf_tl id ="Invalid Mandate" var ="vInvalid2">

		<cf_UItreeitem value="InvalidOrg"
				display="<font size='2'>#vInvalid2#</font>"
				parent="error"
				target="right"
				href="#Template#?Mission=#Attributes.Mission#&ID=AUDIT&ID1=IOR"
				expand="Yes">

		<cfif Parameter.EnforceProgramBudget eq "1">

			<cf_tl id ="Invalid Program Code" var ="vInvalid3">

			<cf_UItreeitem value="InvalidProgram3"
					display="<font size='2'>#vInvalid3#</font>"
					parent="error"
					target="right"
					href="#Template#?Mission=#Attributes.Mission#&ID=AUDIT&ID1=MPR"
					expand="No">

		</cfif>

		<cf_tl id ="Alerts" var ="vAlert">
		<cf_UItreeitem value="alert"
				display="<font size='2'>#vAlert#</font>"
				parent="Views"
				target="right"
				expand="No">

		<cf_tl id ="Incomplete Funding" var ="vIncomplete">
		<cf_UItreeitem value="Pending"
				display="<font size='2'>#vIncomplete#</font>"
				parent="alert"
				target="right"
				href="#Template#?Mission=#Attributes.Mission#&ID=AUDIT&ID1=FND"
				expand="No">

		<cfif Parameter.EnforceProgramBudget eq "1">

			<cf_tl id ="Funded but NO Budget" var ="vFunded">
			<cf_UItreeitem value="InvalidFunding"
					display="<font size='2'>#vFunded#</font>"
					parent="alert"
					target="right"
					href="#Template#?Mission=#Attributes.Mission#&ID=AUDIT&ID1=PRG"
					expand="No">

		</cfif>

	</cfif>

	<cf_UItreeitem value="dummy"
			display=""
			parent="Views">


<!--- ******************************** OPEN CONTRACT ********************************** --->

	<cfif Parameter.EnableExecutionRequest eq "1">
		<cf_tl id ="Open Contract Requests" var ="vOpen">

		<cf_UItreeitem value="dummy"
				display=""
				parent="Root">

		<cf_UItreeitem value="Open"
				display="<span style='font-size:17px;color: 6688aa;'>#vOpen#</span>"
				parent="Root"
				expand="Yes">

		<cf_UItreeitem value="Status"
				display="<span style='font-size:15px;color: black;'>#vStatus#</span>"
				parent="open"
				expand="yes">

		<cfquery name="Status"
				datasource="AppsOrganization">
			SELECT *,

			( SELECT   count(*)
			FROM     Purchase.dbo.PurchaseExecutionRequest R
			WHERE    Period = '#url.period#'
		AND      ActionStatus = S.EntityStatus
<!--- only this mission --->
			AND      R.PurchaseNo IN
			(SELECT     PurchaseNo
			FROM       Purchase.dbo.Purchase
			WHERE      Mission = '#attributes.mission#'
		AND        PurchaseNo = R.PurchaseNo)
<!--- valid orgunit --->
			AND 	  R.OrgUnit IN
			(SELECT     OrgUnit
			FROM      Organization.dbo.Organization
			WHERE     OrgUnit = R.OrgUnit)

			) as Counted


			FROM   Ref_EntityStatus S
			WHERE  EntityCode = 'ProcExecution'
		</cfquery>

		<cfloop query="Status">

			<cfif entitystatus eq "9">
				<cfset cl = "red">
			<cfelse>
				<cfset cl = "black">
			</cfif>

			<cf_tl id ="#StatusDescription#" var ="vStatus">

			<cf_UItreeitem value="#EntityStatus#"
					display="<span style='font-size:14px;color: #cl#;' >#StatusDescription# (#counted#)</span>"
					href="../../PurchaseOrder/ExecutionRequest/ViewView.cfm?mission=#attributes.mission#&period=#url.period#&ID=status&ID1=#EntityStatus#&systemfunctionid=#url.systemfunctionid#"
					target="right"
					parent="Status"
					expand="no">

		</cfloop>

	</cfif>

</cf_UItree>

</cfoutput>

