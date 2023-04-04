
<cf_param name="URL.ID"          default="" 	    type="String">
<cf_param name="URL.Header"      default="Yes" 	    type="String">
<cf_param name="URL.External"    default="1" 	    type="String">
<cf_param name="URL.Apply"       default="0" 	    type="String">
<cf_param name="URL.ApplicantNo" default=""	 	    type="String">
<cf_param name="URL.Mode"        default="View"     type="String">
<cf_param name="URL.Domain"      default="JobProfile" type="String">

<cf_tl id="Job Description" var="label">

<cfif url.header eq "Yes">
	
	<cf_screentop 
		html      = "Yes" 
		layout    = "webapp" 
		banner    = "gray" 				
		jquery    = "Yes"
		label     = "#label#" 		
		scroll    = "Yes"		
		menuPrint = "No"
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
		 AND    TextAreaCode IN (SELECT Code FROM Ref_TextArea WHERE TextAreaDomain = '#url.domain#')
</cfquery>

<cfif VAText.recordcount eq "0">

	<cfset url.domain = "Position">

</cfif>

<cfquery name="Owner"
         datasource="AppsSelection"
         username="#SESSION.login#"
         password="#SESSION.dbpw#">
         SELECT *
         FROM   Ref_ParameterOwner
		 WHERE  Owner = '#VA.Owner#' 
</cfquery>

<cfif FileExists("#SESSION.rootPath#\Custom\#Owner.PathVacancyText#") and url.apply neq "1" and url.external eq "1">

       <!--- disalbed --->

	   <table border="0" bgcolor="ffffff" height="100%" width="95%" align="center">
	   <tr><td height="100%" width="100%" style="padding:10px">	  
	   	 	   	     	   	  						  
		      <!--- custom path --->			  
				  	   	      
			<cfset URL.ID1 = VA.ReferenceNo>						
		  	<cfinclude template="../../../Custom/#Owner.PathVacancyText#">
			
						
		</td></tr>
	  </table>	
		
<cfelse>

    <cf_divscroll>
	
	<cfoutput query = "VA">
		
	   <table width="98%" align="center" class="formpadding">
	   
	   	   	    		 
			<cfif PostSpecific eq "1">
			
			<tr class="labelmedium2" style="height:20px">
		        <td style="padding-left:3px" align="left">Position specific:</b></td>
		        <td><cfif PostSpecific eq "1">Yes<cfelse>No</cfif><td>
			</tr>		
			
			</cfif>
			
			<cfif VA.Announcement eq "1">   	
		
				<tr class="labelmedium2" style="height:20px">
			        <td style="padding-left:3px"><cf_tl id="Effective">:</td>
			        <td>#Dateformat(DateEffective, "#CLIENT.DateFormatShow#")#</td>				
			        <td style="padding-left:3px"><cf_tl id="Reference">:</b></td>
			        <td><cfif ReferenceNo eq "">n/a<cfelse>#ReferenceNo#</cfif></td>
				</tr>	
			
			    <cfif DateExpiration neq "">
					<tr class="labelmedium2" style="height:20px">
				        <td style="padding-left:3px"><cf_tl id="Expiration">:</td>
				        <td>#Dateformat(DateExpiration, "#CLIENT.DateFormatShow#")#</d>
					</tr>		
				</cfif>
			
			     <tr class="labelmedium2" style="height:20px">
			        <td style="padding-left:3px"><cf_tl id="Title">:</td>
			        <td>#FunctionDescription# - #GradeDeployment#</td>			     
			        <td style="padding-left:3px"><cf_tl id="Area">:</td>
			        <td>#OrganizationDescription#</td>
			     </tr>
			 				 
				 
			 </cfif>			
		 
			 <cfif url.applicantNo neq "undefined">
			  
				 <cfif Applicant.recordcount gte "1">
					  
					  <tr class="labelmedium2" style="height:20px">
				        <td style="padding-left:3px"><cf_tl id="Candidate">:</b></td>
				        <td>#Applicant.FirstName# #Applicant.LastName#</td>
				     </tr>
					 
					 <cfloop query="Applicant">
					 
						 <tr class="labelmedium2" style="height:20px">
					        <td style="padding-left:3px">Date:</b></td>
					        <td>#dateformat(DocumentDate, CLIENT.DateFormatShow)#</td>					     
					        <td style="padding-left:3px">#DocumentType#:</b></td>
					        <td>#DocumentText#</td>
					     </tr>
					 
					 </cfloop>
									  
				  </cfif>
				  
			  </cfif>	  
			  
		 		  
		  </cfoutput>			
		  		 			   
		  <cfif VA.postSpecific eq "1">
		  		  
		    <cfif URL.Mode eq "Edit">		
					  	    
		   		<cfform action="AnnouncementSubmit.cfm?ID=#URL.ID#&domain=#url.domain#" method="post" name="gjp" id="gjp">
				
				  <tr><td align="left" colspan="6">
		  
				     <cf_ApplicantTextArea
						Table           = "FunctionOrganizationNotes" 
						Domain          = "#url.domain#"
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
				<tr><td height="1" colspan="6" class="linedotted"></td></tr>
				<tr><td height="4"></td></tr>
				<tr><td height="35" colspan="6" align="center">
								
				<input type="button" name="Close" class="button10g" style="width:150px;height:23px" onclick="window.close()" value="Close profile">&nbsp;
				<cfif Access eq "EDIT" or Access eq "ALL"> 
					<input type="submit" name="Save"  class="button10g" style="width:150px;height:23px" value="Save profile">
				</cfif>
				</td></tr>
								
				</cfform>
					
			<cfelse>				
			  
			    <tr><td colspan="6" align="left">		
				
				     <cf_ApplicantTextArea
						Table           = "FunctionOrganizationNotes" 
						Domain          = "#url.domain#"
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
					<tr><td colspan="6" align="center">
					<cfoutput>
						<input type="button" class="button10g" style="width:200px;height:25px" onclick="ptoken.open('#SESSION.root#/vactrack/application/Announcement/Announcement.cfm?domain=#url.domain#&ID=#URL.ID#&Mode=EDIT','VA','left=20, top=20, width=#CLIENT.width-60#, height=800, status=yes, toolbar=no, location=no, scrollbars=yes, resizable=no')" value="Maintain">
					</cfoutput>	
					</td></tr>
					</cfif>									
				
			</cfif>
					
		  <cfelse>
		  
		  	  <cfif VA.Announcement eq "1">
			  		  
				  <tr><td colspan="6">
				  				  
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
								Domain          = "#url.domain#"
								FieldOutput     = "ProfileNotes"				
								Mode            = "#URL.Mode#"
								Format          = "RichText"
								Key01           = "FunctionId"
								Key01Value      = "#URL.ID#">
								  
						<cfelse>
								  
						   <cf_ApplicantTextArea
								Table           = "FunctionTitleGradeProfile" 
								Domain          = "#url.domain#"
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
		
	</cf_divscroll>	
					
</cfif>

