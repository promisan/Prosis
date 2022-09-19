
<cfif EntityCode eq "VacDocument">

	   <!--- show track --->	
	
	   <cfquery name="Details" dbtype="query">
			SELECT    *
			FROM      DetailsDocument
			WHERE     ParentCode = '#Code#'					
			ORDER BY  ActionCode,
			          EntityClass,
					  DocumentNo
	  </cfquery>
	 					
	   <cfoutput query="Details" group="ActionCode">
	   
		   <cfif Status eq "9">
		   	   <cfset cl = "FDDFDB">
		   <cfelse>
			   <cfset cl = "white">
		   </cfif>	   	 
		   
		   <tr class="labelmedium2 fixlengthlist cls#URL.Mission##row#" style="display:none;">
		   		<td align="left" colspan="6" style="padding-left:24px;font-weight:bold">#ActionDescriptionStep#</td>
		   </tr>
	 	 		   	   
		   <cfoutput>
	
			   <tr bgcolor="#cl#" class="navigation_row line fixlengthlist labelmedium cls#URL.Mission##row#" style="height:20px; display:none;">
			      <td style="padding-left:24px">#CurrentRow#</td> 
				  <td>#TypeDescription#</td>
				  <td>#dateformat(Created,client.dateformatshow)#</td>
				  <td>#dateformat(DatePosted,client.dateformatshow)#</td>
			      <td><a href="javascript:showdocument('#DocumentNo#','')">
				  <cfif VAReferenceNo neq "">#left(VAReferenceNo,8)#<cfelse>#DocumentNo#</cfif></a> </td>	
				  <td title="Expected Onboarding date"><cfif duedate le now() and url.status eq "0"><font color="FF0000"></cfif>#dateformat(duedate,client.dateformatshow)#</td>		  				 				 
				  <td>#Postgrade# <cfif candidates gt "0">[#Candidates#]</cfif></td>
				  
				  <td align="left">
				  									
						 <cfquery name = "qPosition"
					       datasource = "AppsVacancy"
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						   
							SELECT   P.Mission,
									 P.MandateNo,
									 P.PositionParentId,
									 DP.PostNumber, 
							         DP.PositionNo,	
									 DP.DateVacant							 
									 
									  <!--- take expiration date of the position(s) associated to the track prior to the creation 
				 
									 (SELECT     MAX(DateExpiration)
									  FROM       Employee.dbo.PersonAssignment PA
									  WHERE      PA.PositionNo = DP.PositionNo			 
									  AND        PA.AssignmentStatus IN ('0','1') 
									  AND        PA.Incumbency > 0
									  AND        PA.AssignmentType = 'Actual'
									  AND        PA.DateExpiration <= '#Created#') as AssignmentExpiration		
									  
									  --->						 
									 
							FROM     DocumentPost DP INNER JOIN 
							         Employee.dbo.Position P ON DP.PositionNo = P.PositionNo INNER JOIN
									 Employee.dbo.PositionParent PP ON PP.PositionParentId = P.PositionParentId
							WHERE    DocumentNo = '#DocumentNo#'
							
						</cfquery>	
					
						<table width="100%">
				
						<cfloop query = "qPosition">					
							
							<tr class="labelmedium" style="height:20px">
							<td>
								<cfif PostNumber neq "">
									<a href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#','','no')">#PostNumber#</a>
								<cfelse>
									<a href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#','','no')">#PositionParentId#</a>
								</cfif>
							</td>
							
							<td style="padding-left:3px" title="Vacant since">
								#DateFormat(DateVacant,client.dateformatshow)#							
							</td>
							
							</tr>					
							
						</cfloop>	
						  
					    </table>	
						   
				  </td>			
				  <td>#FunctionalTitle#</td>		
				  <td>#OrgUnitNameShort#</td>
				  <td>#OfficerUserLastName#</td>				
			   </tr>  
				
		   </cfoutput>
		   	   
    </cfoutput>
						
<cfelse>

	  <!--- show track candidacy --->
	
	  <cfquery name="Details" dbtype="query">
			SELECT  *
			FROM    DetailsCandidate
			WHERE   ParentCode = '#Code#'
	  </cfquery>
	 	   
	   <cfoutput query="Details"> 
	   
		   <tr class="navigation_row line fixlengthlist labelmedium cls#URL.Mission##row#" style="height:20px; display:none;">
		      <td style="padding-left:24px">#CurrentRow#</td> 
		      <td>#TypeDescription#</td>	
			  <td>#dateformat(Created,client.dateformatshow)#</td>		
			  <td>#dateformat(DatePosted,client.dateformatshow)#</td>	  
		       <td><a href="javascript:showdocument('#DocumentNo#','')">
				  <cfif VAReferenceNo neq "">#left(VAReferenceNo,8)#<cfelse>#DocumentNo#</cfif></a> </td>	
			  <td><cfif duedate le now() and url.status eq "0"><font color="FF0000"></cfif>#dateformat(duedate,client.dateformatshow)#</td>		 
			  
			  					     
			  <td><a href="javascript:showdocumentcandidate('#DocumentNo#','#PersonNo#')">#FirstName# #LastName#</a></td>			 			  
			  <td align="left">
			  
			   <cfquery name = "qPosition"
				       datasource = "AppsVacancy"
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						SELECT   P.Mission,
								 P.MandateNo,
								 P.PositionParentId,
								 DP.PostNumber, 
						         DP.PositionNo,								 
								 
								  <!--- take expiration date of the position(s) associated to the track prior to the creation --->
								  
								   (SELECT     MAX(DateExpiration)
									FROM       Employee.dbo.PersonAssignment PA
									WHERE      PA.PositionNo = DP.PositionNo			 
									AND        PA.AssignmentStatus IN ('0','1') 
									AND        PA.Incumbency > 0
									AND        PA.AssignmentType = 'Actual'
									AND        PA.DateExpiration <= '#Created#') as AssignmentExpiration
			 				 
								 
						FROM     DocumentPost DP INNER JOIN 
						         Employee.dbo.Position P ON DP.PositionNo = P.PositionNo INNER JOIN
								 Employee.dbo.PositionParent PP ON PP.PositionParentId = P.PositionParentId
						WHERE    DocumentNo = '#DocumentNo#'
			    </cfquery>				  
			  
				<table width="100%" cellspacing="0" cellpadding="0">
		
				<cfloop query = "qPosition">					
					
					<tr class="labelmedium" style="height:20px">
					<td>
						<cfif PostNumber neq "">
							<a href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#','','no')">#PostNumber#</a>
						<cfelse>
							<a href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#','','no')">#PositionParentId#</a>
						</cfif>
					</td>
					
					<td style="padding-left:3px" title="Assignment expiration">
						#DateFormat(AssignmentExpiration,client.dateformatshow)#							
					</td>
					
					</tr>					
					
				</cfloop>	
				  
			  </table>	  
			  		  
			  </td>				
			  <td>#FunctionalTitle#</td>	  
			  <td>#OrgUnitNameShort#</td>				 		  
			  <td>#OfficerUserLastName#</td>		
			  			
			</tr>
					
	    </cfoutput>
	   
</cfif>


