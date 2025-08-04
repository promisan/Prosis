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
<!---

- We show all projects filtered and grouped
- we show the total requirement
A - we show the total requirement until the selection date
B - we show the amount allotted (status = 1)
C - we show the amount prepared by not submitted yet 9status = 0)
- we show the amount difference A - B and ability to set this on the requirement level so you can start processing.
- selectt he month
- include PSC in the total required
- apply the amount
- open dialog to process and fund the request

--->

<cfparam name="url.mission"      default="DPA">
<cfparam name="url.period"       default="B14-15">
<cfparam name="url.edition"      default="66">
<cfparam name="url.fund"         default="">
<cfparam name="url.modeselect"   default="">
<cfparam name="url.reviewcycle"  default="">
<cfparam name="url.status"       default="0">


<cfoutput>
	
	<script language="JavaScript">
	 
	 Prosis.busy('no') 
	 
	 function reloadme() { 
	     Prosis.busy('yes') 	    
	     fd = document.getElementById('FundSelect').value		 
		 md = document.getElementById('ModeSelect').value
		 cy = document.getElementById('ReviewCycle').value
		 st = document.getElementById('Status').value
	     ColdFusion.navigate('../Requirement/RequirementView.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&period=#url.period#&edition=#url.edition#&reviewcycle='+cy+'&status='+st+'&fund='+fd+'&modeselect='+md,'request')
	 }
	 
	 function maintainRelease(edition,per,mode,prg) {	    	   
	 	ptoken.open("../Requirement/FundObject/FundObject.cfm?entrymode="+mode+"&systemfunctionid=#url.systemfunctionid#&editionId="+edition+"&period="+per+"&programcode="+prg, "", "left=80, top=80, width=800, height=850, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	 }
	 
	 function allotdrill(prg,per,edit) {
		ptoken.open("#SESSION.root#/ProgramREM/Application/Budget/Allotment/Clearance/AllotmentView.cfm?Program=" + prg + "&Period=" + per + "&Edition=" + edit, "_blank", "left=10, top=20, width=1100, height=950, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	 }  		 	 	
	
	</script>

</cfoutput>

 <cfquery name="get" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Ref_AllotmentEdition WHERE Editionid = '#url.edition#'
</cfquery>

<cfquery name="qCycle" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ReviewCycle C
	WHERE    C.Mission = '#url.mission#'
	AND      C.Period  = '#url.period#'
	AND      Operational = 1
	AND      DateBudgetEffective  is not NULL 
	AND      DateBudgetExpiration is not NULL
	AND      EnableMultiple = 0
	ORDER BY DateEffective	
</cfquery>

<cfquery name="qStatus" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_EntityStatus
	WHERE   EntityCode = 'EntProgramReview'
	AND     EntityStatus <= '3'
</cfquery>

<cfif get.Recordcount eq "0">
	
	<table width="100%" height="100%">
	<tr><td class="labellarge" align="center">
		<font color="FF0000">Please select an edition on the left panel.</b></font>
	</td>
	</tr>
	</table>	
	<script>
			parent.Prosis.busy('no')
	</script>
	<cfabort>

</cfif>	

<cfif get.BudgetEntryMode eq "0" or get.Recordcount eq "0">
	
	<table width="100%" height="100%">
	<tr><td class="labelmedium" style="font-size:23px" align="center">
		<font color="0080C0">Requirement mode not enabled for this edition<br><font size="2">Select <u>Pending for Clearance</u> node in order to issue allotments</font>
	</td>
	</tr>
	</table>	
	<script>
	parent.Prosis.busy('false')
	</script>
	<cfabort>

</cfif>	
 
<cfquery name="getFund" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Ref_AllotmentEditionFund WHERE Editionid = '#url.edition#'
</cfquery>


<cfquery name="Param" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Ref_ParameterMission WHERE Mission = '#url.mission#'
</cfquery>

<table width="99%" height="100%" cellspacing="0" cellpadding="0" align="center">

<cfoutput>
	
	<tr>
		<td align="right">
		
			<table align="right" border="0" width="100%" cellspacing="0" cellpadding="0">
			 <tr>
			 <td style="padding-left:10px;font-size:24px;height:49px;" class="line labellarge">#get.Description# #param.budgetcurrency#:</td>
			 <td style="padding-right:10px" align="right">
			 <input type="button" value="Release requirements for allotment" class="button10g" style="background-color:ffffaf;width:250px;height;28px" onclick="maintainRelease('#url.edition#','#url.period#','edition','');">	 
			 </td> 		
			 </tr>	
			</table>
			
		</td>
	</tr>
		   
    <tr class="line">
	       <td height="35" style="padding-left:0px">
	
		    <table>
		    <tr>
			
				<td class="hide"><input type="button" id="refreshbutton" onclick="Prosis.busy('yes');reloadme()"></td>
											
				<td class="label" style="color:gray;padding-left:12px">	
				  <select class="regularxl" id="ReviewCycle" onchange="Prosis.busy('yes');reloadme()">	
				     <option value="" selected>Any</option>				 		
					  <cfloop query="qCycle">				  
					  	<option value="#cycleid#" <cfif url.reviewcycle eq CycleId>selected</cfif>>#description#</option>					  
					  </cfloop>
				  </select>	
				</td>	
									
				<cfif qStatus.recordcount gte "1">
				 <td class="label" style="color:gray;padding-left:12px">	
				  <select id="Status" class="regularxl" onchange="Prosis.busy('yes');reloadme()">					 		
					  <cfloop query="qStatus">				  
					  	<option value="#EntityStatus#" <cfif url.status eq EntityStatus>selected</cfif>>#StatusDescription# or later</option>					  
					  </cfloop>
				  </select>	
				 </td>															
				<cfelse>
				  <input type="hidden" name="fldStatus" value="0">					
				</cfif>		
				
				 <td class="labelmedium" style="padding-left:10px;padding-right:4px"><cf_tl id="Mode">:</td>
				 <td>
				 
				 	<select id="ModeSelect" class="regularxl" onchange="Prosis.busy('yes');reloadme()">
						<option value="">All</option>
						<option value="overdue" <cfif url.modeselect eq "overdue">selected</cfif>><cf_tl id="Overdue only"></option>	
					</select>
				 
				 </td>
				 <td style="padding-left:10px;padding-right:4px" class="labelmedium"><cf_tl id="Fund">:</td>
				 <td style="padding-right:20px">
					 
					<select id="FundSelect" class="regularxl" onchange="Prosis.busy('yes');reloadme()">
						<option value="">All</option>
						<cfloop query="getfund">
						<option value="#Fund#" <cfif url.fund eq fund>selected</cfif>>#Fund#</option>
						</cfloop>
					</select>
				 
				 </td> 				
				
			</tr>
			</table>
		</td>
	</tr>
	
</cfoutput>

<cf_PresentationScript>

<cfinclude template="RequirementViewPrepare.cfm">

<cfquery name="getTotalPSC" dbtype="query">
	SELECT SUM(SupportPercentage) as SupportPercentage
	FROM   Listing
</cfquery>

<cfset vIncludePSCColumns = true>
<cfif getTotalPSC.recordCount eq 1 AND getTotalPSC.SupportPercentage eq 0>
	<cfset vIncludePSCColumns = false>
</cfif>

<cfif Listing.recordcount gte "1">
		
	<tr><td style="height:30px;border-bottom:0px solid silver;padding-right:17px">
	
		<table width="100%" cellspacing="0" cellpadding="0">
		<tr class="labelmedium line">
			  <td width="2%"></td>	  
			  <td colspan="2" style="width:100%;min-width:480">
			  
				<cfinvoke component = "Service.Presentation.TableFilter"  
				   method           = "tablefilterfield" 
				   filtermode       = "direct"
				   name             = "filtersearch"
				   style            = "font:14px;height:25;width:120"
				   rowclass         = "clsRequirementRow"
				   rowfields        = "ccontent">
			 
			  
			  </td>
			  <td align="center" style="min-width:100px"><cf_tl id="Requested"><br><cf_tl id="Amount"></td>	
			  <cfif vIncludePSCColumns>
			  <td style="font-size:11px;min-width:100px" align="center"><br>incl. PSC</td>	
			  </cfif>
			  <td align="center" style="min-width:100px"><cf_tl id="Approved"><br>Amount</td>	
			  <cfif vIncludePSCColumns> 
			  <td style="font-size:11px;min-width:100px" align="center"><br>incl. PSC</td>	  <!--- based on the date of today --->
			  </cfif>
			  <td align="center" style="min-width:100px"><font color="0080C0"><b>Allotm. Due</td>
			  <td align="center" style="min-width:100px"><cf_tl id="Allotment"><br>Submitted</td>		  
			  <td align="center" style="min-width:100px;padding-left:5px"><br>Amended</td>
			  <td align="center" style="min-width:100px;padding-left:5px"><cf_tl id="Final"><br>Clearance</td>
			  <td align="center" style="min-width:100px;padding-left:5px"><cf_tl id="Overdue"><br><cf_tl id="Allotment"></td> 
			  <td style="min-width:20px"></td> 
			</tr>
		</table>	
	
	</td>
	</tr>
	
	<cfset st = "padding-right:4px;border-left:1px solid silver;min-width:100px">
	
	<!--- body --->
	<tr>
	<td style="padding-bottom:0px;padding-left:15px;padding-right:20px" height="100%">	
		<cf_divscroll width="100%" height="100%" overflowy="scroll">	
			<cfinclude template="RequirementViewDetail.cfm">				
		</cf_divscroll>
	</td>
	</tr>
	
<cfelse>

	<tr><td height="100%"></td></tr>	

</cfif>

<!--- ------ --->
<!--- totals --->
<!--- ------ --->

<tr>
<td style="height:20px;border-top:1px solid silver;padding-right:21px">

	<table width="100%" cellspacing="0" cellpadding="0">
		
		<cfquery name="Total" dbtype="query">
			SELECT Sum(AmountRequested) as AmountRequested,
				   Sum(AmountRequestedTotal) as AmountRequestedTotal,	
			       Sum(AmountVetted) as AmountVetted,
				   Sum(AmountVettedToAllotTotal) as AmountVettedToAllotTotal,		
				   Sum(AmountAmended) as AmountAmended,	      
				   Sum(AllotedToDate) as AllotedToDate,
				   Sum(AllotedToDate2) as AllotedToDate2
			FROM   Listing
		</cfquery>
		
		<cfoutput query="Total">
		
		    <cfset due = TodateDue - AllotedToDate>		
		
			<tr class="line labelmedium navigation_row">
			    <td width="2%" style="padding-left:2px"></td>
				<td width="8%" style="padding-left:2px"></td>
				<td width="70%"></td>
				<td align="right" style="#st#">#numberformat(AmountRequested,",._")#</td> 	
				<cfif vIncludePSCColumns>
				<td align="right" style="#st#;font-size:11px">#numberformat(AmountRequestedTotal,",._")#</td> 		
				</cfif>			
				<td align="right" bgcolor="e1e1e1" style="#st#">#numberformat(AmountVetted,",._")#</td> 	
				<cfif vIncludePSCColumns>
				<td align="right" bgcolor="silver" style="#st#;font-size:11px">#numberformat(TotalDue,",._")#</td> 		
				</cfif>
				<td align="right" bgcolor="gray"   style="#st#"><font color="FFFFFF">#numberformat(TodateDue,",._")#</td>
				
				<td align="right" bgcolor="FBFCDA" style="#st#">#numberformat(AllotedToDate,",._")#</td>
				<td align="right" bgcolor="FBFCDA" style="#st#">#numberformat(AmountAmended,",._")#</td>
				<td align="right" bgcolor="FBFCDA" style="#st#">#numberformat(AllotedToDate2,",._")#</td>		
				
				<cfif abs(Overdue) lt 3> 
						<td align="right" style="#st#;padding-right:4px;border-left:1px solid silver;border-right:1px solid silver;min-width:98px">--</td>		
				<cfelseif due gte "3">
					<td align="right" bgcolor="red" style="#st#;padding-right:4px;border-left:1px solid silver;;min-width:98px">
					
					<font color="white">
					#numberformat(due,",._")#
					</font>
					
					</td>
				<cfelse>
					<td align="right" bgcolor="green" style="#st#;padding-right:4px;border-left:1px solid silver;min-width:98px">
					<font color="white"><b>
					#numberformat(due*-1,",._")#
					</font>							
					</td>
				</cfif>					
				
			</tr>	
				
		</cfoutput>
	
		</table>

	</td>
</tr>

</table>	
