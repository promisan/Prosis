
<cfparam name="URL.Mode" default="supervisor">
<cfparam name="URL.Period" default="">

<cfinclude template="CreatePASAccessWorkflow.cfm">

<cf_screentop html="No" jquery="Yes">
<cf_dialogstaffing>

<cfoutput>
	
	<script>
	
		function present(mode, id) {	     		  		  
				w = #CLIENT.width# - 100;
				h = #CLIENT.height# - 140;
				
				templatepath = 'ProgramREM/Reporting/Document/PAS/PAS.cfm';
				
				if (templatepath != "") {			   
					window.open("#SESSION.root#/"+templatepath+"?id="+id,"_blank", "left=30, top=30, width=800, height=700, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");
				} else {
					alert("No format selected");
				}	  
			} 
	
		function mypas(per,cde,fun,mis) {
			ptoken.open('#SESSION.root#/ProgramREM/Portal/Workplan/PASView/ListingPAS.cfm?id='+per+'&personno='+per+'&mission='+mis,'_self')
		}
	
		function supervisor(per,cde,fun) {
			ptoken.open('#SESSION.root#/ProgramREM/Portal/Workplan/PASView/ListingSupervisor.cfm?personno=#url.personno#&period=#url.period#&function=#url.function#','_self')
		}
		
	</script>
	
</cfoutput>
		
		<table width="100%" 
		      border="0"
			  height="100%"
			  cellspacing="0" 
			  cellpadding="0" 
			  align="center" 
		      bordercolor="d4d4d4">	  	
			  
			   <tr><td height="10" valign="top">
			   					    
						<cfset client.stafftoggle = "close"> 	
						<cfset url.id = url.personno>
						<cfinclude template="../../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">
						
			     </td></tr>	
		 		
				<tr>
				    <td  style="padding:10px;" valign="top" height="100%" id="result">
									
					<img src="<cfoutput>#session.root#/Images/Logos/Payroll/Settlement.png</cfoutput>" style="height:65px;float:left;">
					
        <h1 style="float:left;color:#333333;font-size:28px;font-weight:200;padding-top:10px;"><cf_tl id="#url.function#"></strong></h1>
        <p style="clear: both; font-size: 15px; margin: 3% 0 0 1%;">Check status and follow up with your staff.</p>
		
        <div class="emptyspace" style="height: 4px;"></div>		
		
				<table width="100%" height="100%">
					<tr class="labelmedium line">
					
					<td height="10" style="padding-left:6">
					<cfoutput>
					<table width="100%">
					<tr><td style="padding-left:10px">		
								
					<cfquery name="Period" 
							datasource="appsePas" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT    *
							FROM      Ref_ContractPeriod
							WHERE	    Code = '#url.period#'						   
					</cfquery>	
									
					<font size="5">Appraisal #Period.Mission# #Period.Code#</font>					
					&nbsp;#dateformat(Period.PASPeriodStart,client.dateformatshow)# - #dateformat(Period.PASPeriodEnd,client.dateformatshow)#					
					
					</td>
					<td valign="bottom" align="right" class="labelmedium" style="padding-bottom:4px;padding-right:26px">
					  <table>
					    <tr class="labelmedium2">
						<td style="padding-right:6px;font-size:17px">
					  	<a href="javascript:Prosis.busy('yes');mypas('#url.personno#','#url.period#','#url.function#','#Period.Mission#')"><cf_tl id="My Own PAS"></a>
						</td>
						<td>|</td>
					    <td style="padding-left:6px;font-size:17px">
					  	<a href="javascript:Prosis.busy('yes');supervisor('#url.personno#','#url.period#','#url.function#')"><cf_tl id="Refresh"></a>
						</td>
						</tr>
						</table>
					</td>
					</tr></table>
					
					</cfoutput>
					
					</td></tr>
					
					
					<tr>
					<td width="100%" height="100%" style="padding:20px;padding-right:30px">
					
					<cf_divscroll>
					
					<table class="navigation_table" width="98%">
										
						<cfquery name="Staff" 
							datasource="appsePas" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT    C.Mission,
									  C.ContractId, 
							          C.ContractNo, 
									  G.Description as ContractClassDescription,
									  C.OrgUnitName, 
									  C.FunctionDescription, 
									  CA.RoleFunction,
									  C.ActionStatus, 
									  P.PersonNo,
									  P.IndexNo, 
									  P.LastName, 
									  P.FirstName, 
									  P.Gender, 
									  P.Nationality, 
									  C.DateEffective, 
									  C.DateExpiration
						   FROM       Contract AS C INNER JOIN
				                      ContractActor AS CA ON C.ContractId    = CA.ContractId INNER JOIN
	             				      Employee.dbo.Person AS P ON C.PersonNo = P.PersonNo INNER JOIN
									  Ref_ContractClass G ON C.ContractClass = G.Code
							WHERE     CA.PersonNo     = '#url.personno#'
							AND       C.Period        = '#url.period#'		
							AND       CA.RoleFunction = '#url.function#'	
							AND       CA.ActionStatus = '1'			
							ORDER BY  P.LastName
						</cfquery>	
						
						<tr class="labelmedium2 line fixrow">
							<td style="background-color:ffffff"></td>
							<td style="background-color:ffffff"></td>
							<td style="background-color:ffffff"><cf_tl id="Name"></td>							
							<td style="background-color:ffffff"><cf_tl id="IndexNo"></td>
							<td style="background-color:ffffff"><cf_tl id="G"></td>
							
							<td style="background-color:ffffff"><cf_tl id="Section / Unit"></td>
							<td style="background-color:ffffff"><cf_tl id="Functional Title"></td>
							<td style="background-color:ffffff"><cf_tl id="Class"></td>
							<td style="background-color:ffffff"><cf_tl id="Status"></td>
						</tr>
						
						<cfoutput query="Staff">
						
						<tr class="labelmedium2 navigation_row line">
							<td style="padding-left:8px">
							
							<cfif actionStatus gte "5">
							
							 <table>
								 <tr class="labelmedium" bgcolor="red">
								 	<td class="navigation_action" style="text-align:center;min-width:120px;color:white;padding:5px"><cf_tl id="Stalled"></td>
								 </tr>
							 </table> 
							 
							 <cfelse>
							 
							  <cfif url.personNo eq PersonNo>
							  
							  <table>
									 <tr class="labelmedium">
									 	<td class="navigation_action" style="text-align:center;min-width:120px;color:red;padding:5px"><cf_tl id="Incorrect"><cf_tl id="#RoleFunction#"></td>
									 </tr>
								</table>  
							  	
							  
							  <cfelse>
							 
							  	<table>
									 <tr class="labelmedium" bgcolor="1D61A5">
									 	<td class="navigation_action" style="text-align:center;min-width:120px;color:white;padding:5px" onClick="pasdialog('#ContractId#','#mode#')"><cf_tl id="Open"></td>
									 </tr>
								</table>   	
								
							  </cfif>		
									 
							  </cfif>		 
							
							</td>
							
							<td width="5%">
								<table>
									<tr>									
										
										<td style="padding-left:10px;">
											<img src="#SESSION.root#/images/pdfform.png" style="height:20px;" align="absmiddle" onclick="present('PDF','#ContractId#');">
										</td>										
									</tr>
								</table>
							</td>
									
							<td>#LastName#, #FirstName#</td>							
							<td><a href="javascript:EditPerson('#PersonNo#')">#IndexNo#</a></td>
							<td style="padding-left:4px;padding-right:4px">#Gender#</td>								
							<td>#OrgUnitName#</td>
							<td>#FunctionDescription#</td>
							<td style="padding-right:4px">#ContractClassDescription#</td>
							<td style="min-width:100px;padding-right:5px">
							
							<cfif actionStatus eq "3">
							
								<table width="100%">
									<tr>									
									<td style="height:18px;width:20px;border:1px solid gray;background-color:lime"</td>													
									</tr>
								</table>
							
							<cfelse>
							
								<cfquery name="Section" 
									datasource="appsePas" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT      R.Description, 
									            R.DescriptionTooltip, 
												CS.ProcessStatus
									FROM        ContractSection AS CS INNER JOIN
						                        Ref_ContractSection AS R ON CS.ContractSection = R.Code
									WHERE       CS.ContractId = '#contractId#'
									AND         CS.Operational = 1
									ORDER BY    R.ListingOrder
								</cfquery>	
							
								<table width="100%">
									<tr>
									
									<cfloop query="section">										
									<td style="height:18px;border:1px solid gray;<cfif ProcessStatus eq "1">background-color:lime</cfif>">									
									<cf_UIToolTip tooltip="#DescriptionTooltip#"/></td>
									</cfloop>												
									</tr>
								</table>
							
							</cfif>
															
							
							</td>						
						</tr>
						
						</cfoutput>
									
					</table>
					
					</cf_divscroll>
										
					</td></tr>
											
					</table>
					
				    </td>
				</tr>
								
		</table>
	

<cfset ajaxonload="doHighlight">
<script>
	Prosis.busy('no')
</script>

