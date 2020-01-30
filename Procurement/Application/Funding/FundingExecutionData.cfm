
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>vanpelt</proUsr>
	<proOwn>Hanno van Pelt</proOwn>
	<proDes>Tuned for multi period</proDes>
	<proCom></proCom>
</cfsilent>

<cfparam name="url.view"       default="">
<cfparam name="url.value"      default="">
<cfparam name="url.hierarchy"  default="true">


<cfoutput>
<script>
	 try {
	 document.getElementById("view").value = "#url.view#"
	 document.getElementById("value").value = "#url.value#"
	 document.getElementById("findbox").className = "regular"
	 } catch(e) {}
</script>
</cfoutput>
	
<cfif url.view eq "All">
	
	<cfset fund = "">
	<cfset fdid = "">
	<cfset clan = "">
	<cfset clav = "">

<cfelseif url.view eq "Fund">
		
	<cfset fund = url.value>
	<cfset fdid = url.value>
	<cfset clan = "">
	<cfset clav = "">
	
<cfelse>	

	<cfset fund = "">
	<cfset fdid = "">
	<cfset clan = "#url.view#">
	<cfset clav = "#url.value#">
				
</cfif>

<cfparam name="url.unithierarchy" default="">


<!--- End Prosis template framework --->

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

<cfif Param.BudgetCurrency neq Application.BaseCurrency>						
	    <cfparam name="url.currency"   default="#Param.BudgetCurrency#">		
<cfelse>
	 <cfparam name="url.currency"   default="#Application.BaseCurrency#">	 
</cfif>		

<cfquery name="Expenditure" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    DISTINCT MandateNo, Period, AccountPeriod
	FROM      Ref_MissionPeriod
	WHERE     Mission = '#URL.Mission#'
	<cfif url.period neq "">
	AND       EditionId IN (SELECT EditionId
							FROM      Ref_MissionPeriod
							WHERE     Mission = '#URL.Mission#'
							AND       Period  = '#URL.Period#')  
	</cfif>						
</cfquery>

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

<cfparam name="url.find" default="">
<cfparam name="url.mode" default="regular">

<cfif url.mode eq "Print">

	<cfajaximport>

    <cfinclude template="FundingExecutionScript.cfm">

	<cfoutput>
	<title>Printable Version of Budget Execution</title>
	<link rel="stylesheet" type="text/css" href="#SESSION.root#/#client.style#"> 		
	<link rel="stylesheet" type="text/css" href="#SESSION.root#/print.css" media="print">
	</cfoutput>
    
</cfif>


<!--- ----------------------------------------- --->
<!--- ------------ REQUISITION ---------------- --->
<!--- ----------------------------------------- --->


<!--- ---------------pipeline------------------ --->
<cfinvoke component = "Service.Process.Program.Execution"  
		   method           = "Requisition" 
		   mission          = "#url.mission#"
		   mandateNo        = "#man#"
		   editionid        = "#url.editionid#"
		   Currency         = "#url.currency#"
		   Status           = "Pipeline"		   
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
		   editionid        = "#url.editionid#"
		   Currency         = "#url.currency#"
		   Status           = "Planned"
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
		   editionid        = "#url.editionid#"
		   Currency         = "#url.currency#"
		   status           = "Cleared"
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
		   editionid        = "#url.editionid#"
		   Currency         = "#url.currency#"
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
			   editionid          = "#url.editionid#"
			   Currency           = "#url.currency#"
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
		   Currency         = "#url.currency#"
		   editionid        = "#url.editionid#"
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
	   
<cfif url.mission eq "OICT" or url.mission eq "DM_FMS">

	<!--- --------invoices processed outside -------- --->		
	<cfinvoke component = "Service.Process.Program.IMIS"  
		   method           = "IMIS" 
		   mission          = "#url.mission#"
		   mandateNo        = "#man#"
		   editionid        = "#url.editionid#"
		   Currency         = "#url.currency#"
		   Fund             = "#fund#"
		   Class            = "#clan#" 
		   ClassValue       = "#clav#"
		   unitmode         = "Organization"
		   unithierarchy    = "#url.unithierarchy#"
		   period           = "#persel#" 		   
		   accountperiod    = "#peraccsel#"	  
		   mode             = "table"
		   table            = "#SESSION.acc#IMIS">		

</cfif>		    

<cfquery name="SelectBase" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_AllotmentEdition
	WHERE    EditionId IN (SELECT  EditionId
	                  	   FROM    Organization.dbo.Ref_MissionPeriod P
						   WHERE   Mission = '#URL.Mission#' 
							AND    Period = '#URL.Period#')
</cfquery>

<cf_tl id="Select" var="1">
<cfset vSelect= lt_text>

<!--- select versions --->

<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_AllotmentEdition	         
	WHERE    Mission      = '#URL.Mission#'
	AND      (Period      = '#URL.Period#' or Period is NULL)	
	AND      EditionClass = 'Budget'	
	AND      EditionId    = '#url.EditionId#'
</cfquery>

<!--- --------------------------------- --->		   
<!--- usually there is just one edition --->
<!--- --------------------------------- --->

<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">	

<cfset cols = "12">
	   
<cfloop query="Edition">

	<cfset vers = version>
	
	<!--- no longer needed as we have another button 
				
	<cfif url.mode eq "Print">
	
		<tr><td colspan="<cfoutput>#cols#</cfoutput>" align="center" height="35" class="noprint">
			<cf_tl id="Print" var="vPrint">			
			<input type="button" class="button10s" style="width:130;height:23" name="Print" id="Print" value="<cfoutput>#vPrint#</cfoutput>" onClick="window.print()">
		</td></tr>
	
	</cfif>	
					
	<cfif mode eq "Print">
	
		<cfoutput>
		<tr><td colspan="#cols#" height="40" class="labelmedium"><cf_tl id="Budget Execution"> #url.mission# #url.period#</td></tr>
		<tr><td colspan="#cols#" class="line"></td></tr>
		</cfoutput>
		
		<tr class="labelit" class="linedotted">	
			
			<td style="width:55%"></td>
			<td bgcolor="f4f4f4" align="center" style="border-left: 1px solid Gray;"><cf_space spaces="#spc#"><cf_tl id="Requested"><br>[a1]</td>
			<cfif Edition.AllocationEntryMode eq "0">		
			<td bgcolor="f4f4a4" align="center" style="border-left: 1px solid Gray;"><cf_space spaces="#spc#"><cf_tl id="Budgeted"><br>[a2]</td>
			<cfelse>
			<td bgcolor="f4f4a4" align="center" style="border-left: 1px solid Gray;"><cf_space spaces="#spc#"><cf_tl id="Released"><br>[a2]</td>
			</cfif>
			<td bgcolor="ffffaf" align="center" style="border-left: 1px solid Gray;"><cf_space spaces="#spc#"><cf_tl id="Pipeline"><br>[b0]</td>
			
			<td bgcolor="ffffaf" align="center" style="border-left: 1px solid Gray;"><cf_space spaces="#spc#"><cf_tl id="Approval"><br>[b1]</td>
			<td bgcolor="ffffaf" align="center" style="border-left: 1px solid Gray;"><cf_space spaces="#spc#"><cf_tl id="Procurement"><br>[b2]</td>		
			<td bgcolor="eeeeaf" align="center" style="border-left: 1px solid Gray;"><cf_space spaces="#spc#"><cf_tl id="Unliquidated"><br>[d]</td>	
			<td bgcolor="eeeeaf" align="center" style="border-left: 1px solid Gray;"><cf_space spaces="#spc#"><cf_tl id="Disbursed"><br>[e]</td>		
						
			<cfif url.mission eq "OICT" or url.mission eq "DM_FMS">
			<td bgcolor="eeeeaf" align="center" style="border-left: 1px solid Gray;"><cf_space spaces="#spc#"><cf_tl id="IMIS"><br></td>						
			<cfelse>
			<td bgcolor="eeeeaf" align="center" style="border-left: 1px solid Gray;"><cf_space spaces="#spc#"><cf_tl id="Commitment"><br>[d+e]</td>			
			</cfif>			
						
			<cfif Parameter.FundingCheckCleared eq "0">
			<td bgcolor="E7F5FA" align="center" style="border-left: 1px solid Gray;"><cf_space spaces="#spc#"><cf_tl id="Balance"><br>a1-b12-d-e</td>	
			<cfelse>
			<td bgcolor="E7F5FA" align="center" style="border-left: 1px solid Gray;"><cf_space spaces="#spc#"><cf_tl id="Balance"><br>a2-b12-d-e</td>	
			</cfif>		
			
			<!--- added 11/6/2011 --->			
			<td bgcolor="B0FFB0" align="center" style="border-left: 1px solid Gray;"><cf_space spaces="#spc#"><cf_tl id="Execution"><br>[f]</td>			
			
			<td bgcolor="eAeAeA" style="border-left: 1px solid Gray;"><cf_space spaces="6"></td>
		</tr>
			
	</cfif>
	
	--->
					
	<cftry>
	
	<!--- ------ create tables with budget------ --->	
	<cfinvoke component = "Service.Process.Program.Execution"  
		   method           = "Budget" 
		   period           = "#url.period#" 
		   planningperiod   = "#url.planningperiod#"
		   mission          = "#url.mission#"		   
		   mandateNo        = "#man#"
		   currency         = "#url.currency#"
		   Fund             = "#fund#"
		   Class            = "#clan#" 
		   ClassValue       = "#clav#"		
		   Status           = "0" 	     
		   unithierarchy    = "#url.unithierarchy#"
		   editionid        = "#Edition.EditionId#"
		   table            = "#SESSION.acc#Requirement"
		   mode             = "table">		
		   			   
	<!--- ------ create tables with allotment------ --->		
	
	<cfquery name="Edition" 
		    datasource="AppsProgram" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_AllotmentEdition E, Ref_AllotmentVersion V
			WHERE  E.Version = V.Code
			AND   EditionId = '#EditionId#' 
	</cfquery>
	
	<cfif edition.AllocationEntryMode lte "2">
		<cfset st = "1">
	<cfelse>
		<cfset st = "3">  <!--- workflow cleared --->
	</cfif>
	
	<cfinvoke component = "Service.Process.Program.Execution"  
		   method           = "Budget" 
		   period           = "#url.period#" 		 
		   mission          = "#url.mission#"
		   mandateNo        = "#man#"		   
		   currency         = "#url.currency#"
		   Fund             = "#fund#"		   
		   Class            = "#clan#" 
		   ClassValue       = "#clav#"
		   Status           = "#st#"
		   unithierarchy    = "#url.unithierarchy#"
		   editionid        = "#Edition.EditionId#"
		   table            = "#SESSION.acc#Release"
		   mode             = "table">	   
		   	
	<cfoutput>
	
	<cfparam name="SelectBase.EditionId" default="">
	<cfparam name="ed" default="">
		
	<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
		SELECT TOP 1 * 
        FROM   OrganizationAuthorization
		WHERE  UserAccount    = '#SESSION.acc#'
		AND    Mission        = '#URL.Mission#'
		AND    Role           = 'ProcReqInquiry'
		AND    ClassParameter = '#URL.EditionId#'	
		AND    OrgUnit is NULL
	</cfquery>	
	
	<cfif check.recordcount gte "1" or getAdministrator(url.mission) eq "1">
	
		<cfset accessall = "1">
	
	<cfelse>
	
		<cfset accessall = "0">
		
	</cfif>
	
	<tr class="navigation_row">
		
		<td height="30" width="100%">	
				
		   <cfif mode neq "Print">
		
		   <table width="100%" cellspacing="0" cellpadding="0">		   
		  
		   <tr>
		   
		    <cfif accessall eq "1">
			
		    <td width="30" class="noprint" 
			   style="padding-left:3px" 
			   onclick="object('','#url.mission#','#url.planningperiod#','#url.period#','','','#edition.editionid#','#fund#')">
			   								
				   <cf_space spaces="4">				   						
										
				   <img src="#SESSION.root#/Images/arrow.gif" alt="" 
					id="_#edition.editionid#_#fund#Exp" border="0" class="regular" 
						align="absmiddle" style="cursor: pointer;" height="12" width="14">
										
				   <img src="#SESSION.root#/Images/arrowdown.gif" 
					id="_#edition.editionid#_#fund#Min" alt="" border="0" 
					align="absmiddle" class="hide" style="cursor: pointer;" height="12" width="12">									
												
			</td>	
			
			<cfelse>
			
			  <td width="30" class="noprint" 
			   style="padding-left:3px">
			   </td>
			
			
			</cfif>
			
			<td>
			
			<cfquery name="Period" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * 
				FROM   Ref_Period
				WHERE  Period = '#url.period#'	
			</cfquery>	
							
				<cfif url.unithierarchy eq "">
				
					<cfset myurl = "_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('FundingExecutionData.cfm?man=#man#&hierarchy='+document.getElementById('applyhierarchy').checked+'&view='+document.getElementById('view').value+'&value='+document.getElementById('value').value+'&find='+document.getElementById('findsearch').value+'&mission=#mission#&planningperiod=#planningperiod#&period=#period#&editionid=#editionid#&currency='+document.getElementById('currency').value+'&unithierarchy='+document.getElementById('orgunit').value,'content')">
									    
					<table width="100%">
					<tr>
						<td style="cursor:pointer;padding-left:10px;font-size:20px;height:32px" onclick="object('','#url.mission#','#url.planningperiod#','#url.period#','','','#edition.editionid#','#fund#')">
						     #URL.Mission# #Period.Description# 
						</td>
						<cfif Param.BudgetCurrency neq Application.BaseCurrency>						
						   							
							<td align="right" style="padding-right:5px;padding-top:1px">
							    <cfoutput>
							   	<select name="currency" id="currency" onchange="#myurl#" style="background-color:transparent;border:0px;font-size:15px;height:30px;width:80">
								    <option value="#Param.BudgetCurrency#" <cfif url.currency eq Param.BudgetCurrency>selected</cfif>>#Param.BudgetCurrency#</option>	
								    <option value="#Application.BaseCurrency#" <cfif url.currency eq Application.BaseCurrency>selected</cfif>>#Application.BaseCurrency#</option>															
								</select>
								</cfoutput>
							</td>
						<cfelse>
											   
						   <td>(#Application.BaseCurrency#)
							<input type="hidden" id="currency" name="currency" value="#application.basecurrency#">
							</td>
						</cfif>
						
					</tr>
					</table>
										
				<cfelse>
				
					<cfset myurl = "_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('FundingExecutionData.cfm?man=#man#&hierarchy='+document.getElementById('applyhierarchy').checked+'&view='+document.getElementById('view').value+'&value='+document.getElementById('value').value+'&find='+document.getElementById('findsearch').value+'&mission=#mission#&planningperiod=#planningperiod#&period=#period#&editionid=#editionid#&currency='+document.getElementById('currency').value+'&unithierarchy='+document.getElementById('orgunit').value,'content')">
									    
					<table width="100%">
					<tr>
						<td style="cursor:pointer;padding-left:10px;font-size:20px;height:32px" onclick="object('','#url.mission#','#url.planningperiod#','#url.period#','','','#edition.editionid#','#fund#')">
						     <cf_tl id="unit total">
						</td>
						<cfif Param.BudgetCurrency neq Application.BaseCurrency>						
						   							
							<td align="right" style="padding-right:5px;padding-top:1px">
							    <cfoutput>
							   	<select name="currency" id="currency" onchange="#myurl#" style="background-color:transparent;border:0px;font-size:15px;height:30px;width:80">
								    <option value="#Param.BudgetCurrency#" <cfif url.currency eq Param.BudgetCurrency>selected</cfif>>#Param.BudgetCurrency#</option>	
								    <option value="#Application.BaseCurrency#" <cfif url.currency eq Application.BaseCurrency>selected</cfif>>#Application.BaseCurrency#</option>															
								</select>
								</cfoutput>
							</td>
						<cfelse>
											   
						   <td>(#Application.BaseCurrency#)
							<input type="hidden" id="currency" name="currency" value="#application.basecurrency#">
							</td>
						</cfif>
						
					</tr>
					</table>				
					
					
				</cfif>
									 			 
			 </td>
			 			 
			 </tr></table>
			 
	   </cfif>
		 
	   </td>
		
	   <td align="right" bgcolor="CEF1F4" style="#stc#">	
	  		
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
		
		<td align="right" style="#stc#" bgcolor="D9FFD9">
				
			<cfquery name="Total" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   SUM(Total) AS Total 
				FROM     userQuery.dbo.#SESSION.acc#Release					
			</cfquery>	
			
			<cfif Total.Total eq "">
			  <cfset all = 0>
			<cfelse>
			  <cfset all =  Total.Total>
			</cfif>
		   		   
		   <cf_space align="right" label="#numberformat(all/1000,"_,_._")#" spaces="#spc#"> 
		
		</td>	
		
		<!--- added in October 4th --->
		
		<cfif url.mission neq "STL">	
		
		<td align="right" style="#stc#">
		
			<!--- define reservations --->
			<cfquery name="Pipeline" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   SUM(ReservationAmount) as Amount 
				FROM     #SESSION.acc#Pipeline
			</cfquery>			
			
			<cfif Pipeline.Amount eq "">
			  <cfset pip = 0>
			<cfelse>
			  <cfset pip =  Pipeline.Amount>
			</cfif>
			
			<cf_space align="right" label="#numberformat(pip/1000,"_,_._")#" spaces="#spc#">
		
		</td>		
		
		</cfif>		
		
		<td align="right" style="#stc#">
		
			<!--- define reservations --->
			<cfquery name="Planned" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   SUM(ReservationAmount) as PlannedAmount 
				FROM     #SESSION.acc#Planned
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
			</cfquery>		
			
			<cfif Invoice.InvoiceAmount eq "">
			  <cfset inv = 0>
			<cfelse>
			  <cfset inv =  Invoice.InvoiceAmount>
			</cfif>	
						
			<cf_space align="right" label="#numberformat(inv/1000,"_,_._")#" spaces="#spc#">
			
		</td>				
		
		<td align="right" bgcolor="B7DBFF" style="#stc#">
		
		  <cfif url.mission eq "OICT" or url.mission eq "DM_FMS">
		  
		    <cfquery name="IMIS" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   SUM(ExpenditureAmount) as ExpenditureAmount
				FROM     #SESSION.acc#IMIS		
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
						<cfset cl = "e8e8e8">
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
						<cfset cl = "e8e8e8">
					</cfif>
				<cfelse>
					<cfset exe = "n/a">
					<cfset cl = "silver">
				</cfif>			
			
			</cfif>
			
			<cfif cl eq "red">			
				<td bgcolor="#cl#" align="right" style="#stc#;color:white">					
					<cf_space align="right" label="#exe#" color="white" spaces="#spc#">					
				</td>
			<cfelse>
				<td bgcolor="#cl#" align="right" style="#stc#">										
					<cf_space align="right" label="#exe#" spaces="#spc#">					
				</td>					
			</cfif>	
		
		<td width="3" bgcolor="white" style="padding-right:1px;border-left: 1px solid Gray;">&nbsp;&nbsp;</td>
		
	</tr>
			
	<tr id="d_#edition.editionid#_#fund#" class="hide">										     
		 <td colspan="#cols#" id="i_#edition.editionid#_#fund#" bgcolor="white"></td>				
	</tr>	
				
	</cfoutput>	
		
	<cfcatch>
	
		<tr><td align="center"
		        colspan="<cfoutput>#cols#</cfoutput>" height="40" class="labelmedium">Data could not be retrieved. Please make your selection again</font></td>
		</tr>
		<cfabort>
		
	</cfcatch>
	
	</cftry>	
	
	
	<!--- -------------------------------- --->
	<!--- show all funds for this edition  --->
	<!--- -------------------------------- --->
			
	<cfinclude template="FundingExecutionDataLines.cfm">		
								
	<tr><td height="2"></td></tr>
	
		<cfoutput>
		
		<cfif url.mode eq "Regular">
	
			<!--- show summary of the data i graphical format --->
			<script>
				parent.parent.ColdFusion.navigate('FundingExecutionProperties.cfm?mission=#url.mission#&planningperiod=#url.planningperiod#&period=#url.period#','propertybox')	
			</script>
			
		</cfif>
		
		</cfoutput>
		
</cfloop>

</table>	

<cfset ajaxonload("doHighlight")>
<script>
Prosis.busy("no")
</script>