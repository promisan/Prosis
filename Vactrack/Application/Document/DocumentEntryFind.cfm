
<cfset Mission = "#URL.Mission#">

<cfquery name="Verify" 
datasource="AppsOrganization" 
maxrows=1 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   MandateNo
    FROM     Ref_Mandate
   	WHERE    Mission = '#Mission#'
	ORDER BY MandateDefault DESC, MandateNo DESC
</cfquery>
  
<cfset URL.MandateNo = Verify.MandateNo>

<!--- retrieve position --->

<cfquery name="Position" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT TOP 100 *
   FROM   Position Pos INNER JOIN
          Organization.dbo.Organization Org ON Pos.OrgUnitOperational = Org.OrgUnit
   WHERE  Pos.PostGrade = '#URL.PostGrade#'
   <!--- ( Pos.PositionNo LIKE '%#URL.ID1#%' or Pos.SourcePostNumber LIKE '%#URL.ID1#%') --->
     AND  Org.Mission     = '#URL.Mission#'
	 AND  Org.MandateNo   = '#URL.MandateNo#'  
</cfquery>

<table width="99%" align="left" class="navigation_table">

<cfif Position.recordcount eq "0">
	<tr><td align="center" class="labelmedium2"><font color="FF0000">No positions found for this grade</font></td></tr>
</cfif>
	
<cfoutput query="Position">
	
	<tr style="height:20px" class="navigation_row labelmedium2">
	
		<td width="6%" rowspan="2" align="center" height="35">		
		  <cf_img icon="open" navigation="Yes" onclick="selected('#positionno#')">		 		
		</td>
		<TD width="50%">#FunctionDescription#</TD>
		<TD width="6%">#PostGrade#</TD>
		<TD width="15%">#PostType#</TD>
		<TD width="10%">#SourcePostNumber#</TD>
		<TD width="9%">#DateFormat(DateEffective, CLIENT.DateFormatShow)#</TD>
		<TD width="9%" style="padding-right:5px">#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</TD>
		
	</tr> 
		
	<tr style="height:20px" class="navigation_row_child line labelmedium">	   
		<td colspan="6">#OrgUnitName#</td>
	</tr>
	
	<cfquery name="Assignment" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT  PA.DateEffective, 
	            PA.DateExpiration, 
			    P.FullName, 
			    P.Gender, 
			    P.Nationality, 
			    P.IndexNo, 
			    P.PersonNo
	    FROM    PersonAssignment PA INNER JOIN
	            Person P ON PA.PersonNo = P.PersonNo
		WHERE   PA.DateEffective <= GETDATE() 
	    AND     PA.DateExpiration >= GETDATE()
		AND     PA.AssignmentStatus IN ('0','1')
	 	AND     PA.PositionNo = '#PositionNo#'
	</cfquery>
	
	<cfif Assignment.recordcount eq "0">
		<tr class="navigation_row_child line labelmedium2">
		   <td colspan="7" align="center"><font color="FF0000"><cf_tl id="Vacant"></font></td>	  
		</tr>		
	</cfif>
	
	<cfloop query="assignment">
	
		<tr style="background-color:f1f1f1" class="line labelmedium2">
		   <td></td>
		   <td>#FullName#</td>
		   <td>#Gender#</td>
		   <td></td>
		   <td></td>
		   <td>#DateFormat(DateEffective,CLIENT.DateFormatShow)#</td>
		   <td>#DateFormat(DateExpiration,CLIENT.DateFormatShow)#</td>	   
		</tr>
		
	</cfloop>	
				
</cfoutput>	 

</table>

<cfset AjaxOnLoad("doHighlight")>
