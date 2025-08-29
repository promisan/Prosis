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
<style>	
	td.itemselected {
		cursor:pointer;
		color:white;
		background-color:gray;	
	}
	
</style>

<cf_DialogProcurement>
<cf_DialogREMProgram>
<cf_DialogLedger>
<cf_DialogStaffing>
<cf_presentationscript>	  

<cfoutput>
	
	<script language="JavaScript">
		  
		 // UN only 
		  
		 function imis(yr,fd,act,obj,ed,mi,res,prg) {
		    ptoken.open("Detail/IMIS.cfm?editionid="+ed+"&programcode="+prg+"&year="+yr+"&fund="+fd+"&activity="+act+"&object="+obj+"&resource="+res+"&mission="+mi,"imis","left=30, top=30, width=#client.widthfull-80#, height=#client.height-80#, status=yes, toolbar=no, scrollbars=no, resizable=yes") 
		 }
		 
		 function reload(cur) { 
		     Prosis.busy('yes');
		     ptoken.open("FundingExecutionDetail.cfm?currency="+cur+"&editionid=#url.editionid#&unithierarchy=&mission=#url.mission#&box=#url.box#&reqno=#url.reqno#&fund=#url.fund#&period=#url.period#&programcode=#url.programcode#&programhierarchy=#url.programhierarchy#&objectcode=#url.objectcode#&isParent=#url.isParent#&mode=#url.mode#&resource=#url.resource#","_self")
		 } 
		 
		 function facttabledetailxls1(control,format,box) {  
		     ptoken.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?ts="+new Date().getTime()+"&box="+box+"&data=1&controlid="+control+"&format="+format, "facttable");
		 }		
		 	
		 function toggleme(box,itm) {
		    Prosis.busy('yes')
			_cf_loadingtexthtml='';	
		  	ptoken.navigate('Detail/'+box+'.cfm?objectcode=#url.objectCode#','row_details');
		 }
	   
	  		
	</script>

</cfoutput>

<cfparam name="URL.mission"          default="">
<cfparam name="URL.isParent"         default="0">
<cfparam name="URL.mode"             default="list">
<cfparam name="url.ProgramHierarchy" default="">
<cfparam name="url.UnitHierarchy"    default="">
<cfparam name="url.editionid"        default="">
<cfparam name="url.resource"         default="">

<cfset FileNo = round(Rand()*30)>
<cfset SESSION.FileNo = FileNo>
<CF_DropTable dbName="AppsQuery" tblName="Pipeline_#SESSION.acc#"    range="30">  
<CF_DropTable dbName="AppsQuery" tblName="Approval_#SESSION.acc#"    range="30">  
<CF_DropTable dbName="AppsQuery" tblName="Reservation_#SESSION.acc#" range="30">  
<CF_DropTable dbName="AppsQuery" tblName="Obligation_#SESSION.acc#"  range="30">  
<CF_DropTable dbName="AppsQuery" tblName="Invoice_#SESSION.acc#"     range="30">  

<cfif url.period eq "">

	<!--- define expenditire periods --->
	<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_AllotmentEdition
		WHERE     EditionId = '#url.editionid#'	
	</cfquery>
	
	<cfset url.period = edition.period>
	
</cfif>	

<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Program 
	WHERE    ProgramCode = '#URL.ProgramCode#' 	
</cfquery>

<cfquery name="PlanPeriod" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_MissionPeriod 
	WHERE    Mission = '#URL.Mission#' 	
	AND      Period  = '#url.period#'
</cfquery>

<cfif url.editionid eq "">
    <cfset url.editionid = planperiod.editionid>
</cfif>		

<cfif url.ProgramHierarchy eq "undefined">
      <cfset url.programhierarchy = "">
<cfelseif url.programhierarchy eq "determine">
      <cfset url.programhierarchy = program.programhierarchy>
</cfif>

<cfset prghier = url.ProgramHierarchy>

<cfif url.UnitHierarchy eq "undefined">
	<cfset url.UnitHierarchy = "">
</cfif>

<cfset orghier = url.UnitHierarchy>

<cfif url.mission eq "">
	 <cfset url.mission = program.mission>
</cfif>

<cfquery name="Period" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   * 
	FROM     Program P,
	         ProgramPeriod Pe
	WHERE    P.ProgramCode = Pe.ProgramCode
	AND      P.ProgramCode = '#url.programcode#'
	AND      Pe.Period     = '#planperiod.planningperiod#' 
</cfquery>	

<!--- define expenditire periods --->
<cfquery name="Expenditure" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    DISTINCT Period, AccountPeriod
	FROM      Ref_MissionPeriod
	WHERE     Mission = '#Program.Mission#'
	<cfif url.editionid eq "">
	AND       EditionId IN (SELECT   EditionId
							FROM     Ref_MissionPeriod
							WHERE    Mission = '#Program.Mission#'
							AND      Period  = '#URL.Period#') 
	<cfelse>
	AND       EditionId = '#url.editionid#'
	</cfif>		
	UNION
	
	SELECT    DISTINCT Period, AccountPeriod
	FROM      Ref_MissionPeriod
	WHERE     Mission = '#Program.Mission#'
	<cfif url.editionid eq "">
	AND       EditionIdAlternate IN (SELECT   EditionId
							FROM     Ref_MissionPeriod
							WHERE    Mission = '#Program.Mission#'
							AND      Period  = '#URL.Period#') 
	<cfelse>
	AND       EditionIdAlternate = '#url.editionid#'
	</cfif>		
</cfquery>

<cfquery name="Param" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   * 
	FROM     Ref_ParameterMission
	WHERE    Mission = '#Program.Mission#'
</cfquery>	

<cfset per = "">
<cfset peraccsel = "">

<cfloop query="Expenditure">

  <cfif per eq "">
     <cfset per = "'#Period#'"> 
	 <cfset peraccsel = "'#AccountPeriod#'"> 
  <cfelse>
     <cfset per = "#per#,'#Period#'">
	 <cfset peraccsel = "#peraccsel#,'#AccountPeriod#'"> 
  </cfif>
  
</cfloop>

<cfquery name="Object" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Object
	WHERE  Code = '#url.objectcode#'	
</cfquery>	

<cfquery name="ThisPeriod" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Period
	WHERE  Period = '#url.period#'	
</cfquery>	

<cfquery name="Resource" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Resource
	WHERE  Code = '#Object.Resource#'	
</cfquery>	

<cfif Resource.ExecutionDetail eq "1">

	<cfset drill = "1">
	
<cfelse>

		<cfinvoke component="Service.Access"  
				Method         = "budget"		
				Mission        = "#Program.mission#"
				Period         = "#planperiod.planningperiod#"									
				Role           = "'BudgetManager'"
				ReturnVariable = "BudgetAccess">	
					
		<cfif BudgetAccess eq "EDIT" or BudgetAccess eq "ALL">
				<cfset drill = "1">
		<cfelse>
				<cfset drill = "0">
		</cfif>			
		
</cfif>
	

<cfif url.resource eq "resource">
   <cfset resource = Object.Resource>   
<cfelse>
   <cfset resource = "">     
</cfif>

<cf_screentop height="100%" 
    scroll="Yes" 
	label="Budget and Execution" 
	layout="webapp" 	
	jquery="Yes"
	bannerforce="yes"
	menuPrint="yes">

<table width="95%" height="100%" cellspacing="0" cellpadding="0" border="0" align="center">
	  	
	<cfoutput>	
	
	<tr><td height="15"></td></tr>
	 
	<tr><td>
	
		<table width="100%" cellspacing="0" cellpadding="0">
		
		<tr>		 
		 <td style="min-width:100px" class="labelmedium"><cf_tl id="Program">:</font></td>
		 <td class="labelmedium"><b><cfif Period.Reference neq "">#Period.Reference#<cfelse>#url.programcode#</cfif> #Period.ProgramName# </td>
			
		 <td style="padding-left:20px;min-width:80px" class="labelmedium"><cf_tl id="Period">:</td>
		 <td class="labelmedium"><b>#ThisPeriod.Description#</td>
				
		 <td style="padding-left:20px;min-width:80px" class="labelmedium"><cf_tl id="Fund">:</td>
		 <td class="labelmedium"><b><cfif url.fund eq "">All<cfelse>#url.fund#</cfif></td>
			 
		 <td style="padding-left:20px;min-width:80px" class="labelmedium"><cf_tl id="Object">:</td>
		 <td class="labelmedium"><b><cfif Object.Code eq "">All<cfelse>#Object.CodeDisplay# [#url.objectcode#] #Object.Description#</cfif>
		 		 
		 </td>
		</tr>
		
		<tr>
		<td></td>
		<td colspan="6" class="labelt">
		<cfif url.programhierarchy neq "" and url.programhierarchy neq "undefined">
		Amounts include underlying programs and activities
		</cfif>
		</td>		
		
		<cfquery name="Check" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   Ref_Object
			WHERE  ParentCode = '#url.objectcode#'	
		</cfquery>	
		 <td colspan="1" class="labelt">		 
 		 <cfif url.isparent eq "1" and check.recordcount gte "1">
		 <font color="FF0000">incl. underlying Object codes</font>
		 </cfif>
		 </td>	
		</tr>
		
		<tr><td style="height:5px"></td></tr>
		<tr><td colspan="8" class="line"></td></tr>
				
		<tr class="line">
		
		 <td style="min-width:100px" class="labelmedium"><cf_tl id="Currency">:</td>
							
				<cfif Param.BudgetCurrency neq Application.BaseCurrency>	
				
					<cfparam name="url.currency" default="#Param.BudgetCurrency#">					
				   							
					<td colspan="8" style="padding-right:5px;padding-top:1px">
					   <cfoutput>
					   	<select name="currency" id="currency" onchange="reload(this.value)" style="border:0px;font-size:15px;height:30px;width:80">
						    <option value="#Param.BudgetCurrency#" <cfif url.currency eq Param.BudgetCurrency>selected</cfif>>#Param.BudgetCurrency#</option>	
						    <option value="#Application.BaseCurrency#" <cfif url.currency eq Application.BaseCurrency>selected</cfif>>#Application.BaseCurrency#</option>															
						</select>
						</cfoutput>
					</td>
					
				<cfelse>
					
				   <cfparam name="url.currency" default="#Application.BaseCurrency#">	
				   					   
				   <td colspan="8" class="labelmedium">#Application.BaseCurrency#
					<input type="hidden" id="currency" name="currency" value="#application.basecurrency#">
					</td>
					
				</cfif>
						
		</tr>
		
		</table>
		
	</td>
	</tr>	
								
	<tr><td height="100%" valign="top">
				
	<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center" class="navigation_table" 
	border="0">
		
	    <cfquery name="Edition" 
		    datasource="AppsProgram" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		       SELECT *
		       FROM   Ref_AllotmentEdition
			   WHERE  EditionId = '#URL.EditionId#' 
		</cfquery>		
		
														
		<!--- ------ create tables with budget------ --->	
		<cfinvoke component = "Service.Process.Program.Execution"  
			   method           = "Budget" 
			   period           = "#url.period#" 
			   mission          = "#Program.mission#"			  
			   Fund             = "#url.fund#"			   
			   Status           = "0" 	   
			   currency         = "#url.currency#"  
			   unithierarchy    = "#orghier#"
			   programhierarchy = "#prghier#"
			   Resource         = "#resource#"
			   Object           = "#url.objectCode#"
			   ObjectChildren   = "#url.isParent#"
			   editionid        = "#url.EditionId#"
			   ReturnVariable   = "Requirement"
			   mode             = "view">
			   
		<cfquery name="Total"
	         dbtype="query">
				SELECT    sum(Total) as Amount
				FROM      Requirement					
		  </cfquery>  		   
			   
		<tr height="20" class="line">
			<td style="padding-left:0px" class="labelmedium"><cf_tl id="Requested">:</td>
			<td></td>
			<td align="right" class="labelmedium" style="padding-right:5px">#numberformat(Total.Amount,',__')#</td>
		</tr>	
						   
		<!--- ------ create tables with requirement------ --->	
		<cfinvoke component = "Service.Process.Program.Execution"  
			   method           = "Budget" 
			   period           = "#url.period#" 
			   mission          = "#Program.mission#"				     
			   Fund             = "#url.fund#"		   			 
			   Status           = "1"
			   currency         = "#url.currency#"  
			   unithierarchy    = "#orghier#"
			   programhierarchy = "#prghier#"
			   Resource         = "#resource#"
			   Object           = "#url.objectCode#"
			   ObjectChildren   = "#url.isParent#"
			   editionid        = "#url.editionid#"
			   ReturnVariable   = "Allotment"
			   mode             = "view">	   
			   
		<cfquery name="Total"
	         dbtype="query">
				SELECT    sum(Total) as Amount
				FROM      Allotment				
		  </cfquery>  			   
		
		<tr height="20" class="line">
		
			<td style="padding-left:0px" class="labelmedium">
			
			<cfif Edition.AllocationEntryMode lte "1">		
			<cf_tl id="Approved">
			<cfelse>
			<cf_tl id="Allotted">
			</cfif>:
			</td>
			<td></td>
			<td align="right" style="padding-right:5px" class="labelmedium">#numberformat(Total.Amount,',__')#</td>
		
		</tr>
					
		<cfinvoke component = "Service.Process.Program.Execution"  
		   method           = "Requisition" 
		   mission          = "#Program.mission#"
		   currency         = "#url.currency#"  
		   programhierarchy = "#prghier#"
		   unithierarchy    = "#orghier#"
		   Resource         = "#resource#"
		   programcode      = "#URL.ProgramCode#"
		   period           = "#per#" 
		   status           = "pipeline"		   
		   fund             = "#url.fund#"
		   Object           = "#url.objectCode#"
		   ObjectChildren   = "#url.isParent#"
		   Content          = "Details"
		   Mode             = "Table"
		   Table		    = "Pipeline_#Session.ACC#_#fileno#">	
		
		<cfinvoke component = "Service.Process.Program.Execution"  
		   method           = "Requisition" 
		   mission          = "#Program.mission#"
		   currency         = "#url.currency#"  
		   programhierarchy = "#prghier#"
		   unithierarchy    = "#orghier#"
		   Resource         = "#resource#"
		   programcode      = "#URL.ProgramCode#"
		   period           = "#per#" 
		   status           = "planned"		   
		   fund             = "#url.fund#"
		   Object           = "#url.objectCode#"
		   ObjectChildren   = "#url.isParent#"
		   Content          = "Details"
		   Mode             = "Table"
		   Table  		    = "Approval_#Session.ACC#_#fileno#">	
		   
		 <cfinvoke component = "Service.Process.Program.Execution"  
		   method           = "Requisition" 
		   mission          = "#Program.mission#"
		   currency         = "#url.currency#"  
		   programhierarchy = "#prghier#"
		   programcode      = "#URL.ProgramCode#"
		   unithierarchy    = "#orghier#"
		   period           = "#per#" 
		   status           = "cleared"		   
		   fund             = "#url.fund#"
		   Resource         = "#resource#"
		   Object           = "#url.objectCode#"
		   ObjectChildren   = "#url.isParent#"
		   Content          = "Details"
		   Mode             = "Table"
		   Table            = "Reservation_#Session.ACC#_#fileno#">	
		  
		  <cfif url.mode neq "List">
		 		
			<cfinvoke component = "Service.Process.Program.Execution"  
			   method           = "Obligation" 
			   mission          = "#Program.mission#"
			   currency         = "#url.currency#"  
			   programhierarchy = "#prghier#"
			   programcode      = "#URL.ProgramCode#"
			   unithierarchy    = "#orghier#"
			   period           = "#per#" 			   
			   fund             = "#url.fund#"
			   Resource         = "#resource#"
			   Object           = "#url.objectCode#"
			   ObjectChildren   = "#url.isParent#"
			   Content          = "Details"
			   Mode             = "Table"
			   Table		    = "Obligation_#Session.ACC#_#fileno#">					 
					   
		<cfelse>			
						
			<cfquery name="Mission" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      Ref_Mission
				WHERE     Mission = '#Program.Mission#'	
			</cfquery>
											
			<cfif mission.ProcurementMode eq "1">  
													
				<cfinvoke component   = "Service.Process.Program.Execution"  
				   method             = "Obligation" 
				   mission            = "#Program.mission#"
				   currency           = "#url.currency#"  
				   programhierarchy   = "#prghier#"
				   unithierarchy      = "#orghier#"
				   programcode        = "#URL.ProgramCode#"
				   period             = "#per#" 				   
				   fund               = "#url.fund#"
				   Resource           = "#resource#"
				   Object             = "#url.objectCode#"
				   ObjectChildren     = "#url.isParent#"
				   Content            = "Details"
				   Scope              = "Unliquidated"
				   Mode               = "Table"
				   Table		      = "Obligation_#Session.ACC#_#fileno#">		
			   
			<cfelse>
											
				<cfinvoke component   = "Service.Process.Program.Execution"  
				   method             = "Disbursement" 
				   mission            = "#Program.mission#"
				   currency           = "#url.currency#"  
				   programHierarchy   = "#prghier#"
				   unithierarchy      = "#orghier#"
				   programcode        = "#URL.ProgramCode#"
				   period             = "#per#" 
				   accountperiod      = "#peraccsel#"				   
				   fund               = "#url.fund#"
				   Resource           = "#resource#"
				   Object             = "#url.objectCode#"
				   ObjectChildren     = "#url.isParent#"
				   Content            = "Details"
				   TransactionSource  = "'Obligation'"			 
				   Mode               = "Table"
				   Table              = "Obligation_#Session.ACC#_#fileno#">					   
			
			</cfif>   
							
		</cfif>  			
		
		<cfinvoke component = "Service.Process.Program.Execution"  
		   method           = "Disbursement" 
		   mission          = "#Program.mission#"
		   currency         = "#url.currency#"  
		   programHierarchy = "#prghier#"
		   unithierarchy    = "#orghier#"
		   programcode      = "#URL.ProgramCode#"
		   period           = "#per#" 
		   accountperiod    = "#peraccsel#"		   
		   fund             = "#url.fund#"
		   Resource         = "#resource#"
		   Object           = "#url.objectCode#"	
		   ObjectChildren   = "#url.isParent#"	    
		   Content          = "Details"
		   Mode             = "table"
		   Table		    = "Invoice_#Session.ACC#_#fileno#">	
		   
		   <!--- not needed as info is pass already on parent level ObjectChildren   = "#url.isParent#" --->
		   
		   <!---  ObjectParent     = "#url.isParent#" --->
		   
		  <cfquery name="tPipeline"
	         datasource="AppsQuery">
				SELECT    sum(ReservationAmount) as Amount
				FROM      Pipeline_#Session.ACC#_#fileno#					
		  </cfquery>       
		   
		  <cfquery name="tApproval"
	         datasource="AppsQuery">
				SELECT    sum(ReservationAmount) as Amount
				FROM      Approval_#Session.ACC#_#fileno#				
		  </cfquery>  
		  		    
		  <cfquery name="tReservation"
	         datasource="AppsQuery">
				SELECT    sum(ReservationAmount) as Amount
				FROM      Reservation_#Session.ACC#_#fileno#				
		  </cfquery>  	
		  
		  <cfquery name="tObligation"
	         datasource="AppsQuery">
				SELECT    sum(ObligationAmount) as Amount
				FROM      Obligation_#Session.ACC#_#fileno#			
		    </cfquery> 		  
		   
		  <cfquery name="tInvoice" 
		  	datasource="AppsQuery">
				SELECT    sum(InvoiceAmount) as Amount
				FROM      Invoice_#Session.ACC#_#fileno#		
		  </cfquery>  	  
		  
		<tr class="line">
		
		   <td height="20" style="padding-left:0px;padding-bottom:5px" valign="bottom" class="labelmedium">
		      
			 <table style="width:304" class="clsNoPrint">
	
			     <tr  class="labelmedium">
				
				 <td id="findbox" class="xhide">
		
		          <cfinvoke component = "Service.Presentation.TableFilter"  
					   method           = "tablefilterfield" 
					   name             = "Find"				  
					   filtermode       = "direct"
					   label            = "Execution"
					   style            = "font:23px;height:25;width:170"
					   rowclass         = "filterrow"
					   rowfields        = "filtercontent">	
									   
					   </td>
				    </tr>
    		   </table> 
			   
		   </td>
		   
		   <td>
		   		   
		   <table style="border:0px solid silver">
		   
			   <tr class="linedotted">
			   <td align="right" style="min-width:100px;padding-right:7px" class="labelmedium"><cf_tl id="Pipeline"></td>
			   <td align="right" style="min-width:100px;padding-right:7px" class="labelmedium"><cf_tl id="Approval"></td>
			   <td align="right" style="min-width:100px;padding-right:7px" class="labelmedium"><cf_tl id="Procurement"></td>
			   <cfif url.mode neq "List">
			   <td align="right" style="min-width:100px;padding-right:7px" class="labelmedium"><cf_tl id="Obligated"></td>
			   <cfelse>
			   <td align="right" style="min-width:100px;padding-right:7px" class="labelmedium"><cf_tl id="Unliquidated"></td>
			   </cfif>
			   <td align="right" style="min-width:100px;padding-right:7px" class="labelmedium"><cf_tl id="Expenditures"></td>		   
			   </tr>		
		   		   	
			   <tr>
			        			
					<cfif tPipeline.Amount eq "">
					    <cfset pip = "0">
						<cfset plk = "">
					<cfelse>
						<cfset pip = tPipeline.Amount>
						<cfset plk = "toggleme('ReqPipeline','pipeline_hdr')">
					</cfif>		
					
					<cfif tApproval.Amount eq "">
					    <cfset for = "0">
						<cfset flk = "">
					<cfelse>
						<cfset for = tApproval.Amount>
						<cfset flk = "toggleme('ReqApproval','approval_hdr')">
					</cfif>		
					
					<cfif tReservation.Amount eq "">
					    <cfset res = "0">
						<cfset rlk = "">
					<cfelse>
						<cfset res = tReservation.Amount>
						<cfset rlk = "toggleme('ReqReservation','reservation_hdr')">
					</cfif>		
					
					<cfif tObligation.Amount eq "">
					    <cfset obl = "0">
						<cfset olk = "">
					<cfelse>
					
						<cfset obl = tObligation.Amount>
												
						<cfif drill eq "0">
						
							<cfset olk = "">
							
						<cfelse>
						
							<cfif url.mode neq "List">
								<cfset olk = "toggleme('obligation','obligation_hdr')">
							<cfelse>
								<cfset olk = "toggleme('unliquidated','obligation_hdr')">						
							</cfif>
							
						</cfif>
						
					</cfif>		
					
					<cfif tInvoice.Amount eq "">
					    <cfset inv = "0">
						<cfset ilk = "">
						
					<cfelse>
					
						<cfset inv = tInvoice.Amount>
						
						<cfif drill eq "0">
						
							<cfset ilk = "">
							
						<cfelse>
						
							<cfset ilk = "toggleme('invoice','invoice_hdr')">
						
						</cfif>
						
					</cfif>		
					
					<td onclick="#plk#" style="padding-right:4px;cursor:pointer;padding-left:3px;border-right:1px solid silver;border-left:1px solid silver;border-top:1px solid silver" id="pipeline_hdr"    name="pipeline_hdr"    align="right" class="labelmedium"><cf_space spaces="25">#numberformat(tPipeline.Amount,'__,__')#</td>							
					<td onclick="#flk#" style="padding-right:4px;cursor:pointer;padding-left:3px;border-right:1px solid silver;border-left:1px solid silver;border-top:1px solid silver" id="approval_hdr"    name="approval_hdr"    align="right" class="labelmedium"><cf_space spaces="25">#numberformat(tApproval.Amount,'__,__')#</td>	
					<td onclick="#rlk#" style="padding-right:4px;cursor:pointer;padding-left:3px;border-right:1px solid silver;border-left:1px solid silver;border-top:1px solid silver" id="reservation_hdr" name="reservation_hdr" align="right" class="labelmedium"><cf_space spaces="25">#numberformat(tReservation.Amount,'__,__')#</td>	
					<td onclick="#olk#" style="padding-right:4px;cursor:pointer;padding-left:3px;border-right:1px solid silver;border-left:1px solid silver;border-top:1px solid silver" id="obligation_hdr"  name="obligation_hdr"  align="right" class="labelmedium"><cf_space spaces="25"><cfif drill eq "1"><font color="0080C0">#numberformat(tObligation.Amount,'__,__')#</font><cfelse>#numberformat(tObligation.Amount,'__,__')#</cfif></td>	
					<td onclick="#ilk#" style="padding-right:4px;cursor:pointer;padding-left:3px;border-right:1px solid silver;border-left:1px solid silver;border-top:1px solid silver" id="invoice_hdr"     name="invoice_hdr"     align="right" class="labelmedium"><cf_space spaces="25"><cfif drill eq "1"><font color="0080C0">#numberformat(tInvoice.Amount,'__,__')#</font><cfelse>#numberformat(tInvoice.Amount,'__,__')#</cfif></td>		
										
				</tr>
		   		    
		   </table>
		   
		   </td>
		   
		   <cfset exp = pip+for+res+obl+inv>
			<td align="right" style="padding-right:5px" class="labelmedium">
			#numberformat(exp,',__')# 
			</td>	
			
		</tr>  	
							
		<tr class="line">
		
		<td height="20" style="padding-left:0px" class="labelmedium"><cf_tl id="Balance">:</td>		
		<td></td>		
		<td align="right" style="width:200;padding-right:5px" class="labelmedium">
		
			<cfif Total.Amount eq "">
			    <cfset bud = "0">
			<cfelse>
				<cfset bud = Total.Amount>
			</cfif>
					
			<cfset bal = bud-exp>
			<cfif bal lt 0><font color="FF0000"><cfelse><font color="green"></cfif>
			#numberformat(bal,',__')#			
			
		</td>
		
		</tr>		
				
		<!--- fiscal year conversion --->
		
		<!--- check if this is a child BID under a regular BID --->
						
		<cfquery name="Parent" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   Pe.Reference
			FROM     Program P, ProgramPeriod Pe
			WHERE    P.ProgramCode = '#Period.PeriodParentCode#' 	
			AND      P.ProgramCode = Pe.ProgramCode
		</cfquery>		
		
		<cfquery name="getPeriod" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   P.*
			FROM     Ref_AllotmentEdition R, Ref_Period P 
			WHERE    R.Period = P.Period 	
			AND      R.EditionId = '#url.Editionid#'			
		</cfquery>
										 
		<cfif url.mode eq "List" 		  
		   and (Parent.Reference neq "#Period.Reference#")
		   and (url.mission is "OICT" or url.mission is "DM_FMS")>
		   		   
		  <tr><td colspan="3" height="3" style="padding-left:40px;padding-right:50px">
		   
		  <cfinclude template="Detail/IMISSummary.cfm"> 
		  
		  </td>
		  </tr>
		
		</cfif> 
		
		<tr><td colspan="3" height="99%">
					
			<cf_divscroll>
		
			<table width="100%" style="padding-left:4px;padding-right:4px">
				<tr>
					<td width="100%" id="row_details">
					</td>
				</tr>				
			
			</table> 
			
			</cf_divscroll>
			
		</td>
		</tr>
							
	</table>	
	
	</td></tr>	 
		
	<tr><td height="6"></td></tr>
	
	<cfif url.print eq "1">
	
	<tr>
	<td height="6" colspan="3" align="center" class="noprint">
		<cf_tl id="Print" var="vPrint">
		<cf_tl id="Close" var="vClose">
		
		<input type="button" class="button10g" style="width:110;height:26" name="Print" ID="Print" value="#vPrint#" onclick="window.print()">	
		<input type="button" class="button10g" style="width:110;height:26" name="Close" id="Close" value="#vClose#" onclick="window.close()">
		
	</td></tr>
	
	</cfif>
			
	</cfoutput> 
		
</table>
