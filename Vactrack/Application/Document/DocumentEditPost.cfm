
<cfoutput>

<script>
  
function EditPost(posno) {
     w = #CLIENT.width# - 60;
     h = #CLIENT.height# - 130;
     window.open("#SESSION.root#/Staffing/Application/Position/Position/PositionView.cfm?ID=" + posno, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}	 

function maintain(org,mis,man) {
    w = #CLIENT.width# - 85;
    h = #CLIENT.height# - 110;
	window.open("#SESSION.root#/Staffing/Application/Position/MandateView/MandateViewGeneral.cfm?ID=ORG&ID1=" + org + "&ID2="+mis+"&ID3="+man, "_blank", "left=30, top=30, width=790, height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=no")
}  

</script>

</cfoutput>

<!--- retrieve positions --->

<cfquery name="Post" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT P.*
FROM      Employee.dbo.Position P, 
          DocumentPost S
WHERE     P.PositionNo = S.PositionNo
AND       S.DocumentNo = '#URL.ID#'
ORDER BY  P.SourcePostNumber 
</cfquery>

  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
    
	  <!---	
	  <tr><td height="25" class="labelit"><b>Reserved Positions</font></td></tr>
  
  	  <tr><td height="1" class="linedotted"></td></tr>
	  --->
	  
	  <tr><td>
	  
	  <table width="99%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	  
	  <TR class="labelmedium line">
	    <td width="33"></td>
	    <TD>Post number</TD>
	    <TD>Function</TD>
	    <TD>Grade</TD>		
		<TD>Unit</TD>
		<TD>Expiration</TD>		
		<TD>IndexNo</TD>
		<TD>Name</TD>
		<TD>End date</TD>
	  </TR>
	  
	  <cfif Post.recordcount eq "0">
	   <tr><td height="1" colspan="9" align="center" class="labelmedium" bgcolor="red"><font color="FFFFFF"><b>Problem: Recruitment track is not associated to a valid position (anymore)</font></td></tr>	  
	  </cfif>
	
	  <cfoutput query="Post"> 
	  	  	  
		<cfquery name="Person" 
		datasource="appsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   TOP 1 *
			FROM     PersonAssignment A, Person P
			WHERE    A.PositionNo = '#PositionNo#'
			AND      A.PersonNo = P.PersonNo
			AND      A.AssignmentStatus IN ('0','1')
			ORDER BY A.DateExpiration DESC 
		</cfquery>
		
		<cfquery name="Org" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   TOP 1 *
			FROM     Organization
			WHERE    OrgUnit = '#OrgUnitOperational#'		
		</cfquery>
	
		<cfif Person.recordcount eq 0 or Person.DateExpiration lt now()>
		     <tr class="regular line labelmedium">
		<cfelse>
		     <tr class="highLight2 line labelmedium">
		</cfif> 
		
		<td height="18"></td>  	  
	  
	    <TD><a href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#')"><cfif sourcePostNumber eq "">#PositionParentId#<cfelse>#SourcePostNumber#</cfif></a></TD>
		<TD>#FunctionDescription#</TD>
		<TD>#PostGrade#</TD>
		<cfif Org.recordcount eq 1>
		<td><a href="javascript:maintain('#Org.orgunitCode#','#Org.mission#','#Org.MandateNo#')">#Org.OrgUnitName#</td>
		<cfelse>
		<td>Unit not defined</td>		
		</cfif>		
	    <TD>#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</TD>
		<TD><a href="javascript:EditPerson('#Person.PersonNo#')">#Person.IndexNo#</a></TD>
		<TD>#Person.FirstName# #Person.LastName#</TD>
		<TD>#Dateformat(Person.DateExpiration, CLIENT.DateFormatShow)#</TD>
	</TR>

	</CFOUTPUT>
	
	</table>
	
	</td>
	</tr>

</TABLE>
