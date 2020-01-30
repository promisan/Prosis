<cfsilent>
  <proUsr>Joseph George</proUsr>
  <proOwn>Joseph George</proOwn>
 <proDes>Template that is called by TravelRequest + sign   </proDes>
 <proCom>Added Remarks in the select of Itinerary and also checked for Null  </proCom>
</cfsilent>
<cfoutput>	

      <cfset travel = "0">
	
			<cfquery name="Itinerary" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT DISTINCT I.Itinerary, I.DateDeparture, I.Memo, I.DateReturn, R.*,
				       RL.Currency, RL.RequestAmount, RL.PersonNo, E.LastName, E.FirstName,
					   isnull(RL.Remarks,'') as Remarks
				FROM   ClaimRequestItinerary I, 
				       ClaimRequestLine RL,
				       Ref_ClaimCategory R,
					   stPerson E
				WHERE  I.ClaimRequestId = '#ClaimTitle.ClaimRequestId#'
				AND    RL.ClaimRequestId = I.ClaimRequestId 
				AND    I.Itinerary >= ''
				AND    E.PersonNo = RL.PersonNo
				AND    RL.ClaimRequestLineNo = I.ClaimRequestLineNo
				AND    R.Code = RL.ClaimCategory
			</cfquery>
			
			<tr id="travel" class="hide">
					
					<td bgcolor="white"></td>					
					<td colspan="4">
				
					<table width="100%"
				       border="0"
				       cellspacing="0"
				       cellpadding="0"
				       align="left"
				       bordercolor="C0C0C0"
				       bgcolor="FFFFFF"
				       rules="rows">
					<tr>
										
					<td colspan="2">
								
						<table border="0"
			       cellspacing="0"
			       cellpadding="0"
			       align="left"
				   width="96%"
			       bordercolor="C0C0C0"
			       rules="rows"
				   frame="hsides">
																	
						<cfloop query="Itinerary">
						
							<cfif PersonNo neq "#ClaimTitle.PersonNo#">
								<tr>
								<td>
									<img src="#SESSION.root#/images/joinbottom.gif" 
									alt="" border="0" align="absmiddle">
								</td>
								<td>Traveller:</td><td>#FirstName# #LastName#</td>
								</tr>
							</cfif>
							
							<cfif Itinerary neq "">
								<tr>
								<td>
									<img src="#SESSION.root#/images/joinbottom.gif" 
									alt="" border="0" align="absmiddle">
								</td>
							    <td width="100">#Description#:</td>
								<td>#Itinerary# (#Memo#)</td>								
								</tr>
							</cfif>														
														
							<cfif Remarks neq "">
							
							<tr>
							<td>
								<img src="#SESSION.root#/images/joinbottom.gif" 
								alt="" border="0" align="absmiddle">
							</td>
							<td width="110">Requested Itinerary:</td>
							<td>#Remarks#</td>
							</tr>						
							
							</cfif>
							
							<tr>
							<td>
								<img src="#SESSION.root#/images/joinbottom.gif" 
								alt="" border="0" align="absmiddle">
							</td>
							<td width="100">Departure:</td>
							<td>#DateFormat(DateDeparture,CLIENT.DateFormatShow)#</td>
							</tr>
							
							<tr>
							<td>
								<img src="#SESSION.root#/images/join.gif" 
								alt="" border="0" align="absmiddle">
							</td>
							<td width="80">Return:</td>
							<td>#DateFormat(DateReturn,CLIENT.DateFormatShow)#</td>
							</tr>
							<cfif Itinerary.recordcount neq "#currentRow#">
								<tr><td height="1" colspan="7" bgcolor="E5E5E5"></td></tr>
							</cfif>
						
						</cfloop>
						
					</table>
					</td></tr>
					</table>
				
			</td>
		</tr>
	
</cfoutput>				