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

<cfparam name="url.action" default="">

<cfif url.action eq "Inherit">

	<cfquery name="ClonePriorPanel" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  INSERT INTO DocumentCandidateReviewpanel (DocumentNo,PersonNo,ActionCode,PanelPersonNo)
	  SELECT DocumentNo, '#url.PersonNo#' AS PersonNo, ActionCode, PanelPersonNo
	  FROM DocumentCandidateReviewpanel
	  WHERE DocumentNo     =  '#url.DocumentNo#'
	  AND   ActionCode     =  '#URL.ActionCode#'
	  AND   PersonNo = (
	  	 SELECT TOP 1 PersonNo
		 FROM   DocumentCandidateReviewPanel
		 WHERE  DocumentNo     =  '#url.DocumentNo#'
		 AND    ActionCode     =  '#URL.ActionCode#'
		 ORDER  BY Created DESC
	  )
	</cfquery>

</cfif>

<cfif url.action eq "Insert">

	<cfquery name="Member" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT * FROM DocumentCandidateReviewpanel
	  WHERE DocumentNo     =  '#url.DocumentNo#'
	  AND   PersonNo       =  '#url.PersonNo#'
	  AND   ActionCode     =  '#URL.ActionCode#'
	  AND   PanelPersonNo  =  '#URL.PanelPersonNo#'
	</cfquery>
	
	<cfif Member.recordcount eq "0">

		<cfquery name="Employee" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO DocumentCandidateReviewpanel
		    (DocumentNo,PersonNo,ActionCode,PanelPersonNo)
		VALUES(	
			'#url.DocumentNo#',
			'#url.PersonNo#',
			'#URL.ActionCode#',
			'#URL.PanelPersonNo#'
		) 
			
		</cfquery>
	
	</cfif>
	
<cfelseif url.action eq "delete">	

	<cfquery name="Employee" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM DocumentCandidateReviewpanel
	  WHERE DocumentNo     =  '#url.DocumentNo#'
	  AND   PersonNo       =  '#url.PersonNo#'
	  AND   ActionCode     =  '#URL.ActionCode#'
	  AND   PanelPersonNo  =  '#URL.PanelPersonNo#'
	</cfquery>
	
</cfif>

<cfquery name="Employee" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT F.*, E.*,E.PersonNo as PanelPersonNo
	   FROM DocumentCandidateReviewpanel F, Employee.dbo.Person E
	   WHERE F.DocumentNo     =  '#url.DocumentNo#'
	   AND   F.PersonNo       =  '#url.PersonNo#'
	   AND   F.ActionCode     =  '#URL.ActionCode#'
	   AND   F.PanelPersonNo  =  E.PersonNo
	</cfquery>

    <table width="99%" align="center" border="0" class="formpadding">			
    <tr class="labelmedium line">
	   <td></td>
       <td height="15">IndexNo </td>
	   <TD height="15">Name</TD>
	   <TD height="15">Gender</TD>
	   <TD height="15">Nationality</TD>
	   <td width="20%" height="15">Role</td>  
	   <td></td>   
   </TR>
  
  <cfif Employee.Recordcount eq 0>
  
	    <cfquery name="PriorPanel" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT *
		  FROM DocumentCandidateReviewpanel
		  WHERE DocumentNo     =  '#url.DocumentNo#'
		  AND   ActionCode     =  '#URL.ActionCode#'
		</cfquery>
	  
	   <cfif PriorPanel.RecordCount gt 0>
	  
	  	<tr class="labelmedium">
			<td colspan="7" align="center" >
				<cfoutput>
				 <a style="color:blue;" href="javascript:#ajaxLink('#SESSION.root#/vactrack/application/candidate/CandidateReviewPanel.cfm?action=Inherit&DocumentNo=#DocumentNo#&PersonNo=#PersonNo#&ActionCode=#ActionCode#')#">
					 [Click here to inherit panel members from prior interview]
				 </a>
				</cfoutput>
			</td>
		</tr>
		
		</cfif>
	
  </cfif>
  
   <cfoutput query="Employee">  
	   <tr class="line labelmedium">
	   	  <td height="20">#currentrow#</td>
	      <td><a href="javascript:EditPerson('#PanelPersonNo#')">#IndexNo#</a></td>
		  <td><a href="javascript:EditPerson('#PanelPersonNo#')">#FirstName# #LastName#</a></td>
		  <td>#Gender#</td>
		  <td>#Nationality#</td>
		  <td>#PanelMemo#</td>
		  <td><cf_img icon="delete" 
		  onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/vactrack/application/candidate/CandidateReviewPanel.cfm?action=delete&DocumentNo=#DocumentNo#&PersonNo=#PersonNo#&ActionCode=#ActionCode#&PanelPersonNo=#PanelPersonNo#','member')"></td>
	   </tr> 	      
   </cfoutput>   
   
  
