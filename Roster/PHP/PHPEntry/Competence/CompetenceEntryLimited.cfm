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
<script>
  
ie = document.all?1:0
ns4 = document.layers?1:0

function hl(bx,itm,fld,cnt){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 	 	 		 	
	 if (fld != false){
			 
	 sel  = document.getElementById("clCount");
	 var x = new Number();
	 x = parseInt(sel.value);
	 if (cnt == 1)
		 {
		 x = x+1
		   if (x >= 4)
			 {alert("You exceeded the maximum number of selections")
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
		 sel  = document.getElementById("clCount");	
		 var x = new Number();
		 x = parseInt(sel.value);
		 x = x-cnt
		 if (x < 0) {x=0}
		 sel.value = x;
		 }
	 }
  }
  
</script>

 <cfoutput>
     <input type="hidden" name="PersonNo" value = "#URL.ID#">
  </cfoutput>
  
<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#002350">

<tr><td height="4"></td></tr>

<cfquery name="Master" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT distinct C.CompetenceCategory
  FROM Ref_Competence C
  WHERE C.Operational = 1
</cfquery>

<cfset cnt = 0>
<cfset x = 0>


<cfloop query="Master">

        <cfset ar = #Master.CompetenceCategory#>
		
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
			AND S.PersonNo = '#Get.PersonNo#' 
		</cfquery>
				
		<cfquery name="GroupAll" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT F.*, S.ApplicantNo, S.CompetenceId as Selected
			FROM   UserQuery.dbo.tmp#SESSION.acc#Competence S RIGHT OUTER JOIN 
			       Ref_Competence F ON S.CompetenceId = F.CompetenceId
			WHERE  F.CompetenceCategory = '#Ar#'
			   AND F.Operational = 1
			   ORDER BY F.ListingOrder
		</cfquery>
		
		<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#Competence">
		
<tr><td>
					
       <table width="100%" cellspacing="0" cellpadding="0" class="regular">
	   	    		
		<cfoutput>
						
		<TR><td align="left" class="regular">
								    		   
			#Ar#</td></TR>
			
			</cfoutput>
							
    		<TR><td width="100%">
								
		    <cfoutput>
						
			<table width="100%" border="0" align="right" id="#Ar#">
			
			<tr>
    			<td width="30" valign="top" style="padding-left:4px"><img src="#SESSION.root#/Images/join.gif" alt=""></td>
				<td width="100%">
				
				<table width="100%" border="1" cellspacing="0" cellpadding="0" align="left">
			
					</cfoutput>
				
				    <cfset row = 0>
										
					<cfoutput query="GroupAll">
															
					<cfif row eq "3">
					    <TR>
						<cfset row = 0>
											
					</cfif>
					
					    <cfset row = row + 1>
						<td width="25%">
						<table width="100%" cellspacing="0" cellpadding="0">
							<cfif Selected eq "">
							          <TR class="regular">
							<cfelse>  <TR class="highlight4">
							</cfif>
							<td width="90%" class="regular">#Description#</font></td>
							<TD width="10%" class="regular">
							<cfif Selected eq "">
							<input type="checkbox" name="fieldid" value="#CompetenceId#" onClick="hl(this,this,this.checked,'1')">
							<cfelse>
							<input type="checkbox" name="fieldid" value="#CompetenceId#" checked onClick="hl(this,this,this.checked,'1')">
							<cfset x = x + 1>
						    </cfif>
							</td>
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
		
</cfloop>		
				
</table>
 