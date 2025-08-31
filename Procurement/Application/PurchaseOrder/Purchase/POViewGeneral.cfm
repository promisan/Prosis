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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<cfparam name="URL.Mode"   default="view">
<cfparam name="URL.Header" default="Yes">

<cfif url.mode eq "" or (url.mode neq "edit" and url.mode neq "add")>
   <cfset url.mode = "view">   
</cfif>

<cf_tl id="Procurement" var="1"> 

<cfif url.header eq "Yes">

<cf_screentop  
    layout        = "webapp" 
	html          = "#url.header#" 
	label         = "#lt_text# #URL.Id1#" 		
	banner        = "green" 
	bannerforce   = "Yes"
	scroll        = "No"	
	line          = "no"
	jQuery        = "Yes"
	systemmodule  = "Procurement"
	FunctionClass = "Window"
	FunctionName  = "PurchaseOrder"
	menuAccess    = "context"
	height        = "100%">
		
<cfelseif url.header neq "No">

<cf_screentop  
    layout        = "webapp" 
	html          = "#url.header#" 
	label         = "#lt_text# #URL.Id1#" 		
	banner        = "green" 
	bannerforce   = "Yes"
	scroll        = "No"	
	line          = "no"
	jQuery        = "Yes"
	systemmodule  = "Procurement"
	FunctionClass = "Window"
	FunctionName  = "PurchaseOrder"	
	height        = "100%">
	
</cfif>	

<!--- End Prosis template framework --->

 <cfquery name="PO" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   Purchase P
		WHERE  PurchaseNo ='#URL.Id1#'
		AND    PurchaseNo IN (SELECT PurchaseNo 
		                      FROM   PurchaseLine
							  WHERE  PurchaseNo = P.PurchaseNo)
</cfquery>	

<cfquery name="PurchaseClass" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_OrderClass
		WHERE  Code = '#PO.OrderClass#' 
</cfquery>


<cfquery name="PurchaseType" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_OrderType
		WHERE  Code = '#PO.OrderType#' 
</cfquery>	
	
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#PO.Mission#' 
</cfquery>
	
<cfquery name="Invoice" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    * 
        FROM      Invoice
		WHERE     InvoiceId IN (SELECT InvoiceId FROM InvoicePurchase WHERE PurchaseNO = '#URL.ID1#')
		AND       ActionStatus != '9'
		order by documentDate
</cfquery>  

<cfquery name="Receipt" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    * 
        FROM      PurchaseLineReceipt
		WHERE     RequisitionNo IN (SELECT RequisitionNo FROM PurchaseLine WHERE PurchaseNO = '#URL.ID1#')
		AND       ActionStatus != '9'		
</cfquery>  		

<cfif PurchaseClass.PurchaseTemplate neq "">
	<cfset tmp = "#PurchaseClass.PurchaseTemplate#">
<cfelseif Parameter.PurchaseTemplate neq "">
    <cfset tmp = "#Parameter.PurchaseTemplate#"> 
<cfelse>
	<cfset tmp = "Procurement/Application/Purchaseorder/Purchase/POViewPrint.cfm">  
</cfif>
		
<cfparam name="CLIENT.Sort" default="OrgUnit">
<cfparam name="URL.Sort"    default="line">
<cfparam name="URL.View"    default="Hide">
<cfparam name="URL.Lay"     default="Reference">
<cfif url.mode eq "undefined">
  <cfset url.mode = "view">
</cfif>
<cfparam name="URL.Role"    default="">

<cf_tl id="Memo" var="1">
<cfset vMemo="#lt_text#">

<cf_tl id="Approval History" var="1">
<cfset vHistory="#lt_text#">

<cf_tl id="Received Invoices" var="1">
<cfset vReceived="#lt_text#">

<cfoutput>

	<script>
	
	  function executionrequest(po,exe) {
			
		 se = document.getElementById('box'+exe);
		 if (se.className == 'hide') {
		    se.className = 'regular';
			ptoken.navigate('../ExecutionRequest/ViewDrill.cfm?mode=drill&purchaseno='+po+'&executionid='+exe,'c'+exe);
		 } else {
		   se.className = 'hide'; 
		 }
	 }
	 
	 function ask(status) {
	       
		de = document.getElementById("destination")					
	    if (status <= "1") { 
		    sel = "return this Obligation ?" 
		} else { 	     
		    sel = "Approve this Obligation ?" }		
		
		if (confirm("Do you want to "+sel))	{
			document.getElementById("fStatus").submit();		 
		}
			
	}	
	
	function validate(frm,box,target) {	  
	   document.getElementById(frm).onsubmit() 
	   if( _CF_error_messages.length == 0 ) {	           
		    ptoken.navigate(target,box,'','','POST',frm)
	     }   
    }	
		
	function reloadForm(mode,sort,head) {	
		    
		 if (!head) {
		    header = "#url.header#"
		} else { 
		    header = head
		}	    
		ptoken.location("POView.cfm?Mode=" + mode + "&role=#URL.Role#&ID1=#URL.ID1#&Sort="+sort+"&header="+header) 
	}
	
	function amendpurchase() {	
		if (confirm("Do you want to amend and reset the status of this purchase order"))	{
		    Prosis.busy('yes')
			ptoken.navigate('setPOAmendment.cfm?header=#url.header#&role=#URL.Role#&Purchaseno=#URL.ID1#','amendbox')		 
		}	
	}
	
	function clonepurchase(po) {	
	if (confirm("Do you want to clone the lines of this purchase ?"))	{
		ptoken.navigate('#session.root#/Procurement/Application/PurchaseOrder/Purchase/applyCopyRequisition.cfm?purchaseNo='+po,'processrequisition')
	} 	
	}	
	
	function gettimesheet(po) {   	    		
		w = document.body.clientWidth-50										
		ProsisUI.createWindow('timesheet', 'Timesheet', '#session.root#/Procurement/Application/PurchaseOrder/Timesheet/TimeSheet.cfm?purchaseno='+po,{x:30,y:30,height:document.body.clientHeight-50,width:w,resizable:false,modal:true,center:true});	
	}
			
	function more(bx,act,bx2) {
	
	    icM  = document.getElementById(bx+"Min")
	    icE  = document.getElementById(bx+"Exp")
		se   = document.getElementById(bx)
		se2   = document.getElementById(bx2)
			
		if (se.className=="hide") {
			se.className  = "regular";
			if (se2) { se2.className  = "regular"; }
			icM.className = "regular";
		    icE.className = "hide";
		} else	{
			se.className  = "hide";
			if (se2) { se2.className  = "hide"; }
		    icM.className = "hide";
		    icE.className = "regular";
		}
		}
			
		function clause(cl) {
		 	 w = #CLIENT.width# - 100;
			 h = #CLIENT.height# - 140;
		     ptoken.open("#session.root#/Procurement/Application/PurchaseOrder/Purchase/POViewClausePrint.cfm?PurchaseNo=#URL.ID1#&ClauseCode="+cl,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	  	}
										  
		function invadd(orgunit,po,personno) {	
		     ptoken.open("#SESSION.root#/Procurement/Application/Invoice/InvoiceEntry/InvoiceEntryView.cfm?html=yes&Mission=#PO.Mission#&Period=#PO.Period#&OrgUnit="+orgunit+"&PersonNo="+personno+"&PurchaseNo="+po,"_blank","width=1050, height=960, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");							   						 
		 }	
		 
		function present(mode) {
			     		  		  
		    w = #CLIENT.width# - 100;
		    h = #CLIENT.height# - 140;		  
		    docid = document.getElementById("printdocumentid").value
		  		  		  
		    if (docid != "") {			   
			   ptoken.open("#SESSION.root#/Tools/Mail/MailPrepare.cfm?docid="+docid+"&id="+mode+"&id1=#URL.ID1#","_blank", "left=30, top=30, width=900, height=700, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes")
		    } else {
		       ptoken.open("#SESSION.root#/Tools/Mail/MailPrepare.cfm?templatepath=#tmp#&id="+mode+"&id1=#URL.ID1#","_blank", "left=30, top=30, width=900, height=700, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes")		 
		    }	  
		  
	  	} 	
			
	</script>

</cfoutput>

<!--- check if the person has edit rights to the purchase order --->

<cfajaximport tags="cfform">

<cf_DialogProcurement>
<cf_DialogWorkOrder>
<cf_dialogOrganization>
<cf_dialogLedger>
<cf_timesheetscript>
          		
	<cfquery name="Access" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT    *
	  FROM    PurchaseActor
	  WHERE   PurchaseNo = '#URL.ID1#'
	  AND     ActorUserId = '#SESSION.acc#'
	</cfquery>
	
	<cfif url.mode eq "View">	
				
		<cfif (Access.recordcount gte "1" or getAdministrator("#PO.Mission#") eq "1") and PO.ActionStatus lte "2">		
			<cfset url.mode = "Edit">			
		</cfif>	
		
	</cfif>
		
	<cfinvoke component="Service.Access"
	   Method         = "procApprover"
	   OrgUnit        = "#PO.OrgUnit#"
	   OrderClass     = "#PO.OrderClass#"
	   ReturnVariable = "ApprovalAccess">	
		   
	<cfif (ApprovalAccess eq "NONE" or ApprovalAccess eq "READ") and Access.recordcount eq "0">

		<cfset url.access = "View">

	</cfif>	   
	
	<cfif PO.recordcount eq "0">	
	  	   	
	   <cf_message message = "Order [#URL.ID1#] does not have any lines associated." return="no">
	    
	   <cfabort>
	   	
	</cfif>
	
<cf_divscroll>		
	
<table style="width:97%;min-width:1000px" align="center">

	<tr class="fixrow">
	
	<td style="background-color:white">
	
	<cfoutput>
		
	<table width="99%" align="center" class="formpadding">
	
	   <tr>
	    <td height="32" style="background-color:white;padding-left:5px;font-size:17px">
						
		 <cf_tl id="#PurchaseType.Description#">: 
		 <cfoutput><b>#PO.PurchaseNo#<cfif PO.ModificationNo neq "">/#PO.ModificationNo#</cfif></cfoutput>			
						
		</td>

	    <td align="right" style="background-color:white">
		  	<select name="sort" id="sort" style="border:0px;background-color:f1f1f1" size="1" class="regularxxl" onChange="reloadForm('<cfoutput>#URL.Mode#</cfoutput>',this.value,'yes')">
   	  		    <option value="Line" <cfif URL.Sort eq "Line">selected</cfif>><cf_tl id="Default">
			    <option value="GL"   <cfif URL.Sort eq "GL">selected</cfif>><cf_tl id="Show Ledger Transaction">
		 	</select>
	     </td>
		 
		 <td width="170" align="right" style="background-color:white">
		 
		 	<cfoutput>
		 
			 	<script>				
					function refresh() {
					    ptoken.location('POView.cfm?ID1=#url.id1#&mode=#url.mode#')
					}				
				</script>
				
				<table class="formspacing"> 
		 
			     <tr>
				 <td>|</td>
				 <td>
			 	 <button onClick="Prosis.busy('yes');refresh()" type="button" style="width:40px" class="button10g">
				     <img src="#SESSION.root#/Images/refresh.gif" alt="Refresh" border="0" align="absmiddle" style="height:14px;width:18px" >
				 </button>
				 </td>
				 <td>|</td>
				 <td>
				 <button onClick="present('mail')" type="button" style="width:40px" class="button10g">
				     <img src="#SESSION.root#/Images/mail.png" alt="Send eMail" border="0" align="absmiddle" style="height:26px;width:26px">
				 </button>
				 </td>
				 <td>|</td>
				 <td>
				 <button onClick="present('pdf')" type="button" style="width:40px" class="button10g">
				    <img src="#SESSION.root#/Images/pdf.png" alt="Print" border="0" style="height:18px;width:20px" align="absmiddle">
				 </button>
				 </td>
				
				 
				 </table>				
			 </cfoutput>	
			 	   
	     </td>
		 	 
	   </tr>
	  </table>
	
	</td>
	
	<td colspan="1" height="26" align="right"></td>
	
  </tr>
	
  </cfoutput>
  
      
  <tr><td colspan="2">
  
  <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
       
    <cfif URL.Mode eq "Edit" and PO.ActionStatus eq "0">
	 	<cfset b = "regular">
	    <cfset a = "hide">
	<cfelse>
	    <cfset b = "regular">
	    <cfset a = "hide"> 
	</cfif>
			
	<tr><td colspan="2">
	
	<table width="100%" align="center">
			
	 <cfquery name="CheckMission" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   *
			 FROM     Organization.dbo.Ref_EntityMission 
			 WHERE    EntityCode     = 'ProcPO'  
			 AND      Mission        = '#PO.Mission#' 
	 </cfquery>	
 	
	<tr><td colspan="2">
	
		 <table width="99%" align="center">
			
		 <tr>
		     <td height="20">
			 
		       <table width="100%" border="0">
			    <tr><td onClick="more('header','show')" width="20" style="cursor: pointer;" align="center" style="border-right: 1px solid Silver;">
			    <cfoutput>
				
				    <img src="#SESSION.root#/Images/arrowright.gif" alt="" 
					id="headerExp" border="0" class="hide" align="absmiddle">
					
					<img src="#SESSION.root#/Images/arrowdown.gif" 
					id="headerMin" alt="" border="0" align="absmiddle" class="regular">
					
				</cfoutput>	
				
				</td>
								
				<td>
				
					<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
					<tr>					
					    <td onClick="more('header','show')" class="labellarge" style="height:31px;padding-left:5px;cursor: pointer;"><cf_tl id="General Information"></td>
						
						<cfif CheckMission.WorkflowEnabled eq "0" or CheckMission.recordCount eq 0>		
						
						<td width="70%" align="right">
												
						   <!--- now we show the bar for the status --->
						   <cfif PO.ActionStatus gt "1">						   
						   
						   	    <cfform action="POStatusSubmit.cfm?Header=#url.header#&Role=#URL.Role#&ID1=#URL.ID1#&Sort=#URL.Sort#" 
									method="post" id="fStatus" name="fStatus"
									onsubmit="return true">		
						
								   <!--- manual status management, legacy mode --->
								   <cfoutput query="PO" maxrows=1>	
										<cfinclude template="POViewStatus.cfm">
								   </cfoutput>
							   
							   </cfform>
						   
						   </cfif>
						
						</td>	
						
						<cfelse>
						
							 <td width="70%" class="labellarge">	
							 
							    <cfquery name="Status" 
						          datasource="AppsPurchase" 
					      		  username="#SESSION.login#" 
					        	  password="#SESSION.dbpw#">
					      			SELECT * 
					        		FROM   Status
					      			WHERE  StatusClass = 'Purchase'
									AND    Status      = '#PO.ActionStatus#' 
					      		  </cfquery>
							
							 <cfif PO.actionStatus eq "9">
							 
							   <font size="4" color="FF0000"><b><cfoutput>#Status.Description#</cfoutput></b></font>	
							 
							 </cfif>
							 
							 </td>
						 						
						</cfif>
										  							
					</tr>
					</table>
				
				</td></tr>
		  	</table>
			</td>
		 </tr>	
		 
		 <tr><td colspan="2" class="line"></td></tr>
	
	 		 		 
		 <tr id="header" style="padding-top:3px" class="regular">		 
			  <td>
							  
			  <cfform action="POUpdateSubmit.cfm?Header=#url.header#&Role=#URL.Role#&ID1=#URL.ID1#&Sort=#URL.Sort#" 
					method="post" 
					id="fPurchaseOrder" 
					name="fPurchaseOrder"
					onsubmit="return true">	
						
				  <table width="100%">
				     
					  <cfoutput query="PO" maxrows=1>		
					  
					 	<cfif CheckMission.WorkflowEnabled eq "0" or CheckMission.RecordCount eq 0>		
						  <tr><td>		
							  <cfif PO.ActionStatus eq "0">					  
								  <cfinclude template="POViewStatus.cfm">
							  </cfif>	  
						  </td></tr>										  
						</cfif>
												
						<tr><td id="process"></td></tr>
					  
				      	<tr><td><cfinclude template="POViewHeader.cfm"></td></tr>	 							
												
					  </cfoutput>	
					  	
				  </table>
			  
			  </cfform>
						  
			  </td>
		   </tr>
		   
		</table>
	  
   </td></tr>
    
   </table>	 
	 
</td></tr>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#PO.Mission#' 
</cfquery>

<tr><td height="4"></td></tr>

<!--- --------------------------------------- --->
<!--- ----------Funding subtab -------------- --->
<!--- --------------------------------------- --->

<tr><td>

	<table width="99%" align="center">
	  
       <tr class="fixrow"><td height="20" onClick="more('fun','show')" style="cursor: pointer;">
		   <table width="100%">
		   
		    <tr class="line">
			<td width="24" align="center" style="background-color:white">
			
		    <cfoutput>
			
				<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
				id="funExp" class="regular" align="absmiddle">
				
				<img src="#SESSION.root#/Images/arrowdown.gif" 
				id="funMin" align="absmiddle" class="hide">
				
			</cfoutput>
									
			</td>
			<td class="labellarge" style="background-color:white;padding-left:3px;font-size:24px;height:50px;color:0080C0"><cf_tl id="Funding"></td>
			</tr>
		  </table>
	  	</td></tr>
			
	    <tr id="fun" class="hide">		 
		  <td style="padding-left:20px">
		  <table width="100%" align="center">
		    
		      <tr><td>
			   <cfinclude template="POViewFunding.cfm"> 
			   </td></tr>	 
		  </table>
		  </td>
	   </tr>
	   
	</table>
	
</td></tr>
</table>


<!--- --------------------------------------- --->
<!--- ----------Purchase Lines tab ---------- --->
<!--- --------------------------------------- --->	

<cfoutput>		
  
  <script LANGUAGE = "JavaScript">
	  
			function deleteline(id,no) {
			
				ProsisUI.createWindow('linedecision', 'Purchase line', '',{x:100,y:100,height:200,width:310,modal:true,center:true})    		 				
				ptoken.navigate('POViewDelete.cfm?Role=#URL.Role#&ID1=#URL.ID1#&Sort=#URL.Sort#&reqno='+id+'&no='+no,'linedecision')		
				
			}  		
			
			function hl(itm,fld,reqno){		
			     ln1 = document.getElementById(reqno+"_1");			 	 	 		 	
				 if (fld != false){
					 ln1.className = "highLight4";
				 }else{
				 ln1.className = "header";					
				 }
			  }
			  
			function detail(id) {				
				 se = document.getElementById(id)
				 if (se.className == "regular") {
				    se.className = "hide"
					} else {				
					se.className = "regular"		 
				    url = "POViewLines_BalanceDetail.cfm?id="+id;	
			   	    ptoken.navigate(url,'i'+id)}				  
				  }
				  
			function classes(id) {
					
				 se = document.getElementById("x"+id)
				 if (se.className == "regular") {
			        se.className = "hide"
				 } else {
					 se.className = "regular"
					 url = "POViewClass.cfm?mode=view&id="+id;	
					 ptoken.navigate(url,'xi'+id)		  
				  }	  
				  }
			
   	 </script>
	 
</cfoutput>	 	

	<table width="100%" align="center">				
	
	<tr><td>
			
		<table width="99%" align="center">
	  	
	       <tr class="fixrow"><td height="24" style="cursor: pointer;">
		   	  
			   <table width="100%" border="0">
			   			   
			   		<cfoutput>
					
					    <tr class="line">
						<td width="24" align="center" style="background-color:white" onClick="more('lines','show')" >		
											
							<img src="#SESSION.root#/Images/arrowright.gif" alt="" id="linesExp" border="0" class="hide"    align="absmiddle">
							<img src="#SESSION.root#/Images/arrowdown.gif"  alt="" id="linesMin" border="0" class="regular" align="absmiddle">				
						
						</td>					
						<td onClick="more('lines','show')" class="labellarge" style="background-color:white;padding-right:13px;font-size:24px;height:50px;color:0080C0;"><cf_tl id="Purchase details and Receipts"></td>					
						
							<cf_tl id="Export data to Excel" var="vExport">
							
							<cfinvoke component="Service.Analysis.CrossTab"  
									  method         = "ShowInquiry"
									  buttonName     = "Excel"
									  buttonText     = "#vExport#"
									  buttonClass    = "td"
									  buttonIcon     = "#SESSION.root#/Images/excel.gif"							
									  reportPath     = "Procurement\Application\PurchaseOrder\Purchase\"
									  SQLtemplate    = "POViewGeneralLinesExcel.cfm"
									  queryString    = "purchaseno=#URL.id1#"
									  dataSource     = "appsQuery" 
									  module         = "Procurement"
									  reportName     = "Facttable: Purchase Lines Detail"
									  table1Name     = "Export file"
									  data           = "1"							 
									  ajax           = "0"
									  olap           = "0" 
									  excel          = "1"> 				
				 
						
						<td align="right" style="padding:4px;padding-left:20px;width:150px;background-color:ffffff">
						
						    <table>
							<tr><td><input class="regularxxl" style="border:0px;background-color:f1f1f1;padding-left:3px" id="inputline"></td>
							<td>						
							<img src="#SESSION.root#/Images/search.png" alt="Find line" 
							   style="cursor: pointer;border:1px solid silver" 
							   border="0" height="25" width="25" id="refreshpurchasline" align="absmiddle"
							   onclick="_cf_loadingtexthtml='';ptoken.navigate('POViewGeneralLines.cfm?sort=#url.sort#&mode=#url.mode#&id1=#url.id1#&filter='+document.getElementById('inputline').value,'linescontent');ptoken.navigate('getPurchaseTotal.cfm?id1=#url.id1#','total')">							   
							</td>
							</tr>
							</table>
							   
						</td>					
						</tr>
					
					</cfoutput>	
					 	
					
			   </table>
		      </td>
		  </tr>
		  
		  <tr id="lines">
		     <td style="padding-left:20px">		
			
				<cfdiv id="linescontent">				
					<cfinclude template="POViewGeneralLines.cfm">
				</cfdiv>	 						 
			 
			 </td>
		  </tr>
		  		  
		</table>
			  	  	  	  
	</td></tr>
	
	<cfif PO.ActionStatus neq "9">
	
	<!--- ------------------------------------------- --->
	<!--- ----------Distribution subtab ------------- --->
	<!--- ------------------------------------------- --->
	
	<cfif Parameter.EnableExecutionRequest eq "1">  <!--- POType.InvoiceWorkflow eq "1" this condition which was before invoice-only was removed --->
	
	<tr><td>
	
		<table width="99%" align="center">
		  
	       <tr><td height="20" onClick="more('dis','show')" style="cursor: pointer;">
			   <table width="100%">
			    <tr class="line"><td width="24" align="center">
			    
				<cfoutput>
				
					<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
					id="disExp" border="0" class="regular" 
					align="absmiddle">
					
					<img src="#SESSION.root#/Images/arrowdown.gif" 
					id="disMin" alt="" border="0" 
					align="absmiddle" class="hide">
					
				</cfoutput>
				
				</td>
				<td class="labellarge" style="padding-left:3px;font-size:24px;font-weight:bold;height:50px;"><cf_tl id="Distribution"></td>
				</tr>
			  </table>
		  	</td></tr>
				
		    <tr id="dis" class="hide">		 
			  <td style="padding-left:20px">
			 
				  <table width="100%" align="center">		     
				      <tr><td>		
					       <cfdiv id="boxdistribution">    
						   <cfinclude template="POViewDistribution.cfm"> 
						   </cfdiv>			  				   
					       </td>
				      </tr>	 
				  </table>
			  
			  </td>
		   </tr>
		   
		</table>
		
	</td></tr>
	
	</cfif>
	
	<!--- --------------------------------------- --->
	<!--- ----------Advances subtab ------------- --->
	<!--- --------------------------------------- --->
	
	<cfif Parameter.InvoiceAdvance eq "1">
		
		<cfquery name="Lines" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			SELECT   H.Journal,
			         H.JournalSerialNo,
					 H.JournalTransactionNo, 
			         H.Description, 
					 H.Reference, 
					 H.TransactionId,
					 H.TransactionDate, 
					 TL.Currency, 
					 TL.AmountDebit, 
					 TL.AmountCredit, 
					 TL.GLAccount,
					 H.ReferenceName, 
					 H.ReferenceNo,
					 H.ActionStatus,
					 H.OfficerFirstName,
					 H.OfficerLastName
			FROM     TransactionHeader H INNER JOIN
			         TransactionLine TL ON H.Journal = TL.Journal AND H.JournalSerialNo = TL.JournalSerialNo
			WHERE    H.Reference   = 'Advance' 
			AND      H.ReferenceNo = '#URL.ID1#' 
			AND      TL.TransactionSerialNo != '0'
			ORDER BY H.TransactionDate
		</cfquery>
		
		<cf_verifyOperational module="Accounting" Warning="No">
				
		<cfif operational eq "1">
		
		<!--- -------- --->
		<!--- advances --->
		<!--- -------- --->
						
		<tr><td>
		
			<table width="99%" align="center">
		  	
		       <tr class="fixrow"><td height="20" onClick="more('adv','show')" style="cursor: pointer;">
			   <table width="100%">
				    <tr class="line"><td width="24" align="center" style="background-color:white">
				    <cfoutput>
					<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
						id="advExp" border="0" class="hide" 
						align="absmiddle" style="cursor: pointer;">
						
						<img src="#SESSION.root#/Images/arrowdown.gif" 
						id="advMin" alt="" border="0" 
						align="absmiddle" class="regular" style="cursor: pointer;">
						
					</cfoutput>	
					</td>
					<td class="labellarge" style="background-color:white;padding-left:3px;font-size:24px;height:50px;color:0080C0"><cf_tl id="Advances"></td>
					</tr>
			  </table>
			  </td></tr>
			  
			
			  <tr id="adv"><td>
				  <table width="100%" cellspacing="0" cellpadding="0" align="center">			  	
				      <tr><td style="padding-left:20px"><cfinclude template="POViewAdvance.cfm"></td></tr>	 							  
				  </table>
			  </td></tr>
			  </table>
			
		</td></tr>
		
		</cfif>
		
	</cfif>	
	
	
	
	<!--- to be moved --->
	<!--- --------------------------------------- --->
	<!--- ----------Invoice tab --- ------------- --->
	<!--- --------------------------------------- --->
	
	<cfquery name="Lines" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    TOP 1 * 
	        FROM      Invoice
			WHERE     InvoiceId IN (SELECT InvoiceId 
			                        FROM InvoicePurchase 
									WHERE PurchaseNO = '#URL.ID1#') 		
	</cfquery>  
			
	<cfif lines.recordcount gte "0" and PO.Payroll eq "0">	
	
		<tr><td>
		
			<table width="99%" align="center" border="0" cellspacing="0">
			 
		       <tr class="fixrow"><td height="20" style="cursor: pointer;">
			   
			   <table width="100%" cellspacing="0" cellpadding="0">
				  
				    <tr class="line">
					<td style="background-color:white" width="24" align="center" onClick="more('inv','show','inv2')">
				   
				    <cfoutput>
					
						<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
						id="invExp" border="0" class="hide" 
						align="absmiddle" style="cursor: pointer;">
						
						<img src="#SESSION.root#/Images/arrowdown.gif" 
						id="invMin" alt="" border="0" 
						align="absmiddle" class="regular" style="cursor: pointer;">
						
					
					</td>
					<td onClick="more('inv','show','inv2')" 
					    class="labellarge" 
						style="background-color:white;padding-left:3px;font-size:24px;height:50px;color:0080C0"><cfoutput>#vReceived#</cfoutput></td>
									
					<cfif (Lines.recordcount gte "0" and (ApprovalAccess eq "EDIT" or ApprovalAccess eq "ALL")) 
					    or getAdministrator(Lines.mission) eq "1">
						
					<td style="background-color:white"><cfdiv bind="url:ObligationStatus.cfm?id1=#url.id1#" id="obligation"></td>
					
		
		           </cfif>	
				   
				   <cfquery name="Total" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">				
						SELECT    COUNT(*) As Docs,
								  DocumentCurrency,
								  SUM(DocumentAmount) as Total 
				        FROM      Invoice I				
						WHERE     InvoiceId IN (SELECT InvoiceId FROM InvoicePurchase WHERE PurchaseNO = '#URL.ID1#')				
						AND       ActionStatus != '9'  
					    AND   (
								EXISTS
								(SELECT 'X'
									FROM   Organization.dbo.OrganizationObject
									WHERE  EntityCode    = 'ProcInvoice'
									AND ObjectKeyValue4 = I.InvoiceId 
								) 
								OR HistoricInvoice = 1
						)
						GROUP BY  DocumentCurrency
					</cfquery>  
				   
				   <cfif Total.docs gte "1">
										
						<cf_tl id="Export data to Excel" var="vExport">
						
						<cfinvoke component="Service.Analysis.CrossTab"  
								  method         = "ShowInquiry"
								  buttonName     = "Excel"
								  buttonText     = "#vExport#"
								  buttonClass    = "td"
								  buttonIcon     = "#SESSION.root#/Images/excel.gif"							
								  reportPath     = "Procurement\Application\PurchaseOrder\Purchase\"
								  SQLtemplate    = "POViewInvoiceExcel.cfm"
								  queryString    = "purchaseno=#URL.id1#"
								  dataSource     = "appsQuery" 
								  module         = "Procurement"
								  reportName     = "Facttable: Purchase Invoices"
								  table1Name     = "Export file"
								  data           = "1"							 
								  ajax           = "0"
								  olap           = "0" 
								  excel          = "1"> 				
									
					
					<td align="right" style="padding:4px;padding-left:20px;width:150px;background-color:ffffff">
						
						    <table>
							<tr><td><input class="regularxxl" onkeyup="document.getElementById('refreshinvoiceline').click()" style="border:0px;background-color:f1f1f1;padding-left:3px" id="inputinvoice"></td>
							<td>						
							<img src="#SESSION.root#/Images/search.png" 
							   alt="Find line" 
							   style="cursor: pointer;border:1px solid silver" 
							   border="0" height="25" width="25" id="refreshinvoiceline" align="absmiddle"
							   onclick="_cf_loadingtexthtml='';	ptoken.navigate('POViewInvoice.cfm?sort=#url.sort#&mode=#url.mode#&id1=#url.id1#&filter='+document.getElementById('inputinvoice').value,'invoicecontent')">							   
							</td>
							</tr>
							</table>
							   
					</td>	
					
					</cfif>					
					
										
										
					</cfoutput>
					</tr>
			  </table>
			  </td></tr>		  
			  				
				<cf_tl id="REQ046" var="1">
				<cfset vReq046=#lt_text#>		
						
				<cfif total.docs gt "1">
					
					<tr>
					
						<td id="inv2">
						
							 <table align="center" id="lines">						 
							 <tr><td>
								 <table width="100%" border="0" class="formpadding formspacing"align="center">
								     <cfoutput query="total">
								      <tr style="height:20px" class="labelmedium">
										  <td align="right">#vReq046#:</td>
										  <td style="padding-left:4px" class="labelmedium"><b>#Docs#</td>
										  <td style="padding-left:10px" align="right"><cf_tl id="Currency">:</td>
										  <td style="padding-left:4px"><b>#DocumentCurrency#</td>
										  <td style="padding-left:10px" align="right"><cf_tl id="Amount">:</td>
										  <td style="padding-left:4px"><b>#NumberFormat(Total,",.__")#</td>
									  </tr>
									  </cfoutput>
									
								</table>
							    </td>
							 </tr>	
													
							</table>
							
						</td>
					
					</tr>  
							
				</cfif>				  
			
			  <tr id="inv">
			  <td id="invoicecontent" class="labelmedium" align="center" style="padding-left:20px;padding-top:4px;height:30px">
			  
			  	 <cfif total.docs lt "10">
				 		    
				    <cfinclude template="POViewInvoice.cfm"> 
										
				<cfelse>
				
					<cfoutput>
					<a href="javascript:_cf_loadingtexthtml='';	ptoken.navigate('POViewInvoice.cfm?filter=&sort=#url.sort#&mode=#url.mode#&id1=#url.id1#','invoicecontent')">
					<cf_tl id="Press here to view Payables/Invoices">
					</a>		
					</cfoutput>		 		  
			    				 
				 </cfif> 	 
				  		
			  </td></tr>
			  
			  </table>
			
		</td></tr>
	
	</cfif>	
	
	<!--- --------------------------------------- --->
	<!--- ----------Officers subtab ------------- --->
	<!--- --------------------------------------- --->
	
	<tr><td>
	
		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
		   <tr><td height="20" onClick="more('act','show')" style="cursor: pointer;">
		   <table width="100%">
			    <tr class="line fixrow"><td width="24" align="center" style="background-color:white">
			    <cfoutput>
				<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
					id="actExp" border="0" class="regular" 
					align="absmiddle" style="cursor: pointer;">
					
					<img src="#SESSION.root#/Images/arrowdown.gif" 
					id="actMin" alt="" border="0" 
					align="absmiddle" class="hide" style="cursor: pointer;">
					
				</cfoutput>
				</td>
				<td class="labellarge" style="background-color:white;padding-left:3px;font-size:24px;height:50px;color:0080C0"><cf_tl id="Responsible officers"></td>
				</tr>
		  </table>
		  </td></tr>
		  <tr class="hide" id="act"><td>
		  <table width="100%" cellspacing="0" cellpadding="0" align="center">	     
			  
		      <tr><td id="actor" style="height:120;padding-left:20px" valign="top">		  
			   <cfinclude template="POViewActor.cfm"> 
			  </td></tr>	 
		  </table>
		  </td></tr>
		  </table>
		
	</td></tr>
	
	<!--- --------------------------------------- --->
	<!--- ------------Log subtab ---------------- --->
	<!--- --------------------------------------- --->
	
	<cfquery name="Log" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT   * 
		 FROM     PurchaseAction P, Status S
		 WHERE    PurchaseNo = '#URL.ID1#'
		 AND      S.Status = P.ActionStatus
		 AND      S.StatusClass = 'Purchase'
		 ORDER BY ActionDate DESC
	</cfquery>
		
	<cfif Log.recordcount gt "0">
	
	<tr><td>
	
		<table width="99%" cellspacing="0" cellpadding="0" align="center">
	       <tr><td height="20" onClick="more('log','show')" style="cursor: pointer;">
		   <table width="100%">
			    <tr><td width="24" align="center">
			    <cfoutput>
				
				<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
					id="logExp" border="0" class="regular" 
					align="absmiddle">
					
					<img src="#SESSION.root#/Images/arrowdown.gif" 
					id="logMin" alt="" border="0" 
					align="absmiddle" class="hide">
					
				</cfoutput>
				</td>
				<td class="labellarge" style="font-weight:200;height:31px;font-size:24px;;padding-left:3px;height:40"><font color="0080C0"><cfoutput>#vHistory#</cfoutput></td>
				</tr>
		  </table>
		  </td></tr>
		  <tr class="hide" id="log"><td>
		  <table width="100%" cellspacing="0" cellpadding="0" align="center">	  
			  <tr><td colspan="2" class="line"></td></tr>   
		      <tr><td>
			   <cfinclude template="POViewLog.cfm"> 
			  </td></tr>	 
		  </table>
		  </td></tr>
		  </table>
		
	</td></tr>
	
	</cfif>	
	
	<tr><td height="5"></td></tr>
				
	</TABLE>
	
	</td></tr>		

	</cfif>

</table>	

</cf_divscroll>


