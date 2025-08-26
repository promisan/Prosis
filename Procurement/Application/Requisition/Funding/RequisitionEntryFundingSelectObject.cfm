<!--
    Copyright © 2025 Promisan

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

<!--- Prosis template framework --->
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Show resources budget</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->


<cfparam name="URL.Mission"          default="">
<cfparam name="URL.Scope"            default="">
<cfparam name="URL.CellWidth"        default="21">

<cfparam name="URL.PlanPeriod"       default="">
<cfparam name="URL.Period"           default="FY 04/05">
<cfparam name="URL.ProgramClass"     default="">
<cfparam name="URL.ProgramHierarchy" default="">
<cfparam name="URL.Fund"             default="">
<cfparam name="URL.View"             default="">
<cfparam name="URL.UnitHierarchy"    default="">
<cfparam name="URL.ObjectCode"       default="">
<cfparam name="URL.ItemMaster"       default="">
<cfparam name="URL.Edition"          default="">
<cfparam name="URL.Mode"             default="select">

<cfquery name="Base" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    DISTINCT O.Code, O.Resource
	FROM      ItemMasterObject I, 
	          Program.dbo.Ref_Object O
	WHERE     I.ObjectCode = O.Code
	AND       I.ItemMaster = '#url.itemmaster#'
</cfquery>		

<cfset resr = "''">
<cfset objr = "''">

<!--- get the OE associated to the selected item master --->

<cfloop query="Base">
    <cfif resr eq "">
		<cfset resr = "'#Resource#'">
	<cfelse>
		<cfset resr = "#resr#,'#Resource#'">
	</cfif>	
	<cfif objr eq "">
		<cfset objr = "'#Code#'">
	<cfelse>
		<cfset objr = "#objr#,'#Code#'">
	</cfif>	
</cfloop>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Program
	WHERE  ProgramCode = '#ProgramCode#' 
</cfquery>

<cfif url.programhierarchy eq "determine">
   <cfset url.programhierarchy = program.programhierarchy>
</cfif>	

<!--- define expenditure periods --->

<cfquery name="Expenditure" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    DISTINCT Period,
	                   AccountPeriod
	FROM      Ref_MissionPeriod
	WHERE     Mission = '#URL.Mission#'
	<cfif url.period neq "">
	AND       EditionId IN (SELECT  EditionId
							FROM    Ref_MissionPeriod
							WHERE   Mission = '#URL.Mission#'
							AND     Period  = '#URL.Period#')  
	</cfif>						
</cfquery>

<cfset persel = "">
<cfset peraccsel = "">

<cfloop query="Expenditure">

	  <cfif persel eq "">
	     <cfset persel    = "'#Period#'"> 
		 <cfset peraccsel = "'#AccountPeriod#'"> 
	  <cfelse>
	     <cfset persel    = "#persel#,'#Period#'">
		 <cfset peraccsel = "#peraccsel#,'#AccountPeriod#'"> 
	  </cfif>
  
</cfloop>

<cfif url.edition eq "">
	
	<cfquery name="EditionSelect" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_AllotmentEdition
		WHERE    EditionId IN (
		                       SELECT  EditionId
		                  	   FROM    Organization.dbo.Ref_MissionPeriod P
							   WHERE   Mission = '#URL.Mission#' 
							   AND     Period  = '#URL.Period#'
							  )
	</cfquery>

	<cfset edition = editionselect.editionid>

<cfelse>

	<cfquery name="EditionSelect" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_AllotmentEdition
		WHERE    EditionId = '#url.edition#'		
	</cfquery>

	<cfset edition = url.edition>
	
</cfif>	

<cfquery name="Version" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_AllotmentVersion
	WHERE     Code = '#EditionSelect.version#'
</cfquery>		

<!--- -------------------------------------------------------------------------------- --->
<!--- effort to show only relevant objects that we want to allow funding selection for --->
<!--- reasons for selection one of the below for select or underlying programs/projects
      1. enforce show for Program/OE/fund
	  2. Has allotment
	  3. Has expenditure
	  4. Has disbursement for partipating OE to execution 	  
--->
<!--- -------------------------------------------------------------------------------- --->		   
	
<cfquery name="PlanningPeriod" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_MissionPeriod P
		WHERE   Mission = '#URL.Mission#' 
		AND     Period  = '#URL.Period#'
</cfquery>			

<cfif planningperiod.planningperiod neq "">
    <!--- this is a redirect plan period --->
	<cfset planningperiod = planningperiod.planningperiod>
<cfelseif url.planperiod neq "">
    <cfset planningperiod = url.planperiod>
<cfelse>
     <!--- this is a plan period --->
    <cfset planningperiod = url.period>
</cfif>

<!--- run a query of the objectcode used under financials --->

<cftransaction isolation="READ_UNCOMMITTED">

<cfquery name="GLedgerUsed" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">

		SELECT    V.ObjectCode 			           	
		 FROM      TransactionLine L INNER JOIN
		           TransactionHeader H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo INNER JOIN
				   Ref_Account V ON L.GLAccount = V.GLAccount
		 WHERE     H.Mission      = '#URL.Mission#'					   
		 AND       H.TransactionSource IN ('AccountSeries','ReconcileSeries') 	
		
		    <cfif ProgramHierarchy neq "">
			
			AND    L.ProgramCode IN (SELECT ProgramCode 
                                     FROM   Program.dbo.ProgramPeriod 
									 WHERE  Period = '#planningperiod#'
									 AND    PeriodHierarchy LIKE '#ProgramHierarchy#%')																
										
			<cfelseif ProgramCode neq "">
							
			AND      L.ProgramCode = '#ProgramCode#'
														
			</cfif>						 
		
			
		 <cfif url.fund neq "">
			AND    L.Fund          = '#URL.Fund#'
		</cfif>
		 AND       L.AccountPeriod IN (#preservesingleQuotes(peraccsel)#) 		
		 <!---  AND    R.ObjectCode IN (SELECT Code FROM Ref_Object WHERE Procurement = 1)	--->		
										
		UNION
			
		<!--- D. Objects have been actually used for this program or related program ! --->	
					
		SELECT   L.ObjectCode 			           	
		FROM     Accounting.dbo.TransactionLine L INNER JOIN
		         Accounting.dbo.TransactionHeader H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo 
		WHERE    H.Mission       = '#URL.Mission#'			   
		AND      H.TransactionSource IN ('PayrollSeries','PurchaseSeries','AccountSeries','ReconcileSeries')  	
				 
		  <cfif ProgramHierarchy neq "">
			
			AND    L.ProgramCode IN (SELECT ProgramCode 
                                     FROM   Program.dbo.ProgramPeriod 
									 WHERE  Period = '#planningperiod#'
									 AND    PeriodHierarchy LIKE '#ProgramHierarchy#%')																	
										
			<cfelseif ProgramCode neq "">
		
			AND  L.ProgramCode = '#ProgramCode#'
														
			</cfif>			
		 				
		 <cfif url.fund neq "">
			AND  L.Fund          = '#URL.Fund#'
		</cfif>			
		AND      L.ProgramPeriod = '#URL.Period#'	
		 <!--- AND    L.ObjectCode IN (SELECT Code FROM Ref_Object WHERE Procurement = 1)	--->			
</cfquery>		


</cftransaction>

<cftransaction isolation="READ_UNCOMMITTED">

<!--- get a list of OE to show for this context (fund/project --->

	<cfquery name="Object" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   R.*,
		         S.Name as resourceName, 
				 S.Description as ResourceDescription,
				 (SELECT count(*) FROM Ref_Object WHERE ParentCode = R.Code) as isParent
		FROM     Ref_Object R,
		         Ref_Resource S
		WHERE    S.Code = R.Resource	
				
		<!--- Show objects that are in the same usage class --->
		AND      R.Code IN (
		                    SELECT Code 
		                    FROM   Ref_Object 
							WHERE  ObjectUsage = '#Version.ObjectUsage#' 
							<cfif url.mode neq "List">
							<!--- used for procurement validation in the requisition screen --->
							AND    Procurement = '1'
							</cfif>
						   )
						  
		<cfif url.mode eq "List">
						   
		AND    (
						
			    <!--- B. Inhertance disabled as users may enable object codes now even if they are not alloted --->
			
			    R.Code IN (SELECT Code 
				           FROM   Program.dbo.Ref_Object 
						   WHERE  Code IN (SELECT ParentCode 
						                   FROM   Program.dbo.Ref_Object)
						   )
				
				OR
				
					  
		        R.Code IN
	                   (SELECT DISTINCT D.ObjectCode
					    FROM   Program P,
						       ProgramAllotmentDetail D
				        WHERE  P.ProgramCode = D.ProgramCode
						AND    ABS(D.Amount) > 10					
						
						<cfif ProgramHierarchy neq "">
						
						AND    P.ProgramCode IN (SELECT ProgramCode 
			                                     FROM   Program.dbo.ProgramPeriod 
												 WHERE  PeriodHierarchy LIKE '#ProgramHierarchy#%')
												 AND    Period = '#planningperiod#'
												 <!--- WHERE  ProgramCode = '#url.programcode#') --->
												 <!--- Hierarchy LIKE '#left(ProgramHierarchy,7)#%') --->
												 <!--- CMP is funded on the higher level and the project roll-up
										         WHERE  ProgramHierarchy LIKE '#ProgramHierarchy#%') --->							
													
						<cfelseif ProgramCode neq "">
					
						AND       P.ProgramCode = '#ProgramCode#'
																	
						</cfif>
															
						
						AND    D.Period        = '#planningperiod#' 
						
	       			    AND    D.EditionId     = '#Edition#'
						
						<!--- added for OICT to prevent showing too many OE --->
						<cfif url.fund neq "">
						AND    D.Fund          = '#URL.Fund#'
						</cfif>
				       
					   )	
					   
					   
				OR 
				
				<!--- C. Objects have been actually used for this program or related program ! --->	
				
		        R.Code IN
	                   (SELECT DISTINCT LF.ObjectCode
					    FROM   Purchase.dbo.RequisitionLine L, Purchase.dbo.RequisitionLineFunding LF
				        WHERE  L.RequisitionNo = LF.RequisitionNo
						AND    L.ActionStatus != '9' AND L.ActionStatus > '1'
						
						<cfif ProgramHierarchy neq "">
												
						AND    LF.ProgramCode IN (SELECT ProgramCode 
                                     FROM   Program.dbo.ProgramPeriod 
									 WHERE  Period = '#planningperiod#'
									 AND    PeriodHierarchy LIKE '#ProgramHierarchy#%')									
													
						<cfelseif ProgramCode neq "">
					
						AND      LF.ProgramCode = '#ProgramCode#'
																							
						</cfif>														 
												 
						AND    L.Mission        = '#URL.Mission#'										
						AND    LF.ProgramPeriod = '#URL.Period#'		 
						<cfif url.fund neq "">
						AND    LF.Fund          = '#URL.Fund#'
						</cfif>     
					   )		
					
				<!--- or the code is used in financials --->
				
				<cfif GLedgerUsed.recordcount neq "0">
					   
				OR   R.Code IN (#QuotedValueList(GLedgerUsed.ObjectCode)#)	      
				
				</cfif>
				
				)
							
		</cfif>		
								   
		ORDER BY S.ListingOrder, R.HierarchyCode	
				
	</cfquery>	
	
</cftransaction>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">

<!--- show the header --->

<cfif url.mode eq "List">		
	   <cfset col = 12> 
	   <cfset spc = url.cellwidth> 		  
	   <cfset ostyle  = "height:22px;padding-right:1px;border-left: 1px solid silver; border-top: 1px solid silver; border-bottom: 0px dotted gray;">
<cfelse>	
	   <!--- selection for funding --->	
	   <cfset col = 9>
	   <cfset spc = 22>
	   <cfset ostyle  = "height:22px;border-left:1px solid silver;border-top: 1px solid silver; border-bottom: 1px dotted gray;">
</cfif>

<cfset stc = ostyle>

<!--- loop through all the objects that are valid --->

<cfif url.scope eq "Embed">

<tr>
     				
		<td colspan="3" height="20" width="100%" style="padding-left:7px;padding-right:7px;">
										
		<cfquery name="EditionList" 
		    datasource="AppsProgram" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		       SELECT *
		       FROM   Ref_AllotmentEdition
			   WHERE  EditionId = '#url.Edition#' 
		</cfquery>
		
		</td>
		
		<cfoutput>
		
		<td class="labelit" bgcolor="f4f4f4" align="center" style="#stc#"><cf_space spaces="#spc#">
		
		 <cf_tl id="Requested" var="tRequested">
		 
		 <cf_helpfile code = "Procurement" 
			 class            = "Execution"
			 id               = "cola1" 
			 styleclass       = "labelit"
			 name             = "#tRequested#"
			 displaytext      = "#tRequested#<br>(a1)"
			 mode             = "dialog"
			 display          = "Text">
		
		</td>
				
		 <td class="labelit" bgcolor="ffffFf" align="center" style="#stc#">
		 
		 <cf_space spaces="#spc#">
		 <cf_tl id="Pipeline" var="tPipeline">
		 
		 <cf_helpfile code = "Procurement" 
			 class            = "Execution"
			 id               = "colb0" 
			 styleclass       = "labelit"
			 name             = "Requests in Pipeline"
			 displaytext      = "#tPipeline#<br>(b0)"
			 mode             = "dialog"
			 display          = "Text">
		 </td>	 
		 
		 <td class="labelit" bgcolor="ffffaf" align="center" style="#stc#">
		 
		 <cf_space spaces="#spc#">
		 <cf_tl id="Approval" var="tApproval">
		 
		 <cf_helpfile code = "Procurement" 
			 class            = "Execution"
			 id               = "colb1" 
			 styleclass       = "labelit"
			 name             = "Requests Approved"
			 displaytext      = "#tApproval#<br>(b1)"
			 mode             = "dialog"
			 display          = "Text">
		 </td>	 
		 
		 <td class="labelit" bgcolor="ffffaf" align="center" style="#stc#">
		 
		 <cf_space spaces="#spc#">
		 <cf_tl id="Purchase" var="tPurchase">
		 
		 <cf_helpfile code = "Procurement" 
			 class            = "Execution"
			 id               = "colb2" 
			 styleclass       = "labelit"
			 name             = "Requests under Purchase"
			 displaytext      = "#tPurchase#<br>(b2)"
			 mode             = "dialog"
			 display          = "Text">
		 </td>	 
		
		<td class="labelit" bgcolor="eeeeaf" align="center" style="#stc#">
		 
		 <cf_space spaces="#spc#">
		 <cf_tl id="Unliquid." var="tUnliquidated">
		 
		 <cf_helpfile code = "Procurement" 
			 class            = "Execution"
			 id               = "cold" 
			 styleclass       = "labelit"
			 name             = "Unliquidated Obligations"
			 displaytext      = "#tUnliquidated#<br>(d)"
			 mode             = "dialog"
			 display          = "Text">
		 </td>	 		
		
		<td class="labelit" bgcolor="eeeeaf" align="center" style="#stc#">
		 
		 <cf_space spaces="#spc#">
		 <cf_tl id="Disbursed" var="tDisbursed">
		 
		 <cf_helpfile code = "Procurement" 
			 class            = "Execution"
			 id               = "cole" 
			 styleclass       = "labelit"
			 name             = "Disbursed Obligations"
			 displaytext      = "#tDisbursed#<br>(e)"
			 mode             = "dialog"
			 display          = "Text">
		 </td>	 		
		
		 <!--- UN OICT only as per request of segolene --->
		<cfif url.mission eq "OICT" or url.mission eq "DM_FMS">		   
			<td align="center" class="labelit" bgcolor="B7DBFF" style="#stc#"><cf_space spaces="#spc#"><cf_tl id="IMIS"><br>
			 <cfif url.view eq "fund">			  
				  <a href="javascript:imis('#expenditure.accountperiod#','#url.value#','','','#url.editionid#','#url.mission#','','')">[...]</a>			
			  </cfif>
			</td>						
		<cfelse>
		
		<td class="labelit" bgcolor="eeeeaf" align="center" style="#stc#">
		 
		 <cf_space spaces="#spc#">
		 <cf_tl id="Committed" var="tCommitted">
		 
		 <cf_helpfile code = "Procurement" 
			 class            = "Execution"
			 id               = "colde" 
			 styleclass       = "labelit"
			 name             = "Committed Funds"
			 displaytext      = "#tCommitted#<br>(d+e)"
			 mode             = "dialog"
			 display          = "Text">
			 
		 </td>	 		
		
		</cfif>
		
		<cfif Parameter.FundingCheckCleared eq "0" or url.scope eq "embed">
		<td class="labelit" bgcolor="E7F5FA" align="center" style="#stc#"><cf_space spaces="#spc#"><cf_tl id="Balance"><br>a1-b12-d-e</td>	
		<cfelse>
		<td class="labelit" bgcolor="E7F5FA" align="center" style="#stc#"><cf_space spaces="#spc#"><cf_tl id="Balance"><br>a2-b12-d-e</td>	
		</cfif>		
		
		<!--- added 11/6/2011 --->			
		<td class="labelit" bgcolor="B0FFB0" align="center" style="#stc#"><cf_space spaces="#spc#"><cf_tl id="Execution"><br>[f]</td>	
				
		</cfoutput>

		<td bgcolor="eAeAeA" style="padding-left:3px;border-left: 1px solid Gray;"><cf_space spaces="6"></td>
		
		</tr>

</cfif>		

<!--- correction 17/12/2014 --->

<cfif url.scope eq "embed">

		<!--- reset the tables to run only one --->

		<cfinvoke component = "Service.Process.Program.Execution"  
				   method           = "Budget" 
				   period           = "#url.period#" 
				   mission          = "#url.mission#"
				   editionid        = "#Edition#"
				   currency         = "#application.basecurrency#"
				   fund             = "#url.fund#"
				   unithierarchy    = "#url.unithierarchy#"
				   programcode      = "#url.programcode#"
				   programhierarchy = "#ProgramHierarchy#"				  	
				   objectchildren   = "1"	  
				   status           = "0"      
				   table            = "#SESSION.acc#Requirement">	
				   
		<cfinvoke component = "Service.Process.Program.Execution"  
				   method           = "Requisition" 
				   mission          = "#url.mission#"
				   period           = "#persel#" 
				   fund             = "#url.fund#"
				   currency         = "#application.basecurrency#"
				   status           = "pipeline"
				   unithierarchy    = "#url.unithierarchy#"
				   programcode      = "#url.programcode#"
				   programhierarchy = "#ProgramHierarchy#"			   
				   objectchildren   = "1"			  
				   returnvariable   = "#SESSION.acc#Pipeline">			
				  				   
		<cfinvoke component = "Service.Process.Program.Execution"  
				   method           = "Requisition" 
				   mission          = "#url.mission#"
				   period           = "#persel#" 
				   currency         = "#application.basecurrency#"
				   fund             = "#url.fund#"
				   status           = "planned"
				   unithierarchy    = "#url.unithierarchy#"
				   programcode      = "#url.programcode#"
				   programhierarchy = "#ProgramHierarchy#"			   
				   objectchildren   = "1"			  
				   returnvariable   = "#SESSION.acc#Planned">	
				
		<cfinvoke component = "Service.Process.Program.Execution"  
				   method           = "Requisition" 
				   mission          = "#url.mission#"
				   period           = "#persel#" 
				   currency         = "#application.basecurrency#"
				   fund             = "#url.fund#"
				   status           = "cleared"
				   unithierarchy    = "#url.unithierarchy#"
				   programcode      = "#url.programcode#"
				   programhierarchy = "#ProgramHierarchy#"			   
				   objectchildren   = "1"			  
				   returnvariable   = "#SESSION.acc#Requisition">					    
				   
		<cfinvoke component = "Service.Process.Program.Execution"  
				   method           = "Obligation" 
				   mission          = "#url.mission#"
				   period           = "#persel#" 
				   currency         = "#application.basecurrency#"
				   fund             = "#url.fund#"
				   unithierarchy    = "#url.unithierarchy#"
				   programcode      = "#url.programcode#"
				   programhierarchy = "#ProgramHierarchy#"				   
				   objectchildren   = "1"
				   scope            = "Unliquidated"
				   returnvariable   = "#SESSION.acc#Unliquidated">					   
				   
		<cfinvoke component = "Service.Process.Program.Execution"  
				   Method           = "Disbursement" 
				   Mission          = "#url.mission#"
				   Period           = "#persel#" 
				   AccountPeriod    = "#peraccsel#"
				   currency         = "#application.basecurrency#"
				   Fund             = "#url.fund#"
				   unithierarchy    = "#url.unithierarchy#"
				   programcode      = "#url.programcode#"
				   Programhierarchy = "#ProgramHierarchy#"
				   Scope            = "Budget"				  
				   ObjectChildren   = "1"
				   returnvariable   = "#SESSION.acc#Unliquidated">				   

</cfif>

<cfquery name="FundRecords" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 
	     SELECT *
		 FROM   ProgramAllotmentDetail 
		 WHERE  ProgramCode   = '#URL.ProgramCode#'												
		 AND    Period        = '#planningperiod#' 																										
		 AND    EditionId     = '#Edition#'
		 AND    Status IN ('0','1')
		
</cfquery>

<tr><td colspan="<cfoutput>#col+1#</cfoutput>" class="line"></td></tr>



<cfoutput query="Object" Group="ResourceName">
	
	<tr class="navigation_row line">
		    
	    <td colspan="3" class="labelmedium" 
		 style="width:100%;height:26px;font-size:14px;padding-left:16px;border-right:1px solid gray;color:804000">#ResourceDescription#</td>		
				
	   <cfset ostyle  = "padding-right:1px;height:25;border-right:1px solid gray;">
												
		<cfset filtermode = "Resource">
		<!--- show the data content --->
		<cfinclude template="RequisitionEntryFundingSelectObjectData.cfm">	
		
		<td bgcolor="white" style="border-left: 1px solid Gray;padding:1px;padding-left:7px"></td>
				
	</tr>
		
	<cfoutput>
				
	<cfquery name="Existing" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT * 
			 FROM   RequisitionLineFunding 
			 WHERE  RequisitionNo = '#URL.ID#'
			 <cfif url.fund neq "">
			 AND    Fund          = '#URL.Fund#'
			 </cfif>
			 AND    ProgramCode   = '#URL.ProgramCode#'
			 AND    ObjectCode    = '#Code#'
	 </cfquery>
	 	 
	 <!--- overwrite check if the OE should be shown for all OE under that resource --->
	 
	 <cfquery name="Overwrite" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	 	    SELECT  *
			FROM     Ref_ParameterMissionEntryClass
			WHERE    Mission = '#URL.Mission#' 
			AND      Period  = '#URL.Period#'
	</cfquery>		
	
	 <cfquery name="Extend" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	 	    SELECT  *
			FROM     Ref_ParameterMissionEntryClass
			WHERE    Mission = '#URL.Mission#' 
			AND      Period  = '#URL.Period#'
			AND      EntryClass = (SELECT EntryClass 
                                   FROM   ItemMaster 
			                       WHERE  Code = '#url.itemmaster#' )
	</cfquery>			
										 
	<cfquery name="Procurement" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	      SELECT Code 
		  FROM   Ref_Object 
		  WHERE  Procurement = 1		  
		  <!--- current looped OE --->		  
		  AND    Code = '#Code#'		  
	</cfquery>
	
	<cfif Procurement.recordcount eq "0">
	  <cfset cl = "fafafa">
	<cfelse>
	  <cfset cl = "transparent">	 
	</cfif>
	
	<!--- check if we need to hide or not --->
	
	<cfinvoke component = "Service.Process.Program.Execution"  
			   method           = "Budget" 
			   period           = "#url.period#" 
			   mission          = "#url.mission#"
			   editionid        = "#Edition#"
			   fund             = "#url.fund#"
			   currency         = "#application.basecurrency#"
			   unithierarchy    = "#url.unithierarchy#"
			   programcode      = "#url.programcode#"
			   programhierarchy = "#ProgramHierarchy#"
			   object           = "#code#"		
			   objectchildren   = "1"	 
			   status           = "1" 			  
			   mode             = "view"
			   returnvariable   = "Check">	
			   
	<cfinvoke component = "Service.Process.Program.Execution"  
			   method           = "Disbursement" 
			   mission          = "#url.mission#"
			   period           = "'#url.period#'" 				   
			   currency         = "#application.basecurrency#"
			   fund             = "#url.fund#"
			   unithierarchy    = "#url.unithierarchy#"
			   programcode      = "#url.programcode#"
			   programhierarchy = "#ProgramHierarchy#"				   
			   object           = "#code#"
			   objectChildren   = "1"
			   mode             = "view"
			   returnvariable   = "Check2">				   
	
	<cfif url.mode neq "List" or (Check.total neq "" and Check.total neq "0") or Check2.recordcount gte "1">
			
		<tr class="navigation_row <cfif ParentCode eq "">line<cfelse>linesoft</cfif>">	
		
		<td bgcolor="#cl#" colspan="2" align="left" width="100%">
		
			<table width="100%" cellspacing="0" cellpadding="0">
			
			<tr class="labelmedium" style="height:<cfif ParentCode eq "">21<cfelse>16</cfif>px">
			<td style="padding-left:30px"></td>
			<td width="59" style="padding-right:6px">
			
				<cfif ParentCode eq "">
					<cfif codedisplay neq "">#CodeDisplay#<cfelse>#Code#</cfif>
				<cfelse>
					<table cellspacing="0" cellpadding="0">
					  <tr class="labelmedium" style="height:16px">
					  <td><img src="#SESSION.root#/images/join.gif" height="10" width="10" alt="" border="0" align="absmiddle"></td>
					  <td style="padding-left:4px"><font color="808080"><cfif codedisplay neq "">#CodeDisplay#<cfelse>#Code#</cfif></td>
					  </tr>
					</table>
				</cfif>	
				
			</td>
			
			<td width="100%" class="labelmedium">
			
				<cfif ParentCode eq "">
					<cfif len(description) gt "40">
					#left(description,40)#..
					<cfelse>
					#Description#
					</cfif>
				<cfelse>
					<font color="808080">
					<cfif len(description) gt "40">
					#left(description,40)#..
					<cfelse>
					#Description#
					</cfif>
					</font>
				</cfif>	
				
			</td>
			
			</tr>
			</table>
		</td>
		
		<td bgcolor="#cl#" align="left" width="5%" style="padding-right:4px">
					
			<cfif url.mode neq "List">		
					
			    <!--- this is to select the funding --->
				 			
				<cfif existing.recordcount gte "1" and Program.ProgramScope is "Unit">				
												
				         <input type="checkbox" 
						     name="ObjectCode" 
	                         id="ObjectCode"
							 class="radiol"
						     value="#ProgramCode#-#Code#-#Fund#" 
							 onClick="hl(this, this.checked)" checked>
							 							
				<cfelse>		
										 					
						<cfparam name="Parameter.FundingOnProgram" default="0">					
											
						<cfif procurement.recordcount eq "1">
											
								<!--- enabled for procurement --->
						
							     <!--- if Project and funding also occurs on Project check in addition --->
								 
								<cfif Program.ProgramScope is "Unit">
															
								<cftransaction isolation="READ_UNCOMMITTED">							
								
									 <!--- if Project and funding also occurs on Project check in addition --->
								  							
									<cfif Parameter.EnforceObject eq "1" or Parameter.EnforceObject eq "0">								
								 
										 <cfquery name="hasFunds" 
									     datasource="AppsProgram" 
									     username="#SESSION.login#" 
									     password="#SESSION.dbpw#">
										 
										     SELECT SUM(Amount) as Budget
											 FROM   ProgramAllotmentDetail 
											 WHERE  ProgramCode   = '#URL.ProgramCode#'								
											
											 AND    Period        = '#planningperiod#' 
																											
											 AND    EditionId     = '#Edition#'
											  AND   Status IN ('0','P','1')
											 
											 <cfif url.fund neq "">								 
											 AND    Fund          = '#URL.Fund#'								 
											 </cfif>	
											 
											 <cfif Parameter.EnforceObject eq "0">
											 
											 AND    ObjectCode    = '#Code#'
											 
											 <cfelse>
											 								 
												 <cfif URL.ItemMaster neq "" 
												 
												   <!--- the filter for OE selection is turned on --->
												  									      										   
												   <!--- and it not exempted for this period --->
												   
												   AND Overwrite.DisableFundingCheck eq "0">
												   
												   		<cfif extend.ItemMasterObjectExtend eq "0">	
														
															<!---  show OE as check only if the OE is ALSO present in-the-list-to-be-shown for the ItemMaster select --->
																																					   
												            AND    ObjectCode  IN ( SELECT Code 
										                                            FROM   Program.dbo.Ref_Object															 
																			        WHERE  Code  IN (#preservesinglequotes(objr)#)
																				    AND    Code = '#Code#' )	
															
														<cfelse>
																								
															<!---  show OE only if the resource of the OE is ALSO present in the list-to-be-shown for itemmaster select --->
															
															AND    ObjectCode IN ( SELECT Code 
										                                           FROM   Program.dbo.Ref_Object															 
																			       WHERE  Resource  IN (#preservesinglequotes(resr)#)
																				   AND    Resource = '#Resource#' )											
															
														</cfif>		
														
													<cfelse>
																						
													AND    ObjectCode    = '#Code#'
													
													</cfif>		
													
											</cfif>												 
										 															 
											 HAVING SUM(Amount) > 0			
											 
											</cfquery>											
																					
										 <cfquery name="hasAllocation" 
										     datasource="AppsProgram" 
										     username="#SESSION.login#" 
										     password="#SESSION.dbpw#"> 
											 										 
											 SELECT SUM(Amount) as Budget
											 FROM   ProgramAllotmentAllocation
			
											 WHERE  ProgramCode   = '#URL.ProgramCode#'								
											
											 AND    Period        = '#planningperiod#' 
																											
											 AND    EditionId     = '#Edition#'
																			 
											 <cfif url.fund neq "">								 
											 AND    Fund          = '#URL.Fund#'								 
											 </cfif>											 						
											 								 
											 <cfif URL.ItemMaster neq "" 
											 
											   <!--- the filter for OE selection is turned on --->
											   
										       AND Parameter.EnforceObject eq "1" 
											   
											   <!--- and it not exempted for this period --->
											   
											   AND Overwrite.DisableFundingCheck eq "0">
											   								   
											   		<cfif extend.ItemMasterObjectExtend eq "0">	
													
														<!---  only the associated OE --->															
														   
											            AND    ObjectCode  IN ( SELECT Code 
									                                            FROM   Program.dbo.Ref_Object															 
																		        WHERE  Code  IN (#preservesinglequotes(objr)#)
																			    AND    Code = '#Code#' )	
														
													<cfelse>
													
														<!---  for all OE in the resource of the associated OE --->
														
														AND    ObjectCode IN ( SELECT Code 
									                                           FROM   Program.dbo.Ref_Object															 
																		       WHERE  Resource  IN (#preservesinglequotes(resr)#)
																			   AND    Resource = '#Resource#' )											
														
													</cfif>		
													
											 <cfelse>								
																					
												AND    ObjectCode    = '#Code#'
												
											</cfif>												 
										 															 
											HAVING SUM(Amount) > 0									 							 
											  
										 </cfquery>											 																 									 						 
										 
										 <cfif hasFunds.Budget gt "0.00" or hasAllocation.budget gt "0.00">	
										 								 
										 	<cfset show = "1">
																				
										 <cfelse>
										 									 									 
										 	<!--- check of the project has any funds --->	
											
											 <cfquery name="hasAnyFunds" dbtype="query">
											 SELECT * FROM FundRecords
											 WHERE Fund = '#fund#'
											 AND   ObjectCode = '#Code#'
											 </cfquery>															
																					
											<cfif hasAnyFunds.recordcount eq "0">
																																										
											<cfset show = "0">										
										 
										 	<!--- check of the OE is enforced despite no funds --->						 					 
																									 
											 <cfquery name="Enforce" 
										     datasource="AppsProgram" 
										     username="#SESSION.login#" 
										     password="#SESSION.dbpw#">
										      		SELECT  *
								                    FROM    ProgramObject
								                    WHERE   ProgramCode = '#ProgramCode#'
													AND     EnforceFunding = 1  <!--- field added explicitly 14/3/2014 --->
																						
													 <cfif URL.ItemMaster neq "" 
													   <!--- the filter for OE selection is turned on --->
												       AND Parameter.EnforceObject eq "1" 
													   <!--- and it not exempted for this period --->
													   AND Overwrite.DisableFundingCheck eq "0">
													   
													   		<cfif extend.ItemMasterObjectExtend eq "0">	
															   
												              AND    ObjectCode  IN ( SELECT Code 
										                                           FROM   Program.dbo.Ref_Object															 
																			       WHERE  Code  IN (#preservesinglequotes(objr)#)
																				   AND    Code = '#Code#'
																				   )	
															
															<cfelse>
															
															AND    ObjectCode IN ( SELECT Code 
										                                           FROM   Program.dbo.Ref_Object															 
																			       WHERE  Resource  IN (#preservesinglequotes(resr)#)
																				   AND    Resource = '#Resource#'
																				  )											
															
															</cfif>		
															
														<cfelse>
														
														AND    ObjectCode    = '#Code#'
														
														</cfif>											
													
													<cfif url.fund neq "">
												    	AND     Fund        = '#URL.Fund#'
												    </cfif>						
													
											 </cfquery>		
											 
											 									 
										     <cfif Enforce.recordcount gte "1">										
											 	<cfset show = "1">
											 <cfelse>
											 	<cfset show = "0">	
											 </cfif>	
											 
											 <cfelse>
											 
											 <cfset show = "0">
											 
											 </cfif>								 
										 
										 </cfif>																							 
									
									<!---
									<cfelseif Parameter.EnforceObject eq "9" and hasAnyFunds.recordcount gte "1">	 
									--->
									<cfelseif Parameter.EnforceObject eq "9">
																																						
										<!--- we always consider to have funds --->
									
										<cfset show = "1">
										
									<cfelse>
									
										<cfset show = "0">		
										
									</cfif>	 							 			 				    
								 							 
								 </cftransaction>	
								 																												 
								 <cfif show eq "1">
																						 
								     <!--- if the object code is a parent disable the 
									     direct selection --->
									
									 <!---	 removed the parent limitation 
									     for selection in execution 14/3/2012
									 <cfif isParent eq "0">
									 --->
																				
								 		<input type="checkbox" 
								        name    = "ObjectCode" 
	                                    id      = "ObjectCode"
										class="radiol"
										value   = "#ProgramCode#-#Code#-#Fund#" 
										onClick = "hl(this, this.checked)"> 
									
									 <!---	
									 </cfif>	
									 --->
										
								 </cfif>													
								
							</cfif>
						
						</cfif>
																		
				</cfif>
			
			</cfif>
			
		
		</td>
		
		<cfif ParentCode eq "">
			<cfset ht = "17">
		<cfelse>
			<cfset ht = "13">
		</cfif>
					
		<cfif url.mode eq "List">		
		   <cfset col = 12> 
		   <cfset spc = 19> 			   
		   <cfset ostyle  = "height:#ht#;padding-right:4px;border-right:1px solid gray;filter: alpha(opacity=60);-moz-opacity: .60;opacity: .60;">
		<cfelse>
		   <cfset col = 9>
		   <cfset spc = 21>	   		  
		   <cfset ostyle  = "height:#ht#;padding-right:2px;border-right:1px solid gray;filter: alpha(opacity=60);-moz-opacity: .60;opacity: .60;">
		</cfif>
		
		<cfset filtermode = "Object">
			
		<!--- we only have to pass the spacing once in the same table --->
			
		<cfif currentrow gt "1">
		    <cfset spc = "0">
		</cfif>		
		
		<!--- show the data content --->	
				 
		<cfinclude template="RequisitionEntryFundingSelectObjectData.cfm">	
					
		<td bgcolor="white" style="border-left: 1px solid silver;padding-left:8px"></td>
		
		</tr>
				
		<!--- allotment box --->
		<tr class="hide" id="all#ProgramCode#_#edition#_#url.Fund#_#CurrentRow#">	    	   
		    <td style="padding:10px" width="95%" colspan="#col+1#" id="aall#ProgramCode#_#edition#_#url.Fund#_#CurrentRow#"></td>
		</tr>
		
		<!--- obligation box --->
		<tr class="hide" id="add#ProgramCode#_#edition#_#url.Fund#_#CurrentRow#">
			<td colspan="#col+1#" align="center" width="95%" style="padding:10px" id="iadd#ProgramCode#_#edition#_#url.Fund#_#CurrentRow#"></td>
		</tr>
		
		<!--- disbursement box --->
		<tr class="hide" id="inv#ProgramCode#_#edition#_#url.Fund#_#CurrentRow#">	  
		    <td colspan="#col+1#" style="padding:10px" width="95%" id="iinv#ProgramCode#_#edition#_#url.Fund#_#CurrentRow#"></td>
		</tr>
		
	</cfif>
			
	</cfoutput>	
		
</cfoutput>

<cfoutput>
	<tr><td colspan="#col+1#" style="background-color:e3e3e3;height:4px"></td></tr>
</cfoutput>

</table>

<cfset ajaxonload("doHighlight")>
