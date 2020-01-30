
<cfset bucket = left(url.id,8)>

<cfform name="applyform_#bucket#" method="post">

	<table width="98%" border="0" align="center">
	
		<tr><td class="labelmedium" style="padding-left:9px">
		<font color="0080C0">Questions a candidate needs to answer (allows for filtering)</td></tr>
		
		<tr><td height="20">
			<cfinclude template="doQuestion.cfm">
		</td></tr>
		
		<!---	
		
		<tr class="labelmedium"><td height="24" style="padding-left:9px">
			<font color="0080C0">Describe how your experience, qualifications and competencies match the position for which you are applying</td></tr>
					
		<tr><td height="20" style="padding-left:10px;padding-right:35px">	
		
			  <cf_textarea name="ApplicationMemo_#bucket#" id="ApplicationMemo_#bucket#"                                            
				   height         = "130"
				   toolbar        = "basic"
				   resize         = "yes"
				   color          = "ffffff"/>					
		
		</td></tr>
		
		--->
		
		<cfoutput>
		 
		<input type="hidden" name="ApplicationMemo_#bucket#" value="">
					
		<tr><td height="40" align="center" style="padding-left:0px">		
				   
		   <cf_tl id="Add to Career Path" var="1">
					
			<input class="button10g" style="width:260px;height:27px;" type="button" name="Apply" value="#lt_text#" 
			    onclick="ptoken.navigate('#SESSION.root#/Roster/PHP/PHPEntry/Application/doApplySubmit.cfm?id=#URL.ID#','process','','','POST','applyform_#bucket#')">
							
			</td>

		</tr>
		
		</cfoutput>	

        <!---
						
		<tr><td height="20">
		<table width="98%" cellspacing="0" cellpadding="0" class="formpadding">
		<tr><td style="padding:10px">
			<table cellspacing="0" cellpadding="0" style="border:1px solid silver;padding:5px">
			<tr class="labelit">
			<td style="padding:10px"><font color="808080">The generic vacancy announcements are used to generate candidates for the roster. While preferences will be registered and taken into account, qualified individuals willing to serve in several/all locations will, of course, have a greater possibility of serving.</td>
			</tr>
			<tr class="labelit">
			<td style="padding:10px"><font color="808080">Your interest will be screened and evaluated against the requirements set out in the announcement. If you meet the requirements of the vacancy announcements your application will be included in a roster system that will be submitted for all vacancies in your occupational group and grade for field missions of your choice. Your application will remain valid in the roster for a period of 12 months. Should you wish to remain in the roster after the initial 12 months, please update and resubmit your Profile.</td>
			</tr>
			
			<!---
			<tr><td class="labelit">
			You can also apply for a post-specific vacancy announcement. You will be evaluated against the requirements as specified in the particular vacancy and your name may be put forward for that specific announcement only. Your application will not be placed in the roster unless you apply to a generic (multiple duty stations M/S) vacancy announcement.
			</td></tr>	
			
			<tr><td class="labelit">
			In view of the high volume of applications received, only those applicants who are included in the roster will be notified.
			</td></tr>
						
			--->
			
			</table>
		</td></tr>
				
		</table>
		
		</td>
		
		</tr>
		
		--->
				
		</table>

</cfform>

<cfset ajaxonload("initTextArea")>
