<!--
    Copyright © 2025 Promisan

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
  
<cfquery name="Source" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_Source C
  WHERE  AllowAssessment = 1
</cfquery>  

<cfif url.source eq "">
	<cfset URL.source = source.source>
</cfif>

<cfform name="formass">
	
	<input type="hidden" name="PersonNo" value = "<cfoutput>#URL.ID#</cfoutput>">
		
	<table width="98%" align="center">
	
	<tr><td height="23">
	
	<table width="100%">
	<tr class="line"><td class="labellarge"><cf_tl id="Job Assessment"></td>
	
	<td align="right">
		<table>
		
		<cfoutput query="Source">
		
			<td align="right" style="cursor: pointer;" class="labelit" onClick="reload('#source#')">
			 <table>
			     <tr>
			       <td>
					<input type="radio" id="source" name="source" value="#Description#" <cfif url.source eq "#source#">checked</cfif>> 
				   </td>
				   <td class="labelmedium" style="padding-left:3px;padding-right:6px">
					 <cfif url.source eq source><b></cfif>#Description#</b>
				   </td>	
			     </tr>
			 </table>	
			</td>	
			
		</cfoutput>
		</table>
	</td>
	</tr></table>
	
	</td></tr> 
	
	<input type="hidden" id="sourcesel" name="sourcesel" value="<cfoutput>#url.source#</cfoutput>">
		
	<tr class="line"><td height="30">
		
	<cfquery name="Parameter" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   	 	SELECT *
    	FROM   Parameter
		WHERE  Identifier = 'A'
	</cfquery>

	 <cf_filelibraryN
		DocumentPath="#Parameter.DocumentLibrary#"
		SubDirectory="#URL.ID#" 
		Filter="#URL.Owner#_#url.Source#"
		LoadScript="No"
		Insert="yes"
		Remove="yes"
		PDFScript="importpdf"
		ShowSize="yes">	
	
	</td></tr>
	
	<tr><td height="4"></td></tr>
		
	<cfquery name="Master" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM Ref_AssessmentCategory C
	  WHERE Code IN (SELECT AssessmentCategory 
	                 FROM   Ref_Assessment 
					 WHERE  Owner = '#URL.Owner#' 
					 AND    Operational = 1)	
	</cfquery>
	
	<cfloop query="Master">
	
			<cfset x = 0>
	      				
			<cfquery name="GroupAll" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   R1.Description AS CategoryDescription, R.*, A.AssessmentId AS Selected
				FROM     Ref_AssessmentCategory R1 INNER JOIN
	                     Ref_Assessment R ON R1.Code = R.AssessmentCategory LEFT OUTER JOIN
	                     ApplicantAssessment P INNER JOIN
	                     ApplicantAssessmentDetail A ON P.AssessmentId = A.AssessmentId ON R.Owner = A.Owner AND R.SkillCode = A.SkillCode AND P.Owner = '#URL.Owner#' AND 
	                     P.PersonNo = '#URL.ID#' AND A.Source = '#URL.Source#'
				WHERE    R.Owner = '#URL.Owner#'				
				AND      R.Operational = 1	  
				AND      R.AssessmentCategory = '#Master.Code#'
				ORDER BY R.AssessmentCategory, R.ListingOrder			
			</cfquery>
					
	<tr><td>
						
	       <table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
		   	    		
			<cfoutput>
							
				<tr>
				<td align="left" height="20" class="labelmedium" style="font-size:17px;padding-left:3px">#Description#</td>
				</tr>
				
				</cfoutput>
								
	    		<TR><td width="100%" >
									
			    <cfoutput>
							
				<table width="100%" border="0" align="right" id="#Code#">
				
				<tr>
				     <!---
	    			<td width="30" valign="top">&nbsp;<img src="#SESSION.root#/Images/join.gif" alt=""></td>
					--->
					<td width="100%">
					
					<table width="98%" align="left">
				
						</cfoutput>
					
					    <cfset row = 0>
											
						<cfoutput query="GroupAll">
																
							<cfif row eq "3">
							    <TR>						
								<cfset row = 0>
																				
							</cfif>
						
						    <cfset row = row + 1>
							<td width="33%">
							<table width="100%" cellspacing="0" cellpadding="0" style="border:0px solid silver">
								<cfif Selected eq "">
								    <TR class="regular">
								<cfelse> 
								     <TR class="highlight4">								         
								</cfif>								
								<td width="90%" style="padding-left:5px" class="labelit">#SkillDescription#</td>
								<TD width="10%" style="padding:5px">
								<cfif Selected eq "">
								<input type="checkbox" style="height:14px;width:14px" name="fieldid" value="#SkillCode#" onClick="hl(this,this.checked)"></TD>
								<cfelse>
								<input type="checkbox" style="height:14px;width:14px" name="fieldid" value="#Skillcode#" checked onClick="hl(this,this.checked)"></td>
								<cfset x = x + 1>
							    </cfif>
							</table>
							</td>
							<cfif GroupAll.recordCount eq "1">
	    						<td width="33%"></td>
							</cfif>
						
						</CFOUTPUT>
						
						<cfif row eq "2">
							<td width="33%"></td>
						</cfif>
						
						<cfif row eq "1">
							<td width="33%"></td><td width="33%"></td>
						</cfif>
													
				    </table>
					
					</td></tr>
					
					</table>
										
				</td></tr>
								
			</table>
			
		</td></tr>
		
		<input type="hidden" name="cl<cfoutput>#Master.Code#</cfoutput>" value="<cfoutput>#x#</cfoutput>">
			
	</cfloop>		
	
	<tr><td class="linedotted"></td></tr>
	
	<tr><td height="30" align="center">
	
	<cfoutput>
	 <INPUT class="button10g" style="width:170;height:26"
	        type="button" 
			onclick="ptoken.navigate('Assessment/AssessmentEntrySubmit.cfm?id2=edit&source=#url.source#&Owner=#url.owner#&ID=#url.id#','assessment','','','POST','formass')"
			value="Save">
	</cfoutput>		
			</td></tr>
				
	</table>

</cfform>