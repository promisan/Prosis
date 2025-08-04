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

<cf_screentop height="100%" scroll="Yes" html="No">

<cf_dropDown>

<!--- default settings --->

<cf_insertTimeClass  TimeClass="AnnualLeave" Description="Annual Leave">
<cf_insertTimeClass  TimeClass="SickLeave"   Description="Sick Leave">
<cf_insertTimeClass  TimeClass="Worked"      Description="Employed">
<cf_insertTimeClass  TimeClass="LWOP"        Description="Leave Without Payment">
<cf_insertTimeClass  TimeClass="Suspend"     Description="Suspend from Salary">
<cf_insertTimeClass  TimeClass="Holiday"     Description="Holiday">
<cf_insertTimeClass  TimeClass="Excused"     Description="Excused">
<cf_insertTimeClass  TimeClass="travel"      Description="travel">
				 
<cf_insertWorkAction ActionClass="Direct"     
                     ActionParent="Worked"  
					 Description="Project"
					 ListingOrder = "1"
					 ProgramLookup="1">	
					 
<cf_insertWorkAction ActionClass="Indirect"     
                     ActionParent="Worked"  
					 Description="training"
					 ListingOrder = "2">						 	
					 
<cf_insertWorkAction ActionClass="travel"     
                     ActionParent="travel"  
					 Description="Official travel"
					 ListingOrder = "3"
					 ProgramLookup="1">		
					 
<!---					 					 			 
					 					 
<cf_insertWorkAction ActionClass="Break"     
                     ActionParent="Excused"  
					 Description="Lunch/Dinner"
					 ListingOrder = "4">	
					 
					 --->
					 
<cf_insertWorkAction ActionClass="Break"     
                     ActionParent="Excused"  
					 Description="Excused from Duty"
					 ListingOrder = "5">							 				 
					 
<cf_insertWorkAction ActionClass="Leave"     
                     ActionParent="AnnualLeave"  
					 Description="Leave"
					 ListingOrder = "6">	
					 
<cf_insertWorkAction ActionClass="Sick"     
                     ActionParent="SickLeave"  
					 Description="Sick Leave or Doctors Visit"
					 ListingOrder = "7">						 

<cfquery name="Check"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * FROM Ref_TimeClass
</cfquery>

<cfif Check.recordcount eq "0">
	
	<cfquery name="Insert"
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    INSERT INTO Ref_TimeClass
	       	(TimeClass)
		VALUES ('Holiday') 
	</cfquery>

</cfif>

<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	 *
	FROM 	 #client.lanPrefix#Ref_LeaveType
	ORDER BY LeaveParent, ListingOrder
</cfquery>


<cfset add          = "1">

<cf_screentop html="No" jquery="Yes">

<table width="98%" align="center" height="100%">

<tr style="height:10px"><td><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<cfoutput>
 
<script>

function recordadd(grp) {
      ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=180, top=40, width=1100, height= 850, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
      ptoken.open("RecordEditTab.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit");
}

function accrualadd(tpe) {
      ptoken.open("../Accrual/RecordAdd.cfm?idmenu=#url.idmenu#&ID=" + tpe, "Add", "left=80, top=80, width=800, height=700, toolbar=no, status=yes, scrollbars=yes, resizable=no");
}

function accrualedit(tpe) {
      ptoken.open("../Accrual/RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + tpe, "Add", "left=80, top=80, width=800, height=700, toolbar=no, status=yes, scrollbars=yes, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2" style="min-width:1000px">

<cf_divscroll>

	<table width="95%" align="center" class="navigation_table formpadding">
	
	<tr class="labelmedium line">
	       
	    <td></td>
	    <td>Code</td>
		<td>Description</td>
		<td>PA</td>
		<td>WF</td>
		<td>Accr.</td>
		<td>Max.</td>
		<td>Self</td>
		<td>Officer</td>
	    <td>Entered</td>
	  
	</tr>
	
	<cfoutput query="SearchResult" group="LeaveParent">
	
		<cfquery name="Check"
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * FROM Ref_TimeClass WHERE TimeClass = '#LeaveParent#'
		</cfquery>
		
		<tr><td height="10"></td></tr>
	    <tr class="labelmedium line">
	    	<td height="30"
	        colspan="10" style="font-size:26px;height:40px">#Check.Description#</b>&nbsp;<font face="Verdana" size="2">(#leaveparent#)</b></td>
	    </tr>
	
	<cfoutput>
	     
		<tr class="navigation_row labelmedium2 line" style="height:15px">
		
		  <td align="center">
		  
		  <table cellspacing="0" cellpadding="0">
			  <tr class="labelmedium2" style="height:15px">
			  <td width="20" style="padding-left:8px;">
			  	  <cf_img icon="open" navigation="Yes" onclick="recordedit('#LeaveType#')">
			  </td>
			  
			  <td width="20">
			  
			    <cfif LeaveAccrual neq "0">
				
				   <img src="#Client.VirtualDir#/Images/insert.gif" alt="Accrual" name="img0_#currentrow#" 
				  onMouseOver="document.img0_#currentrow#.src='#Client.VirtualDir#/Images/button.jpg'" 
				  onMouseOut="document.img0_#currentrow#.src='#Client.VirtualDir#/Images/insert.gif'"
				  style="cursor: pointer;" width="12" height="13" border="0" align="absmiddle" 
				  onClick="accrualadd('#LeaveType#')">
			    
			  </cfif>
			  
			  </td>
			  </tr>
		  </table>
		  
		  </td>
		  <td style="padding-left:7px">#LeaveType#</td>
		  <td>#Description#</td>
		  <td align="center"><cfif ActionCode neq "">Y<cfelse>-</cfif></td>
		  <td align="center"><cfif EntityClass neq "">Y<cfelse>-</cfif></td>
		  <td align="center"><cfif LeaveAccrual eq "1">Y<cfelseif LeaveAccrual eq "2">O<cfelseif LeaveAccrual eq "3">C<cfelse>-</cfif></td>
		  <td></td>
		  <td align="center"><cfif UserEntry eq "1">P</cfif></td>
		  <td>#OfficerFirstName# #OfficerLastName#</td>
		  <td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
			 
		 <cfquery name="Accrual"
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	      SELECT   L.*, R.Description
	   	  FROM     Ref_LeaveTypeCredit L, Ref_ContractType R
		  WHERE    L.ContractType = R.ContractType
		  AND      L.LeaveType = '#LeaveType#'
		  ORDER BY L.ContractType, DateEffective DESC
	    </cfquery>
		
		<cfif Accrual.recordCount gt "0">
		
		<tr>
		
		   <td colspan="10" align="center" style="padding:5px">
		   
			   <table width="90%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
			   
			   <tr class="navigation_row labelmedium2 line" style="height:16px">		   
			     
				  <td height="20"></td>
			      <td style="min-width:300;padding-left:6px"><cf_tl id="Contract"></td>			  
		          <td><cf_tl id="Effective"></td>
				  <td><cf_tl id="Period"></td>
				  <cfif LeaveAccrual eq "1">
		      	  <td><cf_tl id="Full Credit"></td>
				  <cfelse>
				  <td><cf_tl id="Latency"></td>
				  </cfif>
				  <td><cf_tl id="Calculation"></td>
		    	  <td><cf_tl id="Carry over"></td>
			      <td><cf_tl id="Max"></td>				      		  
			   </tr>	
			   
			   <cfset prior = "">
			   
			   <cfloop query="Accrual">
			   
				   <tr bgcolor="EAF4FF" class="line labelmedium navigation_row" style="height:25px">
				     
					 <td width="50" align="center" style="padding-left:7px;padding-right:9px;padding-top:3px">			  
					   <cf_img icon="edit" navigation="yes" onclick="accrualedit('#CreditId#')">		  
					  </td>
				      <td width="26%" style="padding-left:6px"><cfif contracttype neq prior>#Description# (#ContractType#)</cfif></td>
					   
					  <td width="12%">#DateFormat(DateEffective,CLIENT.DateFormatShow)#</td>
					  <td width="10%">#CreditPeriod#</td>
					  <cfif SearchResult.LeaveAccrual eq "1">
					  <td width="15%">#CreditFull# #CreditUoM#</td>
					  <cfelse>
					  <td width="15%">#AccumulationPeriod#</td>
					  </cfif>
					  <td width="15%">#Calculation#</td>
					  <td width="15%"><cfif carryovermaximum eq "999">--<cfelse>#CarryOverMaximum#</cfif></td>
					  <td width="14%"><cfif MaximumBalance eq "999">--<cfelse>#MaximumBalance#</cfif></td>				  
				   </tr>
				   <cfset prior = contracttype>
			   
			   </cfloop>
			   </table>
		   </td>
		 </tr>
		 
		 </cfif>
		 
		
	</CFOUTPUT>	
	
	</CFOUTPUT>
	
	    <tr bgcolor="white"><td height="3" colspan="10"></td></tr>
	
	</table>

</cf_divscroll>

</td>

</tr>

</table>


