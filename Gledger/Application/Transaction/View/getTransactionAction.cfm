
<cfparam name="url.action" default="view">
<cfparam name="url.actionid" default="">

<cfparam name="Transaction.ActionStatus" default="0">

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
			
				<cfquery name="updateAction"
						datasource="AppsMaterials"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
						UPDATE Accounting.dbo.TransactionHeaderAction
						SET    ActionStatus = '9'
						WHERE  ActionId  = '#URL.ActionId#'
				</cfquery>
				
			<cfelse>
			
				Error. Try again.
				
			</cfif>
						
	</cfif>

</cfif>

<cfquery name="Action" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   TOP 3
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
				 T.Created
		FROM     TransactionHeaderAction T, Ref_Action R
		WHERE    T.ActionCode      = R.Code
		AND      T.Journal         = '#url.Journal#'
		AND      T.JournalSerialNo = '#url.JournalSerialNo#'
		AND      R.Code = 'Invoice'
		and      ActionStatus IN ('1','9')
		ORDER BY R.Code, ActionDate DESC
 </cfquery>
  
 <table width="100%" class="formpadding" style="border-left:1px solid silver;border-right:1px solid silver">
   
	 <cfoutput query="Action" group="Code">
  	  
		 <cfoutput>	 
		 
		 <cfif actionstatus eq "9">		  
		      <cfset st = "color:red;text-decoration-line: line-through;background-color:ffffcf;border-left:1px solid silver;padding-left:3px;padding-right:3px">
		 <cfelse>
			 <cfset st = "background-color:ffffcf;border-left:1px solid silver;padding-left:3px;padding-right:3px">
		 </cfif>	 
		
		 <tr class="labelmedium2 linedotted">	   
		 
			<cfif Transaction.ActionStatus eq "0">
			
			     <!--- transaction is open, not cleared yet --->
			
				<td align="center" style="width:20px;background-color:f4f4f4;border-right:1px solid silver">
			
				<cfif actionMode eq "2" and actionStatus eq "1">
				
					<cf_img icon="delete"
				    	tooltip="cancel action" 
						onclick="_cf_loadingtexthtml='';Prosis.busy('yes');ptoken.navigate('#session.root#/Gledger/Application/Transaction/View/getTransactionAction.cfm?action=delete&actionid=#actionid#&journal=#journal#&journalserialNo=#journalserialno#','invoiceactionbox')">
														
				</cfif>	
			
				</td>	
							
			</cfif>
			
			<td align="center" width="140" style="padding-left:3px;padding-right:3px">#dateformat(ActionDate,CLIENT.DateFormatShow)# [#timeformat(Created,"HH:MM")#]</td>		
			<td align="center" style="#st#;<cfif ActionStatus eq '9'>background-color:FF8080</cfif>">#ActionStatus# <cfif ActionStatus eq "1">Success<cfelse>Fail</cfif></td>
			<td align="center" style="#st#;<cfif ActionMode eq '2'>background-color:yellow</cfif>">#ActionMode# <cfif ActionMode eq "2">Electronic<cfelse>Manual</cfif></td>
			<td align="center" style="#st#">			
			<cfif currentrow eq "1" and actionMode eq "2">	
				<a href="javascript:PrintTaxReceivable('')">#ActionReference1#</a>
			<cfelse>
				#ActionReference1#
			</cfif>
			</td>
			<td align="center" style="#st#">#ActionReference2#</td>
			<td align="center" style="#st#">#ActionReference3#</td>
			<td align="center" style="#st#">#ActionReference4#</td>
			
		  </tr>
		  
			  <cf_filelibraryCheck
					DocumentPath="LedgerAction"
					SubDirectory="#Journal#\#JournalSerialNo#" 
					Filter="#code#_#actionid#">	
							
			  <cfif files gte "1">
					
				  <tr>	
				    <td></td>
					<td colspan="7" width="80%">
							 			 
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