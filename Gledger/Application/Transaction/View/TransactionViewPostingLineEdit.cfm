
<cfparam name="url.mode" default="edit">

<cfquery name="getheader"
        datasource="AppsLedger" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT * 
		 FROM   TransactionHeader		
		 WHERE  Journal             = '#url.journal#'
		 AND    JournalSerialNo     = '#url.Journalserialno#'		
</cfquery>		

<cfquery name="get"
        datasource="AppsLedger" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT * 
		 FROM   TransactionLine			
		 WHERE  Journal             = '#url.journal#'
		 AND    JournalSerialNo     = '#url.Journalserialno#'
		 AND    TransactionSerialNo = '#url.transactionSerialNo#'
</cfquery>		
  
<cfset link = "journal=#url.journal#&journalserialno=#url.journalserialno#&transactionserialno=#url.transactionserialno#&box=#box#">

<cfswitch expression="#url.fld#">

<cfcase value="memo">  
	  
	  <cfif url.mode eq "save">
	    		
		<!--- ------------------------------------- --->
		<!--- create a log for the edit transaction --->
		<!--- ------------------------------------- --->
		
		<!--- update the line --->
	  
	    <cftransaction>
		
			<cfquery name="Update"
		         datasource="AppsLedger" 
		         username="#SESSION.login#" 
		         password="#SESSION.dbpw#">
			         UPDATE TransactionLine
					 SET    Memo                =  '#URL.selected#'					 
					 WHERE  Journal             = '#url.journal#'
					 AND    JournalSerialNo     = '#url.Journalserialno#'
					 AND    TransactionSerialNo = '#url.transactionSerialNo#'					 
		    </cfquery>		
			
			<cfinvoke component    = "Service.Process.GLedger.Transaction"  
			   method              = "LogTransaction" 
			   Journal             = "#url.Journal#"
			   JournalSerialNo     = "#url.JournalSerialNo#"
			   TransactionSerialNo = "#url.transactionSerialNo#"
			   Action              = "Edit Memo">		 							
					   
		</cftransaction>   	  	  
	  	  
	  </cfif>	
	 	  
	  <cfoutput>	
	  
		 <cfif url.mode eq "Edit">
	 	 	
			<table>
			<tr><td><input type="text" id="text#box#" value="#url.selected#" class="regularxxl" size="60" maxlength="80"></td>
			    <td>
			 <input type="button" name="Save" value="Save" class="button10g" style="width:40px" 
			     onclick="ptoken.navigate('TransactionViewPostingLineEdit.cfm?mode=save&selected='+document.getElementById('text#box#').value+'&#link#&fld=memo','memo#url.box#')">	
			    </td>
			</tr>
			</table>		 
			   
	     <cfelse>
	   
	   		<table>
			<tr>
			<td class="labelit">
       		<a href="javascript:ptoken.navigate('TransactionViewPostingLineEdit.cfm?selected=#url.selected#&#link#&fld=memo','memo#url.box#')">
			   [<cf_tl id="edit">]
			</a>			
			</td>			
			<td style="padding-left:10px" class="labelit">#url.selected#</td>
			</table>
		 		   
		 </cfif>   
		
		</cfoutput>	
	    				  
</cfcase>	

<cfcase value="objectcode">  
	  
	  <cfif url.mode eq "save">
	  	  
	  	  <cfif url.selected neq get.ObjectCode>
		  	  			  	  
		   <cfquery name="Update"
	         datasource="AppsLedger" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
	         UPDATE TransactionLine
			 SET    ObjectCode          =  '#URL.selected#' 
			 WHERE  Journal             = '#url.journal#'
			 AND    JournalSerialNo     = '#url.Journalserialno#'
			 AND    TransactionSerialNo = '#url.transactionSerialNo#'
	       </cfquery>
		   
		   <cfinvoke component    = "Service.Process.GLedger.Transaction"  
			   method              = "LogTransaction" 
			   Journal             = "#url.Journal#"
			   JournalSerialNo     = "#url.JournalSerialNo#"
			   TransactionSerialNo = "#url.transactionSerialNo#"
			   Action              = "Edit Object">	
		  
		  </cfif>		 
	  	  
	  </cfif>	
		  
	  <cfoutput>	
	  
		 <cfif url.mode eq "Edit">
		 
		 	 <cfquery name="getCode"
	         datasource="AppsProgram" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">		 
			  	SELECT   Code, 
				         (CASE WHEN CodeDisplay is NULL THEN
					         Code+' '+Description
							 ELSE
							 CodeDisplay+' '+Description
						 END) as Description,	 
							 
						 ObjectUsage
				FROM     Ref_Object
				WHERE    ObjectUsage IN
	                          ( SELECT  ObjectUsage
	                            FROM    Ref_AllotmentVersion V, Ref_AllotmentEdition R
	                            WHERE   R.Version = V.Code 
								AND     R.Mission = '#getHeader.mission#')
				ORDER BY ObjectUsage, HierarchyCode
			</cfquery>
			
			<table cellspacing="0" cellpadding="0">
			
			<cfform>
			
			<tr><td>					
				<cfselect class="regularxxl" query="getCode" id="objectcode#box#" name="objectcode#box#" group="ObjectUsage" value="Code" display="Description" selected="#url.selected#"></cfselect>							
			</td>
			
			<td style="padding-left:2px">
			
				<input type="button" name="Save" value="Save" class="button10g" style="width:40" onclick="ptoken.navigate('TransactionViewPostingLineEdit.cfm?mode=save&selected='+objectcode#box#.value+'&#link#&fld=objectcode','objectcode#url.box#')">	
			
			</td>
			</tr>
			
			</cfform>
			
			</table>
			   
	     <cfelse>
		 
		 	 <cfquery name="Obj" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  TOP 1 *
					FROM    Ref_Object O
					WHERE   O.Code = '#url.selected#'				
				</cfquery>
		 
		 	<table>
				<tr>
					<td class="labelit">			   
			   		  <a href="javascript:ptoken.navigate('TransactionViewPostingLineEdit.cfm?selected=#url.selected#&#link#&fld=objectcode','objectcode#url.box#')">
					  	 [<cf_tl id="edit">]
					  </a>	
					</td>					
					<td class="labelit" style="padding-left:10px">
				    <cfif Obj.recordcount neq "0"> 
					    #url.selected# #Obj.Description# (#Obj.ObjectUsage#)											   		
					<cfelse>
				   		<font color="FF0000">-- <cf_tl id="undefined"> --</font>
				    </cfif>
					</td>
				</tr>
			</table> 		
										 		   
		 </cfif>   
		
	</cfoutput>	
	    				  
</cfcase>

<cfcase value="unit">  
	  
	  <cfif url.mode eq "save">
	  
	  	  <cfif url.selected neq get.OrgUnit>
		   	  
		   <cfquery name="Update"
	         datasource="AppsLedger" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
	         UPDATE TransactionLine
			 SET    OrgUnit             =  '#URL.selected#'
			 WHERE  Journal             = '#url.journal#'
			 AND    JournalSerialNo     = '#url.Journalserialno#'
			 AND    TransactionSerialNo = '#url.transactionSerialNo#'
	       </cfquery>
		   
		   <cfinvoke component    = "Service.Process.GLedger.Transaction"  
			   method              = "LogTransaction" 
			   Journal             = "#url.Journal#"
			   JournalSerialNo     = "#url.JournalSerialNo#"
			   TransactionSerialNo = "#url.transactionSerialNo#"
			   Action              = "Edit Unit">	  	  	  
		  
		  </cfif>		 
	  	  
	  </cfif>	
	  
	  <cfquery name="Org"
         datasource="AppsOrganization" 
         username="#SESSION.login#" 
         password="#SESSION.dbpw#">
         SELECT * 
		 FROM  Organization 
		 WHERE OrgUnit = '#URL.selected#'
      </cfquery>		
	  
	  <cfoutput>	
	  
		 <cfif url.mode eq "Edit">
		 
		 	<table>
			<tr>
			<td class="labelit">
		     <cf_img icon="open" onClick="selectorgN('#Org.Mission#','Administrative','orgunit','applyorgunit','#box#')">
			</td>
			
			<td>			
			<input type="text" name="orgunitname#box#" id="orgunitname#box#" value="#Org.OrgUnitName#" class="regularxxl" size="40" maxlength="60" readonly >
			</td>
			<td>
			
			  <input type="button" name="Save" value="Save" class="button10g" style="width:40px" 
			     onclick="ptoken.navigate('TransactionViewPostingLineEdit.cfm?mode=save&selected='+document.getElementById('orgunit#box#').value+'&#link#&fld=unit','unit#url.box#')">	
			  <input type="hidden" name="mission#box#" id="mission#box#">
			  <input type="hidden" name="orgunit#box#" id="orgunit#box#" value="#Org.OrgUnit#">
			  </td>
			  </tr>
			</table> 	
		   
	     <cfelse>
		 
		 	<table>
			<tr>
			<td class="labelit">	   
	   		  <a href="javascript:ptoken.navigate('TransactionViewPostingLineEdit.cfm?selected=#url.selected#&#link#&fld=unit','unit#url.box#')">
			  	 [<cf_tl id="edit">]
			  </a>	
			</td>				
			<td class="labelit" style="padding-left:10px">
		    #Org.OrgUnitCode# #Org.OrgUnitName#	   
			</td>
			</tr>
			</table> 		
										 		   
		 </cfif>   
		
		</cfoutput>	
	    				  
</cfcase>	

<cfcase value="fund">  
	  
	  <cfif url.mode eq "save">
	    
	        <cfif url.selected neq get.Fund>
				  	  		  
			   <cfquery name="Update"
		         datasource="AppsLedger" 
		         username="#SESSION.login#" 
		         password="#SESSION.dbpw#">
		         UPDATE TransactionLine
				 SET    Fund                = '#URL.selected#'
				 WHERE  Journal             = '#url.journal#'
				 AND    JournalSerialNo     = '#url.Journalserialno#'
				 AND    TransactionSerialNo = '#url.transactionSerialNo#'
		      </cfquery>	
			  
			  	<cfinvoke component    = "Service.Process.GLedger.Transaction"  
				   method              = "LogTransaction" 
				   Journal             = "#url.Journal#"
				   JournalSerialNo     = "#url.JournalSerialNo#"
				   TransactionSerialNo = "#url.transactionSerialNo#"
				   Action              = "Edit Fund">	 	
		  
		  </cfif> 
	  	  
	  </cfif>	
	  	  
	  <cfoutput>	
	  
		 <cfif url.mode eq "Edit">	 	 
			    
			<table>
			<tr>
			<td>	
			  <input type="text" id="fundcode#box#" name="fundcode#box#" value="#url.selected#" class="regularxxl" style="padding-top:2px;width:35" maxlength="4">
			  </td>
			  <td style="padding-left:2px">
			  <input type="button" name="Save" value="Save" class="button10s" style="width:40;height:18" onclick="ptoken.navigate('TransactionViewPostingLineEdit.cfm?mode=save&selected='+document.getElementById('fundcode#box#').value+'&#link#&fld=fund','fund#url.box#')">	
			  </td>
			 </tr>
			 </table> 
				   
	     <cfelse>
		 
		 	<table>
			<tr>
			<td class="labelit">
	   
	   		  <a href="javascript:ptoken.navigate('TransactionViewPostingLineEdit.cfm?selected=#url.selected#&#link#&fld=fund','fund#url.box#')">
			  	 [<cf_tl id="edit">]
			  </a>	
			</td>			
			<td class="labelit" style="padding-left:10px">
		    #url.selected#	   
			</td>
			</td>
			</table> 		
										 		   
		 </cfif>   
		
		</cfoutput>	
	    				  
</cfcase>	

<cfcase value="program"> 	

		<cfif url.mode eq "save">
		
			<cfif url.selected neq get.ProgramCode>
					  
			   <cfquery name="Update"
		         datasource="AppsLedger" 
		         username="#SESSION.login#" 
		         password="#SESSION.dbpw#">
		         UPDATE TransactionLine
				 SET    ProgramCode        =  '#URL.selected#'
				 WHERE  Journal             = '#url.journal#'
				 AND    JournalSerialNo     = '#url.JournalSerialno#'
				 AND    TransactionSerialNo = '#url.transactionSerialNo#' 
		      </cfquery>	
			  
			  <cfinvoke component    = "Service.Process.GLedger.Transaction"  
				   method              = "LogTransaction" 
				   Journal             = "#url.Journal#"
				   JournalSerialNo     = "#url.JournalSerialNo#"
				   TransactionSerialNo = "#url.transactionSerialNo#"
				   Action              = "Edit Program">	  			
		  
		  </cfif>
		  
	    </cfif>	

		<cfquery name="Header"
		     datasource="AppsLedger" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		      SELECT  *
		      FROM    TransactionHeader
		      WHERE   Journal = '#URL.Journal#'
			  AND     JournalSerialNo = '#URL.JournalSerialNo#'
		</cfquery>	
		
		<cfquery name="Prg" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    TOP 1 *
				FROM      Program P, ProgramPeriod Pe
				WHERE     P.ProgramCode = Pe.ProgramCode
				AND       P.ProgramCode = '#URL.selected#'
				ORDER BY  Pe.Created DESC
		</cfquery>
		  
		<cfoutput>
		  
		  	 <cfif url.mode eq "Edit">
		  
		  	   <table cellspacing="0" cellpadding="0">
			   <tr>
				   <td>				   
				   <cf_img icon="edit" onClick="selectprogram('#Header.mission#','#Header.AccountPeriod#','applyprogram','#box#')">			
				  </td>				  
				    
				  <td style="padding-left:2px">	 
				  <input type="text" id="programdescription#box#" name="programdescription#box#" value="#Prg.ProgramName#" class="regularxxl" size="90" maxlength="80" readonly>
				  </td>
				  <td style="padding-left:3px">
				  <input type="button" name="Save" value="Save" class="button10g" style="width:40" onclick="ptoken.navigate('TransactionViewPostingLineEdit.cfm?mode=save&selected='+programcode#box#.value+'&#link#&fld=program','program#url.box#')">	
				  <input type="hidden" id="programcode#box#" name="programcode#box#" value="#URL.selected#" size="20" maxlength="20" readonly>			  
				  </td>
			  </tr>
			  </table>
		   				  
			<cfelse>
			
			  <table>
				<tr>
				<td class="labelit">
				   <a href="javascript:ptoken.navigate('TransactionViewPostingLineEdit.cfm?selected=#PRG.programcode#&#link#&fld=program','program#box#')">
				   [<cf_tl id="edit">]
				   </a>
				</td>   
			    <td>&nbsp;</td>		
			    <td class="labelit">
				    <a href="javascript:EditProgram('#Prg.ProgramCode#','#Prg.Period#','#Prg.ProgramClass#')">   
			       		#Prg.Reference# #Prg.ProgramName#
				    </a>
				</td>
				</td>
			</table> 		 
						
			</cfif>  
			
		  </cfoutput>	

</cfcase>


<cfcase value="contributionlineid"> 

		<cfif url.mode eq "save">
	  
		   <cfquery name="Update"
	         datasource="AppsLedger" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
	         UPDATE TransactionLine
			 <cfif url.selected eq "">
			 SET    ContributionLineId  =  NULL
			 <cfelse>
			 SET    ContributionLineId  =  '#URL.selected#'
			 </cfif>
			 WHERE  Journal             = '#url.journal#'
			 AND    JournalSerialNo     = '#url.JournalSerialno#'
			 AND    TransactionSerialNo = '#url.transactionSerialNo#' 
	      </cfquery>	
		  
		  <!--- add the logging logging --->
		  
	    </cfif>	
		
		
		<cfif url.mode eq "Edit">
		
		 <cfquery name="getLine"
	         datasource="AppsLedger" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
	         SELECT *
			 FROM   TransactionLine
			 WHERE  Journal             = '#url.journal#'
			 AND    JournalSerialNo     = '#url.JournalSerialno#'
			 AND    TransactionSerialNo = '#url.transactionSerialNo#' 
	      </cfquery>	
		  
		  <!--- select only donor lines that are intended to be used by this program based on the allotment 
		  
		  1. filter on project code, fund
		  2. pending : filtering on the Object code used for allotment
		  3. only contributions that are still valid on the document dateof the transaction
		  4. pending : exclude contributions which have been fully used already 
		  
		  --->
		  		  
		   <cfquery name="getDonorLines"
	         datasource="AppsProgram" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
			 
		     SELECT   C.ContributionId,
			          C.Mission, 
					  C.OrgUnitDonor,
                          (SELECT  OrgUnitName
                           FROM    Organization.dbo.Organization
                           WHERE   OrgUnit = C.OrgUnitDonor) AS Donor, 
					  C.Reference as DonorReference,	   
    				  CL.ContributionLineId, 
					  CL.DateEffective, 
					  CL.DateExpiration, 					  
					  CL.Fund, 
					  CL.Reference,
                      CL.AmountBase,
					  
					  (SELECT IsNull(SUM(AmountBaseDebit-AmountBaseCredit),0) as Consumed
			                           FROM   Accounting.dbo.TransactionLine
									   WHERE  ContributionLineId = CL.ContributionLineId
									   AND    TransactionLineId <> '#getLine.TransactionLineid#') as AmountUsed
					  
					  <!---
					  CL.Reference+' [#APPLICATION.BaseCurrency# '+CONVERT(VARCHAR,CAST(ROUND(CL.AmountBase,0) AS MONEY),1)+']' as Reference
					  --->
					  
			 FROM     Contribution AS C INNER JOIN
                      ContributionLine AS CL ON C.ContributionId = CL.ContributionId
				
			 <!--- show contributions used for this project --->
			 		  
			 WHERE    CL.ContributionLineId IN
                          (SELECT    ADC.ContributionLineId
                            FROM     ProgramAllotmentDetailContribution AS ADC INNER JOIN
                                     ProgramAllotmentDetail AS AD ON ADC.TransactionId = AD.TransactionId
                            WHERE    AD.ProgramCode = '#getLine.ProgramCode#') 
							
			 AND      (CL.DateExpiration IS NULL 
			          OR CL.DateExpiration >= '#dateformat(getLine.TransactionDate, client.dateSQL)#') 
			 
			 <!--- same fund --->		  
		     AND      CL.Fund       = '#getLine.Fund#' 
			 
			 <!--- contribution line not already fully disbursed excluding the current line --->
			 
			 AND      CL.AmountBase > (SELECT IsNull(SUM(AmountBaseDebit-AmountBaseCredit),0) as Consumed
			                           FROM   Accounting.dbo.TransactionLine
									   WHERE  ContributionLineId = CL.ContributionLineId
									   AND    TransactionLineId <> '#getLine.TransactionLineid#') 		

			 <!--- better to exclude here the current selected donor as well --->						   									   	 
			 
			 ORDER BY C.OrgUnitDonor, C.Reference, CL.DateEffective
			 
		   </cfquery>		
		   
		   <cfset ht = getDonorLines.recordcount * 17 + 40>
		   		  		   				
			<div style="position:absolute; color: white; z-index: 2000;" id="contributionfind">
						   				
				<table style="border:1px solid silver" bgcolor="fafafa">			
								
				<tr>
				
				<td width="350"  style="padding-top:5px" valign="top">
				<table width="92%" align="center">
				<tr class="line labelmedium">
					<td><cf_tl id="Donor"></td>
					<td align="center"><cf_tl id="Effective"></td>
					<td align="center"><cf_tl id="Expiration"></td>
					<td align="right" width="60"><cf_tl id="Amount"></td>		
					<td align="right" width="60" style="padding-right:4px"><cf_tl id="Used"></td>				
				</tr>
				
				<cfoutput>
				
				<tr class="labelit">					   
				   <td colspan="5" height="20" align="center">
				   <a href="javascript:ptoken.navigate('TransactionViewPostingLineEdit.cfm?mode=save&selected=&#link#&fld=contributionlineid','donor#box#')">
				   -- Undefined --</a></td>
				</tr> 
				
				</cfoutput>	  
								
				<cfoutput query="getDonorLines" group="Donor">

					<cfoutput group="DonorReference">

						<tr><td colspan="2" class="labelmedium"><b>#donor#</b></td>
							<td colspan="3" class="labelit" align="right">#DonorReference#</td>
						</tr>
				
						<cfoutput>
											
							<cfif url.selected eq contributionlineid>				
							<tr class="labelit" bgcolor="ffffaf">
							<cfelse>
							<tr class="labelit">
							</cfif>
							    <td style="padding-left:20px;padding-top:3px">
								<cf_img icon="open" 
								   onclick="ptoken.navigate('TransactionViewPostingLineEdit.cfm?mode=save&selected=#contributionlineid#&#link#&fld=contributionlineid','donor#box#')">
								</td>
								<td align="center">#dateformat(DateEffective,CLIENT.DateFormatShow)#</td>
								<td align="center">#dateformat(DateExpiration,CLIENT.DateFormatShow)#</td>
								<td align="right">#numberformat(AmountBase,',__')#</td>		
								<td align="right" style="padding-right:4px">#numberformat(AmountUsed,',__')#</td>			
							</tr>			
					
						</cfoutput>
						
					</cfoutput>
				
				</cfoutput>
								
				</table>				
				
				</td>
				</tr>
				<tr><td height="4"></td></tr>
				
				</table>						
				
			</div>			
					  		
		<cfelse>		
		
				<cfquery name="Donor" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT     C.Description,
					           CL.Reference,
	                          (SELECT   OrgUnitName
	                           FROM     Organization.dbo.Organization O
	                           WHERE    C.OrgUnitDonor = O.OrgUnit) AS Donor, 
							   CL.DateEffective, 
							   CL.DateExpiration
					FROM       Contribution C INNER JOIN
			                   ContributionLine CL ON C.ContributionId = CL.ContributionId
					<cfif url.selected eq "">
					WHERE      1 = 0
					<cfelse> 
					WHERE      CL.ContributionLineId = '#url.selected#'						
					</cfif>
					</cfquery>
					
					<cfoutput>
					
					 <cfif Donor.recordcount gte "1"> 
								
					    <table class="formpadding">
						
						 <tr>
						   
						    <td class="labelit">		
							
						    <a href="javascript:ptoken.navigate('TransactionViewPostingLineEdit.cfm?selected=#url.selected#&#link#&fld=contributionlineid','donor#box#')">
							[<cf_tl id="edit">]							
							</a>
							
						    </td>
						    <td >&nbsp;</td>					
							<td class="labelit"><a href="javascript:EditDonor('#url.selected#')">#Donor.Donor#</a></td>														
							<td class="labelit">#Donor.Description#</td>
							<td class="labelsmall" class="labelit" style="padding-left:3px">Reference:</td>
							<td style="padding-left:3px" class="labelit">#Donor.Reference#</td>
						 </tr>
						
						</table>
						
				   <cfelse>
				   		<font color="FF0000">-- <cf_tl id="undefined"> --</font>
				   </cfif>
				   
				   </cfoutput>
				
		</cfif>
		
</cfcase>

<cfcase value="programprovider"> 	

		<cfif url.mode eq "save">
	  
		   <cfquery name="Update"
	         datasource="AppsLedger" 
	         username="#SESSION.login#" 
	         password="#SESSION.dbpw#">
	         UPDATE TransactionLine
			 SET    ProgramCodeProvider =  '#URL.selected#'
			 WHERE  Journal             = '#url.journal#'
			 AND    JournalSerialNo     = '#url.JournalSerialno#'
			 AND    TransactionSerialNo = '#url.transactionSerialNo#' 
	      </cfquery>	
		  
	    </cfif>	

			 <cfquery name="Header"
		     datasource="AppsLedger" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		      SELECT *
		      FROM TransactionHeader
		      WHERE Journal = '#URL.Journal#'
			  AND   JournalSerialNo = '#URL.JournalSerialNo#'
		    </cfquery>	
		
		   <cfquery name="Prg" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  TOP 1 *
				FROM    Program P, ProgramPeriod Pe
				WHERE   P.ProgramCode = Pe.ProgramCode
				AND     P.ProgramCode = '#URL.selected#'
				ORDER BY Pe.Created DESC
			</cfquery>
		  
		  <cfoutput>
		  
		  	 <cfif url.mode eq "Edit">
		  
			   <img src="#SESSION.root#/Images/contract.gif" alt="Select program" name="img5#box#" 
					  onMouseOver="document.img5#box#.src='#SESSION.root#/Images/button.jpg'" 
					  onMouseOut="document.img5#box#.src='#SESSION.root#/Images/contract.gif'"
					  style="cursor: pointer;" alt="" width="18" height="18" border="0" align="absmiddle" 
					  onClick="selectprogram('#Header.mission#','#Header.AccountPeriod#','applyprogram','provider#box#')">
				 
			  <input type="text" name="programdescriptionprovider#box#" name="programdescriptionprovider#box#" value="#Prg.ProgramName#" class="regularxl" size="20" maxlength="60" readonly>
			  <input type="button" name="Save" value="Save" class="button10s" style="width:40;height:18" onclick="ptoken.navigate('TransactionViewPostingLineEdit.cfm?mode=save&selected='+programcodeprovider#box#.value+'&#link#&fld=programprovider','programprovider#url.box#')">	
			  <input type="hidden" name="programcodeprovider#box#" name="programcodeprovider#box#" value="#URL.selected#" size="20" maxlength="20" readonly>			  
		   				  
			<cfelse>
			
			  <table>
				<tr>
				<td class="labelit">
				   <a href="javascript:ptoken.navigate('TransactionViewPostingLineEdit.cfm?selected=#PRG.programcode#&#link#&fld=programprovider','programprovider#box#')">
				   [<cf_tl id="edit">]
				   </a>
				</td>   
			    <td>&nbsp;</td>		
			    <td class="labelit">
				    <a href="javascript:EditProgram('#Prg.ProgramCode#','#Prg.Period#','#Prg.ProgramClass#')">#Prg.ProgramName#</a>
				</td>
				</td>
			</table> 		 
						
			</cfif>  
			
		  </cfoutput>	
		  
</cfcase>

</cfswitch>
