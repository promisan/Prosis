
<cfparam name="url.orgunit" default="">

<cfif url.orgunit neq "">

	<cfquery name="get" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		 SELECT * 
		 FROM   Organization 
		 WHERE  OrgUnit = '#url.orgunit#' 
	</cfquery>
	
	<cfparam name="url.unithierarchy"    default="#get.HierarchyCode#">	

<cfelse>

	<cfparam name="url.unithierarchy"    default="">
	
</cfif>

<cfparam name="url.hierarchy"        default="true">
<cfparam name="url.unithierarchy"    default="">

<cfparam name="url.period"           default="">

<cfif url.period eq "">

	<cfquery name="PeriodList" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  TOP 1 M.PlanningPeriod, P.DateEffective
		FROM    Ref_MissionPeriod AS M INNER JOIN
	            Program.dbo.Ref_Period AS P ON M.PlanningPeriod = P.Period
		WHERE   M.Mission = '#mission#' 
		AND     P.DateEffective < GETDATE() 		
		ORDER BY P.DateEffective DESC	
	</cfquery>	
	
	<cfset url.period = PeriodList.PlanningPeriod>

</cfif>

<cfparam name="url.planningperiod"   default="#url.period#">

<cfset fund = "">
<cfset fdid = "">
<cfset clan = "">
<cfset clav = "">

<!--- identify the PRIMARY edition for this period and check if the edition
is also used for other periods of the SAME mission, then we take
these periods as the basis for the presentation  --->

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_Mission
	WHERE     Mission = '#URL.Mission#'	
</cfquery>

<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_ParameterMission
	WHERE     Mission = '#URL.Mission#'	
</cfquery>

<cfquery name="Param" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_ParameterMission
	WHERE     Mission = '#URL.Mission#'	
</cfquery>

<cfquery name="Expenditure" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    DISTINCT MandateNo, Period, AccountPeriod, EditionId, EditionidAlternate
	FROM      Ref_MissionPeriod
	WHERE     Mission = '#URL.Mission#'
	<cfif url.period neq "">
	AND       EditionId IN (SELECT EditionId
							FROM      Ref_MissionPeriod
							WHERE     Mission = '#URL.Mission#'
							AND       Period  = '#URL.Period#')  
	</cfif>						
</cfquery>

<cfset url.editionId = expenditure.editionid>

<cfset unit = "Yes">
<cfset spc  = 21>
<cfset stc  = "padding-right:1px;border-left: 1px solid Gray;">	

<cfset persel = "">
<cfset peraccsel = "">
<cfset man  = "">

<cfloop query="Expenditure">

  <!--- ----------set the mandate for unit selection --------------------------------------- --->
  <!--- Attention : issue if the edition crosses several periods and has a different mandate --->
  <!--- ------------------------------------------------------------------------------------ --->
  
  <cfset man = MandateNo>
  
  <cfif MandateNo neq man>
     <cfset unit = "No">  
  </cfif>

  <cfif persel eq "">
     <cfset persel = "'#Period#'"> 
	 <cfset peraccsel = "'#AccountPeriod#'"> 
  <cfelse>
     <cfset persel = "#persel#,'#Period#'">
	 <cfset peraccsel = "#peraccsel#,'#AccountPeriod#'"> 
  </cfif>
  
</cfloop>

<cfquery name="Period" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT  *
	FROM    Organization.dbo.Ref_MissionPeriod P
    WHERE   Mission = '#URL.Mission#' 
	AND     Period  = '#URL.Period#'
</cfquery>
	
<cf_tl id="Select" var="1">
<cfset vSelect= lt_text>

<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_AllotmentEdition	         
		WHERE    Mission      = '#URL.Mission#'
		AND      (Period      = '#URL.Period#' or Period is NULL)	
		AND      EditionClass = 'Budget'	
		AND      (EditionId   = '#url.EditionId#' or EditionId = '#Period.EditionIdAlternate#')
</cfquery>

<!--- --------------------------------- --->		   
<!--- usually there is just one edition --->
<!--- --------------------------------- --->

<table width="97%" align="center" cellspacing="0" cellpadding="0" class="navigation_table">	

<cfset cols = "10">
	   
<cfloop query="Edition">	

		<cfset fund = "">
		<cfset fdid = "">
		<cfset clan = "">
		<cfset clav = "">

		<!--- ----------------------------------------- --->
		<!--- ------------ REQUISITION ---------------- --->
		<!--- ----------------------------------------- --->
		
		<!--- ---------------pipeline------------------ --->
		<cfinvoke component = "Service.Process.Program.Execution"  
				   method           = "Requisition" 
				   mission          = "#url.mission#"
				   mandateNo        = "#man#"
				   editionid        = "#editionid#"
				   Status           = "Pipeline"
				   Currency         = "#Param.BudgetCurrency#"
				   Fund             = "#fund#"
				   Class            = "#clan#" 
				   ClassValue       = "#clav#"
				   unithierarchy    = "#url.unithierarchy#"		  
				   period           = "#persel#" 		   
				   mode             = "table"
				   table            = "#SESSION.acc#Pipeline">		
		
		<!--- -------------planned--------------------- --->
		<cfinvoke component = "Service.Process.Program.Execution"  
				   method           = "Requisition" 
				   mission          = "#url.mission#"
				   mandateNo        = "#man#"
				   editionid        = "#editionid#"
				   Status           = "Planned"
				   Currency         = "#Param.BudgetCurrency#"
				   Fund             = "#fund#"
				   Class            = "#clan#" 
				   ClassValue       = "#clav#"
				   unithierarchy    = "#url.unithierarchy#"		  
				   period           = "#persel#" 		   
				   mode             = "table"
				   table            = "#SESSION.acc#Planned">		
		
		<!--- ---------------requisitione-------------- --->
		<cfinvoke component = "Service.Process.Program.Execution"  
				   method           = "Requisition" 
				   mission          = "#url.mission#"
				   mandateNo        = "#man#"
				   editionid        = "#editionid#"
				   status           = "Cleared"
				   Currency         = "#Param.BudgetCurrency#"
				   Fund             = "#fund#"
				   Class            = "#clan#" 
				   ClassValue       = "#clav#"
				   unithierarchy    = "#url.unithierarchy#"		  
				   period           = "#persel#" 		   
				   mode             = "table"
				   table            = "#SESSION.acc#Requisition">	
				   
		<!--- ----------------------------------------- --->
		<!--- ------------ OBLIGATION  ---------------- --->
		<!--- ----------------------------------------- --->		
		
		<cfif mission.ProcurementMode eq "1">   <!---like DPA --->	 
			
			<!--- ---------------unliq obligations----------- --->		   
			
			<cfinvoke component = "Service.Process.Program.Execution"  
				   method           = "Obligation" 
				   mission          = "#url.mission#"
				   mandateNo        = "#man#"
				   editionid        = "#editionid#"
				   Currency         = "#Param.BudgetCurrency#"
				   Fund             = "#fund#"
				   Class            = "#clan#" 
				   ClassValue       = "#clav#"
				   unithierarchy    = "#url.unithierarchy#"		   
				   period           = "#persel#" 		  
				   scope            = "Unliquidated"
				   mode             = "table"
				   table            = "#SESSION.acc#Unliquidated">	
				   
		<cfelse>
				   		   			   
			<!--- -------- posted obligations : Hanno -------- --->		   
			
			<cfinvoke component = "Service.Process.Program.Execution"  
					   method             = "Disbursement" 
					   mission            = "#url.mission#"
					   mandateNo          = "#man#"
					   Currency           = "#Param.BudgetCurrency#"
					   editionid          = "#editionid#"
					   Fund               = "#fund#"
					   Class              = "#clan#" 
					   ClassValue         = "#clav#"
					   unithierarchy      = "#url.unithierarchy#"
					   period             = "#persel#" 
					   scope              = "Budget"
					   TransactionSource  = "'Obligation'"
					   accountperiod      = "#peraccsel#"	  
					   mode               = "table"
					   table              = "#SESSION.acc#Unliquidated">			
		
		</cfif>				   
			   
		<!--- ----------------------------------------- --->
		<!--- ------------ DISBURSEMENT --------------- --->
		<!--- ----------------------------------------- --->		   
				   		   			   
		<!--- --------invoices processed in budget-------- --->		   
		<cfinvoke component = "Service.Process.Program.Execution"  
				   method           = "Disbursement" 
				   mission          = "#url.mission#"
				   mandateNo        = "#man#"
				   Currency         = "#Param.BudgetCurrency#"
				   editionid        = "#editionid#"
				   Fund             = "#fund#"
				   Class            = "#clan#" 
				   ClassValue       = "#clav#"
				   unithierarchy    = "#url.unithierarchy#"
				   period           = "#persel#" 
				   scope            = "Budget"
				   accountperiod    = "#peraccsel#"	  
				   mode             = "table">			
			  	
		<!--- ---------------------------------------------- --->
		<!--- ----UN OICT only as per request of segolene--- --->
		<!--- ---------------------------------------------- --->	
			   
		<cfif url.mission eq "OICT">
		
			<!--- --------invoices processed outside -------- --->		
			<cfinvoke component = "Service.Process.Program.IMIS"  
				   method           = "IMIS" 
				   mission          = "#url.mission#"
				   mandateNo        = "#man#"
				   Currency         = "#Param.BudgetCurrency#"
				   editionid        = "#editionid#"
				   Fund             = "#fund#"
				   Class            = "#clan#" 
				   ClassValue       = "#clav#"
				   unitmode         = "organization"
				   unithierarchy    = "#url.unithierarchy#"
				   period           = "#persel#" 		   
				   accountperiod    = "#peraccsel#"	  
				   mode             = "table"
				   table            = "#SESSION.acc#IMIS">		
		
	    </cfif>		   		   
	
		<cfset vers = version>
		
		<tr><td colspan="10" class="labelmedium" height="40"><cfoutput>#Description# (#Param.BudgetCurrency#)</cfoutput></td></tr>
			
		<tr class="line" style="border-top:1px solid silver">	
			
			<td class="labelit" style="width:10%;padding-left:2px"><cf_tl id="Fund"></td>						
			<cfif Edition.AllocationEntryMode lte 1>		
			<td class="labelit" bgcolor="f4f4a4" align="center" style="border-left: 1px solid Gray;">
				 <cf_space spaces="#spc#">
				 <cf_tl id="Released" var="tReleased">
				 <cf_helpfile code = "Procurement" 
					 class            = "Execution"
					 id               = "cola2" 
					 styleclass       = "labelit"
					 name             = "Released Funds"
					 displaytext      = "#tReleased#<br>(a2)"
					 mode             = "dialog"
					 display          = "Text"
					 align			  = "center">
			</td>
			<cfelse>
			<td class="labelit" bgcolor="f4f4a4" align="center" style="border-left: 1px solid Gray;">
				 <cf_space spaces="#spc#">
				 <cf_tl id="Released" var="tReleased">
				 <cf_helpfile code = "Procurement" 
					 class            = "Execution"
					 id               = "cola2" 
					 styleclass       = "labelit"
					 name             = "Allocated Funds"
					 displaytext      = "#tReleased#<br>(a2)"
					 mode             = "dialog"
					 display          = "Text"
					 align			  = "center">
			</td>
			</cfif>
			<!---
			<td class="labelit" bgcolor="f4f4f4" align="center" style="border-left: 1px solid Gray;"><cf_space spaces="#spc#"><cf_tl id="Pipeline"><br>[b0]</td>			
			--->
			<td class="labelit" bgcolor="ffffaf" align="center" style="border-left: 1px solid Gray;">
				 <cf_space spaces="#spc#">
				 <cf_tl id="Approval" var="tApproval">
				 <cf_helpfile code = "Procurement" 
					 class            = "Execution"
					 id               = "colb1" 
					 styleclass       = "labelit"
					 name             = "Requests Approved"
					 displaytext      = "#tApproval#<br>(b1)"
					 mode             = "dialog"
					 display          = "Text"
					 align			  = "center">
			</td>
			<td class="labelit" bgcolor="ffffaf" align="center" style="border-left: 1px solid Gray;">
				 <cf_space spaces="#spc#">
				 <cf_tl id="Purchase" var="tPurchase">
				 <cf_helpfile code = "Procurement" 
					 class            = "Execution"
					 id               = "colb2" 
					 styleclass       = "labelit"
					 name             = "Requests under Purchase"
					 displaytext      = "#tPurchase#<br>(b2)"
					 mode             = "dialog"
					 display          = "Text"
					 align			  = "center">
			</td>		
			<td class="labelit" bgcolor="eeeeaf" align="center" style="border-left: 1px solid Gray;">
				 <cf_space spaces="#spc#">
				 <cf_tl id="Unliquid." var="tUnliquidated">
				 <cf_helpfile code = "Procurement" 
					 class            = "Execution"
					 id               = "cold" 
					 styleclass       = "labelit"
					 name             = "Unliquidated Obligations"
					 displaytext      = "#tUnliquidated#<br>(d)"
					 mode             = "dialog"
					 display          = "Text"
					 align			  = "center">
			</td>	
			<td class="labelit" bgcolor="eeeeaf" align="center" style="border-left: 1px solid Gray;">
				 <cf_space spaces="#spc#">
				 <cf_tl id="Disbursed" var="tDisbursed">
				 <cf_helpfile code = "Procurement" 
					 class            = "Execution"
					 id               = "cole" 
					 styleclass       = "labelit"
					 name             = "Disbursed Obligations"
					 displaytext      = "#tDisbursed#<br>(e)"
					 mode             = "dialog"
					 display          = "Text"
					 align			  = "center">
			</td>		
						
			<cfif url.mission eq "OICT">
			<td class="labelit" bgcolor="B7DBFF" align="center" style="border-left: 1px solid Gray;"><cf_space spaces="#spc#"><cf_tl id="IMIS"><br></td>						
			<cfelse>
			<td class="labelit" bgcolor="eeeeaf" align="center" style="border-left: 1px solid Gray;">
				 <cf_space spaces="#spc#">
				 <cf_tl id="Committed" var="tCommitted">
				 <cf_helpfile code = "Procurement" 
					 class            = "Execution"
					 id               = "colde" 
					 styleclass       = "labelit"
					 name             = "Committed Funds"
					 displaytext      = "#tCommitted#<br>(d+e)"
					 mode             = "dialog"
					 display          = "Text"
					 align			  = "center">
			</td>			
			</cfif>			
						
			<cfif Parameter.FundingCheckCleared eq "0">
			<td class="labelit" bgcolor="E7F5FA" align="center" style="border-left: 1px solid Gray;"><cf_space spaces="#spc#"><cf_tl id="Balance"><br>a1-b12-d-e</td>	
			<cfelse>
			<td class="labelit" bgcolor="E7F5FA" align="center" style="border-left: 1px solid Gray;"><cf_space spaces="#spc#"><cf_tl id="Balance"><br>a2-b12-d-e</td>	
			</cfif>					
			<!--- added 11/6/2011 --->			
			<td class="labelit" bgcolor="B0FFB0" align="center" style="border-left: 1px solid Gray;"><cf_space spaces="#spc#"><cf_tl id="Execution"><br>[f]</td>						
			
		</tr>
						
	<cftry>	
	
	<!--- ------ create tables with budget------ --->	
	<cfinvoke component = "Service.Process.Program.Execution"  
		   method           = "Budget" 
		   period           = "#url.period#" 
		   planningperiod   = "#url.planningperiod#"
		   mission          = "#url.mission#"
		   mandateNo        = "#man#"
		   Currency         = "#Param.BudgetCurrency#"
		   Fund             = "#fund#"
		   Class            = "#clan#" 
		   ClassValue       = "#clav#"		
		   Status           = "0" 	     
		   unithierarchy    = "#url.unithierarchy#"
		   editionid        = "#EditionId#"
		   table            = "#SESSION.acc#Requirement"
		   mode             = "table">		
			   
	<!--- ------ create tables with allotment------ --->		
		
	<cfif AllocationEntryMode lte "2">	
		<cfset st = "1">
	<cfelse>	
		<cfset st = "3">  <!--- workflow cleared --->
	</cfif>
	
	<cfinvoke component = "Service.Process.Program.Execution"  
		   method           = "Budget" 
		   period           = "#url.period#" 
		   planningperiod   = "#url.planningperiod#"
		   mission          = "#url.mission#"
		   mandateNo        = "#man#"
		   Currency         = "#Param.BudgetCurrency#"
		   Fund             = "#fund#"		   
		   Class            = "#clan#" 
		   ClassValue       = "#clav#"
		   Status           = "#st#"		  
		   unithierarchy    = "#url.unithierarchy#"
		   editionid        = "#EditionId#"
		   table            = "#SESSION.acc#Allotment"
		   mode             = "table">	   
	
	<cfoutput>
	
	<cfparam name="SelectBase.EditionId" default="">
	<cfparam name="ed" default="">
	
	<cfquery name="Fund" 
		    datasource="AppsProgram" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT   DISTINCT Fund
			FROM     userQuery.dbo.#session.acc#Requirement
			WHERE    Fund NOT IN ('ZTA','XB') 
			UNION
			SELECT   DISTINCT Fund
			FROM     userQuery.dbo.#SESSION.acc#Unliquidated
			WHERE    Fund NOT IN ('ZTA','XB') 			
			ORDER BY Fund
	</cfquery>		
	
	<cfloop list="ANY,#valuelist(fund.fund)#" index="itm">
	
		<tr class="navigation_row line">			
				  
			<cfif itm neq "ANY">
			<td class="cellcontent" height="16" width="80" style="padding-left:13px">#itm#</td>	
			<cfelse>
			<td class="cellcontent" height="20" width="80" style="background-color:f1f1f1;padding-left:3px"><cf_tl id="Total"></td>	
			</cfif>
			
		   <cfif Parameter.FundingCheckCleared eq "0">			    		
		   		   	
		   <td align="right" bgcolor="f4f4f4" style="#stc#">	
			
				<cfquery name="Total" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    SUM(Total) AS Total 
					FROM      userQuery.dbo.#SESSION.acc#Requirement				
				</cfquery>	
				
				<cfif Total.Total eq "">
				  <cfset rsc = 0>
				<cfelse>
				  <cfset rsc =  Total.Total>
				</cfif>							
						
				<cf_space align="right" label="#numberformat(rsc/1000,"_,_._")#" spaces="#spc#">
	
			</td>
			
			<cfelse>
			
			<td align="right" style="#stc#">
					
				<cfquery name="Total" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   SUM(Total) AS Total 
					FROM     userQuery.dbo.#SESSION.acc#Allotment	
					<cfif itm neq "ANY">
					WHERE    Fund = '#itm#'
					</cfif>				
				</cfquery>	
				
				<cfif Total.Total eq "">
				  <cfset all = 0>
				<cfelse>
				  <cfset all =  Total.Total>
				</cfif>
			   		   
			   <cf_space align="right" label="#numberformat(all/1000,"_,_._")#" spaces="#spc#"> 
			
			</td>	
			
			</cfif>
			
			<!--- added in October 4th 
			
			<td align="right" style="#stc#" bgcolor="f4f4f4">
			
				<!--- define reservations --->
				<cfquery name="Pipeline" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   SUM(ReservationAmount) as Amount 
					FROM     #SESSION.acc#Pipeline
					<cfif itm neq "ANY">
					WHERE    Fund = '#itm#'
					</cfif>		
				</cfquery>			
				
				<cfif Pipeline.Amount eq "">
				  <cfset pip = 0>
				<cfelse>
				  <cfset pip =  Pipeline.Amount>
				</cfif>
				
				<cf_space align="right" label="#numberformat(pip/1000,"_,_._")#" spaces="#spc#">
			
			</td>		
			
			--->		
			
			<td align="right" style="#stc#">
			
				<!--- define reservations --->
				<cfquery name="Planned" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   SUM(ReservationAmount) as PlannedAmount 
					FROM     #SESSION.acc#Planned
					<cfif itm neq "ANY">
					WHERE    Fund = '#itm#'
					</cfif>		
				</cfquery>			
				
				<cfif Planned.PlannedAmount eq "">
				  <cfset pla = 0>
				<cfelse>
				  <cfset pla =  Planned.PlannedAmount>
				</cfif>
				
				<cf_space align="right" label="#numberformat(pla/1000,"_,_._")#" spaces="#spc#">
			
			</td>
			
			<td align="right" style="#stc#">
			
				<!--- define reservations --->
				<cfquery name="Reservation" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   SUM(ReservationAmount) as ReservationAmount 
					FROM     #SESSION.acc#Requisition
					<cfif itm neq "ANY">
					WHERE    Fund = '#itm#'
					</cfif>		
				</cfquery>			
				
				<cfif Reservation.ReservationAmount eq "">
				  <cfset res = 0>
				<cfelse>
				  <cfset res =  Reservation.ReservationAmount>
				</cfif>
				
				<cf_space align="right" label="#numberformat(res/1000,"_,_._")#" spaces="#spc#">
			
			</td>
					
			<td align="right" style="#stc#">
			
				<!--- define obligations --->
				
				<cfquery name="Unliquidated" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   SUM(ObligationAmount) as ObligationAmount 
					FROM     #SESSION.acc#Unliquidated
					<cfif itm neq "ANY">
					WHERE    Fund = '#itm#'
					</cfif>		
				</cfquery>
				
				<cfif Unliquidated.ObligationAmount eq "">
				  <cfset unl = 0>
				<cfelse>
				  <cfset unl =  Unliquidated.ObligationAmount>
				</cfif>
				
				<cf_space align="right" label="#numberformat(unl/1000,"_,_._")#" spaces="#spc#">
				
			</td>		
					
			<td align="right" style="#stc#">
			
				<cfquery name="Invoice" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   SUM(InvoiceAmount) as InvoiceAmount
					FROM     #SESSION.acc#Invoice		
					<cfif itm neq "ANY">
					WHERE    Fund = '#itm#'
					</cfif>		
				</cfquery>		
				
				<cfif Invoice.InvoiceAmount eq "">
				  <cfset inv = 0>
				<cfelse>
				  <cfset inv =  Invoice.InvoiceAmount>
				</cfif>	
							
				<cf_space align="right" label="#numberformat(inv/1000,"_,_._")#" spaces="#spc#">
				
			</td>				
			
			<td align="right" bgcolor="B7DBFF" style="#stc#">
			
			  <cfif url.mission eq "OICT" >
			  
			    <cfquery name="IMIS" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   SUM(ExpenditureAmount) as ExpenditureAmount
					FROM     #SESSION.acc#IMIS		
					<cfif itm neq "ANY">
					WHERE    Fund = '#itm#'
					</cfif>		
				</cfquery>		
				
				<cfif IMIS.ExpenditureAmount eq "">
				  <cfset ims = 0>
				<cfelse>
				  <cfset ims =  IMIS.ExpenditureAmount>
				</cfif>	
				
				<cf_space align="right" label="#numberformat(ims/1000,"_,_._")#" spaces="#spc#">
			  		  
			  <cfelse>
			
				<cf_space align="right" label="#numberformat((unl+inv)/1000,"_,_._")#" spaces="#spc#">		
				
			  </cfif>	
					
			</td>				
			
			<td align="right" bgcolor="E7F5FA" style="#stc#">
					
			<cfif Parameter.FundingCheckCleared eq "0">
						
				<cfif rsc-pla-res-unl-inv gte 0>
					<cf_space align="right" label="#numberformat((rsc-pla-res-unl-inv)/1000,"_,_._")#" spaces="#spc#">		
				<cfelse>
					<cf_space align="right" label="#numberformat((rsc-pla-res-unl-inv)/1000,"_,_._")#" spaces="#spc#" color="red">		
				</cfif>
			
			<cfelse>
			
				<cfif all-pla-res-unl-inv gte 0>
					<cf_space align="right" label="#numberformat((all-pla-res-unl-inv)/1000,"_,_._")#" spaces="#spc#">		
				<cfelse>
					<cf_space align="right" label="#numberformat((all-pla-res-unl-inv)/1000,"_,_._")#" spaces="#spc#" color="red">		
				</cfif>
			
			</cfif>
			
			</td>
					
				<cfset tot = pla+res+unl+inv>
			
				<cfif Parameter.FundingCheckCleared eq "0">
				
					<cfif rsc gt "0">
						<cfset exe = "#numberformat(tot*100/rsc,'._')#%">
						<cfif tot gt rsc>
							<cfset cl = "red">
						<cfelse>
							<cfset cl = "B0FFB0">
						</cfif>
					<cfelse>
						<cfset exe = "n/a">
						<cfset cl = "silver">
					</cfif>						
				
				<cfelse>
				
					<cfif all gt "0">
						<cfset exe = "#numberformat(tot*100/all,'._')#%">
						<cfif tot gt all>
							<cfset cl = "red">
						<cfelse>
							<cfset cl = "B0FFB0">
						</cfif>
					<cfelse>
						<cfset exe = "n/a">
						<cfset cl = "silver">
					</cfif>			
				
				</cfif>
				
				<td bgcolor="#cl#" align="right" style="#stc#">			
				<cf_space align="right" label="#exe#" spaces="#spc#">
						
			</td>					
			
		</tr>
		
	    <cfif itm eq "ANY">
		  <tr><td class="line" colspan="#cols#"></td></tr>
	    </cfif>
	
	  </cfloop>
	  				
	</cfoutput>	
					
	    <cfcatch>
	
		<tr><td align="center"
		        colspan="<cfoutput>#cols#</cfoutput>" height="40" class="labelmedium">Data could not be retrieved. Please make your selection again</font></td>
		</tr>
		<cfabort>
		
	</cfcatch>
	
	</cftry>			
				
</cfloop>

</table>	

<cfset ajaxonload("doHighlight")>
