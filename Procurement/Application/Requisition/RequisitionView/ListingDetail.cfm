
<cfparam name="cat" default="">

<cfquery name="Parameter"
	datasource="AppsPurchase"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT     *
		FROM  Ref_ParameterMission      
		WHERE Mission = '#Mission#'					  
</cfquery>

<cfoutput>

	<cfquery name="Items"
	datasource="AppsPurchase"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    ItemMaster      
		WHERE   Code = '#ItemMaster#'					  
	</cfquery>
	
    <!--- current neq previous and --->				
	
	<cfif URL.ID neq "WHS">
					    
		<cfif reference eq "" and currentrow eq "1">
		
 		<tr><td style="padding-left:4px" colspan="10" class="labellarge"><font color="black"><b><cf_tl id="Pending Submission"></td></tr>
		
		<cfelseif url.sort eq "Reference">
						
			<cfif Reference eq Previous or Reference eq "">
		
			<cfelse>
												
			<tr class="line">
						
				<td colspan="8" align="left">
				
				    <table cellspacing="0" cellpadding="0">
					
					<tr class="labelmedium">
						<td style="min-width:150px;height:40px;font-weight:300">								
						<a title="view requisition" href="javascript:RequisitionView('#URL.Mission#','#URL.Period#','#Reference#')">
						
						<cfsilent>
							<cfloop index="itm" list="#Reference#" delimiters="-">#itm#</cfloop>
						</cfsilent>
											
						<cfset ref = replaceNoCase(reference,itm,"<font size='5'>#itm#</font>")> 						
						#ref#</a>
												
						</td>
						
						<cfif URL.ID neq "WHS">
												  
						  <td style="padding-left:4px;padding-top:0px" class="labelit">
						  
						  <cf_img icon="print"  onClick="mail2('print','#Reference#')" >
						  							   
						  </td>
						  
						  <td style="padding-left:4px">
						   
						   <img src="#SESSION.root#/Images/mail.gif"
						        alt="eMail requisition"
						        border="0"
						        align="absmiddle"
						        style="cursor: pointer;"		
							    height="15" width="20"					 
						        onClick="mail2('mail','#Reference#')">
							 
							</td>						  
						   
						</cfif>   
					
					    </td>
																								
						<td style="padding-left:4px" width="76%">#RequisitionPurpose#</td>
											
					</tr>					
									
				</table>
				
				</td>
				
				<cfquery name="Subtotal" dbtype="query">
					 SELECT sum(RequestAmountBase) as Amount
					 FROM   Requisition
					 <cfif URL.Lay eq "Reference">
					 WHERE  Reference   = '#Reference#' 
					 <cfelse>
					 WHERE  ItemMaster  = '#ItemMaster#'
					 </cfif>
				</cfquery>			
				
				<td colspan="1" align="right"  class="labelmedium">#numberformat(Subtotal.Amount,",.__")#</b></td>
				<td></td>
				
			</tr>	
			
			</cfif>
			
			<cfset previous=Reference>				
			
		<cfelseif url.sort eq "ActionStatus">
				
			<cfif ActionStatus eq Previous or Reference eq "">
		
			<cfelse>					
										
				<tr class="line">
				
					<td colspan="8" align="left" height="22" class="labelmedium">					   														
						#StatusDescription# (#ActionStatus#)											
					</td>
					
					<cfquery name="Subtotal" dbtype="query">
						 SELECT sum(RequestAmountBase) as Amount
						 FROM   Requisition					
						 WHERE  ActionStatus = '#ActionStatus#' 					
					</cfquery>			
					
					<td colspan="1" align="right" style="padding-right:4px" class="labelmedium">#numberformat(Subtotal.Amount,",.__")#</td>
					<td></td>
					
				</tr>	
				
				<cfset previous=ActionStatus>				
			
			</cfif>				
							
								
		</cfif>					
						
	</cfif>
	
	<cfparam name="pt" default="0">
		
		<cfif RequestDue neq "" and RequestDue lt now() and actionStatus lte "2k" and Parameter.EnableDueDate eq "1">
		  <cfset color = "E7F5FA">
		<cfelse>
		  <cfset color = "white"> 
		</cfif>  
		
		<tr class="navigation_row"><td colspan="10" style="height:4px"></td></tr>						    				
		<tr class="navigation_row_child labelmedium" style="height:18px" bgcolor="#color#" id="box#RequisitionNo#">	
						
		<td colspan="2" width="30" align="left">
	
			<table cellspacing="0" cellpadding="0">
			
			<tr class="labelmedium" style="height:18px">
			
			<td width="3"><cf_space spaces="1"></td>
									
			<td style="padding-left:3px;height:18;padding-top:1px">
							
				<cfif PurchaseNo neq "" and PurchaseStatus neq "9">
				
					<cfquery name="Receipt"
					datasource="AppsPurchase"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
					SELECT     *
					FROM   PurchaseLineReceipt      
					WHERE  RequisitionNo = '#RequisitionNo#'			  
					AND    ActionStatus != '9'
					</cfquery>		
								
					<cfif Receipt.recordcount gt "0">
												 		
						<img src="#SESSION.root#/Images/arrowright.gif" alt="View receipts" 
							id="hist#currentRow#Exp" border="0" class="regular" 
							align="absmiddle" style="cursor: pointer;" 
							onClick="more('hist#currentRow#','#RequisitionNo#','show','history')">
									
						<img src="#SESSION.root#/Images/arrowdown.gif" 
							id="hist#currentRow#Min" alt="Hide receipts" border="0" 
							align="absmiddle" class="hide" style="cursor: pointer;" 
							onClick="more('hist#currentRow#','#RequisitionNo#','hide','history')">					
							
							<cfset pt = "1">
											
				     </cfif>			
					   
				</cfif>	   
							
				<cfif pt eq "0">		  
				
					<cf_img icon="edit" navigation="Yes" onClick="ProcReqEdit('#RequisitionNo#','dialog')">
					 
			  	</cfif>
			
			</td>				
			<td style="padding-left:4px;padding-right:8px;padding-top:3px">			
				<cf_img icon="log" id="log#currentRow#Exp" onClick="requisitionlog('#RequisitionNo#','#RequisitionNo#')">					
			<td>
					
			</tr>
			</table>
	  		
		</td>
		
		<cfset des = Items.Description>  
		
		<td>
			<table>
			<tr class="labelmedium" style="height:18px">
			
			<cfif url.id eq "STA">
			   <!---
				<td width="80">
				<a href="javascript:RequisitionView('#URL.Mission#','#URL.Period#','#reference#')">#Reference#<a></td>
				--->
			</cfif>
			
			<cfparam name="CaseNo" default="">
			
			<!--- disabled by hanno as it shows under reference already 
			<cfif caseNo neq "">
				<td class="labelmedium" width="80" style="padding-right:3px"><cf_space spaces="20">#CaseNo#</td>
			<cfelse>
			   
			</cfif>
			--->
						
			<cfif PurchaseNo neq "" and PurchaseStatus neq "9">
						
				<cfif Receipt.recordcount gt "0">	
					<td style="cursor:pointer" onclick="more('hist#currentRow#','#RequisitionNo#','hide','history')">#des#</td>
				<cfelse>									
					<td style="cursor:pointer" onclick="showreqdetail('#requisitionno#_detail','#requisitionno#','#mission#','#itemmaster#','#requesttype#','#warehouseitemno#','listing')"><u>#des#</font></td>
				</cfif>					
							
			<cfelse>				
				<td style="cursor:pointer" onclick="showreqdetail('#requisitionno#_detail','#requisitionno#','#mission#','#itemmaster#','#requesttype#','#warehouseitemno#','listing')"><u>#des#</td>		
			</cfif>
			
			<cfif PersonNo neq "">
										
				<td colspan="2" style="padding-left:5px">
							
					<cfquery name="Person" 
					 datasource="AppsEmployee" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT *
						 FROM   Person
						 WHERE  PersonNo = '#PersonNo#'					
					</cfquery>			
					
					<a href="javascript:EditPerson('#PersonNo#')">: #Person.FirstName# #Person.LastName#</a>
				
				</td>				
									
		    </cfif>
												
			</tr>
						
			</table>
		</td>
		
		<td>#DateFormat(RequestDate, CLIENT.DateFormatShow)#&nbsp;</td>
		<td>
		
		<cfif URL.ID eq "STA" and URL.ID1 eq "2k">
		
			<cfquery name="FlowSetting" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
					SELECT   S.*
					FROM     RequisitionLine R INNER JOIN
			                 ItemMaster M ON R.ItemMaster = M.Code INNER JOIN
			                 Ref_ParameterMissionEntryClass S ON R.Mission = S.Mission AND R.Period = S.Period AND M.EntryClass = S.EntryClass
					WHERE    R.RequisitionNo = '#Requisition.RequisitionNo#'
			</cfquery>	
		
		   <!---
			<cfif url.role eq "ProcManager" and FlowSetting.BuyerDefault eq "">
			--->
			
			<cfif url.role eq "ProcManager">
			
				<cfif buyer neq "">
				
					<cfquery name="Buyers" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
					      SELECT DISTINCT RequisitionNo,ActorUserId,ActorLastName,LastName
					      FROM   RequisitionLineActor A LEFT OUTER JOIN System.dbo.UserNames U ON A.ActorUserId = U.Account
						  WHERE  A.RequisitionNo = '#RequisitionNo#'						    
					      AND    A.Role = 'ProcBuyer'						  
					</cfquery>	
					
					<cfloop query="Buyers">
					
						<table>
						
							<tr>
							<td id="buyer#requisitionno#_#currentrow#" class="labelmedium">		
							
								<cfif url.role eq "ProcManager">	
								
									<table cellspacing="0" cellpadding="0">
									<tr><td>
										<cf_img icon="delete" onclick="ColdFusion.navigate('setBuyerRevert.cfm?id=#requisitionno#&actoruserid=#actoruserid#','buyer#requisitionno#_#currentrow#')" tooltip="Reset buyer assignment"> 	
										</td>
										<td class="labelmedium" style="padding-left:3px"><cfif ActorLastName neq "">#ActorLastName#<cfelse>#LastName#</cfif></td>
									 </tr>
									 </table>
								   
								<cfelse>
								
									<cfif ActorLastName neq "">#ActorLastName#<cfelse>#LastName#</cfif>
								
								</cfif>	   
									   
							</td>	   
							</tr>
						
						</table>   
					
					</cfloop>
				
				</cfif>
								
			</cfif>
		
		<cfelse>
		
			#OfficerLastName#
			
		</cfif>
		
		</TD>
		
		<td>#left(RequestType,1)#</td>
		<td>
		
		<cfif PurchaseNo gte "a" and PurchaseStatus neq "9">
		   <a href="javascript:ProcPOEdit('#Purchaseno#','view')">#PurchaseNo#</a>		   
		<cfelse>
		   <cfif URL.ID eq "STA" and URL.ID1 neq "2k">		
		 
		   		<cfif url.lay eq "Due">
				
				#dateformat(RequestDue, CLIENT.DateFormatShow)#<a>
				
				<cfelse>
				
				<cfif CaseNo neq "">#CaseNo#<cfelse>
				     	<cfif requestPriority eq ""><cfelse>#RequestPriority#</cfif>				
				</cfif>	
				
				</cfif>
		   			   
		   <cfelseif URL.ID eq "STA" and URL.ID1 eq "2k">	
		   
			   	<cfquery name="Job"
					datasource="AppsPurchase"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
					SELECT J.*
					FROM   Job J
					WHERE  J.JobNo = '#JobNo#'					  
				</cfquery>
					
			    <a href="javascript:job('#JobNo#')"><font color="2F97FF">
			    	<cfif Job.CaseNo neq "">#Job.CaseNo#<cfelse>#JobNo#</cfif>
					</font>
				</a>
				
		   <cfelse>
			   #StatusDescription#
		   </cfif>		   
		</cfif>
		</td>
		<td align="center">
		<cfif warehouseItemNo neq "" and WarehouseUoM neq "">
		<a href="javascript:itemopen('#warehouseitemno#')">#RequestQuantity#</a>
		<cfelse>
		#RequestQuantity#
		</cfif>
		</td>				
		<td align="right"><font color="gray">
		
		<cfparam name="subtotal.amount" default="#RequestAmountBase#">
		
		<cfif reference neq "">
			<cfparam name="subtotal.amount" default="#RequestAmountBase#">
			<cfif RequestAmountBase neq subtotal.amount>
			   #numberformat(RequestAmountBase,",.__")#
			</cfif>
		<cfelse>
		   #numberformat(RequestAmountBase,",.__")# 
		</cfif> 

		</td>		
		
		<td id="note#RequisitionNo#" width="30" style="padding-right:4px" align="right">
		
			<cf_annotationshow entity="ProcReq" 
			                   keyvalue1="#requisitionno#" 
							   docbox="note#RequisitionNo#">
		
		</td>
						
		</TR>
		
		<!---		
		<cfif orgunit neq orgunitimplement>
		--->
		
			<tr class="navigation_row_child" style="height:18px">
			    <td></td>
			    <td colspan="9">
				
				<cfparam name="OrgUnitImplement" default="0">
				
				<cfquery name="Org"
					datasource="AppsOrganization"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
					SELECT *
					FROM   Organization
					WHERE  OrgUnit = '#OrgUnit#'					  
				</cfquery>
				
				<cfquery name="check"
						datasource="AppsOrganization"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
						SELECT *
						FROM   Organization
						WHERE  OrgUnit = '#OrgUnitImplement#'					  
					</cfquery>
								
				<cfif check.recordcount eq "0">
												
					<cfquery name="Line" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    UPDATE RequisitionLine
						SET    OrgUnitImplement = OrgUnit
						WHERE  RequisitionNo = '#requisitionno#'	
					</cfquery>
					
					<cfquery name="Imp"
					datasource="AppsOrganization"
					username="#SESSION.login#"
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Organization
						WHERE  OrgUnit = '#OrgUnit#'					  
					</cfquery>
				
				<cfelse>
				
					<cfquery name="Imp"
						datasource="AppsOrganization"
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
						SELECT *
						FROM   Organization
						WHERE  OrgUnit = '#OrgUnitImplement#'					  
					</cfquery>
				
				</cfif>
				
				<table width="100%">
					<tr class="labelmedium" style="height:18px">
					<td width="30%">#Org.OrgUnitName#</td>
					<td width="30%"><cfif Imp.OrgUnitName eq ""><font color="FF0000">UNDEFINED</font><cfelse>#imp.OrgUnitName#</cfif></td>
					</tr>
				</table>
				</td>
			</tr>
		
		<!---
		</cfif>
		--->
		
		<cfif ActionStatus neq "0" and CustomForm eq "1" and CustomDialog eq "Contract" and IndPosition eq "0">
				
			<tr class="navigation_row_child" style="height:18px">
			    <td colspan="10">
				<table cellspacing="0" cellpadding="0">
					<tr style="height:18px" class="labelmedium">
					<td width="10%"><img src="#SESSION.root#/images/join.gif" alt="" border="0"></td>
					<td width="90%" bgcolor="ffffaf" height="14">&nbsp;<a href="javascript:ProcReqEdit('#RequisitionNo#','dialog')">Pending association to a position.</a></font></td>
					</tr>
				</table>
				</td>
			</tr>
				
		</cfif>	
		
		<cfif countedtopics gte 1>
				<tr class="navigation_row_child labelmedium" style="border-top:1px dotted silver;height:18px">
				 <td></td>				
				  <td colspan="9">				   				 
					<cf_getRequisitionTopic RequisitionNo="#RequisitionNo#" TopicsPerRow="3">				
				  </td>
				</tr>
		</cfif> 	 
				
		<tr id="#RequisitionNo#" class="#URL.view# navigation_row_child">
				
			<td></td>
			<td align="center" colspan="9">
						
			<table width="95%" border="0" align="center" class="show" cellspacing="0" cellpadding="0">
	
				<cfquery name="funding"
				datasource="AppsPurchase"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
				SELECT  L.*, 
				        P.ProgramName AS Description, 
						O.CodeDisplay,
						O.Description AS ObjectDescription
				FROM    RequisitionLineFunding L LEFT OUTER JOIN
                        Program.dbo.Ref_Object O ON L.ObjectCode = O.Code LEFT OUTER JOIN
                        Program.dbo.Program P ON L.ProgramCode = P.ProgramCode				
				WHERE RequisitionNo = '#RequisitionNo#'		  
				</cfquery>		
				
				<cfset Per = "#Period#">										
				
				<cfloop query="funding">
				   <tr bgcolor="DBF9E1" class="labelmedium">	
				      <td height="20">&nbsp;</td>			     
				      <td width="6%">#ProgramPeriod#</td> 
					  <td width="6%">#Fund#</td>
					  
					  <cfquery name="Program" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    P.*, Pe.Reference
							FROM      Program P, ProgramPeriod Pe
							WHERE     P.ProgramCode = '#ProgramCode#'	
							AND       P.ProgramCode = Pe.ProgramCode
							AND       Pe.Period = '#Per#'
	    			</cfquery>
					  
				      <td width="20%">
					   <a href="javascript:ViewProgram('#ProgramCode#','#Per#','#Program.ProgramClass#')">
				         <cfif Program.reference neq "">#Program.Reference#<cfelse>#ProgramCode#</cfif>&nbsp;#Description#
					   </a>					  
					  </td>					  
		 			  <td width="40%">#CodeDisplay# #ObjectDescription# <font size="1"><cfif objectcode neq codedisplay>[#ObjectCode#]</cfif></font></td>
		 			  <td width="6%">#Percentage*100#%</td>
					  <td width="11%">#DateFormat(Created, CLIENT.DateFormatShow)#</td>
					  <td width="20%"></td>
				   </tr>
				</cfloop>
							
			</table>
			</td>
			
		</tr>
		
		<cfif parameter.RequisitionListingMode eq "1" and url.id neq "Org">
		  	<cfset cl = "regular">
		<cfelse>
		    <cfset cl = "hide">
		</cfif>		
														
		<tr id="#RequisitionNo#_detail" class="#cl# navigation_row_child labelmedium" style="height:18px" bgcolor="#color#">
			<td></td>		
			<td colspan="9">#RequestDescription#</td>
		</tr>
		
		<tr id="bdet#RequisitionNo#_detail" class="hide navigation_row_child" bgcolor="#color#">
			<td></td>		
			<td class="labelit" colspan="9" id="det#RequisitionNo#_detail"></td>
		</tr>
		
		<tr id="blog#requisitionNo#" class="hide">
		    <td></td>
			<td colspan="8">
			<cfdiv id="log#RequisitionNo#" class="ignore">
		</td></tr>
							
		<cfif PurchaseNo neq "" and PurchaseStatus neq "9">			
		
			<tr class="hide" id="hist#currentRow#">		
			    <td></td>   
			   	<td colspan="8" style="padding:4px" id="ihist#currentRow#"></td>
	   	    </tr>		
		
		</cfif>
				
		<tr style="height:1px" class="navigation_row_child line"><td colspan="10"></td></tr>
		
</cfoutput>			