
<!--- dialog to show the batch transaction information to be processed --->

<cfparam name="URL.Drillid"            default="0">
<cfparam name="URL.Mission"            default="">
<cfparam name="URL.BatchNo"            default="#url.drillid#">
<cfparam name="URL.Mode"               default="view">
<cfparam name="URL.SystemFunctionId"   default="">
<cfparam name="URL.StockOrderId"       default="">
<cfparam name="URL.Trigger"            default="">

<cfoutput>	

<cfif url.batchno eq "0">

	<cfquery name="check"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   * 
		FROM     WarehouseBatch B
		WHERE    Mission  = '#url.mission#'
		AND      Warehouse = '#url.warehouse#'
		AND      ActionStatus = '0'
		AND      BatchNo IN (SELECT TransactionBatchNo FROM ItemTransaction WHERE TransactionBatchNo = B.BatchNo)
		ORDER BY BatchNo 		
	</cfquery>
	
	<cfif check.recordcount eq "0">

		 <script>
			 window.close()
		 </script>
		 <cfabort>
		 
	<cfelse>
	
		<cfset url.batchno = check.BatchNo>	 
	
	</cfif>

</cfif>

<cfquery name="Check"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     ItemTransaction
	WHERE    TransactionBatchNo = '#URL.BatchNo#' 
	AND      ActionStatus = '0'
</cfquery>

<cfif check.recordcount gte "1">

    <!--- reset batch --->

	<cfquery name="Update"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE WarehouseBatch
		SET    ActionStatus = '0'
		WHERE  BatchNo = '#URL.BatchNo#'
	</cfquery>
	
</cfif>

<cfquery name="Batch"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     WarehouseBatch B, Ref_TransactionType R 
	WHERE    B.TransactionType = R.TransactionType
	AND      BatchNo           = '#URL.BatchNo#'
</cfquery>

<cfquery name="BatchClass"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   R.*
	FROM     WarehouseBatch B
			 INNER JOIN Ref_WarehouseBatchClass R
			 	ON B.BatchClass = R.Code
	AND      B.BatchNo = '#URL.BatchNo#'
</cfquery>

<cf_tl id="Stock Transaction" var="1">

<cfset url.mission = batch.mission>

<cfif url.mode neq "embed">

<cf_screentop height="100%"     
	title="#lt_text# : #URL.BatchNo# (#Batch.Mission#)" 
	label="#lt_text# : #URL.BatchNo# <font size='1'>(#Batch.Mission#)</font>" 
	layout="webapp" 	
	jquery="Yes"
	line="no"
	banner="gray" 
	bannerforce="Yes"
	scroll="no">

</cfif>
	
	<cf_tl id="Do you want to deny this batch" var="1">
	<cfset tCancel="#lt_text#">

	<cf_tl id="Do you want to confirm this batch" var="1">
	<cfset tConfirm="#lt_text#">
	
	<cfoutput>									
	
	<script language="JavaScript">
	
		function pickticket(bat) {					
			window.open("#session.root#/Warehouse/Application/Stock/Pickticket/PickticketPrint.cfm?batchNo="+bat+"&ts="+new Date().getTime(), "_blank", "left=30, top=30, width=850, height=850, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes")			
		}	  
		
		function printbatch(batchno, template) {
			ptoken.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id="+batchno+"&ID1="+batchno+"&ID0="+template,"_blank", "left=30, top=30, width=800, height=800, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes")	
		}	
		
		function transactionobservation(traid) {
			if (confirm("Do you want to submit an observation?")) {
			    ptoken.navigate('BatchViewTransactionLineWorkflow.cfm?ajaxid='+traid,traid)	
				document.getElementById('workflow_'+traid).className = "hide"			
			}			
		}
			
		function batchdecision(action) {
		    if (action == "confirm") {
				if (confirm("#tConfirm#")) {
					ptoken.navigate('#session.root#/Warehouse/Application/Stock/Batch/setBatchDecision.cfm?action='+action+'&systemfunctionid=#url.systemfunctionid#&trigger=#url.trigger#&batchno=#url.batchNo#&stockorderid=#url.stockorderid#','iconfirm','','','POST','batchform')			
				}		 
			} else {
				if (confirm("#tCancel#")) {
					ptoken.navigate('#session.root#/Warehouse/Application/Stock/Batch/setBatchDecision.cfm?action='+action+'&systemfunctionid=#url.systemfunctionid#&trigger=#url.trigger#&batchno=#url.batchNo#&stockorderid=#url.stockorderid#','iconfirm','','','POST','batchform')			
				}	
			}	
		}
							
		function checkconfirm() {
			ptoken.navigate('BatchConfirmCheck.cfm?trigger=#url.trigger#&batchno=#url.batchNo#','iconfirm')		 		 
		}
				
		function batchrevert(action,bat) {
			if (confirm("Do you want to revert this transaction batch ?")) {		   		   
			    Prosis.busy('yes')
			    if (action == "confirm") {
				    ptoken.navigate('#session.root#/Warehouse/Application/Stock/Batch/setBatchRevert.cfm?systemfunctionid=#url.systemfunctionid#&trigger=#url.trigger#&batchno='+bat,'status')							
				} else {
				    ptoken.navigate('#session.root#/Warehouse/Application/Stock/Batch/setBatchRevert.cfm?systemfunctionid=#url.systemfunctionid#&trigger=#url.trigger#&batchno='+bat,'status')	
				}	
			}		
		}		
		
		function batchtosale(action,bat) {
		
			if (confirm("Do you want to issue a Sales transaction ?")) {	
		     Prosis.busy('yes')
			 ptoken.navigate('#session.root#/Warehouse/Application/Stock/Batch/setBatchToSale.cfm?systemfunctionid=#url.systemfunctionid#&trigger=#url.trigger#&batchno='+bat,'status')			 
		    }
		
		}
		
		function setlinestatus(id,st) {
		    _cf_loadingtexthtml='';
			ptoken.navigate('#session.root#/Warehouse/Application/Stock/Batch/setLineStatus.cfm?&transactionid='+id+'&act='+st,'status_'+id)		 	
				 		 
		}
		
		function lineassetedit(sid,id) {		
    		_cf_loadingtexthtml="";	
			ptoken.navigate('#SESSION.root#/warehouse/application/stock/batch/StockTransactionEditAsset.cfm?systemfunctionid='+sid+'&id='+id,'editbox')
			_cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy11.gif'/>";				
		}
				
		function doit(action,id) {    	
    
		if (confirm("Do you want to update this transaction ?")) {	
			_cf_loadingtexthtml="";	
	       	 ptoken.navigate('#SESSION.root#/warehouse/application/stock/Inquiry/TransactionSubmit.cfm?scope=embed&action='+action+'&drillid='+id+'&systemfunctionid=#url.systemfunctionid#','editbox','','','POST','transactionform')
			_cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy11.gif'/>";	
		}	
	  }	 
		
				
	</script>
	
</cfoutput>	

<cfset enforcelines = "0">
							
<cfquery name="Check"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     WarehouseTransaction 
		WHERE    Warehouse       = '#Batch.warehouse#'					
		AND      TransactionType = '#Batch.TransactionType#' 
</cfquery>
	
<cfif check.clearancemode gte "2">
			
	<!--- we enforce individual clearance based on the deeper level --->							
	<cfset enforcelines = "1">

</cfif>

<table width="99%" style="min-width:1000px" height="100%" align="center">

	<tr><td align="right" height="100%" valign="top">	  
	
		<table border="0" height="100%" width="100%">		
		
		<tr><td id="editbox"></td></tr>
		
		<tr><td height="100%" valign="top">
		    
			<table width="100%" height="100%">
				<tr><td style="min-height:230;padding:5px"><cfinclude template="BatchViewTransaction.cfm"></td></tr>			
			</table>
		  
		</td>
		</tr>	
				
		<cfparam name="pendingworkflow" default="0">		
								
		<cfif clearmode eq "3">
		
			<!--- not applicable for progressing buttonts as a workflow would take over the status processing --->
			
		<cfelse>
		
		<cfif pendingworkflow eq "1">					
			<cfset cl = "hide">			
		<cfelse>		
			<cfset cl = "regular">		
		</cfif>		
			
		<tr><td id="actionbox" class="<cfoutput>#cl#</cfoutput>" align="center" style="padding-left:4px;padding-right:4px">
								
			<cfif batch.actionStatus eq "0" and url.mode eq "Process">				
															
					<form method="post" name="batchform" id="batchform" style="border:0px solid silver; padding-left:5px;padding-right:5px">
											
						<table width="100%" align="center">
													
							<tr id="box1" class="hide"><td colspan="5" style="height:26;" class="labelmedium"><b><cf_tl id="Transaction verification"></td></tr>
							
							<tr id="box2"><td colspan="5"></td></tr>
						
							<tr id="box3">
							    <td colspan="5" align="left" style="padding-left:1px">	
								<textarea style="font-size:13px;padding:3px;width:99%;height:40" name="ActionMemo" class="regular"></textarea>	
							</td>
							</tr>
							
							<tr id="box4">
							<td id="box5" colspan="5" style="padding-left:0px;padding-right:11px;padding-top:3px;padding-bottom:5px;border:0px solid silver" align="left">	
												
							<cf_filelibraryN DocumentPath="StockBatch"
											 SubDirectory="#URL.BatchNo#" 
											 Filter=""
											 Presentation="all"
											 Insert="yes"
											 Remove="yes"
											 color="transparent"
											 width="100%"	
											 Loadscript="yes"				
											 border="1">	
								
							</td>
							</tr>
							
							<!--- we check how this batch in general needs to be processed --->
							
							<tr id="box6"><td height="2" colspan="5"></td></tr>
												
							<tr>
												
								<td width="20">
																														
								<cfif fullAccess eq "GRANTED" or editAccess eq "GRANTED">
																																					
								    <cfdiv id="iconfirm">
									
									    <cfquery name="Check"
											datasource="AppsMaterials" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												SELECT   *
												FROM     ItemTransaction
												WHERE    TransactionBatchNo = '#URL.BatchNo#'
												AND      ActionStatus = '0'
										</cfquery>
																										
																								
										<cfif enforcelines eq "0" or check.recordcount eq "0">	
																						   
												<cf_button onclick="batchdecision('confirm')" 
												    mode="greenlarge" 
													name="Confirm" 
													id="Confirm" 
													label="Confirm" 
													label2="transaction" 
													icon="images/selectDocument.gif">													
																				
										</cfif>
														
									</cfdiv>
								
								</cfif>
								
					    		</td>	
								
								<td align="center" style="padding-left:25px">								
																								
								<!--- validate of the transactions of the batch were already sourced --->
								
								<cfquery name="Check"
									datasource="AppsMaterials" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT  TOP 1 * 
									FROM    ItemTransaction AS I INNER JOIN
						                    ItemTransactionValuation AS V ON I.TransactionId = V.TransactionId
									WHERE   I.TransactionBatchNo = '#URL.BatchNo#'
									AND     V.TransactionId <> V.DistributionTransactionId
								</cfquery>									
																		
								<!--- added 5/12/2015 to prevent deletion if transaction is already sourced --->
								
								<cfif Check.recordcount eq "0">
																
									<cfif fullaccess eq "GRANTED" or editAccess eq "GRANTED">
																										
										<cfdiv id="icancel">
																				
											<cf_button onclick="batchdecision('deny')" 
											      mode="silverlarge" 
												  name="Cancel" 
												  id="Cancel" 
												  label="Reject" 
												  label2="transaction" 
												  icon="images/close.png">
											
										</cfdiv>
									
									</cfif>
									
								</cfif>	
								
								</td>					
								
								<td align="right" style="padding-left:20px" width="90%">							
								
									<cfif Batch.ReportTemplate neq "">
									
										<cfset vPrintoutPath = Batch.ReportTemplate>
										<cfif BatchClass.ReportTemplate neq "">
											<cfset vPrintoutPath = BatchClass.ReportTemplate>
										</cfif>
									
										<cfoutput>
										
											<cf_button onclick="printbatch('#url.batchno#','#vPrintoutPath#')" 
											       mode="silverlarge" 
												   name="Print" 
												   id="Print" 
												   value="Print" 
												   icon="images/print.png" 
												   iconheight="25px">
											
										</cfoutput>
										
									</cfif>
									
								</td>
								
							</tr>
						</table>	
					
					</form>
									
			<cfelse>
			
			<table width="100%" class="formpadding">						
							
				<tr><td colspan="3" class="labelmedium" style="font-size:16px">	
				    <cfif Batch.actionStatus eq "1"> 
					<font color="2BBD86"><cf_tl id="Confirmed by"><cfelseif Batch.actionstatus eq "9"><font color="FF0000"><cf_tl id="Denied by"></cfif>	
					<cfif Batch.actionStatus eq "1" or  Batch.actionStatus eq "9"> 			
					&nbsp;:&nbsp;#Batch.ActionOfficerFirstName# #Batch.ActionOfficerLastName# on #dateformat(Batch.ActionOfficerDate,CLIENT.DateFormatShow)# #timeformat(Batch.ActionOfficerDate,"HH:MM")#
					</cfif>
					</td>
					
					<cfif Batch.actionstatus neq "9">		
					
					<td id="iconfirm"></td>
						
						<td colspan="1" height="30" align="right">
							<cfif Batch.ReportTemplate neq "">
							
								<cfset vPrintoutPath = Batch.ReportTemplate>
								<cfif BatchClass.ReportTemplate neq "">
									<cfset vPrintoutPath = BatchClass.ReportTemplate>
								</cfif>
								
								<cfoutput>
									<input type="button" 
									 class="button10g"
									 style="width:120px" 
									 onclick="printbatch('#url.batchno#','#vPrintoutPath#')" 
									 name="Print" 
									 id="Print" 
									 value="Print">
								</cfoutput>
							</cfif>
						</td>
					
					</cfif>
					
				</tr>
				
				<cfif Batch.ActionMemo neq "">
				
					<tr><td height="5"></td></tr>											
					<tr class="line"><td class="labelit" colspan="5">#Batch.ActionMemo#</td></tr>							
									
				</cfif>
				
				<cf_FileLibraryCheck
						DocumentPath="StockBatch"
						SubDirectory="#URL.BatchNo#"
						Filter="">
				
				<cfif files gte "1">				
					
					<tr><td colspan="5" style="border-top:1px solid silver">	
										
						<cf_filelibraryN
							DocumentPath="StockBatch"
							SubDirectory="#URL.BatchNo#" 
							Filter=""
							Presentation="all"
							Insert="no"
							Remove="no"
							width="100%"	
							Loadscript="yes"				
							border="1">	
							
						</td>
					</tr>
				
				</cfif>
							
			</table>
												
			</cfif>
			
		</td>
				
		</tr>
		
		<tr><td id="process" style="padding-bottom:7px"></td></tr>
		
		</cfif>
		
		</table>	
	</td>
	</tr>		
	
		
</table>

</cfoutput>

<cf_screenbottom layout="webdialog">

<cf_actionListingScript>
<cf_dialogMaterial>
<cf_dialogLedger>
<cf_dialogAsset>
<cf_presentationScript>
<cf_listingScript>

