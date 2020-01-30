
<cfparam name="currentrow" default="1">
<cfparam name="actions.ActionStatus" default="0">
<cfparam name="url.line" default="#currentrow#">

<cfoutput>
	<!--- refresh only --->
	<input type="hidden" name="mybut" 
	    id="mybut" 
		onclick="ColdFusion.navigate('../Candidates/JobCandidate.cfm?ajaxid=#url.ajaxid#&line=#url.line#','urldetail#url.line#')">
</cfoutput>
	
<cfquery name="Job" 
	datasource="appsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	    SELECT *			 			  
	    FROM   Job
		WHERE  JobNo = '#url.ajaxid#' 		
</cfquery>
		
<cfquery name="Searchresult" 
	datasource="appsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	    SELECT A.IndexNo, 
		       A.PersonNo, 
			   J.Status, 		       
		   	   A.LastName, 
			   A.FirstName, 
			   A.Nationality, 
			   A.Gender, 
			   A.DOB, 
			   J.PersonClass,
			   J.OfficerLastName, 
			   J.OfficerFirstName,
			   J.Created 
			 			  
	    FROM   JobPerson J,		    
			   Applicant.dbo.Applicant A
		WHERE  J.JobNo = '#url.ajaxid#' 
		AND    J.PersonClass = 'Applicant'
		AND    J.PersonNo = A.PersonNo
		
		UNION 
		
		 SELECT A.IndexNo, 
		       A.PersonNo, 
			   J.Status, 		       
		   	   A.LastName, 
			   A.FirstName, 
			   A.Nationality, 
			   A.Gender, 
			   A.BirthDate as DOB, 
			   J.PersonClass,
			   J.OfficerLastName, 
			   J.OfficerFirstName,
			   J.Created 
			 			  
	    FROM   JobPerson J,		    
			   Employee.dbo.Person A
		WHERE  J.JobNo = '#url.ajaxid#' 
		AND    J.PersonClass = 'Employee'
		AND    J.PersonNo = A.PersonNo	
		
	</cfquery>
	
<cfif SearchResult.recordCount neq "0">

<table width="100%" border="0"
         bordercolor="silver" 		 
		 cellspacing="0" 
		 cellpadding="0"
		 class="formpadding" 		
		 align="center" id="shortlist">
	
<tr><td>

<table width="100%" border="0" 
	cellspacing="0" bordercolor="silver" cellpadding="0"
	bgcolor="ffffff" style="filter: alpha(opacity=95);-moz-opacity: .95;opacity: .95;" 
	align="center"
	class="formpadding">

    <TR bgcolor="f4f4f4">
   	  <TD class="labelit"><cf_space spaces="10"></TD>
   	  <TD class="labelit"><cf_tl id="Id"></TD>
      <TD class="labelit"><cf_tl id="LastName"></TD>
      <TD class="labelit"><cf_tl id="ForstName"></TD>
	  <TD class="labelit"><cf_tl id="Nat"></TD>
      <TD class="labelit"><cf_tl id="Gender"></TD>
	  <TD class="labelit"><cf_tl id="Birthdate"></TD>
   	  <TD class="labelit"><cf_tl id="Status"></TD>
	  <td></td>
	  <TD class="labelit"><cf_tl id="Entered"></TD>
  	  <td><cf_space spaces="10"></td>
    </TR>			
			 	
	<cfoutput query="SearchResult">
			
	<!--- provision to add record to the quote line --->
			
	<cfquery name="Requisition" 
		datasource="appsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		    SELECT *			 			  
		    FROM   RequisitionLine
			WHERE  JobNo = '#url.ajaxid#' 		
			AND    ActionStatus NOT IN ('9','0z')
	</cfquery>
	
	<cfset per = PersonNo>
	<cfset cls = PersonClass> 
	
	<cfloop query="Requisition">
		
			<cfquery name="Insert" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 INSERT INTO RequisitionLineQuote 
				 ( RequisitionNo, 
				   JobNo, 
				   PersonClass, 
				   PersonNo, 
				   VendorItemDescription,
				   TaxIncluded,
				   TaxExemption,
				   QuoteTax, 
				   QuotationQuantity, 
				   QuotationUoM, 
				   Currency,
				   OfficerUserId,
				   OfficerLastName,
				   OfficerFirstName)
			 SELECT RequisitionNo, 
			        '#URL.ajaxid#', 
					'#Cls#',
					'#Per#', 
					RequestDescription, 
					'1',
					'0',
					'0', 
					RequestQuantity, 
					QuantityUoM, 
					'#APPLICATION.BaseCurrency#',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#'
			 FROM   RequisitionLINE L
			 WHERE  JobNo = '#URL.ajaxid#'
			 <!---  does not have an occurance --->
			 AND    L.RequisitionNo NOT IN (SELECT RequisitionNo 
			                                FROM   RequisitionLineQuote 
										    WHERE  PersonNo      = '#Per#'
										    AND    PersonClass   = '#cls#'
											AND    JobNo         = '#url.ajaxid#'
										    AND    RequisitionNo = L.RequisitionNo
										   ) 
		    </cfquery>	
		
	</cfloop>	
		
	<TR class="linedotted">
	
	<td height="19" style="padding-top:3px" width="30" align="center">
					
	    <cfif PersonClass eq "Employee">
		
			  <cf_img icon="select" onClick="EditPerson('#PersonNo#')">
						   
		<cfelse>
		
			  <cf_img icon="select" onClick="ShowCandidate('#PersonNo#')">
					
		</cfif>	   
	   
	</td>
	
	<cfif dob neq "">
		
		<cfset age = year(now())-#year(DOB)#>
		<cfif dayofyear(now()) lt #dayofyear(DOB)#>
		  <cfset age = age -1>
		</cfif>
	
	<cfelse>
	
		<cfset age = "undefined">
		
	</cfif>
	
	<td class="labelit">#IndexNo#</td>
    <td class="labelit">#LastName#</td>
	<td class="labelit">#FirstName#</td>
	<td class="labelit">#Nationality#</td>
	<td class="labelit"><cfif Gender eq "F">Female<cfelse>Male</cfif></td>
	<td class="labelit">#dateFormat(DOB,CLIENT.DateFormatShow)# [age:<b>#age#</b>]</td>
	<td class="labelit"><cfif status eq "2s"><font size="2" color="808040"><b>Selected</font></cfif></td>
	<td width="30"></td>	
	<td class="labelit">#Dateformat(Created, CLIENT.DateFormatShow)#</td>	
	<td>	
				
		<cfparam name="dialogAccess" default="edit">	
								
		<cfif Actions.ActionStatus eq "0">
				
			<cfif dialogAccess eq "EDIT">
			
				<cf_img icon="delete" onClick="personcancel('#URL.ajaxid#','#PersonNo#','#url.line#','../Candidates/JobCandidateDelete.cfm','#personclass#')">
			
			    <!---
			    <img src="#SESSION.root#/Images/delete5.gif" 
				     alt="Remove candidate from shortlist" 
					 border="0" 
					 style="cursor:pointer"
					 align="absmiddle"
					 height="13" 
					 width="13"
					 onClick="personcancel('#URL.ajaxid#','#PersonNo#','#url.line#','../Candidates/JobCandidateDelete.cfm','#personclass#')">
					 
					 --->
					 
		    </cfif>		
						
		</cfif>
		
	</td>
	
	</tr>
			
	<tr>
		<td></td>
		<td colspan="9" class="labelit">
						
		<cfif Job.ActionStatus lte "1">
						
			<cf_filelibraryN
				DocumentPath="ProcJob"
				SubDirectory="#URL.ajaxid#" 
				Filter="#PersonNo#"
				box="candidate#currentrow#"
				Loadscript="No"
				color="transparent"
				Insert="yes"
				Remove="yes"
				ShowSize="1">	
							
		<cfelse>
				
			<cf_filelibraryN
				DocumentPath="VacCandidate"
				SubDirectory="#URL.ajaxid#" 
				Filter="#PersonNo#"
				box="candidate#currentrow#"
				Loadscript="No"		
				color="transparent"
				Insert="no"
				Remove="no"
				ShowSize="1">	
							
		</cfif>	
			
		</td>
		<td><cf_space spaces="10"></td>
	</tr>
	
	<cfset row = currentrow>
		
		<cfquery name="Quote" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT Q.*				 			  
			FROM   RequisitionLineQuote Q
			WHERE  Q.JobNo        = '#url.ajaxid#'						
			AND    Q.PersonClass  = '#PersonClass#'									
			AND    Q.PersonNo     = '#PersonNo#'					
		</cfquery>
		
		<tr>
		
		<td></td>
		<td colspan="9" style="padding-left:1px">
		
		<table width="100%" cellspacing="0" style="border: 0px solid silver;">
		
				<cfloop query = "Quote">
				
					<cfif selected eq "1">
			
					<tr class="labelit" bgcolor="yellow">
					
					<cfelse>
					
					<tr class="labelit" bgcolor="e4e4e4">
					
					</cfif>
									
					<td align="center" width="30" style="padding:3px">
					
						<cfif Actions.ActionStatus eq "0">
						
							<cf_img icon="edit" onClick="ProcQuoteEdit('#quotationid#');">					
						 
						</cfif> 
					 
					 </td>
						
					<cfif QuoteAmountBase lte "0" and QuoteZero eq "0">
						<td colspan="7" style="padding-left:0px">
							<a href="javascript:ProcQuoteEdit('#quotationid#')"><font color="FF0000"><cf_tl id="Not offered">: #VendorItemDescription#</a>
						</td>
					<cfelse>
					    <td style="padding-lweft:10px" width="230"><a href="javascript:ProcQuoteEdit('#quotationid#')">#VendorItemDescription#</a></td>
				        <td>#QuotationQuantity#</td>
				    	<td align="center" width="80" style="padding:3px">#QuotationUoM#</td>
				        <td align="right"  width="70" style="padding:3px">#NumberFormat(QuoteAmountBase/QuotationQuantity,",__.__")#</td>
						<td align="right"  width="90" style="padding:3px">#NumberFormat(QuoteAmountBaseCost,",__.__")#</td>					
				        <td align="right"  width="90" style="padding:3px">#NumberFormat(QuoteAmountBaseTax,",__.__")#</td>
						<td align="right"  width="90" style="padding:3px;padding-right:10px">#NumberFormat(QuoteAmountBase,",__.__")#</b></td>				   
					</cfif>
	            	</tr>
				
				</cfloop>
	
		</table>
		</td>
		<td></td>
	</tr>	
	
	<tr><td height="6"></td></tr>	
		
	</cfoutput>
		
</table>	

</td></tr>

</table>

</cfif>


