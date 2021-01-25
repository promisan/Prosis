	
<cfparam name="URL.mission"             default="CMP"> 	
<cfparam name="URL.journal"             default="20002"> 	
<cfparam name="URL.TransactionType"     default="Standard"> 	
<cfparam name="URL.accountPeriod"       default=""> 
<cfparam name="URL.transactiondate"     default=""> 
<cfparam name="URL.transactioncategory" default=""> 
<cfparam name="URL.parentlineid"        default=""> 
<cfparam name="URL.parenttransactionid" default=""> 

<cfparam name="URL.entryreference"      default=""> 
<cfparam name="URL.entryreferencename"  default=""> 
<cfparam name="URL.entryglaccount"      default=""> 
<cfparam name="URL.serialno"            default=""> 
<cfparam name="URL.journalserialno"     default=""> 

<cfparam name="URL.warehouse"           default=""> 
<cfparam name="URL.itemno"              default=""> 
<cfparam name="URL.itemuom"             default=""> 
<cfparam name="URL.itemquantity"        default=""> 
<cfparam name="URL.Source"        		default="">

<cfset presetGLAccount = ""> 

<cfif url.source eq "ReceiptSeries">

 <cfquery name="GLAccount" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM  Ref_ParameterMission
     WHERE Mission = '#url.mission#'
	 AND   ReceiptGLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
 </cfquery>		
 
 <cfif GLAccount.recordcount eq "1">
     <cfset presetGLAccount = GLAccount.ReceiptGLAccount>  
	 <cfset entryglaccount    = presetGLAccount>
 </cfif>
 
<cfelse>

	<cfset entryglaccount = url.entryglaccount> 
 
</cfif>

<cfquery name="Period"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Period
	WHERE  AccountPeriod = '#URL.AccountPeriod#' 	
</cfquery>	

<!--- Query returning search results --->
<cfquery name="Journ"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT J.Currency, 
	       C.ExchangeRate, 
		   J.TransactionCategory,
		   J.SystemJournal,
		   J.SpeedType
	FROM   Journal J, Currency C
	WHERE  Journal = '#URL.Journal#' 
	AND    J.Currency = C.Currency
</cfquery>	

<cfquery name="Mandate"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM Ref_Mandate
	WHERE Mission = '#url.mission#'
	ORDER BY MandateDefault DESC
</cfquery>

<cfquery name="CostCenter"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     JournalOrgUnit J, Organization.dbo.Organization O
	WHERE    Journal   = '#URL.Journal#'
	AND      J.OrgUnit = O.OrgUnit
	AND      O.Mission = '#URL.Mission#'
	AND      O.MandateNo  = '#Mandate.MandateNo#' 
	ORDER BY HierarchyCode
</cfquery>		

<cfquery name="Acc"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_Account
	WHERE  GLAccount = '#entryglaccount#' 
</cfquery>		

<cfparam name="URL.entrygldescription"  default="#Acc.Description#">
<cfparam name="URL.entryDebitCredit"    default="#Acc.Accounttype#">
<cfparam name="URL.currency"            default="#journ.Currency#"> 
<cfparam name="URL.entryamount"         default=""> 
<cfparam name="URL.taxcode"             default=""> 
<cfparam name="URL.memo"                default=""> 
<cfparam name="URL.orgunit1"            default=""> 
<cfparam name="URL.programcode1"        default=""> 
<cfparam name="URL.programcode2"        default=""> 
<cfparam name="URL.contributionlineid"  default=""> 
<cfparam name="URL.fund1"               default=""> 
<cfparam name="URL.object1"             default=""> 

<cfif URL.entryDebitCredit eq "">
  <cfset url.entrydebitcredit = "Debit">
</cfif>

<cfoutput query="Journ">
   <cfset TraCat = TransactionCategory>
   <cfset SysJou = SystemJournal>
</cfoutput>

<!--- Query returning search results --->
<cfquery name="TransactionType"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT TransactionType
	FROM   Ref_TransactionType
	WHERE  TransactionCategory = '#TraCat#'
	AND    Operational = 1
</cfquery>	

<!--- Query returning search results --->
<cfquery name="Tax"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_Tax
</cfquery>	

<cfquery name="SpeedType"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_Speedtype
	WHERE  Speedtype = '#journ.speedtype#'
</cfquery>	

<cfif Speedtype.recordcount eq "0">

		<cfset costcenterMode       = 1>
		<cfset externalprogramMode  = 0>
		<cfset taxcodeMode          = 1>
		<cfset taxcodeDefault       = "00">
		<cfset accountParentMode    = "">

<cfelse>
		
		<cfset costcenterMode       = speedtype.costcenter>
		<cfset externalprogrammode  = speedtype.externalProgram>
		<cfset taxcodeMode          = speedtype.taxcodeMode>
		<cfset taxcodeDefault       = speedtype.taxcode>
		
		<cfquery name="Parent"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM   Ref_SpeedtypeParent
			WHERE  Speedtype = '#journ.speedtype#'
		</cfquery>		
		
		<cfset accountparentMode = "#ValueList(Parent.AccountParent,'|')#">
		
</cfif>
  
<table width="100%" align="center">

<tr class="hide"><td id="processmanual"></td></tr>

<tr><td style="min-width:900px">
       
	<table>
	
		<tr><td>
			
		  <table width="100%" class="formpadding formspacing">
		  
	         <TR> 
	          <TD class="labelmedium2" style="min-width:190px;max-width:190px"><cf_tl id="Transaction">:</TD>
	          <td colspan="3" align="left" valign="top">	
			  
			  <table><tr class="labelmedium2">
			  	
			   <td>		 			 			  	  	  		  
			   <select name="entrydebitcredit" class="regularxxl enterastab" id="entrydebitcredit">
	            	<option value="Debit" <cfif URL.entrydebitcredit eq "Debit">selected</cfif>><cf_tl id="Debit"></option>
	          		<option value="Credit" <cfif URL.entrydebitcredit eq "Credit">selected</cfif>><cf_tl id="Credit"></option>
	           </select>
			   </td>
			   
			   <td style="padding-left:4px">
			   	  
			   <select name="transactiontype" id="transactiontype" class="regularxxl enterastab" onchange="tratoggle(this.value)">
			   	 <cfoutput query="TransactionType">
	        		<option value="#lcase(TransactionType)#" <cfif URL.TransactionType is TransactionType>selected</cfif>>#TransactionType#</option>
	         	 </cfoutput>
		       </select>
			   
			   </td>
			   
			    <cfoutput>
				  <TD class="labelmedium" style="padding-left:6px;padding-right:4px"><cf_tl id="Note"></TD>
		          <td align="left">
				  <input type="text"   id="memo"            name="memo"    class="regularxxl enterastab" value="#URL.memo#" style="width:100%" maxlength="80">
				  <input type="hidden" id="serialno"        name="serialno"                     value="#URL.serialno#">
				  <input type="hidden" id="journalserialno" name="journalserialno"              value="#URL.journalserialno#">
				  <input type="hidden" id="parentlineid"    name="parentlineid"                 value="#URL.parentlineid#">
				  <input type="hidden" id="parenttransactionid"    name="parenttransactionid"   value="#URL.parenttransactionid#">
				  </td>		
			  </cfoutput>
			   
			   <!--- hidden after discussion for SAT, maybe paramrter later --->
			   <cfoutput> <input type="hidden" name="transactioncategory" id="transactioncategory" value="#TraCat#" size="16" readonly></cfoutput>
			   
			   </tr></table>
			  				
			  </td>
			  
			   
	        </tr>			
			
			
			
	        <tr name="glaccountline" id="glaccountline" class="regular">	
			
			<td class="labelmedium2">
			
				<table style="width:100%">
				<tr>
				  <td class="labelmedium2"><cf_tl id="Account">:</td>				 		
				</tr>
				</table>
						
			</td>
	        
			 <td align="left">	
					  
			   <cfoutput>	
			   
			    <cfif presetGLAccount eq "">
				
				   <table>
				   <tr>
				   
				    <td align="center" style="padding-right:5px;border:1px solid silver">	
				 
				         <cfoutput>				   
					  				   				   	  
				  		 <img src="#SESSION.root#/Images/search.png" name="img3" 
							  onMouseOver="document.img3.src='#SESSION.root#/Images/search1.png'" 
							  onMouseOut="document.img3.src='#SESSION.root#/Images/search.png'"
							  style="padding-left:5px;cursor: pointer" width="25" height="25" align="absmiddle" 
							  onClick="selectaccountgl('#URL.mission#','parent','#accountparentMode#','#url.journal#','applyaccount');">
			  			
						</cfoutput>
								  
				  </td>		
				  
				  <td style="border:1px solid silver">	
				  
					    <table>
						<tr>
					   												
						<cfquery name="getGL" 
							datasource="AppsLedger" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT *
								FROM   Ref_Account
								WHERE  GLAccount = '#entryglaccount#'
						</cfquery>
				  		
						<td><input type="text"   name="entrygldescription" id="entrygldescription" value="#URL.entrygldescription#"  class="regularxxl enterastab" style="border:0px;width:400px;background-color:f1f1f1" readonly ></td>	
						<td style="padding-left:1px;border-left:1px solid silver">
							<input type="text"   name="entrygllabel"       id="entrygllabel"       value="#getGL.AccountLabel#"      class="regularxxl enterastab" readonly style="border:0px;text-align: left;background-color:f1f1f1">
							<input type="hidden" name="entryglaccount"     id="entryglaccount"     value="#entryglaccount#"          class="regularxxl enterastab" readonly>
						
						</td>
						
						</tr>
						</table>
					
					</td>
					
					
				   </tr>
				   
				   </table>
			   
			   <cfelse>
			   
				   <cfquery name="getGLAccount"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
						FROM   Ref_Account
						WHERE  GLAccount = '#PresetGLAccount#'
					</cfquery>		
				   
				   <table>
					   <tr>						
						<td><input type="text"   name="entrygldescription" id="entrygldescription" value="#getGLAccount.description#"   class="regularxxl enterastab" size="60" readonly style="background-color:f1f1f1"></td>						
						<td style="padding-left:2px"><input type="text"   name="entryglaccount"     id="entryglaccount"     value="#presetGLAccount#"            class="regularxxl enterastab" size="6"  readonly style="background-color:f1f1f1"></td>
						<cfif getGLAccount.accountLabel neq presetGLAccount and getGLAccount.accountLabel neq "">
						<td style="padding-left:2px"><input type="text"   name="entrygllabel"       id="entrygllabel"       value="#getGLAccount.accountLabel#"  class="regularxxl enterastab" size="11" readonly style="background-color:f1f1f1"></td>					  						
						</cfif>
								  					    
					   </tr>				   
				   </table>			   			   
			   
			   </cfif>
			   
			   </cfoutput>
			   
			</td>	
				 
			<td></td>	
			<td></td>
					 
		    </tr>	
								
			<cfquery name="Check"
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM   Ref_Account
				WHERE  GLAccount = '#entryglaccount#'
			</cfquery>				
						
			<cfif check.forceProgram eq "1">
			    <cfset cl = "regular"> 
			<cfelseif url.fund1 neq "">
			    <cfset cl = "regular">
			<cfelse>
			    <cfset cl = "hide">
			</cfif>		
							
			<cf_verifyOperational module = "Program" Warning   = "No">
					
				<tr id="program0" class="<cfoutput>#cl#</cfoutput>">
				
				  <cfif operational eq "1">
				  
					     <TD class="labelmedium2" style="padding-left:10px"><cf_tl id="Budget Fund">:</TD>
						 
				         <td>	
						 
						  <!--- Query returning search results --->
				          <cfquery name="FundList"
				          datasource="AppsProgram" 
				          username="#SESSION.login#" 
				          password="#SESSION.dbpw#">
				         	 SELECT *
						     FROM   Ref_Fund	
							 WHERE  Code IN (
											   SELECT  Fund
											   FROM    Ref_AllotmentEditionFund AF INNER JOIN
						                               Ref_AllotmentEdition AE ON AF.EditionId = AE.EditionId
											   WHERE   Mission = '#URL.Mission#' )
							 
					      </cfquery>	
						  
						  <select name="fund1" id="fund1" class="regularxxl enterastab">
						  <cfoutput query="FundList">
							  <option value="#Code#" <cfif url.fund1 eq code>selected</cfif>>#Code#</option>
						  </cfoutput>
						  </select>
						  				   	 
						  </td>
					  
				   <cfelse>	
								
			         <td>	
				
				      <cfoutput>
					  	<input type="hidden" name="fund1" id="fund1" value="#URL.Fund1#" size="20" maxlength="20" readonly>
					  </cfoutput>
					  
					 </td> 
									 
				    </cfif> 
				  
				</TR>					
							
				
				<tr id="program2" class="<cfoutput>#cl#</cfoutput>">
				
				  <cfif operational eq "1">
				  
					     <TD class="labelmedium2">
						 
						 <table style="width:100%">
							<tr class="labelmedium2">
							<td><cf_tl id="Budget Program">:</td>			
										
							</tr>
						 </table>												 
						 
						 </TD>
				         							 
						  <!--- Query returning search results --->
				          <cfquery name="Prg"
				          datasource="AppsProgram" 
				          username="#SESSION.login#" 
				          password="#SESSION.dbpw#">
					          SELECT *
						      FROM   Program
						      WHERE  ProgramCode = '#URL.ProgramCode1#'
					      </cfquery>	
						  
						  
						  
						  <td>
						  
						  <cfoutput>
						  
						     <table>
			    			 <tr>
							 
							   <td align="center" style="min-width:30px;padding-right:5px;border:1px solid silver;padding-right:5px">	
							   						   							 
							         <cfoutput>				   
								  				   				   	  
							  		 <img src="#SESSION.root#/Images/search.png" alt="Select Program or Project" name="img5" 
									  onMouseOver="document.img5.src='#SESSION.root#/Images/search1.png'" 
									  onMouseOut="document.img5.src='#SESSION.root#/Images/search.png'"
									  style="padding-left:5px;cursor: pointer" alt="" width="25" height="25" border="0" align="center" 
									  onClick="selectprogram('#URL.mission#',document.getElementById('accountperiod').value,'applyprogram','1')">
									  
									</cfoutput>
											  
							   </td>	
							   
							   <td style="border:1px solid silver;background-color:f1f1f1">	
				  
				 				 <table><tr>
								 <td>								  
								  <input type="text"   name="programdescription1" id="programdescription1" value="#Prg.ProgramName#"  class="regularxxl" style="border:0px;background-color:f1f1f1;width:423px" readonly>
								  <input type="hidden" name="programcode1"        id="programcode1"        value="#URL.ProgramCode1#" size="20" maxlength="20" readonly>								  
								  </td>
								  </tr>
								  </table>
							 
							    </td>
																						 
							  </tr>							  
							  </table>
							  
						  </cfoutput>
					   	 
						  </td>
					  
				   <cfelse>	
								
			         <td>	
				
				      <cfoutput>
					  	<input type="hidden" id="programcode1" name="programcode1" value="#URL.ProgramCode1#" size="20" maxlength="20" readonly>
					  </cfoutput>
					  
					 </td> 
									 
				    </cfif> 
				  
				</TR>		
												
				<tr id="program3" class="<cfoutput>#cl#</cfoutput>">
								
				  <!--- define if external program or contribution --->
				  			  							
				  <cfif operational eq "1">
					  
						<cfquery name="Check" 
						  datasource="AppsProgram" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
								SELECT   *
								FROM     Ref_ParameterMission
								WHERE    Mission = '#URL.Mission#'						
						</cfquery>
						
						<cfif Check.enableDonor neq "1">						
											
							<td class="labelmedium2"><cf_tl id="Contribution">:</td>
							
							<td>
						  
							  <cfoutput>
							  
							     <table cellspacing="0" cellpadding="0">
				    			 <tr>
								 
								   <td align="center" style="min-width:30px;padding-right:5px;border:1px solid silver;padding-right:5px">	
								   			   							 
								        <img src="#SESSION.root#/Images/search.png" alt="Select Donor" name="img7" 
												onMouseOver="document.img7.src='#SESSION.root#/Images/search1.png'" 
												onMouseOut="document.img7.src='#SESSION.root#/Images/search.png'"
												style="padding-left:5px;cursor: pointer" width="25" height="25" align="absmiddle" 
												onClick="selectdonor('#url.mission#',document.getElementById('fund1').value,document.getElementById('programcode1').value,'#url.journal#','#url.journalserialno#','#url.ContributionLineId#','applydonor','')">											
												  
								   </td>	
								   
								   <td id="donorbox" style="border:1px solid silver;background-color:f1f1f1">																																			
										<cfinclude template="../../Lookup/getDonor.cfm">													 									 																	 
								    </td>
																							 
								  </tr>							  
								  </table>
								  
							  </cfoutput>
						   	 
							  </td>
													
							
							 <input type="hidden" name="programdescription2"  value="" class="regularxxl enterastab" size="60" maxlength="80" readonly>
							 <input type="hidden" name="programcode2"         id="programcode2" value="">
							 <input type="hidden" name="contributionlineid"   id="contributionlineid" value="">
							
						<cfelse>		  
							
								<cfif ExternalProgramMode eq "0">
						   
								   <input type="hidden" name="programdescription2"  value="" class="regularxxl enterastab" size="60" maxlength="80" readonly>
								   <input type="hidden" name="programcode2"         id="programcode2" value="">
								   <input type="hidden" name="contributionlineid"   id="contributionlineid" value="">
								   							   
								<cfelse>   
					  
								     <td class="labelmedium" style="padding-left:10px"><cf_tl id="External Program">:</TD>
							         <td>					 
														 
									  <!--- Query returning search results --->
							          <cfquery name="Prg"
							          datasource="AppsProgram" 
							          username="#SESSION.login#" 
							          password="#SESSION.dbpw#">
								          SELECT *
									      FROM   Program
									      WHERE  ProgramCode = '#URL.ProgramCode2#'
								      </cfquery>	
									  
									  <cfoutput>
									  
									  	 <table cellspacing="0" cellpadding="0">
												 <tr>				 									 	 									 
										  										
													<td>
													  <input type="text"   name="programdescription2"  value="#Prg.ProgramName#" class="regularxxl enterastab" style="background-color:f1f1f1" size="60" maxlength="80" readonly>
													  <input type="hidden" name="programcode2"         id="programcode2" value="#URL.ProgramCode2#">
													  <input type="hidden" name="contributionlineid"   id="contributionlineid" value="">
													
													</td>		
													
													<td style="padding-left:2px">
									  
													 <img src="#SESSION.root#/Images/search.png" alt="Select a program" name="img56" 
														  onMouseOver="document.img56.src='#SESSION.root#/Images/search1.png'" 
														  onMouseOut="document.img56.src='#SESSION.root#/Images/search.png'"
														  style="cursor: pointer" alt="" width="25" height="25" border="0" align="absmiddle" 
														  onClick="selectprogram('#URL.mission#',document.getElementById('accountperiod').value,'applydonor','2')">
														
													  
													</td>												
													
											    </tr>
												
											</table>
										</td>
											
									  </cfoutput>
								   	 
									  
								</cfif>	  
							  
						</cfif>
						  
					   <cfelse>	
									
				         <td>	
					
						      <cfoutput>
							  
								  <input type="hidden" 
								         name="programcode2" 
										 id="programcode2"
										 value="#URL.ProgramCode2#" 
										 size="20" 
										 maxlength="20">
													
								  <input type="hidden" 							       
									     name="contributionlineid" 
										 id="contributionlineid"
										 value="#URL.contributionlineid#" 
										 size="20" 
										 maxlength="20">
				 
							  </cfoutput>
						  
						 </td> 
										 
				</cfif> 
				  
		</TR>				
		
		<tr id="program1" class="<cfoutput>#cl#</cfoutput>">
				
				 <cfif operational eq "1">
				  
					     <TD class="labelmedium2" style="padding-left:10px"><cf_tl id="Budget Object">:</TD>
						 
				         <td>	
						 
						  <!--- Query returning search results --->
						  
						  <cfquery name="getCode"
					         datasource="AppsProgram" 
					         username="#SESSION.login#" 
					         password="#SESSION.dbpw#">		 
							  	SELECT    Code, Code+' '+Description as Description, ObjectUsage
								FROM      Ref_Object
								WHERE     ObjectUsage IN
					                          ( SELECT  ObjectUsage
					                            FROM    Ref_AllotmentVersion V, Ref_AllotmentEdition R
					                            WHERE   R.Version = V.Code 
												AND     R.Mission = '#url.mission#')
								ORDER BY  ObjectUsage, HierarchyCode
						  </cfquery>			          
						  
						  <select name="object1" id="object1" style="width:423px" class="regularxxl enterastab">
							  <cfoutput query="getCode">
								  <option value="#Code#" <cfif url.object1 eq code>selected</cfif>>#Description#</option>
							  </cfoutput>
						  </select>
						  				   	 
						  </td>
					  
				 <cfelse>	
								
				         <td>	
					
						    <cfoutput>
							<input type="hidden" name="object1" id="object1" value="#URL.object1#" size="20" maxlength="20" readonly>
							</cfoutput>
						  
						 </td> 
									 
				 </cfif> 
				  
				</TR>							
					
		<cfif url.transactiontype eq "item">
			<cfset clw = "regular">
		<cfelse>
		    <cfset clw = "hide">	
		</cfif>	
				
		<tr name="item" class="<cfoutput>#clw#</cfoutput>">
		
			<td width="100" class="labelmedium2"><cf_tl id="Warehouse">:</td>
			<td>
				
				<cfquery name="Warehouse" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Warehouse
					WHERE  Mission = '#url.Mission#'
				</cfquery>		
						
				<select name="warehouse" id="warehouse" class="regularxxl enterastab">
					<cfoutput query="warehouse">
					    	<option value="#Warehouse#" <cfif Warehouse eq url.warehouse>selected</cfif>>#WarehouseName#</option>					
					</cfoutput>
				</select>
				
			</td>	    	
				 
		</tr>
					
		<TR name="item" class="<cfoutput>#clw#</cfoutput>">
		
			<td class="labelmedium2"><cf_tl id="Item">:</td>
		  		
			<TD colspan="3">
									
					<table cellspacing="0" cellpadding="0">
	
					<tr>
					
					<td>			 
					
					 <cfoutput>	
					 
					 <table>
					 
					 <tr><td style="padding-left:5px;padding-right:5px;border:1px solid silver">
											 
					 <img src="#SESSION.root#/Images/search.png"
					     alt="" name="img99" id="img99" width="25" height="26"
					     border="0" align="absmiddle" style="cursor: pointer;" onClick="selectwarehouseitem('#url.mission#','','','applyitem','')"
					     onMouseOver="document.img99.src='#SESSION.root#/Images/search1.png'"
					     onMouseOut="document.img99.src='#SESSION.root#/Images/search.png'">  
													
					   <cfquery name="Item" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM   Item I,ItemUoM U
							WHERE  I.ItemNo = U.ItemNo
							AND    I.ItemNo = '#url.itemNo#'
							AND    U.UoM    = '#url.itemuom#'
						</cfquery>		
											
						</td>
								
						<td width="1"></td>	
						<td style="border:1px solid silver;background-color:f1f1f1">
							<input type="text" name="itemdescription" id="itemdescription" value="#item.itemdescription#" class="regularxxl" size="40" readonly style="background-color:f1f1f1;border:0px;text-align: left;">
						</td>		
						<td width="1"></td>		
						<td style="border:1px solid silver;background-color:f1f1f1">				
							<input type="text" name="itemno"  id="itemno"  value="#url.itemno#" size="3" class="regularxxl" readonly style="background-color:f1f1f1;border:0px;text-align: center;">
						</td>					
						<td width="1"></td>	
						<td style="border:1px solid silver;background-color:f1f1f1">
							<input type="text" name="uomname" id="uomname" value="#item.uomdescription#" size="7" class="regularxxl" readonly style="background-color:f1f1f1;border:0px;text-align: center;">
						</td>
							<input type="hidden" name="itemuom"       id="itemuom"  value="#url.itemuom#" size="10" class="regularxxl" readonly style="border:0px;text-align: left;">																
						</tr>
						</table>
						
						</cfoutput>
					
					</td>
									
					</tr>
					
					</table>				
			</TD>
		</TR>
		
		<tr name="item" class="<cfoutput>#clw#</cfoutput>">
					
			<td class="labelmedium2"><cf_tl id="Quantity">:</td>
				
			<td>
				<cfoutput>
				<input type="text" name="warehousequantity" id="warehousequantity" style="text-align:right" size="10" class="regularxxl enterastab" value="#url.itemquantity#"> 
				</cfoutput>
			</td>
		
		</tr>	
		
		<tr>
		
		    <TD class="labelmedium2"><cf_tl id="Cost Center">:</TD>
		 		 
	        <td align="left" style="height:31px" class="labelmedium2">	
			 
			 	<cfif CostCenterMode eq "0">
				   
				   <i><cf_tl id="disabled">
				   <input type="hidden" name="orgunit1" id="costcenter1" value="">
				
				<cfelse>	
				
					<cfif CostCenter.recordcount gte "1">						
											
						<select name="costcenter1" id="costcenter1" class="regularxxl enterastab">
						
							<cfoutput query="CostCenter">
								<option value="#OrgUnit#" <cfif orgunit eq url.orgunit1>selected</cfif>>#orgunitName#</option>
							</cfoutput>
							
						</select>
											
					<cfelse>		
				  
						  <cfquery name="Org"
				          datasource="AppsOrganization" 
				          username="#SESSION.login#" 
				          password="#SESSION.dbpw#">
					          SELECT * 
							  FROM 	 Organization 
							  WHERE  OrgUnit = '#URL.Orgunit1#'
					      </cfquery>		
						  
						  <cfoutput>	
						  
						  <table>
						  
						  	<td align="center" style="min-width:30px;padding-right:5px;border:1px solid silver;padding-right:5px">	
							 
							  <img src="#SESSION.root#/Images/search.png" alt="Select cost center" name="img66" 
							  onMouseOver="document.img66.src='#SESSION.root#/Images/search1.png'" 
							  onMouseOut="document.img66.src='#SESSION.root#/Images/search.png'"
							  style="padding-left:5px;cursor: pointer;" width="25" height="25" align="absmiddle" 
							  onClick="selectorgN('#URL.Mission#','Administrative','costcenter','applyorgunit','1')">								 								 
								
							 </td>
				 
							 <td style="border:1px solid silver">
						  
							  	 <table>
				    			 <tr>								
								 <td>	
								    
								  <input type="text"   name="orgunitname1"  id="costcentername1" class="regularxxl" value="#Org.OrgUnitName#"  style="border:0px;background-color:f1f1f1;width:454px" readonly ondblclick="resetcost()">
								  <input type="hidden" name="mission1"      id="mission1">
							   	  <input type="hidden" name="orgunit1"      id="costcenter1"  value="#Org.OrgUnit#">
								  <input type="hidden" name="orgunitcode1"  id="costcentercode1">
							  									  
								 </td>								 
								 </tr>
								 </table> 
							 
							 </td>
							 
							 </tr>
							 
							 </table>
							 							  
						  </cfoutput>	
						  
					  </cfif>	  
				  
				</cfif>  
			  
			 </td>	
				 
				 <script language="JavaScript">
				 
					 function resetcost() {
						 document.getElementById("orgunitname1").value = ""
						 document.getElementById("orgunit1").value = ""
					 }
				 
				 </script>
				 
				<td class="labelmedium"><!--- <cf_tl id="Exchange">:---></td>				
			   				
		  </tr>		
		  
		   <cfquery name="getGLAccount"
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    SELECT *
				FROM   Ref_Account
				WHERE  GLAccount = '#entryglaccount#'
			</cfquery>	
			
			<cfif presetGLAccount eq "">
						
			    <cfif getGLAccount.AccountClass neq "Result">
				    <cfset cl = "hide"> 
				<cfelse>
					<cfset cl = "regular">
				</cfif>
			
			<cfelse>
						
				<cfif getGLAccount.AccountClass eq "Balance">
				    <cfset cl = "hide"> 
				<cfelse>
					<cfset cl = "regular">
				</cfif>
				
			</cfif>	
			
			<tr id="setdate" class="<cfoutput>#cl#</cfoutput>">	
			
				<td class="labelmedium2"><cf_tl id="Posting Date">:<cf_space spaces="40"></td>	        
				<td align="left">					
												
				<cfif url.transactiondate eq "">
				
				 <cf_intelliCalendarDate9
					 manual="false"
			      FieldName="transactiondateline" 			 
				  class="regularxxl enterastab"		
				  DateValidStart="#Dateformat(Period.PeriodDateStart, 'YYYYMMDD')#"				  	  
				  
			      Default="#dateformat(now(),client.dateformatshow)#">
				  
				  <!--- DateValidEnd="#Dateformat(Period.PeriodDateEnd, 'YYYYMMDD')#"		 --->
				
				<cfelse>
				
				 <cf_intelliCalendarDate9
				  manual="false"
			      FieldName="transactiondateline" 			 
				  class="regularxxl enterastab"		
				  DateValidStart="#Dateformat(Period.PeriodDateStart, 'YYYYMMDD')#"							  				  	  
			      Default="#url.TransactionDate#">
				  
				  <!--- DateValidEnd="#Dateformat(Period.PeriodDateEnd, 'YYYYMMDD')#"			--->
					
				</cfif>
												
				
				</td>
			
			</tr>			 
		
		  <TR> 
			 <TD width="158" class="labelmedium2"><cf_tl id="Description">/<cf_tl id="Memo">:</TD>
	             <td align="left" colspan="3">
				 
				  <input type="text"   id="entryreference"     name="entryreference"     value="<cfoutput>#URL.entryreference#</cfoutput>"  class="regularxxl" style="width:80%" maxlength="100">
				  <input type="hidden" id="entryreferencename" name="entryreferencename" value="<cfoutput>#URL.entryreferencename#</cfoutput>" >
				 
				 </td>	
				 
					<!--- Query returning search results --->
					<cfquery name="CurrencySelect"
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
						FROM   Currency
						WHERE  Currency IN (SELECT Currency 
						                   FROM    CurrencyExchange 
										   WHERE   EffectiveDate <= getDate())
						ORDER BY Currency				   
					</cfquery>	
							
					<script language="JavaScript">
					
						function curformat(amount) {		
							var objRegExp = new RegExp('(-?\[0-9]+)([0-9]{3})');
							<!--- while(objRegExp.test(amount)) amount = amount.toString().replace(objRegExp,'$1,$2'); --->
							document.getElementById('entryamount').value = amount		
						}
			
					</script>	
				
		  </tr>		
		  	  											
		  <cfif TaxCodeMode eq "1" and SysJou neq "ExchangeRate">
		  	
				  <tr>
				 
				  <!---
				  <cfif TraCat is "Payables" or TraCat is "DirectPayment" or TraCat is "Receivables">
				  --->
				 				 	
												
						  <TD class="labelmedium2"><cf_tl id="Taxcode">:</TD>
				          <td align="left">
						  
							 <cfif url.taxcode neq "">
						 				
							 <select name="taxcode" id="taxcode" class="regularxxl enterastab" style="width:170px">
					            <cfoutput query="Tax">
					        	<option value="#TaxCode#" <cfif URL.taxcode eq TaxCode>selected</cfif>>
								#TaxCode# #Description#</option>
					         	</cfoutput>
						    </select>
							
							<cfelse>
							
								<select name="taxcode" id="taxcode" class="regularxxl enterastab" style="width:170px">
					            <cfoutput query="Tax">
					        	<option value="#TaxCode#" <cfif taxcode eq TaxCodeDefault>selected</cfif>>
								#TaxCode# #Description#</option>
					         	</cfoutput>
						    </select>							
							
							</cfif>
										
						  </td>
					
					<!---				
					  <cfelse>
					
					    <td></td>
						<input type="hidden" id="taxcode" name="taxcode" value="00" style="text-align: right; background: #DCDCDC;" notab="">	
							  		
			  	  </cfif>
				  --->
				  	  
				  </tr>
			
		<cfelse>
				
			 <input type="hidden" id="taxcode" name="taxcode" value="00" style="text-align: right; background: #DCDCDC;" notab="">	
				
		</cfif>
			
		<tr>
				  <TD style="padding-top:5px;" valign="top" class="labelmedium" height="21"><cf_tl id="Amount">:</TD>
		          <td>
				  
					  <table cellspacing="0" cellpadding="0">
					  <tr>
					
					   <td style="padding-top:0px;" valign="top">
					   
					   <cfif acc.ForceCurrency neq "">					  
					   	 <cfset dis = "disabled">
					   <cfelse>					   
					   	 <cfset dis = "">
					   </cfif>
					   
						<select name="entrycurrency" 
						    id="entrycurrency" style="height:30px"
							onchange="amountcalc('0')" 
							class="regularxxl enterastab" <cfoutput>#dis#</cfoutput>>
						 <cfoutput query="CurrencySelect">
					     <option value="#Currency#" <cfif URL.currency eq currency>selected</cfif>>#Currency#</option>
						 </cfoutput> 
						</select>
						
					   </td>  
					  
					   <td id="amtinput" style="padding-top:0px; padding-left:3px" valign="top">
					   
					  <cfif url.entryamount eq "0">
					  	<cfset url.entryamount = "">
					  </cfif>					  	
										  
					   <input type="text"
						       name="entryamount"
							   id="entryamount"
						       value="<cfoutput>#URL.entryamount#</cfoutput>"
						       size="10"
						       class="regularxxl calculator enterastab"
							   style="height:30px;width:110px;padding-top:1px;text-align: right;padding-right:4px"		
							   onkeyup="amountcalc('0')" 					  
						       onblur="curformat(this.value)">

						  <!---							   
							    onkeyup="amountcalc('0')"  --->
					   
						</td>
											   
					     <td id="calc" class="hide">
							  							
								<cf_calculator
									 name="calcamount"
									 id="calcamount"
									 copy="entryamount"
									 value="#URL.entryamount#"
									 style="font:14px;text-align: right;"			 
									 decimals = "2"
									 onchange="amountcalc('1')"> 
						
						 </td>
							 
							 <script>
							 
								 function togglecalc() {
									 se  = document.getElementById("entryamount")
									 se1 = document.getElementById("calc")
									 se2 = document.getElementById("amtinput")
									 se3 = document.getElementById("calcamount")
									 
									 if (se1.className == "hide") {
									    se1.className  = "regular"
										se2.className  = "hide"
										cformat(se.value)										
										amountcalc('1')
									  } else {
										se2.className = "regular"
										se1.className = "hide"
										curformat(se3.value)
										amountcalc('1')
										}
									 }	
									 
							 </script>
							
							</td>
							
							<td style="padding-left:4px" colspan="3" id="amountdetail">
			 
								<cfset url.entryCurrency = URL.currency>
								<cfinclude template="TransactionDetailEntryCalc.cfm">
													
							</td>
					
					   </tr>
					   
					 </table>	
					 		   
				</TD>
				
			</tr>
			 
			 			  
			  <tr><td colspan="4" class="line"></td></tr>
			  
			  <tr><td colspan="4" height="30">
				
			   <cfoutput>
	
			   <cfif url.serialNo eq "">
	   		   <cf_tl id="Add Line" var="1">
			   
		       <input type="button" id="entryadd" style="height:30px;width:160;font-size:13px" value="#lt_text#" 
			       class="button10g" 
				   onClick="addline('add')">
				   
			   <cfelse>
			   
	   		    <cf_tl id="Update Line" var="1">
			    <input type="button" id="entryedit" style="height:30px;width:160;font-size:13px" value="#lt_text#" 
			       class="button10g"
				   onClick="addline('edit')">
	
				   
	   		    <cf_tl id="Add Line" var="1">
				 <input type="button" id="entryadd" style="height:30px;width:160;font-size:13px" value="#lt_text#" 
			       class="button10g"  
				   onClick="addline('add')">  
				   
			   </cfif>	  
			   
			   </cfoutput> 
		 </td>
		 </tr>
		 	 				
	      </TABLE>
		 
		 </td> 
		    			 
		 </tr>
				 	 
	</table>	

</td></tr>

</table>

<cfset ajaxonload("doCalendar")>


