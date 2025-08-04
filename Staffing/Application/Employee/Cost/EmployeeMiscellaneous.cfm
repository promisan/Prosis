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
<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop height="100%" html="No" jquery="Yes" scroll="Yes" menuaccess="context" actionobject="Person" actionobjectkeyvalue1="#url.id#">

<cf_actionListingScript>
<cf_dialogledger>
<cf_FileLibraryScript>		
<cfajaximport tags="cfdiv">

<cfparam name="URL.Status" default="">
<cfparam name="URL.sort"   default="doc">

<cfoutput>

<script language="JavaScript">
	
	function entitlement(persno) {
	    ptoken.location("MiscellaneousEntry.cfm?ID=" + persno);
	}
	
	function reloadForm() {
	    Prosis.busy('yes');
		fil = document.getElementById('filter').value
		srt = document.getElementById('sort').value
		ptoken.location('EmployeeMiscellaneous.cfm?ID=#URL.ID#&status=' + fil + '&sort=' + srt);
	}
	
	function recordedit(id) {
	    ptoken.open("MiscellaneousEdit.cfm?ID=#URL.ID#&ID1="+id+"&status=#URL.Status#", "_self", "left=80, top=80, width=560, height=500, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function workflowdrill(key,box,mode) {
			
	    se = document.getElementById(box)
		ex = document.getElementById("exp"+key)
		co = document.getElementById("col"+key)
			
		if (se.className == "hide") {	
			
		   se.className = "regular" 		   
		   co.className = "regular"
		   ex.className = "hide"			   
		   ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Cost/MiscellaneousWorkflow.cfm?ajaxid='+key,key)		   		 
		   
		} else {  se.className = "hide"
		          ex.className = "regular"
		   	      co.className = "hide" 
	    } 				
	}	
	
	function unitevent(id) {
	    ptoken.open('#session.root#/Payroll/Application/Commission/CommissionListing.cfm?ajaxid='+id, '_blank');	
	}	

</script>
</cfoutput>


<cfif URL.Status eq "">
          <cfset condition = "AND Status != '9'">
<cfelseif URL.Status eq "0d">		  
          <cfset condition = "AND Status = '0' AND DateEffective < getDate()+35">		  
<cfelse>  
       <cfset condition = "AND Status = '#URL.Status#'">
</cfif>

<cfinvoke component = "Service.Process.Payroll.PayrollItem"  
   method           = "PayrollItem"   
   returnvariable   = "accessItem">	   

<cfquery name="SearchResult" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *, 
	
			 (SELECT TOP 1 TransactionId
			  FROM     Accounting.dbo.TransactionHeader
			  WHERE    TransactionId = L.SourceId) as TransactionId,
				 
	         (SELECT TOP 1 ObjectKeyValue4 
			  FROM     Organization.dbo.OrganizationObject 
			  WHERE    (Objectid   = L.CostId OR ObjectKeyValue4 = L.CostId)
			  AND      EntityCode = 'EntCost' 
			  AND      Operational = 1) as Workflow
			  		
	FROM     PersonMiscellaneous L INNER JOIN Ref_PayrollItem I ON L.PayrollItem = I.PayrollItem
	WHERE    L.PersonNo = '#URL.ID#' 	
          	 #preserveSingleQuotes(condition)#
	<cfif accessitem neq "">
    AND      L.PayrollItem IN (#preservesingleQuotes(accessitem)#)
	</cfif>		 			 
			 
	ORDER BY L.PayrollItem, 
	         <cfif url.sort eq "doc">
			 L.DocumentDate, 
			 L.DateEffective, 
			 <cfelse>
			 L.DateEffective, L.DocumentDate,
			 </cfif> 
			 L.DocumentReference 
			 
</cfquery>

<table width="100%" align="center" class="formpadding">

<tr><td height="10" style="padding-top:3px;padding-left:7px">	
<cfset openmode = "show">
<cfinclude template="../PersonViewHeaderToggle.cfm">
</td>
</tr>

<tr><td style="padding:8px">
	
<table width="99%" align="center">
  <tr class="line">
     	
    <td width="100%">
		<table width="100%">
			<tr>
			<td colspan="5" style="font-size: 27px;text-transform: capitalize;font-weight: 200;">
			<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Logos/Payroll/Miscellaneous.png" height="40" alt=""  border="0" align="absmiddle">
			<cf_tl id="Miscellaneous Payroll Entry"></td>
			</tr>
			<tr>		
			<td style="padding-left:6px"><cf_tl id="Filter"></td>	
			<td style="padding-left:10px" style="min-width:20">
			<select id="filter" class="regularxl" style="border:0px;background-color:f1f1f1;width:280px;height:30px;font-size:17px" onChange="javascript:reloadForm()">
		        <OPTION value="" <cfif URL.Status eq "">selected</cfif>><cf_tl id="All except cancelled">
		        <OPTION value="0" <cfif URL.Status eq "0">selected</cfif>><cf_tl id="Pending">
				<OPTION value="0d" <cfif URL.Status eq "0d">selected</cfif>><cf_tl id="Pending and due">
			    <OPTION value="2" <cfif URL.Status eq "2">selected</cfif>><cf_tl id="Approved">
				<OPTION value="3" <cfif URL.Status eq "3">selected</cfif>><cf_tl id="Payment">
			    <OPTION value="5" <cfif URL.Status eq "5">selected</cfif>><cf_tl id="Settled">
				<OPTION value="9" <cfif URL.Status eq "9">selected</cfif>><cf_tl id="Cancelled">
			 </SELECT>		
			</td>	
			<td><cf_tl id="Sort"></td>			
			<td style="padding-left:10px" style="min-width:20">
			<select id="sort" class="regularxl" style="border:0px;background-color:f1f1f1;width:280px;height:30px;font-size:17px" onChange="javascript:reloadForm()">
		        <OPTION value="doc" <cfif URL.sort eq "doc">selected</cfif>><cf_tl id="Document date">
		        <OPTION value="due" <cfif URL.sort eq "due">selected</cfif>><cf_tl id="Due date">
			   
			 </SELECT>		
			</td>
			<cfif accessitem neq "">
				<cfoutput>
				    <td align="right" style="padding-right:1px;width:20%">
					<input type="button" value="New Entry" style="height:26px" class="button10g" onClick="javascript:entitlement('#URL.ID#','#URL.ID1#')">	 
				    </td>
				</cfoutput>
			</cfif>
			</tr>
		</table>
	</td>
   </tr>
   
<tr>  
<td width="100%" colspan="2">
  
	<table width="100%" class="navigation_table">
		
	<TR class="line labelmedium2 fixrow fixlengthlist">
	    <td colspan="2" align="center"></td>
	    <td><cf_tl id="Date"></td>
		<TD><cf_tl id="Status"></TD>
		<TD><cf_tl id="Reference"></TD>
		<TD><cf_tl id="Officer"></TD>
		<TD><cf_tl id="Source"></TD>
		<TD><cf_tl id="Category"></TD>
		<TD><cf_tl id="Due"></TD>
		<TD><cf_tl id="Qty"></TD>
		<TD><cf_tl id="Curr."></TD>
		<TD align="right"><cf_tl id="Amount"></TD>
	</TR>	
	<cfset last = '1'>
	
	<cfif searchresult.recordcount eq "0">
	<tr><td colspan="12" style="height:60" class="labelmedium" align="center">There are no records found for this view</td></tr>
	
	</cfif>
	
	<cfoutput query="SearchResult" group="PayrollItem">
	
	<TR class="line labelmedium2 fixrow2">
        <td colspan="12" style="font-weight:bold;padding-left:6px;font-size:21px;height:45px">#PayrollItem# #PayrollItemName#
	</td></tr>
	
	<cfset docdte = "">
	<cfset docref = "">
				
	<cfoutput>
		
	<TR class="navigation_row labelmedium2 fixlengthlist">
	
	    <cfif workflow neq "" and (source eq "Manual" or source eq "Ledger")>
	 
			 <td height="20" align="center" style="cursor:pointer" 
					onclick="workflowdrill('#workflow#','box_#workflow#')" >
										
				<cf_wfActive entitycode="EntCost" objectkeyvalue4="#costid#">	
				 
					<cfif wfStatus eq "Open" and DateDiff("D",dateEffective,now()) gte -14>
					
						<cfset cl = "regular">
					
						<img id="exp#Workflow#" 
					     class="hide" 
						 src="#SESSION.root#/Images/arrowright.gif" 
						 align="absmiddle" alt="Expand" height="9" width="7" border="0"> 	
										 
					   <img id="col#Workflow#" 
					     class="regular" 
						 src="#SESSION.root#/Images/arrowdown.gif" 
						 align="absmiddle" height="10" width="9" alt="Hide" border="0"> 
					
					<cfelse>
					
						<cfset cl = "hide">
					
					   <img id="exp#Workflow#" 
					     class="regular" 
						 src="#SESSION.root#/Images/arrowright.gif" 
						 align="absmiddle" alt="Expand" height="9" width="7" border="0"> 	
										 
					   <img id="col#Workflow#" 
					     class="hide" 
						 src="#SESSION.root#/Images/arrowdown.gif" 
						 align="absmiddle" height="10" width="9" alt="Hide" border="0"> 
					
					</cfif>
					
					</td>
				
		<cfelse>
		
				<cfset wfStatus = "">
			
			    <td height="20" align="center"></td>	
			  
		</cfif>
					
		<cfquery name="Payroll" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   EmployeeSalaryLine L INNER JOIN EmployeeSalary P ON L.PersonNo      = P.PersonNo
									AND    L.PayrollStart  = P.PayrollStart
									AND    L.PayrollCalcNo = P.PayRollCalcNo				
			WHERE  L.ReferenceId   = '#CostId#' 				
		</cfquery>
		
		<!--- check period --->
		
		<cfquery name="Schedule" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM       SalarySchedulePeriod
			WHERE      Mission        = '#Payroll.Mission#' 
			AND        SalarySchedule = '#Payroll.SalarySchedule#' 
			AND        PayrollStart   = '#Payroll.PayrollStart#'
		</cfquery>	
		
		<td align="center" style="padding-right:10px">
	
	        <cfif source eq "unit">
			
				 <cf_img icon="open" onClick="unitevent('#sourceid#')" navigation="Yes"> 
			
			<cfelse>

					<cfif getAdministrator("#Payroll.Mission#") eq "1" 
				      or  Status eq "0" 
					  or (Status eq "2" and EntityClass eq "") 
					  or Schedule.CalculationStatus lt "3">
					  
				     <cf_img icon="open" onClick="recordedit('#CostId#')" navigation="Yes">   	 
				  
				  </cfif> 
				  
			</cfif>
	
		</td>	
		
		<td><cfif documentdate neq docdte>#Dateformat(DocumentDate, CLIENT.DateFormatShow)#</cfif></td>
		<td id="status_#workflow#"><cfif Status eq "2"><font color="008000"><cf_tl id="Cleared">
		    <cfelseif Status eq "3"><font color="008000"><cf_tl id="Cleared">
		    <cfelseif Status eq "5"><font color="008000" style="cursor:hand" onclick="document.getElementById('id#costid#').className='regular'">In Payroll</font><cfelse>Pending</cfif></td>
		<td><cfif documentreference neq docref>#DocumentReference#</cfif></TD>
		<td>#OfficerLastName#</TD>
		<td>
		
		<cfif TransactionId neq "">		
			<a href="javascript:ShowTransaction('','','view','tab','','#TransactionId#')">#source#</a>		
		<cfelseif source eq "unit">		
		    <a href="javascript:unitevent('#sourceid#')">#Source#</a>	
		<cfelse>
			<span style="color:purple">#Source#</span>		
		</cfif>
				
		</TD>
		<TD>#EntitlementClass#</TD>
		
		<cfif workflow neq "" and wfStatus eq "Open" and DateDiff("D",dateEffective,now()) gte -14>
		<TD align="center" style="background-color:red;color:white">#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
		<cfelse>
		<td align="center">#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
		</cfif>		
		<TD>#Quantity#</TD>
		<TD>#Currency#</TD>
		<TD align="right">#NumberFormat(Amount, ",.__")#</TD>	
	</tr>
		
	<cfif Remarks neq "">
		<TR class="navigation_row_child labelmedium  fixlengthlist" style="height:20px" bgcolor="#IIf(CurrentRow Mod 2, DE('F1F1F1'), DE('F1F1F1'))#">
		    <td colspan="2"></td>
			<td colspan="10" align="left">#Remarks#</td>
		</tr>
	</cfif>	
	
	<cfif Payroll.recordcount gte "1">
		
		<tr id="id#costid#" class="hide">
		<td colspan="2" style="width:10px" align="right"></td>
		
		<td colspan="8" align="left" style="padding-bottom:1px">
		
			<table width="100%" bgcolor="ffffaf" cellspacing="0" cellpadding="0" style="border:1px solid silver">
			    <tr class="labelmediuum2" style="height:20px">				    
					<td style="background-color:e4e4e4;min-width:170px;padding-left:5px"><cf_tl id="Payroll entitlement">:</td>
					
					<!---
					<A href="#SESSION.root#/Payroll/Application/Payslip/SalarySlip.cfm?ID=#URL.ID#&ID2=#URLEncodedFormat(Payroll.PayrollEnd)#">
					<img src="../../../../Images/info.gif" alt="Payslip" name="PAYSLIP" border="0"></A>
					--->
					
					<td width="15%" style="padding-left:5px">#Payroll.SalarySchedule#</td>
					<td style="min-width:100px">#Dateformat(Payroll.PayrollEnd, CLIENT.DateFormatShow)#</td>
					<td style="min-width:100px">#Dateformat(Payroll.SalaryCalculatedEnd, CLIENT.DateFormatShow)#</td>
					<TD style="min-width:40px">#Payroll.PaymentCurrency#</TD>
					<td style="min-width:70px"><cf_tl id="Staff"></td>
					<TD style="min-width:80px" align="right">#NumberFormat(Payroll.PaymentAmount,".__")#</TD>
					<td style="min-width:80px;padding-left:10px"><cf_tl id="Organization"></td>
					<TD style="min-width:80px" align="right">#NumberFormat(Payroll.PaymentCalculation,".__")#</TD>
					<td style="width:100%"></td>
				</tr>
			</table>
		
		</td>
		</tr>
	
	</cfif>	
	
	<cfif source eq "Manual" or source eq "Ledger">
	
		<cfif workflow neq "">
			
				<input type="hidden" 
			       name="workflowlink_#workflow#" id="workflowlink_#workflow#" 		   
			       value="MiscellaneousWorkflow.cfm">			   			  
			   
				<input type="hidden" 
				   name="workflowlinkprocess_#workflow#" id="workflowlinkprocess_#workflow#" 
				   onclick="_cf_loadingtexthtml='';ptoken.navigate('getMiscellaneousStatus.cfm?ajaxid=#workflow#','status_#workflow#')">		    
								   
				<tr id="box_#workflow#" class="#cl#">
						<td></td>		   				 
					    <td colspan="11" id="#workflow#" style="padding-left:20px">						
						
						<cfif wfStatus eq "Open" and DateDiff("D",dateEffective,now()) gte -14>
						
							<cfset url.ajaxid = workflow>					
							<cfinclude template="MiscellaneousWorkflow.cfm">
															
						</cfif>
					
					</td>
				
				</tr>
			
			</cfif>
	
	</cfif>
	
	<cfset docdte = documentDate>
	<cfset docref = documentReference>
	
	<tr class="line" style="padding:0px"><td colspan="12"></td></tr>
	
	</cfoutput>
	
	
	</cfoutput>
	
	</TABLE>

</td>
</tr>
</table>
