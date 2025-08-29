<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="url.drillid"           default="">
<cfparam name="url.elementid"         default="">
<cfparam name="url.caseelementid"     default="">
<cfparam name="url.forclaimid"        default="">

<cfquery name="Class" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT   *
	     FROM     Ref_ElementClass 
		 WHERE    Code = '#url.elementclass#'				
</cfquery>

<cfquery name="getTopicList" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT     R.*, S.ElementSection
	     FROM       Ref_Topic R INNER JOIN Ref_TopicElementClass S ON R.Code = S.Code
		 WHERE      ElementClass = '#url.elementclass#'	
		 AND        Operational = 1
		 AND        (Mission = '#url.Mission#' or Mission is NULL)			
		 ORDER BY   S.ListingOrder,R.ListingOrder 
</cfquery>

<cfif url.drillid eq "" and class.enableMatching eq "1"> 
   <cfset locmatch = "retrievematched()">	 	
<cfelse>
   <cfset locmatch = "">	   
</cfif>

<cfinvoke component = "Service.Access"  
	   method           = "CaseFileManager" 	   
	   returnvariable   = "access"
	   Mission          = "#url.mission#">				

<!--- --------------------------------------------------------------------------------------- --->
<!--- determine the claim id from the prior caseelement usually as part of the add new option --->
<!--- --------------------------------------------------------------------------------------- --->

<cfif url.caseelementid neq "">
		
	<cfquery name="CaseElement" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 SELECT   *
	     FROM     ClaimElement			
		 WHERE    CaseElementId = '#url.caseelementid#'	
	</cfquery>
	
	<cfif caseelement.recordcount eq "1">	
	
	    <!--- determine the claimid to be add based on the prior record that was handled --->
		<cfset url.forclaimid = "#caseelement.claimid#">	
		
	<cfelseif url.elementid neq "">	
		
	</cfif>

</cfif>

<!--- --------------------------------------------------------------------------------------- --->
<!--- determined that we need to create a new record here ---------------------------------- --->
<!--- --------------------------------------------------------------------------------------- --->

<cfif url.drillid eq "">
    <cf_assignid>
    <cfset url.caseelementid = rowguid>	
<cfelse>
	<cfset url.caseelementid = url.drillid>
</cfif>	

<cfquery name="CaseElement" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT   *
     FROM     ClaimElement			
	 WHERE    CaseElementId = '#url.caseelementid#'	
</cfquery>

<cfif CaseElement.recordcount eq "1">

	  <!--- click on edit --->      
	  <cfset url.claimid     = "'#caseelement.claimid#'">	
	  <cfset url.elementid   = caseelement.elementid>	  
				  
	  <cfquery name="Element" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			 SELECT   *
		     FROM     Element			
			 WHERE    ElementId = '#CaseElement.elementid#'				
	  </cfquery>	  
	   
	  <cfset url.elementclass = element.elementclass>
	  
<cfelse>

	  <cfif url.elementid eq "">

		  <cf_assignid>	
		  <cfset url.elementid = rowguid>
		  
		    <cfquery name="Element" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			 SELECT   *
		     FROM     Element			
			 WHERE    1=0				
	        </cfquery>
		  
	  <cfelse>
	  	  
		   <cfquery name="Element" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				 SELECT   *
			     FROM     Element			
				 WHERE    ElementId = '#url.elementid#'				
		  </cfquery>	  
		  
		  <cfif element.recordcount eq "1">
		  	
		  <cfset url.elementclass = element.elementclass>	  
		  
		  </cfif>
		  
	  </cfif>	  	
		  		  
</cfif>

<cfif url.elementclass eq "Person">
 <cfset rows = 18>
<cfelse>
 <cfset rows = "#gettopiclist.recordcount+1#"> 
</cfif>

<cfoutput>

<!--- -------------------- --->
<!--- the form starts here --->
<!--- -------------------- --->

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formspacing formpadding">
<tr><td>

<cfform method="POST" name="elementform" onsubmit="return false">
    
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formspacing formpadding">

	<cfset withincase = "1">
		  
	<cfif url.elementid neq "" and url.forclaimid neq "">
			
		 <cfquery name="getClaimElement" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			 SELECT *
			 FROM   ClaimElement CE			
			 WHERE  CE.ClaimId   = '#url.forclaimid#'
			 AND    CE.ElementId = '#url.elementid#'				
		  </cfquery>	
			 		  
		  <cfif getClaimElement.recordcount eq "0"> 
		  
		    <cfquery name="get" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			 SELECT *
			 FROM   Claim C, ClaimElement CE
			 WHERE  C.ClaimId = CE.ClaimId			
			 AND    CE.ElementId = '#url.elementid#'		
		    </cfquery>	
			
			<cfset withincase = "0">
			
			<cfif get.recordcount gt "0">
					  	
			    <tr><td height="20" colspan="4" align="center" class="labelit">Attention : This element was recorded under: <cfloop query="get"><a href="javascript:showclaim('#claimid#','#mission#')"><font color="0080C0">#get.DocumentNo# #get.DocumentDescription#</font></a>&nbsp;</cfloop></font></td></tr>
		  		<tr><td colspan="4" class="line"></td></tr>
					
			</cfif>
					
		  </cfif>
				  
	</cfif> 			
	
    <cfset row = 0>		
						
	<tr>	
							
		<cfif class.enableReference eq "1" and element.recordcount eq "1">
															
			<td style="width:170px" class="labelit"><cf_tl id="Element reference">:</td>
				
			<td width="90%">
				
					<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
					<tr>
					
					<cfif class.enableReference eq "1">
					
						<td width="10%"  style="padding-right:1px" class="labelit">

						<cfif URL.Mode eq "edit">
						
							<cfif class.ReferencePrefix neq "">
														
							  	 <input type="text" 
							      name="ElementReference" 
								  onchange="#locmatch#" 
								  value="#element.reference#" 
								  size="10" 
								  style="text-align:center"
								  readonly
								  maxlength="20" 
								  class="regularxl">	  
							
							<cfelse>						
							
							      <input type="text" 
							      name="ElementReference" 
								  onchange="#locmatch#" 
								  value="#element.reference#" 
								  size="10" 
								  maxlength="20" 
								  class="regularxl">
								  
							</cfif>	  
						   
						<cfelse>
						
							<cfif element.personno neq "">
								<a href="javascript:ShowCandidate('#personno#')"><font color="0080C0">#element.reference#</font></a>
							<cfelse>
								#element.reference#
							</cfif>
						
						</cfif>
						
						</td>												
					
					</cfif>
														
					<cfif url.mode neq "view" and url.drillid neq "" and access eq "ALL">
						
						<td align="right" class="labelit">
												
				           <cfoutput>			
						   
						   	   <cf_tl id="Purge Element" var="1">
							   <cfset vPurge = #lt_text#>
						   	   <cf_tl id="Do you want to completely remove this element ?" var="1">
								
								<cfquery name="Check" 
										datasource="AppsCaseFile" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										 SELECT   *
									     FROM     Element E	
										 WHERE    E.ElementId = '#url.elementid#'		
										 AND  (  ElementId IN (SELECT SourceElementId FROM ClaimElement WHERE SourceElementid = E.ElementId)
													 OR  	 
											     ElementId IN (SELECT RelationElementId FROM ElementRelation WHERE RelationElementId = E.ElementId)			
											  )	 
							   </cfquery>
							   								   									
							   <cfif check.recordcount eq "0">
						   
							   <input type="button" 
									name="Delete" 
									value="#vPurge#" 
									class="button10g" 					   
									onclick="if (confirm('#lt_text#')) { ColdFusion.navigate('ElementDelete.cfm?action=purge&elementid=#url.elementid#','contentbox1') }" 					  
									style="height:24;width:160px">	
									
								</cfif>
								
								<cfquery name="Check" 
										datasource="AppsCaseFile" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										 SELECT   *
									     FROM     Element E		
										 WHERE    E.ElementId = '#url.elementid#'			
										 AND      ElementId IN (SELECT SourceElementId FROM ClaimElement WHERE SourceElementid = E.ElementId)												
							    </cfquery>
							   
							    <cfif check.recordcount eq "0" and withincase eq "1">
				   
					   				<cf_tl id="Remove from Case File" var="1">
									<cfset vClear = #lt_text#>
					   				<cf_tl id="Do you want to remove this element from the case but keep the element itself ?" var="1">
					   
								    <input type="button" 
										name="Delete" 
										value="#vClear#" 
										class="button10g" 					   
										onclick="if (confirm('#lt_text#')) { ColdFusion.navigate('ElementDelete.cfm?action=remove&caseelementid=#url.drillid#','contentbox1') }" 					  
										style="height:24;width:160px">	
									
								 </cfif>	
									
							</cfoutput>			
												
						</td>
												
					</cfif>
					
					</tr>
					</table>
					
				</td>	
												
			<cfelse>
			
				<input type="hidden" name="form.elementReference" value="">		
				
				<tr>
								
				<td colspan="2"></td>
								
				<cfif url.mode neq "view" and url.drillid neq "" and access eq "ALL">
						
						<td align="left" class="labelit">
						
				           <cfoutput>			
						   
						   	   <cf_tl id="Purge Element" var="1">
							   <cfset vPurge = #lt_text#>
						   	   <cf_tl id="Do you want to completely remove this element ?" var="1">
								
								<cfquery name="Check" 
										datasource="AppsCaseFile" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										 SELECT   *
									     FROM     Element E	
										 WHERE    E.ElementId = '#url.elementid#'		
										 AND  (  ElementId IN (SELECT SourceElementId FROM ClaimElement WHERE SourceElementid = E.ElementId)
													 OR  	 
											     ElementId IN (SELECT RelationElementId FROM ElementRelation WHERE RelationElementId = E.ElementId)			
											  )	 
							   </cfquery>
							   						   
							   								   									
							   <cfif check.recordcount eq "0">
						   
							   <input type="button" 
									name="Delete" 
									value="#vPurge#" 
									class="button10s" 					   
									onclick="if (confirm('#lt_text#')) { ColdFusion.navigate('ElementDelete.cfm?action=purge&elementid=#url.elementid#','contentbox1') }" 					  
									style="height:18;width:160px">	
									
								</cfif>
								
								<cfquery name="Check" 
										datasource="AppsCaseFile" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										 SELECT   *
									     FROM     Element E		
										 WHERE    E.ElementId = '#url.elementid#'			
										 AND      ElementId IN (SELECT SourceElementId FROM ClaimElement WHERE SourceElementid = E.ElementId)												
							    </cfquery>
							   
							    <cfif check.recordcount eq "0" and withincase eq "1">
				   
				   				<cf_tl id="Remove from Case File" var="1">
								<cfset vClear = #lt_text#>
				   				<cf_tl id="Do you want to remove this element from the case but keep the element itself ?" var="1">
				   
							    <input type="button" 
									name="Delete" 
									value="#vClear#" 
									class="button10s" 					   
									onclick="if (confirm('#lt_text#')) { ColdFusion.navigate('ElementDelete.cfm?action=remove&caseelementid=#url.drillid#','contentbox1') }" 					  
									style="height:18;width:160px">	
									
								 </cfif>	
									
							</cfoutput>			
												
						</td>
				
				<cfelse>
				
				<td></td>
				
				</cfif>		
											
			</cfif>		
						
		</tr>		
				 						
		<cfquery name="Case" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Claim
				<cfif url.forclaimid neq "">
				WHERE  ClaimId = '#url.forclaimid#'						
				<cfelse>
				WHERE 1=0
				</cfif>
		</cfquery>		
		
		<!--- -------------------------------------------- --->
		<!--- show selection of a dependent for an element --->		
		<!--- -------------------------------------------- --->
								
		<cfif class.enableDependent eq "1" and Case.PersonNo neq "">
			
			<cfset row = row+1>
			
			<tr>
			
			<td class="labelit" height="25">&nbsp;#row#.</td>	
			<td class="labelit"><cf_tl id="Dependent">:<cf_space spaces="50"></td>
				
			<td width="75%" style="z-index:20; position:relative;padding:0px">		
																							
						<cfquery name="Dependent" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT *
								FROM   PersonDependent
								WHERE  PersonNo = '#Case.PersonNo#'
						</cfquery>
						
						<select name="DependentId">
							<option value="">n/a</option>
							<cfloop query="Dependent">
								<option value="#dependentid#" <cfif Element.dependentid eq dependentid>selected</cfif>>#FirstName# #LastName# [#Gender#] #dateformat(BirthDate,CLIENT.DateFormatShow)#</option>
							</cfloop>
						</select>	
													
				</td>	
				
			</tr>
			
		</cfif>					
		
		<!--- --------------------------------------------- --->
		<!--- special embedded fields for person class only --->
		<!--- --------------------------------------------- --->
				
		<cfquery name="getSection" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
				SELECT *
				FROM  Ref_ElementSection
				WHERE Code IN (#quotedValueList(getTopicList.ElementSection)#)
				ORDER BY ListingOrder
		</cfquery>		
		
		<cfquery name="Get" 
		datasource="AppsSelection">
			SELECT *
			FROM   Applicant A, 
			       ApplicantSubmission S
			WHERE  A.PersonNo = S.PersonNo
			AND    S.PersonNo = '#Element.PersonNo#'  			
		</cfquery>	
		
		<cfquery name="Nation" 
		datasource="AppsSystem">
		    SELECT    Code,Name 
		    FROM      Ref_Nation
			WHERE     Operational = '1'
			ORDER BY  Name
		</cfquery>
		
		<cfif getSection.recordcount eq "1">
		
		     <!--- show all sections --->
			<cfset sectionselect = "">		
						
			<tr>
			
		    <td colspan="4" height="30" style="padding-top:5px;padding-left:10px;padding-right:10px">	
							
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">		
				
				<tr><td width="100%">
										
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">		
					
					<input type="hidden" name="applicantno" value="#get.applicantno#" size="20" maxlength="20" class="regular">	
					<cfinclude template="ElementEditCustom.cfm">					
						
					</table>
					
				</td>
				
				<cfif class.enablepicture eq 1>		
		
					<td align="right" valign="top" id="picturebox" style="padding-left:3px">
																								
								<cfif url.elementclass eq "person" and Element.PersonNo neq "">
								
										<cf_PictureView documentpath="Applicant"
								                subdirectory="#Element.PersonNo#"
												filter="Picture_" 							
												width="140" 
												height="180" 
												mode="edit">			
								
								<cfelse>
								
									<cf_PictureView documentpath="CaseFileElement"
								                subdirectory="#url.elementid#"
												filter="Picture_" 							
												width="140" 
												height="180" 
												mode="edit">			
												
								</cfif>	
						
													
					</td>
						
				</cfif>
			
				</tr>
				
				</table>
													
			</td>
			
			</tr>		
		
		<cfelse>				
					
			<tr>
			
			    <td colspan="3" height="30" style="border:0px dotted silver;padding-top:5px;padding-left:20px;padding-right:20px">
				
					<table width="100%" border="0" cellspacing="0" cellpadding="0">		  		
									
						<cfset ht = "29">
						<cfset wd = "29">
											
						<tr>		
						
						<cfloop query="getSection">
						
							<cfif currentrow eq "1">
							   <cfset cl = "highlight1">						   
							<cfelse>
							   <cfset cl = "regular">   
							</cfif>
																	
							<cf_menutab base="personmenu" 
							    item       = "#currentrow#" 
					            iconsrc    = "#ListingIcon#" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								target     = "personbox"
								selected   = "#cl#"
								name       = "#ListingLabel#">						
							
						</cfloop>													
								
						<td width="20%"></td>								 		
							
						</tr>
						
						</table>
												
				</td>
				
			</tr>	
			
			<tr><td height="3"></td></tr>
									
			<tr><td colspan="2" style="padding-left:20px;border:0px dotted silver">
														
				<cfquery name="PHPParameter" 
				  datasource="AppsSelection" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT   TOP 1 *
				  FROM     Parameter
				</cfquery>	
									
				<cfquery name="Get" 
				datasource="AppsSelection">
					SELECT *
					FROM   Applicant A, 
					       ApplicantSubmission S
					WHERE  A.PersonNo = S.PersonNo
					AND    S.PersonNo = '#Element.PersonNo#'  			
				</cfquery>					
				
				<cfquery name="Nation" 
				datasource="AppsSystem">
				    SELECT    Code,Name 
				    FROM      Ref_Nation
					WHERE     Operational = '1'
					ORDER BY  Name
				</cfquery>
										
				<input type="hidden" name="applicantno" value="#get.applicantno#" size="20" maxlength="20" class="regular">	
								
				<table width="100%" cellspacing="0" cellpadding="0" valign="top">	
								
				<cfloop query="getSection">
				
					<cfif currentrow eq "1">
						<cfset cl = "regular">
					<cfelse>
						<cfset cl = "hide">   
					</cfif>
										
					<cf_menucontainer name="personbox" item="#currentrow#" class="#cl#">				
					    <table width="100%" cellspacing="0" cellpadding="0" valign="top" class="formpadding">	
						 <cfset sectionselect = "#code#">
						     <cfinclude template="ElementEditCustom.cfm">					
						</table>
					<cf_menucontainer>
											
				</cfloop>
				
				</table>	
								
				</td>
				
				<cfif class.enablepicture eq 1>		
			
				<td align="right" valign="top" id="picturebox" style="padding-left:3px;padding-right:3px">
																		
					<cfif url.elementclass eq "person" and Element.PersonNo neq "">
					
							<cf_PictureView documentpath="Applicant"
					                subdirectory="#Element.PersonNo#"
									filter="Picture_" 							
									width="140" 
									height="180" 
									mode="edit">			
					
					<cfelse>
					
						<cf_PictureView documentpath="CaseFileElement"
					                subdirectory="#url.elementid#"
									filter="Picture_" 							
									width="140" 
									height="180" 
									mode="edit">			
									
					</cfif>		
																
				</td>
				
				</cfif>
			
			</tr>																				
								
	</cfif>		
		
	<cf_fileExist
			DocumentPath="CaseFileElement"
			SubDirectory="#URL.elementid#" 						
    		Filter = "">	
	
	<cfif files gte "1" or url.mode eq "edit">

		<tr><td height="5"></td></tr>
				  			
		<tr>
			
			<td colspan="4" style="border:1px dotted silver;padding-top:5px;padding-left:20px;padding-right:20px">
													
				<cfif url.mode eq "Edit">
					
						<cf_filelibraryN
							DocumentPath="CaseFileElement"
							SubDirectory="#URL.elementid#" 
							Filter = ""						
							Presentation="all"
							Insert="yes"
							Remove="yes"
							width="100%"									
							border="1">	
							
				<cfelse>
				
						<cf_filelibraryN
							DocumentPath="CaseFileElement"
							SubDirectory="#URL.elementid#" 						
							Filter = ""			
							Insert="no"
							Remove="no"							
							width="100%"			
							border="1">	
				
				</cfif>	
								
			</td>
		</tr>
			
	</cfif>
	
	<cfif url.drillid eq "" and element.recordcount eq "0">
					
		<tr><td colspan="4" align="center" height="33">
		
		  <table cellspacing="0" cellpadding="0" align="center" class="formspacing">
		  <tr>
		  <td>
		  
		   	<cfif class.enableMatching eq "1">
		
			<cf_tl id="Check Match" var="1">
		
			   <button name="Validate"
		           value="#lt_text#"
		           class="button10g"
		           style="height:28;width:140px"
		           onClick="retrievematched('#url.caseelementid#')"><img src="#Client.VirtualDir#/images/matching.gif" align="absmiddle" height="16" width="16" border="0">&nbsp;#lt_text#</button>			  
				   
			</cfif>	   
				   
		  </td>
		  
		  <td>
		   
			   <cf_tl id="Save" var="1">
			   			   
			   <input type="button" 
					   name="Save" 
					   value="#lt_text#" 
					   class="button10g" 					   
					   onclick="validate('close','#url.caseelementid#','#url.elementid#','1','')" 					  
					   style="height:28;width:140px">			
					   
			</td>
			
			<td>		   	   
			  				   
				<cf_tl id="Save and New" var="1">

				<input type="button" 
					   name="Save" 
					   value="#lt_text#" 
					   class="button10g" 					   
					   onclick="validate('new','#url.caseelementid#','#url.elementid#','1','')" 					  
					   style="height:28;width:140px">			      		  
				   
		  </td>
		  </tr>
		  </table>			
		   
		</td></tr>
	
	<cfelse>
	
		<cfif url.mode neq "view">
			
		<tr><td colspan="4" align="center" height="33">
		
		           <cfoutput>					   
				          							
					<cf_tl id="Save" var="1">
					<input type="button" 
						   name="Save" 
						   value="#lt_text#" 
						   class="button10g" 					   
						   onclick="validate('open','#url.caseelementid#','#url.elementid#','0','')" 					  
						   style="height:25;width:140px">	
						   
					<cfif url.drillid neq "">	   
						   
					<cf_tl id="Save and New" var="1">
					<input type="button" 
						   name="Save" 
						   value="#lt_text#" 
						   class="button10g" 					   
						   onclick="validate('new','#url.caseelementid#','#url.elementid#','0','')" 					  
						   style="height:25;width:140px">			   	
						   
					</cfif>	   
						   
					<cf_tl id="Save and Close" var="1">
					
					<input type="button" 
						   name="Save" 
						   value="#lt_text#" 
						   class="button10g" 					   
						   onclick="validate('close','#url.caseelementid#','#url.elementid#','0','')" 					  
						   style="height:25;width:140px">		 
						
					</cfoutput>			
								
			</td>
		</tr>	
		
		</cfif>		
	
	</cfif>	
				
	<cfif url.drillid eq "">
					
		<tr><td id="boxmatched" colspan="4" width="95%" align="center" valign="top">					
			<!--- locate existing records to be selected --->			
		</td></tr>	
	
	<cfelse>		
		
		<tr><td colspan="4" class="linedotted"></td></tr>
		
		<tr><td colspan="4" width="100%" align="right" style="padding-top:2px;padding-right:16px" class="labelit">
		<font color="808080"><cf_tl id="Element recorded by">:</font>
				
			   <cfoutput>#Element.OfficerFirstName# #Element.OfficerLastName# <cf_tl id="on"> #dateformat(Element.created,CLIENT.DateFormatShow)#</cfoutput>  
			
		</td>
		</tr>	
		
	
	</cfif>	
		
	</table>
			
	</cfform>	
	
</td></tr>

</table>	
	
</cfoutput>	
