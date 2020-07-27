
<cfparam name="url.objectId" default="">
<cfparam name="url.actioncode" default="">
<cfparam name="url.actionid" default="">

<cfparam name="url.detailedit" default="yes">
<cfparam name="url.mode" default="regular">
<cfparam name="url.box" default="costcontainer">
<cfparam name="url.sel" default="">
<cfparam name="url.val" default="">
<cfparam name="url.se2" default="">
<cfparam name="url.va2" default="">
<cfparam name="client.filter" default="">

<cfif url.objectid eq "">
	<cfabort>
</cfif>
		  
<cfif url.sel neq "">
	<cfset client.filter = 	"AND C.#url.sel# = '#URL.val#'">
</cfif>	  

<cfif url.se2 neq "">
	<cfset client.filter = 	"#client.filter# AND C.#url.se2# = '#URL.va2#'">
</cfif>	  
		  
<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM       OrganizationObject
	WHERE      ObjectId = '#URL.ObjectId#' OR ObjectKeyValue4 = '#URL.ObjectId#' 
</cfquery>

<cfparam name="url.wf" default="0">

<cfif Object.Recordcount gte "1">

	<cfquery name="CurrentAction" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 * 
		FROM   OrganizationObjectAction
		WHERE  ObjectId    = '#ObjectId#'
		AND    ActionStatus = '0'	
		ORDER BY ActionFlowOrder
	</cfquery>
				
	<cfset objectId = Object.ObjectId>
			
	<cfquery name="Listing" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     C.*, 
		           U.FirstName            AS OwnerFirstName, 
				   U.LastName             AS OwnerLastName, 
				   GL.GLAccount           AS PayrollGLAccount, 
				   GLcost.Journal         AS GLCostJournal,
				   GLcost.JournalSerialNo AS GLCostJournalSerialNo, 
                   GLsale.Journal         AS GLSaleJournal,
				   GLsale.JournalSerialNo AS GLSaleJournalSerialNo 
        FROM       OrganizationObjectActionCost C LEFT OUTER JOIN
                   Accounting.dbo.TransactionLine GLsale ON C.ObjectCostId = GLsale.ReferenceId AND GLsale.ReferenceIdParam = 'Sales' LEFT OUTER JOIN
                   System.dbo.UserNames U ON C.OwnerAccount = U.Account LEFT OUTER JOIN
                   Accounting.dbo.TransactionLine GLcost ON C.ObjectCostId = GLcost.ReferenceId AND GLcost.ReferenceIdParam = 'Cost' LEFT OUTER JOIN
                   Employee.dbo.PersonGLedger GL ON U.PersonNo = GL.PersonNo AND GL.Area = 'Payroll'		
			WHERE  C.ObjectId = '#ObjectId#'	
			<cfif url.wf neq "0">
				<cfif client.filter neq "">
					#preservesingleQuotes(client.filter)#  
				</cfif> 
			</cfif>
			<cfif url.actionid neq "">
			AND C.Actionid = '#URL.actionid#'	
			AND  C.DocumentType = '#url.mode#'	
			<cfelseif url.mode eq "cost" or url.mode eq "work">
			AND  C.ActionCode = '#URL.ActionCode#'
			AND  C.DocumentType = '#url.mode#'		
			<cfelseif url.mode eq "Actor" and SESSION.isAdministrator eq "No">
			AND  U.Account = '#SESSION.acc#'
			</cfif>
			ORDER BY C.DocumentType DESC, DocumentCurrency, DocumentDate 
			
	</cfquery>	
	
			
	<cfif url.mode eq "regular">
	  <cfset col = 13>
	<cfelse>
	  <cfset col = 11>  
	</cfif>
			
	<table width="98%" cellspacing="0" cellpadding="0">
	
		<cfif url.mode eq "regular">
		
		<form name="formcost" method="post">
		
		</cfif>
		
		<cfif url.detailedit eq "Yes">
	  						
			<cfif url.mode eq "Actor">
			
			    <tr class="line"><td height="22" align="center" colspan="<cfoutput>#col#</cfoutput>">
				
					<table width="100%" class="navigation_table"><tr>
					
						<td width="170"><!--- <b>Expenses</b> ---></td>			
						<td align="right" width="100%">
						<table cellspacing="0" cellpadding="0" align="right">
						<tr><td>
					
						<cfmenu name="costmenu#objectid#"
					          font="verdana"
					          fontsize="14"
							  menustyle="height:10"
					          type="horizontal"		
							  bgcolor="transparent"	          
					          selecteditemcolor="6688AA"
					          selectedfontcolor="FFFFFF">					  							  					  	  	    
								
							 <cf_tl id="Expense Entry" var="1">
							 <cfset tExpense = "#Lt_text#">							
								
							 <cfmenuitem 
								     display="#tExpense#"
								     name="Cost#Object.ObjectId#"
								     href="javascript:costentry('#Object.ObjectId#','','cost','#url.mode#','#url.box#','#url.actioncode#')"
								     image="#SESSION.root#/Images/calculate.gif"/>
	
							 <cf_tl id="Work Entry" var="1">
							 <cfset tWork = "#Lt_text#">
										
							 <cfmenuitem 
								    display="#tWork#"
								    name="Work#Object.ObjectId#"
								    href="javascript:costentry('#Object.ObjectId#','','work','#url.mode#','#url.box#','#url.actioncode#')"
								    image="#SESSION.root#/Images/activity.gif"/>
														
						</cfmenu>	
						</td></tr>
						</table>
						</td></tr>
					 </table>	
					 </td>
				 </tr>	 
								 
			 <cfset cl = "top4n">
			 
			<!--- workflow embedding ---> 
			 
			<cfelseif url.mode eq "work"> 
			
				<cfoutput>			   
				<tr class="line">					
					<td width="100%" colspan="#col#" height="22" class="labelit">
				    <a href="javascript:costentry('#Object.ObjectId#','','work','#url.mode#','#url.box#','#url.actioncode#')"><cf_tl id="Add Work Record"></a>
				    </td>
				</tr>				
				</cfoutput> 
				
			<!--- workflow embedding ---> 	 
				 
			<cfelseif url.mode eq "cost"> 
			
				<cfoutput>
			   
				<tr class="line">
					<td width="100%" colspan="#col#" height="22" class="labelit">
				 	<a href="javascript:costentry('#Object.ObjectId#','','cost','#url.mode#','#url.box#','#url.actioncode#')"><cf_tl id="Add Expense"></a>
					</td>
				</tr>
				
				</cfoutput>
				
			<cfelse>
			
				<cfset cl = "regular">	
			
			</cfif>	
					
		</cfif>	 			
		
		<cfif Listing.recordcount gt "0">
				
			<tr>
			<td height="19" width="25"></td>
			<td width="25"></td>
			<td width="25"></td>
			<td></td>
			<td class="labelit"><cf_tl id="Date"></td>		
			<td class="labelit"><cf_tl id="Description"></td>
			<td class="labelit"><cf_tl id="Name"></td>		
			<td class="labelit" width="30"><cf_tl id="Curr."></td>
			<td class="labelit" align="right" width="140"><cf_tl id="Qty"></td>
			<cfif url.mode eq "Actor" or url.mode eq "Regular" or url.mode eq "Work" or url.mode eq "Cost">
			<td class="labelit" align="right"><cf_tl id="Cost"></b></td>		
			</cfif>
			<cfif url.mode eq "Regular">
			<td class="labelit" width="10"></td>
			</cfif>
			<cfif url.mode neq "Actor" and url.mode eq "Work" and url.mode eq "Cost">
			<td class="labelit" align="right"><cf_tl id="Sales"></td>	
			</cfif>
			<cfif url.mode eq "Regular">
			<td width="10"></td>
			</cfif>
			</tr>
			<tr><td height="1" colspan="<cfoutput>#col#</cfoutput>" class="linedotted"></td></tr>	
		
		<cfelse>
		
			<cfif url.detailedit eq "Yes"> 
				<tr><td colspan="<cfoutput>#col#</cfoutput>" align="center"><b>--</b></td></tr>
			</cfif>
		
		</cfif>
		
		<cfset row = 0>
		<cfset pst = 0>
								
	    <cfoutput query="Listing" group="DocumentType">		
		
			<cfoutput group="DocumentCurrency">		
			
				<cfset tot = 0>
				<cfset cst = 0>
				
					<cfoutput> 
					
							<cfset row = row+1>				
							
							<cfdirectory action="LIST"
				             directory="#SESSION.rootDocumentPath#\#object.entitycode#\#objectcostid#"
				             name="attach"
				             type="file"
				             listinfo="name">					 
														
							<tr id="r#row#" class="navigation_row">
																				
							<td align="center" width="30" id="coststatus#currentrow#">
							
							<cfif GLCostJournal eq "" 
							    and GLSaleJournal eq "" 
								and url.mode eq "Regular">
								
								  <cfset url.row = currentrow>
								  <cfinclude template="CostStatus.cfm">
								 
							</cfif>
								
							</td>
															
							<TD height="22" width="20" align="center">
							
								<!--- 7/7/2009 provision to allow for changes if the recording action was before the current wf action --->
			
								<cfquery name="RecordingAction" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT * 
									FROM   OrganizationObjectAction
									WHERE  ObjectId    = '#ObjectId#'
									AND    ActionId    = '#ActionId#'
								</cfquery>
															 
								 <cfif url.detailedit is "yes"
								       and ((ActionStatus eq "0" and GLCostJournal eq "" and GLSaleJournal eq "") or CurrentAction.ActionFlowOrder gte RecordingAction.ActionFlowOrder)
									   and (url.mode eq "Regular" or url.mode eq "Actor" or url.mode eq "Cost" or url.mode eq "Work")>	
									   
									    <cf_img icon="edit" onClick="costentry('#objectid#','#objectcostid#','#DocumentType#','#url.mode#','#url.box#','#url.actioncode#')">	
										  
								 </cfif> 	  
											
							</TD>
							
							<td width="20">
							
							 <cfif DocumentType eq "cost">
							 	<img src="#SESSION.root#/Images/calculate.gif" height="12" width"12"
							   	 alt="cost" border="0" align="absmiddle">
							 <cfelse>
								 <img src="#SESSION.root#/Images/activity.gif" height="12" width"12" 
								 alt="work" border="0" align="absmiddle">
							 </cfif>
							
							</td>				
							<td width="20">							
								<cfif attach.recordcount gte "1">
									<img src="#SESSION.root#/Images/paperclip2.gif" alt="attachment" border="0" align="absmiddle">						
								</cfif>									
							</td>
							<td class="labelit" width="100">#dateformat(DocumentDate,CLIENT.DateFormatShow)#</td>	
							<td class="labelit" width="25%">#Description#</td>
							<td class="labelit" width="15%">
								<table width="100%" cellspacing="0" cellpadding="0">
								<tr>
								<cfif PayrollGLAccount eq "">
									<td class="labelit"><font color="FF0000">#OwnerFirstName# #OwnerLastName#</font></td>
									<td>
									<img src="#SESSION.root#/Images/warning.gif" heght="11" width="11" alt="Payroll Posting Account is not available" border="0" align="absmiddle">
									</td>	
								<cfelse>
								<td class="labelit">#OwnerFirstName# #OwnerLastName#</td>					
								</cfif>		
												
								</tr>
								</table>
							</td>		
							<td class="labelit">#DocumentCurrency# </td>					
							<td width="140" align="right" class="labelit">
							
								<cfset a = abs(documentquantity)>
							
								<cfset h = int(a)>
								<cfset m = round((a - h)*60)>
								
								<cfif documentQuantity lt 0><font color="FF0000"></cfif>#h#<cfif DocumentType eq "work">
								<cfif m neq "0">:#m#</cfif>h @ #numberFormat(documentrate,"__.__")#</cfif>		
								
								
							</td>	
							
							<cfif url.mode eq "Actor" 
							   or url.mode eq "Regular" 
							   or url.mode eq "cost" 
							   or url.mode eq "work">
							<td width="10%" class="labelit" align="right">
							
							<cfif documentQuantity lt 0><font color="FF0000">(</cfif>
							#numberformat(DocumentAmount,"__,__.__")#
							<cfif documentQuantity lt 0><font color="FF0000">)</cfif>
							
							</td>	
							</cfif>
							
							<cfif url.mode eq "Regular">
							
							    <cfif actionStatus eq "0">
								  <cfset cl = "hide">
								<cfelse>
								  <cfset cl = "regular">  
								</cfif>
								
								<td class="labelit" width="30" align="center">
								
								<div id="check#currentrow#" class="#cl#">
												
								<cfif GLCostJournal eq "" and PayrollGLAccount neq "">		
														
										<cfset pst = 1>
										<input type="checkbox" name="costselected" id="costselected" value="'#objectcostid#'">						
									
								<cfelseif GLCostJournal neq "">
												 				 
								 	<button name="gl" id="gl" type="button"
									  class="button3" 
									  onclick="ShowTransaction('#GLCostJournal#','#GLCostJournalSerialNo#','1')">
								
									     <img src="#SESSION.root#/Images/paid.gif" 
									   	 alt="invoiced" 
										 border="0"
										 align="absmiddle">
									 
									 </button>		
									 	
								</cfif>	
								
								</div>
								
								</td>
							
							</cfif>
							
							<cfif url.mode neq "Actor" and url.mode neq "Cost" and url.mode neq "Work">
								<td width="10%" align="right" class="labelit">					
								<cfif documentQuantity lt 0><font color="FF0000">(</cfif>
								#numberformat(InvoiceAmount,"__,__.__")#
								<cfif documentQuantity lt 0><font color="FF0000">)</cfif>
								</td>
							</cfif>	
							
							<cfif url.mode eq "Regular">
							
								<td width="30" align="center" class="labelit">
												
								<cfif GLSaleJournal eq "" and PayrollGLAccount neq "">		
								
								<!--- disables as this goes automatically 
									<cfif InvoiceAmount gte "0">
										<cfset pst = 1>
										<input type="checkbox" name="saleselected" value="'#objectcostid#'">
									</cfif>
									--->
									
								<cfelseif GLSaleJournal neq "">
														
									 <img src="#SESSION.root#/Images/paid.gif" 
									   	 alt="invoiced" 
										 border="0"
										 style="cursor: pointer;"
										 onclick="ShowTransaction('#GLSaleJournal#','#GLSaleJournalSerialNo#','1')"
										 align="absmiddle">
									 						 	
								</cfif>	
								
								</td>
							
							</cfif>
											
							</tr>				
										
							<cfif url.mode neq "Regular">					
								
								<tr><td colspan="3"></td><td colspan="#col-3#">			
								
								<cf_filelibraryN
									DocumentPath="#Object.EntityCode#"
									SubDirectory="#objectcostid#" 
									Filter=""	
									color="F4FBFD"			
									Width="100%"						
									inputsize = "340"
									loadscript="No"
									insert="no"
									Remove="no">	
								
								</td>
								</tr>			
											
							</cfif>			
							
							<cfif currentrow neq recordcount>
								<tr><td height="1" colspan="#col#" class="linedotted"></td></tr>		
							</cfif>
							
							<cfif InvoiceAmount neq "">
							   <cfset tot = tot+InvoiceAmount>				
							</cfif>
							
							<cfif DocumentAmount neq "">
							   <cfset cst = cst+DocumentAmount>				
							</cfif>
							
					</cfoutput>
									  
				<cfquery name="Doc" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT     *
					FROM       Ref_EntityDocument
					WHERE      EntityCode = '#Object.EntityCode#' 
					AND        (DocumentMode = '#DocumentType#')
				</cfquery>
						
				<tr class="navigation_row">
				   <td></td>
				   <cfif url.mode neq "Regular">
				   <td class="labelit" colspan="#col-3#" align="right">#Doc.DocumentDescription# #DocumentCurrency#</td>
				   <cfelse>
				   <td class="labelit" colspan="#col-5#" align="right">#Doc.DocumentDescription# #DocumentCurrency#</td>		 
				   </cfif>
				   
				   <cfif url.mode eq "Actor" or url.mode eq "Cost" or url.mode eq "Work" or url.mode eq "Regular">
				   <td class="labelit" bgcolor="ffffdf" align="right"><b>#numberformat(cst,"__,__.__")#</b></td>
				   </cfif>
				   <cfif url.mode eq "Regular">
				   <td class="labelit" bgcolor="ffffdf" align="right" colspan="2"><b>#numberformat(tot,"__,__.__")#</b></td>
				   </cfif>
				</tr>
																				
			</cfoutput>
		
		</cfoutput>
		
		<cfoutput>
						
		<cfif pst eq "1">
			<tr><td height="1" colspan="#col#" class="linedotted"></td></tr>		
			<tr>
			<td height="32" colspan="#col#" align="center">
			<input type="button" class="button10g" value="Post" onclick="postledger()">
			</td>
			</tr>	
			<tr><td height="1" colspan="#col#" class="linedotted"></td></tr>
		</cfif>
		</cfoutput>
		
		
		<cfoutput>
			<input type="hidden" name="rows" id="rows"    value="0">
			<input type="hidden" name="id" id="id"      value="#Listing.ObjectCostId#">
			<input type="hidden" name="total" id="total"  value="#row#">
		</cfoutput>
		
		<cfif url.mode eq "regular">
		</form>	
		</cfif>
		
	</table>
	
</cfif>

<cfset ajaxOnLoad("doHighlight")>
