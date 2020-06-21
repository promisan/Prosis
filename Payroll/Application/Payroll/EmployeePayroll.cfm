	
<cf_actionListingScript>
<cf_FileLibraryScript>	
<cf_listingscript>
<cf_dialogStaffing>
<cf_dialogPosition>

<cfajaximport tags="cfdiv,cfform">

<cf_verifyOnBoard PersonNo="#url.id#">

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
		
		function reloadForm(view) {
			window.location = "EmployeePayroll.cfm?id=#URL.ID#&view="+view
		}
					
		function detail(box,id,cur,phase) {					
			se = document.getElementById("d"+box)		
			if (se.className == "regular") {			 
			    se.className   = "hide"							
			} else {			 			
			  url = "SalarySlip.cfm?box="+box+"&id=#URL.ID#"+"&settlementid="+id+"&currency="+cur+"&settlementphase="+phase		   
			  ptoken.navigate(url,'i'+box)     
			  se.className = "regular"	 
	        }	
		}		
		
		function drilldown(id,phase,cls,itm,target,box) {		 
			url = "SalarySlipSettlementLine.cfm?id="+id+"&settlementphase="+phase+"&payrollitem="+itm+"&box="+box		   
			ptoken.navigate(url,target)     		 
		}		
		
		function editsettlement(id,set,grp,box) {
			ProsisUI.createWindow('editsettlement', 'Edit settlement', '',{x:100,y:100,height:360,width:400,modal:true,center:true})    				
			ptoken.navigate('#session.root#/Payroll/Application/Payroll/SettlementLineForm.cfm?box='+box+'&id='+id+'&paymentid='+set+'&printgroup='+grp,'editsettlement') 		
		} 
		
		function showprogresscalculate(processno) {
		   if (document.getElementById('progressbox')) {
		      ColdFusion.navigate('../Calculation/CalculationProcessProgress.cfm?processno='+processno,'progressbox')
		   } else {
		   stopprogress()
		  }
	    }
		
		function openfinal(id) {
		     ptoken.open('#session.root#/Payroll/Application/Payroll/FinalPayment/FinalPaymentView.cfm?settlementid='+id+'&systemfunctionid=#url.systemfunctionid#','_blank')
		}
	
		function stopprogress() {
		   clearInterval ( prg );
		}	
		
				
		function payrollprocess(processno,personno,enforce,mission,mde) {
	
			var dateEff   = document.getElementById("dateEffective").value;	
			var startFrom = document.getElementById("customPeriodStart").value;	
		    
		    <cfif getAdministrator("*") eq "1">	
			  window.open('../Calculation/CalculationProcess.cfm?mode='+mde+'&processno='+processno+'&mission='+mission+'&personno='+personno+'&enforce='+enforce+'&dateEff='+dateEff+'&customStart='+startFrom,'_blank') 
			<cfelse>
			    ptoken.navigate('../Calculation/CalculationProcess.cfm?mode='+mde+'&processno='+processno+'&mission='+mission+'&personno='+personno+'&enforce='+enforce+'&dateEff='+dateEff+'&customStart='+startFrom,'runbox') 	 										
			 </cfif>
			showprogresscalculate(processno)		 				 
		} 
			
		function print(id,phase,docCur) {
		   window.open("SalarySlipView.cfm?settlementphase="+phase+"&settlementid="+id+"&documentCurrency="+docCur,"_blank","left=40, top=10, width=840, height=960, status=yes, menubar=no, toolbar=no, scrollbars=yes, resizable=yes")	
		}
		
		function month(yr) {
		   window.location = "EmployeePayroll.cfm?view=EntitlementDetail&id=#URL.ID#&paymentyear="+yr
		}
			
		function drill(mde,mis,box,yr,item,curr) {
		
			se = document.getElementById("d"+box)
			icM  = document.getElementById(box+"Min")
		    icE  = document.getElementById(box+"Exp")
			if (se.className  == "regular") {
			    se.className   = "hide"
				icE.className  = "regular";
	  	        icM.className  = "hide";			
			 } else {
				 icM.className = "regular";
		         icE.className = "hide";
				 url = "EmployeeEntitlementDrill.cfm?"+
			       "&id=#URL.ID#"+
				   "&mode="+mde+
				   "&mission="+mis+
				   "&year="+yr+
				   "&item="+item+
				   "&box="+box+
				   "&curr="+curr						   
				 ptoken.navigate(url,'i'+box)
				 se.className = "regular"  		    
	     	}	
		}	
			
		function workflowdrill(key,box,mode) {	
		   
			se = document.getElementById(box)
			ex = document.getElementById("exp"+key)
			co = document.getElementById("col"+key)			
			
			if (se.className == "hide") {		
			    se.className = "regular" 		   
			    co.className = "regular"
			    ex.className = "hide"			 
			    ptoken.navigate('#SESSION.root#/staffing/application/employee/HRAction/HRActionWorkflow.cfm?ajaxid='+key,key)		   		  
			} else {  se.className = "hide"
			          ex.className = "regular"
			   	      co.className = "hide" 
		    } 	
		
		}		
	
		function showYearReport(mis, personno, yr, cur) {
			var vSign = $('##Sign_'+yr+'_'+cur).val();
			var vContributions = 0;
			var vDeductions = 0;
			var vMiscellaneous = 0;
			
			if ($('##Contributions_'+yr+'_'+cur).is(':checked')) { vContributions = 1; }
			if ($('##Deductions_'+yr+'_'+cur).is(':checked')) { vDeductions = 1; }
			if ($('##Miscellaneous_'+yr+'_'+cur).is(':checked')) { vMiscellaneous = 1; }
			
			ptoken.open("AnnualStatement/Report.cfm?year="+yr+"&personno="+personno+"&mission="+mis+'&currency='+cur+'&contributions='+vContributions+'&deductions='+vDeductions+'&miscellaneous='+vMiscellaneous+'&sign='+vSign,"_blank","left=40, top=10, width=1000, height=800, status=yes, menubar=no, toolbar=no, scrollbars=yes, resizable=yes");
		}
		
		function showPpost(transactionid,personno) {
			ptoken.open("../../../custom/stl/payroll/DataExport/DoSUN.cfm?transactionid="+transactionid+"&personno="+personno+"&id="+transactionid,"_blank","left=40, top=10, width=1200, height=400, status=yes, menubar=no, toolbar=no, scrollbars=yes, resizable=yes");
		}
			
		</script>
		
	</cfoutput>

<cfparam name="url.header" default="0">

<cfif url.header eq "1">
	<cf_screenTop height="100%" jquery="Yes"  html="yes" band="no" scroll="no" menuaccess="context" layout="default" actionobject="Person"
		actionobjectkeyvalue1="#url.id#">	
<cfelse>
	<cf_screenTop height="100%" jquery="Yes" html="no" band="no" scroll="no" menuaccess="context" layout="default" actionobject="Person"
		actionobjectkeyvalue1="#url.id#">
</cfif>	

<table width="99%" height="100%" align="center" style="min-width:970" class="formpadding">

	<tr><td height="10" style="padding-left:7px">	
		  <cfset ctr        = "1">	
		  <cfset url.header = 1>	
	      <cfset openmode = "show"> 
		  <cfinclude template="../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">		  
		 </td>
	</tr>	
	    
   <cfparam name="URL.View" default="Entitlement">

   <tr><td height="20" valign="top">	
   
	   <table width="98%" cellspacing="0" cellpadding="0" align="center">
	   
	   <tr>			
	   		   	   	   						
			<cf_tl id="Calculated Entitlements"	var="1">
			<cfset msg1=#lt_text#>

			<cf_tl id="Settlement (payslip)"	var="1">
			<cfset msg2=#lt_text#>
			
			<cf_tl id="Staff Payroll Action"	var="1">
			<cfset msg3=#lt_text#>
			
			<cf_tl id="Recalculate Payroll"	    var="1">
			<cfset msg4=#lt_text#>		
			
			<cf_tl id="Calculation Log"	        var="1">
			<cfset msg6=#lt_text#>		
			
			<cf_tl id="Off cycle or Final Pay"	    var="1">
			<cfset msg5=#lt_text#>
			
			<cfset itm = 0>
						
			
			<cfif PayrollAccess is "ALL" or PayrollAccess eq "Edit" or PayrollAccess eq "Read">
			
				<cfset itm = itm + 1>
								
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Payroll/Entitlement.png" 
							iconwidth  = "64" 
							iconheight = "64" 
							class      = "highlight1"
							name       = "#msg1#"
							source     = "EmployeeEntitlement.cfm?id=#url.id#">
						
			</cfif>		
			
			<cfif PayrollAccess is "Edit"  or PayrollAccess is "ALL">			
						
				<cfset itm = itm+1>						
							
			    <cf_menutab item       = "#itm#" 
				            iconsrc    = "Action.png" 
							targetitem = "1"
							iconwidth  = "64" 
							iconheight = "64" 
							name       = "#msg3#"
							source     = "../../../Staffing/Application/Employee/HRAction/HRAction.cfm?id=#url.id#">	
							
				<cfquery name="qFinal"
			    datasource="AppsEmployee" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				  SELECT     *
				  FROM       Payroll.dbo.EmployeeSettlement ES INNER JOIN 
				  			 Person P ON ES.PersonNo = P.PersonNo INNER JOIN 
							 Payroll.dbo.SalarySchedule R ON ES.SalarySchedule = R.SalarySchedule
				  WHERE      ES.PaymentFinal = '1'
				  AND        ES.PersonNo     = '#url.id#'    	                   
				</cfquery> 			
				
				<cfif qFinal.recordcount gte "1">	
							
					<cfset itm = itm+1>						
								
				    <cf_menutab item       = "#itm#" 
					            iconsrc    = "Payment.png" 
								targetitem = "1"
								iconwidth  = "64" 
								iconheight = "64" 
								name       = "#msg5#"
								source     = "EmployeeFinalPayment.cfm?id=#url.id#&systemfunctionid=#url.systemfunctionid#">	
							
				</cfif>											
						
			</cfif>			
			
			<cfif PayrollAccess eq "ALL" or PayrollAccess eq "Edit" or PayrollAccess eq "Read">	
			  
				<cfset itm = itm+1>						
							
			    <cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Payroll/Settlement.png" 
							targetitem = "1"
							iconwidth  = "64" 
							iconheight = "64" 
							name       = "#msg2#"
							source     = "EmployeeSettlement.cfm?id=#url.id#">		
						
			</cfif>			
			
			<cfquery name="check" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   TOP 1 * 
				FROM     EmployeeSettlement
				WHERE    PersonNo = '#url.id#'				
				AND      PaymentFinal = 1 
				-- AND    ActionStatus = '0'
			</cfquery>	
											
			<cfif PayrollAccess is "ALL">		
					
					<cfset itm = itm+1>
								
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Payroll/Recalculate.png" 
								targetitem = "1"
								iconwidth  = "64" 
								iconheight = "64" 
								name       = "#msg4#"
								source     = "../Calculation/CalculationProcessExecutePerson.cfm?id=#url.id#">	
								
					<cfset itm = itm+1>
								
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Report/log.png" 
								targetitem = "1"
								iconwidth  = "64" 
								iconheight = "64" 
								name       = "#msg6#"
								source     = "Calculation/CalculationListing.cfm?id=#url.id#&systemfunctionid=#url.systemfunctionid#">				
						
			</cfif>			
   
       </tr>
	   </table> 	
	 	
	 </td>
   </tr>	 
   
   <cf_menuscript>
          
   <tr><td height="1" colspan="1">
        <table width="98%" align="center"><tr><td class="line" height="1"></td></tr></table>
   </td></tr>
	
   <tr><td height="100%" style="padding-right:16px">
   
   		
		
		<table width="99%" 		      
			  height="100%"
			  align="center">	  
		 		
				<tr class="hide"><td valign="top" height="1" id="result"></td></tr>							
				<cf_menucontainer item="1" class="regular">
												
		</table>
		
		
	
	</td></tr>
	
</table>

<cfoutput>

	<script>
	    document.getElementById('menu1').click()
	</script>
	
</cfoutput>
	
</cfif>