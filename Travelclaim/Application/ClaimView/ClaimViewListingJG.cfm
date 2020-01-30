
<cfsilent>

<proUsr>administrator</proUsr>
<proOwn>Hanno van Pelt</proOwn>
<proDes>a.Made changes to disable claiming against Travel request that have status closed: TCP Issues: 33
b. Made changes since if the traveller does not choose express or detailed and hits logout ,when he logs back 
in it only shows detailed as the default (JG).
</proDes>
<proCom></proCom>
<proCM></proCM>

<proInfo>
<table width="100%" cellspacing="0" cellpadding="0">
<tr><td>
This template (called from ClaimViewBody.cfm) is the work-horse of the home page. It extracts the requested data and shows the information is visible or hidden format to the user.

The template does the work at opening for all 4 sections. As the number of claims per person is limited there is not much advantage loading the content using AJAX upon user action to expand a section.
</td></tr>
</table>
</proInfo>

</cfsilent>


<cfparam name="URL.page" default="1">
<cfparam name="URL.text" default="">
<cfparam name="client.claimlast" default="">

<cfoutput>
<SCRIPT LANGUAGE = "JavaScript">


function reloadForm(page) {
   window.location = "ClaimViewListing.cfm?PersonNo=#URL.PersonNo#&ID=#URL.ID#&ID1=#URL.ID1#&Page=" + page;
}

function showclaim(id1,id2) {
   window.location = "../ClaimEntry/ClaimEntry.cfm?PersonNo=#URL.PersonNo#&ClaimId="+id1+"&RequestId="+id2;
}

function claimdialog(claimid,mode,st,req) {
		
	if (mode == "1") {
		 if (st >= "1") {		 
		   window.location  = "../ClaimEntry/ClaimEntry.cfm?mode=1&RequestId="+req+"&ClaimId="+claimid;
		  } else {
		   window.location  = "../Express/ExpressEntry.cfm?ClaimId="+claimid;
		  }
     } else {	 
	   parent.window.location  = "../FullClaim/FullClaimView.cfm?PersonNo=#URL.PersonNo#&ClaimId="+claimid;
	}	
   
}

function zoom(row,mode) {
	
	se1 = document.getElementById(row+"_1")
	se2 = document.getElementById(row+"_2")
	
	if (mode == "show") {
	se1.className = "highlight2"
	se2.className = "highlight2"
	}
	
	else {
	se1.className = "regular"
	se2.className = "hide"
	}

}
	
</SCRIPT>	
</cfoutput>

<!-- Status = 1, pending submission
     Status = 2, submitted
	 Status = 3, ready for upload
	 Status = 4 and 4c, uploaded into IMIS
	 Status = 5, confirmed from IMIS, can have different status UA, AP, DB
	 Status = 6 outside
	 ---> 

<cfset condition = "">
<cfset text = "Claim">

<cfswitch expression="#URL.ID#">
	
	<cfcase value="STA">
	
	    <cfif #URL.ID1# eq "2">
			<cfset condition = "WHERE C.ActionStatus IN ('2','3','4','4c','4i')">			
			<cfset group = "ClaimStatus">
			
		<cfelseif #URL.ID1# eq "99">
		
		  	<cfset condition = "WHERE R.ActionStatus = 'cl'">
			<cfset group = "Mission">	
			
		<cfelse>
		
		
			<cfset condition = "WHERE C.ActionStatus = '#URL.ID1#'">
			<cfset group = "Mission">
			
		</cfif>
			
	</cfcase>
		
</cfswitch>

<cfswitch expression="#URL.ID#">

	<cfcase value="REQ">	
					 	
	<cfquery name="SearchResult" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   R.*, 
		         '{00000000-0000-0000-0000-000000000000}' as ClaimId,
		         '0' as ClaimStatus, 
				 '' as ClaimDocumentNo,
				 '0' as ClaimasIs,
				 T.DateDeparture, 
				 T.DateReturn, 
				 P.Description as Purpose, 
				 'Not claimed' as StatusDescription,
				 S.PointerStatus,
				 S.Description as PointerDescription,
				 '' as RequestStatus,
				 '' as RequestDescription
	    FROM     ClaimRequest R, 
		         Ref_ClaimPurpose P, 
				 Ref_Status S, 
				 userQuery.dbo.clm#SESSION.acc#ClaimTrip#FileNo# T
		WHERE    R.ClaimRequestId NOT IN (SELECT ClaimRequestId 
		                                  FROM Claim)
		AND      R.OrgUnit IN (SELECT OrgUnit 
		                       FROM Organization.dbo.Organization 
							   WHERE (DateEffective <= getdate() or DateEffective is NULL)
							   AND   (DateExpiration >= getDate() or DateExpiration is NULL)
							  )
		                                       								  
		AND      R.ActionStatus = S.Status
		AND      R.ActionPurpose = P.Code
		AND      R.PersonNo = '#URL.PersonNo#' 
		AND      T.ClaimRequestId = R.ClaimRequestId 
		AND      S.StatusClass = 'ClaimRequest'
		<!----Added the below line to exclude claim against tvrqs with status closed: Huda Seid---->
		AND R.actionstatus not in ('cl')
		UNION
		
		SELECT R.*, 
		         C.ClaimId,
		         C.ActionStatus as ClaimStatus, 
				 C.DocumentNo as ClaimDocumentNo,
				 C.ClaimAsIs,
				 T.DateDeparture, 
				 T.DateReturn, 
				 P.Description as Purpose, 
				 S.Description as StatusDescription,
				 S.PointerStatus,
				 S.Description as PointerDescription,
				 S1.PointerStatus as RequestStatus,
				 S1.Description as RequestDescription
	    FROM     ClaimRequest R, 
		         Ref_ClaimPurpose P, 
				 Claim C, 
				 Ref_Status S,
				 Ref_Status S1,
				 userQuery.dbo.clm#SESSION.acc#ClaimTrip#FileNo# T
		WHERE C.ActionStatus IN ('0','1') 
		<!---
		AND R.ActionStatus     != 'cl'
		--->
		AND R.ActionPurpose     = P.Code
		AND C.ActionStatus      = S.Status
		AND R.ActionStatus      = S1.Status
		AND R.OrgUnit IN (SELECT OrgUnit 
		                  FROM Organization.dbo.Organization 
						  WHERE (DateEffective <= getdate() or DateEffective is NULL)
						  AND  ( DateExpiration >= getDate() or DateExpiration is NULL)
						  )
		AND S1.StatusClass      = 'ClaimRequest'
		AND T.ClaimRequestId    = R.ClaimRequestId	
		AND S.StatusClass       = 'TravelClaim'
		AND C.ClaimRequestId    = R.ClaimRequestId
		AND R.PersonNo          = '#URL.PersonNo#' 
		ORDER BY ClaimStatus, R.DocumentNo 
		</cfquery>
		
		<cfset group = "ClaimStatus">

	</cfcase>
	
	<!--- disabled for release 1 

	<cfcase value="SUP">
	
	<cfquery name="SearchResult" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   R.*, 
			 	 '' as ClaimId,
		         '' as ClaimStatus,
				 '' as ClaimDocumentNo,
				 '' as ClaimAsIs,
		         T.DateDeparture, 
				 T.DateReturn, 
		         P.Description as Purpose, 
				 S.Description as StatusDescription,
				 S.PointerStatus,
				 S.Description as PointerDescription
	    FROM     ClaimRequest R, 
         		 Ref_ClaimPurpose P, 
		         Ref_Status S,
		         userQuery.dbo.clm#SESSION.acc#ClaimTrip T
		WHERE    R.ClaimRequestId IN 	(SELECT     CL.ClaimRequestId
									 FROM       ClaimLine CL INNER JOIN
									            Claim C ON CL.ClaimId = C.ClaimId
									 WHERE     (C.ActionStatus IN ('1', '2', '3')) 
									 GROUP BY CL.ClaimRequestId
									 HAVING      MIN(CL.PointerClaimFinal) = 0)
									 <!---
									 UNION
									 SELECT     CL.ClaimRequestId
									 FROM       ClaimLine CL INNER JOIN
									            Claim C ON CL.ClaimId = C.ClaimId
									 WHERE     (C.ActionStatus IN ('0')) 
									 GROUP BY CL.ClaimRequestId
									 HAVING      MIN(CL.PointerClaimFinal) = 1)
									 --->
		AND      T.ClaimRequestId = R.ClaimRequestId							 
		AND      R.ActionPurpose = P.Code
		AND      R.PersonNo = '#URL.PersonNo#' 
		AND      R.ActionStatus = S.Status
		AND      S.StatusClass = 'ClaimRequest'		
		ORDER BY ActionStatus, R.Mission, R.DocumentNo
		</cfquery>
		
		<cfset group = "ActionStatus">

	</cfcase>
	
	--->

	<cfdefaultcase>

		<cfquery name="SearchResult" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT DISTINCT R.*, 
		           C.ActionStatus as ClaimStatus, 
	           	   T.DateDeparture, 
				   T.DateReturn,
		           C.ClaimId,
				   C.ClaimAsIs,
		           C.DocumentNo as ClaimDocumentNo, 
				   C.ClaimDate,
				   C.Reference,
				   C.ReferenceNo,
				   C.ReferenceStatus,
				   C.PointerUpload,
				   C.PaymentDueDate,
				   C.PaymentCurrency,
				   C.PaymentFund,
				   S.Description as StatusDescription,
		           P.Description as Purpose,
				   S1.PointerStatus,
				   S1.Description as PointerDescription
	    FROM     ClaimRequest R, 
		         Ref_ClaimPurpose P, 
				 Claim C, 
				 Ref_Status S,
				 Ref_Status S1,
				 userQuery.dbo.clm#SESSION.acc#ClaimTrip#FileNo# T 
		#preserveSingleQuotes(condition)# 
		AND R.ActionPurpose  = P.Code
		AND C.ActionStatus   = S.Status
		AND R.ActionStatus   = S1.Status
		AND T.ClaimRequestId = R.ClaimRequestId	
		AND S.StatusClass    = 'TravelClaim'
		AND S1.StatusClass   = 'TVCV'
		AND R.OrgUnit IN (SELECT OrgUnit 
		                  FROM Organization.dbo.Organization
					      WHERE (DateEffective <= getdate() or DateEffective is NULL)
						   AND  (DateExpiration >= getDate() or DateExpiration is NULL)
						   )
		AND C.ClaimRequestId = R.ClaimRequestId
		AND R.PersonNo       = '#URL.PersonNo#' 
		ORDER BY C.ActionStatus, R.DocumentNo  
		</cfquery>
		
	</cfdefaultcase>

</cfswitch>

<cfquery name="Parameter" 
datasource="appsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
    FROM Parameter
</cfquery>
	
<!--- Query returning search results --->

<cfif URL.ID eq "REQ">
<cfset border = 0>
<cfelse>
<cfset border = 1>
</cfif>

<table width="100%" border="<cfoutput>#border#</cfoutput>" frame="hsides" cellspacing="0" cellpadding="1" bordercolor="e4e4e4" rules="rows">
	
<tr><td>
 	
<table class="#cl#" width="100%" border="0" cellspacing="0" cellpadding="0" align="left" bordercolor="#C0C0C0">

<cfif SearchResult.recordcount eq "0">

	<cfif URL.ID eq "REQ">
		   
		<tr>
			<td colspan="2" height="17" align="center" >&nbsp;&nbsp;<b><font color="red">You have no recorded <cfoutput>#URL.Text#</cfoutput></b></td>
		</tr>	
		<tr>
			<td colspan="2" align="center">
				<cf_helpfile code = "TravelClaim" 
				    id      = "1" 
					display = "Both"					
					color   = "668800">
			</td>
			
		</tr>	
				
		<cfelse>
		
		<tr bgcolor="ffffef"><td height="17" 
		   colspan="2">
		   &nbsp;&nbsp;<b>
		   <font color="gray">
		   No <cfoutput>#URL.Text#</cfoutput> found</b>
		   </td>
		 </tr>  
						 
		</cfif>	 
	
<cfelse>  
				
	<cfoutput query="SearchResult" group="#Group#">
	
		<cfif group eq "ActionStatus">
		
		<tr>
		
			<td height="15" colspan="1">&nbsp;&nbsp;<b>#StatusDescription#</td>		
			<td colspan="1" align="right" bgcolor="ECECDE"></td>
		
		</tr>
		
		<tr><td colspan="2" bgcolor="silver"></td></tr>
						
		<cfelseif group eq "ClaimStatus">
								
			<cfif URL.ID eq "REQ">		
			
				<tr>
				<td align="left">
				<cfif currentrow eq "1">
					<cf_helpfile code = "TravelClaim" 
					    id      = "1" 
						color   = "6688aa"
						display = "Both">	 					
				</cfif>					
				</td>				
				</tr>
				
				
			<cfelse>
			
				<tr><td height="21">&nbsp;&nbsp;<b>#StatusDescription#</td>				
				<td align="right"></td>
					 
			</tr></cfif>	 
		
			
			<tr><td colspan="2" bgcolor="silver"></td></tr>	
						
		<cfelse>
		
			<tr>
			
				<td height="20">&nbsp;&nbsp;<b>#Mission#</td>
				<td colspan="1" align="right"></td>
			
			</tr>
			<tr><td colspan="2" bgcolor="silver"></td></tr>	
		
		</cfif>
		
		<tr>
			<td colspan="2">
		    <table width="100%" cellspacing="0" cellpadding="2">
									
		<cfif URL.ID1 lte "3" or URL.ID neq "STA">
				       		
				<cfif currentrow eq "1">
							
					<tr>
					    <td height="18" width="20"></td>
						<td width="15%"><b>#Parameter.ClaimRequestPrefix#</td>
						<td width="10%"><b>Duty Station</td>
						<td width="10%"><b>Claim No</td>
						<td width="15%"><b>Departure</td>
						<td width="15%"><b>Return</td>
						<td width="20%"><b>Purpose</td>
						<td width="5%"></td>
				    </tr>
					<tr><td height="1" colspan="8" bgcolor="C0C0C0"></td></tr>
				
				<cfelse>
				
					<tr bgcolor="f1f1f1">
					    <td height="3" width="20"></td>
						<td width="15%"></td>
						<td width="10%"></td>
						<td width="10%"></td>
						<td width="15%"></td>
						<td width="15%"></td>
						<td width="20%"></td>
						<td width="5%"></th>
				    </tr>
				
				</cfif>
										
					
					<cfoutput>
					
					    <cfif client.claimLast eq claimId and URL.ID eq "REQ">
						
							<tr height="20" bgcolor="D6F8E0" id="#currentrow#_1"							
								onMouseOver="zoom('#currentrow#','show')"
								style="cursor: hand;"
								onClick="claimdialog('#ClaimId#','#claimAsIs#','#ClaimStatus#','#ClaimRequestid#')"
							    onMouseOut="zoom('#currentrow#','hide')">
						
						<cfelseif ClaimStatus gte "2">
						
							<tr height="20" id="#currentrow#_1" style="cursor: hand;"
						  	bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('f4f4f4'))#"
							onClick="claimdialog('#ClaimId#','#claimAsIs#','#ClaimStatus#','#ClaimRequestid#')">
						
						<cfelse>
						
							<cfif claimid neq "00000000-0000-0000-0000-000000000000">
							<!---  JG - Fixed because of bug that if the user
							does not select express or detailed and logs out 
							the system puts him back in detailed mode if he logs back in.
							Understanding.
							--------------
												
							 A record gets inserted into the Claim table the moment 
							 a claim is selected (if he/she did not select express/detailed)
							 that is the logic (which is a bit fuzzy) but since that logic already
							 exist , If a user views all the claims and clicks on a particular and 
							 does not choose express/Detailed when he/she logs out , and if he/she logs 
							 back onceagain , it takes them to detailed mode only.
							 To prevent this I added the following logic.
							 1. Check whether the detailed option was chosen if so , there would records
							    in claimeventtrip actionstatus on the time entered atleast (mandatory field)
							  2. If such is the case , then the detailed mode was chosen so use the claim id 
							  information to show the existing history information (fullclaimview)
							  3. If nothing was chosen then instead of calling claimview call the 
							      call the showclaim with just the requestid which will call claimentry
								  instead of fullclaimview.cfm
						      
							--->
							 <cfif ClaimRequestId neq "">
								<cfquery name="CheckDetailedClaimSaved" 
								datasource="appsTravelClaim" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#"> 
								SELECT    actionstatus  as Detailed_entered
           								FROM         ClaimEvent A, ClaimEventTrip B
								WHERE     ClaimId in (select claimid from 
									claim where claimrequestid ='#ClaimRequestId#')
									and A.ClaimEventid =B.ClaimeventID
									and actionstatus =1
                                 </cfquery>
								</cfif>
							<cfif claimstatus eq "0" and claimasis eq "0" and CheckDetailedClaimSaved.recordcount eq "0" >
							 		<tr height="20" id="#currentrow#_1"
						    		style="cursor: hand;"
									bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('f4f4f4'))#"
									onClick="showclaim('','#ClaimRequestId#')"
									onMouseOver="zoom('#currentrow#','show')"
							    	onMouseOut="zoom('#currentrow#','hide')">
																		
								<cfelse>	   
							 		
							<tr height="20" id="#currentrow#_1"
						    	style="cursor: hand;"
								bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('f4f4f4'))#"
								onClick="claimdialog('#ClaimId#','#claimAsIs#','#ClaimStatus#','#ClaimRequestid#')"
								onMouseOver="zoom('#currentrow#','show')"
							    onMouseOut="zoom('#currentrow#','hide')">
							</cfif>	
							<cfelse>
														
							<tr height="20" id="#currentrow#_1"
						    	style="cursor: hand;"
								bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('f4f4f4'))#"
								onClick="showclaim('','#ClaimRequestId#')"
								onMouseOver="zoom('#currentrow#','show')"
							    onMouseOut="zoom('#currentrow#','hide')">
																					
							</cfif>	
						
						</cfif>
									   
						   <TD width="5%" rowspan="1" align="center">
						  
							   <cfif claimid eq "00000000-0000-0000-0000-000000000000">
									  
									   <img src="#SESSION.root#/Images/bullet.png"
									     alt="Prepare claim"
									     name="img#url.id#_#currentrow#"
									     id="img#url.id#_#currentrow#"
									     border="0"
										
									     align="middle"
									     style="cursor: hand;"									     
									     onMouseOver="document.img#URL.ID#_#currentrow#.src='#SESSION.root#/Images/button.jpg'"
									     onMouseOut="document.img#URL.ID#_#currentrow#.src='#SESSION.root#/Images/bullet.png'">
									
							    <cfelseif claimstatus gte "2" <!--- and #URL.ID# neq "STA" --->>
									  
									   <img src="#SESSION.root#/Images/alert_caution.gif"
									     alt="View claim"
									     name="img#url.id#_#currentrow#"
									     id="img#url.id#_#currentrow#"
									     border="0"
									     align="middle"
									     style="cursor: hand;"
									     onMouseOver="document.img#URL.ID#_#currentrow#.src='#SESSION.root#/Images/button.jpg'"
									     onMouseOut="document.img#URL.ID#_#currentrow#.src='#SESSION.root#/Images/alert_caution.gif'">
										 
							   <cfelseif requeststatus eq "0">
							 
										 <img src="#SESSION.root#/Images/object_locked.gif"
									     alt="#RequestDescription#"
									     name="img#URL.ID#_#currentrow#"
									     id="img#URL.ID#_#currentrow#"
									     border="0"
										 width="13"
									     height="14"
									     align="middle">
										 
								<cfelse>		 
									
										<img src="#SESSION.root#/Images/bullet.png"
									     alt="Update claim"
									     name="img#url.id#_#currentrow#"
									     id="img#url.id#_#currentrow#"
									  
									     border="0"
									     align="middle"
									     style="cursor: hand;"
									     onMouseOver="document.img#URL.ID#_#currentrow#.src='#SESSION.root#/Images/button.jpg'"
									     onMouseOut="document.img#URL.ID#_#currentrow#.src='#SESSION.root#/Images/bullet.png'">
																	 
								</cfif> 
												
						 </td>
						 
							    <TD rowspan="1">#DocumentNo#</td>
								<TD>#Mission#</td>
								<TD><cfif ClaimDocumentNo neq "0">#ClaimDocumentNo#</cfif></TD>
							    <TD>#DateFormat(DateDeparture, CLIENT.DateFormatShow)#</b></TD>
								<TD>#DateFormat(DateReturn, CLIENT.DateFormatShow)#</b></TD>
								<TD>#Purpose#</TD>
								<td rowspan="1" align="right">
								    
									<!---
								    <cfif ClaimAsIs eq "1">
									
									<img src="#SESSION.root#/images/alert_caution.gif"
								     alt="Express Claim"
								     border="0"
								     align="absmiddle">
									</cfif>
									&nbsp;
									--->
								   
								</td>
													
							</TR>
							
							<cfif client.claimLast eq claimId>
							<cfset det = "regular">							
							<cfelse>
							<cfset det = "hide">							
							</cfif>
							
							<cfquery name="Itin" 
								datasource="appsTravelClaim" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT   TOP 1 *
								FROM     ClaimRequestItinerary T
								WHERE    ClaimRequestId = '#ClaimRequestId#'
								AND Itinerary is not NULL
							</cfquery>
							
							
							<cfif claimid neq "00000000-0000-0000-0000-000000000000">
							
								<tr id="#currentrow#_2" class="#det#"
						    	style="cursor: hand;"
								bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('f4f4f4'))#"
								onClick="claimdialog('#ClaimId#','#claimAsIs#','#ClaimStatus#','#ClaimRequestid#')"
								onMouseOver="zoom('#currentrow#','show')"
							    onMouseOut="zoom('#currentrow#','hide')">
															
								    <td colspan="2"></td>																
									<td colspan="5">#Itin.Itinerary#</td>
									<td></td>	
								</tr>		
								
							<cfelse>
							
								<tr id="#currentrow#_2" class="#det#"
							    	style="cursor: hand;"
									bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('f4f4f4'))#"
									onClick="showclaim('','#ClaimRequestId#')"
									onMouseOver="zoom('#currentrow#','show')"
								    onMouseOut="zoom('#currentrow#','hide')">																
								    <td colspan="2"></td>																
									<td colspan="5">#Itin.Itinerary#</td>
									<td></td>								
								</tr>	
																					
							</cfif>	
							
																																															      
					</cfoutput>   
				
	<cfelse>
		
			<tr bgcolor="e9e9e9">
			    <td class="top4n" width="20"></td>
				<td class="top4n" width="20%">IMIS Document</td>
				<td class="top4n" width="15%">#Parameter.ClaimRequestPrefix#</td>
				<td class="top4n" width="10%">Status</td>
				<td class="top4n" width="15%">Departure</td>
				<td class="top4n" width="15%">Return</td>
				<td class="top4n" width="10%">Curr.</td>
				<td class="top4n" width="15%" align="right">Amount</td>
						
					
				<cfoutput>
				
						<cfif client.claimLast eq claimId>
						
							<TR height="20" bgcolor="ffffcf">
						
						<cfelse>
																	
						    <cfif #PointerStatus# eq "0">
							<TR height="20" bgcolor="#IIf(CurrentRow Mod 2, DE('FfFfFf'), DE('ffffff'))#">
							<cfelse>
							<TR height="20" bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('ffffff'))#">
							</cfif>
						
						</cfif>
						   
						   <TD width="5%" height="21" rowspan="2" align="center">
															
						     <cfif #URL.ID# eq "0" or #URL.ID1# eq "1">
							   <cfset i = "#SESSION.root#/Images/insert3.gif">
							   <cfset t = "Prepare or Submit claim">
							 <cfelse>
							   <cfset i = "#SESSION.root#/Images/contract.gif">
							   <cfset t = "View Claim">
							 </cfif>
							 
							 <cfif PointerStatus eq "0">
					
							 <img src="#SESSION.root#/Images/object_locked.gif"
						     alt="#t#"
						     name="img#URL.ID#_#currentrow#"
						     id="img#URL.ID#_#currentrow#"
						     border="0"
							   width="13"
						     height="14"
						     align="middle">
							 
							 <cfelse>
							 
								 <cfif ClaimStatus gte "6">
								 
										<img src="#i#"
								     alt="#t#"
								     name="img#URL.ID#_#currentrow#"
								     id="img#URL.ID#_#currentrow#"
								     border="0"
									   width="13"
								     height="14"
								     align="middle"
								     style="cursor: hand;"
									 onClick="showclaim('#ClaimId#','#ClaimRequestId#')"
								     onMouseOver="document.img#URL.ID#_#currentrow#.src='#SESSION.root#/Images/button.jpg'"
								     onMouseOut="document.img#URL.ID#_#currentrow#.src='#i#'">	
								 
								 <cfelse>
								 
								 		<img src="#i#"
								     alt="#t#"
								     name="img#URL.ID#_#currentrow#"
								     id="img#URL.ID#_#currentrow#"
								     border="0"
									   width="13"
								     height="14"
								     align="middle"
								     style="cursor: hand;"
									 onClick="javascript:claimdialog('#ClaimId#','#claimAsIs#','#ClaimStatus#','#ClaimRequestid#')"
								     onMouseOver="document.img#URL.ID#_#currentrow#.src='#SESSION.root#/Images/button.jpg'"
								     onMouseOut="document.img#URL.ID#_#currentrow#.src='#i#'">	
								 
								 </cfif>
																				 
							 </cfif>											
							</td>
						   	<td rowspan="2">
							<cfif PointerStatus neq "0">
								<cfif ClaimStatus gte "6">
								<a href="javascript:showclaim('#ClaimId#','#ClaimRequestId#')">
								<cfelse>
								<a href="javascript:claimdialog('#ClaimId#','#claimAsIs#','#ClaimStatus#','#ClaimRequestid#')">
								</cfif>
							</cfif>
							#Reference#-#ReferenceNo#</a></td>
							 <TD>#DocumentNo# <cfif claimAsIs eq "1">&nbsp;
							  <img src="#SESSION.root#/Images/alert_caution.gif" 
							    alt="Express claim"
								border="0" 
								align="absmiddle">
							 </cfif></td>
							 
							<TD>
							
							<cfquery name="SelectStatus"
							   datasource="appsTravelClaim"
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
							   SELECT *
							   FROM Ref_Status
							   WHERE StatusClass = 'TVCV'
							   AND   Status = '#ReferenceStatus#' 					   
							</cfquery> 
							
							#SelectStatus.Description#</TD>
						    <TD>#DateFormat(DateDeparture, CLIENT.DateFormatShow)#</b></TD>
							<TD>#DateFormat(DateReturn, CLIENT.DateFormatShow)#</b></TD>
							
							<cfif #PointerUpload# eq "0">
																	
							<cfquery name="Total" 
							datasource="appsTravelClaim" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT     SUM(AmountClaim) AS Total
							FROM         ClaimLine
							WHERE ClaimId = '#ClaimId#'
							</cfquery>
							
							<cfelse>
							
							<cfquery name="Total" 
							datasource="appsTravelClaim" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT     SUM(AmountClaim) AS Total
							FROM         ClaimLineExternal
							WHERE ClaimId = '#ClaimId#'
							</cfquery>
							
							</cfif>
							
							<td>#PaymentCurrency#</td>
							<td align="right">#numberFormat(Total.Total,"__,__.__")#&nbsp;</td>
																			
						</TR>
						
						<cfquery name="Itin" 
								datasource="appsTravelClaim" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								SELECT   TOP 1 *
								FROM     ClaimRequestItinerary T
								WHERE    ClaimRequestId = '#ClaimRequestId#'
								AND Itinerary is not NULL
						</cfquery>
						
						<cfif client.claimLast eq claimId>						
							<TR bgcolor="ffffcf">						
						<cfelse>
																		
							<cfif #PointerStatus# eq "0">
								<TR bgcolor="#IIf(CurrentRow Mod 2, DE('F4F4F4'), DE('f4f4f4'))#">
							<cfelse>
								<TR bgcolor="#IIf(CurrentRow Mod 2, DE('f7f7f7'), DE('f4f4f4'))#">
							</cfif>
							
						</cfif>	
							
						<td colspan="6">#Itin.Itinerary#</td>
						</tr>
										  
				</cfoutput> 	  
						
				</cfif>
				
			</table>
			</td>
		</tr>		
						
							      
	</cfoutput>   
			  
</cfif>	  

</TABLE>			 

</tr>

</table>

