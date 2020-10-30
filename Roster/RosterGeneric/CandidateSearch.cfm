
<cfparam name="URL.DocNo"   default="">
<cfparam name="URL.Scope"   default="Inquiry">
<cfparam name="URL.Class"   default="">
<cfparam name="URL.Mission" default="">

<!--- ------------------------------------------------------------------------------------------------------------------ --->
<!--- use URL.mode=Limited in the URL to show all candidates, this is an option to be granted for an auditor or verifier --->
<!--- ------------------------------------------------------------------------------------------------------------------ --->

<cfparam name="URL.Mode"    default="Regular">
<cfparam name="URL.Height"  default="600">
<cfparam name="URL.Owner"   default="">

<cfoutput>

<cf_dialogStaffing>   
<cfajaximport tags="cfdiv">
<cf_ajaxRequest>

<cfquery name="Owner" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  TOP 1 *
		FROM   Ref_ParameterOwner
</cfquery>

<cfif Owner.PathHistoryProfile eq "">
	<cfset path = "Roster/PHP/PDF/PHP_Combined_List.cfm">
<cfelse>
    <cfset path = "Custom/#Owner.PathHistoryProfile#">
</cfif>

<script>

function maxme(itm) {
	 
	 se   = document.getElementsByName(itm)
	 icM  = document.getElementById(itm+"Min")
	 icE  = document.getElementById(itm+"Exp")
	 count = 0
		
	 if (icM.className == "regular") {
	
	 icM.className = "hide";
	 icE.className = "regular";
	 
	 while (se[count]) {
	     se[count].className = "hide"
	     count++ }
		 	 
	 } else {
	 	
	 while (se[count]) {
	 se[count].className = "regular"
	 count++ }
	 icM.className = "regular";
	 icE.className = "hide";			
	 }	
	 
 }		
 
 function formvalidate() {
	document.candidateform.onsubmit() 
	if( _CF_error_messages.length == 0 ) {             
		ptoken.navigate('#SESSION.root#/Roster/RosterGeneric/CandidateResult.cfm?mission=#url.mission#&height=#URL.height#&DocNo=#URL.DocNo#&Scope=#URL.Scope#&Mode=#URL.Mode#&Owner=#URL.Owner#','result','','','POST','candidateform')
	 }   
}	

function list(page) {	
      _cf_loadingtexthtml='';	       
       ptoken.navigate('#SESSION.root#/roster/rostergeneric/CandidateResult.cfm?height='+document.body.offsetHeight+'&Owner=#URL.Owner#&DocNo=#URL.DocNo#&Scope=#URL.Scope#&Mode=#URL.Mode#&Page=' + page + '&ID=9','result');
	   Prosis.busy('yes')
	}

		function printingPHP(roster,format,script) {
						
			document.getElementById("php_"+script).className = "hide"
			document.getElementById("wait_"+script).className = "regular"
													

			url = "#SESSION.root#/#path#?PHP_Roster_List="+roster+"&FileNo="+script	
																			
	 		AjaxRequest.get({			
	        'url':url,    	    
			'onSuccess':function(req) { 	
			 document.getElementById("php_"+script).className = "regular"
			 document.getElementById("wait_"+script).className = "hide"
		  	 window.open("#SESSION.root#/cfrstage/user/#SESSION.acc#/php_"+script+".pdf?ts="+new Date().getTime(),"php_"+script)
			
          	  },					
    	    'onError':function(req) { 	
			 document.getElementById("wait_"+script).className = "hide"
			 alert("An error has occurred upon preparing this PHP. A notification email was sent to the administrator.")}	
    	     });	
					
		 }

	
</script>

</cfoutput>

	<cfif URL.Scope neq "Inquiry">
	
		<table width="100%" height="99%" class="formpadding">
		
		<tr><td height="5"></td></tr>
				
	<cfelse>
	
		<cf_screentop height="100%" jquery="Yes" scroll="No" html="No" menuAccess="Yes" SystemFunctionId="#url.idmenu#">
	
		<table width="98%" height="100%" align="center">
		
		<tr><td height="5"></td></tr>
		
		<t><td>
		
			<table width="100%" align="center" align="center" class="formpadding">
							
				 <tr class="line">
				  
				    <cfif url.mission neq "">
					<cfoutput>
					<td style="font-weight:200;height:50px;padding-left:10px;padding-top:8px;font-size:25px" class="labelit">#url.mission# <cf_tl id="Patients"></td>	
					</cfoutput>
					<cfelse>
				    <td style="font-weight:200;padding-left:10px;padding-top:6px;font-size:30px"><cfoutput>#session.welcome#<cf_tl id="Natural Person Repository"></cfoutput></td>					
					</cfif>
					<td align="right" width="30%" valign="bottom" style="padding-right:10px" class="labelit">
					<cfoutput><cf_tl id="Mode">:&nbsp;&nbsp;<font color="002350">#URL.Mode# <cfif url.class eq ""><cf_tl id="Global"><cfelse>/#url.class#</cfif></cfoutput>
					</td>
				 </tr> 	
				 			 
			 </table>
		 
		 </td></tr>
		 		
	</cfif>
	
	<tr><td height="5"></td></tr>

	<tr class="line">
	
	<td height="20" name="search">
								
		<CFFORM onsubmit="return false"	name="candidateform">		
					
		<table width="98%" align="center" align="center" class="formpadding">
		
		    <cfif url.class neq "">
				
			   <cfoutput>		
			   <input type="hidden" name="Class" value="#url.class#">
			   </cfoutput>
			
			<cfelse>
					 
				<tr><td height="5"></td></tr>
				
				<tr class="labelmedium">
													
				<cfquery name="Class" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   * 
					FROM     Ref_ApplicantClass
					WHERE    Operational = 1
					ORDER BY ListingOrder
				</cfquery>
			
				<td style="padding-left:10px" width="100" style="padding-top:2px"><cf_tl id="Class">:</td>
				<td colspan="3">
				
				    <table>
					<tr class="labelmedium">
					<td><input type="radio" name="Class" value="" checked></td><td><cf_tl id="Any"></td>
					<cfoutput query="Class">
					  <td style="padding-left:5px"><input type="radio" class="radiol" name="Class" value="#ApplicantClassId#"></td>
					  <td style="padding-left:3px"><cf_tl id="#Description#"></td>
					</cfoutput>		
					</tr>
					</table>
				   
				</td>
				</tr>
							
			</cfif>
						
			<tr>
				
			<cfquery name="Parameter" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
		    	FROM Parameter
			</cfquery>
		
			<!--- Field: IndexNo=CHAR;20;FALSE --->
			<INPUT type="hidden" name="Crit8_FieldName" value="A.IndexNo">
			<INPUT type="hidden" name="Crit8_FieldType" value="CHAR">
			<TD style="padding-left:10px" class="labelit"><cfoutput query="Parameter">#IndexNoName#:</cfoutput></TD>
			<TD class="labelit">
						
			<SELECT name="Crit8_Operator" class="regularxl">
				
					<OPTION value="CONTAINS">contains
					<OPTION value="BEGINS_WITH">begins with
					<OPTION value="ENDS_WITH">ends with
					<OPTION value="EQUAL">is
					<OPTION value="NOT_EQUAL">is not
					<OPTION value="SMALLER_THAN">before
					<OPTION value="GREATER_THAN">after
				
				</SELECT>
				
			<INPUT type="text" name="Crit8_Value" class="regularxl" size="20" onkeyup="if (event.keyCode == 13) { formvalidate() }"> 
						
			</TD>
			
			<cfif url.class eq "">
					
			<TD style="padding-left:10"><cf_tl id="Roster bucket">:</TD>
			<TD>
			
			<cfquery name="Edition" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_SubmissionEdition
				WHERE  Operational = 1
			</cfquery>
			
			<select name="Roster" style="width: 250;" class="regularxl" onchange="formvalidate()">
			   <option value="" selected>All</option>
			   <option value="1">Candidates cleared for at least one bucket</option>
			   
			   <cfoutput query="Edition">
			   <option value="#SubmissionEdition#">Cleared for #Owner# #EditionDescription#</option>
			   </cfoutput>	   
			   
			</select>
			 	  	
		  	</TD>		
									
			<cfelseif url.class eq "4">
						
				<!--- Field: Staff.LastName=CHAR;40;FALSE --->
				<INPUT type="hidden" name="Crit2a_FieldName" value="A.DocumentReference">
				<INPUT type="hidden" name="Crit2a_FieldType" value="CHAR">
				
				<TD style="padding-left:10px" class="labelit"><cf_tl id="Reference">:</TD>
				<TD>
				<SELECT name="Crit2a_Operator" class="regularxl">
					
						<OPTION value="CONTAINS">contains
						<OPTION value="BEGINS_WITH">begins with
						<OPTION value="ENDS_WITH">ends with
						<OPTION value="EQUAL">is
						<OPTION value="NOT_EQUAL">is not
						<OPTION value="SMALLER_THAN">before
						<OPTION value="GREATER_THAN">after
					
					</SELECT>
						
				<INPUT type="text" class="regularxl" name="Crit2a_Value" size="10" onkeyup="if (event.keyCode == 13) { formvalidate() }"></TD>
			
			
			</cfif>
			
			</TR>		
						
			<!--- Field: Staff.LastName=CHAR;40;FALSE --->
			<INPUT type="hidden" name="Crit2_FieldName" value="A.FullName">
			<INPUT type="hidden" name="Crit2_FieldType" value="CHAR">
			<TR>
			<TD style="padding-left:10px" class="labelit"><cf_tl id="Full Name">:</TD>
			<TD>
			<SELECT name="Crit2_Operator" class="regularxl">
				
					<OPTION value="CONTAINS">contains
					<OPTION value="BEGINS_WITH">begins with
					<OPTION value="ENDS_WITH">ends with
					<OPTION value="EQUAL">is
					<OPTION value="NOT_EQUAL">is not
					<OPTION value="SMALLER_THAN">before
					<OPTION value="GREATER_THAN">after
				
				</SELECT>
					
			<INPUT type="text" class="regularxl" name="Crit2_Value" size="20" onkeyup="if (event.keyCode == 13) { formvalidate() }"></TD>
			
			<cfif url.class eq "">
			
				<TD style="padding-left:10px"><cf_tl id="Candidate Assessment">:</TD>
				<TD>
				
				<select name="Assessment" style="width: 250;" class="regularxl">
				   <option value="" selected>N/A</option>
				   <option value="1">Candidates WITH a Skill Assessment</option>
				   <option value="0">Candidates WITHOUT a Skill Assessment</option>
				</select>
				   
			  	</TD>
				
			<cfelse>
			
				<TD style="padding-left:10px"><cf_tl id="Assessment">:</TD>
				<TD>
				
				<select name="Assessment" style="width: 250;" class="regularxl">
				   <option value="" selected>N/A</option>
				   <option value="1"><cf_tl id="Cleared"></option>
				   <option value="0"><cf_tl id="Pending"></option>
				</select>
				   
			  	</TD>
						
			</cfif>
			
			</tr>
							
			<tr>
		
			<!--- Field: Staff.FirstName=CHAR;40;FALSE --->
			<INPUT type="hidden" name="Crit3_FieldName" value="A.FirstName">
			<INPUT type="hidden" name="Crit3_FieldType" value="CHAR">
			<TD style="padding-left:10px"><cf_tl id="First name"></TD>
			<TD class="regular">
			<SELECT name="Crit3_Operator" class="regularxl">
				
					<OPTION value="CONTAINS">contains
					<OPTION value="BEGINS_WITH">begins with
					<OPTION value="ENDS_WITH">ends with
					<OPTION value="EQUAL">is
					<OPTION value="NOT_EQUAL">is not
					<OPTION value="SMALLER_THAN">before
					<OPTION value="GREATER_THAN">after
				
				</SELECT>
				
			<INPUT type="text" class="regularxl" name="Crit3_Value" size="20" onkeyup="if (event.keyCode == 13) { formvalidate() }"> 
			
			</TD>
			
			<cfif url.class eq "">
			
			<TD style="padding-left:10px"><cf_tl id="Bucket Processed">:</TD>
			<TD>
			<select name="Filter" style="width: 250;" class="regularxl">
			   <option value="" selected>All</option>
			   <option value="1">Only candidates processed by <cfoutput>#SESSION.first# #SESSION.last#</cfoutput></option>
			</select>
			   
		  	</TD>
			
			</cfif>
			
			</tr>	
			
		  <!--- Field: Staff.Person=CHAR;40;FALSE --->
				
		    <INPUT type="hidden" name="Crit7_FieldName" value="A.PersonNo">
			<INPUT type="hidden" name="Crit7_FieldType" value="CHAR">
			<TR>
			<td style="padding-left:10px"><cf_tl id="Person Id">:</td>
			<TD>
			<SELECT name="Crit7_Operator" class="regularxl">
				
					<OPTION value="CONTAINS">contains
					<OPTION value="BEGINS_WITH">begins with
					<OPTION value="ENDS_WITH">ends with
					<OPTION value="EQUAL">is
					<OPTION value="NOT_EQUAL">is not
					<OPTION value="SMALLER_THAN">before
					<OPTION value="GREATER_THAN">after
				
				</SELECT>
				
			<INPUT type="text" class="regularxl" name="Crit7_Value" size="20" onkeyup="if (event.keyCode == 13) { formvalidate() }"> 
			
			</TD>
					
						
			<!--- Field: Staff.Source=CHAR;40;FALSE --->
			
			<INPUT type="hidden" name="Crit6_FieldName" value="A.Source">		
			<INPUT type="hidden" name="Crit6_FieldType" value="CHAR">
					
			<TD style="padding-left:10px"><cf_tl id="Source">:</TD>
			<TD>
			<SELECT name="Crit6_Operator" class="regularxl">
				
					<OPTION value="CONTAINS">contains
					<OPTION value="BEGINS_WITH">begins with
					<OPTION value="ENDS_WITH">ends with
					<OPTION value="EQUAL">is
					<OPTION value="NOT_EQUAL">is not
					<OPTION value="SMALLER_THAN">before
					<OPTION value="GREATER_THAN">after
				
				</SELECT>
				
			<cfinput type="Text" class="regularxl" name="Crit6_Value" message="Enter an integer value" onkeyup="if (event.keyCode == 13) { formvalidate() }" required="No" size="10">
			
			</TD>
								
			</TR>		
				
			<TR>
		
			<!--- Field: Staff.FirstName=CHAR;40;FALSE --->
			<INPUT type="hidden" name="Crit5_FieldName" value="A.EMailAddress">
			<INPUT type="hidden" name="Crit5_FieldType" value="CHAR">
			<TD style="padding-left:10px"><cf_tl id="Email">:
			<cf_space spaces="20">
			
			</TD>
			
			<TD>
						
				<SELECT name="Crit5_Operator" class="regularxl">
				
					<OPTION value="CONTAINS">contains
					<OPTION value="BEGINS_WITH">begins with
					<OPTION value="ENDS_WITH">ends with
					<OPTION value="EQUAL">is
					<OPTION value="NOT_EQUAL">is not
					<OPTION value="SMALLER_THAN">before
					<OPTION value="GREATER_THAN">after
				
				</SELECT>
				
				<INPUT type="text" class="regularxl" name="Crit5_Value" size="20" onkeyup="if (event.keyCode == 13) { formvalidate() }"> 
			
			</TD>
			
			<!--- Field: Staff.FirstName=CHAR;40;FALSE --->
			<INPUT type="hidden" name="Crit5a_FieldName" value="A.MobileNumber">
			<INPUT type="hidden" name="Crit5a_FieldType" value="CHAR">
			<TD style="padding-left:10px"><cf_tl id="Mobile">:</TD>
			
			<TD>
			
				<SELECT name="Crit5a_Operator" class="regularxl">
				
					<OPTION value="CONTAINS">contains
					<OPTION value="BEGINS_WITH">begins with
					<OPTION value="ENDS_WITH">ends with
					<OPTION value="EQUAL">is
					<OPTION value="NOT_EQUAL">is not
					<OPTION value="SMALLER_THAN">before
					<OPTION value="GREATER_THAN">after
				
				</SELECT>
				
				<INPUT type="text" class="regularxl" name="Crit5a_Value" size="10" onkeyup="if (event.keyCode == 13) { formvalidate() }"> 
			
			</TD>
			
			</TR>
			
			<!--- Field: Staff.Gender=CHAR;40;FALSE --->
			<INPUT type="hidden" name="Crit4_FieldName" value="A.Gender">
			<INPUT type="hidden" name="Crit4_FieldType" value="CHAR">
			<INPUT type="hidden" name="Crit4_Operator" value="CONTAINS">
			
			<TR>
			<TD style="padding-left:10px;height:30px;"><cf_tl id="Gender">:</TD>		
			<TD class="labelit">
				
				<input type="radio" class="radiol" name="Crit4_Value" value="M"><cf_tl id="Male">
			    <input type="radio" class="radiol" name="Crit4_Value" value="F"><cf_tl id="Female">
				<input type="radio" class="radiol" name="Crit4_Value" value="" checked><cf_tl id="Any">
			
			</TD>
			
				<TD style="padding-left:10px"><cf_tl id="Candidate status">:</TD>
				<TD>
				
				<select name="CandidateStatus" style="width: 250;" class="regularxl">
				   <option value="" selected>All but cancelled</option>
				   <option value="0"><cf_tl id="Pending"></option>
				   <option value="1"><cf_tl id="Accepted"></option>
				   <option value="9"><cf_tl id="Denied"></option>				   
				</select>
				   
			  	</TD>
			
			</TR>				 	 
									
			<tr><td colspan="4" class="line"></td></tr>	
			
			<tr><td valign="center" style="padding-top:4px" colspan="4" align="center">
			
			    <cfoutput>
			
			    <cf_tl id="Reset" var="reset">
			
				<input type="reset" class="button10g" 
					mode        = "silver"
					value       = "#reset#" 						
					id          = "reset"					
					width       = "150px" 					
					color       = "636334"
					fontsize    = "11px">   
					
				<cf_tl id="Search" var="qsearch">
							
				<input type="button" class="button10g" 
					mode        = "silver"
					onclick     = "formvalidate();document.getElementById('toggle').className='regular';"
					value       = "#qSearch#" 							
					id          = "submit"										
					width       = "150px" 					
					color       = "636334"
					fontsize    = "11px">   
					
				</cfoutput>						
					
			
			</td></tr>
			
		</TABLE>
		
		</CFFORM>
		
	</td>

	</tr>

	<cfoutput>
		
		<tr><td id="toggle" class="hide" width="100%">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" style="padding-right:5px">
									
					<tr class="line"><td width="100%" colspan="2" align="center" align="right" style="padding-right:5px">		
					
						<button style="height:20;width:44" onclick="maxme('search')" name="back" class="button3" type="button" 
				        onMouseOver="this.className='button1'" onMouseOut="this.className='button3'">
							<img id="searchExp" align="absmiddle" title="Full screen" src="#SESSION.root#/Images/down2.gif" border="0" class="hide">
							<img id="searchMin" align="absmiddle" title="Split Screen" src="#SESSION.root#/Images/up2.gif" border="0" class="regular">
						</button>
										
						</td>
					</tr>	
										
			</table>		
		</td></tr>
	
	</cfoutput>	
	
	<tr><td height="100%" width="100%">
		<table width="100%" height="100%" align="center">
			<tr><td valign="top" height="100%" style="padding-left:5px" id="result">						
			</td></tr>
		</table>
	</td>
	</tr>

</table>

<cfif URL.Scope eq "Inquiry">	
	<cf_screenbottom html="No">
</cfif>	