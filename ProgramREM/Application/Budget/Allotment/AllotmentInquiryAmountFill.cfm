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
<cfinvoke component="Service.Presentation.Presentation" 
      	  method="highlight" 
		  neutral="labelit"
		  class="highlight3 cellcontent"
		  returnvariable="stylescroll"/>		  
	  
<cfquery name="EditionRecord" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM Ref_AllotmentEdition
		WHERE    EditionId = '#URL.Edition#' 
</cfquery>		

<cfquery name="Parameter" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM     Ref_ParameterMission
		WHERE    Mission = '#EditionRecord.Mission#'
</cfquery>

<cfquery name="EditionFund" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
		SELECT   EditionId, ltrim(rtrim(Fund)) as Fund
		FROM     Ref_AllotmentEditionFund
		WHERE    EditionId = '#URL.Edition#'		
		ORDER BY EditionId,Fund
</cfquery>		

<!--- check if execution is needed for this edition --->

<cfquery name="Execution" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM Ref_MissionPeriod P
		WHERE    Mission = '#EditionRecord.Mission#' 
		AND      EditionId = '#URL.Edition#'
		<!--- edition is not disabled for execution show --->
		AND     EditionId IN (SELECT EditionId 
			                  FROM   Program.dbo.Ref_AllotmentEdition 
							  WHERE  ControlExecution = 1
							  AND    EditionId = P.EditionId)
</cfquery>		

<cfif execution.recordcount gte "1" and url.execution neq "hide">
    
    <cfset exe = 1>
  
    <cfset persel = "">
	<cfset peraccsel = "">
	
	<cfloop query="Execution">
	
		  <cfif persel eq "">
		     <cfset persel = "'#Period#'"> 
			 <cfset peraccsel = "'#AccountPeriod#'"> 
		  <cfelse>
		     <cfset persel = "#persel#,'#Period#'">
			 <cfset peraccsel = "#peraccsel#,'#AccountPeriod#'"> 
		  </cfif>
	  
	</cfloop>
  
<cfelse>
    <!--- this is not an execution --->
    <cfset exe = 0>	  
	
</cfif>  

<cfset list = "">

<!--- ------- --->
<!--- edition --->
<!--- ------- --->
  
<cfoutput query="EditionFund">

	<cfif list eq "">
		<cfset list = "#fund#"> 
	<cfelse>
	    <cfset list = "#list#,#fund#"> 
	</cfif>
	
</cfoutput>


<!--- ----- --->
<!--- total --->
<!--- ----- --->
		
<cfparam name="list_#edition#" default="#list#">

<!--- preset values --->
<cfset edmode = 1>
<cfset BudgetAccess = "EDIT">

<cfswitch expression="#url.mode#">
	
<!--- ---------------------------------------- --->
<!--- --- 1/3 --- OBJECT and PARENT --------- --->
<!--- ---------------------------------------- --->
		
		<cfcase value="cell">		
				
				<cfloop index="fd" list="#evaluate('list_#Edition#')#">
				
					<cfquery name="Check" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT      *
						FROM        Ref_Object
						WHERE       ParentCode = '#ObjectCode#'					
				   </cfquery>	
				   
				   <cfif check.recordcount eq "0">
				    <cfset isParent = "0">
				   <cfelse>
				    <cfset isParent = "1">
				   </cfif>
				   
				   <cfset par = "0">
					   
				   <cfquery name="Fund" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT      Fund, 
						            SUM(Amount) as amount,									
									(
									  SELECT count(*) 
									  FROM   ProgramAllotmentRequest 
									  WHERE    ProgramCode  = '#program#'
									  AND      Period       = '#period#'								  	 
									  <cfif Check.recordcount eq "0">
									  AND         ObjectCode  = '#ObjectCode#'	
									  <cfelse>
									  AND         ObjectCode IN (
									                             SELECT Code 
										                         FROM   Ref_Object 
										 				         WHERE  ParentCode = '#ObjectCode#' OR ObjectCode = '#ObjectCode#'
																 )																																											
																									
									  </cfif>
									  AND      EditionId    = '#Edition#'
									  AND      Fund         = D.Fund	
									  AND      ActionStatus = '0'
									 ) as Blocked 
						
						FROM        ProgramAllotmentDetail D
						WHERE       ProgramCode = '#program#'	
						AND         Period      = '#period#'    
						AND         EditionId   = '#Edition#'
						<cfif Check.recordcount eq "0">
						AND         ObjectCode  = '#ObjectCode#'	
						<cfelse>
						AND         ObjectCode IN (SELECT Code 
						                            FROM   Ref_Object 
												    WHERE  ParentCode = '#ObjectCode#' OR ObjectCode = '#ObjectCode#'
												   )																																											
																					
						</cfif>
						AND         Fund        = '#fd#'				
						AND         Status IN ('P','0','1') <!--- corrected hanno upon refreshing 16/10 status IN ('0','1') --->  
						GROUP BY Fund
						
				   </cfquery>					  
							 			   
				   <cfparam name="searchresult.Edition_#Edition#_#fd#" default="0">	
				
				   <cfif fund.amount neq "">				   
						<cfset searchresult["Edition_#Edition#_#fd#"] = fund.amount>
						<cfset searchresult["Blocked_#Edition#_#fd#"] = fund.blocked>
				   </cfif>
					
				   <!--- -------------- --->
				   <!--- show execution --->
				   <!--- -------------- --->										
										
					<cfif exe eq "1">	
					
						<cfinvoke component = "Service.Process.Program.Execution"  
								   method           = "Requisition" 
								   mission          = "#EditionRecord.mission#"
								   programCode      = "#program#"
								   period           = "#persel#" 
								   currency         = "#parameter.budgetcurrency#"
								   fund             = "#fd#"
								   Object           = "#ObjectCode#"
								   ObjectParent     = "#isParent#"
								   Mode             = "View"
								   ReturnVariable   = "Requisition">		 
								   
						<cfinvoke component = "Service.Process.Program.Execution"  
								   method           = "Obligation" 
								   mission          = "#EditionRecord.mission#"
								   programCode      = "#program#"
								   period           = "#persel#" 
								   currency         = "#parameter.budgetcurrency#"
								   fund             = "#fd#"
								   Object           = "#ObjectCode#"
								   ObjectParent     = "#isParent#"
								   Mode             = "View"
								   ReturnVariable   = "Obligation">		
								   
						<cfinvoke component = "Service.Process.Program.Execution"  
								   method           = "Disbursement" 
								   mission          = "#EditionRecord.mission#"
								   programCode      = "#program#"
								   period           = "#persel#" 
								   accountperiod    = "#peraccsel#"	  
								   currency         = "#parameter.budgetcurrency#"
								   fund             = "#fd#"
								   Object           = "#ObjectCode#"
								   ObjectParent     = "#isParent#"
								   Mode             = "View"
								   ReturnVariable   = "Disbursement">	
								   
						<cfparam name="searchresult.Requisition_#Edition#_#fd#"  default="#Requisition.ReservationAmount#">	
						<cfparam name="searchresult.Obligation_#Edition#_#fd#"   default="#Obligation.ObligationAmount#">
						<cfparam name="searchresult.Disbursement_#Edition#_#fd#" default="#Disbursement.InvoiceAmount#">		   	
								   
					</cfif>			
					
																							
				</cfloop>			
		
				<cfquery name="Total" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT      sum(Amount) as amount						           
						FROM        ProgramAllotmentDetail
						WHERE       ProgramCode = '#program#'	
						AND         Period      = '#period#'    
						AND         EditionId   = '#Edition#'
						<cfif isParent eq "0">
						AND         ObjectCode  = '#ObjectCode#'	
						<cfelse>
						AND         (ObjectCode  = '#ObjectCode#' or ObjectCode IN (SELECT Code FROM Ref_Object WHERE ParentCode = '#ObjectCode#'))
						</cfif>				
						AND         Status IN ('P','0','1') <!--- corrected hanno upon refreshing 16/10 not showing status IN ('0','1') --->			
				</cfquery>	
				
				<cfparam name="searchresult.Edition_#Edition#_total" default="0">	
				
				<cfif total.amount neq "">				   
					<cfset searchresult["Edition_#Edition#_total"] = total.amount>
				</cfif>
				
				<!--- -------------- --->
				<!--- show execution --->
				<!--- -------------- --->		
					
				<cfif exe eq "1">	
				
						<cfquery name="Req" dbtype="query">
						     SELECT Sum(ReservationAmount) as ReservationAmount 
							 FROM Requisition						
						</cfquery>
					
						<cfquery name="Obl" dbtype="query">
						     SELECT Sum(ObligationAmount) as ObligationAmount 
							 FROM Obligation						
						</cfquery>
						
						<cfquery name="Dis" dbtype="query">
						     SELECT Sum(InvoiceAmount) as InvoiceAmount 
							 FROM Disbursement					
						</cfquery>														   
					
						<cfparam name="searchresult.Requisition_#Edition#_total"  default="#Req.ReservationAmount#">	
						<cfparam name="searchresult.Obligation_#Edition#_total"   default="#Obl.ObligationAmount#">
						<cfparam name="searchresult.Disbursement_#Edition#_total" default="#Dis.InvoiceAmount#">
						
				</cfif>				
												
				<cfset code = objectcode>
					
				<!--- output the cell --->
								
				<cfinclude template="AllotmentInquiryCellObject.cfm">				
					
		</cfcase>					
		
		<cfcase value="celltot">
		
			 <cfset par = "0">
			 
			 <cfquery name="CellTotal" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT      sum(Amount) as amount
						FROM        ProgramAllotmentDetail
						WHERE       ProgramCode = '#program#'	
						AND         Period      = '#period#'    	
						AND         ObjectCode IN (SELECT Code 
						                            FROM   Ref_Object 
												    WHERE  ParentCode = '#ObjectCode#' OR ObjectCode = '#ObjectCode#'
												   )												
										
						AND         Status IN ('P','0','1') <!--- status IN ('0','1') --->				
				</cfquery>		
				
				<cfset total = 0>
				
				<cfif Celltotal.amount neq "">				   
					<cfset total = Celltotal.amount>
				</cfif>
		
				<!--- output the cell --->
				
				<cfinclude template="AllotmentInquiryCellTotal.cfm">
		
		</cfcase>	
		
<!--- ---------------------------------------- --->
<!--- --- 2/3 ------- RESOURCES -------------- --->
<!--- ---------------------------------------- --->
				
		<cfcase value="res">		
				
				<cfloop index="fd" list="#evaluate('list_#Edition#')#">
													   
				   <cfset par = "0">
					   
				   <cfquery name="Fund" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT      Fund, sum(Amount) as amount
						FROM        ProgramAllotmentDetail
						WHERE       ProgramCode = '#program#'	
						AND         Period      = '#period#'    
						AND         EditionId   = '#Edition#'						
						AND         ObjectCode  IN (SELECT Code FROM Ref_Object WHERE Resource = '#url.resource#')
						AND         Fund        = '#fd#'				
						AND         Status IN ('P','0','1') <!--- status IN ('0','1') --->
						GROUP BY Fund
				   </cfquery>	
							 			   
				    <cfparam name="searchresult.Edition_#Edition#_#fd#" default="0">	
				
					<cfif fund.amount neq "">				   
						<cfset searchresult["Edition_#Edition#_#fd#"] = fund.amount>
					</cfif>					
													
					<!--- -------------- --->
					<!--- show execution --->
					<!--- -------------- --->		
						
					<cfif exe eq "1">	
						
							<cfinvoke component = "Service.Process.Program.Execution"  
									   method           = "Requisition" 
									   mission          = "#EditionRecord.mission#"
									   programCode      = "#program#"
									   period           = "#persel#" 
									   currency         = "#parameter.budgetcurrency#"
									   fund             = "#fd#"
									   Resource         = "#url.resource#"
									   Mode             = "View"
									   ReturnVariable   = "Requisition">		 
									   
							<cfinvoke component = "Service.Process.Program.Execution"  
									   method           = "Obligation" 
									   mission          = "#EditionRecord.mission#"
									   programCode      = "#program#"
									   period           = "#persel#" 	
									   currency         = "#parameter.budgetcurrency#"	
									   fund             = "#fd#"						  
									   Resource         = "#url.resource#"
									   Mode             = "View"
									   ReturnVariable   = "Obligation">		
									   
							<cfinvoke component = "Service.Process.Program.Execution"  
									   method           = "Disbursement" 
									   mission          = "#EditionRecord.mission#"
									   programCode      = "#program#"
									   period           = "#persel#" 								   
									   accountperiod    = "#peraccsel#"	  	
									   currency         = "#parameter.budgetcurrency#"							  
									   fund             = "#fd#"
									   Resource         = "#url.resource#"
									   Mode             = "View"
									   ReturnVariable   = "Disbursement">										   
						
							<cfparam name="searchresult.Requisition_#Edition#_#fd#"  default="#Requisition.ReservationAmount#">	
							<cfparam name="searchresult.Obligation_#Edition#_#fd#"   default="#Obligation.ObligationAmount#">
							<cfparam name="searchresult.Disbursement_#Edition#_#fd#" default="#Disbursement.InvoiceAmount#">
							
					</cfif>		
				
				</cfloop>			
		
				<cfquery name="Total" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT      sum(Amount) as amount
						FROM        ProgramAllotmentDetail
						WHERE       ProgramCode = '#program#'	
						AND         Period      = '#period#'    
						AND         EditionId   = '#Edition#'
						AND         ObjectCode  IN (SELECT Code FROM Ref_Object WHERE Resource = '#url.resource#')				
						AND         Status IN ('P','0','1') <!--- status IN ('0','1') --->		
				</cfquery>	
				
				<cfparam name="searchresult.Edition_#Edition#_total" default="0">	
				
				<cfif total.amount neq "">				   
					<cfset searchresult["Edition_#Edition#_total"] = total.amount>
				</cfif>
													
				<cfif exe eq "1">	
									
						<cfquery name="Req" dbtype="query">
						     SELECT Sum(ReservationAmount) as ReservationAmount  
							 FROM Requisition						
						</cfquery>
					
						<cfquery name="Obl" dbtype="query">
						     SELECT Sum(ObligationAmount) as ObligationAmount 
							 FROM Obligation						
						</cfquery>
						
						<cfquery name="Dis" dbtype="query">
						     SELECT Sum(InvoiceAmount) as InvoiceAmount 
							 FROM Disbursement					
						</cfquery>													   
					
						<cfparam name="searchresult.Requisition_#Edition#_total"  default="#Req.ReservationAmount#">	
						<cfparam name="searchresult.Obligation_#Edition#_total"   default="#Obl.ObligationAmount#">
						<cfparam name="searchresult.Disbursement_#Edition#_total" default="#Dis.InvoiceAmount#">
						
				</cfif>										
								
				<!--- output the cell --->
				<cfset scp = "Category">			
				<cfinclude template="AllotmentInquiryCellSubTotal.cfm">				
					
		</cfcase>	
		
		<!--- ------------------------- --->
		<!--- -----resource total ----- --->
		<!--- ------------------------- --->
		
		<cfcase value="restot">
		
			 <cfset par = "0">
			 
			 <cfquery name="CellTotal" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT      sum(Amount) as amount
						FROM        ProgramAllotmentDetail
						WHERE       ProgramCode = '#program#'	
						AND         Period      = '#period#'    					
						AND         ObjectCode  IN (SELECT Code FROM Ref_Object WHERE Resource = '#url.resource#')					
						AND         Status <> '9'					
				</cfquery>		
				
				<cfset total = 0>
				
				<cfif Celltotal.amount neq "">				   
					<cfset total = Celltotal.amount>
				</cfif>
		
				<!--- output the cell --->
				
				<cfinclude template="AllotmentInquiryCellTotal.cfm">
		
		</cfcase>	
		
<!--- ---------------------------------------- --->
<!--- --- 3/3 ------- HEADER ----------------- --->
<!--- ---------------------------------------- --->
				
		<cfcase value="hea">		
				
				<cfloop index="fd" list="#evaluate('list_#Edition#')#">
													   
				   <cfset par = "0">
					   
				   <cfquery name="Fund" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT      Fund, sum(Amount) as amount
						FROM        ProgramAllotmentDetail
						WHERE       ProgramCode = '#program#'	
						AND         Period      = '#period#'    
						AND         EditionId   = '#Edition#'												
						AND         Fund        = '#fd#'				
						AND         Status <> '9'
						GROUP BY Fund
				   </cfquery>	
							 			   
				    <cfparam name="searchresult.Edition_#Edition#_#fd#" default="0">	
				
					<cfif fund.amount neq "">				   
						<cfset searchresult["Edition_#Edition#_#fd#"] = fund.amount>
					</cfif>		
																		
					<!--- -------------- --->
					<!--- show execution --->
					<!--- -------------- --->		
						
					<cfif exe eq "1">	
						
							<cfinvoke component = "Service.Process.Program.Execution"  
									   method           = "Requisition" 
									   mission          = "#EditionRecord.mission#"
									   programCode      = "#program#"
									   period           = "#persel#" 
									   currency         = "#parameter.budgetcurrency#"
									   fund             = "#fd#"
									   Mode             = "View"
									   ReturnVariable   = "Requisition">		 
									   
							<cfinvoke component = "Service.Process.Program.Execution"  
									   method           = "Obligation" 
									   mission          = "#EditionRecord.mission#"
									   programCode      = "#program#"
									   period           = "#persel#" 		
									   currency         = "#parameter.budgetcurrency#"
									   fund             = "#fd#"
									   Mode             = "View"
									   ReturnVariable   = "Obligation">		
									   
							<cfinvoke component = "Service.Process.Program.Execution"  
									   method           = "Disbursement" 
									   mission          = "#EditionRecord.mission#"
									   programCode      = "#program#"
									   period           = "#persel#" 								   
									   accountperiod    = "#peraccsel#"	  	
									   currency         = "#parameter.budgetcurrency#"							  
									   fund             = "#fd#"
									   Mode             = "View"
									   ReturnVariable   = "Disbursement">										   
						
							<cfparam name="searchresult.Requisition_#Edition#_#fd#"  default="#Requisition.ReservationAmount#">	
							<cfparam name="searchresult.Obligation_#Edition#_#fd#"   default="#Obligation.ObligationAmount#">
							<cfparam name="searchresult.Disbursement_#Edition#_#fd#" default="#Disbursement.InvoiceAmount#">
														
					</cfif>	
							
																		
				</cfloop>			
		
				<cfquery name="Total" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT      sum(Amount) as amount
						FROM        ProgramAllotmentDetail
						WHERE       ProgramCode = '#program#'	
						AND         Period      = '#period#'    
						AND         EditionId   = '#Edition#'							
						AND         Status <> '9'					
				</cfquery>	
				
				<cfparam name="searchresult.Edition_#Edition#_total" default="0">	
				
				<cfif total.amount neq "">				   
					<cfset searchresult["Edition_#Edition#_total"] = total.amount>
				</cfif>
				
				<!--- -------------- --->
				<!--- show execution --->
				<!--- -------------- --->		
					
				<cfif exe eq "1">					
					
						<cfquery name="Req" dbtype="query">
						     SELECT Sum(ReservationAmount) as ReservationAmount 
							 FROM Requisition						
						</cfquery>
					
						<cfquery name="Obl" dbtype="query">
						     SELECT Sum(ObligationAmount) as ObligationAmount 
							 FROM Obligation						
						</cfquery>
						
						<cfquery name="Dis" dbtype="query">
						     SELECT Sum(InvoiceAmount) as InvoiceAmount 
							 FROM Disbursement					
						</cfquery>					
								   
						<cfparam name="searchresult.Requisition_#Edition#_total"  default="#Req.ReservationAmount#">	
						<cfparam name="searchresult.Obligation_#Edition#_total"   default="#Obl.ObligationAmount#">
						<cfparam name="searchresult.Disbursement_#Edition#_total" default="#Dis.InvoiceAmount#">
						
				</cfif>								
												
				<!--- output the cell --->
				<cfset scp = "">				
				<cfinclude template="AllotmentInquiryCellSubtotal.cfm">				
					
		</cfcase>	
		
		<cfcase value="heatot">
		
			 <cfset par = "0">
			 
			 <cfquery name="CellTotal" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT      sum(Amount) as amount
						FROM        ProgramAllotmentDetail
						WHERE       ProgramCode = '#program#'	
						AND         Period      = '#period#'    													
						AND         Status <> '9'					
				</cfquery>		
				
				<cfset total = 0>
				
				<cfif Celltotal.amount neq "">				   
					<cfset total = Celltotal.amount>
				</cfif>
		
				<!--- output the cell --->
				
				<cfinclude template="AllotmentInquiryCellTotal.cfm">
		
		</cfcase>				
	
	</cfswitch>