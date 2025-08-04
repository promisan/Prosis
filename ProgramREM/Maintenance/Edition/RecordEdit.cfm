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
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
  			  scroll="Yes" 
			  layout="webapp" 
			  banner="gray" 			  
			  label="Budget Edition"
			  menuAccess="Yes" 
			  line="no"
			  systemfunctionid="#url.idmenu#">
   
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_AllotmentEdition
	WHERE  EditionId = '#URL.ID1#' 
</cfquery>   

<cfquery name="Version"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_AllotmentVersion
	WHERE  (Mission = '#Get.Mission#' or Mission is NULL)
	ORDER BY ListingOrder
</cfquery>

<cfquery name="Period"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Period
</cfquery>


<cfoutput>
<script language="JavaScript">
	
	w = 0
	h = 0
	if (screen) {
	w = #CLIENT.width# - 60
	h = #CLIENT.height# - 110
	}

	function mode(cls) {
		if (cls == "budget") {
			document.getElementById("carryover").className="regular"
			document.getElementById("versionbox").className="regular"
		} else {
			document.getElementById("carryover").className="hide"
			document.getElementById("versionbox").className="hide"
		}
	}

	function budgetfund(id) {
	    ptoken.open('FundRelease.cfm?id='+id,'_blank',"left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
	}

</script>

</cfoutput>

<!--- edit form --->

<cfform action="RecordSubmit.cfm" method="POST" target="result" name="dialog">
		
<table width="92%" align="center" class="formpadding formspacing">

	<tr><td height="10"></td></tr>
	
	<tr class="hide"><td colspan="2"><iframe name="result"
	                              id="result"
	                              width="100%"
	                              height="100"></iframe></td></tr>

	
	<cfoutput>
	 <input type="hidden" name="EditionId" value="#Get.EditionId#">
	</cfoutput>	
   
	<tr class="labelmedium2"><TD>Entity / Class:</TD>
    <TD class="labelmedium2" style="padding-left:3px">
		<cfoutput>#Get.Mission#
		<input type="hidden" name="Mission" value="#Get.Mission#">
	</cfoutput>
	<cfoutput>/ #Get.EditionClass# 
	<input type="hidden" name="EditionClass" value="#Get.EditionClass#">
	</cfoutput>
		
    </TD>
	</TR>	
		
	<cfif Get.EditionClass eq "Budget">
	
		<TR class="labelmedium2">
	    <TD><cf_tl id="Version">:</TD>
	    <TD>
			<select name="version" class="regularxxl">
	     	   <cfoutput query="Version">
	        	<option value="#Code#" <cfif #Get.Version# eq "#Code#">selected</cfif>>#Description#</option>
	         	</cfoutput>
		    </select>
			
	    </TD>
		</TR>	
	
	</cfif>
		
	<cfquery name="Fund"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_Fund
		ORDER BY ListingOrder
	</cfquery>  
	
	<script>
			
			function togglefund(code,val) {
			  s1 = document.getElementById('def_'+code)
			  s2 = document.getElementById('perc_'+code)
			  if (val == true) {
			    s1.disabled = false
				s2.disabled = false
			  } else {
			    s1.disabled = true
				s2.disabled = true
			  }
			  
			}
			
	</script>	
	
	
	<TR class="labelmedium2">
    <TD>Applies to Execution period:
	<cf_space spaces="50">
	</TD>
    <TD>
		<select name="Period" class="regularxxl">
		   <option value="">All Periods</option> 
     	   <cfoutput query="Period">
        	<option value="#Period#" <cfif Get.Period eq "#Period#">selected</cfif>>#Description#
			</option>
         	</cfoutput>
	    </select>
		
    </TD>
	</TR>	
	
	<TR class="labelmedium2">
    <TD><cf_tl id="Name">:</TD>
    <TD>
	
	   <table>
	   <tr class="labelmedium2"><td>
  	   <cfinput type="Text"
       name="Description"
       value="#Get.Description#"
       message="Please enter a description"
       required="Yes"      
       size="50"
       maxlength="50"
       class="regularxxl">
	   </td>
	    <TD style="padding-left:14px">Listing Order:</TD>
	    <TD style="padding-left:5px">
	  	   <cfinput type="Text"
	       name="ListingOrder"
	       value="#Get.ListingOrder#"
	       message="Please enter a number 1..9"
	       validate="integer"
		   style="text-align:center"
	       required="Yes"
	       visible="Yes"
	       enabled="Yes"
	       size="1"
	       maxlength="1"
	       class="regularxxl">
	    </TD>
	   </tr>
	   </table>
    </TD>
	</TR>
	
		
	<TR class="labelmedium2">
    <TD><cf_UIToolTip tooltip="Define the entry mode for budget amounts per object of expenditure">Requirement entry Mode:</cf_UIToolTip></TD>
    <TD>
	    <input type="radio" name="BudgetEntryMode" onclick="toggle('1')" value="0" <cfif Get.BudgetEntryMode neq "1">checked</cfif>>Direct Entry
		<input type="radio" name="BudgetEntryMode" onclick="toggle('0')" value="1" <cfif Get.BudgetEntryMode eq "1">checked</cfif>>Specify Amounts on an underlying detail level
	</TD>
	</TR>
	
	
	<script>
	
	 function toggle(val) {
	    se = document.getElementsByName('EntryMethod')
	    if (val == 1) {
		   se[0].disabled = false
		   se[1].disabled = false
		} else {
			se[0].disabled = true
			se[1].disabled = true
	    }
	 }
	</script>
	
	<cfif Get.BudgetEntryMode eq "1">
	    <cfset ena = "disabled">		
	<cfelse>
		<cfset ena = "">
		
	</cfif>		
	
	<TR class="labelmedium2">
    <TD style="padding-left:30px">Logging mode:</TD>
    <TD>
	    <cfoutput>
	 	<INPUT type="radio" name="EntryMethod" #ena# value="Transaction"  <cfif get.EntryMethod eq "Transaction">checked</cfif>>Transactional (recommended)
		<INPUT type="radio" name="EntryMethod" #ena# value="Snapshot"     <cfif get.EntryMethod eq "Snapshot">checked</cfif>>Snapshot (direct entry)    	
		</cfoutput>
	</TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD><cf_UIToolTip tooltip="Define the budget execution mode for cleared budget amounts">Budget Usage mode:</cf_UIToolTip></TD>
    <TD class="labelmedium2">
    	<select name="AllocationEntryMode" class="regularxxl">
			<option value="0" <cfif Get.AllocationEntryMode eq "0">selected</cfif>>Proposed and Approved Budget Transactions</option>		
			<option value="1" <cfif Get.AllocationEntryMode eq "1">selected</cfif>>Confirmed Budget Transactions</option>		
			<option value="2" <cfif Get.AllocationEntryMode eq "2">selected</cfif>>Recorded Allocated Budget amount (manual)</option>
			<option value="3" <cfif Get.AllocationEntryMode eq "3">selected</cfif>>Workflow cleared Budget Transactions</option>		
	    </select>
	</TD>
	</TR>		
	
		
	<TR class="labelmedium2">
    <TD><cf_UIToolTip tooltip="Show/Hide this edition in various interfaces">Interface:</cf_UIToolTip></TD>
    <TD>
	    <table cellspacing="0" cellpadding="0">
		<tr>
			<td>
		    <input type="checkbox" class="radiol" name="ControlView" value="1" <cfif Get.ControlView eq "1">checked</cfif>></td>
			<td style="padding-left:4px" class="labelmedium2">Allotment Inquiry</td>
			<td style="padding-left:4px" ><input type="checkbox" class="radiol" name="ControlEdit" value="1" <cfif Get.ControlEdit eq "1">checked</cfif>></td>
			<td style="padding-left:4px" class="labelmedium2">Allotment Entry form</td>
		    <TD style="padding-left:4px" colspan="1">
	    	    <input type="checkbox" class="radiol" name="ControlExecution" value="1" <cfif Get.ControlExecution eq "1">checked</cfif>></td>
			<td style="padding-left:4px"  class="labelmedium2"><cf_UIToolTip tooltip="Show Budget execution in Budget Inquiry screen">Execution in budget Inquiry</cf_UIToolTip></td>
		</tr>		
		</table>
	</TD>
	</TR>
			
	<TR class="labelmedium2">
    <TD valign="top" style="padding-top:4px">Edition status:</TD>
    <TD><table class="formpadding">
	    <tr><td style="cursor: pointer;">
	    <input type="radio" class="radiol" name="Status" value="1" <cfif Get.Status eq "1">checked</cfif>>
		</td><td style="padding-left:5px" class="labelmedium"><cf_UIToolTip tooltip="Budget Officer and Budget Manager can make changes">Open for Budget Officer and Manager</cf_UIToolTip></td>
		</tr>
		<tr>
		<td style="cursor: pointer;">
		<input type="radio" class="radiol" name="Status" value="3" <cfif Get.Status eq "3">checked</cfif>>
		</td><td style="padding-left:5px" class="labelmedium"><cf_UIToolTip tooltip="Only role Budget Manager can make changes to the budget">Locked for Budget Officer (only Budget Manager)</cf_UIToolTip></td>
		</tr>
		<tr>
		<td style="cursor: pointer;"> 
		<input type="radio" class="radiol" name="Status" value="9" <cfif Get.Status eq "9">checked</cfif>>
		</td><td style="padding-left:5px"  class="labelmedium"><cf_UIToolTip tooltip="Edition can not be used for Budget Execution (error message)">Disabled for execution / locked for data entry</cf_UIToolTip></td>
		</tr>
		</table>
	</TD>
	</TR>
	
	<TR class="line">
        <td style="padding-0top:1px" height="23" class="labelmedium2"><cf_tl id="Instructions">:</td>
		<TD>
		     <cfinclude template="EditionAttachment.cfm">
		</TD>
	</TR>
	
	<tr>
	   
		<cfif fund.recordcount gte "30">
		<TD colspan="2" style="padding:5px;height:200px">
			<cf_divscroll style="height:100%">
				<cfinclude template="RecordEditFund.cfm">	
			</cf_divscroll>	
		</td>
		<cfelse>
		<TD colspan="2" style="padding:5px;">
			<cfinclude template="RecordEditFund.cfm">
		</td>
		</cfif>
		</td>
	</tr>	
		
	<tr><td colspan="2">
	   <cf_dialogBottom option="edit" delete="Edition">
	</td></tr>
			
</table>
		
</CFFORM>


