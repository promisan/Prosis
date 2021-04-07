
<cf_param name="url.scope" default="" type="string">
<cf_param name="url.id" default="" type="string">

<cfquery name="Candidate" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  	SELECT *
    FROM   Applicant
	WHERE  PersonNo = '#URL.ID#'   		  
</cfquery>

<cf_tl id="Person Profile" var="1">
<cfset p1 = lt_text>
<cf_tl id="Profile Maintenance and Inquiry" var="1">
<cfset p2 = lt_text>

 <cfif Candidate.dob neq "">
	 
	 <cfset age =  year(now()) - year(Candidate.DOB)>
	 <cfif dayOfYear(Candidate.DOB) gt dayOfYear(Now())>
	  <cfset age = age-1>
	 </cfif>
	 
	 <cfif age gte "90">	 
		 <cfset age = "">		 
	 <cfelse>	 
		 <cfset age = "#age#">	 
	 </cfif>		 
	 
 <cfelse> 
 	<cfset age = ""> 	 
 </cfif>	
 
<cfoutput>

	<script language="JavaScript">
	
	    function deleterecord(per) {
		
		<cf_tl id="Do you want to remove candidate record" var="1">
		
		if   (confirm("#lt_text#")) {
			  parent.window.location = "PHPPurge.cfm?personNo="+per
			 } 
		} 
		
	    function merge() {
		
		    			
			parent.ProsisUI,createWindow('mydialog', 'Merge', '',{x:100,y:100,height:700,width:700,modal:true,resizable:false,center:true})    					
			parent.ptoken.navigate('#SESSION.root#/Roster/Candidate/Tools/Person2Times.cfm?personno=#url.id#','mydialog') 		

		
		}
		
	</script>
	
</cfoutput> 

<cf_dialogstaffing>

<cfajaximport tags="cfdiv">

<cf_screentop scroll="No" 
	     height="100%" 
		 html="no" 				 		
		 label="#candidate.firstname# #candidate.lastname# [#age#]" 	
		 line="yes" 		
		 jQuery        = "Yes"
		 systemmodule  = "Roster"
		 functionclass = "Window"
		 functionName  = "Candidate Screen"
		 menuAccess="context"
		 banner="gray"/>
	
<cf_layoutscript>
<cf_actionlistingscript>
<cf_textareascript>
	
<cfoutput>
	
	<cfquery name="Parameter" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Parameter
	</cfquery>
	
	<cfparam name="CLIENT.submission" default="#Parameter.PHPEntry#">
					 
	<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

	<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
	   	position  = "header"
	   	name      = "headerPHP"
	   	minsize	  = "50px"
		maxsize	  = "50px"
		size 	  = "50px">	
				
		<cf_ViewTopMenu systemfunctionid="#url.systemfunctionid#" label="#candidate.firstname# #candidate.lastname# [#age#]" background="blue" option="">
			 			  
	</cf_layoutarea>	
	
	
<cfinvoke component = "Service.Access"  
   method           = "roster" 
   role             = "'AdminRoster','RosterClear','CandidateProfile','CandidateReview','CandidateClear'"   
   returnvariable   = "accessProfile">	  
   
   <cfif accessProfile neq "NONE">
						
		<cf_layoutarea 
		    position    = "left" 
		    name        = "treebox" 
			maxsize     = "300" 		
			size        = "260" 
			minsize     = "260" 
			collapsible = "true" 
			splitter    = "true"
			overflow    = "auto">	
														
				<table width="100%" height="100%" class="formpadding">
			
				   <tr><td height="1" colspan="2"><cfinclude template="PHPHeader.cfm"></td></tr>
																			
				   <tr><td valign="top" height="100%" style="padding-left:8px">	
				  								
							<table width="100%" height="100%" border="0" align="center">
							
								<tr><td valign="top" style="height:100%;padding-left;4px">
							     <cf_PHPTreeData scope="#url.scope#">		
								 
								<!--- 
								<cf_divscroll style="border:12px solid silver;height:100%">				       						  					   					
								  				  						  						
						 	    </cf_divscroll>
								--->
							  		
							    </td>
							   </tr> 					
							  
						</table>	
											
						</td>
						
					</tr>
					
					<!---  Enabled back by Armin on Jan 21 2021---->
									
					<cfquery name="PHPSource" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						  	SELECT PHPSource
						  	FROM   Parameter
					</cfquery>
				
					<cfquery name="PHP" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT PersonNo,ApplicantNo
							FROM   ApplicantSubmission
							WHERE  PersonNo  = '#URL.ID#' 
							AND    Source    = '#PHPSource.PHPSource#' 
					</cfquery>					
					
					<cfoutput>																						
																	
						<cfquery name="Check" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					   		SELECT * 
							FROM   ApplicantFunction
							WHERE  ApplicantNo IN (SELECT ApplicantNo 
							                       FROM   ApplicantSubmission 
									 			   WHERE  PersonNo = '#URL.ID#')													  
					   		
					   	</cfquery>				
						
						<tr style="height:20px">
						<td align="center" style="padding-left:5px">		
												
								<cfquery name="Submission" 
									datasource="AppsSelection" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									  SELECT 	*
									  FROM 		ApplicantSubmission S
									  WHERE 	PersonNo = '#PHP.personno#'
									  AND       ApplicantNo IN (SELECT ApplicantNo 
									  							FROM   ApplicantBackGround A 
																WHERE  ApplicantNo = S.ApplicantNo 
																AND    Status < '9')
									</cfquery>
								
									<table width="100%">
									
									<cfif submission.recordcount gte "1">
									
									<tr class="line"><td style="padding-left:10px" class="line labelmedium"><cf_tl id="Print Profile"></td></tr>
									</cfif>
																
									<cfloop query="Submission">
									
										<tr>
																
										<td align="right" style="padding-left:10px;padding-right:5px" class="labelmedium">
		
										<cf_RosterPHP 
											DisplayType = "HLink"
											Image       = "#SESSION.root#/Images/pdf_small.gif"
											DisplayText = "#Source#"
											style       = "height:14;width:16"
											Script      = "#currentrow#"
											RosterList  = "#ApplicantNo#"
											Format      = "Document">	
											
											</td>		
											
										</tr>			
									
									</cfloop>  
																		
									</table>					
												   							
						</td>	
						</tr>
										
						<cfif check.recordcount eq "0">										
						
							<cfinvoke component="Service.Access"  
							   method="roster" 
							   returnvariable="AccessRoster"
							   role="'AdminRoster'">				
															
							<cfif AccessRoster eq "EDIT" or AccessRoster eq "ALL">	
							
								<tr style="height:20px"><td align="center">																
										<button style="border-radius:3px;width:140;height:39px" type="button" class="button10g" onClick="deleterecord('#Candidate.PersonNo#')"><cf_tl id="Purge record"></button>																															
									</td>	
								</tr>									
																			
							</cfif>  														
		
						</cfif> 																
						
						<cfinvoke component="Service.Access"  
						   method="roster" 
						   returnvariable="AccessRoster"
						   role="'AdminRoster'">				
						
						<cfif AccessRoster eq "EDIT" or 
						      AccessRoster eq "ALL">
								
								<tr>				 							
								<td align="center">							
									<button style="border-radius:2px;width:96%;height:39px" type="button" class="button10g" 
									  onClick="merge('#Candidate.PersonNo#')"><cf_tl id="Merge this candidate"></button>								
								</td>	
								</tr>
																	
						</cfif>  	
						
						 </cfoutput>	
								
						
						</table> 										
						

		 </cf_layoutarea>
	 
	 </cfif> 
	 
	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/>   
			
	 <cf_layoutarea position="center" name="box">									
						
			<iframe src="General.cfm?ID=#URL.ID#&topic=all&mid=#mid#" name="right" id="right" width="100%" height="100%" frameborder="0"></iframe>		
										
	 </cf_layoutarea>	
	 
		 <cfquery name="Object" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		 
			SELECT *
			FROM    OrganizationObject
			WHERE   EntityCode = 'Candidate' 
			AND     ObjectKeyValue1 = '#url.id#'	
		</cfquery>	
		
		<cfif Object.recordcount eq "1">
	 
		 <cf_layoutarea 
		   	position    = "right"
		   	name        = "topPHP"
		   	minsize	    = "390px"
			maxsize	    = "390px"
			size 	    = "390px"
			collapsible = "true" 
			initcollapsed = "true"
			splitter    = "true">	
			
			<cf_divscroll style="height:99%">
				<cf_commentlisting objectid="#Object.ObjectId#" ajax="No">		
			</cf_divscroll>		
					
		</cf_layoutarea>
		
		</cfif>
		 
</cf_layout>		 
						
</cfoutput>
