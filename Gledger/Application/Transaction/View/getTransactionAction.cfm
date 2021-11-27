
<cfparam name="url.action" default="view">
<cfparam name="url.actionid" default="">

<cfparam name="Transaction.ActionStatus" default="0">

<table width="100%" class="formpadding" style="navigation_table;border:1px solid silver;border-bottom:0px solid silver">

<!--- Hanno, cleanup some how it is create a double record, to be tracked --->

<cfquery name="cleanAction"
			datasource="AppsLedger"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			DELETE TransactionHeaderAction
			FROM  TransactionHeaderAction A
			WHERE        Journal = '#url.Journal#' 
			AND          JournalSerialNo = '#url.JournalSerialNo#'
			AND          ActionStatus = '1' 
			AND          ActionMode = '2' 
			AND EXISTS (SELECT   'X' AS Expr1
			            FROM     TransactionHeaderAction
			            WHERE    Journal         = A.Journal 
						AND      JournalSerialNo = A.JournalSerialNo 
						AND      ActionReference1 = A.ActionReference1 
						AND      ActionStatus = '9')
</cfquery>


 <cfif url.action eq "delete">
 
  <!--- you have the actionId to do the stuff here --->
<!--- post the tax action --->
	<cfquery name="getAction"
			datasource="AppsMaterials"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT     H.*
			FROM       Accounting.dbo.TransactionHeader H
					   INNER JOIN Accounting.dbo.TransactionHeaderAction A ON H.Journal = A.Journal AND H.JournalSerialNo=A.JournalSerialNo
			WHERE      A.ActionId = '#URL.actionId#'
			AND        A.ActionReference1 IS NOT NULL
			AND        A.ActionStatus = '1'						
	</cfquery>

	<cfif getAction.recordcount neq 0>
				
			<cfinvoke component = "Service.Process.EDI.Manager"
				method           = "SaleVoid"
				Datasource       = "AppsMaterials"
				Mission          = "#getAction.Mission#"
				Terminal		 = "TransactionView"
				Journal          = "#getAction.Journal#"
				JournalSerialNo  = "#getAction.JournalSerialNo#"					
				returnvariable	 = "stResponse">

			<cfif stResponse.Status eq "OK">
			
			    <!--- we update the action itself to cancelled --->
				
				<cfquery name="updateAction"
					datasource="AppsMaterials"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
						UPDATE Accounting.dbo.TransactionHeaderAction
						SET    ActionStatus = '9'
						WHERE  ActionId  = '#URL.ActionId#'
				</cfquery>
				
			<cfelse>
			
				<tr class="line" style="background-color:fafafa">
		   		<td class="labelmedium2" colspan="8" style="padding-left:5px">
					<cf_tl id="Please Try again">
				</td>
      	        </tr>				
				
			</cfif>
						
	</cfif>

</cfif>
	
	<cfquery name="Action" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   TOP 10
			         R.Code, 
			         R.Description, 
					 T.Journal,
					 T.JournalSerialNo,
					 T.ActionId,
					 T.ActionMode,
					 T.ActionStatus,
					 T.ActionReference1,
					 T.ActionReference2,
					 T.ActionReference3,
					 T.ActionReference4,
					 T.ActionDate,
					 T.OfficerUserId,
					 T.Created
			FROM     TransactionHeaderAction T, Ref_Action R
			WHERE    T.ActionCode      = R.Code
			AND      T.Journal         = '#url.Journal#'
			AND      T.JournalSerialNo = '#url.JournalSerialNo#'		
			AND      R.Code IN ('Invoice','CreditNote')
			and      ActionStatus IN ('1','5','9')  <!--- opening = 4 is not recorded --->
			ORDER BY T.Created DESC, T.ActionDate DESC, R.Code
	 </cfquery>
	 
	 <cfquery name="Last" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   TOP 1 *
				FROM     TransactionHeaderAction T
				WHERE    T.Journal         = '#url.Journal#'
				AND      T.JournalSerialNo = '#url.JournalSerialNo#'		
				AND      T.ActionCode IN ('Invoice','CreditNote')
				and      ActionStatus IN ('1','5','9')  
				AND      T.ActionMode = '2' <!--- electronic --->
				ORDER BY T.Created DESC, T.ActionDate DESC
	  </cfquery>
	  
	  <cfquery name="get" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     TransactionHeader
				WHERE    Journal         = '#url.Journal#'
				AND      JournalSerialNo = '#url.JournalSerialNo#'						
       </cfquery>
  
      <!--- header is pending and actionstatus <> '1' --->
	  
	   <cfif Last.actionStatus neq "1">
	   <!---
      <cfif Transaction.ActionStatus eq "0" and action.actionStatus neq "1">
	  --->
	  
	       <tr class="line" style="background-color:f1f1f1">
			   <td colspan="10">
				   <table>
				    <tr>
				  	<td class="labelmedium2" style="padding-left:5px">
					
					    <cfif get.TransactionSource eq "SalesSeries" and Action.recordcount eq "0">
						    <!--- we go the POS mode for the sales series, unlike accounting and workorder series  ---> 
						    <a href="javascript:NewTaxReceivable('','pos')"><cf_tl id="Issue Electronic Invoice"></a>
						<cfelse>
						    <a href="javascript:NewTaxReceivable('','finance')"><cf_tl id="Issue Electronic Invoice"></a>
						</cfif>
						
					</td>		
					
					<cfif get.TransactionSource eq "SalesSeries"> 
				    <td style="padding-left:10px;padding-right:10px">|</td>		  
			  		<td class="labelmedium2" colspan="6">				  		
			   			<a href="javascript:PrintReceivable()">
				    	<cf_tl id="Invoice">
						</a>				   		
					</td>			
					</cfif>
				   </tr>	
				   </table>
			   </td>
		   </tr>
		 
	 <cfelse>
	 
 	     <tr class="line" style="background-color:fafafa">
		 	<td class="labelmedium2" colspan="11" style="padding-left:5px"><cf_tl id="Invoice Log"></td>
	     </tr>

	 </cfif>

	 <cfoutput query="Action" group="Code">
  	  
		 <cfoutput>	 
		 
		 <cfif actionstatus eq "9">		  
		      <cfset st = "color:red;text-decoration-line: line-through;background-color:##FFFF0050;border-left:1px solid silver;padding-left:3px;padding-right:3px">
		 <cfelse>
			 <cfset st = "background-color:##FFFF0050;border-left:1px solid silver;padding-left:3px;padding-right:3px">
		 </cfif>	 
		
		 <tr class="labelmedium linedotted navigation_row fixlengthlist">	   
		 
		    <cfif currentrow eq "1">
			
			<!--- is better to connect this to the transaction itself
			<cfif Transaction.ActionStatus eq "0" and currentrow eq "1">
			--->
			
			     <!--- transaction is open, not cleared yet --->
			
				<td align="center" style="width:20px;background-color:f4f4f4;border-right:1px solid silver">
			
				<cfif actionMode eq "2" and actionStatus eq "1">
				
					<cf_img icon="delete"
				    	tooltip="cancel action" 
						onclick="_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('#session.root#/Gledger/Application/Transaction/View/getTransactionAction.cfm?action=delete&actionid=#actionid#&journal=#journal#&journalserialNo=#journalserialno#','invoiceactionbox')">
														
				</cfif>	
			
				</td>	
				
			<cfelse>
			
				<td></td>	
							
			</cfif>
						
			<td align="center" style="padding-left:3px;padding-right:3px"><cfif actionstatus neq "5">#dateformat(ActionDate,"YYYY/MM")#</cfif></td>		
			<td align="center" style="#st#;<cfif ActionStatus eq '9'>background-color:##FF808050<cfelseif actionstatus eq '5'>background-color:##e1e1e150</cfif>">#ActionStatus# <cfif ActionStatus eq "1">Issued<cfelseif ActionStatus eq "5">Voided<cfelse>Fail</cfif></td>
			<td align="center" style="#st#">			
			<cfif actionMode eq "2" and (actionstatus eq "1" or actionstatus eq '9')>	
				<a href="javascript:PrintTaxReceivable('#actionid#','finance')">#ActionReference1#</a>
			<cfelse>			
				#ActionReference1#
			</cfif>
			</td>
			
			<td style="#st#;width:20px">
			<cfif actionStatus eq "1">
			<cfif get.TransactionSource eq "SalesSeries">
				<cf_img tooltip="reprint" icon="print" onclick="javascript:RePrintReceivable('#get.TransactionSourceId#')">
			</cfif>
			</cfif>
			</td>
				
			<td align="center" style="#st#">#ActionReference2#</td>
			<td align="center" style="#st#">#ActionReference3#</td>
			<td align="center" style="#st#">#ActionReference4#</td>
			<td align="center" style="<cfif ActionMode eq '2'>background-color:yellow</cfif>">#ActionMode# <cfif ActionMode eq "2">Electronic<cfelse>Manual</cfif></td>
			<td align="center" style="padding-left:3px;padding-right:3px">#dateformat(Created,CLIENT.DateFormatShow)# #timeformat(Created,"HH:MM")#</td>	
			
			
		  </tr>
		  
			  <cf_filelibraryCheck
					DocumentPath="LedgerAction"
					SubDirectory="#Journal#\#JournalSerialNo#" 
					Filter="#code#_#actionid#">	
							
			  <cfif files gte "1">
					
				  <tr>	
				    <td></td>
					<td colspan="8" width="80%">
							 			 
						<cf_filelibraryN
								DocumentPath="LedgerAction"
								SubDirectory="#Journal#\#JournalSerialNo#" 
								Filter="#code#_#ActionId#"
								Insert="no"
								color="ffffef"
								Remove="no"
								reload="true">		 				 
					
					</td>
				 
				 </tr>
			 
			 </cfif>
			 		 
		 </cfoutput>
	 
	 </cfoutput>
	 
 </table>	 
 
 <script>
  Prosis.busy('no')
 </script>
 
 <cfset ajaxOnLoad("doHighlight")>