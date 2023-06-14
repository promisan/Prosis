
<cfparam name="URL.Class"     default="Operational">
<cfparam name="URL.ID"        default="">
<cfparam name="URL.ID1"       default="">
<cfparam name="URL.ID2"       default="">
<cfparam name="URL.ID3"       default="">
<cfparam name="URL.source"    default="">
<cfparam name="URL.Mission"   default="#URL.ID2#">
<cfparam name="URL.MandateNo" default="#URL.ID3#">

<cfif url.mission eq "">
    <cfset url.mission   = url.id2>
</cfif>

<cfif url.mandateno eq "">
	<cfset url.mandateno = url.id3>
</cfif>

<cf_tl id="Vacant" var="1">
<cfset tVacant=#lt_text#>

<cfif URL.MandateNo eq "0000">

	<cfquery name="Verify" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT TOP 1 MandateNo
	      FROM Ref_Mandate
	   	  WHERE Mission = '#Mission#'
		  ORDER BY MandateDefault DESC</cfquery>
	  
	  <cfset URL.MandateNo = Verify.MandateNo>
  
</cfif>  

<cfparam name="url.org" default="0">

<cfif URL.Source eq "VAC">	
		
	   <cfquery name="Position" 
	   datasource="AppsVacancy" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
   
		 SELECT  *
		 FROM    Employee.dbo.Position Post 	        			 
				 INNER JOIN Organization.dbo.Organization Org ON Post.OrgUnitOperational = Org.OrgUnit
	     <cfif url.org neq "0">
		 WHERE   OrgUnitOperational = '#url.org#' 
		 <cfelseif url.id1 neq "">
		 WHERE   ( Post.PositionNo LIKE '%#URL.ID1#%' 
		            OR Post.SourcePostNumber LIKE '%#URL.ID1#%' 
					OR Post.PositionParentId LIKE '%#URL.ID1#%') 		
		 <cfelse>			  
		 WHERE   ( Post.PositionNo IN (SELECT PositionNo
		                               FROM   DocumentPost 
									   WHERE  DocumentNo = '#URL.DocumentNo#')
				 OR Post.SourcePositionNo IN (SELECT PositionNo 
				                              FROM   DocumentPost 
											  WHERE  DocumentNo = '#URL.DocumentNo#')
				 )				
		 </cfif>
		 AND     Org.Mission     = '#URL.Mission#'
		 AND     Org.MandateNo   = '#URL.MandateNo#'
		 AND     Post.PostType IN (SELECT PostType
			                       FROM  Employee.dbo.Position
								   WHERE PositionNo IN (SELECT PositionNo 
								                        FROM   DocumentPost 
														WHERE  DocumentNo = '#URL.DocumentNo#')
								  ) 			
			
		</cfquery>	
				
				
		<table width="97%" class="navigation_table">
			
		<cfif Position.recordcount gte "1">
		
		<cfif url.id1 eq "">
		
		<TR class="line">
		    <td colspan="9" style="height:40px;padding-left:10px;font-size:17px" class="labelmedium">
			<font color="6688aa">The following position(s) were associated to this Recruitment track : <b><cfoutput>#URL.DocumentNo#</cfoutput></b></td>
		</TR>
		
		</cfif>
	
		<cfoutput query="Position">
		
			<tr class="line labelmedium2 navigation_row fixlengthlist" style="height:18px">
			
				<td align="center">				
				  <cf_img icon="select" navigation="Yes" onclick="assignment('#URL.Source#','#PositionNo#','#URL.ApplicantNo#','#URL.PersonNo#','#URL.RecordId#','#URL.DocumentNo#');">										 
				 </td>
				 <td>#MandateNo#</td>
				 <td>#OrgUnitNameShort#</td>
			     <TD>#FunctionDescription#</TD>
			     <TD>#PostGrade#</TD>
			     <TD>#PostType#</TD>
				 <TD><cfif SourcePostNumber eq "">#Positionno#<cfelse>#SourcePostNumber#</cfif></TD>
			     <TD>#DateFormat(DateEffective, CLIENT.DateFormatShow)#</TD>
			     <TD><cfif dateExpiration lte now()><font color="FF0000"></cfif>#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</TD>
		   
		   </tr> 
			
				<cfquery name="Assignment" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				     SELECT   PA.DateEffective, 
					          PA.DateExpiration, 
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
						 AND  PA.Incumbency > 0
			    </cfquery>
				
				<cfloop query="assignment">
				
					<tr class="background-color:##ffffaf80 line labelmedium2 navigation_row_child">
					   <td></td>
					   <td align="center"></td>			   
					   <td colspan="2">#FullName#</td>
					   <td>#Indexno#</td>
					   <td></td>
					   <td></td>
					   <td>#DateFormat(DateEffective,CLIENT.DateFormatShow)#</td>
					   <td>#DateFormat(DateExpiration,CLIENT.DateFormatShow)#</td>			   
					</tr>	
		
				</cfloop>	
								
					
		</cfoutput>	 
		
		</cfif>
	
	</table>
	
	<cfset ajaxonload("doHighlight")>

</cfif>


<cfif URL.ID eq "POS" or url.source is "TFR" or url.source is "CUS">
	
	<!--- retrieve position --->
	
	<cfquery name="Position" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   SELECT *, (
	   
		    SELECT   count(AssignmentNo)
	   	    FROM     PersonAssignment PA INNER JOIN
	                 Person P ON PA.PersonNo = P.PersonNo
	   	    WHERE    PA.DateEffective <= GETDATE() 
		      AND  PA.DateExpiration >= GETDATE()
			  AND  PA.AssignmentStatus IN ('0','1')
		 	  AND  PA.PositionNo = Pos.PositionNo) as Assignment
	   
	   	   
	   FROM   Position Pos INNER JOIN
	          Organization.dbo.Organization Org ON Pos.OrgUnitOperational = Org.OrgUnit
		<cfif url.org neq "0">
		WHERE OrgUnitOperational = '#url.org#'
		<cfelse>
		WHERE  ( Pos.PositionNo LIKE '%#URL.ID1#%' or Pos.SourcePostNumber LIKE '%#URL.ID1#%' OR Pos.PositionParentId LIKE '%#URL.ID1#%') 
		</cfif>	  	   
	    AND  Org.Mission     = '#URL.Mission#'
		AND  Org.MandateNo   = '#URL.MandateNo#'	
		
		 
	</cfquery>
		
	<table width="100%" style="padding-right:10px" class="navigation_table">
	
	<tr><td height="4"></td></tr>
		
	<cfoutput query="Position">
		
	<tr class="labelmedium navigation_row fixlengthlist" style="height:18px">
			<td align="center" style="padding-top:3px;cursor:pointer" class="navigation_action" 
			  onclick="transfer('#URL.Source#','#PositionNo#','#URL.PersonNo#','#URL.RecordId#','#URL.DocumentNo#')"><cf_img icon="select"></td>
		     <TD>#FunctionDescription#</TD>
		     <TD>#PostGrade#</TD>
		     <TD>#PostType#</TD>
			 <TD>#SourcePostNumber#</TD>
		     <TD>#DateFormat(DateEffective, CLIENT.DateFormatShow)#</TD>
		     <TD>#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</TD>
	</tr> 
		
	<tr class="line labelmedium navigation_row_child" style="height:20px">
	    <td></td>
		<td colspan="4">#OrgUnitName#</td>
		<cfif assignment eq "0">
		<td colspan="2" align="center" bgcolor="gray"><font color="white">#tVacant#</font></td>
		<cfelse>
		<td colspan="2"></td>
		</cfif>
	</tr>
		
	<cfif Assignment gte "1">
		
		<cfquery name="AssignmentList" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT   PA.DateEffective, 
		          PA.DateExpiration, 
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
			
		<cfloop query="assignmentList">
		
		<tr style="background-color:##ffffaf80" class="labelmedium2 line navigation_row_child">
		   <td height="18"></td>
		   <td style="background-color:##ffffaf80;padding-left:3px;border-left:1px dotted silver;border-top:1px dotted silver">#FullName#</td>
		   <td style="background-color:##ffffaf80;border-top:1px dotted silver">#IndexNo#</td>
		   <td style="background-color:##ffffaf80;border-top:1px dotted silver"></td>
		   <td style="background-color:##ffffaf80;border-top:1px dotted silver"></td>
		   <td style="background-color:##ffffaf80;padding-right:4px;border-top:1px dotted silver">#DateFormat(DateEffective,CLIENT.DateFormatShow)#</td>
		   <td style="background-color:##ffffaf80;padding-right:4px;border-top:1px dotted silver">#DateFormat(DateExpiration,CLIENT.DateFormatShow)#</td>
		   
		</tr>	
			
		</cfloop>	
		
	</cfif>
					
	</cfoutput>	 
	
	</table>

</cfif>

<cfif URL.ID eq "ORG" or URL.source eq "Lookup" or URL.source eq "AUT">

	<cfparam name="URL.DocumentNo" default="">
	
	<input type="hidden" name="mission" value="<cfoutput>#URL.Mission#</cfoutput>">
	
	 <cfquery name="Current" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   SELECT * 
	   FROM Ref_Mandate
	   WHERE Mission = '#URL.Mission#'
	   AND MandateNo = '#URL.MandateNo#'
	</cfquery>
	           
	<cf_dialogOrganization>
	
	<HTML><HEAD>
	    <TITLE>Search - Search Result</TITLE>	
	</HEAD>
	
	<table width="100%">
	   
	<td width="100%" colspan="2">
	
	<table width="100%" align="center" class="formpadding">
	
	<cfif URL.ID1 eq "root">
	    <cfset cond = "AND (O.ParentOrgUnit is NULL or O.ParentOrgUnit = '')">
	<cfelse>
	   	<cfset cond = "AND O.OrgUnitCode = '#URL.ID1#'">
	</cfif>
	 
	<!--- Query returning search results --->
	
	<cfif URL.Class eq "Operational">
		
		<cfquery name="SearchResult" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   distinct O.*
		    FROM     Organization O
			WHERE    O.Mission     = '#URL.Mission#'
			AND      O.MandateNo   = '#URL.MandateNo#' 
			#preserveSingleQuotes(cond)#
		    ORDER BY O.Mission, TreeOrder   
		</cfquery> 
		
			
	<cfelse>
		
		<cfquery name="SearchResult" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT distinct O.*
		    FROM   Organization O
			WHERE  O.OrgUnit = '#URL.ID1#' 
			ORDER BY O.Mission, TreeOrder
		</cfquery>
	
	</cfif>
	
	<table width="100%" class="formpadding">
		
	<cfoutput query="SearchResult" group="TreeOrder">
		
	<tr class="labelit" bgcolor="FFFF00">
	      <td height="27" colspan="4">
		   &nbsp;<b>#OrgUnitName#</b></TD>
		   <!---
	       <TD width="20%"><b>#OrgUnitClass#</b></TD>
		   <TD width="10%"><b>#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</b>&nbsp;&nbsp;</TD>	 
		   --->
	    </TR>
		<tr><td colspan="4" bgcolor="EEEEEE"></td></tr>
		<tr><td height="3"></td></tr>
		
		<cfset SelectOrgUnit = SearchResult.OrgUnit>
		
		<cfinclude template="PositionListingDetail.cfm">
					
		   <cfquery name="Level02" 
		    datasource="AppsOrganization" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT   DISTINCT O.*
		    FROM     Organization O
			WHERE    O.ParentOrgUnit = '#SearchResult.OrgUnitCode#'
			AND      O.Mission   = '#SearchResult.Mission#'
			AND      O.MandateNo = '#SearchResult.MandateNo#'
			ORDER BY O.Mission, TreeOrder
		   </cfquery>
	   
	    <cfloop query="Level02">
	   
	   	 <tr><td colspan="4" bgcolor="EEEEEE"></td></tr>
	     
		 <tr class="labelit" bgcolor="FFFFAF">
			
		  <td height="20" width="8%">&nbsp;&nbsp;&nbsp;
		      <img src="../../../../Images/org_unit.gif" alt="" name="img0_#orgunit#" id="img0_#orgunit#" width="14" height="14" border="0" align="absmiddle"> 
			  &nbsp;
	      </td>
	      <TD>#Level02.OrgUnitName#</TD>
	      <TD>#Level02.OrgUnitClass#</TD>
	      <TD>#DateFormat(Level02.DateExpiration, CLIENT.DateFormatShow)#&nbsp;</TD>
	     </TR> 
		 
		 
		<cfset SelectOrgUnit = Level02.OrgUnit>
		
		<cfinclude template="PositionListingDetail.cfm">
		
		  <cfquery name="Level03" 
	      datasource="AppsOrganization" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT DISTINCT O.*
	       FROM Organization O
		   WHERE (ParentOrgUnit = '#Level02.OrgUnitCode#')
	       AND O.Mission   = '#SearchResult.Mission#'
		   AND O.MandateNo = '#SearchResult.MandateNo#'
		   ORDER BY O.Mission, TreeOrder
	    </cfquery>
	
	    <cfloop query="Level03">
	   
	     <tr class="labelit linedotted" bgcolor="white">
			
		   <td bgcolor="FFFFDF">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	        <img src="../../../../Images/org_unit.gif" alt="" name="img0_#orgunit#" id="img0_#orgunit#" width="14" height="14" border="0" align="absmiddle">&nbsp; 
			 
	       </td>
	       <TD>#Level03.OrgUnitName#</font></TD>
	       <TD>#Level03.OrgUnitClass#</font></TD>
		   <TD>#DateFormat(Level03.DateExpiration, CLIENT.DateFormatShow)#&nbsp;</font></TD>
	     </TR> 		 
		 
		 <cfset SelectOrgUnit = Level03.OrgUnit>
		 
		 <cfinclude template="PositionListingDetail.cfm">
		 
		 	  <cfquery name="Level04" 
		      datasource="AppsOrganization" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
		      SELECT   DISTINCT O.*
		      FROM     Organization O
			  WHERE    ParentOrgUnit = '#Level03.OrgUnitCode#'
		      AND      O.Mission   = '#SearchResult.Mission#'
			  AND      O.MandateNo = '#SearchResult.MandateNo#'
			  ORDER BY O.Mission, TreeOrder
		    </cfquery>
	
	    <cfloop query="Level04">
	   
	     <tr class="labelit" bgcolor="white">
			
		   <td bgcolor="FFFFFF">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		    <img src="../../../../Images/org_unit.gif" alt="" name="img0_#orgunit#" id="img0_#orgunit#" width="14" height="14" border="0" align="absmiddle">&nbsp; 
			
	       </td>
	       <TD>#Level04.OrgUnitName#</font></TD>
	       <TD>#Level04.OrgUnitClass#</font></TD>
		   <TD>#DateFormat(Level04.DateExpiration, CLIENT.DateFormatShow)#&nbsp;</font></TD>
	     </TR> 
		  <tr><td colspan="4" bgcolor="EEEEEE"></td></tr>
		 
		</cfloop> 
		   
	    </cfloop>
		     
	    </cfloop> 
	     
	</CFOUTPUT>
	
	</TABLE>
	   
	</table>
	</table>

</cfif>  

<cfset ajaxonload("doHighlight")>

 