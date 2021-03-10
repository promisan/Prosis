
<!--- Hanno : we need a provision for the online user to process it, even if allowedit = 0 --->

<cfparam name="url.applicantno" default="0">
<cfparam name="URL.ID3"         default="#url.applicantno#">
<cfparam name="URL.ID4"         default="">
<cfparam name="URL.source"      default="Manual">  

<cfparam name="url.section" 	default="">
<cfparam name="url.entryScope"  default="Backoffice">
<cfparam name="url.Scope"       default="">

<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Parameter
</cfquery>

<cfquery name="getSource" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Source
	WHERE   Source = '#url.source#'
</cfquery>


<cfquery name="Detail" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   L.*, 
	         R.LanguageClass, 
		     R.ListingOrder, 
		     R.LanguageName, 
			 S.Source,
			 So.AllowEdit
	FROM     ApplicantSubmission S, ApplicantLanguage L, Ref_Language R, Ref_Source So
	WHERE    S.PersonNo        = '#URL.ID#'
	  AND    S.ApplicantNo     = L.ApplicantNo
	  <cfif url.applicantno neq "0">
	  AND    S.ApplicantNo     = '#url.applicantno#'
	  </cfif>
	  AND    S.Source          = So.Source  
	  <!--- we show from any source the data here for now to give a full picture
	  AND    So.Source     = '#url.source#'  
	  --->
	  AND    L.LanguageId      = R.LanguageId
	ORDER BY LanguageClass, ListingOrder, LanguageName
</cfquery>

<cfif url.entryScope eq "Backoffice">
	
	<cfinvoke component="Service.Access"  
	 	method="roster" 
	 	returnvariable="Access"
 		role="'AdminRoster','CandidateProfile'">
 	
<cfelseif url.entryScope eq "Portal"> 
 	<cfset Access = "ALL"> 	
</cfif>

 
<cfif URL.Topic neq "All">  

	<form name="languageform">
	
</cfif>

<input type="hidden" name="PersonNo" id="PersonNo" value="<cfoutput>#URL.ID#</cfoutput>">

	<table width="96%" align="center">
		
		<cfif URL.Topic neq "All">
		
		<tr><td style="font-size:28px;padding-top:8px;height:46px;padding-left:5px" class="labellarge"><cf_tl id="Languages"></td></tr>
		
		<cfelse>
		
		<tr><td height="5"></td></tr>
		
		</cfif>
		   		
		<tr>
		  <td style="padding-left:0px">
			
			<table width="100%" align="center" class="formpadding navigation_table">
			
			<TR class="labelmedium2 line">
			    <td height="20" width="20%" style="padding-left:40px" align="left"><cfif url.entryScope eq "Backoffice"><cf_tl id="Name"></cfif></td>
				<TD width="11%"  align="center"><cf_tl id="Native"></TD>
			    <TD width="8%"   align="center"><cf_tl id="Prof."></TD>
			   
				<TD width="11%"  align="center"><cf_tl id="Read"></TD>
				<TD width="11%"  align="center"><cf_tl id="Write"></TD>
				<TD width="11%"  align="center"><cf_tl id="Speak"></TD>
				<TD width="11%"  align="center"><cf_tl id="Understand"></TD>
				<cfif url.entryScope eq "Backoffice">
			    <TD width="8%"  align="center"><cf_tl id="Clearance"></TD>
				<TD width="10%" align="center"><cf_tl id="Source"></TD>
				<cfelse>
				<TD width="8%"  align="center"><cf_tl id="Source"></TD>
				<TD width="8%"  align="center"></TD>
				</cfif>
			</TR>
				
			<cfif Access eq "EDIT" or Access eq "ALL">
			
					<CFOUTPUT query="Detail" group="LanguageClass">
					
					<TR class="linedotted">
					<td colspan="11" style="padding-left:23px;font-size:20px;height:42px;padding-top:5px" class="labellarge">
					<font color="0080C0">
					<cfif LanguageClass eq "Official"><cf_tl id="#LanguageClass#"><cfelse><cf_tl id="Other Languages"></cfif>
					</font>
					</td>
					</tr>	
							
					<cfoutput>
									
					<cfif URL.ID4 eq LanguageId and URL.source eq Source>
					
					<tr class="navigation_row linedotted labelmedium2" style="height:35px">
					<TD style="padding-left:45px">#LanguageName#</TD>
					<TD align="center" class="regular">
							<INPUT type="checkbox" class="radiol" name="Mothertongue" value="1" <cfif MotherTongue eq "1">checked</cfif>>
					</TD>
					<td align="center">
							<INPUT type="checkbox" class="radiol" name="Proficiency" id="Proficiency" value="1" <cfif Proficiency eq "1">checked</cfif>>
							<input type="hidden" class="radiol" name="Select" id="Select" value="#LanguageId#">
					</td>					
					<TD align="center" class="regular">
						  <select name="LevelRead" id="LevelRead" required="Yes"  class="regularxl">
							<option value="1" <cfif LevelRead eq "1">selected</cfif>><cf_tl id="High"></option>
							<option value="2" <cfif LevelRead eq "2">selected</cfif>><cf_tl id="Medium"></option>
							<option value="3" <cfif LevelRead eq "3">selected</cfif>><cf_tl id="Low"></option>
							<option value="9" <cfif LevelRead eq "9">selected</cfif>>N/A</option>
						  </select>	
					</TD>
					<TD align="center" class="regular">
						  <select name="LevelWrite" id="LevelWrite" required="Yes" class="regularxl">
							<option value="1" <cfif LevelWrite eq "1">selected</cfif>><cf_tl id="High"></option>
							<option value="2" <cfif LevelWrite eq "2">selected</cfif>><cf_tl id="Medium"></option>
						    <option value="3" <cfif LevelWrite eq "3">selected</cfif>><cf_tl id="Low"></option>
							<option value="9" <cfif LevelWrite eq "9">selected</cfif>>N/A</option>
						  </select>	
					</TD>
					<TD align="center" class="regular">
						  <select name="LevelSpeak" id="LevelSpeak" required="Yes" class="regularxl">
							<option value="1" <cfif LevelSpeak eq "1">selected</cfif>><cf_tl id="High"></option>
							<option value="2" <cfif LevelSpeak eq "2">selected</cfif>><cf_tl id="Medium"></option>
							<option value="3" <cfif LevelSpeak eq "3">selected</cfif>><cf_tl id="Low"></option>
							<option value="9" <cfif LevelSpeak eq "9">selected</cfif>>N/A</option>
						  </select>	
					</TD>
					<TD align="center" class="regular">
						  <select name="LevelUnderstand" id="LevelUnderstand" required="Yes" class="regularxl">
							<option value="1" <cfif LevelUnderstand eq "1">selected</cfif>><cf_tl id="High"></option>
							<option value="2" <cfif LevelUnderstand eq "2">selected</cfif>><cf_tl id="Medium"></option>
							<option value="3" <cfif LevelUnderstand eq "3">selected</cfif>><cf_tl id="Low"></option>
							<option value="9" <cfif LevelUnderstand eq "9">selected</cfif>>N/A</option>
						  </select>	
					</TD>
					<cfif url.entryScope eq "Backoffice">
						<td align="center"></td>
						<td align="center"></td>
					</cfif>
						
						<td align="center" colspan="3" style="padding-right:5px">
						<cfif URL.Topic neq "All">  
						    <input type="button" value=" Save " class="button10g"
							   onclick="Prosis.busy('yes');ptoken.navigate('#SESSION.root#/roster/candidate/details/Language/LanguageSubmit.cfm?entryScope=#url.entryScope#&applicantno=#url.applicantno#&section=#url.section#&source=#url.source#&ID2=#URL.ID2#&ID3=#URL.ID3#&ID4=#URL.ID4#&Topic=#URL.Topic#','languagebox','','','POST','languageform')">				
						<cfelse>
							<input type="submit" value=" Save " class="button10g">
						</cfif>	
						</td>
					
					<cfelse>
					
					<cfif MotherTongue eq "1">
						<cfset cl = "ffffaf">					
					<cfelse>
					    <cfset cl = "">
					</cfif>
					
					<tr bgcolor="#cl#" class="navigation_row labelmedium2 line">
						<TD style="height:24px;padding-left:45px">#LanguageName#</TD>
						<TD align="center" style="border-left:1px solid gray"><cfif MotherTongue eq "1"><cf_tl id="Yes"></cfif></TD>
						<td align="center" style="border-left:1px solid gray"><cfif Proficiency eq "1"><cf_tl id="Yes"></cfif></td>					
						<TD align="center" style="border-left:1px solid gray">
							<cfswitch expression="#LevelRead#">
								<cfcase value="1"><cf_tl id="High"></cfcase>
								<cfcase value="2"><cf_tl id="Medium"></cfcase>
								<cfcase value="3"><cf_tl id="Low"></cfcase>
								<cfcase value="9"><cf_tl id="N/A"></cfcase>
							</cfswitch>
						</TD>
						<TD align="center" style="border-left:1px solid gray">
							<cfswitch expression="#LevelWrite#">
								<cfcase value="1"><cf_tl id="High"></cfcase>
								<cfcase value="2"><cf_tl id="Medium"></cfcase>
								<cfcase value="3"><cf_tl id="Low"></cfcase>
								<cfcase value="9"><cf_tl id="N/A"></cfcase>
							</cfswitch>
						</TD>
						<TD align="center" style="border-left:1px solid gray">
							<cfswitch expression="#LevelSpeak#">
								<cfcase value="1"><cf_tl id="High"></cfcase>
								<cfcase value="2"><cf_tl id="Medium"></cfcase>
								<cfcase value="3"><cf_tl id="Low"></cfcase>
								<cfcase value="9"><cf_tl id="N/A"></cfcase>
							</cfswitch>
						</TD>
						<TD align="center" style="border-left:1px solid gray">
							<cfswitch expression="#LevelUnderstand#">
								<cfcase value="1"><cf_tl id="High"></cfcase>
								<cfcase value="2"><cf_tl id="Medium"></cfcase>
								<cfcase value="3"><cf_tl id="Low"></cfcase>
								<cfcase value="9"><cf_tl id="N/A"></cfcase>
							</cfswitch>
						</TD>
						<cfif url.entryScope eq "Backoffice">
						
							<td align="center" style="border-left:1px solid gray">
							<cfif Status is "0"><cf_tl id="Pending"></cfif>
							<cfif Status is "1"><cf_tl id="Cleared"></cfif>
							<cfif Status is "9"><cf_tl id="Cancelled"></cfif>
							</td>			
							
						</cfif>
						<td align="right" style="border-left:1px solid gray;padding-left:14px">#Source#</td>
						<td align="right" style="padding-left:10px">		
						
						<cfif url.source eq source or getAdministrator("*") eq "1">
															
							<cfif ((URL.Topic neq "All" or url.entryScope eq "Portal") and getSource.allowEdit eq "1" and getSource.operational eq "1")>
										
									<cfif url.entryScope eq "Backoffice">
										<cfset template="General.cfm">
										<a class="navigation_action" href="#template#?ApplicantNo=#url.ApplicantNo#&section=#url.section#&entryScope=#url.entryScope#&ID=#URL.ID#&ID2=#URL.ID2#&ID3=#ApplicantNo#&ID4=#LanguageId#&Topic=#URL.Topic#&source=#URL.Source#">
									<cfelse>
										<cfset template="#SESSION.root#/Roster/Candidate/Details/Language/Language.cfm">
										<a class="navigation_action" href="javascript:Prosis.busy('yes');ptoken.navigate('#template#?ApplicantNo=#url.ApplicantNo#&section=#url.section#&entryScope=#url.entryScope#&ID=#URL.ID#&ID2=#URL.ID2#&ID3=#ApplicantNo#&ID4=#LanguageId#&Topic=#URL.Topic#&source=#URL.Source#','languagebox');">
									</cfif>
									<img src="#SESSION.root#/Images/edit.gif" height="13" width="13" align="absmiddle" alt="Edit" border="0">
									<a>
												
							</cfif>
						
						</cfif>
						
						</td>
						<td align="left" style="padding-left:6px;padding-right:5px;padding-top:2px">
																
						<cfif url.source eq source or getAdministrator("*") eq "1">
											
							<cfif ((URL.Topic neq "All" or url.entryScope eq "Portal") and getSource.allowEdit eq "1" and getSource.operational eq "1")>
							
								<!--- Hanno : we need a provision for the online user to process it, even if allowedit = 0
									<cfif Source neq "#Parameter.PHPSource#" and URL.Topic neq "All">		
								--->
				
								<A href="javascript:Prosis.busy('yes');ptoken.navigate('#SESSION.root#/roster/candidate/details/Language/LanguagePurge.cfm?ApplicantNo=#url.ApplicantNo#&section=#url.section#&entryScope=#url.entryScope#&ID=#URL.ID#&ID2=#URL.ID2#&ID3=#ApplicantNo#&ID4=#LanguageId#&Topic=#URL.Topic#&source=#url.source#','languagebox')">
								<img src="#SESSION.root#/Images/delete5.gif" height="15" width="13" alt="Remove record" border="0">					
								<a>
								
							</cfif>
						
						</cfif>
						
						</td>
					</tr>
					
					</cfif>
					
					</tr>
					
					</cfoutput>
					
					</cfoutput>
					
					<cfif ((URL.Topic neq "All" or url.entryScope eq "Portal") and getSource.allowEdit eq "1" and getSource.operational eq "1")>
					
						<cfif URL.ID4 eq "">
						
							<input type="hidden" name="Select" id="Select" value="">
							
							<cfquery name="Language" 
							datasource="AppsSelection" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT *
							    FROM   Ref_Language
								WHERE  LanguageId NOT IN (SELECT L.LanguageId
										                  FROM   ApplicantSubmission S, ApplicantLanguage L
											              WHERE  S.PersonNo  = '#URL.ID#'
											              AND    S.ApplicantNo = L.ApplicantNo
											              AND    S.Source 	  = '#url.source#')
								ORDER BY ListingOrder, LanguageName			
							</cfquery>
						
						<cfif Language.recordcount neq "0" and URL.Topic neq "All">
						
							<tr><td height="15"></td></tr>
							<tr><td class="line" colspan="10"></td></tr>
										
							<TR style="height:35px">
							<TD style="padding-left:45px">
							
							    	<select name="Language" id="Language" class="regularxxl" required="Yes">
								    	<cfoutput query="Language">
											<option value="#LanguageId#">#LanguageName#</option>
										</cfoutput>
								    </select>	
									
							</TD>
							
							<cf_tl id="Medium" var="1">
							<cfset medium = lt_text>
							<cf_tl id="High" var="1">
							<cfset high = lt_text>
							<cf_tl id="Low" var="1">
							<cfset low = lt_text>
							<cf_tl id="n/a" var="1">
							<cfset na = lt_text>
							
							<cfoutput>
							<TD align="center">		
									<INPUT type="checkbox" class="radiol" name="Mothertongue" id="Mothertongue" value="1">				
							</TD>
							<td align="center">		
									<INPUT type="checkbox" class="radiol" name="Proficiency" id="Proficiency" value="1">		
							</td>
							
							<TD align="center">
								<select name="LevelRead" id="LevelRead" class="regularxxl">
									<option value="1" selected>#high#</option>
									<option value="2">#medium#</option>
									<option value="3">#low#</option>
									<option value="9">#na#</option>
								    </select>	
							</TD>
							<TD align="center">
								<select name="LevelWrite" id="LevelRead" class="regularxxl">
									<option value="1" selected>#high#</option>
									<option value="2">#medium#</option>
									<option value="3">#low#</option>
									<option value="9">#na#</option>
								    </select>	
							</TD>
							<TD align="center">
								<select name="LevelSpeak" id="LevelRead" required="Yes" class="regularxxl">
									<option value="1" selected>#high#</option>
									<option value="2">#medium#</option>
									<option value="3">#low#</option>
									<option value="9">#na#</option>
								    </select>	
							</TD>
							<TD align="center">
								<select name="LevelUnderstand" id="LevelUnderstand" required="Yes" class="regularxxl">
									<option value="1" selected>#high#</option>
									<option value="2">#medium#</option>
									<option value="3">#low#</option>
									<option value="9">#na#</option>
								    </select>	
							</TD>
							</cfoutput>
							
							<cfif url.entryScope eq "Backoffice">						
							<td align="center"></td>
							</cfif>
							
							<td colspan="3" align="right" style="padding-right:10px">
							
							<cfoutput>
							
							<cfif URL.Topic neq "All">  											
							    <input type="button" value=" Save " class="button10g" style="width:90"
								   onclick="Prosis.busy('yes');ptoken.navigate('#SESSION.root#/roster/candidate/details/Language/LanguageSubmit.cfm?entryScope=#url.entryScope#&applicantno=#url.applicantno#&section=#url.section#&source=#url.source#&ID2=#URL.ID2#&ID3=#URL.ID3#&ID4=#URL.ID4#&Topic=#URL.Topic#','languagebox','','','POST','languageform')">				
							<cfelse>											
								<input type="submit" value=" Save " class="button10g">
							</cfif>	
							
							</cfoutput>	
							
							</td>
							</TR>
							
							<tr><td class="line" colspan="10"></td></tr>
												
						</cfif>
				
						</cfif>
					
					</cfif>
					
			<cfelse>
			
				<cf_tl id="Medium" var="1">
				<cfset medium = lt_text>
				<cf_tl id="High" var="1">
				<cfset high = lt_text>
				<cf_tl id="Low" var="1">
				<cfset low = lt_text>
				<cf_tl id="Yes" var="1">
				<cfset yes = lt_text>
			
				<CFOUTPUT query="Detail">				
								
				<cfif MotherTongue eq "1">
					<cfset cl = "ffffaf">					
				<cfelse>
				    <cfset cl = "transparant">
				</cfif>
				
				<tr bgcolor="#cl#" class="labelmedium2">
					<TD style="height:35px;padding-left:4px"><b>#LanguageName#</TD>					
					<TD align="center"><cfif MotherTongue eq "1">#yes#</cfif></TD>
					<td align="center"><cfif Proficiency eq "1">#yes#</cfif></td>
					<TD align="center">
					<cfswitch expression="#LevelRead#">
						<cfcase value="1">#high#</cfcase>
						<cfcase value="2">#medium#</cfcase>
						<cfcase value="3">#low#</cfcase>
						<cfcase value="9">N/A</cfcase>
					</cfswitch>
					</TD>
					<TD align="center">
					<cfswitch expression="#LevelWrite#">
						<cfcase value="1">#high#</cfcase>
						<cfcase value="2">#medium#</cfcase>
						<cfcase value="3">#low#</cfcase>
						<cfcase value="9">N/A</cfcase>
					</cfswitch>
					</TD>
					<TD align="center">
					<cfswitch expression="#LevelSpeak#">
						<cfcase value="1">#high#</cfcase>
						<cfcase value="2">#medium#</cfcase>
						<cfcase value="3">#low#</cfcase>
						<cfcase value="9">N/A</cfcase>
					</cfswitch></TD>
					<TD align="center">
					<cfswitch expression="#LevelUnderstand#">
						<cfcase value="1">#high#</cfcase>
						<cfcase value="2">#medium#</cfcase>
						<cfcase value="3">#low#</cfcase>
						<cfcase value="9">N/A</cfcase>
					</cfswitch>
					</TD>
					<cfif url.entryScope eq "Backoffice">
					
						<td align="center">
						<cfif Status is "0"><cf_tl id="Pending"></cfif>
						<cfif Status is "1"><cf_tl id="Cleared"></cfif>
						<cfif Status is "9"><cf_tl id="Cancelled"></cfif>
						</td>
						
					</cfif>
					
					<td align="center">#Source#</td>					
					<td align="center"></td>
					<td align="center" height="22"></td>
					
					</TR>
					
				</cfoutput>	
					
			</cfif>		
			
			</TABLE>
		
		</td>
		</tr>
		
		<tr><td height="4"></td></tr>
		
	</table>

<cfif URL.Topic neq "All"> 

	</form>

</cfif>

<script>
	Prosis.busy('no')
</script>
