
<cfinclude template="AllotmentSearch.cfm">
<cfparam name="URL.Keyword" default="">
<cfparam name="URL.FileNo" default="#fileNo#">

<cf_tl id="Please enter a correct amount" var="1">	 

<cfset vAmount = lt_text>

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
  
<tr>
  <td class="hide" id="object"></td>
  <td></td> 
  
  <cfoutput>  
  
	  <cfloop query="edition"> 	
	  
		<cfquery name="Edit" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM       Ref_AllotmentEdition
			WHERE      EditionId = '#EditionId#'	   
		</cfquery>
		
		<cfquery name="Per" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     *
			FROM       Ref_Period
			WHERE      Period = '#Edit.Period#'	   
		</cfquery>
			
	    <td height="40" align="center" class="labelit"
	    style="border-left: 1px solid Silver; border-right: 1px solid Silver;"><b><cfif Edit.Period eq "">#Edit.Description#<cfelse>#Per.Description#</cfif></b> <cfif Parameter.BudgetAmountMode eq "1"><br>($'000)</cfif></td>
	      
	  </cfloop>
  
  </cfoutput>
  
</tr>  

<tr>
  <td></td>     
          
  <cfloop query="edition">
    
       
    <cfset editselect = edition.editionid>
	  
    <!--- --------------------- --->
  	<!--- determine access mode --->
	<!--- --------------------- --->
	
	 <cfquery name="qLock" 
			datasource="AppsProgram" 
			maxrows=1 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   ProgramAllotment
			WHERE  ProgramCode = '#url.ProgramCode#' 
			AND    Period      = '#url.Period#'
			AND    EditionId   = '#editionid#'					
	   	  </cfquery>
	
	<cfif Status eq "3" or Status eq "9">
		  
		  <cfinvoke component = "Service.Access"  
			Method            = "budget"
			ProgramCode       = "#URL.ProgramCode#"
			Period            = "#URL.Period#"	
			EditionId         = "'#Edition.EditionId#'"  
			Role              = "'BudgetManager'"
			ReturnVariable    = "BudgetAccess">	
					
			<cfif (BudgetAccess eq "EDIT" or BudgetAccess eq "ALL") and qLock.LockEntry neq "1">
			    <cfparam name="e#edition.editionid#mode" default="1">				
			<cfelse>
			    <cfparam name="e#edition.editionid#mode" default="0">					
			</cfif>
				  
	<cfelse> 
	  	  
	  		<cfinvoke component ="Service.Access"  
			Method              = "budget"
			ProgramCode         = "#URL.ProgramCode#"
			Period              = "#URL.Period#"	
			EditionId           = "'#Edition.EditionId#'"  
			Role                = "'BudgetManager','BudgetOfficer'"
			ReturnVariable      = "BudgetAccess">	
				
			<cfif (BudgetAccess eq "EDIT" or BudgetAccess eq "ALL") and qLock.LockEntry neq "1">			
				 <cfparam name="e#Edition.editionid#mode" default="1">				
			<cfelse>			
			     <cfparam name="e#Edition.editionid#mode" default="0">				
			</cfif>			
		
	</cfif>	
	   
	<cfquery name="Edit" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     *
		FROM       Ref_AllotmentEditionFund
		WHERE      EditionId = '#EditSelect#'	   
	</cfquery>	
						
	<td align="right" style="padding-right:0px;border-left: 1px solid Silver;border-right: 1px solid Silver; ">
	   <table width="100%" cellspacing="0" cellpadding="0" style="border-left: 0px solid Silver;">
		   <tr>
		   	<cfoutput>
						
			   <cfloop query="Edit">
			   	   
				   <td align="center" bgcolor="ffffcf" class="labelit" style="border: 1px solid b1b1b1">
						<cf_space spaces="20">#Fund#
				   </td>	
				   <cfif currentrow neq recordcount>
				   <td><cf_space spaces="3"></td>
				   </cfif>
				  
			   </cfloop>	
			   
			</cfoutput>			   
		   </tr>
	   </table>	  
	 </td>
   </cfloop>      
  
</tr>  

<cfset No = 0>

<cfquery name="Result" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     #SESSION.acc#Allotment_#URL.FileNo#
	<cfif url.keyword neq "">
		WHERE Description like '%#URL.keyword#%'
			or Code in
				(
					SELECT ObjectCode 
					FROM   Purchase.dbo.ItemMasterObject O, Purchase.dbo.ItemMaster I
					WHERE  O.ItemMaster = I.Code
					AND    I.Description LIKE '%#URL.keyword#%'		
				)	
			or Code like '%#URL.keyword#%'	
			
		
	</cfif>
	ORDER BY CategoryOrder, HierarchyCode, Code  		   
</cfquery>

<cfoutput query="Result" group="Category">

<tr class="line"><td style="font-size:20px;height:37px" colspan="#Edition.recordcount+2#" class="labelmedium"><font color="0080C0">#Category#</td></tr> 

<cfoutput group="ListingOrder">
<cfoutput group="Code">
 
   <cfif ParentCode eq "">
   
   <tr class="navigation_row line" style="height:14px" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f8f8f8'))#">
   
     <td width="80%">
	 <table cellspacing="0" cellpadding="0">
	 <tr class="labelmedium" style="height:15px">
	 <td style="padding-left:20px" width="80">#CodeDisplay#</td><td>&nbsp;</td><td>#Description#</td>
	 </tr>
	 </table>
	 </td>
	 
   <cfelse>
   
     <tr class="navigation_row line" style="height:14px" bgcolor="ffffef">
	 
     <td width="80%">
	  <table cellspacing="0" cellpadding="0">
	  	<tr class="labelmedium" style="height:15px">		 
		  <td style="padding-left:30px"><img src="#SESSION.root#/Images/childnode.gif" alt="" align="absmiddle" border="0"></td>
		  <td width="80">#CodeDisplay#</td>
		  <td>&nbsp;</td>
		  <td>#Description#</td></tr>
	  </table>	 
	 </td>
 
   </cfif>	 
	 
   <cfset No = No+1>   
   			 		 
	 <cfloop index="EditionId" list="#EditionList#" delimiters=",">
	 		    			 
		 <cfquery name="Check" 
          datasource="AppsProgram" 
          username="#SESSION.login#" 
          password="#SESSION.dbpw#">
	          SELECT     *
	          FROM       Ref_AllotmentEdition
	          WHERE      EditionId = '#EditionId#'	   
         </cfquery>
		 
		 <cfif Edition.status eq "1">
	
				<!--- edition is open, so check for both roles --->
			
				<cfinvoke component="Service.Access"  
					Method         = "budget"
					ProgramCode    = "#URL.ProgramCode#"
					Period         = "#URL.Period#"	
					EditionId      = "'#editionId#'"  
					Role           = "'BudgetManager','BudgetOfficer'"
					ReturnVariable = "BudgetAccess">	
			
		 <cfelse>
			
				<!--- edition is locked, so check for one role only --->
			
				<cfinvoke component="Service.Access"  
					Method         = "budget"
					ProgramCode    = "#URL.Program#"
					Period         = "#URL.Period#"	
					EditionId      = "'#editionId#'"  
					Role           = "'BudgetManager'"
					ReturnVariable = "BudgetAccess">	
			
		 </cfif>
		 
		 <cfquery name="FundList" 
          datasource="AppsProgram" 
          username="#SESSION.login#" 
          password="#SESSION.dbpw#">
	          SELECT     *
	          FROM       Ref_AllotmentEditionFund
	          WHERE      EditionId = '#EditionId#'	   
         </cfquery>
		 
		 <cfif FundList.recordcount eq "0">
		 
			 <td class="labelmedium"><font color="FF0000">No fund defined for this edition. Please contact administator</font></td>
			 <cfabort>
		 
		 </cfif>
		 
		 <cfset val = "Edition_#EditionId#_#FundList.Fund#">
				 		 
		 <td align="right">	
		  			 
			 <table cellspacing="0" cellpadding="0">
			 <tr>		
			 
			 <!--- this is defined in AllotmentInquiryCost line 111 --->			  			 
			 						 
			 <cfif evaluate("e#editionid#mode") eq "1">		
			 			
			 		<cfif Check.BudgetEntryMode eq "0">		
					
					    <!--- entry of the detail requirements is enabled so we just show objects to be selected here --->
												
						<td align="right"> 
																							
						<table cellspacing="0" cellpadding="0">
							<tr>
							
								<cfloop query="FundList">
								
									<cfset val = evaluate("result.Edition_#EditionId#_#Fund#")>
																											
									<cfif Parameter.BudgetAmountMode eq "0">
										<cf_numbertoformat amount="#val#" present="1" format="number0">
									<cfelse>
										<cf_numbertoformat amount="#val#" present="1000" format="number1">
									</cfif>
									
									<td align="right" width="30" style="padding-left:3px">
																 																								 					
								 	<cfif val neq "0" and val neq "">					
																				
										<input type="checkbox" name="Show_#No#" checked style="height:13px;width:13px" class="enterastab" value="#Result.Code#" onclick="ColdFusion.navigate('AllotmentListingObject.cfm?programcode=#url.programcode#&objectcode=#result.Code#&fund=#fund#&editionid=#editionid#&select='+this.checked,'object','','','POST','entry')">	
									
									<cfelse>
																					 
										<cfquery name="Checking" 
										datasource="AppsProgram" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT *
											FROM  ProgramObject
											WHERE ProgramCode = '#URL.ProgramCode#'
											AND   ObjectCode  = '#Result.Code#'		
											AND   Fund        = '#Fund#'		   
										 </cfquery>		
																												 					 
								 	 	<input type="checkbox" class="enterastab" style="height:13px;width:13px" onclick="ColdFusion.navigate('AllotmentListingObject.cfm?programcode=#url.programcode#&objectcode=#result.Code#&fund=#fund#&select='+this.checked,'object','','','POST','entry')" name="Show_#No#" value="#Result.Code#" <cfif checking.recordcount gte "1">checked</cfif>>		 
									 
									</cfif> 	
																	
								</td>			 
																											
									<td align="right" style="padding-left:3px;padding-right:3px">
																		
										<cf_space spaces="20">
																																
									     <input type="Text" 
										     name="i#EditionId#_#Fund#_Amount_#No#"   
											 value="#val#" 
											 message="#vAmount#" 
											 style="border:0px;border-left:1px solid silver;border-right:1px solid silver;font-size:13px;height:22px;padding-top:2px;padding-right:3px;text-align:right"
											 validate="float"
											 class="regularxl enterastab" 
											 required="No" 
											 size="8" 
											 maxlength="10">	
											 
									</td>	 
									
									 <input type="hidden" name="i#EditionId#_#fund#_AmountPrior_#No#" id="i#EditionId#_#fund#_AmountPrior_#No#" value="#val#">									 
							 		 <input type="hidden" name="i#EditionId#_#fund#_Code_#No#"        id="i#EditionId#_#fund#_Code_#No#"        value="#Result.Code#">
									 
								</cfloop>	
							</tr>
						</table> 
													 
						 </td>	 
							 
					 <cfelse>
					 
					 	<!--- date entry and selection is enabled here --->
												 
					    <td id="#Editionid#_#Code#_total" 
						 align="right" 
						 class="regular"
						 style="cursor: pointer;" 
						 onmouseover="if (this.className=='regular') {this.className='highlight2'}"
						 onmouseout="if (this.className=='highlight2') {this.className='regular'}">						
						 
						 <!--- ---------------------- --->
						 <!--- START replacable cell- --->
						 <!--- ---------------------- --->
						 
						 <table cellspacing="0" cellpadding="0" style="cursor: pointer;">
						 
						 		<tr>
																						
								<td align="right" style="padding-left:5px"></td>								
																
								<cfset cde = code>
								
								<cfloop query="FundList">								
									
									<cfset val = "#evaluate('result.Edition_#EditionId#_#Fund#')#">									
									<cfif val eq "">
									   <cfset val = 0>
									</cfif>
																		
									<td align="right" width="30" style="padding-left:3px">
							 													 					
								 	<cfif evaluate(val) neq "0" and evaluate(val) neq "">					
																				
										<input type="checkbox" name="Show_#No#" style="height:12px;width:12px" class="enterastab" value="#Result.Code#" checked onclick="ColdFusion.navigate('AllotmentListingObject.cfm?programcode=#url.programcode#&objectcode=#result.Code#&fund=#fund#&editionid=#editionid#&select='+this.checked,'object','','','POST','entry')">	
									
									<cfelse>
																					 
										<cfquery name="Checking" 
										datasource="AppsProgram" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT *
											FROM  ProgramObject
											WHERE ProgramCode = '#URL.ProgramCode#'
											AND   ObjectCode  = '#Result.Code#'		
											AND   Fund        = '#Fund#'		   
										 </cfquery>		
																												 					 
								 	 	<input type="checkbox" class="enterastab" style="height:12px;width:12px" onclick="ColdFusion.navigate('AllotmentListingObject.cfm?programcode=#url.programcode#&objectcode=#result.Code#&fund=#fund#&select='+this.checked,'object','','','POST','entry')" name="Show_#No#" value="#Result.Code#" <cfif checking.recordcount gte "1">checked</cfif>>		 
									 
									</cfif> 	
																			
									<cfif Parameter.BudgetAmountMode eq "0">
										<cf_numbertoformat amount="#val#" present="1" format="number">
									<cfelse>
										<cf_numbertoformat amount="#val#" present="1000" format="number1">
									</cfif>
									
									<td align="right" style="padding-right:5px" class="labelmedium" onclick="alldet('#Editionid#_#Cde#','#editionid#','#cde#');">
									    <cf_space spaces="18">#val#											
									</td>										
									
								</cfloop>	
								
								</tr>
							
						</table> 		
							
						 <!--- ------------------- --->
						 <!--- END replacable cell --->
						 <!--- ------------------- --->		
							 			 
						 </td>							
					 					 
					 </cfif>					 
					  		 	 
			 <cfelse>
				 
				 	<td align="right">
					 <table cellspacing="0" cellpadding="0">
						 <tr> 
						 
						 <cfloop query="FundList">
						 
						    <cfset val = "#evaluate('result.Edition_#EditionId#_#Fund#')#">
							<cfif val eq "">
							   <cfset val = 0>
							</cfif>
									
							<cfif Parameter.BudgetAmountMode eq "0">
								<cf_numbertoformat amount="#val#" present="1" format="number">
							<cfelse>
								<cf_numbertoformat amount="#val#" present="1000" format="number1">
							</cfif>
						 	
						    <td align="right" style="padding-right:3px" class="labelmedium">
							
							   <cf_space spaces="19">
							   #val#
							   
							   <input type="hidden" 
								     name="i#EditionId#_#Fund#_Amount_#No#" id="i#EditionId#_#Fund#_Amount_#No#"  
									 value="#val#" 
									 class="regularxl enterastab"
									 message="#vAmount#" 
									 validate="float" 
									 stylw="text-align:right"
									 required="No" 
									 size="10" 
									 maxlength="10">			
									 
							</td> 
							 <input type="Hidden" name="i#EditionId#_#fund#_AmountPrior_#No#" id="i#EditionId#_#fund#_AmountPrior_#No#" value="#val#">
							 <input type="Hidden" name="i#EditionId#_#fund#_Code_#No#" id="i#EditionId#_#fund#_Code_#No#" value="#Result.Code#">
						</cfloop>	
						
						</tr>
					 </table>  							 
					</td> 
					 
			 </cfif>
				 
			 </tr>
			 </table>
			
		 </td>
		 		 
	 </cfloop>
	 
   </tr> 
   
   <!---   
   <cfif Check.BudgetEntryMode eq "1">
   --->
   
   	<cfloop index="EditionId" list="#EditionList#" delimiters=",">
   
	   <tr id="#Editionid#_#Code#" class="hide">
	   		<td colspan="#Edition.recordcount+2#" >
				<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
					<tr><td id="box#Editionid#_#Code#"></td></tr>
				</table>
			</td>
	   </tr>
	   
	 </cfloop>  
   
   <!---
   </cfif>
   --->

</cfoutput>
</cfoutput>
</cfoutput>

<cfoutput>


<tr><td height="1" colspan="#Edition.recordcount+2#" class="line"></td></tr>

</cfoutput>

<tr><td height="2"></td></tr>

</table>

<cfoutput>
	<input type="Hidden" name="No"      id="No"        value="#No#">
	<input type="Hidden" name="Edition" id="Edition"   value="#EditionList#">
	<input type="Hidden" name="Program" id="Program"   value="#URL.ProgramCode#">
	<input type="Hidden" name="Version" id="Version"   value="#URL.Version#">
	<input type="Hidden" name="Period"  id="Period"    value="#URL.Period#">
	<input type="Hidden" name="Fund"    id="Fund"      value="#URL.Fund#">
</cfoutput>

