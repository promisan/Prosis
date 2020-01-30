
<!--- show details of the line for editing --->

<cfparam name="url.print" default="1">

	   
<cfoutput>

<table width="90%" cellspacing="0" cellpadding="0" class="formspacing">    
   	        
	   <cfif Memo neq "">	   
	   	         		  	   
		      <tr class="linedotted">
			   <td style="padding-left:4px" width="20%" class="labelit"><cf_tl id="Memo">:</b></td>
			   <td width="80%" height="18">
			   <cfdiv id="memo#box#">
			   		<table>
					   <tr>
					  	 <td class="labelit">					 
						  <cfif (access eq "EDIT" and url.print neq 1 and ActionStatus eq "0") or access eq "ALL">
					      <a href="javascript:ColdFusion.navigate('TransactionViewPostingLineEdit.cfm?selected=#memo#&#link#&fld=memo','memo#box#')">
						  <font color="0080FF">[<cf_tl id="edit">]</font>
						  </a>
						  </cfif>
						 </td>
						 <td>&nbsp;</td>
						 <td class="labelit">#Memo#</td>
					    </tr>
				   </table>		   
				 
			   </cfdiv>
			  	  
			   </td>
			  </tr>  
				   
	   </cfif>    
	   	      
	   <cfquery name="Org" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  Organization
			WHERE OrgUnit = '#OrgUnit#'
	   </cfquery> 
	     	   	         
	    <!-----   	  to let the user modify even if 0 is the value for the TransactionLine::OrgUnit 	         
	   <cfif Org.OrgUnitName neq "" or forceProgram eq "1">
	   	------>
	      	   		  			   		   
		      <tr class="linedotted">
			   <td style="padding-left:4px" class="labelit"><cf_tl id="Cost center">:</b></td>
			   <td height="18">
			   <cfdiv id="unit#box#">
			   		<table>
					   <tr>
					  	 <td class="labelit">
						 <cfif (access eq "EDIT" and checkdis.recordcount eq "0" and url.print neq 1 and ActionStatus eq "0") or access eq "ALL">						  
					      <a href="javascript:_cf_loadingtexthtml='';	ColdFusion.navigate('TransactionViewPostingLineEdit.cfm?selected=#orgunit#&#link#&fld=unit','unit#box#')">
						  <font color="0080FF">[<cf_tl id="edit">]</font>
						  </a>
						  </cfif>
						 </td>
						 <td>&nbsp;</td>
						 <td class="labelit">
						    <cfif Org.OrgUnitName neq "1"> 
								#Org.OrgUnitCode# - #Org.OrgUnitName#					   		
						   <cfelse>
						   		<font color="FF0000">-- <cf_tl id="undefined"> --</font>
						   </cfif>
						    </td>
					    </tr>
				   </table>					 
			   </cfdiv>
			  	  
			   </td>
			  </tr>
			  
			       		    
	  <!----		       		    
	   </cfif>  ----->
	   
	      
	   <cf_verifyOperational module = "Program" Warning = "No">
			
	   <cfif operational eq "1" and TransactionSource neq "AssetSeries" and TransactionSource neq "WarehouseSeries">
	   
	   		 <cfquery name="Prg" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   TOP 1 *
					FROM     Program P, ProgramPeriod Pe
					WHERE    P.ProgramCode = Pe.ProgramCode
					AND      P.ProgramCode = '#ProgramCode#'
					ORDER BY Pe.Created DESC
			</cfquery>
	   
	        <cfif Prg.recordcount gte "1" or forceProgram eq "1">
	   	   
	   			<tr class="linedotted">
					
					<!--- this was old code for the donor, has to be replaced now for the new function --->
					
					<cfquery name="Check" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     Ref_ParameterMission
						WHERE    Mission = '#Mission#'						
					</cfquery>
					
					<cfif Check.enableDonor eq "1">
					
						<cfquery name="Donor" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT     C.Description,
						           C.Reference,
		                          (SELECT   OrgUnitName
		                           FROM     Organization.dbo.Organization O
		                           WHERE    C.OrgUnitDonor = O.OrgUnit) AS Donor, 
								   CL.DateEffective, 
								   CL.DateExpiration
						FROM       Contribution C INNER JOIN
				                   ContributionLine CL ON C.ContributionId = CL.ContributionId
						<cfif contributionlineid eq "">
						WHERE      1 = 0
						<cfelse> 
						WHERE      CL.ContributionLineId = '#ContributionLineId#'						
						</cfif>
						</cfquery>
					
						<td style="padding-left:4px" class="labelit">Donor:</td>
					
					    <td width="30%" height="18" id="donor#box#">			   
					   		<table>
							   <tr>
							  	 <td class="labelit">
								  <cfif (access eq "EDIT" and checkdis.recordcount eq "0" and url.print neq 1 and ActionStatus eq "0") or access eq "ALL">											  
							      <a href="javascript:ColdFusion.navigate('TransactionViewPostingLineEdit.cfm?selected=#contributionlineid#&#link#&fld=contributionlineid','donor#box#')">
								  <font color="0080FF">[<cf_tl id="edit">]</font>
								  </cfif>
								  </a>
								 </td>
								 <td>&nbsp;</td>
								 <td class="labelit">
								 
								    <cfif Donor.recordcount gte "1"> 
									
									    <table cellspacing="0" cellpadding="0" class="formpadding">
										<tr>
										
										<td class="labelit">
										<a href="javascript:EditDonor('#ContributionLineId#')">   
							       			#Donor.Donor# 
								   		</a>
										</td>								
										
										<td class="labelit">#Donor.Description#</td>
										<td class="labelsmall" style="padding-left:3px">Reference:</td>
										<td class="labelit" style="padding-left:3px">#Donor.Reference#</td>
										</tr>
										
										</table>
										
								   <cfelse>
								   		<font color="FF0000">-- <cf_tl id="undefined"> --</font>
								   </cfif>
								   
								   </td>
							    </tr>
						   </table>						 
					    </td>					
					
					<cfelse>
										
						<cfquery name="Prg1" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   TOP 1 *
							FROM     Program P, ProgramPeriod Pe
							WHERE    P.ProgramCode = Pe.ProgramCode
							AND      P.ProgramCode = '#ProgramCodeProvider#'
							ORDER BY Pe.Created DESC
						</cfquery>
					
						<td style="padding-left:4px" class="labelit">Provider:</td>
					
					    <td width="20%" height="18" id="programprovider#box#">			   
					   		<table>
							   <tr>
							  	 <td class="labelit">
								 
								  <cfif (access eq "EDIT" and checkdis.recordcount eq "0" and url.print neq 1 and ActionStatus eq "0") or access eq "ALL">			
							      <a href="javascript:ColdFusion.navigate('TransactionViewPostingLineEdit.cfm?selected=#programcodeprovider#&#link#&fld=programprovider','programprovider#box#')">
								  <font color="0080FF">[<cf_tl id="edit">]</font>
								  </cfif>
								  </a>
								 </td>
								 <td>&nbsp;</td>
								 <td class="labelit">
								    <cfif Prg1.recordcount gte "1"> 
										<a href="javascript:EditProgram('#Prg1.ProgramCode#','#Prg1.Period#','#Prg1.ProgramClass#')">   
							       			#Prg1.ProgramName#
								   		</a>
								   <cfelse>
								   		<font color="FF0000">-- <cf_tl id="undefined"> --</font>
								   </cfif>
								    </td>
							    </tr>
						   </table>						 
					    </td>
					
					</cfif>
			   
			   </tr>			  
			 			 			   
		   </cfif>  
		   	   
	   	   
		   <cfif Prg.recordcount gte "1" or forceProgram eq "1">
		   			  
			  <tr class="linedotted">	
					<td style="padding-left:4px" class="labelit"><cf_tl id="Fund">:</td>
					
					<td width="5%" height="18" id="fund#box#">			   
				   		<table>
						  <tr>
						    
						  	 <td class="labelit">							 
								<cfif (access eq "EDIT" and checkdis.recordcount eq "0" and url.print neq 1 and ActionStatus eq "0") or access eq "ALL">			
							      <a href="javascript:ColdFusion.navigate('TransactionViewPostingLineEdit.cfm?selected=#fund#&#link#&fld=fund','fund#box#')">
								  <font color="0080FF">[<cf_tl id="edit">]</font>
								  </a>
								</cfif>							  
							 </td>
							 <td>&nbsp;</td>
							 <td class="labelit">#fund#</td>
						  </tr>
					   </table>						 
				    </td>
					
				</tr>	
				
			    <tr class="linedotted">
				   <td width="30%" style="padding-left:4px" class="labelit"><cf_tl id="Cost Program">:</td> 
				   
				   <td width="70%">
				   
				   <table width="100%" cellspacing="0" cellpadding="0">
				   <tr>
				   				   
					   <td width="20%" height="18" id="program#box#">			   
					   		<table>
							   <tr>
							  	 <td class="labelit">							 
								  <cfif (access eq "EDIT" and checkdis.recordcount eq "0" and url.print neq 1 and ActionStatus eq "0") or access eq "ALL">	
							      <a href="javascript:ColdFusion.navigate('TransactionViewPostingLineEdit.cfm?selected=#programcode#&#link#&fld=program','program#box#')">
								  <font color="0080FF">[<cf_tl id="edit">]</font>
								  </cfif>
								  </a>
								 </td>
								 <td>&nbsp;</td>
								 <td class="labelit">
								    <cfif Prg.recordcount gte "1"> 
										<a href="javascript:EditProgram('#Prg.ProgramCode#','#Prg.Period#','#Prg.ProgramClass#')">   
							       			#Prg.Reference# #Prg.ProgramName#
								   		</a>
								   <cfelse>
								   		<font color="FF0000">-- <cf_tl id="undefined"> --</font>
								   </cfif>
								    </td>
							    </tr>
						   </table>						 
					    </td>
					  </tr>
					  </table>	
					  </td>
				</tr>  
											
				 <!---	  
				   <cfif ObjectCode neq "">
				   --->
				   	   			 
					  <cfquery name="Obj" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT  TOP 1 *
								FROM    Ref_Object O
								WHERE   O.Code = '#ObjectCode#'				
						</cfquery>
													
				  <tr>
					   <td style="padding-left:4px" width="160" class="labelit"><cf_tl id="Object of Expense">:</b></td>
					   <td height="18">
						   
						    <cfdiv id="objectcode#box#">
						   		<table>
								   <tr>
								  	 <td  class="labelit">
									  <cfif (access eq "EDIT" and checkdis.recordcount eq "0" and url.print neq 1 and ActionStatus eq "0") or access eq "ALL">			
								      <a href="javascript:ColdFusion.navigate('TransactionViewPostingLineEdit.cfm?selected=#ObjectCode#&#link#&fld=objectcode','objectcode#box#')">
									  <font color="0080FF">[<cf_tl id="edit">]</font>
									  </a>
									  </cfif>
									 </td>
									 <td>&nbsp;</td>
									 <td  class="labelit">
									   <cfif Obj.recordcount neq "0"> 
										    #ObjectCode# #Obj.Description# (#Obj.ObjectUsage#)									   		
									   <cfelse>
									   		<font color="FF0000">-- <cf_tl id="undefined"> --</font>
									   </cfif>
									    </td>
								    </tr>
							   </table>					 
						   </cfdiv>
						   			   
						   </td>
				  </tr> 
							
				   <!--- </cfif> --->					  
		  
		   </cfif>
			   
	   </cfif>
	      	   
  </table>
  
</cfoutput>  