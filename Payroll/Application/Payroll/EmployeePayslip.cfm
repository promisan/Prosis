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
			 ColdFusion.navigate(url,'i'+box)     
			 se.className = "regular"	 
         }	
	}		
	
	function showYearReport(mis, personno, yr, cur, contributions) {
		ptoken.open("#session.root#/Payroll/Application/Payroll/AnnualStatement/Report.cfm?year="+yr+"&personno="+personno+"&mission="+mis+'&currency='+cur+'&contributions='+contributions,"_blank","left=40, top=10, width=1000, height=800, status=yes, menubar=no, toolbar=no, scrollbars=yes, resizable=yes");
	}
				
	function print(id,phase,docCur) {
		window.open("#session.root#/Payroll/Application/Payroll/SalarySlipView.cfm?settlementphase="+phase+"&settlementid="+id+"&documentCurrency="+docCur,"_blank","left=40, top=10, width=840, height=960, status=yes, menubar=no, toolbar=no, scrollbars=yes, resizable=yes")	
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
		      border="0"
			  height="100%"
			  cellspacing="0" 
			  cellpadding="0" 
			  align="center" 
		      bordercolor="d4d4d4">	  
		 		
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