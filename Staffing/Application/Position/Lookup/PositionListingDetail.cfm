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
  
   <cfif URL.Source eq "VAC">

   <cfquery name="PostLevel" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT     P.*, O.OrgUnitName, O.TreeOrder
     FROM       Employee.dbo.Position P, 
	            Organization O, 
			    Vacancy.dbo.Document D
	 WHERE      P.OrgUnit#class# = O.OrgUnit 
   	  AND       P.OrgUnit#class# = '#SelectOrgUnit#'
	  AND       D.PostGrade          = P.PostGrade
	  AND       D.DocumentNo         = '#URL.DocumentNo#'
	 ORDER BY   FunctionDescription
    </cfquery>
	
	<cfelseif URL.Source eq "TFR">
	
	<cfquery name="PostLevel" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT   P.*, O.OrgUnitName, O.TreeOrder
     FROM     Employee.dbo.Position P, 
	          Organization O
	 WHERE    P.OrgUnit#class# = O.OrgUnit  
   	  AND     P.PositionNo        != '#DocumentNo#'
	  AND     P.OrgUnit#class# = '#SelectOrgUnit#'
	 ORDER BY FunctionDescription
    </cfquery>
		
	<cfelseif URL.Source eq "ASS">
	
		<cfquery name="PostLevel" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT P.*, O.OrgUnitName, O.TreeOrder
	     FROM   Employee.dbo.Position P, Organization O
		 WHERE  P.OrgUnit#class# = O.OrgUnit 
	   	  AND   P.Mission             = '#URL.Mission#'
		  AND   P.MandateNo           = '#URL.MandateNo#'
		  AND   P.OrgUnit#class#      = '#SelectOrgUnit#'
		 ORDER BY FunctionDescription
	    </cfquery>
	
	<cfelseif URL.Source eq "Lookup">
		
		<cfquery name="PostLevel" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT P.*, 
		        O.OrgUnitName, 
				O.TreeOrder
	     FROM   Employee.dbo.Position P, 
		        Organization O
		 WHERE    P.OrgUnit#class# = O.OrgUnit 
	   	   AND    P.OrgUnit#class# = '#SelectOrgUnit#'
		 ORDER BY FunctionDescription 
	    </cfquery>
	
	<cfelse>
	
	<!--- IMIS provision --->
	
	<cfquery name="PostLevel" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT DISTINCT  P.*, O.OrgUnitName, O.TreeOrder
     FROM Position P, 
	      Organization.dbo.Organization O, 
		  stPostNumber D
	 WHERE P.OrgUnit#class#     = O.OrgUnit 
   	  AND P.Mission             = '#URL.Mission#'
	  AND P.MandateNo           = '#URL.MandateNo#'
	  AND P.OrgUnit#class#      = '#SelectOrgUnit#'
	  AND D.PostGrade           = P.PostGrade
	  AND D.Source              = '#URL.DocumentNo#'
	  <!--- disabled
	  AND D.SourcePostNumber    = '#URL.RecordId#'   
	  --->
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
		
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding navigation_table">
      
	    <tr class="labelit navigation_row">
		 
		 <td width="30" align="right">
			
		 <cfswitch expression="#URL.Source#">
		 
		 <cfcase value="VAC">
		 
		  <cf_img icon="edit" 
		     onlick="assignment('#URL.Source#','#PositionNo#','#URL.ApplicantNo#','#URL.PersonNo#','#URL.RecordId#','#URL.DocumentNo#')">  	 		 
	      	 	 
		 </cfcase>
		 
		 <cfcase value="TFR">
		 
		   <img onMouseOver="document.img1_#positionno#.src='#SESSION.root#/Images/button.jpg'" 
			 onMouseOut="document.img1_#positionno#.src='#SESSION.root#/Images/contract.gif'"
			 onclick="transfer('#URL.Source#','#PositionNo#','#URL.PersonNo#','#URL.RecordId#','#URL.DocumentNo#')"
			 src="#SESSION.root#/Images/contract.gif" alt="Select Position" name="img1_#positionno#" width="13" height="14" border="0" align="absmiddle">
			 	 
		 </cfcase>
		 
		 <cfcase value="ASS">
		 
		  <a href="assignment('#URL.Source#','#PositionNo#','#URL.ApplicantNo#','#URL.PersonNo#','#URL.RecordId#','#URL.DocumentNo#')" 
		    onMouseOver="document.img0_#positionno#.src='#SESSION.root#/Images/button.jpg'" 
			onMouseOut="document.img0_#positionno#.src='#SESSION.root#/Images/view.jpg'">
	         <img src="#SESSION.root#/Images/view.jpg" alt="" name="img0_#positionno#" id="img0_#positionno#" width="13" height="14" border="0" align="middle">
	     </a>
		 
		 </cfcase>
		   	  
		 <cfcase value="Lookup">
		 
		  <a href="javascript:lookupreturn('#URL.Mission#','#SourcePostNumber#','#FunctionNo#','#FunctionDescription#','#OrgUnitName#','#PostGrade#','#PositionNo#')" onMouseOver="document.img0_#positionno#.src='#SESSION.root#/Images/button.jpg'" onMouseOut="document.img0_#positionno#.src='#SESSION.root#/Images/view.jpg'">
	         <img src="#SESSION.root#/Images/view.jpg" alt="" name="img0_#positionno#" id="img0_#positionno#" width="13" height="14" border="0" align="middle">
	     </a>
		 
		 </cfcase>
		 
		 <cfdefaultcase>
		
		 <a href="javascript:associate('#URL.Source#','#PositionNo#','#URL.RecordId#','#URL.DocumentNo#')" onMouseOver="document.img0_#positionno#.src='#SESSION.root#/Images/button.jpg'" onMouseOut="document.img0_#positionno#.src='#SESSION.root#/Images/view.jpg'">
	         <img src="#SESSION.root#/Images/view.jpg" alt="" name="img0_#positionno#" id="img0_#positionno#" width="13" height="14" border="0" align="middle">
	     </a>
		 
		 </cfdefaultcase>
		 	 	 
		 </cfswitch>
						 	 
	     </td>
	     <TD width="50%">#FunctionDescription#</TD>
	     <TD width="9%">#PostGrade#</TD>
	     <TD width="15%">#PostType#</TD>
		 <TD width="8%">
		 
		 <cf_customLink
			FunctionClass = "Staffing"
			FunctionName  = "stPosition"
			Key           = "#SourcePostNumber#">
			
		 </TD>
	     <TD width="9%"><cfif showpdte eq 1>#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</cfif></TD>
		  
	    </TR>
		 	 
		 <cfquery name="Assignment" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT   PA.DateEffective, 
		          PA.DateExpiration,
				  PA.AssignmentClass, 		
				  PA.Incumbency,	  
				  P.FullName, 
				  P.Gender, 
				  P.Nationality, 
				  P.IndexNo, 
				  P.PersonNo
		 FROM     PersonAssignment PA INNER JOIN
	              Person P ON PA.PersonNo = P.PersonNo
		 WHERE    PA.DateEffective <= GETDATE() 
		     AND  PA.DateExpiration >= GETDATE()
			 AND  PA.AssignmentStatus IN ('0','1')
		 	 AND  PA.PositionNo = '#PositionNo#'
	    </cfquery>
	
		<cfif Assignment.recordcount eq "0">
			<tr>
			   <td></td> 
			   <td colspan="6" height="20" align="center" class="labelmedium"><font color="FF0000">#tVacant#</font></td>	  
			</tr>
			<tr><td colspan="7" class="line"></td></tr>
		</cfif>
	
		<cfloop query="assignment">
		
			<tr bgcolor="ffffef" class="linedotted labelit navigation_row_child">
			   <td></td>	   
			   <td>#FullName#</td>
			   <td>#AssignmentClass#:(#Incumbency#)</td>
			   <td>#DateFormat(DateEffective,CLIENT.DateFormatShow)#</td>
			   <td>#DateFormat(DateExpiration,CLIENT.DateFormatShow)#</td>
			   <td></td>
			</tr>
				
		</cfloop>
		 	 
	</table>
    </td></tr>
	  
    </cfoutput>
	
	</cfloop>
	
	<cfset ajaxonload("doHighlight")>
	 
 