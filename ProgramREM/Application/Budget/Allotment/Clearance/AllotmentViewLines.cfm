
<cfquery name="Transactions" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT     *,
		           (SELECT ISNULL(OrgUnitNameShort,OrgUnitCode) 
				    FROM   Organization.dbo.Organization 
					WHERE  OrgUnit = D.OrgUnit) as OrgUnitName,
					
				   (SELECT Status
				    FROM   ProgramAllotmentAction
					WHERE  Actionid = D.ActionId) as ActionStatus
						
	    FROM       ProgramAllotmentDetail D
		WHERE      ProgramCode = '#URL.Program#'	   
	 	AND        EditionId   = '#url.edition#'
		AND        Period      = '#url.period#'
		AND        ObjectCode  = '#Code#'		
		AND        Fund        = '#fd#'
		AND        Status NOT IN ('P','9') <!--- 16/11/2013 exclude NOT released requirements and cancelled records --->		
		AND        ObjectCode IN (SELECT ObjectCode
								  FROM   ProgramAllotmentDetail
								  WHERE  ProgramCode = '#URL.Program#'	   
								    AND  EditionId   = '#url.edition#'
									AND  Period      = '#url.period#'
									AND  Fund        = '#fd#'
									AND  ObjectCode  = '#Code#'	
									<!--- AND  Status      = '0'	--->
								 ) 	
		AND        Amount <> '0'  
		ORDER BY Created
</cfquery>

<cfif Transactions.recordcount gt "0">
	
	<!--- show the transaction lines for this fund/oe --->
	
	<cfoutput query="Transactions">	
	
		<cfset traid = replaceNoCase(transactionid,"-","","ALL")> 
		
		<cfif Status eq "0">
		   <cfif transactionType eq "Standard">
			   <cfset cl = "B8FED6">
		   <cfelse>
			   <cfset cl = "ffffcf">
		   </cfif>
		<cfelseif status eq '9'>
		    <cfset cl = "ffcccc">
		<cfelse>		
			<cfset cl = "transparent">	
	    </cfif>
		
		<cfquery name="getSupportTransaction" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *	    
				FROM    ProgramAllotmentDetail D	
				WHERE   ProgramCode     = '#url.Program#'	   
			 	AND     EditionId       = '#url.edition#'
				AND     Period          = '#url.period#'
				AND     Fund            = '#fd#'
				AND     Status          = '0'		
				AND     TransactionType = 'Support'						
		</cfquery>
						
		<cfif support eq "1" and getSupportTransaction.recordcount gt "0">		
			<cfset lk = "ColdFusion.navigate('setSupportCost.cfm?transactionid=#transactionid#&fund=#fd#&orgunit=#orgunit#','#fd#_supportcost_#orgunit#','','','POST','clear')">
		<cfelse>
			<cfset lk = "ColdFusion.navigate('setAllocationSummary.cfm?transactionid=#transactionid#','amountaction','','','POST','clear')">	
		</cfif>
										
		<tr class="navigation_row line">
		
		    <cfif Status eq "0">
			
			<td align="center" style="padding-left:30px">
					  
			  <cfif Parameter.EnableDonor eq "1" and Edit.BudgetEntryMode eq "1">		
			  
			  	  <!--- contribution driven approval --->	  	 
			  
			  	  <cfif transactiontype eq "standard">
				  
				  	 <table width="100%" height="100%"
				       cellspacing="0"
				       cellpadding="0"
				       bgcolor="e5e5e5"					   
				       style="width:305;height:23;border-right:1px solid gray;border-top:1px solid silver;border-bottom:1px solid silver;border-left:1px solid gray;">
					   
						<tr>
					 
					      <td style="padding-left:4px">					  
						     <input type="button" name="Donor" onclick="donordrill('#transactionid#')" value="Allocation" class="button10s" style="height:17px;width:70">					  
					      </td>
					  					     					  				  
						  <td align="right">		
						  						  						  
							  <table cellspacing="0" cellpadding="0">
							 
							  <tr>
							  <td style="padding-left:4px" id="clear#transactionid#" class="hide">	
							      
								  <table cellspacing="0" cellpadding="0">
								  
									  <tr>		
									  <TD></TD>						  
									  <td style="padding-right:4px">														   		  					 
									  <input type="radio" onclick="#lk#" name="Decision_#traid#" id="Decision_#transactionid#_0" value="0">
									  </td>
									  
									  <td style="padding-right:4px" id="clear#transactionid#" class="labelit">#vPending#</td>
									  <td style="padding-right:4px">	
											   		  					 
									  	<input type="radio"  
										      onclick = "#lk#"
										      name    = "Decision_#traid#" 
											  id      = "Decision_#transactionid#_1" 
											  value   = "1">
									  </td>
									  <td style="padding-right:4px" id="clear#transactionid#" class="labelit">#vClear#</td>
										
									  </tr>
									  
								  </table>      
								  				  
							  </td>		  
							  
							  <td style="padding-right:4px"> 
							  
							     <input type="radio"  
								     onclick="#lk#;document.getElementById('submitbox').className='regular'" 
									 name   = "Decision_#traid#" 
									 id     = "Decision_#transactionid#_9" 
									 value  = "9"> 
									 
							  </td>									 
							  <td style="padding-right:8px" class="labelit">#vRevoke#</td>		  							  							  
							  </tr>
						  
						  </table>
					  
					    </td>
						
					  </tr>
					  </table>
								  
				  <cfelse>
				  
				  		 <!--- support is calculated  --->
																  
				  		 <input type="hidden"  name="Decision_#traid#" id="Decision_#transactionid#_1" value="0"> 
				  
				  </cfif>
			  
			  <cfelse>
			  
			      <!--- standard approval --->
			  
			 	  <cfif transactiontype eq "standard">
				  
				  	 <table width="100%" height="100%"
				       cellspacing="0"
				       cellpadding="0"				       
				       style="padding:0px;border-left:1px solid gray;">
					   
					  <tr>
			  
						  <td style="padding-left:4px">	      			  		   		  			 
							  <input type="radio" class="radiol"  onclick="#lk#" name="Decision_#traid#" id="Decision_#transactionid#_1" value="1">							 
							  </td>
						  <td class="labelit" style="padding-right:4px"><font color="008000">#vClear#</font></td>
						
						  <td style="padding-right:4px">
							  <input type="radio" class="radiol" onclick="#lk#" name="Decision_#traid#" id="Decision_#transactionid#_9" value="9">							 
							  </td>
						  <td class="labelit" style="padding-right:4px"><font color="red">#vRevoke#</font></td>		
					  
				      </tr>
					  </table>
			  
					  
				 <cfelse>
				  
				  		 <input type="hidden" name="Decision_#traid#" id="Decision_#transactionid#_1" value="1">	  
				  
				  </cfif>
			 		  
			  </cfif>
			  		
			<cfelse>
			
				<td width="70" height="15" align="center">  
			
		    </cfif>
			
		</td>
		
		<td bgcolor="#cl#" style="padding-left:10px">
		
			<table cellspacing="0" cellpadding="0">
				<tr><td style="padding-right:3px">
				<cfif Parameter.EnableDonor eq "1" and Edit.BudgetEntryMode eq "1">		
					<cfif status eq "1">
						<cf_img icon="expand" toggle="yes" onclick="donordetail('donor_#transactionid#')">		
					</cfif>
				</cfif>
				</td>
				<td class="labelit">#OfficerLastName#</td>
				</tr>
			</table>
			
		</td>
		<td bgcolor="#cl#" class="labelit">	
		<cfif ActionStatus eq "3" or ActionStatus eq "">
		<font color="008040">
		<cfelseif ActionStatus neq "">
		<font color="red">
		</cfif>	
		#DateFormat(TransactionDate, CLIENT.DateFormatShow)#<cfif currentrow eq "1"><cf_space spaces="30"></cfif>		
		</td>
		
		<td class="labelit" bgcolor="#cl#">
		<cfif status eq "0">
		
			<table>
			<tr>
			<td class="labelit" id="orgunit_#transactionid#">#orgunitname#</td>
			<td style="padding-left:3px;padding-top:0px">
			<cfif transactiontype eq "standard">
				<cf_img icon="edit" navigation="Yes" onClick="selectorgN('#edit.mission#','','#transactionid#','setthisorgunit','orgunit_#transactionid#','1','modal')">
			</cfif>
			</td>		
			</tr>
			</table>
		
			<!--- remove me
			<cf_img icon="edit" navigation="Yes" onClick="selectorgN('orgunit_#transactionid#','#transactionid#','','','','','','#edit.mission#')">			
			--->
			
		<cfelse>
		
			#orgunitname#
			
		</cfif>
		
		</td>		
				
		<td colspan="2" class="labelit" bgcolor="#cl#" align="right" >#NumberFormat(amountbase,"___,___.__")# <cfif transactiontype eq "Standard">(#NumberFormat(exchangerate,".____")#)</cfif></td>	
				
		<td class="labelit" align="right" style="padding-right:5px" bgcolor="#cl#">#Currency#</td>
		
		<cfif transactiontype eq "Standard" or Status neq "0">
		
			<td style="padding-right:30px" class="labelit" bgcolor="#cl#" align="right"><cfif transactiontype eq "Standard">#NumberFormat(amount,",.__")#</cfif></td>
		
		<cfelse>			
			
			<!--- to be updated as part of selected approvals --->
			<!--- remove this as it is confusing, we need to set the contributions not the amout itself to be changed --->
							
			<cfquery name="getSupportTransaction" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  * 
					FROM    ProgramAllotmentDetail			
					WHERE   ProgramCode     = '#url.Program#'	   
				 	AND     EditionId       = '#url.edition#'
					AND     Period          = '#url.period#'
					AND     Fund            = '#fd#'
					AND     Status          = '0'		
					AND     TransactionType = 'Support'						
			</cfquery>
									
			<!--- clear the contributions --->
				
			<cfquery name="setInitialSupport" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    DELETE 
					FROM   ProgramAllotmentDetailContribution
					WHERE  TransactionId = '#getSupportTransaction.TransactionId#'						
			</cfquery>	
					
			<!--- box that contains the support costs for the selected items through contributions --->	
			<td bgcolor="#cl#" class="labelit" align="right" style="padding-right:30px" id="#fd#_supportcost_#orgunit#">			
				  #NumberFormat(0,",.__")#			
			</td>
			
		</cfif>
		
		</tr>	
						
		<cfif Parameter.EnableDonor eq "1" and Edit.BudgetEntryMode eq "1">		
		
			<!--- if donor is enabled we shown donor information here as for its funding --->
						
			<cfif Status neq "9">
			
				<cfif status eq "0">
					 <cfset cl = "regular">
				<cfelse>
					 <cfset cl = "hide"> 
				</cfif>
				
				<tr>		 
				    <td></td>   
					<td colspan="7" style="padding-right:40px">
																	
						<!--- we load the parent as ajax, do NOT !! make this a cfinclude --->						
						
						<cfdiv bind="url:DonorAllocationViewLines.cfm?transactionid=#transactionid#&datamode=standard" 
						 id="donor_#transactionid#" class="#cl#">							
						
					</td>
				</tr>					
			
			</cfif>
		
		</cfif>	
			
	</cfoutput>

</cfif>