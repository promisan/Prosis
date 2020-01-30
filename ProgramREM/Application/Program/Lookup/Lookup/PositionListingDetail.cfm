 
   <cfif #URL.Source# eq "VAC">

   <cfquery name="PostLevel" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT P.*, O.OrgUnitName, O.TreeOrder
     FROM Employee.dbo.Position P, Organization O, Vacancy.dbo.Document D
	 WHERE P.OrgUnitOperational = O.OrgUnit 
   	  AND P.Mission = '#URL.Mission#'
	  AND P.MandateNo = '#URL.Mandate#'
	  AND P.OrgUnitOperational = '#SelectOrgUnit#'
	  AND D.PostGrade = P.PostGrade
	  AND D.DocumentNo = '#URL.DocumentNo#'
	 ORDER BY FunctionDescription
    </cfquery>
	
	<cfelseif #URL.Source# eq "TFR">
	
	<cfquery name="PostLevel" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT P.*, O.OrgUnitName, O.TreeOrder
     FROM Employee.dbo.Position P, Organization O
	 WHERE P.OrgUnitOperational = O.OrgUnit  
   	  AND P.Mission = '#URL.Mission#'
	  AND P.MandateNo = '#URL.Mandate#'
	  AND P.PositionNo != '#DocumentNo#'
	  AND P.OrgUnitOperational = '#SelectOrgUnit#'
	 ORDER BY FunctionDescription
    </cfquery>
		
	<cfelseif #URL.Source# eq "ASS">
	
	<cfquery name="PostLevel" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT P.*, O.OrgUnitName, O.TreeOrder
     FROM Employee.dbo.Position P, Organization O
	 WHERE P.OrgUnitOperational = O.OrgUnit 
   	  AND P.Mission = '#URL.Mission#'
	  AND P.MandateNo = '#URL.Mandate#'
	  AND P.OrgUnitOperational = '#SelectOrgUnit#'
	 ORDER BY FunctionDescription
    </cfquery>
	
	<cfelseif #URL.Source# eq "Lookup">
		
	<cfquery name="PostLevel" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT P.*, O.OrgUnitName, O.TreeOrder
     FROM Employee.dbo.Position P, Organization O
	 WHERE P.OrgUnitOperational = O.OrgUnit 
   	  AND P.Mission = '#URL.Mission#'
	  AND P.MandateNo = '#URL.Mandate#'
	  AND P.OrgUnitOperational = '#SelectOrgUnit#'
	 ORDER BY FunctionDescription
    </cfquery>
	
	<cfelse>
	
	<cfquery name="PostLevel" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT P.*, O.OrgUnitName, O.TreeOrder
     FROM Position P, Organization.dbo.Organization O, stPostNumber D
	 WHERE P.OrgUnitOperational = O.OrgUnit 
   	  AND P.Mission             = '#URL.Mission#'
	  AND P.MandateNo           = '#URL.Mandate#'
	  AND P.OrgUnitOperational  = '#SelectOrgUnit#'
	  AND D.PostGrade           = P.PostGrade
	  AND D.Source              = '#URL.DocumentNo#'
	  AND D.SourcePostNumber    = '#URL.RecordId#'
	 ORDER BY FunctionDescription
    </cfquery>
	
	</cfif>
			
	<cfloop query="PostLevel">
	
    <cfoutput>
		
   <cfif #DateFormat(Current.DateEffective, CLIENT.DateFormatShow)# eq #DateFormat(DateEffective, CLIENT.DateFormatShow)#
         AND 
		 #DateFormat(Current.DateExpiration, CLIENT.DateFormatShow)# eq #DateFormat(DateExpiration, CLIENT.DateFormatShow)#>
      <cfset showpdte = 0>
   <cfelse>
      <cfset showpdte = 1>
   </cfif>
 	
    <tr>
		
	<td colspan="5">
		
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
      
     <tr>
	 
	 <td width="6%" align="center">
		 
	 <cfswitch expression="#URL.Source#">
	 
	 <cfcase value="VAC">
	 		 
	 <a href="javascript:assignment('#URL.Source#','#PositionNo#','#URL.ApplicantNo#','#URL.PersonNo#','#URL.RecordId#','#URL.DocumentNo#')" onMouseOver="document.img0_#positionno#.src='#SESSION.root#/Images/button.jpg'" onMouseOut="document.img0_#positionno#.src='#SESSION.root#/Images/view.jpg'">
         <img src="#SESSION.root#/Images/view.jpg" alt="" name="img0_#positionno#" id="img0_#positionno#" width="13" height="13" border="0" align="middle">
     </a>
	 	 
	 </cfcase>
	 
	 <cfcase value="TFR">
	 		 
	 <a href="javascript:transfer('#URL.Source#','#PositionNo#','#URL.PersonNo#','#URL.RecordId#','#URL.DocumentNo#')" onMouseOver="document.img0_#positionno#.src='#SESSION.root#/Images/button.jpg'" onMouseOut="document.img0_#positionno#.src='#SESSION.root#/Images/view.jpg'">
         <img src="#SESSION.root#/Images/view.jpg" alt="" name="img0_#positionno#" id="img0_#positionno#" width="13" height="13" border="0" align="middle">
     </a>
	 	 
	 </cfcase>
	 
	 <cfcase value="ASS">
	 
	  <a href="javascript:assignment('#URL.Source#','#PositionNo#','#URL.ApplicantNo#','#URL.PersonNo#','#URL.RecordId#','#URL.DocumentNo#')" onMouseOver="document.img0_#positionno#.src='#SESSION.root#/Images/button.jpg'" onMouseOut="document.img0_#positionno#.src='#SESSION.root#/Images/view.jpg'">
         <img src="#SESSION.root#/Images/view.jpg" alt="" name="img0_#positionno#" id="img0_#positionno#" width="13" height="13" border="0" align="middle">
     </a>
	 
	 </cfcase>
	   	  
	 <cfcase value="Lookup">
	 
	  <a href="javascript:lookupreturn('#URL.Mission#','#SourcePostNumber#','#FunctionNo#','#FunctionDescription#','#OrgUnitName#','#PostGrade#','#PositionNo#')" onMouseOver="document.img0_#positionno#.src='#SESSION.root#/Images/button.jpg'" onMouseOut="document.img0_#positionno#.src='#SESSION.root#/Images/view.jpg'">
         <img src="#SESSION.root#/Images/view.jpg" alt="" name="img0_#positionno#" id="img0_#positionno#" width="13" height="13" border="0" align="middle">
     </a>
	 
	 </cfcase>
	 
	 <cfdefaultcase>
	
	 <a href="javascript:associate('#URL.Source#','#PositionNo#','#URL.RecordId#','#URL.DocumentNo#')" onMouseOver="document.img0_#positionno#.src='#SESSION.root#/Images/button.jpg'" onMouseOut="document.img0_#positionno#.src='#SESSION.root#/Images/view.jpg'">
         <img src="#SESSION.root#/Images/view.jpg" alt="" name="img0_#positionno#" id="img0_#positionno#" width="13" height="13" border="0" align="middle">
     </a>
	 
	 </cfdefaultcase>
	 	 	 
	 </cfswitch>
				 	 
     </td>
     <TD width="50%" class="regular">&nbsp;#FunctionDescription#</TD>
     <TD width="9%" class="regular">#PostGrade#&nbsp;</TD>
     <TD width="15%" class="regular">#PostType#&nbsp;</TD>
	 <TD width="8%" class="regular">#SourcePostNumber#&nbsp;</TD>
     <TD width="9%" class="regular"><cfif showpdte eq 1>#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</cfif></TD>
     <!--- <TD width="10%" class="regular">#Source#&nbsp;</TD> --->
	 
     </TR>
	 <tr><td height="1" colspan="7" bgcolor="D2D2D2"></td></tr>
	 	 
	</table>
     </td></tr>
	  
    </cfoutput>
	
	</cfloop>
	 
 