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

<HTML><HEAD>
<TITLE>Category - Entry Form</TITLE>
</HEAD><body bgcolor="#FFFFFF">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<script>
  
ie = document.all?1:0
ns4 = document.layers?1:0

function hl(bx,itm,fld,cnt,mas,masmax){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	
	 if (fld != false){
		 
	 sel     = document.getElementById("cl"+mas);
	 
	 var x = new Number();
	 x = parseInt(sel.value);
	 if (cnt == 1)
		 {
		 x = x+1
		   if (x > masmax)
			 {alert("You exceeded the maximum number ("+masmax+") of selections")
			 bx.checked = false
			 }
			 else
			 {
			 sel.value = x;
			 itm.className = "highLight4";
			 }
		 }
		else { itm.className = "highLight4"; }
		 
	 }else{
			 
     itm.className = "header";		
	 if (cnt == 1) {
		 sel  = document.getElementById("cl"+mas);	
		 var x = new Number();
		 x = parseInt(sel.value);
		 x = x-cnt
		 if (x < 0) {x=0}
		 sel.value = x;
		 }
	 }
  }
  
</script>

<cfset cnt = 0>

<cfoutput>
<form action="Competence/CompetenceEntrySubmit.cfm?id2=#URL.ID2#&Topic=<cfoutput>#URL.Topic#</cfoutput>" method="post">
  
     <input type="hidden" name="PersonNo" value = "#URL.ID#">
  </cfoutput>
  
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" frame="all">
<tr><td>
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" frame="all">

<tr><td class="top3n" height="23"><b>&nbsp;Competencies</b></td></tr> 

<tr><td height="4"></td></tr>

<tr><td>
<cfset cnt = #cnt#+20>
&nbsp;<b>Attention:</b> &nbsp;<cfoutput>#Topic.CandidateHint# </cfoutput>
</td></tr>
<tr><td height="4"></td></tr>


<cfquery name="Master" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM Ref_CompetenceCategory C
  WHERE Operational = 1 
</cfquery>

<cfloop query="Master">

		<cfset x = 0>

        <cfset ar = #Master.Code#>
		<cfset arc = #Master.MaximumSelect#>
		
		<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#Competence">
		
		<cfquery name="tmp" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT C.*
			INTO UserQuery.dbo.tmp#SESSION.acc#Competence
		    FROM ApplicantCompetence C, ApplicantSubmission S
			WHERE S.ApplicantNo = C.ApplicantNo
			AND S.Source = '#CLIENT.Submission#'
			AND S.PersonNo = '#URL.ID#'
		</cfquery>
				
		<cfquery name="GroupAll" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT F.*, S.ApplicantNo, S.CompetenceId as Selected
			FROM   UserQuery.dbo.tmp#SESSION.acc#Competence S RIGHT OUTER JOIN 
			       Ref_Competence F ON S.CompetenceId = F.CompetenceId
			WHERE   F.CompetenceCategory = '#Ar#'
			   AND F.Operational = 1
			   ORDER BY F.ListingOrder
		</cfquery>
		
		<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#Competence">
		
<tr><td>
					
       <table width="100%" border="0" cellspacing="0" cellpadding="0" class="regular">
	   	    		
		<cfoutput>
						
		<TR><td align="left" class="regular">
		  <cfset cnt = #cnt# + 20>
		     
			&nbsp;#Ar#</td></TR>
			
			</cfoutput>
							
    		<TR><td width="100%" >
								
		    <cfoutput>
						
			<table width="100%" border="0" align="right" class="regular" id="#Ar#" bordercolor="silver">
			
			<tr>
    			<td width="30" valign="top">&nbsp;<img src="#SESSION.root#/Images/join.gif" alt=""></td>
				<td width="100%">
				<table width="98%" border="1" align="left" bgcolor="E9E9D1" bordercolor="silver">
			
					</cfoutput>
				
				    <cfset row = 0>
										
					<cfoutput query="GroupAll">
															
					<cfif #row# eq "3">
					    <TR>
						<cfset cnt = #cnt#+30>
						<cfset row = 0>
																		
					</cfif>
					
					    <cfset row = row + 1>
						<td width="25%" class="regular">
						<table width="100%">
							<cfif #Selected# eq "">
							          <TR class="regular">
									  
							<cfelse>  <TR class="highlight4">
							         
							</cfif>
							
							<td width="90%" class="regular">#Description#</font></td>
							<TD width="10%" class="regular">
							<cfif #Selected# eq "">
							<input type="checkbox" name="fieldid" value="#CompetenceId#" onClick="hl(this,this,this.checked,'1','#ar#','#arc#')"></TD>
							<cfelse>
							<input type="checkbox" name="fieldid" value="#CompetenceId#" checked onClick="hl(this,this,this.checked,'1','#ar#','#arc#')"></td>
							<cfset x = x + 1>
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
		
</cfloop>		

<tr><td height="30" align="center"><INPUT class="button10g" type="submit" value="Save"></td></tr>
			
</table>

</td></tr>

</table>

<cfif #URL.Topic# eq "All">

<cfoutput>

	<script language="JavaScript">
	
	{
	frm  = parent.document.getElementById("icompetence");
	he = 80+#cnt#;
	frm.height = he;
	}
	
	</script>

</cfoutput>

</cfif>


</BODY></HTML>