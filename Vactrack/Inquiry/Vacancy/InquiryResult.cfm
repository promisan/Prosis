<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop height="100%" jquery="yes" scroll="Yes" html="No">

<cfinclude template="../../Application/Document/Dialog.cfm">

<cf_dialogStaffing>
<cf_dialogPosition>

<cfparam name="URL.IDSorting"    default="PostGrade">
<cfparam name="URL.Page"         default="1">
<cfparam name="URL.FileNo"       default="1">

<!--- Query returning search results --->
<cfquery name="SearchResult"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT 
	       D.DocumentNo, 
	       D.Mission, 
		   D.PostNumberTrigger, 
		   D.FunctionalTitle, 
		   D.PostGrade, 
		   D.DueDate,
		   D.DocumentStatus,
		   
			(SELECT TOP 1 ReferenceNo 
			 FROM   Applicant.dbo.FunctionOrganization 
			 WHERE  DocumentNo = D.DocumentNo) as ReferenceNo,
						
			(SELECT count(*) 
			 FROM   Vacancy.dbo.DocumentPost 
			 WHERE  DocumentNo = D.DocumentNo) as Posts,
			 
			(SELECT TOP 1 PostNumber 
			 FROM   Vacancy.dbo.DocumentPost 
			 WHERE  DocumentNo = D.DocumentNo) as PostNumber,
			 
			(SELECT TOP 1 PositionNo 
			 FROM   Vacancy.dbo.DocumentPost 
			 WHERE  DocumentNo = D.DocumentNo) as PositionNo
			 
			 					
	FROM     #SESSION.acc#Document#url.FileNo# D 	
    ORDER BY #URL.IDSorting# 
	
</cfquery>

<cfset counted = SearchResult.recordcount>
	
	
<script>

	function reloadForm(group,page) {
    	 ptoken.location('InquiryResult.cfm?fileNo=<cfoutput>#URL.FileNo#</cfoutput>&IDSorting=' + group + '&Page=' + page)
	}

	function search() {
		ptoken.location('InquiryForm.cfm')
	}
	
</script>	
	
<table style="width:97%" align="center" height="100%">
  <tr class="line">
   <td height="25" style="padding-top:40px;">
    
	   	<table>		
		<tr class="labellmedium">
			<td style="font-size:30px;padding-left:4px;font-weight:200"><cf_tl id="Recruitment Track"></td>
			<td style="padding-left:14px;padding-top:5px;" class="labelmedium">
			   <a href="javascript:search()"><cf_tl id="New search"></a>
			</td>
			<td style="padding-left:4px">
				<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/search_next.gif" alt="New Search" border="0" align="absmiddle">		
			</td>
		</tr>	   
	   </table>
   
   </td>
   <td align="right" style="padding-top:40px;;padding-right:5px">
      
	   <select name="group" size="1" class="regularxxl" onChange="javascript:reloadForm(this.value,page.value)">
	    	 <option value="DueDate"    <cfif URL.IDSorting eq "Duedate">selected</cfif>>Group by Due date
		     <OPTION value="Mission"    <cfif URL.IDSorting eq "Mission">selected</cfif>>Group by Mission
		     <OPTION value="PostGrade"  <cfif URL.IDSorting eq "PostGrade">selected</cfif>>Group by Post grade
			 <OPTION value="DocumentNo" <cfif URL.IDSorting eq "DocumentNo">selected</cfif>>Sort by Document No
		</SELECT> 
	
		<cf_PageCountN count="#counted#">
		 
		<cfif pages eq "1">
		
			<input type="hidden" name="page" value="1">
		
		<cfelse>
		   
			<select name="page" size="1" class="regularxxl" onChange="reloadForm(group.value,this.value)">
			    <cfloop index="Item" from="1" to="#pages#" step="1">
		    	    <cfoutput><option value="#Item#"<cfif URL.page eq Item>selected</cfif>>Page #Item# of #pages#</option></cfoutput>
			    </cfloop>	 
			</SELECT>   
		
		</cfif>
		    
	</td>
   </tr> 	

<td colspan="2">

<cf_divscroll>

	<table style="width:98.5%" class="navigation_table">
	
	<tr class="line labelmedium2 fixrow">
	    <TD height="23" width="4%" align="center"></TD>
	    <TD width="4%"></TD>
	    <TD width="100"><cf_tl id="Track"></TD>
		<td width="35%"><cf_tl id="Function"></td>
		<TD width="15%"><cf_tl id="Grade"></TD>
	    <TD width="10%"><cf_tl id="Entity"></TD>
	    <TD width="12%"><cf_tl id="Position"></TD>
		<td style="padding-right:3px"><cf_tl id="Reference"></TD>		
	</TR>
	
	<cfset currrow = 0>
	
	<cfoutput query="SearchResult" group="#URL.IDSorting#">
	
	               <cfset currrow = currrow + 1>
	  
	   			   <cfif currrow gte first and currrow lte Last>	
		    
			       <tr><td height="4"></td></tr>
				   <tr class="labelmedium2 line fixrow2">
				   <cfswitch expression = #URL.IDSorting#>
				     <cfcase value = "Duedate">
				     <td height="24" style="height:45px;font-size:23px; padding-left:10px" colspan="8">#Dateformat(Duedate, "#CLIENT.DateFormatShow#")#</b></font></td>
				     </cfcase>
				     <cfcase value = "Mission">
				     <td height="24" style="height:45px;font-size:23px;padding-left:10px" colspan="8">#Mission#</b></font></td> 
				     </cfcase>	
				     <cfcase value = "DocumentNo">
				     <td height="24" style="height:45px;font-size:23px;padding-left:10px" colspan="8">#DocumentNo#</b></font></td>
				     </cfcase>	
				     <cfcase value = "PostGrade">
					 <td height="24" style="height:45px;font-size:23px;padding-left:10px" colspan="8">#PostGrade#</b></font></td>
				     </cfcase>
				   </cfswitch>
				   </tr>
				   			  			   
				   </cfif>
				   
				   <cfset currrow = currrow - 1>
				   			     
				    <CFOUTPUT>
					
					<cfset currrow = currrow + 1>
							
					<cfif currrow gte first and currrow lte Last>										
										
						<cfif documentStatus eq "9">
						 <cfset cl = "FFCAB0">	
						<cfelseif documentStatus eq "1">
						 <cfset cl = "f4f4f4">
						<cfelse>
						 <cfset cl = "ffffff"> 
						</cfif>		
								
					    <TR bgcolor="#cl#" style="height:24px" class="navigation_row labelmedium2">
						
						<cfif DocumentStatus eq "9">
							<td height="18" align="center">#currrow#.</td>
							<td width="20" align="center">
						<cfelse>
							<td height="18" align="center">#currrow#.</td>
							<td width="20" align="center" style="padding-left:3px;padding-top:2px">					
						</cfif>
											
						<cfif DocumentStatus eq "1">
						
						    <button type="button" class="button3 navigation_action" onClick="showdocument('#DocumentNo#')">
						     <img src="#client.virtualdir#/Images/validate.gif" alt="Completed and closed" border="0" align="absmiddle">
							</button>
							
						<cfelseif DocumentStatus neq "9">					
						
						    <cf_img icon="open" navigation="Yes" onClick="showdocument('#DocumentNo#')">										
							
						 </cfif>
						 
						</td> 
						
						<TD style="padding-left:9px;padding-right:4px">
						   <a href="javascript:showdocument('#DocumentNo#','ZoomIn')" title="Go to recruitment track">#DocumentNo#</a>
						</TD>
						
						<td style="padding-left:8px">#FunctionalTitle#</td>	
						<td>#PostGrade#</TD>
					    <td>#Mission#</TD>
					    <td width="30%">											
						
							<table width="99%" align="center">
							
							<tr><td>
							
								<table width="99%" align="center">
								
								<cfset c = 0>
								<cfset cnt = 1>
								<tr style="height:22px" class="labelmedium2">
								
								<cfif Posts gt "1">
								
								   <td><font size="1"><cf_tl id="Multiple"></font>: #Posts#</td>
								   
								<cfelseif Posts eq "1">
								
								   <cfquery name="getPost"
								     datasource="AppsVacancy" 
								     username="#SESSION.login#" 
								     password="#SESSION.dbpw#">
									    SELECT     PositionNo, PostNumber
									    FROM       DocumentPost
										WHERE      DocumentNo = '#DocumentNo#'
								    </cfquery>		
														
								   <td style="padding-top:3px">
								    <a title="View Position" href="javascript:EditPosition('','','#PositionNo#')">											 					
									 <cfif PostNumber neq "">#PostNumber#<cfelse>#PositionNo#</cfif>
									</a>
								   </td>
								   
								</cfif>
								</tr>
																			
								</table>
								
							</td></TR>
							</table>	
							
						</td>
						
						<TD style="padding-right:2px">#ReferenceNo#</TD>
						
					  </TR>
						
						<cfif documentStatus neq "9">
						
							<!--- Query returning search results --->
							<cfquery name="Person"
							datasource="AppsQuery" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT *
								FROM   #SESSION.acc#Document#url.FileNo#
								WHERE  DocumentNo = '#DocumentNo#'
						    </cfquery>
							
							<cfif Person.name neq "">
																
							<TR class="navigation_row_child">
								<td></td>
								<td></td>
								<td></td>						
								<td colspan="6" style="height:30">
								
								<table width="99%" align="center">
									   
									<tr><td style="padding-left:13px">
									
										<table>
										
										<cfset c = 0>
										<cfset cnt = 1>
																
											<cfloop query="Person">
												<cfif c eq "4">
												    <cfset c = 0>
													<tr>
												</cfif>
											    <cfif Name eq ""><td width="25%"><font color="gray">[<cf_tl id="no candidates">]</td>
												
												<cfelse>
												
													<cfif status eq "2s" or status eq "3">
														<td bgcolor="ffffaf" style="border: 1px solid gray;padding-right:6px;border-radius:4px">
															<cf_space spaces="52" class="labelmedium" label="#cnt#. #Name#" script="javascript:showdocumentcandidate('#DocumentNo#','#PersonNo#','0')">										 												
													<cfelse>
														<td bgcolor="f4f4f4" style="height:24px;border: 1px solid gray;padding-right:6px;border-radius:4px">																												   
															<cf_space spaces="52" class="labelmediumn" label="#cnt#. #Name#">												
														</TD>	
													</cfif>								
												 	</td>
													<td style="width:1px"></td>
																							
												</cfif>
												<cfset c =  c + 1>
												<cfset cnt = cnt + 1>
										    </cfloop>
											
											</tr>
															
										</table>
										
									</td></tr>
									</table>
									</td>
								</tr>
							
							</cfif>
						
						</cfif>		
						
						<tr class="line"><td colspan="9"></td></tr>													
																
					</cfif>
		
			</cfoutput>
				
	</CFOUTPUT>
	
	</TABLE>

</cf_divscroll>

</td>

</tr>

</TABLE>

</td>

</table>

<cf_screenbottom layout="webdialog">
 