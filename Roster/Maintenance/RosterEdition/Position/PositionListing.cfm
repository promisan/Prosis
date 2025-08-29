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
<cfquery name="qExercise"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  E.*, 
	        S.ActionStatus, S.Owner
	FROM    Ref_ExerciseClass E INNER JOIN Ref_SubmissionEdition S
	ON      E.ExcerciseClass    = S.ExerciseClass
	WHERE   S.SubmissionEdition = '#url.submissionedition#' 	
</cfquery>

<cfquery name="getPosition" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">


	SELECT    P.Mission, 
			  P.MandateNo,	
	          P.PostGrade, 
			  SP.FunctionNo,
			  (SELECT TOP 1 FunctionDescription
			   FROM   Ref_SubmissionEditionPosition_Language
			   WHERE  SubmissionEdition = SP.SubmissionEdition
			   AND    PositionNo        = SP.Positionno
			   AND    LanguageCode      = '#client.LanguageId#') as FunctionDescription,
			   
			  (SELECT TOP 1 FunctionId
			   FROM   FunctionOrganization
			   WHERE  SubmissionEdition = SP.SubmissionEdition
			  -- AND    Mission           = P.Mission
			   AND    ReferenceNo         = SP.Reference) as FunctionId,
			   
			   (SELECT TOP 1 DocumentNo
			   FROM   FunctionOrganization
			   WHERE  SubmissionEdition = SP.SubmissionEdition
			  -- AND    Mission           = P.Mission
			   AND    ReferenceNo         = SP.Reference) as DocumentNo, 
			   
			  
			  F.FunctionDescription as PositionDescription,
			  P.PostType, 
			  P.SourcePostNumber,
			  P.PositionNo, 
			  P.PositionParentId,
			  SP.PublishMode, 
			  SP.EntityClass, 
			  SP.Reference,
			  G.PostOrder, 
			  O.Mission as MissionOperational,
			  O.OrgUnit,
              O.OrgUnitName,
			  
			  (SELECT count(*) 
			  FROM    Ref_SubmissionEditionPosition 
			  WHERE   SubmissionEdition = SP.SubmissionEdition
			  AND     PositionNo  IN (SELECT PositionNo 
			                          FROM   Employee.dbo.Position 
									  WHERE  Mission   = P.Mission
									  AND    PostGrade = P.Postgrade)
			  AND     (Reference is NULL or Reference = '')) as Pending			  
			  
   FROM       Ref_SubmissionEditionPosition AS SP INNER JOIN
              Employee.dbo.Position AS P ON SP.PositionNo = P.PositionNo INNER JOIN
              Employee.dbo.Ref_PostGrade AS G ON P.PostGrade = G.PostGrade INNER JOIN
              Organization.dbo.Organization AS O ON P.OrgUnitOperational = O.OrgUnit INNER JOIN
              FunctionTitle AS F ON SP.FunctionNo = F.FunctionNo
			  
	WHERE     SubmissionEdition = '#url.submissionedition#'		
	
	<cfif qExercise.ActionStatus eq "3" and SESSION.isAdministrator eq "No" and not findNoCase(qExercise.owner,SESSION.isOwnerAdministrator)>
						
			<!--- limit access --->		
			AND 	SP.Reference  IN (SELECT FO.ReferenceNo
			                          FROM   FunctionOrganization FO INNER JOIN RosterAccessAuthorization RA ON RA.FunctionId = Fo.FunctionId
                   			          WHERE  SubmissionEdition = SP.SubmissionEdition
			                          AND    Mission           = P.Mission			                          
			                          AND    RA.UserAccount    = '#session.acc#') 			   
								  
	</cfif>	
		
	AND       RecordStatus = '1'		  
	ORDER BY  P.Mission,G.PostOrder, P.PostGrade
	
</cfquery>


<cfif SESSION.isAdministrator eq "Yes">
	<cfset vClass="regular">
<cfelse>
	<cfset vClass="hide">	
</cfif>

<cfdiv id="dresult" class="#vClass#">

<!--- do not remove : Hanno --->
	
	<input type="hidden" id="UpdateList" name="UpdateList">
	<input type="hidden" id="reloadpos" value="">
	<table><tr><td id="refresh_listing"></td></tr></table>

<!--- --------------------- --->

<cfquery name="language"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_SystemLanguage
	WHERE    LanguageCode != ''
	AND      Operational > 0
	ORDER BY LanguageCode	
</cfquery>

<cfquery name="qSystem" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ModuleControl
	WHERE  SystemModule = 'Roster' 
	AND    FunctionClass='Maintain' 
	AND    FunctionName ='Functional Title Class'
</cfquery>

<form id="fReferences">

<table width="94%" align="center" class="navigation_table">

	<tr><td height="15"></td></tr>
		
	<cfoutput>
	<tr class="labelmedium2 line fixlengthlist">
	   <td valign="top"><cf_tl id="Grade"></td>
	   <td valign="top"><cf_tl id="Unit"></td>	 
	   <td valign="top"><cf_tl id="Function"></td>
       <td valign="top"><cf_tl id="PostNo"></td>
	   
	   <cfloop query="language">	   
	   <td width="8%" valign="top">
	   		<table width="100%">
				<tr><td colspan="2" align="center" class="labelmedium">#LanguageName#</td></tr>
				<tr>
					<!--- <td class="labelit" width="30%" align="center">Unit</td> --->
					<td class="labelit" width="50%" align="center"><cf_tl id="Title"></td>					
					<td width="50%" class="labelit" align="center"><cf_tl id="Text"></td>
				</tr>
			</table>	
	   </td>	   
	   </cfloop>
	   
	   <td valign="top">
	   
		   	<table width="100%">
			    
				<tr class="labelmedium2">
				<td align="right">JO&nbsp;No</td>
			    <td align="right" style="padding-right:4px">		
				    <cfif qExercise.actionStatus eq "0">
					<a href="javascript:referencereset('#url.submissionedition#')">reset</a>
					</cfif>
					</td>
				</tr>
			</table>
	 						
	   </td>	   
     </tr>
     </cfoutput>   
	
	<cfoutput query="getPosition" group="Mission">
		
		<tr><td class="labellarge" colspan="5" style="padding-left:3px;font-weight:bold;font-size:17px;height:30px">#Mission#</td></tr>
	
		<cfoutput group="Postorder">
		
			<tr class="line">
				<td class="labelmedium" colspan="#4+language.recordcount*2#" style="height:20px;font-size:15px;width:100px;padding-left:4px">#PostGrade#</td>
				
				<cfif qExercise.actionStatus eq "0">
				
					<cfif pending gte "1">
					<td class="labelit" align="right" id="apply#PostGrade#">
						<a href="javascript:referenceapply('#url.submissionedition#','#mission#','#PostGrade#')">apply
						</a>
					</td>
					</cfif>
				
				</cfif>
				
			</tr>	
			
			<cfoutput>
				
				<tr id="row_#positionno#" style="height:20px" class="line labelmedium navigation_row fixlengthlist">
				
				   <td align="right" style="padding-right:5px;padding-top:1px">
				   		<cfif qExercise.actionStatus eq "0">
							<input type="hidden" name="PublishMode_#positionno#" id="PublishMode_#positionno#" value="#PublishMode#">
							<cfif PublishMode eq 1>
								<a href="javascript:togglePublishMode('#submissionedition#','#positionno#')">
									<img src="#client.root#/images/light_green1.gif" width="13px" id="imgPublishMode_#positionno#" title="Disable" border="0">
								</a>
							<cfelseif PublishMode eq 0>
								<a href="javascript:togglePublishMode('#submissionedition#','#positionno#')">
									<img src="#client.root#/images/light_red1.gif" width="13px" id="imgPublishMode_#positionno#" title="Enable" border="0">
								</a>
							</cfif>
						</cfif>
				   </td>
					
				   <td><cfif MissionOperational neq Mission>#missionOperational#/</cfif>#OrgUnitName#</td>
				   <td style="padding-left:15px;padding-right:7px">
				   
				   <cfif qExercise.actionStatus eq "0">
				   
					   	<table cellspacing="0" cellpadding="0">
						<tr style="height:20px" class="labelmedium">					
						
						<td width="20" style="padding-top:1px">
						
						<cf_img icon="open" onClick="selectfunction('webdialog','','','#qExercise.owner#','#submissionedition#','#positionno#')">
																									
						</td>
										
						<td style="padding-left:5px" id="title#positionno#" style="cursor:pointer">				   				    	
						    <a href="javascript:editeditionposition('#positionno#','#url.submissionedition#','#qSystem.SystemFunctionId#')" class="navigation_action">
						   	<font id="#positionno#_title"><cfif FunctionDescription eq "">#PositionDescription#<cfelse>#FunctionDescription#</cfif></font>										
							</a>	
												
						</td>
						
						</tr></table>
					
				   <cfelse>
				   
			   		  <font id="#positionno#_title">
						 <cfif FunctionDescription eq "">#PositionDescription#<cfelse>#FunctionDescription#</cfif>
				   </cfif>	
					
				   </td>
				  
				   <td>
				   <cfif qExercise.actionStatus eq "0">
				  		<a href="javascript:EditPosition('#getPosition.Mission#','#getPosition.MandateNo#','#positionno#','listing')">#SourcePostNumber#</a>
				   <cfelse>
				   		#SourcePostNumber#
				   </cfif>
		           </td>
				   
				   <cfset URL.positionNo = "#PositionNo#">
				   <cfloop query="language">	   
				   <td>
				   		<table width="100%" border="0">
						
							<cfset URL.languagecode = language.languagecode>
							<cfset URL.lcode        = language.code>
							<cfset URL.linechecking = "Reference">
						    <cfset URL.display = "No">
							<tr>
								
								<td align="center" style="border-left:1px solid silver">
								
								<cfset URL.linechecking = "Functions">
								<cfinclude template="../../../../Custom#qExercise.PathPublishText#EditionVerificationLine.cfm">
								<cfif response eq 0>
									<img src="#SESSION.root#/images/icon_stop.gif">
								<cfelse>	
									<img src="#SESSION.root#/images/help_answer2.gif">
								</cfif>		
															
								</td>
								
								<td align="center" style="border-left:1px solid silver;<cfif currentrow eq recordcount>border-right:1px solid silver</cfif>">
								
								<cfset URL.linechecking = "Reference">
								<cfinclude template="../../../../Custom#qExercise.PathPublishText#EditionVerificationLine.cfm">
								<cfif response eq 0>
									<img src="#SESSION.root#/images/icon_stop.gif">
								<cfelse>	
									<img src="#SESSION.root#/images/help_answer2.gif">
								</cfif>			
											
								</td>						
													
							</tr>
						</table>	
				   </td>			   	   
				   
				   </cfloop>
				   
				   <td>
				   				   			   
				       <table width="100%">
					   
					   <tr class="labelmedium fixlengthlist" style="height:20px">
					   
					   <td id="reference_#positionno#" align="right" style="padding-right:10px">				  
					   		
						   <cfif reference eq "" and qExercise.actionStatus eq "0">
						  
							  	<input type="checkbox" name="groupreference" value="#positionno#">
								
									 
							<cfelse>
							
									<cfif functionid neq "">								
									<a href="javascript:details('#functionid#')" title="Open candidate bucket" class="navigation_action">#reference#</a>
									<cfelse>								
									#reference#
									</cfif>
									<cfif documentNo neq "">
									| <a href="javascript:showdocument('#documentno#')" title="Open recruitment track">#documentNo#</a>
									</cfif>
								
							</cfif>		 
						
					   </td>
					   </tr>
					   
					   </table>
					  	
				   </td>
			   
			   </tr>
				   			
			</cfoutput>
		
		</cfoutput>
	
	</cfoutput>

	<cfoutput>	
	
	<!--- 
	<tr><td>Prepare package, send repeatedly and close</td></tr>	
	--->
	
	<!---
	
	<tr><td colspan="#5+language.recordcount*2#" class="linedotted"></td></td>

	<cfset vClass = "button10s">
		
	<cfif qBroadcast.recordcount eq 0>
		<cfset vClass = "hide">				
	<cfelse>
		<cfset vClass = "button10p">	
	</cfif>		
	
	<tr><td colspan="#5+language.recordcount*2#" align="center" style="padding-top:4px">
		<table width="100%">
		<tr height="30">
			<td width="100%" colspan="3"></td>
		</tr>
		<tr>
		<td align="center" width="33%">
			<input type="button" id="Prepare" name="Prepare" value="Prepare Package..." class="button10p" style="width:140" onclick="publishedition('#url.submissionedition#','#qExercise.PathPublishText#')">
		</td>
		<td align="center" width="33%">
			<input type="button" id="Send" name="Send" value="Send" class="#vClass#" style="width:140" onclick="doSend()">	
		</td>
		<td align="center" width="33%">
			<input type="button" id="Lock" name="Lock" value="Lock" class="#vClass#" style="width:140" onclick="doLock()">		
		</td>	
		</tr>
		
		<!---
		<tr>
			<td align="center" width="33%"></td>
			<td align="center" width="33%">
				<p id="lbldate">
					<cfif qBroadcast.recordcount neq 0>
						Last preparation on :#DateFormat(qBroadcast.Created,'#CLIENT.DateFormatShow#')# #TimeFormat(qBroadcast.Created,'HH:mm:ss')#
					</cfif>	
				</p>
				
			</td>
			<td align="center" width="33%"></td>
		</tr>
		--->
		
		</table>
	
	
	</td></tr>
	
	--->
	
	</cfoutput>

</table>

</form>

<cfset ajaxonload("doHighlight")>
