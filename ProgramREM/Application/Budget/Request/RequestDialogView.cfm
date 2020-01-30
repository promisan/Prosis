
<!--- Attention : line 108 contains the saving box --->

<head>
<cfoutput>
<script type="text/javascript">
  // Change cf's AJAX "loading" HTML
  _cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy5.gif'/>";
</script>
</cfoutput>
</head>

<div id="dResult"></div>

<cf_screentop height="100%" html="No" scroll="Yes" JQuery="yes">

	<cfinclude template="RequestScript.cfm">
	<cf_dialogOrganization>
	<cf_calendarscript>	
	<cf_dialogREMProgram>
	<cf_dialogStaffing>
	<cf_dialogPosition>
	
	<cfoutput>
		
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr><td valign="top" style="padding-left:15px;padding-right:15px">
	
		<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
		
		<tr>
				
			<td valign="top" height="100%">
			
			    <cf_space spaces="70">
				<cf_tl id="Summary" var="1">			
				
				<cfquery name="Get" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					  SELECT *
					  FROM   Program
					  WHERE  ProgramCode = '#URL.ProgramCode#'		
				</cfquery> 
				
				<cfquery name="Period" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">							  
				  SELECT OrgUnit
				  FROM   Program.dbo.ProgramPeriod
				  WHERE  ProgramCode = '#url.ProgramCode#'		
				  AND    Period      = '#url.period#'										
				</cfquery>
							
				<cfquery name="GetRoot" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
					SELECT  Par.OrgUnit, Par.OrgUnitName, Par.OrgUnitNameShort, Par.HierarchyCode
					FROM    Organization AS O INNER JOIN
	                		Organization AS Par ON O.HierarchyRootUnit = Par.OrgUnitCode AND O.Mission = Par.Mission AND O.MandateNo = Par.MandateNo
					WHERE   O.OrgUnit = '#period.orgunit#'
					
				</cfquery> 
												
				<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				  					  		
				      <td style="height:25px;padding-left:5px;padding-top:4px" id="summaryselect">
						  <table cellspacing="0" cellpadding="0">
						  <tr>
						  
						  <cfif url.activityid neq "">
						      <td>						  
						      <input type="radio" name="summarymode" class="radiol"
						      onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/programrem/application/budget/request/RequestSummary.cfm?summarymode=activity&programcode=#url.programcode#&period=#url.period#&editionid=#url.editionid#&activityid=#url.activityid#','summary')"			
						      value="activity"></td>
						      <td class="labelit" style="padding-left:4px"><cf_tl id="Activity"></td>						  
						  </cfif>
						  
						  	<td style="padding-left:7px">						  
						      <input type="radio" name="summarymode" class="radiol"
						      onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/programrem/application/budget/request/RequestSummary.cfm?summarymode=program&programcode=#url.programcode#&period=#url.period#&editionid=#url.editionid#&activityid=#url.activityid#','summary')"			
						      value="program"></td>
						      <td class="labelit" style="padding-left:4px">#get.ProgramClass#</td>
							 							  
							  <td style="padding-left:7px"><input type="radio" name="summarymode" class="radiol" 
							  onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/programrem/application/budget/request/RequestSummary.cfm?summarymode=unit&programcode=#url.programcode#&period=#url.period#&editionid=#url.editionid#&activityid=#url.activityid#','summary')"					    
							  value="unit"></td>
							  <td style="padding-left:4px" class="labelit"><cf_tl id="Unit"></td>
							 							  
							   <td style="padding-left:7px"><input type="radio" name="summarymode" class="radiol" checked
							  onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/programrem/application/budget/request/RequestSummary.cfm?summarymode=parent&orgunit=#getroot.orgunit#&programcode=#url.programcode#&period=#url.period#&editionid=#url.editionid#&activityid=#url.activityid#','summary')"					    
							  value="unit"></td>
							  <td style="padding-left:4px" class="labelit"><cfif getRoot.OrgUnitNameShort neq "">#getRoot.OrgUnitNameShort#<cfelse><cf_tl id="Parent"></cfif></td>
							 
						  </tr>
						  </table>
				      </td>
				  </tr>
			
				  <tr><td style="padding:5px" colspan="2" valign="top" bgcolor="ffffff" id="summary" name="summary">
				      <cfset url.orgunit = getroot.orgunit>
					  <cfinclude template="RequestSummary.cfm">	  		  
				  </td></tr>			 		
				  <tr><td height="100%" colspan="2"></td></tr>  
				 
				</table>
			
			</td>	
			
			<td>&nbsp;</td>
			
			<td width="100%" height="100%" valign="top">
			
				<cf_space spaces="180">
			
				<cf_tl id="Requirements" var="1">			
						
				<cfquery name="Program" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    *
					FROM      Program P, ProgramPeriod Pe
					WHERE     P.ProgramCode  = Pe.ProgramCode
					AND       P.ProgramCode  = '#url.programcode#' 
					AND       Pe.Period      = '#url.period#' 	
				</cfquery>
				
				<table width="100%" cellspacing="0" cellpadding="0" border="0">
								
				   <!--- ----------------------------- --->				
				   <!--- ----------------------------- --->
				   <!--- ajax container for processing --->
				   <!--- ----------------------------- --->
				   
					<tr class="xxhide">
					   <td colspan="4" id="entrydialogsave"></td>
					</tr>
				   <!--- ----------------------------- --->
				   <!--- ----------------------------- --->
		
				  <tr class="labelmedium">
				   <td width="100%" style="height:30;padding-left:10px">
				   
				   <cfif Program.Reference neq "">#Program.Reference#<cfelse>#Program.ProgramCode#</cfif> - #Program.ProgramName# 
				   
				    <cfquery name="ProgramGroup" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    *
							FROM      ProgramGroup P, Ref_ProgramGroup G
							WHERE     P.ProgramGroup = G.Code
							AND       P.ProgramCode  = '#url.programcode#' 			
						</cfquery>
						
					   <cfif ProgramGroup.recordcount gte "1">	
					   						 						   			   	 				 
							<cfquery name="ProgramGroup" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT    *
								FROM      ProgramGroup P, Ref_ProgramGroup G
								WHERE     P.ProgramGroup = G.Code
								AND       P.ProgramCode  = '#url.programcode#' 					
							</cfquery>
							/ 
							<cfloop query="ProgramGroup">
							  <cfif currentrow gte "2">|&nbsp;</cfif>#Description#&nbsp;
							</cfloop>
											   
					   </cfif>		
				   
				   
				   <cfif Program.ReferenceBudget1 neq "">
					- #Program.ReferenceBudget1#-#Program.ReferenceBudget2#-#Program.ReferenceBudget3#-#Program.ReferenceBudget4#-#Program.ReferenceBudget5#-#Program.ReferenceBudget6#
				   </cfif>		
				   </b>	
				   
				 
				   	   
				   
				   </td>
				   <td align="right" style="padding-right:3px" width="23">
					
					<cf_space spaces="8">
					
					<img src="#SESSION.root#/images/toggle_up.png" 
					    id="locate_col"	
						height="20"
						width="20"
						align="absmiddle"
						onclick="toggle()"						
						class="regular">
						
					<img src="#SESSION.root#/images/toggle_down.png" 		    
						id="locate_exp"
						height="20"
						width="20"
						align="absmiddle"
						onclick="toggle()"							
						class="hide">
								
				</td>				  
				</tr>
				
				<cfinvoke component="Service.Process.Program.ProgramAllotment"  <!--- get access levels based on top Program--->
					Method         = "RequirementStatus"
					ProgramCode    = "#URL.ProgramCode#"
					Period         = "#URL.Period#"	
					EditionId      = "#URL.editionID#" 
					ReturnVariable = "RequirementLock">							
				
				  <tr><td colspan="2" class="line"></td></tr>
				  <tr class="regular" id="entrybox" name="entrybox">
				  <td colspan="2" valign="top" height="300" align="center" class="labelmedium" id="entrydialog" name="entrydialog">
				  
				     <cfif RequirementLock eq "1">
					       <font color="FF0000">
						   <br><b>Attention:</b><br><br>Project was locked for requirement definition by the Budget Manager
						   </font>
					 <cfelse>						
						  <cfinclude template="RequestDialogForm.cfm">	  
					 </cfif>	  
					  </td>
				  </tr>		  
				
				</table>
			
			</td>
			
			<script language="JavaScript">
		
			Number.prototype.formatMoney = function(decPlaces, thouSeparator, decSeparator) {
			    var n = this,
			    decPlaces = isNaN(decPlaces = Math.abs(decPlaces)) ? 2 : decPlaces,
			    decSeparator = decSeparator == undefined ? "." : decSeparator,
			    thouSeparator = thouSeparator == undefined ? "," : thouSeparator,
			    sign = n < 0 ? "-" : "",
			    i = parseInt(n = Math.abs(+n || 0).toFixed(decPlaces)) + "",
			    j = (j = i.length) > 3 ? j % 3 : 0;
			    return sign + (j ? i.substr(0, j) + thouSeparator : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + thouSeparator) + (decPlaces ? decSeparator + Math.abs(n - i).toFixed(decPlaces).slice(2) : "");
			};	
			
			function ItemTotalCalculate(tot, line) {
				var total = tot;		
				for (var i=1;i<25;i++) { 				    
					if (i!=line) {
						element = $('##total_'+i);						
						if (element.is(":visible")){							
							str = element.html();							
							if (str!='') {
								str = str.replace(/<(\/)?[D|d][I|i][V|v]([^>]*)>/g,"");								
								str = str.replace(/,/g,"");																
								if (parseFloat(str)) {	
								    temp = parseFloat(str)								
									total = total + temp;								
								}
							}													
						}	
					}				
				}		
										
				dtotal = document.getElementById('overall');				
				dtotal.innerHTML = '<div style="padding-top:3px;font-size:14">'+total.formatMoney(2,',','.');+'</div>';	
				
			}
					
			function toggle() {
			
				 up = document.getElementById("locate_col")				
				 dw = document.getElementById("locate_exp")				
				 s1 = document.getElementById("entrybox")				
				 s2 = document.getElementById("summary")	
				 s3 = document.getElementById("summaryselect")	
				 
				 if (s1.className == "regular") {
				    s1.className = "hide"
					s2.className = "hide"		
					s3.className = "hide"
					up.className = "hide"
					dw.className = "regular"
				 } else {
				    s1.className = "regular"
					s2.className = "regular"	
					s3.className = "regular"	
					up.className = "regular"
					dw.className = "hide"
				 }			
			}
			
			</script>
							
		</tr>
		
		<cfif snapshot.recordcount gte "1">
			<cfset col = "3">
		<cfelse>
			<cfset col = "2">
		</cfif>		
		
		</table>
	
	</td></tr>
	
	<tr><td colspan="#col#">
		
		<cfif RequirementLock eq "1">
		
		<cfelse>
		
			<cf_tl id="Recorded Transactions" var="1">
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">		  	 
			  <tr><td colspan="2" id="details" name="details" style="padding-left:10px;padding-right:10px">	 
			      <cfset url.scope    = "dialog">
				  <cfset url.period   = budgetperiod>
				  <cfinclude template = "RequestList.cfm">	  
			  </td></tr>
			</table>
					
		</cfif>	
	
	</td>
	</tr>
	
	</table>
	
	</cfoutput>
	
<!--- fill the position matrix --->	
	
<cfif isDefined("mode.BudgetEntryPosition")>
	<cfif mode.BudgetEntryPosition eq "1">
		
		<script>
			domatrix()
		</script>
		
	</cfif>		
</cfif>	