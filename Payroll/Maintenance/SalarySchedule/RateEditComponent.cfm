
<table style="width:100%"  cellspacing="0" cellpadding="0" height="100%">

<cfquery name="CurrencyList"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Currency
</cfquery>

<cfif Component.recordcount eq "0">

	<table><tr><td class="labellarge">
	
	  Schedule has not been enabled for components 
	  
	  </td></tr></table>
	
<cfelse>

	
	<cfset w = 80/Component.recordcount>
					
	<cfquery name="PostGrade"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
    	SELECT   *
		FROM     SalaryScheduleServiceLevel P, 
		         Employee.dbo.Ref_PostGrade R
		WHERE    P.ServiceLevel   = R.PostGrade		
		AND      P.SalarySchedule = '#url.schedule#'
		ORDER BY R.PostOrder
	</cfquery>			

        <cfset init="false">
	
	    <!--- header 1 --->
		
		<tr class="labelmedium" style="height:20px">
		   <td valign="top" style="padding-top:4px;min-width:80px"><!---<b><cf_tl id="Step">---></td>
		   
		   <cfoutput query="Component">
		   
		     <cfquery name="getCurrency"
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    SELECT  TOP 1 *
				FROM    SalaryScaleLine
				WHERE   ScaleNo        = '#Scale.ScaleNo#' 				
				AND     ComponentName  = '#ComponentName#'							
     		</cfquery>		
			
			<cfif getCurrency.recordcount gte "1">
					
    			 <cfset curr = getCurrency.Currency>
				 
			<cfelse>
						
				 <cfquery name="schedule"
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    SELECT  TOP 1 *
					FROM    SalarySchedule
					WHERE   SalarySchedule = '#Scale.SalarySchedule#'						
	     		</cfquery>		
								
			     <cfset curr = schedule.PaymentCurrency>
				 
			</cfif>		
		   
		   <td valign="top" style="border-bottom:1px solid silver;border-top:1px solid silver;padding-right:2px;border-right:1px solid silver;border-left:1px solid silver;padding-left:2px">
		   
		   <table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">		
		    
			   <tr class="labelit line">
			   <td height="20" align="center" style="cursor:pointer;min-width:80px;word-break: break-all;">
				   <cf_UItooltip  tooltip="#ComponentName# #Description#">#left(ComponentName,12)#</cf_UItooltip>
			   </td>
			   </tr> 
			   
			   <tr><td align="center">
			   
			   <table><tr class="labelit"><td>
			   
			    <cfset cp = "#replace(ComponentName,' ','','ALL')#">
			    <cfset cp = "#replace(cp,'-','','ALL')#">
				
			   	<select name="Currency_#cp#" style="font:10px">
				  <cfloop query="CurrencyList">
				    <option value="#Currency#" <cfif Currency eq curr>selected</cfif>>#Currency#</option>
				  </cfloop>
				</select>	
				
				<input type="hidden" name="Currency_#cp#_old" id="Currency_#cp#_old" value="#getCurrency.Currency#">
						   
			   </td>	
			   <td style="padding-left:2px">/#left(Period,1)#</td>
			   </tr>
			   </table>
			   
			   </td>
			   </tr> 		  
		   </table>
		   </td>
		   </cfoutput>
		   
		   <td style="width:29px"></td>
		   
		</tr>			
		
		<!--- header 2 --->
				
		<tr style="height:35px">
		   <td width="40" align="center"></td>
		  
		  <cfset pGrade=PostGrade.PostGrade>

		   <cfoutput query="Component">
		   
			   <td align="right" style="padding-top:3px">
			   
			   	<table cellspacing="0" cellpadding="0" align="right" class="formpadding">
				    <tr><td style="border:1px solid silver;padding:4px">		   		           
				   		   <cfset cp = "#replace(ComponentName,' ','','ALL')#">
						   <cfset cp = "#replace(cp,'-','','ALL')#">
				   			   
						   <cfset gr = "#replace(pGrade,'-','')#">
						   <cfset gr = "#replace(gr,' ','')#">								          
						   <img src="#session.root#/Images/copy4.gif" alt="Inherit to all levels" height="13" width="13" border="0" onclick="populateall('#gr#_1_#cp#','_#cp#')">					   
					   </td>				   
					   <td style="padding-left:4px;border:1px solid silver;padding:4px">					 
						   <img src="#session.root#/Images/delete5.gif" alt="Delete to all levels" height="13" width="13" border="0" onclick="deleteall('_1_#cp#','_#cp#')">				  				   
				       </td>
				   </tr> 		 
				   </table>
				   
			   </td>
		   
		   </cfoutput>
		   
		   <td style="width:23px"></td>
		   
		</tr>	
		
		<tr>
		
		<td colspan="<cfoutput>#component.recordcount+2#</cfoutput>" valign="top" style="width:99%;height:99%">
						
		<cf_divscroll overflowy="scroll">
						
			<table style="width:98.7%;height:100%">		
						
			<cfoutput query="PostGrade">		
				
				<cfset gr = "#replace(PostGrade,'-','')#">
				<cfset gr = "#replace(gr,' ','')#">				
							
			    <tr style="border-bottom:1px solid silver">
					<td width="100%" colspan="#component.recordcount+2#">
					
					    <table width="100%" cellspacing="0" cellpadding="0">
						<tr><td align="center" width="40">
					
						<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
						id="#gr#Exp" border="0" class="regular" 
						align="absmiddle" style="cursor: pointer;" 
						onClick="maximize('#gr#')">
						
						<img src="#SESSION.root#/Images/arrowdown.gif" 
						id="#gr#Min" alt="" border="0" 
						align="absmiddle" class="hide" style="cursor: pointer;" 
						onClick="maximize('#gr#')">
											
						</td>
						<td style="height:32px; font-size:18px; font-weight:200" class="labelmedium"><a href="javascript:maximize('#gr#')">#PostGrade#</font></a></td></tr>
						</table>
						
					</td>
					
				</tr>
																				
				<cfset grade = Postgrade>
				
				<!--- show all the steps --->		
													
				<cfloop index="st" from="1" to="#PostGradeSteps#" step="1">
							   
					<cfset stl = "border-bottom:1px solid silver;height:20px">				
				
					<tr name="#gr#" id="#gr#" class="hide" style="#stl#">
					
					<td style="min-width:80px;padding-left:5px;padding-right:5px" class="labelit" align="center"><cfif st lt 10>0</cfif>#st#</td>
					
						<!--- August 29th moved the query to make the screen load a factor 4 faster --->
					
					    <cfquery name="AmountList"
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
							FROM   SalaryScaleLine
							WHERE  ScaleNo       = '#Scale.ScaleNo#' 
							AND    ServiceLevel  = '#grade#'
							AND    ServiceStep   = '<cfif st lt 10>0</cfif>#st#'	
							AND    Operational = '1'									
						</cfquery>		
											
						<cfset comp = StructNew()>
						
						<cfloop query="AmountList">
																
							<cfset name = replace(componentname," ","","ALL")>
							<cfset name = replace(name,"-","","ALL")>
							<cfset name = replace(name,",","","ALL")>
							<cfset comp["#name#"] = amount>
										
						</cfloop>
										
					<cfloop query="Component">
																				
						<cfset name = replace(componentname," ","","ALL")>
						<cfset name = replace(name,"-","","ALL")>
						<cfset name = replace(name,",","","ALL")>												
						<cfparam name="comp.#name#" default="0">
															
						<cfset amt = evaluate("comp.#name#")>
						
						<cfset cp = "#replace(ComponentName,' ','','ALL')#">
						<cfset cp = "#replace(cp,'-','','ALL')#">
						
						<cfif RateStep eq "0" and st gt "1">
						
								<td align="right" style="background-color:e1e1e1;padding-right:2px;border-left:1px solid silver;padding-left:2px">
								<!--- hide --->		
								<!---				
								<input type="hidden" name="#gr#_#st#_#cp#_old" value="#amt#">							
								--->
								</td>
							
						<cfelse>		
																				
								<cfif RateComponentName eq ""> 			
								
								<td align="right" style="padding-right:4px;border-left:1px solid silver;">
									
									<cfif schedule.paymentRounding eq "2">
								
										<cfset amt = "#numberformat(amt,',.__')#">
									
									<cfelse>
									
										<cfset amt = "#numberformat(amt,',')#">
									
									</cfif>
																														
									<cfinput type="Text"
								       name="#gr#_#st#_#cp#"							   
								       message="Please enter a valid amount"
								       validate="float"
									   value="#amt#"
								       required="No"
								       visible="Yes"
								       enabled="Yes"							   							       
									   maxlength="20"
									   style="border:0px solid silver;text-align:right;width:97%;font-size:11px!important;"
								       class="amount2 enterastab regularh"/>
									   
									   <input type="hidden"  name="#gr#_#st#_#cp#_old" value="#amt#">
								   
								 </td>  
								   
								 <cfelse>
								 
									 <td align="right" style="font-size:13px;background-color:ffffcf;padding-right:2px;border-left:1px solid silver;">								
									 	 #numberformat(amt,'.__')#							 
									 </td>							 
								 
								 </cfif>  
													  
						</cfif>	  
			
						</cfloop>
					</tr>
					
				    <cfif init eq "false">
						<cfset init="true">
					</cfif>		
					
					</cfloop>
					
												
			</cfoutput>
			
			<tr><td height="100%"></td></tr>
			
			</table>
		
		</cf_divscroll>
				
		</td>
		
		</tr>
		
    </cfif>		
	
</table>