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
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Register Allotment Edition" 
			  menuAccess="Yes" 
			  banner="gray"			 
			  line="no"
			  systemfunctionid="#url.idmenu#">

<cfoutput>

<cfajaximport>

<script>

function selected(per,mis,ver) {			
	url = "EditionSelect.cfm?period="+per+"&mission="+mis+"&version="+ver;
	ColdFusion.navigate(url,'selectme')		
	inherit('') 
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

function inherit(val) {
  se = document.getElementsByName("edit")
  if (val == "") {
    se[0].className = "regular"
	se[1].className = "regular"
  } else {
	se[0].className = "hide"
	se[1].className = "hide"
  }

}

</script>

</cfoutput>

<cfquery name="MissionList"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Mission
	WHERE Mission IN (SELECT Mission 
	                  FROM   Ref_MissionModule 
					  WHERE  SystemModule = 'Program')
</cfquery>


<cfquery name="PeriodList"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Period
	ORDER BY Period DESC
</cfquery>

<cfquery name="Fund"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Fund
</cfquery>

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog" target="result">

<table width="95%" class="formpadding formspacing" cellspacing="0" cellpadding="0" align="center">

	<tr><td height="10"></td></tr>
		
	<tr class="hide"><td colspan="2">
				<iframe name="result"
	                    id="result"
	                    width="100%"
	                    height="100"></iframe></td></tr>

	
	<TR>
    <TD width="170" class="labelmedium">Class:</TD>
    <TD class="labelmedium">
	    <INPUT type="radio" onclick="mode('budget')"   name="EditionClass" value="Budget" checked> Budget
	    <INPUT type="radio" onclick="mode('actuals')"  name="EditionClass" value="Actuals"> Expenditures
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Entity:</TD>
    <TD class="labelmedium">
		<select name="mission" onchange="selected(period.value,this.value,version.value)" class="regularxl">
     	   <cfoutput query="MissionList">
        	<option value="#Mission#">#Mission#</option>
         	</cfoutput>
	    </select>
		
    </TD>
	</TR>				

	<TR id="versionbox">
    <TD class="labelmedium"><cf_tl id="Version">:</TD>
    <TD class="labelmedium">	
		<cfdiv bind="url:VersionSelect.cfm?mission={mission}">			
    </TD>
	</TR>	
	
	<TR>
    <TD class="labelmedium">Applies to Execution (Period/Class):</TD>
    <TD class="labelmedium">
		<select name="period" onchange="selected(this.value,mission.value,version.value)" class="regularxl">		  
     	   <cfoutput query="PeriodList">
        		<option value="#Period#">#Period# / #PeriodClass#</option>
           </cfoutput>
		    <option value="">All Periods</option> 
	    </select>
		
    </TD>
	</TR>	
	
	<TR id="carryover">
	    <TD style="height:25" class="labelmedium">Inherit budget data from:</TD>
	    <TD id="selectme" class="labelmedium">	
			<font color="808080"><i>Option not available</font>    
		</TD>
	</TR>
	
	<TR id="edit">
    <TD class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Fund">:</TD>
    <TD>
		<table cellspacing="0" cellpadding="0">
		
		<cfset cnt = 0>
	    <cfoutput query="Fund">
		
			<cfif cnt eq "0">
			<tr>
			</cfif>
			
			<td>			
		     <table cellspacing="0" cellpadding="0">
				 <tr>
					 <td class="labelmedium"><input class="radiol" type="checkbox" name="Fund" value="#Code#"></td>
					 <td class="labelmedium" style="padding-left:5px;padding-right:15px">#Code#</td>
				 </tr>
			 </table>	
			 				
			</td>
			<cfset cnt = cnt+1>
		
			<cfif cnt eq "6">
			</tr>		
			<cfset cnt = 0>		
			</cfif>	
		
		</cfoutput>
		</table>
		
	</TD>
	</TR>
   	
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Description">:</TD>
    <TD><cfinput type="text" 
	       name="Description" 
		   value="" 
		   message="Please enter a description" 
		   required="Yes" 
		   size="50" 
		   maxlength="50" 
		   class="regularxl">
    </TD>
	</TR>
	
	<TR id="edit">
    <TD class="labelmedium"><cf_UIToolTip tooltip="Define the entry mode for budget amounts per object of expenditure"><cf_tl id="Entry Mode">:</cf_UIToolTip></TD>
    <TD><table cellspacing="0" cellpadding="0" class="formpadding">
	   
	    <tr>
		<td>
			<table cellspacing="0" cellpadding="0">
			<tr>
				<td class="labelmedium" style="padding-right:10px">
		   		 <input type="radio" class="radiol" name="BudgetEntryMode" value="0" checked onclick="document.getElementById('method').className='regular'">
				 </td>
				 <td style="padding-left:3px;padding-right:4px" class="labelmedium">Direct Entry</td>
				
				<TD style="cursor: pointer;" id="method" style="padding-left:3px" class="labelmedium">
				<cf_UIToolTip tooltip="The recording metod defines if incremental changes are being stored in the database">
				<select name="EntryMethod" class="regularxl">
					<option value="Snapshot">Snapshot</option>
					<option value="Transaction">Transactional (recommended)</option>
				</select>
				</cf_UIToolTip>
				</TD>
			</tr>
			</table>
		</td>
		</tr>
		<tr>
		<td class="labelmedium">
			<input type="radio" class="radiol" name="BudgetEntryMode" 
			   onclick="document.getElementById('method').className='hide'" 
			   value="1">Specify Underlying Requirements
		</td>
		</tr>
		
		</table>
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_UIToolTip tooltip="Set the allocation mode for cleared budget amounts"><cf_tl id="Budget Mode">:</cf_UIToolTip></TD>
    <TD class="labelmedium">
	
		<select name="AllocationEntryMode" class="regularxl">
			<option value="0" selected>Proposed and Approved Budget Transactions</option>		
			<option value="1">Approved Budget Transactions</option>		
			<option value="2">Recorded Allocated Budget amounts (manual)</option>
			<option value="3">Workflow cleared Budget Transactions</option>	
	    </select>
	    
	</TD>
	</TR>		
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Show Edition">:</TD>
    <TD>
	   <input type="checkbox" class="radiol" name="ControlView" value="1" checked>
	</TD>
	</TR>
		
	<TR>
    <TD class="labelmedium"><cf_tl id="Allow Editing">:</TD>
    <TD>
	   <input type="checkbox" class="radiol" name="ControlEdit" value="1" checked>
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Listing Order">:</TD>
    <TD style="padding-left:4px">
  	   <cfinput type="Text"
       name="ListingOrder"
       value="1"
       message="Please enter a number 1..9"
       validate="integer"
       required="Yes"
       visible="Yes"
       enabled="Yes"
       size="1"
       maxlength="1"
	   style="text-align:center"
       class="regularxl">
    </TD>
	</TR>	
		
	<tr><td colspan="2">	
		<cf_dialogBottom option="add" delete="Edition">		
	</td></tr>	

</table>

</CFFORM>
		

