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
<cfparam name="url.webapp" default="Backoffice">

<cfif url.webapp neq "Backoffice">
	 <cfset url.id = CLIENT.personno>
</cfif>


<cf_screenTop height="100%" html="no" band="no" scroll="yes" layout="default">

<cfinvoke component="Service.Access"
	Method="PayrollOfficer"
	Role="PayrollOfficer"
	Mission="#mission#"
	ReturnVariable="PayrollAccess">		

<cfinvoke component="Service.Access"
	Method="employee"
	PersonNo="#url.id#"	
	ReturnVariable="HRAccess">		
	
<cfif PayrollAccess neq "NONE" or HRAccess neq "NONE" or Client.PersonNo eq URL.ID>

<cfoutput>

	<script language="JavaScript">
					
	function detail(box,id,cur,phase) {
		
		 se = document.getElementById("d"+box)		
		 if (se.className == "regular") {
		 
		    se.className   = "hide"
						
		 } else {
		 			
			 url = "#session.root#/Payroll/Application/Payroll/SalarySlip.cfm?ts="+new Date().getTime()+"&id=#URL.ID#"+"&settlementid="+id+"&currency="+cur+"&settlmentphase="+phase		   
			 ptoken.navigate(url,'i'+box)     
			 se.className = "regular"	 
         }	
	}		
	
	function showYearReport(mis, personno, yr, cur, contributions) {
		ptoken.open("#session.root#/Payroll/Application/Payroll/AnnualStatement/Report.cfm?year="+yr+"&personno="+personno+"&mission="+mis+'&currency='+cur+'&contributions='+contributions,"_blank","left=40, top=10, width=1000, height=800, status=yes, menubar=no, toolbar=no, scrollbars=yes, resizable=yes");
	}
				
	function print(id,phase,docCur) {
		ptoken.open("#session.root#/Payroll/Application/Payroll/SalarySlipView.cfm?settlementphase="+phase+"&settlementid="+id+"&documentCurrency="+docCur,"_blank","left=40, top=10, width=840, height=960, status=yes, menubar=no, toolbar=no, scrollbars=yes, resizable=yes")	
	}		
			
	</script>
	
</cfoutput>

<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">

	<tr><td height="10">	
		  <cfset ctr      = "1">		
	      <cfset openmode = "open"> 
		  <cfinclude template="../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">		  
		 </td>
	</tr>	
		      
   <tr><td height="100%">
		
		<table width="100%" 		     
			  height="100%"			 
			  align="center">	  
		 		
				<tr>
				    <td  style="padding:20px 0 10px 30px;height:54px;" valign="top" height="100" id="result">
					<img src="<cfoutput>#session.root#/Images/Logos/Payroll/Settlement.png</cfoutput>" style="height:65px;float:left;">
        <h1 style="float:left;color:#333333;font-size:28px;font-weight:200;padding-top:10px;">Check your<strong> Payslips</strong></h1>
        <p style="clear: both; font-size: 15px; margin: 1% 0 0 1%;">Check and print the details of your monthly payments, deductions and benefits.</p>
        <div class="emptyspace" style="height: 40px;"></div>					
					<cfinclude template="EmployeeSettlement.cfm">
				    </td>
				</tr>
								
		</table>
	
	   </td>
	   
   </tr>
	
</table>

</cfif>