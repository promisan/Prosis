
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
	  
	  <!---
	   
	   <cfif details.recordcount gte "1">
	   
		   <tr class="line labelmedium">
		   <td style="min-width:40"></td>
		   <td style="min-width:80"><cf_tl id="Class"></td>
		   <td style="min-width:100"><cf_tl id="Track"></td>
		   <td style="min-width:100"><cf_tl id="Due"></td>
		   <td style="min-width:70"><cf_tl id="VA"></td>
		   <td style="width:100%"><cf_tl id="Grade"></td>
		   <td style="min-width:160"><cf_tl id="Position">		     
		   <td style="min-width:200"><cf_tl id="Title"></td>
		   <td style="min-width:120"><cf_tl id="Office"></td>	   
		   <td style="min-width:120"><cf_tl id="Officer"></td>	   
		   </tr>
			   
	   </cfif>
	   
	   --->
					
	   <cfoutput query="Details" group="ActionCode">
	   
	   <cfif Status eq "9">
	   	   <cfset cl = "FDDFDB">
	   <cfelse>
		   <cfset cl = "white">
	   </cfif>	   	 
	   
	   <tr class="labelmedium cls#URL.Mission##row#" style="display:none;">
	   		<td align="left" colspan="6" style="padding-left:24px;font-weight:bold" class="labelmedium">#ActionDescription#</td>
	   </tr>
	 	 		   	   
		   <cfoutput>
	
			   <tr bgcolor="#cl#" class="navigation_row line labelmedium cls#URL.Mission##row#" style="height:20px; display:none;">
			      <td style="padding-left:24px">#CurrentRow#</td> 
				  <td style="padding-right:3px">#EntityClass#</td>
				 
			      <td style="padding-left:2px;padding-right:3px"><a href="javascript:showdocument('#DocumentNo#','')">#DocumentNo#</a> </td>	
				  <td style="padding-right:3px">#dateformat(duedate,client.dateformatshow)#</td>		  
				  <td style="padding-left:2px;padding-right:3px">#left(VAReferenceNo,6)#</td>
				 
				  <td style="padding-right:3px">#Postgrade#</td>
				  
				  <td align="left"  style="padding-right:3px">
				  									
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
									  AND        PA.DateExpiration <= '#Created#') as AssignmentExpiration								 
									 
							FROM     DocumentPost DP INNER JOIN 
							         Employee.dbo.Position P ON DP.PositionNo = P.PositionNo INNER JOIN
									 Employee.dbo.PositionParent PP ON PP.PositionParentId = P.PositionParentId
							WHERE    DocumentNo = '#DocumentNo#'
							
						</cfquery>	
					
						<table width="100%">
				
						<cfloop query = "qPosition">					
							
							<tr class="labelmedium">
							<td>
								<cfif PostNumber neq "">
									<a href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#','','no')">#PostNumber#</a>
								<cfelse>
									<a href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#','','no')">#PositionParentId#</a>
								</cfif>
							</td>
							
							<td style="padding-left:3px">
								#DateFormat(AssignmentExpiration,client.dateformatshow)#							
							</td>
							
							</tr>					
							
						</cfloop>	
						  
					    </table>	
						
								  			 
					    
				  </td>			
				  <td style="padding-right:3px">#FunctionalTitle#</td>		
				  <td style="padding-right:3px">#OrgUnitNameShort#</td>
				  <td style="padding-right:3px">#OfficerUserLastName#</td>				
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
	  
	  <!---
		
	   <cfif details.recordcount gte "1">	
	   
	   	  <tr class="line labelmedium">
		   <td style="min-width:40"></td>
		   <td style="min-width:80"><cf_tl id="Class"></td>
		   <td style="min-width:100"><cf_tl id="Track"></td>
		   <td style="min-width:100"><cf_tl id="Due"></td>
		   <td style="min-width:70"><cf_tl id="VA"></td>
		   <td style="width:100%"><cf_tl id="Candidate"></td>
		   <td style="min-width:160"><cf_tl id="Position"></td>		       
		   <td style="min-width:200"><cf_tl id="Title"></td>
		   <td style="min-width:120"><cf_tl id="Office"></td>	   
		   <td style="min-width:120"><cf_tl id="Officer"></td>	   
		   </tr>		
	   
	   </cfif>
	   
	   --->
	   
	   <cfoutput query="Details"> 
	   
		   <tr class="navigation_row line labelmedium cls#URL.Mission##row#" style="height:20px; display:none;">
		      <td style="padding-left:24px">#CurrentRow#</td> 
		      <td>#EntityClass#</td>			  
		      <td style="padding-left:2px"><a href="javascript:showdocument('#DocumentNo#','')">#DocumentNo#</a></td>	
			  <td style="padding-right:3px">#dateformat(duedate,client.dateformatshow)#</td>		 
			  
			  <td style="padding-left:2px">#left(VAReferenceNo,6)#</td>						     
			  <td style="padding-left:3px"><a href="javascript:showdocumentcandidate('#DocumentNo#','#PersonNo#')">#FirstName# #LastName#</a></td>			 			  
			  <td align="left" style="padding-right:3px">
			  
			   <cfquery name = "qPosition"
				       datasource = "AppsVacancy"
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						SELECT   P.Mission,
								 P.MandateNo,
								 DP.PostNumber, 
						         DP.PositionNo,								 
								 
								  <!--- take expiration date of the position(s) associated to the track prior to the creation --->
			 
								 (SELECT     MAX(DateExpiration)
								  FROM       Employee.dbo.PersonAssignment PA
								  WHERE      PA.PositionNo = DP.PositionNo			 
								  AND        PA.AssignmentStatus IN ('0', '1') 
								  AND        PA.DateExpiration <= '#Created#') as AssignmentExpiration								 
								 
						FROM     DocumentPost DP INNER JOIN 
						         Employee.dbo.Position P ON DP.PositionNo = P.PositionNo INNER JOIN
								 Employee.dbo.PositionParent PP ON PP.PositionParentId = P.PositionParentId
						WHERE    DocumentNo = '#DocumentNo#'
			    </cfquery>				  
			  
				<table width="100%" cellspacing="0" cellpadding="0">
		
				<cfloop query = "qPosition">					
					
					<tr class="labelmedium">
					<td>
						<cfif PostNumber neq "">
							<a href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#','','no')">#PostNumber#</a>
						<cfelse>
							<a href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#','','no')">N/A</a>
						</cfif>
					</td>
					
					<td style="padding-left:3px">
						#DateFormat(AssignmentExpiration,client.dateformatshow)#							
					</td>
					
					</tr>					
					
				</cfloop>	
				  
			  </table>	  
			  		  
			  </td>				
			  <td style="padding-right:3px">#FunctionalTitle#</td>	  
			  <td style="padding-right:3px">#OrgUnitNameShort#</td>				 		  
			  <td style="padding-right:3px">#OfficerUserLastName#</td>		
			  			
			</tr>
					
	    </cfoutput>
	   
</cfif>


