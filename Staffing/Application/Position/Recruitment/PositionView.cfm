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
<cf_divscroll>

<table style="width:94%" align="center">

  <tr>
  <td colspan="2">
  	<cfinclude template="../Position/PositionViewHeader.cfm">
  </td>
  </tr>  
  
    <cfif Position.mission eq "DPPA-DPO" or Position.mission eq "OCT">
      <cfset source = "hub">
    <cfelse>
      <cfset source = "standard">
    </cfif>
    
	<cfquery name="getTracks" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">    
		SELECT      D.DocumentNo, D.Owner, D.Mission, D.PositionNo, D.DueDate, 
		            D.FunctionId, D.FunctionNo, D.FunctionalTitle, 
					D.OrganizationUnit, D.PostGrade, D.Status,
					FO.ReferenceNo,
					D.EntityClass, 
					(SELECT  EntityClassName
                     FROM    Organization.dbo.Ref_EntityClass
                     WHERE   EntityCode = 'VacDocument' 
					 AND     EntityClass = D.EntityClass) as EntityClassName,
					D.Remarks, D.Source, FO.PostSpecific, 
					FO.DateEffective, FO.DateExpiration, 
					D.OfficerUserId, D.OfficerUserLastName, D.OfficerUserFirstName, D.Created
					
		FROM        Document AS D LEFT OUTER JOIN
	                Applicant.dbo.FunctionOrganization AS FO ON D.DocumentNo = FO.DocumentNo
					
		WHERE       D.Status <> '9'
		
		
		AND         ( D.DocumentNo IN (SELECT DocumentNo
		                             FROM   DocumentPost 
						   		     WHERE  PositionNo IN (SELECT PositionNo 
								                           FROM   Employee.dbo.Position
														   WHERE  PositionParentId = '#position.PositionParentId#'))
														   
					OR 
					
					D.PositionNo IN (SELECT DocumentNo
		                             FROM   DocumentPost 
						   		     WHERE  PositionNo IN (SELECT PositionNo 
								                           FROM   Employee.dbo.Position
														   WHERE  PositionParentId = '#position.PositionParentId#'))		
														   
					   )							   
														  
		ORDER BY    D.DocumentNo DESC
	</cfquery>
	
	<cfset since = "">
	<cfset until = "">
 
    <!---
	<cfif Position.mission neq "DPPA-DPO">
	--->
		
		<cfquery name="getLast" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
		    SELECT   MAX(DateExpiration) as DateExpiration
		    FROM     PersonAssignment
		    WHERE    PositionNo IN (SELECT PositionNo FROM Position WHERE PositionParentId = '#Position.PositionParentId#')
			AND      Incumbency > 0 
		    AND      AssignmentType = 'Actual'
		    AND      AssignmentStatus IN ('0','1')
		</cfquery>	
		
		<cfquery name="getUntil" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
		    SELECT   MAX(DateExpiration) as DateExpiration
		    FROM     PersonAssignment
		    WHERE    PositionNo IN (SELECT PositionNo FROM Position WHERE PositionParentId = '#Position.PositionParentId#')
			<!--- see if we have any liens --->
			AND      Incumbency = 0 
		    AND      AssignmentType = 'Actual'
		    AND      AssignmentStatus IN ('0','1')
		</cfquery>		
		
		<cfif getUntil.recordcount eq "0" and ExpirationDate lte now()>
		
		    <cfset until = Position.DateExpiration>
			
		<cfelse>
		    <!--- lien capped vacancy --->
			<cfset until = getUntil.DateExpiration>
		
		</cfif>
	 
	<!--- 
	<cfelse>
	
	      <cfparam name="getLast.DateExpiration" default="01/01/2021">
	       <cfparam name="until" default="12/31/2021">
	
	</cfif>
	--->
	
	<tr><td colspan="2">
	<table style="width:99%" align="right" class="navigation_table">
	
	<tr class="labelmedium2 fixrow"><td colspan="2" style="background-color:white;height:40px;font-size:23px;font-weight:bold"><cf_tl id="Recruitment Tracks"></td></tr>
		
	<tr class="labelmedium2 line fixlengthlist">
	   <td style="padding-left:3px"><cf_tl id="Type"></td>
	   <td><cf_tl id="Number"></td>
	   <td><cf_tl id="Reference"></td>
	   <td><cf_tl id="Posting Effective"></td>
	   <td><cf_tl id="Posting Expiration"></td> 
	   <!---
	   <td><cf_tl id="Due"></td>		  
	   --->
	   <td><cf_tl id="Vacant since"></td>  <!--- also show days --->
	   <td><cf_tl id="Vacant until"></td>  <!--- if there is a LIEN assignment to this position --->  						  										  
	</tr>

	<cfoutput query="getTracks">
		
		<tr class="labelmedium2 navigation_row line fixlengthlist" style="height:30px">
		   <td style="padding-left:3px">#EntityClassName#</td>
		   <td><a href="javascript:showdocument('#DocumentNo#')" title="TrackNo">#DocumentNo#</a></td>
		   <td>#ReferenceNo#</a></td>
		   <cfif dateEffective gte "01/01/2000">
		   <td>#dateformat(DateEffective,client.dateformatshow)#</td>
		   <cfelse>
		   <td>-</td>
		   </cfif>
		   <cfif dateExpiration gte "01/01/2000">
		   <td>#dateformat(DateExpiration,client.dateformatshow)#</td>   
		   <cfelse>
		   <td>-</td>
		   </cfif>
		   <!---
		   <td>#dateformat(DueDate,client.dateformatshow)#</td>  
		   --->
		   <cfif Status eq "0">
		   <cfif getLast.DateExpiration neq "">
		   <td style="background-color:##ffffaf80">#dateformat(getLast.DateExpiration,client.dateformatshow)# = #dateDiff('D','#getLast.DateExpiration#','#now()#')# <cf_tl id="days"></td>
		   <cfelse>
		   <td style="background-color:##ffffaf80"></td>		  
		   </cfif>
		   
		   <td style="background-color:##ffffaf80">#dateformat(until,client.dateformatshow)#</td>
		   <cfelse>
		   <td colspan="2"><cf_tl id="Completed"></td>
		   </cfif>   
		</tr>
		
		<cfif remarks neq "">
			<tr class="labelmedium2 navigation_row_child">
			   <td></td>
		   	   <td style="background-color:f1f1f1" colspan="6">#Remarks#</td>  
		    </tr>
		</cfif>
		
		<!--- show selected, onboarded candidates --->
		
		<cfquery name="candidates" 
			datasource="AppsVacancy" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT   DocumentNo, PersonNo, LastName, FirstName, PositionNo, Status
     		FROM     DocumentCandidate
            WHERE    Status IN ('2s', '3') 
			AND      DocumentNo = '#documentNo#'
		</cfquery>	
		
		<cfif candidates.recordcount gte "1">
		   <tr class="labelmedium2 navigation_row_child">
			   <td></td>
		   	   <td style="background-color:f1f1f1;padding-left:4px" colspan="6">
			   <cfloop query="candidates"><a href="javascript:showdocumentcandidate('#DocumentNo#','#PersonNo#')">#LastName#, #FirstName# <cfif status eq "3">[<cf_tl id="onboarded">]</cfif></a>&nbsp;|&nbsp;</cfloop>
			   </td>  
		    </tr>
		
		</cfif>
		
	
	</cfoutput>
	
	</table>
	</td></tr>

	<tr><td colspan="2">
		<table style="width:99%" align="right" class="navigation_table">
		
		<tr class="labelmedium2 fixrow"><td colspan="2" style="background-color:white;height:40px;font-size:23px;font-weight:bold"><cf_tl id="Lien holder"></td></tr>
			
		<tr class="labelmedium2 line fixlengthlist">
		   <td><cf_tl id="Name"></td>
		   <td><cf_tl id="IndexNo"></td>
		   <td><cf_tl id="Nat"></td>
		   <td><cf_tl id="G"></td> 
		   <td><cf_tl id="Level"></td>		  
		   <td><cf_tl id="Country group"></td>
		   <td><cf_tl id="Appointment"></td>
		   <td><cf_tl id="Start"></td>
		   <td><cf_tl id="End"></td>
		   <td><cf_tl id="Assignment"></td>		 		  										  
		</tr>
	
		<cfif source eq "hub">
		
			<cfquery name="getAssignment" 
				datasource="hubEnterprise" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#"> 
			
			       SELECT     newId() as Id,
				              PA.Indexno as PersonNo, 
				              PA.IndexNo, 
							  Pe.LastName, 
							  Pe.MiddleName, 
							  Pe.FirstName, 
							  Pe.Gender, 
							  Pe.NationalityCode as Nationality,
							  
							  (  SELECT ISNULL(PresentationLevel1,Continent)
						         FROM Ref_Country
							     WHERE Code = Pe.NationalityCode) as CountryGroup,
								 
							  (  SELECT   TOP 1 PC.Grade
			                   FROM     PersonGrade AS PC 
			                   WHERE    PC.Indexno = PA.IndexNo 
							   AND      PC.TransactionStatus = '1'
							   AND      PC.DateEffective <= PA.DateExpiration
							   ORDER BY PC.DateEffective DESC ) as ContractLevel,
						  				  
						   
						    (  SELECT   TOP 1 S.ContractStatusDescription
			                   FROM     PersonAppointment AS PC INNER JOIN	                           
			                            Ref_ContractStatus AS S ON PC.ContractStatus = S.ContractStatus
			                   WHERE    PC.IndexNo = PA.IndexNo 
							   AND      PC.TransactionStatus = '1' 
							   AND      PC.DateEffective <= PA.DateExpiration
							   ORDER BY PC.DateEffective DESC ) AS AppointmentStatus,
							  
							  PA.DateEffective  AS DateEffective, 
							  PA.DateExpiration AS DateExpiration,
							   
							  P.PositionId, 
				              'Owner'           AS Modality, 
							  O.OrgUnitNameShort, 
							  PA.OrgUnitId      AS orgUnit, 							
							  P.PositionType, 
							  PA.AssignmentType as AssignmentClass,
							  R.PostTypeName, 
							  P.PositionGrade,
							  '' as Remarks							  
							  
                    FROM      PersonAssignment AS PA INNER JOIN
                              Position AS P ON PA.PositionId = P.PositionId INNER JOIN
                              Ref_PostType AS R ON P.PositionType = R.PostType INNER JOIN
                              Person AS Pe ON PA.IndexNo = Pe.IndexNo INNER JOIN
                              Organization AS O ON PA.OrgUnitId = O.OrgUnitId
							  
                    WHERE     PA.PositionId        = '#Position.SourcePostNumber#'
					AND       PA.AssignmentType    = 'LI' 						
					AND       PA.TransactionStatus = '1' 
					AND       PA.DateEffective >= '#Position.DateEffective#'
					ORDER BY  PA.DateEffective
					
			</cfquery>		
			
			<cfset prior  = "">
			<cfset person = "">
			<cfset eff  = "">
			
			<cfloop query="getAssignment">
									
			    <cfif DateEffective eq prior and PersonNo eq Person>			
			         <cfset getAssignment[ "DateEffective" ][ getAssignment.currentRow ] = "#eff#">	
				<cfelse>
					<cfset eff = dateEffective>	 						 				
				</cfif>
				
				<cfset prior = dateAdd("D",dateExpiration,1)> 
				<cfset person = personNo>
			
			</cfloop>
			
			<cfquery name="getAssignment" dbtype="query">
			
				SELECT *
				FROM getAssignment
				ORDER BY DateExpiration DESC
			
			</cfquery> 
			
			
			
		<cfelse>
		
			<cfquery name="getAssignment" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#"> 
			
				SELECT     P.PersonNo, P.IndexNo, P.LastName, P.FirstName, P.MiddleName, P.Gender, P.Nationality, 
				           PA.DateEffective, 
						   PA.DateExpiration, 
						   
						   (  SELECT ISNULL(CountryGroup,Continent)
						      FROM System.dbo.Ref_Nation
							  WHERE Code = P.Nationality) as CountryGroup,
						   
						    (  SELECT   TOP 1 PC.ContractLevel
			                   FROM     PersonContract AS PC 
			                   WHERE    PC.PersonNo = P.PersonNo 
							   AND      PC.ActionStatus <> '9' 
							   AND      PC.DateEffective <= PA.DateExpiration
							   ORDER BY PC.DateEffective DESC ) as ContractLevel,
						   
						    (  SELECT   TOP 1 R.Description
			                   FROM     PersonContract AS PC INNER JOIN
			                            Ref_ContractType AS R ON PC.ContractType = R.ContractType 
			                   WHERE    PC.PersonNo = P.PersonNo 
							   AND      PC.ActionStatus <> '9' 
							   AND      PC.DateEffective <= PA.DateExpiration
							   ORDER BY PC.DateEffective DESC ) AS ContractTypeName,
						   
						    (  SELECT   TOP 1 S.Description
			                   FROM     PersonContract AS PC INNER JOIN	                           
			                            Ref_AppointmentStatus AS S ON PC.AppointmentStatus = S.Code
			                   WHERE    PC.PersonNo = P.PersonNo 
							   AND      PC.ActionStatus <> '9' 
							   AND      PC.DateEffective <= PA.DateExpiration
							   ORDER BY PC.DateEffective DESC ) AS AppointmentStatus,				   			   
						   
						   PA.FunctionNo, 
						   PA.FunctionDescription, 
						   PA.AssignmentClass, 
						   PA.Incumbency, 
						   PA.Source, 
		                   PA.SourceId,
						   PA.Remarks
		        FROM       PersonAssignment AS PA INNER JOIN
		                   Person AS P ON PA.PersonNo = P.PersonNo
		        WHERE      PositionNo IN (SELECT PositionNo FROM Position WHERE PositionParentId = '#Position.PositionParentId#') 
				AND        PA.AssignmentStatus IN ('0', '1') 
				AND        PA.AssignmentType  = 'Actual' 	
				AND        PA.DateEffective >= '#Position.DateEffective#'	
				AND        PA.Incumbency = 0
				ORDER BY DateEffective DESC
			
			</cfquery>
		
		</cfif>	
			
		<cfif getAssignment.recordcount eq "0">
			
				<tr class="labelmedium2 line">
				   <td colspan="10" align="center"><cf_tl id="There are no records to show in this view"></td>
				 </tr>
			
		<cfelse>
			
				<cfoutput query="getAssignment" group="DateEffective">
				    <cfoutput group="PersonNo">
					<tr class="labelmedium2 line navigation_row fixlengthlist">
					    <td style="padding-left:4px">#LastName#, #FirstName#</td>
					    <td><a href="javascript:EditPerson('#PersonNo#','#IndexNo#')">#IndexNo#</a></td>
					    <td>#Nationality#</td>
					    <td>#Gender#</td> 
					    <td>#ContractLevel#</td>		  
					    <td>#CountryGroup#</td>
					    <td>#AppointmentStatus#</td>
					    <td>#DateFormat(DateEffective,client.dateformatshow)#</td>
					    <td>#DateFormat(DateExpiration,client.dateformatshow)#</td>
					    <td>#AssignmentClass#</td>		 		  										  
				    </tr>
					<cfif remarks neq "">
					<tr class="labelmedium2 line"><td style="padding-left:4px;background-color:f1f1f1" colspan="10">#Remarks#</td></tr>
					</cfif>
					</cfoutput>
				</cfoutput>
			
		</cfif>	
		
		<tr class="labelmedium2 fixrow"><td colspan="2" style="background-color:white;height:40px;font-size:23px;font-weight:bold"><cf_tl id="Post users"></td></tr>	
				
		<tr class="labelmedium2 line fixlengthlist">
		   <td><cf_tl id="Name"></td>
		   <td><cf_tl id="IndexNo"></td>
		   <td><cf_tl id="Nat"></td>
		   <td><cf_tl id="G"></td> 
		   <td><cf_tl id="Level"> | <cf_tl id="SPA"></td>		  
		   <td><cf_tl id="Country group"></td>
		   <td><cf_tl id="Appointment"></td>
		   <td><cf_tl id="Start"></td>
		   <td><cf_tl id="End"></td>
		   <td><cf_tl id="Assignment"></td>		 		  										  
		</tr>
			
		<cfif source eq "hub">
		
			<cfquery name="getAssignment" 
				datasource="hubEnterprise" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#"> 
			
			       SELECT     PA.Indexno as PersonNo, PA.IndexNo, 
							  Pe.LastName, 
							  Pe.MiddleName, 
							  Pe.FirstName, 
							  Pe.Gender, 
							  Pe.NationalityCode as Nationality,
							  
							  (  SELECT ISNULL(PresentationLevel1,Continent)
						         FROM Ref_Country
							     WHERE Code = Pe.NationalityCode) as CountryGroup,
								 
							  (  SELECT   TOP 1 PC.Grade
			                   FROM     PersonGrade AS PC 
			                   WHERE    PC.Indexno = PA.IndexNo 
							   AND      PC.TransactionStatus = '1'
							   AND      PC.DateEffective <= PA.DateExpiration
							   ORDER BY PC.DateEffective DESC ) as ContractLevel,
						  				  
						   
						    (  SELECT   TOP 1 S.ContractStatusDescription
			                   FROM     PersonAppointment AS PC INNER JOIN	                           
			                            Ref_ContractStatus AS S ON PC.ContractStatus = S.ContractStatus
			                   WHERE    PC.IndexNo = PA.IndexNo 
							   AND      PC.TransactionStatus = '1' 
							   AND      PC.DateEffective <= PA.DateExpiration
							   ORDER BY PC.DateEffective DESC ) AS AppointmentStatus,
							  
							  PA.DateEffective  AS DateEffective, 
							  PA.DateExpiration AS DateExpiration,
							   
							  P.PositionId, 
				              'Owner'           AS Modality, 
							  O.OrgUnitNameShort, 
							  PA.OrgUnitId      AS orgUnit, 							
							  P.PositionType, 
							  PA.AssignmentType as AssignmentClass,
							  R.PostTypeName, 
							  P.PositionGrade,
							  '' as Remarks							  
							  
                    FROM      PersonAssignment AS PA INNER JOIN
                              Position AS P ON PA.PositionId = P.PositionId INNER JOIN
                              Ref_PostType AS R ON P.PositionType = R.PostType INNER JOIN
                              Person AS Pe ON PA.IndexNo = Pe.IndexNo INNER JOIN
                              Organization AS O ON PA.OrgUnitId = O.OrgUnitId
							  
                    WHERE     PA.PositionId        = '#Position.SourcePostNumber#'
					AND       PA.AssignmentType    != 'LI' 						
					AND       PA.TransactionStatus = '1' 
					AND       PA.DateEffective >= '#Position.DateEffective#'
					ORDER BY PA.DateEffective DESC
					
			</cfquery>		
	
		<cfelse>
		
			<cfquery name="getAssignment" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#"> 
			
				SELECT     P.PersonNo, P.IndexNo, P.LastName, P.FirstName, P.MiddleName, P.Gender, P.Nationality, 
				           PA.DateEffective, 
						   PA.DateExpiration, 
						   
						     (  SELECT ISNULL(CountryGroup,Continent)
						      FROM System.dbo.Ref_Nation
							  WHERE Code = P.Nationality) as CountryGroup,
						   
						    (  SELECT   TOP 1 PC.ContractLevel AS ContractLevel
			                   FROM     PersonContract AS PC 
			                   WHERE    PC.PersonNo = P.PersonNo 
							   AND      PC.ActionStatus <> '9' 
							   AND      PC.DateEffective <= PA.DateExpiration
							   ORDER BY PC.DateEffective DESC ) as ContractLevel,
						   
						    (  SELECT   TOP 1R.Description
			                   FROM     PersonContract AS PC INNER JOIN
			                            Ref_ContractType AS R ON PC.ContractType = R.ContractType 
			                   WHERE    PC.PersonNo = P.PersonNo 
							   AND      PC.ActionStatus <> '9' 
							   AND      PC.DateEffective <= PA.DateExpiration
							   ORDER BY PC.DateEffective DESC ) AS ContractTypeName,
						   
						    (  SELECT   TOP 1 S.Description
			                   FROM     PersonContract AS PC INNER JOIN	                           
			                            Ref_AppointmentStatus AS S ON PC.AppointmentStatus = S.Code
			                   WHERE    PC.PersonNo = P.PersonNo 
							   AND      PC.ActionStatus <> '9' 
							   AND      PC.DateEffective <= PA.DateExpiration
							   ORDER BY PC.DateEffective DESC ) AS AppointmentStatus,				   			   
						   
						   PA.FunctionNo, 
						   PA.FunctionDescription, 
						   PA.AssignmentClass, 
						   PA.Incumbency, 
						   PA.Source, 
		                   PA.SourceId,
						   PA.Remarks
		        FROM       PersonAssignment AS PA INNER JOIN
		                   Person AS P ON PA.PersonNo = P.PersonNo
		        WHERE      PositionNo IN (SELECT PositionNo FROM Position WHERE PositionParentId = '#Position.PositionParentId#') 
				AND        PA.AssignmentStatus IN ('0', '1') 
				AND        PA.AssignmentType  = 'Actual' 		
				AND        PA.Incumbency > 0
				AND        PA.DateEffective >= '#Position.DateEffective#'
				ORDER BY DateEffective DESC
			
			</cfquery>
			
			</cfif>
			
			<cfif getAssignment.recordcount eq "0">
			
				<tr class="labelmedium2 line">
				   <td colspan="10" align="center"><cf_tl id="There are no records to show in this view"></td>
				 </tr>
			
			<cfelse>
						  			
				<cfoutput query="getAssignment">
				
					<tr class="labelmedium2 line navigation_row fixlengthlist">
					    <td style="padding-left:4px">#LastName#, #FirstName#</td>
					    <td><a href="javascript:EditPerson('#PersonNo#','#IndexNo#')">#IndexNo#</a></td>
					    <td>#Nationality#</td>
					    <td>#Gender#</td> 
					    <td>#ContractLevel#</td>		  
					    <td>#CountryGroup#</td>
					    <td>#AppointmentStatus#</td>
					    <td>#DateFormat(DateEffective,client.dateformatshow)#</td>
					    <td>#DateFormat(DateExpiration,client.dateformatshow)#</td>
					    <td>#AssignmentClass#</td>		 		  										  
				    </tr>
					<cfif remarks neq "">
					<tr class="labelmedium2 line"><td style="padding-left:4px;background-color:f1f1f1" colspan="10">#Remarks#</td></tr>
					</cfif>
					
				</cfoutput>
			
			</cfif>
				
	</table>
	
	</td>
	</tr>

</table>

</cf_divscroll>

<cfset ajaxOnLoad("doHighlight")>