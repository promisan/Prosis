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

<cfparam name="url.action" default="view">
<cfparam name="url.actionid" default="">

<cfparam name="Transaction.ActionStatus" default="0">

<table width="100%" class="formpadding" style="navigation_table;border:1px solid silver;border-bottom:0px solid silver">

<!--- Hanno, cleanup somehow it is create a double record, to be tracked --->

<cfquery name="cleanAction"
	datasource="AppsLedger"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		DELETE TransactionHeaderAction
		FROM  TransactionHeaderAction A
		WHERE    Journal = '#url.Journal#' 
		AND      JournalSerialNo = '#url.JournalSerialNo#'
		AND      ActionStatus = '1' 
		AND      ActionMode = '2' 
		AND EXISTS (SELECT   'X' AS Expr1
		            FROM     TransactionHeaderAction
		            WHERE    Journal          = A.Journal 
					AND      JournalSerialNo  = A.JournalSerialNo 
					AND      ActionReference1  = A.ActionReference1 
					AND      ActionStatus      = '9')
</cfquery>

<cfif url.action eq "save">

	<cfquery name="setAction"
	datasource="AppsLedger"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		UPDATE  TransactionHeaderAction
		SET     ActionReference1 = '#url.val1#',
		        ActionReference2 = '#url.val2#',
         		ActionReference3 = '#url.val3#',
				OfficerUserId    = '#session.acc#',
				OfficerLastName  = '#session.last#',
				OfficerFirstName = '#session.first#',
				Created          = getDate(),
				ActionReference5 = 'Manual'
		WHERE   ActionId = '#url.actionid#'		
    </cfquery>

<cfelseif url.action eq "delete">
 
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
 
	 
 <cfif Last.actionStatus neq "1" or Last.recordcount eq "0">
 
   <!--- <cfif Transaction.ActionStatus eq "0" and action.actionStatus neq "1"> --->
	  
	  <cfif get.ActionStatus eq "9" or get.recordstatus eq "9">
	  
	     <!--- do not show --->
		 
	  <cfelseif get.ActionStatus eq "0">
	  
	  	<!--- workflow controlled we wait until the step is completed --->	 
			
	  <cfelse> 
	  
		   <tr style="background-color:f1f1f1;height:32px">
			   <td colspan="10" style="padding-left:5px">
				   <table>
				    <tr>
					
																									
					<cfif Action.ActionStatus neq "1">
				  	
						<td class="labelmedium2" style="height:20px;font-size:16px">				  
						
						    <cfif get.TransactionSource eq "SalesSeries" and Action.recordcount eq "0">
							    <!--- we go the POS mode for the sales series, unlike accounting and workorder series  ---> 
							    <a href="javascript:NewTaxReceivable('','pos')"><cf_tl id="Issue Electronic Invoice"></a>
							<cfelse>
							    <a href="javascript:NewTaxReceivable('','finance')"><cf_tl id="Issue Electronic Invoice"></a>
							</cfif>
							
							<cfoutput>
							<span style="font-size:14px">(#dateformat(get.documentdate,client.dateformatshow)#)</span>
							</cfoutput>
								
						</td>	
						
						<td style="padding-left:10px;padding-right:10px">|</td>	
					
					</cfif>		
					
					<cfif get.TransactionSource eq "SalesSeries"> 
				      
				  		<td class="labelmedium2" style="height:20px;font-size:16px" colspan="6">				  		
				   			<a href="javascript:PrintReceivable()"><cf_tl id="Invoice"></a>				   		
						</td>			
					
					</cfif>
					
					
					
				   </tr>	
				   </table>
			   </td>
		   </tr>
	   
	   </cfif>
		 
	 <cfelse>
	 
 	     <tr class="line" style="background-color:BFFFBF;height:20px">
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
		
		 <tr class="labelmedium2 <cfif currentrow neq recordcount>linedotted</cfif> navigation_row fixlengthlist">	   
						
			<td align="center" style="padding-left:3px;padding-right:3px"><cfif actionstatus neq "5">#dateformat(ActionDate,"dd-mm-yyyy")#</cfif></td>		
			<td align="center" style="#st#;<cfif ActionStatus eq '9'>background-color:##FF808050<cfelseif actionstatus eq '5'>background-color:##e1e1e150</cfif>">#ActionStatus# <cfif ActionStatus eq "1">Issued<cfelseif ActionStatus eq "5">Voided<cfelse>Fail</cfif></td>
			<td align="center" style="#st#">			
			<cfif actionMode eq "2" and (actionstatus eq "1" or actionstatus eq '9')>	
				<a href="javascript:PrintTaxReceivable('#actionid#','finance')">#ActionReference1#</a>
			<cfelse>		
			    <cfif url.action eq "edit" and actionid eq url.actionId>	
				<input type="text" 
				   id="ActionReference1" name="ActionReference1" value="#ActionReference1#" 
				   style="width:98%;text-align:center" class="regularxl">
				<cfelse>
				   #ActionReference1#
				</cfif>
			</cfif>
			</td>
			
			<td style="#st#;width:20px">
			
				<cfif actionStatus eq "1">
					<cfif get.TransactionSource eq "SalesSeries">
						<cf_img tooltip="reprint" icon="print" onclick="javascript:RePrintReceivable('#get.TransactionSourceId#')">
					</cfif>
				</cfif>
				
			</td>
				
			<td align="center" style="#st#">
			
			  <cfif url.action eq "edit" and actionid eq url.actionId>	
				<input type="text" 
				   id="ActionReference2" name="ActionReference2" value="#ActionReference2#" 
				   style="width:98%;text-align:center" class="regularxl">
				<cfelse>
				   #ActionReference2#
				</cfif>
			
			
			</td>
			<td align="center" style="#st#">
			
			  <cfif url.action eq "edit" and actionid eq url.actionId>	
				<input type="text" 
				   id="ActionReference3" name="ActionReference3" value="#ActionReference3#" 
				   style="width:98%;text-align:center" class="regularxl">
				<cfelse>
				   #ActionReference3#
				</cfif>
			</td>
			<td align="center" style="#st#">#ActionReference4#</td>
			<td align="center" style="<cfif ActionMode eq '2'>background-color:yellow</cfif>">#ActionMode# <cfif ActionMode eq "2">Electronic<cfelse>Manual</cfif></td>			
			<td align="right" style="padding-right:3px"> 
			   #dateformat(Created,CLIENT.DateFormatShow)# #timeformat(Created,"HH:MM")#
			</td>
			
			
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
				
				<cfelseif actionStatus eq "1" and url.action neq "edit">
				
				<cf_img icon="edit"
				    	tooltip="Amend information" 
						onclick="_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('#session.root#/Gledger/Application/Transaction/View/getTransactionAction.cfm?action=edit&actionid=#actionid#&journal=#journal#&journalserialNo=#journalserialno#','invoiceactionbox')">
						
				<cfelseif url.action eq "edit" and actionid eq url.actionId>							
					 
					  <cf_tl id="Save" var="1">
					  <input type="button" class="button10g" style="width:80px" name="save" value="#lt_text#" 
					    onclick="_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('#session.root#/Gledger/Application/Transaction/View/getTransactionAction.cfm?action=save&actionid=#actionid#&val1='+document.getElementById('ActionReference1').value+'&val2='+document.getElementById('ActionReference2').value+'&val3='+document.getElementById('ActionReference3').value+'&journal=#journal#&journalserialNo=#journalserialno#','invoiceactionbox')">				
					  
														
				</cfif>	
			
				</td>	
				
			<cfelse>
			
				<td></td>	
							
			</cfif>						
			
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