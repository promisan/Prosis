
<cfparam name="url.action" default="">

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
	SELECT DISTINCT F.*, E.*
	   FROM DocumentCandidateReviewpanel F, Employee.dbo.Person E
	   WHERE F.DocumentNo     =  '#url.DocumentNo#'
	   AND   F.PersonNo       =  '#url.PersonNo#'
	   AND   F.ActionCode     =  '#URL.ActionCode#'
	   AND   F.PanelPersonNo  =  E.PersonNo
	</cfquery>

    <table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">			
    <tr>
	   <td></td>
       <td height="15">IndexNo </td>
	   <TD height="15">Name</TD>
	   <TD height="15">Gender</TD>
	   <TD height="15">Nationality</TD>
	   <td width="20%" height="15">Role</td>  
	   <td></td>   
   </TR>
   <tr><td colspan="7" class="line" height="1"></td></tr>
   <cfoutput query="Employee">
  
   <tr>
   	  <td height="20">#currentrow#</td>
      <td><a href="javascript:EditPerson('#PersonNo#')">#IndexNo#</a></td>
	  <td><a href="javascript:EditPerson('#PersonNo#')">#FirstName# #LastName#</a></td>
	  <td>#Gender#</td>
	  <td>#Nationality#</td>
	  <td>#PanelMemo#</td>
	  <td><A href="#ajaxLink('#SESSION.root#/vactrack/application/candidate/CandidateReviewPanel.cfm?action=delete&DocumentNo=#DocumentNo#&PersonNo=#PersonNo#&ActionCode=#ActionCode#&PanelPersonNo=#PanelPersonNo#')#">
		   <img src="#SESSION.root#/Images/delete3.gif" alt="delete" border="0" align="absmiddle">
		  </a>
	  </td>
   </tr> 	  
   <tr><td colspan="7" bgcolor="DADADA"></td></tr> 
   
   </CFOUTPUT>   
   
  
