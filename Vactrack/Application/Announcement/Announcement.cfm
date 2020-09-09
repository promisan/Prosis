
<cf_param name="URL.ID"          default="" 	type="String">
<cf_param name="URL.Header"      default="Yes" 	type="String">
<cf_param name="URL.Apply"       default="0" 	type="String">
<cf_param name="URL.ApplicantNo" default=""	 	type="String">
<cf_param name="URL.Mode"        default="View" type="String">

<cf_tl id="Job Description" var="label">

<cfif url.header eq "Yes">
	
	<cf_screentop 
		html      = "Yes" 
		layout    = "webapp" 
		banner    = "gray" 				
		jquery    = "Yes"
		label     = "#label#" 		
		scroll    = "Yes"		
		menuPrint = "Yes"
		menuClose = "Yes">
				
		<cf_textareascript>
	
</cfif>


<cfif url.id eq "">

	<table align="center">
	  <tr><td height="70" class="labelmedium"><cf_tl id="There is a problem with your selection"></td></tr>
	</table>

	<cfabort>

</cfif> 

<cfquery name="VA"
         datasource="AppsSelection"
         username="#SESSION.login#"
         password="#SESSION.dbpw#">
         SELECT *
         FROM   FunctionOrganization F1, 
		        Ref_SubmissionEdition E, 
				FunctionTitle F,
				Ref_Organization O
		 WHERE  E.SubmissionEdition  = F1.SubmissionEdition
		 AND    F1.FunctionNo        = F.FunctionNo
		 AND    F1.OrganizationCode  = O.OrganizationCode
		 AND    FunctionId           = '#URL.ID#' 
</cfquery>

<cfif url.applicantNo neq "undefined">
	
	<cfquery name="Applicant"
	         datasource="AppsSelection"
	         username="#SESSION.login#"
	         password="#SESSION.dbpw#">
			 SELECT     A.*, DOC.*
			 FROM       Applicant A INNER JOIN
	                    ApplicantSubmission S ON A.PersonNo = S.PersonNo LEFT OUTER JOIN
	                    ApplicantFunctionDocument DOC ON S.ApplicantNo = DOC.ApplicantNo
			 WHERE      S.ApplicantNo  = '#URL.ApplicantNo#' 
			 AND        DOC.FunctionId = '#URL.ID#'        
	</cfquery>

</cfif>

<cfquery name="VAText"
         datasource="AppsSelection"
         username="#SESSION.login#"
         password="#SESSION.dbpw#">
         SELECT *
         FROM   FunctionOrganizationNotes 
		 WHERE  FunctionId = '#URL.ID#' 
</cfquery>

<cfquery name="Owner"
         datasource="AppsSelection"
         username="#SESSION.login#"
         password="#SESSION.dbpw#">
         SELECT *
         FROM   Ref_ParameterOwner
		 WHERE  Owner = '#VA.Owner#' 
</cfquery>


<cfif FileExists("#SESSION.rootPath#\Custom\#Owner.PathVacancyText#") and url.apply neq "1">

	   <table border="0" bgcolor="ffffff" height="100%" width="95%" align="center">
	   <tr><td height="100%" width="100%" style="padding:20px">	  
   	   	  
		      <!--- custom path --->			  
				  	   	      
			<cfset URL.ID1 = VA.ReferenceNo>						
		  	<cfinclude template="../../../Custom/#Owner.PathVacancyText#">
			
						
		</td></tr>
	  </table>	
		
<cfelse>
		
	<cfoutput query = "VA">
		
	   <table border="0" cellpadding="0" cellspacing="0" width="96%" align="center" class="formpadding">
	   	    		 
		<cfif PostSpecific eq "1">
		
		<tr class="labelmedium">
	        <td width="160" style="padding-left:3px" align="left">Position specific:</b></td>
	        <td width="80%" align="left"><cfif PostSpecific eq "1">Yes<cfelse>No</cfif><td>
		</tr>		
		
		</cfif>
		
		<cfif VA.Announcement eq "1">   	
	
			<tr class="labelmedium">
		        <td align="left" style="padding-left:3px">Post date:</td>
		        <td align="left">#Dateformat(DateEffective, "#CLIENT.DateFormatShow#")#<td>
			</tr>		
			
			 <tr class="labelmedium">
		        <td width="130" style="padding-left:3px" align="left">Reference No:</b></td>
		        <td align="left"><cfif ReferenceNo eq "">n/a<cfelse>#ReferenceNo#</cfif><td>
			</tr>	
		
		    <cfif DateExpiration neq "">
				<tr class="labelmedium">
			        <td align="left" style="padding-left:3px">Expiration date:</td>
			        <td align="left">#Dateformat(DateExpiration, "#CLIENT.DateFormatShow#")#<td>
				</tr>		
			</cfif>
		
		     <tr class="labelmedium">
		        <td align="left" style="padding-left:3px"><cf_tl id="Title">:</td>
		        <td align="left" colspan="1">#FunctionDescription# - #GradeDeployment#</td>
		     </tr>
			
			 <tr class="labelmedium">
		        <td align="left" style="padding-left:3px"><cf_tl id="Area">:</td>
		        <td align="left" colspan="1">#OrganizationDescription#</td>
		     </tr>
		 
			 <tr><td height="3"></td></tr>
			 <tr><td height="1" colspan="3" class="linedotted"></td></tr>
			 <tr><td height="2"></td></tr>
			 
		 </cfif>			
		 
		 <cfif url.applicantNo neq "undefined">
		  
			 <cfif Applicant.recordcount gte "1">
				  
				  <tr class="labelmedium">
			        <td align="left" style="padding-left:3px">Applicant:</b></td>
			        <td align="left" colspan="1">#Applicant.FirstName# #Applicant.LastName#</td>
			     </tr>
				 
				 <cfloop query="Applicant">
				 
					 <tr class="labelmedium">
				        <td align="left" style="padding-left:3px">Date:</b></td>
				        <td align="left" colspan="1">#dateformat(DocumentDate, CLIENT.DateFormatShow)#</td>
				     </tr>
					   
					 <tr class="labelmedium">
				        <td align="left" style="padding-left:3px">#DocumentType#:</b></td>
				        <td align="left" colspan="1">#DocumentText#</td>
				     </tr>
				 
				 </cfloop>
				 
				 <tr><td height="3"></td></tr>
				 <tr><td height="1" colspan="3" class="line"></td></tr>
				 <tr><td height="2"></td></tr>
			  
			  </cfif>
			  
		  </cfif>	  
		  
		  </cfoutput>	
		  		 			   
		  <cfif VA.postSpecific eq "1">
		  		  
		    <cfif URL.Mode eq "Edit">		
			
		  	    
		   		<cfform action="AnnouncementSubmit.cfm?ID=#URL.ID#" method="post" name="gjp" id="gjp">
				
				  <tr><td align="left" colspan="3">
		  
				     <cf_ApplicantTextArea
						Table           = "FunctionOrganizationNotes" 
						Domain          = "JobProfile"
						FieldOutput     = "ProfileNotes"
						Mode            = "#URL.Mode#"
						Format          = "Mini"
						Key01           = "FunctionId"
						Key01Value      = "#URL.ID#">
															
				</td></tr>
			
				<cfinvoke component="Service.AccessGlobal"  
			      method="global" 
				  role="FunctionAdmin" 
				  returnvariable="Access">
				  
				<tr><td height="4"></td></tr>
				<tr><td height="1" colspan="2" class="linedotted"></td></tr>
				<tr><td height="4"></td></tr>
				<tr><td height="35" colspan="2" align="center">
								
				<input type="button" name="Close" class="button10g" style="width:150px;height:23px" onclick="window.close()" value="Close profile">&nbsp;
				<cfif Access eq "EDIT" or Access eq "ALL"> 
					<input type="submit" name="Save"  class="button10g" style="width:150px;height:23px" value="Save profile">
				</cfif>
				</td></tr>
								
				</cfform>
					
			<cfelse>				
			  
			    <tr><td colspan="4" align="left">		
				
				     <cf_ApplicantTextArea
						Table           = "FunctionOrganizationNotes" 
						Domain          = "JobProfile"
						FieldOutput     = "ProfileNotes"				
						Mode            = "#URL.Mode#"						
						Key01           = "FunctionId"
						Key01Value      = "#URL.ID#">
						
																
				</td></tr>
				
					<cfinvoke component="Service.AccessGlobal"  
				      method="global" 
					  role="FunctionAdmin" 
					  returnvariable="Access">		
											  					  		  		  
					<cfif (Access eq "EDIT" or Access eq "ALL") and URL.Apply eq "0">       
					<tr><td colspan="4" align="center">
					<cfoutput>
						<input type="button" class="button10g" style="width:100px;height:25px" onclick="ptoken.open('#SESSION.root#/vactrack/application/Announcement/Announcement.cfm?ID=#URL.ID#&Mode=EDIT','VA','left=20, top=20, width=#CLIENT.width-60#, height=800, status=yes, toolbar=no, location=no, scrollbars=yes, resizable=no')" value="Maintain">
					</cfoutput>	
					</td></tr>
					</cfif>									
				
			</cfif>
					
		  <cfelse>
		  
		  	  <cfif VA.Announcement eq "1">
			  
		  
				  <tr><td colspan="4">
				  				  
						  	<cfquery name="Check"
				         datasource="AppsSelection"
				         username="#SESSION.login#"
				         password="#SESSION.dbpw#">
				         SELECT *
				         FROM   FunctionOrganizationNotes 
						 WHERE  FunctionId = '#URL.ID#' 
						 AND    ProfileNotes is not NULL
						</cfquery>
						
						<cfif check.recordcount gte "1">
						  		  
						    <cf_ApplicantTextArea
								Table           = "FunctionOrganizationNotes" 
								Domain          = "JobProfile"
								FieldOutput     = "ProfileNotes"				
								Mode            = "#URL.Mode#"
								Format          = "RichText"
								Key01           = "FunctionId"
								Key01Value      = "#URL.ID#">
								  
						<cfelse>
								  
						   <cf_ApplicantTextArea
								Table           = "FunctionTitleGradeProfile" 
								Domain          = "JobProfile"
								FieldOutput     = "ProfileNotes"
								Mode            = "#URL.Mode#"
								Key01           = "FunctionNo"
								Key01Value      = "#VA.FunctionNo#"
								Key02           = "GradeDeployment"
								Key02Value      = "#VA.GradeDeployment#">
							
						 </cfif>	
					
				   </td></tr>
			   
			   </cfif>
				 
		  </cfif>	
		  
		  <cfif VA.FunctionId neq "">
		
			<cfoutput>
			
			<cfif URL.Apply eq "1">
			    <script>
				 application('#VA.FunctionId#')
				</script>
				<!---
				<tr><td colspan="4" class="labellarge" style="height:50px;font-size:32px;padding-left:10px">
				<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/finger.gif" alt="" align="absmiddle" border="0">
				<a href="javascript:application('#VA.FunctionId#')"><b><cf_tl id="Press to Apply"></a></td></tr>				
				--->
			</cfif>
			</cfoutput>
		
		</cfif>
				  	 
	    </table>
					
</cfif>

