<table width="100%" cellspacing="0" cellpadding="0">

<tr><td height="20" colspan="10" class="top4n">
		
		<b>&nbsp;&nbsp;&nbsp;DSA Review</td></tr>
		
		<tr bgcolor="f4f4f4">
		  <td align="center"></td>
		  <td align="center">Line</td>
		  <td colspan="2">DSA Location</td>
		  <td>Rate</td>
		  <td>Percentage</td>
		  <td>Start</td>
		  <td>End</td>
		  <td>Days</td>
		  <td>Amount</td>
		</tr>
		 <tr><td colspan="10" bgcolor="silver"></td></tr>
	   
	    <cfquery name="Requested" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   D.*, 
			         R.Description as ClaimCategoryDescription, 
				     R.ClaimAmount,
				     R.DefaultIndicatorCode,
				     Loc.LocationCountry as Country, 
				     Loc.Description as LocationDescription,
					 L.PersonNo,
					 P.IndexNo, 
					 P.LastName, 
					 P.FirstName
			FROM     ClaimRequestLine L,
				 	 ClaimRequestDSA D,
			         Ref_ClaimCategory R,
				     Ref_PayrollLocation Loc,
				     stPerson P
			WHERE    L.ClaimCategory  = R.Code
			AND      L.PersonNo       = P.PersonNo
			AND      R.Code           = 'DSA'
			AND      L.ClaimRequestId = '#Claim.ClaimRequestId#'
			AND      L.ClaimRequestId = D.ClaimRequestId
			AND      L.ClaimRequestLineNo = D.ClaimRequestLineNo
			AND      Loc.LocationCode = D.ServiceLocation
			ORDER BY P.PersonNo 
		</cfquery>
		
		<tr><td colspan="10" bgcolor="EEEEEE"></td></tr>
		 
		<cfoutput query="Requested" group="PersonNo">
		       	   
			  <cfoutput>
			   
			  <tr bgcolor="ffffef" height="17">
			     <td>&nbsp;<cfif claim.PersonNo neq PersonNo>#FirstName# #LastName#</cfif></td>
			     <td align="center">#ClaimRequestLineNo#</td>
		 		 <td>#ServiceLocation#</td>
				 <td>#LocationDescription#</td>
				 <td></td>
			     <td></td>
		         <td>#DateFormat(DateEffective, CLIENT.DateFormatShow)#</td>
				 <td>#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</td>
		         <td>#RequestDays#</td>
				 <td>#NumberFormat(RequestAmount,"__.__")#</td>
		   	  </tr> 
			  <tr><td colspan="10" bgcolor="EEEEEE"></td></tr>
			      
			  </cfoutput>
		   
		</cfoutput>
		
		  <cfquery name="DSA" 
		 datasource="appsTravelClaim" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
	     SELECT   P.PersonNo, 
		          LastName,
				  FirstName,
				  IndexNo,
		          Grouping, 
				  Loc.LocationCode, 
				  Loc.Description as LocationDescription,
			   	  Rate,
				  Percentage, 
				  MIN(CalendarDate) AS PeriodStart, 
				  MAX(CalendarDate) AS PeriodEnd, 
				  Count(*) as Days,
				  SUM(Amount) AS Amount
		 FROM     ClaimLineDSA DSA, 
		          stPerson P, 
				  Ref_PayrollLocation Loc
	     WHERE    ClaimId          = '#Claim.ClaimId#'
		 AND      P.PersonNo       = DSA.PersonNo
		 AND      Loc.LocationCode = DSA.LocationCode
	     GROUP BY P.PersonNo, 
		          LastName,
				  FirstName,
				  IndexNo,
				  Grouping, 
				  Loc.LocationCode, 
				  Rate, 
				  Percentage,
				  Loc.Description
	     HAVING   SUM(Amount) > 0
		</cfquery>
			   
		<cfoutput query="DSA" group="PersonNo">
				  	   
			  <cfoutput>
			  		  		   
			  <tr bgcolor="ffffcf">
			     <td><font color="800000">&nbsp;<cfif claim.PersonNo neq PersonNo>#FirstName# #LastName#</cfif></td>
			     <td></td>
		 		 <td>#LocationCode#</td>
				 <td>#LocationDescription#</td>
				 <td>#NumberFormat(Rate,"__.__")#</td>
			     <td>#Percentage#%</td>
		         <td>#DateFormat(PeriodStart, CLIENT.DateFormatShow)#</td>
				 <td>#DateFormat(PeriodEnd, CLIENT.DateFormatShow)#</td>
		         <td>#Days#</td>
				 <td>#NumberFormat(Amount,"__.__")#</td>
		   	  </tr> 
			  <cfif #currentRow# neq #Recordcount# and recordcount neq "1">
			  <tr><td colspan="10" bgcolor="EEEEEE"></td></tr>
			  </cfif>
			      
			  </cfoutput>
						   
		</cfoutput>
			
		
		
</table>		