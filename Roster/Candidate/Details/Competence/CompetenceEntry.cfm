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
<cf_screentop html="No" jquery="Yes">

<cf_tl id="You exceeded the maximum number" var="1">
<cfset msg1 = lt_text>
<cf_tl id="of selections" var="1">
<cfset msg2 = lt_text>

<cfquery name="Topic" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_ParameterSkill
  WHERE  Code = '#URL.Topic#'
</cfquery>

<cfinvoke component="Service.Access"  
		method="roster" 
		role="'AdminRoster','CandidateProfile','RosterClear'"
		returnvariable="Access">	

<cfoutput>

<script>
	  
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
	function hl(bx,itm,fld,cnt,mas,masmax){
	
		 validateform()
	
	     if (ie){
	          while (itm.tagName!="TR")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TR")
	          {itm=itm.parentNode;}
	     }
		
		 if (fld != false){
			 
		 sel     = document.getElementById(mas);
		 
		 var x = new Number();
		 x = parseInt(sel.value);
		 
		 if (cnt == 1) {
			 x = x+1
			   if (x > masmax) {
			   				 
				 <cfoutput>
					 alert('#msg1#('+masmax+') #msg2#')
				 </cfoutput>
				 
				 bx.checked = false
				 } else {
				 sel.value = x;
				 itm.className = "highLight1";
				 }
			 }
			else { itm.className = "highLight1" }
			 
		 }else{
				 
	     itm.className = "header";		
		 if (cnt == 1) {
			 sel  = document.getElementById(mas);	
			 var x = new Number();
			 x = parseInt(sel.value);
			 x = x-cnt
			 if (x < 0) {x=0}
			 sel.value = x;
			 }
			 
		 }
	  }
	  
	 function validateform() {      	 
		ptoken.submitForm('competenceform','Competence/CompetenceEntrySubmit.cfm?source=#url.source#&id2=#URL.ID2#&Topic=#URL.Topic#','','','POST')	    
	 }	 
 
 </script>
  	
</cfoutput>
  

<form name="competenceform" id="competenceform">
	
<input type="hidden" name="PersonNo" value = "<cfoutput>#URL.ID#</cfoutput>">
  
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">

<tr><td>

<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">

<tr><tdstyle="padding-top:3px" class="labellarge"><font size="4"><cf_tl id="Competencies"></b></td></tr> 

<tr><td height="5"></td></tr>

<tr><td style="padding-left:13px" class="labelmedium">
<b><cf_tl id="Attention">:</b><cfoutput>#Topic.CandidateHint# </cfoutput>
</td></tr>
<tr><td height="4"></td></tr>

<cfquery name="Master" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_CompetenceCategory C
  WHERE  Operational = 1 
</cfquery>

<cfloop query="Master">

		<cfset x = 0>
		<cfset val = "">

        <cfset ar  = Master.Code>
		<cfset arc = Master.MaximumSelect>
						
		<cfquery name="GroupAll" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  F.*, 
			        S.ApplicantNo, 
					C.CompetenceId as Selected
			FROM    ApplicantCompetence C INNER JOIN
                    ApplicantSubmission S ON C.ApplicantNo = S.ApplicantNo RIGHT OUTER JOIN
                    Ref_Competence F ON C.CompetenceId = F.CompetenceId 
					AND S.Source = '#URL.Source#' 
					AND S.PersonNo = '#URL.ID#'
			WHERE   F.CompetenceCategory = '#Ar#'
			   AND  F.Operational = 1
			   ORDER BY F.ListingOrder
		</cfquery>
		
		<tr><td>
					
       <table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="regular">
	   	    		
		<cfoutput>
						
		<TR><td align="left" class="labelmedium" style="padding-top:4px;padding-bottom:4px;padding-left:5px">#Ar#</td></TR>
			
			</cfoutput>
							
    		<TR><td width="100%" >
								
		    <cfoutput>
						
			<table width="100%" border="0" align="right" class="regular" id="#Ar#">
			
			<tr>
    			<td width="30" valign="top">&nbsp;<img src="#SESSION.root#/Images/join.gif" alt=""></td>
				<td width="100%">
				<table width="98%" border="0" align="left">
			
					</cfoutput>
				
				    <cfset row = 0>
										
					<cfoutput query="GroupAll">
					
					<cfif selected neq "">
					   <cfif val eq "">
					    <cfset val = "'#selected#'">
					   <cfelse>
					   <cfset val = "#val#,'#selected#'">
					   </cfif>
					</cfif>
															
					<cfif row eq "3">
					    <TR>						
						<cfset row = 0>
																								
					</cfif>
					
					    <cfset row = row + 1>
						<td width="25%" class="regular" >
						<table width="100%" class="formpadding">
						
							<cfif Selected eq "">
							          <TR class="regular">
									  
							<cfelse>  <TR class="highlight1">
							         
							</cfif>
							
							<td width="90%" class="labelmedium" style="padding-left:6px">#Description#</font></td>
							<TD width="10%" class="labelit">
							
							<cfif access eq "EDIT" or access eq "ALL">	
							
								<cfif Selected eq "">
								<input type="checkbox" class="radiol" name="fieldid" value="#CompetenceId#" 
								        onClick="hl(this,this,this.checked,'1','#ar#','#arc#')"></TD>
								<cfelse>
								<input type="checkbox" class="radiol" name="fieldid" value="#CompetenceId#" checked 
								      onClick="hl(this,this,this.checked,'1','#ar#','#arc#')"></td>
								<cfset x = x + 1>
							    </cfif>
							
							<cfelse>
							
							
							</cfif>
						</table>
						</td>
						<cfif GroupAll.recordCount eq "1">
    						<td width="25%" class="regular"></td>
						</cfif>
					
					</CFOUTPUT>					
												
			    </table>
				
				</td></tr>
				
				</table>
									
			</td></tr>
							
		</table>
		
	</td></tr>
		
	<input type="hidden" name="cl<cfoutput>#Master.Code#</cfoutput>" value="<cfoutput>#x#</cfoutput>">
	
	<tr><td height="5"></td></tr>
			
	<cfquery name="get" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT TOP 1 *
	  FROM   ApplicantCompetence 
	  <cfif val neq "">
	  WHERE  CompetenceId IN (#preservesinglequotes(val)#) 
	  <cfelse>
	  WHERE 1=0
	  </cfif>
	</cfquery>	
				
	<cfoutput query="get">
	<tr><td class="linedotted"></td></tr>
	<tr><td height="30" class="labelit" style="padding-left:30"><cf_tl id="Last updated">: #get.OfficerFirstName# #get.OfficerLastName# on #dateformat(get.created,CLIENT.DateFormatShow)# #timeformat(get.created,"HH:MM")#</td></tr>
	<tr><td class="linedotted"></td></tr>
	</cfoutput>
		
</cfloop>	
			
</table>

</td></tr>

</table>


</BODY></HTML>