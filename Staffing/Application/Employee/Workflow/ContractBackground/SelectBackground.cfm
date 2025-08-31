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
<CFOUTPUT>	

<script>

function selectall(chk)
{

var count=1
while (count < 30)
   
    {
	
    se = document.getElementById("selected_"+count)
	if (se)
	{
	ln = document.getElementById("line"+count)
    
	if (chk == true)
	    {ln.className = "highLight2";
		 se.checked = true;
		}
		
	else {
      
	   ln.className = "regular";
	   se.checked = false; }
		   
	}
    count++;
   }	
}


ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight2";
	 }else{
		
     itm.className = "regular";		
	 }
  }

</script>
</CFOUTPUT>

<cfquery name="Employee" 
  datasource="appsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
		SELECT *
	    FROM   Person
		WHERE  PersonNo = '#Object.ObjectKeyValue1#'		
</cfquery>	

<!--- check if exists --->
	
<cfquery name="Candidate" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	    FROM   Applicant
		WHERE  EmployeeNo = '#Employee.PersonNo#'		
</cfquery>	

<cfif Candidate.Recordcount neq "1" and Employee.indexNo neq "">
	
	<cfquery name="Candidate" 
		datasource="appsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
		    FROM   Applicant
			WHERE  IndexNo = '#Employee.IndexNo#'	
	</cfquery>	

</cfif>

<cfif Candidate.Recordcount neq "1">

	<table align="center">
	<tr><td>
	<font color="FF0000">Profile for this employee could not be determined. Employee does not have a recruitment account. 
	</td></tr>
	</table>
	
<cfelse>	
	
	<!--- select valid profile records --->
	
	<cfquery name="SearchResult" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT    A.Source AS Expr1, B.*, C.ExperienceId as CurrentAssigned
		 FROM      ApplicantSubmission A INNER JOIN
		           ApplicantBackground B ON A.ApplicantNo = B.ApplicantNo LEFT OUTER JOIN
		           Employee.dbo.PersonContractBackground C ON B.ExperienceId = C.ExperienceId 
		           AND  C.ContractId = '#Object.ObjectKeyValue4#'
		           AND  C.PersonNo   = '#Object.ObjectKeyValue1#'
		 WHERE     A.PersonNo = '#Candidate.PersonNo#' 
		 AND       B.Status <> '9' 
		 AND       B.ExperienceCategory NOT IN ('Miscellaneous', 'School')
		 ORDER BY  B.ExperienceCategory, B.ExperienceStart DESC 
	</cfquery>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" frame="all">
	   
	  <tr>
	    <td width="100%" colspan="2">
	    <table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#E4E4E4" class="formpadding">
		
	    <TR>
	       <td width="5%" align="center">
			   <input type="checkbox" name="selected_all" id="selected_all" value="All" onClick="javascript:selectall(this.checked);">
			   </td>
	       <TD><b>Organization</TD>
	       <TD><b>Function</TD>
		   <TD><b>From</TD>
		   <TD><b>To</TD>
	   </TR>
	   <tr><td height="1" colspan="5" bgcolor="C0C0C0"></td></tr>
	  
	   <cfset module = "">
	
	   <cfoutput query="SearchResult" group="ExperienceCategory">
	   
	   <tr><td colspan="5"><b>#ExperienceCategory#</b></td></tr>
	   <cfoutput>
	   
	   <cfif CurrentAssigned is ''>
	      <tr bgcolor="F1F1E4" id="line#currentrow#">
	   <cfelse>
	      <tr class="highLight2" id="line#currentrow#">
	   </cfif>   
	   <td width="5%" align="center">
	      <cfif #CurrentAssigned# is ''>
		    <input type="checkbox" id="selected_#currentRow#" name="selected" value="#ExperienceId#" onClick="hl(this,this.checked)">
	   	  <cfelse>
	        <input type="checkbox" id="selected_#currentRow#" name="selected" value="#ExperienceId#" checked onClick="hl(this,this.checked)">
		  </cfif>
	      </TD>
	      <TD>#OrganizationName#</TD>
		  <TD>#ExperienceDescription#</TD>
	      <TD>#DateFormat(ExperienceStart, CLIENT.DateFormatShow)#&nbsp;&nbsp;</td>
		  <TD>#DateFormat(ExperienceEnd, CLIENT.DateFormatShow)#&nbsp;</TD>
	   </TR>
	   
	   <cfif ExperienceCategory eq "Employment">
		<cfquery name="Detail" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT D.TopicValue
			FROM   ApplicantBackgroundDetail D
			WHERE  D.ApplicantNo  = '#ApplicantNo#'
			AND    D.ExperienceId = '#ExperienceId#'
			AND    D.Topic = 'BACK_01'    <!--- KRW hard coded for the moment --->
			</cfquery>					
		
			<tr><td></td><td colspan="4">#Detail.TopicValue#</td></tr>
	   
	   </cfif>
		      
	   </cfoutput>
	
	   </CFOUTPUT>
	
	</TABLE>
	
	</td>
	</tr>
	
	</table>
	
</cfif>	
	