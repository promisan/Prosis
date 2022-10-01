
<cfparam name="url.back" default="1">

<cfif url.back eq "1">	
	<cf_screentop label="Roster Search Result" height="100%" jQuery="Yes" scroll="no" html="No">
<cfelse>
    <cf_screentop label="Roster Search Result" height="100%" jQuery="Yes" scroll="no" html="Yes" layout="webapp" >
</cfif>	

<cfparam name="url.print" default="0">
<cfparam name="url.docno" default="">

<cfif url.print eq "1">
	 <cfset access = "EDIT">
</cfif>

	<cfquery name="CheckDetail" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   RosterSearchLine R, 
	         FunctionOrganization F
	  WHERE  R.SearchId    = '#URL.ID1#'
	  AND    R.SearchClass = 'Function'
	  AND    R.SelectId    = F.FunctionId
	</cfquery>

<cfinclude template="ResultListingPrepare.cfm">

<cfajaximport>

<table width="100%" height="100%">
<tr><td style="width:100%;height:100%" class="clsPrintContent">
 
<form action="<cfoutput>#SESSION.root#/roster/rostergeneric/RosterSearch/ResultShortList.cfm?mode=#url.mode#&docno=#url.docno#&ID=#URL.ID#&ID1=#URL.ID1#&ID2=#URL.ID2#&ID3=#URL.ID3#</cfoutput>" 
	method="post" style="height:98%;padding-right:8px;padding-left:10px"
	name="resultlist">

<table width       = "98%"         
	   class       = "formpadding"
	   style       = "height:100%;padding-top:4px;padding-right:6px">
 
<input type="hidden" name="lay" id="lay" value="<cfoutput>#URL.Lay#</cfoutput>">

<cfif url.print eq "0">

<tr>
	<td height="20">	
		
		<table width="100%">
		<tr>
						
		<td>
		  
    	<cfoutput>
		
		<table width="100%">
		<tr class="labelmedium"><td style="height:20px"><cf_tl id="Search">:</td>
			<td style="height:20px;padding-left:10px"  class="labelmedium">#SearchAction.OfficerFirstName# #SearchAction.OfficerLastName# (#SearchAction.SearchId#)</b></td>
		</tr>
		<tr class="labelmedium"> 
			<td style="height:20px"><cf_tl id="Date">:</td>
			<td style="height:20px;padding-left:10px"  class="labelmedium">#DateFormat(SearchAction.Created)#</b>
		</tr>

		<cfif CheckDetail.recordcount eq "1">
		<tr class="labelmedium"><td style="height:20px"><cf_tl id="Document">:</td>
			<td style="height:20px;padding-left:10px"><cfif CheckDetail.DocumentNo neq "">
				  <a href="javascript: showdocument('#CheckDetail.DocumentNo#')">#CheckDetail.ReferenceNo#</a>
				<cfelse>
				  <a href="javascript: va('#CheckDetail.FunctionId#')">#CheckDetail.ReferenceNo#</a>
			</cfif>
		</td>
		</tr>	
		</cfif>
				
		</table>
		
		</cfoutput>		
		</td>
		
		 <td height="33" id="selectme" align="right" class="clsNoPrint">
	
		  <cfif Criteria.recordcount neq "0">
			     
				  <input name="Prior" value="<cf_tl id='Amend Criteria'>"
				     style="width:165px;height:35;font-size:14px" 
					 value="Next" 
					 class="button10g" 
					 type="button" 
					 onClick="back()">
			    			  
			</cfif>
	
		</td>
		
		<td align="right" style="padding-right:8px; padding-left:8px; width:1%;" class="clsNoPrint">
		
			<span style="display:none;" id="printTitle"><cf_tl id="Roster Search"></span>
			<cf_tl id="Print" var="1">
			<cf_button2
				title = "#lt_text#"
				type = "Print"
				mode = "icon"
				height = "35px"
				width = "35px"
				printContent = ".clsPrintContent"
				printTitle = "##printTitle">
		</td>
		
		</tr>
		</table>
	   		
	</td>
	
	<td align="right" style="padding-right:2px">
	
	<cfinvoke component="Service.Access"  
		   method="roster" 
		   owner="" 
		   role="'AdminRoster'"
		   returnvariable="Access">	
	
	<cfif SearchAction.SearchCategory eq "Function" and Access eq "EDIT" or Access eq "ALL">
	    <cfset rows    = ceiling((url.height-324)/20)> 
	<cfelse>
		<cfset rows    = ceiling((url.height-230)/20)>
	</cfif>	
	
	<cfset rows = "200">
	
	<cfif rows lte "0">
	    <cfset rows = "20">
	</cfif>
		
	<cfset cpage   = url.page>
	<cfset first   = ((cpage-1)*rows)+1>
	<cfset top     = cpage*rows>
	<cfset pages   = Ceiling(SearchResult.recordCount/rows)>
	<cfif first lt 0>
		<cfset first = 1>
	</cfif>
	<cfif pages lt "1">
	   <cfset pages = '1'>
	</cfif>
					
	<input type="hidden" id="searchid" name="searchid" value="<cfoutput>#URL.ID1#</cfoutput>">
		
	<cfif pages eq "1">
	
		<input type="hidden" id="page" name="page" value="1">
		
	<cfelse>
				     
       <select name="page" id="page" size="1" class="regularxl"
        onChange="list(this.value)">
        <cfloop index="Item" from="1" to="#pages#" step="1">
           <cfoutput><option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>><cf_tl id="Page"> #Item# <cf_tl id="of"> #pages#</option></cfoutput>
        </cfloop>	 
      </SELECT> 
	  
	 </cfif>  	

    </TD> 
  </tr>
  
  <!--- AJAX select and process box --->
  
  <tr class="hide"><td id="selectbox"></td></tr> 
       
  <tr><td colspan="2" height="25" bgcolor="white">
  
		  <table width="100%" border="0">
		  		    
		  <tr>	  	
		   			  
			  <td height="27" style="cursor: pointer;" onclick="searchcriteria()" class="labelmedium" style="padding-left:10px;font-weight:200">
		  
			  <cfoutput>			  
			  
			  <table><tr class="labelmedium2"><td>
			
			  <img src="#SESSION.root#/Images/arrowright.gif" alt="Show search" 
					id="critMax" border="0" class="show" 
					align="absmiddle" style="cursor: pointer;">
					
			  <img src="#SESSION.root#/Images/arrowdown.gif" 
					id="critMin" alt="hide search" border="0" 
					align="absmiddle" class="hide" style="cursor: pointer;">
				
				</td>
				<td style="padding-left:10px;font-size:18px"> 		  		  										
				<cf_tl id="matching candidates">:#SearchResult.recordcount#
				</td>
				<td style="padding-left:5px">
				<cfif url.mode neq "ssa" and url.mode neq "vacancy">
				<a href="##" title="View criteria" class="clsNoPrint">View criteria</a>
				</cfif>
				</td>
				
				</tr>
				</table>
							
			  </cfoutput>
			  		  
		  </td>		  
				
		  <td align="center"></td>
		    
		  <td style="padding-right:5px" align="right">
		  
		      <table><tr><td>
			  <select name="sort" id="sort" size="1" class="regularxl"
			   onChange="javascript:list(page.value)">
			     <OPTION value="Gender" <cfif URL.Sort eq "Gender">selected</cfif>><cf_tl id="Group by Gender">
			     <OPTION value="Continent" <cfif URL.Sort eq "Continent">selected</cfif>><cf_tl id="Group Continent">
				 <option value="DOB" <cfif URL.Sort eq "DOB">selected</cfif>><cf_tl id="Order by DOB">
			     <OPTION value="LastName" <cfif URL.Sort eq "LastName">selected</cfif>><cf_tl id="Order by Name"></select>
				</td>
				<td class="clsNoPrint">			
			   <select name="layout" id="layout" size="1" class="regularxl"
			    onChange="javascript:list(page.value)">
			    <option value="Listing"  <cfif URL.Lay eq "Listing">selected</cfif>><cf_tl id="Listing">
				<option value="Function" <cfif URL.Lay eq "Function">selected</cfif>><cf_tl id="View Roster Buckets">
				
			    <cfif CheckDetail.recordcount eq "1">
					<option value="Question" <cfif URL.Lay eq "Question">selected</cfif>><cf_tl id="View questions">
				</cfif>
				</select>
				
			  </td></tr></table>	
		 			    
		  </td>
		  </tr>
		  
		  </table>
  </td>
  </tr>
   
  <tr class="hide" id="criteriabox"><td id="searchcriteria" colspan="2"></td></tr>
    
  <cfif pages gt "1">
    
	  <tr class="line"><td colspan="2" height="25" align="center">	  
	   	<cf_pagenavigation cpage="#cpage#" pages="#pages#">	  
	  </td></tr>
	 
  </cfif>  
  
  <cfelse>
  
  	<!--- printing --->
  
	<cfparam name="first" default="0">  
	<cfparam name="rows"  default="999">  
	
	<tr>
    <td height="33" id="selectme" class="labelmedium">
		  
    	<cfoutput>
		<cf_tl id="Search">: <b>#SearchAction.OfficerFirstName# #SearchAction.OfficerLastName#</b> &nbsp;<cf_tl id="Date">: <b>#DateFormat(SearchAction.Created)#</b>
		<cfif CheckDetail.recordcount eq "1">&nbsp;<cf_tl id="for">: <b>
		
		<cfif CheckDetail.DocumentNo neq "">
		  <a href="javascript: showdocument('#CheckDetail.DocumentNo#')">#CheckDetail.ReferenceNo#</a>
		<cfelse>
		  <a href="javascript: va('#CheckDetail.FunctionId#')">#CheckDetail.ReferenceNo#</a>
		</cfif>
		</b></cfif>
		&nbsp;&nbsp;
		<cf_tl id="Id">: <b>#SearchAction.SearchId#</b> <cf_tl id="matching candidates">: <font size="4"><b>#SearchResult.recordcount#</b></font>
     	</cfoutput>
	   		
	</td>
	
	</tr>
   
  </cfif> 
  
  <tr>
  <td width="100%" height="100%" colspan="2" valign="top">
  
  <cf_divscroll style="height:100%">
  
	  <table style="width:98.5%" class="navigation_table">
	
		<cfif URL.Page eq "1">
	
	    	<cfswitch expression="#URL.ID3#">
			
				<tr><td colspan="12">
		
				<cfcase value="COU">
	    			<cfinclude template="Summary/PieCountry.cfm">
				</cfcase>
				
				</td>
				</tr>
		
			</cfswitch>
	  
		</cfif>		
					
		<tr class="labelmedium2 line fixrow fixlengthlist">
			<td style="padding-left:5px" >
			  <cfif url.print eq "0">
				<input type="checkbox" name="selectall" value=""
				    onClick="selall(this,this.checked);selected('',this.checked)" class="clsNoPrint">
			  </cfif>	
			</td> 
			<td><cf_tl id="Name"></td>
			<td><cf_tl id="DOB"></td>
			<td align="center"><cf_tl id="S"></td>
			<td><cf_tl id="Nat"></td>
			<td><cf_tl id="Index"></td>
			<td><cf_tl id="Grade"></td>
			<td><!---<b>Expiration</b>---></td>
			<td><!--- <b>Source</b> ---></td>
			<td align="center"><cf_tl id="Mail"></td>			
			<cfif url.print eq "0">
			<td align="center">PHP</td>
			</cfif>
			
		</tr>
			
		<cfset currrow = 0> 	
			
		<cfif SearchResult.recordcount eq "0">
			
				<tr bgcolor="ffffff">
				     <td colspan="12" style="height:50" align="center" class="labellarge"><font color="0080C0"><cf_tl id="No Candidates match your criteria"></b></td>
				</tr>
	          		
				<cfif SearchAction.SearchCategory eq "Vacancy">
				
				<tr>
					<td colspan="12" height="35" align="center" class="labelmedium2">
					    <a href="javascript:parent.document.getElementById('menu3').click()">Press here to record a new candidate</a>
					</td>
				</tr>
				
				</cfif>		
							  			
			</cfif>
			
			<cfif url.sort eq "">
			  <cfset url.sort = "Gender">
			</cfif>
			
			<cfif first eq "0">
				<cfset first = "1">
			</cfif>
			
			<cfoutput query="SearchResult" group="#URL.Sort#" startrow="#first#">
			
			   <cfif currentrow-first lt rows>
					 
				   <cfswitch expression = "#URL.Sort#">
				    
					 <cfcase value = "Gender">
						 <tr class="line labelmedium2"><td style="height:32px;font-weight:200;font-size:17px" colspan="12"><cfif Gender eq "M"><cf_tl id="Male"><cfelse><cf_tl id="Female"></cfif></b></font></td></tr>						
				     </cfcase>
					 
				     <cfcase value = "Continent">
						 <tr class="line labelmedium2"><td style="height:32px;font-weight:200;font-size:17px" colspan="12">#Continent#</td></tr>						
				     </cfcase>
					 
				   </cfswitch>
			   
			   </cfif>
			  		  		      
			   <cfoutput>
			      
			   <cfset currrow = currrow + 1>
			
			   <cfif currentrow-first lt rows>
			   		               
			     <cfif (SearchAction.SearchCategory neq "Vacancy" and Status eq "0") or 
			    	   (SearchAction.SearchCategory eq "Vacancy" and Status eq "")>
	
				      <TR class="navigation_row line labelmedium2 fixlengthlist">
						
				 <cfelse>
				 
				      <TR class="navigation_row line labelmedium2 fixlengthlist">
						
				 </cfif>
				
			     <td style="padding-left:10px" width="30" align="center">
				 
				    <cfif url.print eq "0">
										
					    <input type="checkbox" 
						       name="select" 
							   style="height:15px;width:15px"
							   value="'#PersonNo#'" 
							   onClick="hl(this,this.checked);selected('#personno#',this.checked)"
							   class="clsNoPrint"
							  		
						 <cfif (SearchAction.SearchCategory neq "Vacancy" and Status eq "1") 
						    or ((SearchAction.SearchCategory eq "Vacancy" or SearchAction.SearchCategory eq "SSA") and Status neq "")>checked</cfif>>
													
	                 <cfelse>
					 
					 	#currentrow#						
						
					 </cfif>	
				 
				 </td>		
				 
			     <TD height="24" style="padding-left:6px">
				 
					 <a href="javascript:ShowCandidate('#PersonNo#')" title="View candidate profile" class="navigation_action">					
					 <cfif PersonStatus neq 0>
						<cfif PersonStatus neq 2 >
							<font color="##993300">#PersonStatusDescription#</font>
						<cfelse>
							<strong><font color="##006699">#PersonStatusDescription#</font></strong>
						</cfif>
					 </cfif>#LastName#, #FirstName#
					 </a>
					 
				 </TD>	
			     <TD>#DateFormat(DOB, CLIENT.DateFormatShow)#</TD>
			     <td style="padding-left:2px;padding-right:2px" align="center">#Gender#</td>
				 <TD>#Nationality#</TD>
			     <TD><A href ="javascript:EditPerson('#IndexNo#')">#IndexNo#</a></TD>
				 <cfif IndexNo neq "" and ContractLevel eq "">
				 <td colspan="2" align="left">.....</td>	
				 <cfelse>
			     <TD><cfif ContractLevel neq "">#ContractLevel#/#ContractStep#</cfif></TD>	
				 <TD><cfif ContractLevel neq ""><!---#DateFormat(DateExpiration, CLIENT.DateFormatShow)#---></cfif></TD>	
				 </cfif>
		 	     <TD><!---#Source#---> <!---#DateFormat(Created, CLIENT.DateFormatShow)#---></TD>
				 <td align="center">
				 
				 <cfif eMailAddress is ''>				 
					 <cf_img icon="mail" onclick="javascript:email('#eMailAddress#','','','','Applicant','#PersonNo#')">	    			 
			     </cfif>
				 
				 </td>
			     				 
				 <cfif url.print eq "0">
				 
				 	<td style="width:20px" class="linedotted">
									 
					<cfquery name="Submission" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					  SELECT 	*
					  FROM 		ApplicantSubmission S
					  WHERE 	PersonNo = '#personno#'
					  AND       ApplicantNo IN (SELECT ApplicantNo 
					  							FROM   ApplicantBackGround A 
												WHERE  ApplicantNo = S.ApplicantNo 
												AND    Status < '9')
					</cfquery>

				 
				 	<cf_RosterPHP 
						DisplayType = "HLink"
						DisplayText = ""
						Script      = "#currentRow-first+1#"
						RosterList  = "#Submission.ApplicantNo#"
						Format      = "Document">
					 		
				     </TD>
					 
				 <cfelse>
				 
				 </cfif>
				 
			     </TR>
				 
				 <cfif remarks neq "">
				 
				     <tr><td height="3"></td></tr>
					 <tr>
					 	 <td align="right" height="20">
						 	<img src="#SESSION.root#/Images/join.gif" align="absmiddle" alt="" border="0">
						 </td>
						 <td class="labelit" colspan="9" style="padding:2px;border:1px solid d4d4d4" bgcolor="ffffdf">#remarks#</td>
					 </tr>
				 
				 </cfif>
				 
				 <!--- -------------------------- --->
				 <!--- check answers on questions --->
				 <!--- -------------------------- --->	
				 
				 <cfif url.print eq "0">		 
									  
					 <cfif URL.Lay eq "Question">
					  
					    <cfquery name="FunctionTopic" 
						 datasource="AppsSelection" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT  *
						 FROM    FunctionOrganizationTopic FO LEFT OUTER JOIN ApplicantFunctionTopic A
						    ON   FO.FunctionId = A.FunctionId
						    AND  FO.TopicId    = A.TopicId
							AND  A.ApplicantNo = '#ApplicantNo#' 
						  WHERE  FO.FunctionId = '#CheckDetail.FunctionId#'				 
						  ORDER BY Parent, TopicOrder
						</cfquery>
						
						<cfif FunctionTopic.recordcount eq "0">
				
				        <tr><td class="labelit" colspan="11" align="center"><font color="C0C0C0"><cf_tl id="No questions"></font></td></tr>
						
						<cfelseif FunctionTopic.recordcount gte "1">
				
						<TR>
							<td align="center" valign="top"><img src="#SESSION.root#/Images/join.gif" alt="" border="0"></td>
						    <TD colspan="11">
							
							  <table width="99%" bgcolor="f9f9f9" class="formpadding">
							   
								  <cfloop query="FunctionTopic">
								  <tr class="labelmedium">
								 	<td width="5%" align="center" valign="top">#currentrow#</td>							
									<td class="labelit" width="5%" align="center" valign="top">
									<b>
									<cfswitch expression="#TopicValue#">
										<cfcase value="">N/A</cfcase>
										<cfcase value="0">No</cfcase>
										<cfcase value="1">Yes</cfcase>
									</cfswitch>
									</b>
									</td>
									<td class="labelit" width="80%" valign="top">#TopicMemo#</td>
								  </tr>
								  </cfloop>	
							  
							  </table>
							  
							</TD>
						</TR>
						
						<tr><td height="3"></td></tr>	 
						
						</cfif>
					  			  
					 </cfif>			 
				
					<!--- ---------------------------------------- --->
					<!--- check if candidate was selected recently --->
					<!--- ---------------------------------------- --->
					
					<cfif indicator eq "recent">
					
						<cfset col          = "13">	
						<cfset own          = "#SearchAction.Owner#">		 		 
						<cfinclude template = "../../Candidate/Details/Functions/ApplicantFunctionSelection.cfm">
					
					</cfif>
					
					<cfif showassignment gte "1">
					
						<cfset col          = "13">					 		 
						<cfinclude template = "../../Candidate/Details/Functions/ApplicantFunctionIncumbency.cfm">
									
					</cfif>
					
				 </cfif>	
																			 	
			     <cfif URL.Lay eq "Function">
							    
				     <cfquery name="Function"  dbtype="query">
						SELECT   *
						FROM     FunctionSet
						WHERE    PersonNo = '#PersonNo#'					 
						ORDER BY Status
				     </cfquery>
				 
					 <cfif Function.recordcount gte "1">
					 
				     <tr><td height="3"></td></tr>	 
					 <tr>
					 <td></td>
					 <td colspan="9">
				   
				     <table width="95%" border="0" cellspacing="0" cellpadding="0">
					 
				     <tr><td width="100%">
					 
					     <table width="100%">
						 
						  <tr class="labelmedium line">
						     <td>Status</td>
							 <td>Bucket</td>
							 <td>Level</td>
							 <td>Area</td>					 
							 <td style="padding-right:6px">Effective</td>
							 <td>VA</td>		
							 <td></td>		  
						  </tr>
						 
						 <cfset st = "">				
										 
						 <cfloop query="Function">
						 			  
						    <cfif st neq Status and st neq "">
							<tr><td colspan="7" class="labeldotted"></td></tr>
							</cfif>
							<cfif SearchId neq "">
							<tr><td colspan="7" class="labeldotted"></td></tr>
							
							<cfelseif PostSpecific eq "1">
								<TR class="labelmedium2" bgcolor="fcfcfc">
							<cfelse>
								<TR class="labelmedium2">
							</cfif>
							
						    	 <td width="20%">#Meaning#</td>
							     <TD width="35%">#FunctionDescription#</TD>
					           	 <TD width="10%">#GradeDeployment#</TD>
					             <td width="20%">#Description#</td>
								 <td width="90">
								 <cfif enableStatusDate eq "1">#dateformat(statusDate,CLIENT.DateFormatShow)#</cfif>
								 </td>
								 <TD width="10%" style="padding-left:4px">
								       <a title="Review Announcement and Application" href="javascript:va('#FunctionId#','#ApplicantNo#');"><font color="0080C0">#ReferenceNo#</a>
								 </TD>						 
					             <TD style="padding-left:4px">
								 
								     <table><tr class="labelmedium"><td>
								 
									 <cfif SearchId neq ""><a href="##" title="Part of this roster search">*</a></cfif>
									 
									 </td>
									 
									 <td>
									 
									 <cfif PostSpecific eq "1">
									  <a href="javascript:showdocument('#DocumentNo#')">#DocumentNo#</a>
									 </cfif>
									 
									 </td></tr></table> 
									 
								 </TD>
					   	    </TR>
							<cfif SearchId neq "">
							<tr><td colspan="7" class="line"></td></tr>
							</cfif>
							<cfif FunctionJustification neq "" or rosterGroupMemo neq "">
						 	<tr>
							   <td colspan="7" style="padding-left:6px"><font color="666666">#FunctionJustification# #RosterGroupMemo#</font></td>
							</tr>
					        </cfif>
							<cfset st = "#Status#">
							
					     </cfloop>
										
					     </table>
				     </td>
					 </tr>
					 
				     </table>
					 
					 </td></tr>
									 
					 </cfif>
				  	  
			     </cfif>		
						 									 
				 </cfif>
				 						   
			   </cfoutput>
			    
			  </CFOUTPUT>
				
			</TABLE>
			
		</cf_divscroll>	
						
		</td>
		</tr>		
				
		<cfif url.print eq "0">
								
			<cfif SearchAction.SearchCategory eq "Function" and (Access eq "EDIT" or Access eq "ALL")>
		
			<tr><td height="4"></td></tr>
											
			<tr>
				<td colspan="2" class="header">
				    <cf_DecisionBlock form="result" title="Roster decision" OK="Initially clear" cancel="false"> 
				</td>
			</tr>
	
			</cfif>	
			
			<tr><td></td></tr>
							
			<tr class="clsNoPrint">
		
				<td colspan="2" class="line" style="padding-top:7px;padding-bottom:6px">
				
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						<td height="35" colspan="2" align="center" valign="middle" class="labelit">
										
						<cfif SearchAction.Status neq "0" and SearchAction.SearchCategory neq "Vacancy">
							  Archived search &nbsp;<!--- remove archived searches ---> 
							  <input type="button"
							    name="Remove" 	
								class="button10g"									
								style="width:150;height:25"
								value="Remove" 
								onClick="searchdel('<cfoutput>#URL.ID1#</cfoutput>')">
						  </td><td>
						</cfif>		
						
						<cfif url.mode eq "ssa" or url.mode eq "vacancy">
						
						    <cfif url.docno neq "">
						
							<cfif SearchResult.recordcount neq "0">
							
								<cf_tl id="Add to the list of candidates" var="1">	
																			   
							    <input type = "button" 
									name        = "Add" 
									class       = "button10g"		
									value       = "<cfoutput>#lt_text#</cfoutput>" 						
									style       = "width:240;height:25"								
									onClick     = "return info('Add selected candidates to the shortlist')">
							
							</cfif>					
											
							<cf_tl id="Close" var="1">
							<cfset tClose=#lt_text#>
							
							<cf_tl id="Prepare PHP" var="1">
							<cfset tPhp=#lt_text#>
							
							<cfif SearchResult.recordcount neq "0">
							<input type      = "button"
							     name        = "PHP" 
								 class       = "button10g"		
								 value       = "<cfoutput>#tPhp#</cfoutput>"
								 onclick     = "php()" 		
								 style       = "width:140;height:25">
							</cfif>	 
							
							<!---
							<input type      = "submit" 
								name         = "Close" 
								class        = "button10g"		
								value        = "<cfoutput>#tClose#</cfoutput>" 
								style        = "width:140;height:25"															
								onClick      = "parent.parent.window.close(); parent.parent.opener.location.reload()">
								--->
							
							</cfif>				
				   		   	
						<cfelse>  
						
							<cf_tl id="Prepare PHP" var="1">
							<cfset tPhp=#lt_text#>
							
							<input type      = "button"
							     name        = "PHP" 
								 class       = "button10g"		
								 value       = "<cfoutput>#tPhp#</cfoutput>"
								 onclick     = "php()" 	
								 style       = "width:140;height:25">
								 	
							<cf_tl id="Export" var="1">
							<cfset tExport=#lt_text#>		
							
							<cfoutput>	
							
							<input type="hidden" name="selectedall" value="#quotedvalueList(searchResult.PersonNo)#">						   
							
							</cfoutput>
						
						    <input type = "submit" 
								name    = "ExportExcel"
								class   = "button10g"		 
								style   = "width:140;height:25" 
								value   = "<cfoutput>#tExport#</cfoutput>">
											
							<input type  = "button" 
							     name    = "Broadcast Mail" 
								 onclick = "broadcast('#url.docno#')" 
								 class   = "button10g"		
								 style   = "width:140;height:25"
								 value   = "Broadcast Mail">
											   
						</cfif> 
						
						</td>
						</tr>
						
					</table>
					
				</td>
			</tr>
			
		<cfelse>
		
			<script>
				window.print()
			</script>	
			
		</cfif>	
		
</table>

</form>

</td></tr></table>

<script>
Prosis.busy('no')
</script>
