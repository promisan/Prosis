 <!--- show contract --->  
 
 <cfparam name="ass" default="1">
	  	 	 
 <cfquery name="OnBoard" 
 datasource="AppsEmployee"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT   P.*, PA.OrgUnit
	 FROM     PersonAssignment PA, Position P
	 WHERE    PersonNo           = '#URL.ID#'
	 AND      PA.PositionNo      = P.PositionNo
	 AND      PA.DateEffective   < getdate()
	 AND      PA.DateExpiration  > getDate()
	 AND      PA.AssignmentStatus IN ('0','1')
	 -- AND      PA.AssignmentClass = 'Regular' <!--- dropped --->
	 AND      PA.AssignmentType  = 'Actual'
	 AND      PA.Incumbency      = '100' 
 </cfquery>   	  
	
 <cfinvoke component="Service.Access"  
	     method="StaffingTable" 
	     mission="#OnBoard.Mission#" 
	     returnvariable="maintain">		 
  
 <!--- Query returning search results --->
 <cfquery name="Contract" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT TOP 1 L.*, 
           R.Description as ContractDescription, 
	       A.Description as AppointmentDescription
    FROM   PersonContract L, 
	       Ref_ContractType R,
		   Ref_AppointmentStatus A
	WHERE  L.PersonNo = '#URL.ID#'
	AND    L.ContractType = R.ContractType
	AND    L.AppointmentStatus = A.Code
	AND    L.ActionStatus != '9'
	ORDER BY L.DateEffective DESC
 </cfquery>	
 
<cfparam name="ctr" default="1">
				  
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		  			     	
	  <cfif ctr eq "1" and (maintain neq "NONE" or Access.Recordcount eq "1")>	 						   
				   					 
			 <cfif contract.recordcount neq "0">
			 
				 <TR class="line labelmedium fixlengthlist">
				   
				    <td height="17"><cf_tl id="Entity"></td>
				    <td height="17"><cf_tl id="Effective"></td>
					<TD><cf_tl id="Expiration"></TD>
					<TD><cf_tl id="Level"></TD>		
					<TD><cf_tl id="Type"></TD>																
					<TD><cf_tl id="Payroll"></TD>
					<TD><cf_tl id="Location"></TD>				   
					<TD><cf_tl id="Increase"></TD>													
				</TR>
							
			</cfif>					
		
			<cfoutput query="Contract">
			
				<TR class="labelmedium navigation_row fixlengthlist" style="height:20px">
				<td>#Mission#</td>
				<td height="20">
				
				<!--- if the leg is a step increase we show the orginal data as follows --->
				
				 <cfquery name="Start" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT     MIN(C.DateEffective) AS DateEffective
					FROM       EmployeeAction AS EA INNER JOIN
					           EmployeeActionSource AS EAS ON EA.ActionDocumentNo = EAS.ActionDocumentNo INNER JOIN
					           PersonContract AS C ON EAS.PersonNo = C.PersonNo AND EAS.ActionSourceId = C.ContractId
					WHERE      EA.ActionSourceId = '#contractid#' 
					AND        EAS.ActionStatus = '1' 
					AND        EA.ActionCode = '3004'
				</cfquery>
				
				<cfif start.DateEffective neq "">
					#Dateformat(Start.DateEffective, CLIENT.DateFormatShow)#
				<cfelse>
					#Dateformat(DateEffective, CLIENT.DateFormatShow)#					
				</cfif>
							
				
				</td>
				<td><cfif Contract.DateExpiration eq ""><cf_tl id="Permanent"><cfelse>#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</cfif></td>
				<TD>
				<cfif SalarySchedule eq "NoPay">
				<font color="800040"><cf_tl id="Unfunded"></font>
				<cfelse>
				#ContractLevel#/#ContractStep#<cfif contracttime neq "100">&nbsp;:&nbsp;#ContractTime#</cfif>
				</cfif>
				</TD>				
				<td>#ContractFunctionDescription#</td>									
				<TD>#SalarySchedule#</TD>
				<TD>
				
				<cftry>
		
						<cfquery name="Location" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  *   
							FROM       Ref_PayrollLocation
							WHERE      LocationCode = '#servicelocation#'					
					</cfquery>
				
						#Location.Description#
				
				<cfcatch>#servicelocation#</cfcatch>
				</cftry>
				
				</TD>				
				<td>#Dateformat(StepIncreaseDate, "MM/YYYY")#</td>					
				</TR>	
				
				<TR class="line labelmedium navigation_row_child fixlengthlist" style="height:20px">
					<td></td>					
					<td style="height:10px" colspan="3">#ContractDescription# <cfif ContractStatus eq "1">(Regularised)</cfif></TD>																									
					<td style="padding-right:4px" colspan="4">#AppointmentDescription#<cfif AppointmentStatusMemo neq "">&nbsp;<i>#AppointmentStatusMemo#</cfif></td>					
				</TR>			
				
			</cfoutput>						
		  
		  <cfif contract.recordcount eq "0">			  
			   <tr style="height:20px"  class="labelmedium">				
				 <td colspan="8">
				  <img style="float: left;margin-right: 5px;" align="absmiddle" src="<cfoutput>#SESSION.root#</cfoutput>/images/alert.png" alt="" border="0" width="20" height="20">
				  <font style="float: left;" color="FF8040"><cf_tl id="No contracts are recorded"></font>
                      <div style="height:20px;"></div>
				 </td>
			   </tr>				  
		  </cfif>
					  
		</cfif>	  
		
		<cfif ass eq "1">
						  	  
			<cfquery name="PersonAssignment" 
		    datasource="AppsEmployee" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    SELECT     TOP 1 A.*, 
				           P.MandateNo, 
						   P.Mission, 
						   P.SourcePostNumber, 
						   P.PositionParentId,
						   O.OrgUnitName, 
						   M.MissionOwner
			    FROM       PersonAssignment A, 
				           Position P,
				           Organization.dbo.Organization O, 
					       Organization.dbo.Ref_Mission M
				WHERE      A.OrgUnit = O.OrgUnit
				  AND      A.PersonNo = '#URL.ID#'
				  AND      M.Mission = O.Mission 
				  AND      A.PositionNo = P.PositionNo
				  AND      A.AssignmentStatus IN ('0','1')
				  AND      A.Incumbency > 0
				  AND      A.AssignmentType = 'Actual'
				  ORDER BY A.DateEffective DESC
		    </cfquery>

		    <cfif PersonAssignment.recordCount eq 0>
			    
		    	<cfquery name="PersonAssignment" 
			    datasource="AppsEmployee" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				    SELECT     TOP 1 A.*, 
					           P.MandateNo, 
							   P.Mission, 
							   P.SourcePostNumber, 
							   P.PositionParentId,
							   O.OrgUnitName, 
							   M.MissionOwner
				    FROM       PersonAssignment A, 
					           Position P,
					           Organization.dbo.Organization O, 
						       Organization.dbo.Ref_Mission M
					WHERE      A.OrgUnit = O.OrgUnit
					  AND      A.PersonNo = '#URL.ID#'
					  AND      M.Mission = O.Mission 
					  AND      A.PositionNo = P.PositionNo
					  AND      A.AssignmentStatus IN ('0','1')
					  AND      A.Incumbency = 0
					  AND      A.AssignmentType = 'Actual'
					  ORDER BY A.DateEffective DESC
			    </cfquery>

		    </cfif>
			
			<cfquery name="MandateRetrieve" 
		    datasource="AppsOrganization" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    SELECT  *
			    FROM    Ref_Mandate
				WHERE   Mission   = '#PersonAssignment.Mission#'
				  AND   MandateNo = '#PersonAssignment.MandateNo#'				
		    </cfquery>
							    
			<cfif PersonAssignment.DateExpiration gt Contract.DateExpiration and Contract.DateExpiration neq "" and PersonAssignment.DateExpiration lt now()>
			
				<cfoutput>
				<tr class="line" class="labelmedium" style="height:20px">				 
					  <td colspan="8">
					   <img align="absmiddle" src="#SESSION.root#/images/alert.png" alt="" border="0" width="20" height="20">
				        <font color="FF8040">
						Incumbency expiration (#dateformat(PersonAssignment.DateExpiration,CLIENT.DateFormatShow)#) exceeds the currently issued contract (#dateformat(Contract.DateExpiration,CLIENT.DateFormatShow)#). <b>Contract should be extended.</b>					  
					    </font>
				  </td>
				</tr>	
				</cfoutput>				
				
			<cfelse>	
			
			    <cfif PersonAssignment.recordcount eq "0">
				
					<cfoutput>
				    <tr class="line" class="labelmedium" style="height:20px">				      
					  <td colspan="8" height="22" >
					   <img align="absmiddle" width="20" height="20" src="#SESSION.root#/images/alert.png" alt="" border="0">
					  <font color="FF8040"><cf_tl id="No Post Assignment information found" class="Message"></font></td>
				   </tr>	
				   </cfoutput>
									
				<cfelse>
				
					<cfoutput>
								
						<tr class="labelmedium navigation_row line fixlengthlist">							  
						   <td style="padding-right:2px;padding-left:2px">#PersonAssignment.Mission#</td>
						   <td style="padding-right:2px" colspan="1">#dateformat(PersonAssignment.DateEffective,CLIENT.DateFormatShow)#</td>
						   <td style="padding-right:2px">
						   <cfif PersonAssignment.DateExpiration lt now()>
						   <b><font color="FF0000"><u>#dateformat(PersonAssignment.DateExpiration,CLIENT.DateFormatShow)#</font>
						   <cfelse>
						   #dateformat(PersonAssignment.DateExpiration,CLIENT.DateFormatShow)#
						   </cfif>
						   </td>
						   <td style="padding-right:2px" colspan="3" class="fixlength">
						  
						   <cfquery name="Parent" 
							    datasource="AppsOrganization" 
							    username="#SESSION.login#" 
							    password="#SESSION.dbpw#">
							    SELECT      *
								FROM        Organization
								WHERE       OrgUnit = '#PersonAssignment.OrgUnit#'
							</cfquery>
							
							<cfif Parent.HierarchyRootUnit neq "">
							
								 <cfquery name="getRoot" 
							    datasource="AppsOrganization" 
							    username="#SESSION.login#" 
							    password="#SESSION.dbpw#">
							    SELECT    *
								FROM      Organization
								WHERE     OrgUnitCode  = '#Parent.HierarchyRootUnit#'
								AND       Mission      = '#Parent.Mission#'
								AND       MandateNo    = '#Parent.MandateNo#'
								</cfquery>
							
								#getRoot.OrgUnitName# / 							
							
							</cfif>	
							
							
							
							<cfif Parent.ParentOrgUnit neq "">
							
								 <cfquery name="getParent" 
							    datasource="AppsOrganization" 
							    username="#SESSION.login#" 
							    password="#SESSION.dbpw#">
							    SELECT    *
								FROM      Organization
								WHERE     OrgUnitCode  = '#Parent.ParentOrgUnit#'
								AND       Mission      = '#Parent.Mission#'
								AND       MandateNo    = '#Parent.MandateNo#'
								</cfquery>
							
								<cfif getRoot.OrgUnit neq getParent.OrgUnit>
								#getParent.OrgUnitName# / 	
								</cfif>						
							
							</cfif>						   
						   
						   #PersonAssignment.OrgUnitName# / <font color="408080">#PersonAssignment.FunctionDescription#</font>
						   
						   </td>	
						   
						   <td>#PersonAssignment.AssignmentClass#</td>					   
						   <td style="padding-right:2px"><cfif PersonAssignment.sourcePostNumber neq ""><a href="javascript:EditPosition('','','#PersonAssignment.PositionNo#')">#PersonAssignment.SourcePostNumber#<cfelse>#PersonAssignment.PositionParentId#</cfif></a></td>
						  
					   </tr>
							  											
					   <cfif PersonAssignment.mission eq Contract.mission>
						
							<cfif PersonAssignment.DateExpiration neq Contract.DateExpiration 
							      and Contract.dateExpiration neq ""
								  and PersonAssignment.DateExpiration lt mandateRetrieve.DateExpiration>
							
								<tr style="height:20px">
									<td colspan="8" style="padding-top:4px;color:ff0000" align="center" class="labellarge fixlength">
									<b>Attention:</b> Incumbency expiration per #dateformat(PersonAssignment.DateExpiration,CLIENT.DateFormatShow)# is INCONSISTENT with Contract expiration per (#dateformat(Contract.DateExpiration,CLIENT.DateFormatShow)#)
									</td>
								</tr>
														
							</cfif>
							
						<cfelse>
						
							<cfif Contract.historiccontract eq "0">
					
							    <tr style="height:20px">
								<td colspan="8" style="padding-top:4px;color:ff0000" align="center" class="labellarge fixlength">
									Contract record does not match the organization of last Incumbency record								
								</td>
								</tr>
							
							</cfif>
						
						</cfif>				
						
					</cfoutput>
					
				</cfif>	
				
		</cfif>
		
	</cfif>		
			  
  </table>				  