

<cfquery name="Staffing" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   			SELECT   P.PositionNo, 
		         P.PositionParentId, 
				 P.Mission, 
				 P.MandateNo,
				 P.OrgUnitOperational, 
				 P.PostGrade, 
				 P.PostType, 
				 P.SourcePostNumber, 
				 PA.DateEffective, 
				 PA.DateExpiration,
				 PA.Incumbency,
				 O.OrgUnitName,
				 PA.PersonNo,
				 PA.AssignmentNo,
				 M.MissionOwner
		FROM     PersonAssignment AS PA INNER JOIN
                       Position AS P ON PA.PositionNo = P.PositionNo INNER JOIN
                       Organization.dbo.Organization AS O ON P.OrgUnitOperational = O.OrgUnit	INNER JOIN
				 Organization.dbo.Ref_Mission M ON P.Mission = M.Mission	 
              
              WHERE    PA.SourceId = '#url.id#' 
		AND      PA.AssignmentStatus IN ('0', '1') 
		AND      PA.Incumbency > 0
		AND      PA.SourcePersonNo = '#url.id1#' 
		AND      PA.AssignmentType = 'Actual'
              ORDER BY PA.DateEffective
	 </cfquery>	
	 
	 <cfif staffing.recordcount gte "1">
	 
	 <tr style="border:1px solid silver;background-color:ffffaf;" class="fixrow">
	 
	 <td height="1" colspan="12" style="border:1px solid silver;background-color:ffffaf;padding:4px">
	 
	     <cfoutput query="staffing">
		 
		    <cfinvoke component="Service.Access"  
			   method="owner" 
			   owner="#MissionOwner#" 
			   returnvariable="accessOwner">	
		 
		 <table width="100%">
		 <tr class="labelmedium2 fixlengthlist fixrow">
		    <td style="background-color:ffffaf;padding:4px">
			  <cfif accessOwner eq "EDIT" or accessOwner eq "ALL">	
			  <cf_img icon="open" navigation="Yes" onClick="EditAssignment('#PersonNo#','#AssignmentNo#')">	
			  </cfif>
			</td>
		    <td style="background-color:ffffaf;padding:4px">#Mission#&nbsp;:&nbsp;#OrgUnitName#</td>
		    <td style="background-color:ffffaf;padding:4px"><a href="javascript:EditPosition('#mission#','#mandateno#','#positionno#')">#SourcePostNumber#</a></td>					
			<td style="background-color:ffffaf;padding:4px">#PostGrade#</td>
			<td style="background-color:ffffaf;padding:4px">#PostType#</td>
			<td style="background-color:ffffaf;padding:4px">#Incumbency#</td>
			<td style="background-color:ffffaf;padding:4px">#dateformat(DateEffective,client.dateformatshow)#</td>
			<td style="background-color:ffffaf;padding:4px">#dateformat(DateExpiration,client.dateformatshow)#</td>
		 </tr>
		 </table>	
		 
		 </cfoutput>
	 		
	</td>
	</tr>	 
	 
</cfif>