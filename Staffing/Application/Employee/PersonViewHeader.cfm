<!--
    Copyright © 2025 Promisan B.V.

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
<!--- 6/5/2016, it appears that this is already loaded, check with Dev if you are going to restore it
<cf_screentop html="No" jQuery="Yes">
--->

<!---Hidden dialog until Photo is clicked --->
<div id="picturedialog"></div>	

<cf_dialogstaffing>
<cf_systemscript>

<cfparam name="url.mode"     default="person">
<cfparam name="url.header"   default="1">
<cfparam name="url.refer"    default="Backoffice">
<cfparam name="url.scope"    default="#url.refer#">
<cfparam name="ctr"          default="1"> 
<cfparam name="URL.ID"       default="">
<cfparam name="URL.ID1"      default="">

<cfquery name="Param" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
     SELECT * 
     FROM   Parameter
</cfquery>

<cfoutput>

	<script>
		
		function reload() { 
		    opener.location.reload();
		    window.close();
		}
			
	</script>

</cfoutput>

<cfinvoke component = "Service.Access" 
  	method          = "employee" 
	personno        = "#URL.ID#" 
	returnvariable  = "Officer">

<cfinvoke component = "Service.AccessGlobal"
    Method          = "global"
    Role            = "HRManager"
    ReturnVariable  = "Manager">	
  
<!--- check access as bypass for showing the screen 19/3/2009 --->

<cfquery name="Access" 
    datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   TOP 1 A.AccessId
	FROM     Ref_AuthorizationRole R INNER JOIN
	         OrganizationAuthorization A ON R.Role = A.Role
	WHERE    R.SystemFunction in ('Staffing' ,'Attendance')
	AND      A.UserAccount = '#SESSION.acc#'
</cfquery> 

<cfif Officer eq "READ" or Officer eq "EDIT" or Officer eq "ALL" or Manager eq "ALL" 
	 or Access.Recordcount eq "1"
	 or CLIENT.PersonNo eq TRIM(URL.ID)
	 or url.mode eq "workflow">         
      
      <cfquery name="Employee" 
	    datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
             SELECT *
             FROM   Person
             WHERE  PersonNo = '#URL.ID#'
      </cfquery>      
      	
      <cfif Employee.recordcount eq "0">         
         
         <cfquery name="Employee" 
		     datasource="AppsEmployee" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
               	SELECT *
                FROM   Person
                WHERE  PersonNo = '#URL.ID1#'
         </cfquery>      	
         	            
         <cfif Employee.recordcount eq "0">                      
            	
            <cfquery name  = "Employee" 
			     datasource= "AppsEmployee" 
				 username  = "#SESSION.login#" 
				 password  = "#SESSION.dbpw#">               
	               	SELECT TOP 1*
               	    FROM   Person
               	    WHERE  IndexNo = '#URL.ID#'
            </cfquery>
                	            	            
            <cfset URL.ID = "#Employee.PersonNo#">
	
         </cfif>         
         
      </cfif>     
	        	
      <cfquery name="LastGrade" 
	     datasource="AppsEmployee" 		
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">         
         SELECT   TOP 1 *
         FROM     PersonContract
         WHERE    PersonNo = '#URL.ID#'
		 AND      ActionStatus != '9'
         ORDER BY DateEffective DESC
      </cfquery>      	
      
      <cfquery name="LastContract" 
	     datasource="AppsEmployee" 
		 maxrows="1" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">         
         SELECT   *
         FROM     PersonContract
         WHERE    PersonNo = '#URL.ID#'
     	 AND      ActionStatus != '9'
         ORDER BY DateEffective DESC
      </cfquery>
	  		        	      
      <cfquery name="Nationality" 
	      datasource="AppsSystem" 
		  maxrows="1" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
             SELECT * 
			 FROM   Ref_Nation
             WHERE  Code = '#Employee.Nationality#'
      </cfquery>   	   			

       <table width="98%" align="center">   
	                              
			   <tr class="line">   
                  <td valign="top" style="padding:4px;border-right:0px solid silver"> 
				  
				  	<!--- left cell --->  
				  
                     <table width="100%">   
					 
                        <cfoutput query="Employee">
                           
                           <tr class="fixlengthlist">   
						   						                             							  
							  <cfif employee.indexNo neq "">
							  
							   <td class="labelit" style="padding-top:1px"><font color="808080">#client.indexNoName#:</td>   
                               <td class="labelmedium fixlength" style="height:20px;font-size:14px" colspan="1">
							   <cfif url.refer eq "backoffice" or url.refer eq "workflow">
							   #Employee.IndexNo#
							   <cfelse>
							   <a href="javascript:EditPerson('#Employee.PersonNo#')">#Employee.IndexNo#</a>
							   </cfif>
							  
							  <cfelse>
							  
							   <td class="labelit" style="padding-top:1px" width="20%"><font color="808080"><cf_tl id="ExternalReference">:</td>   
                               <td class="labelmedium" style="height:20px;font-size:16px" colspan="1">#Employee.Reference#
							  							  
							  </cfif>							  
							 							  						  
							   <cfinvoke component="Service.Access" 
							         method="contract" 
									 personno="#URL.ID#" 
									 incumbency="100"
									 returnvariable="access100">
								 
							   <cfinvoke component="Service.Access" 
							         method="contract" 
									 personno="#URL.ID#" 
									 incumbency="0"
									 returnvariable="access000">
																 
		                           <cfif (access100 eq "EDIT" or access100 eq "ALL" or access000 eq "EDIT" or access000 eq "ALL") and url.refer neq "workflow">
        	                       	  <cfoutput>
        	                       	  	<span class="clsNoPrint">&nbsp;[<a href="javascript:personedit(<cfoutput>'#PersonNo#'</cfoutput>);" style="color:0080C0;"><cf_tl id="Edit"></a>]</span>
	                    	 	      </cfoutput>
                           			</cfif>
									
                              </td>   
                              <input type="hidden" name="person" value="#Employee.PersonNo#" id="personedit" onclick="personrefresh('#Employee.PersonNo#')">
                           </tr>   			
                         
                           <tr class="fixlengthlist">   
                              <td class="labelit" style="padding-top:1px"><font color="808080">
							  <cf_tl id="Name">:
							  <cf_space spaces="20">
							  </td>   
                              <td class="labelmedium fixlength" style="height:20px;font-size:14px">#Employee.FullName#</td>   
                           </tr>   
                         
                           <tr class="fixlengthlist">   
                              <td class="labelit" style="padding-top:1px"><font color="808080"><cf_tl id="Gender">:</td>   
                              <td class="labelmedium" style="height:20px"><cfif Employee.Gender eq "M"><cf_tl id="Male"><cfelse><cf_tl id="Female"></cfif></td>   
                           </tr>   
						                             
                           <cfif access100 eq "EDIT" or access100 eq "ALL" or access000 eq "EDIT" or access000 eq "ALL" or url.mode eq "workflow">                              
        	                                            
                           <tr class="fixlengthlist">    
                              <td class="labelit" style="padding-top:1px"><font color="808080"><cf_tl id="DOB">:</td>   
                              <td class="labelmedium" style="height:20px;font-size:14px">#Dateformat(Employee.BirthDate, CLIENT.DateFormatShow)# <cfif Employee.BirthDate neq "">(#datediff("yyyy",Employee.BirthDate,now())#)</cfif></td>   
                           </tr>   
                          
                           <tr class="fixlengthlist">   
                              <td class="labelit" style="padding-top:1px"><font color="808080"><cf_tl id="Nationality">:</td>   
                              <td>
							  <table>
							  <tr class="labelmedium" style="height:20px;font-size:14px">
							  <td>#Nationality.Name#</td>
							  							  
							  <cfquery name="Prior" 
						      datasource="AppsEmployee" 
							  maxrows="1" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
								  SELECT    EAS.ActionFieldValue, EA.ActionDate, System.dbo.Ref_Nation.Name
								  FROM      EmployeeActionSource AS EAS INNER JOIN
					                        EmployeeAction AS EA ON EAS.ActionDocumentNo = EA.ActionDocumentNo INNER JOIN
				                            System.dbo.Ref_Nation ON EAS.ActionFieldValue = System.dbo.Ref_Nation.Code
								  WHERE     EAS.PersonNo = '#Employee.PersonNo#' 
								  AND       EA.ActionCode = '1003'								 
								  AND       EAS.ActionStatus = '9'
								  ORDER BY  EAS.ActionDocumentNo DESC
							  </cfquery>
							  
							  <cfif Prior.recordcount gte "1">							  
								  <td style="padding-left:4px">(#Prior.Name# <i><cf_tl id="until">:</i> #dateformat(Prior.ActionDate,client.dateformatshow)#)</td>							  
							  </cfif>
							  
							  </tr>
							  </table>
							  </td>
							  
                           </tr>   
						   						   
						   <cfquery name="Recruitment" 
						      datasource="AppsSystem" 
							  maxrows="1" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
					             SELECT * 
								 FROM   Ref_Nation
					             WHERE  Code = '#Employee.RecruitmentCountry#'
					       </cfquery>      
						   
						   <cfif Recruitment.Name neq "">
						   
							   <tr class="fixlengthlist">   
	                              <td class="labelit" style="padding-top:1px"><font color="808080"><cf_tl id="Recruitment">:</td>   
	                              <td class="labelmedium" style="padding-left:3px;height:20px;font-size:14px">#Recruitment.Name# - #Employee.RecruitmentCity#</td>   
	                           </tr>   
						   
						   </cfif>
                         
						   <cfif lastgrade.contractlevel neq "">
                           <tr class="fixlengthlist">   
                              <td class="labelit" style="padding-top:1px"><font color="808080"><cf_tl id="Grade">:</td>   
                              <td class="labelmedium" style="padding-left:6px;height:20px;font-size:14px">#LastGrade.ContractLevel# / #LastGrade.ContractStep#</td>                              
                           </tr>  
						   </cfif>						   
						   						   
						   <cfif url.header eq "1">
						   
						   <tr class="fixlengthlist">
						   <td class="labelit" style="padding-top:1px"><font color="808080"><cf_tl id="EOD">:</td>   
           
                           <td class="labelmedium" style="height:20px;font-size:14px">     
						   
						       <cfquery name="Appointment" 
							      datasource="AppsEmployee" 		  
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								   SELECT    Mission
								   FROM      PersonContract
								   WHERE     PersonNo = '#URL.ID#'
								   AND       ActionStatus != '9'
								   GROUP BY  Mission
							    </cfquery>	 
						   
						        <cfif appointment.recordcount gte "1">	
								
									<table>
									
										<cfloop query="Appointment">
										    <tr>
											<td style="height:20px;font-size:12px">#mission#:</td>
											<td style="padding-left:7px;font-size:14px">										
											
											<cfinvoke component = "Service.Process.Employee.PersonnelAction"
											    Method          = "getEOD"
											    PersonNo        = "#url.id#"
												Mission         = "#mission#"
											    ReturnVariable  = "EOD">	
											
											#dateformat(EOD,client.dateformatshow)#
											
											</td>
											
											<!--- check if there is an assignment on the same date --->
											
											<cfquery name="Assignment" 
										      datasource="AppsEmployee" 		  
											  username="#SESSION.login#" 
											  password="#SESSION.dbpw#">
												SELECT     *
												FROM       PersonAssignment AS PA INNER JOIN
								                           Position AS P ON PA.PositionNo = P.PositionNo
												WHERE      PA.PersonNo      = '#url.id#'
												AND        P.Mission        = '#mission#' 
												AND        PA.AssignmentStatus IN ('0', '1') 
												AND        PA.DateEffective = '#dateformat(EOD,client.datesql)#'												
											</cfquery>
											
											<cfif Assignment.recordcount eq "0">
											
											<td style="padding-left:7px;font-size:14px;cursor:pointer;min-width:100px" title="No assignment started on the same date as the EOD">
											<font color="red"><u><cf_tl id="Attention">!</u>
											</td>
											
											</cfif>
											
											
											</tr>									
										</cfloop>	
										
									</table>	                            
																 
								</cfif>  
								
								<!---
								<cfoutput>5.#now()#</cfoutput>
								--->
                            
                           </td>   
						   
						   </tr>
						   
						   </cfif> 
						   
						   <tr class="fixlengthlist">
						   <td class="labelit" style="padding-top:1px" width="80"><font color="808080"><cf_tl id="Login">:</td>              
                           <td class="labelmedium" style="height:20px;padding-top:1px">    
						   
						   <cfquery name="User" 
						         datasource="AppsSystem" 			
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
					             SELECT   TOP 1 * 
								 FROM     UserNames
					             WHERE    PersonNo = '#URL.ID#'	
								 ORDER BY Disabled, DateExpiration DESC							 
					       </cfquery>		 	
						   
						   <cfif user.recordcount eq "0" and Employee.IndexNo neq "">
											       
							      <cfquery name="User" 
							         datasource="AppsSystem" 			
									 username="#SESSION.login#" 
									 password="#SESSION.dbpw#">
						             SELECT   TOP 1 * 
									 FROM     UserNames
						             WHERE    IndexNo = '#Employee.IndexNo#'
									 ORDER BY Disabled, DateExpiration DESC			
							      </cfquery>		                            
                                 													   
						   </cfif>	
						   						   
						   <cfif user.recordcount eq "0">
						   
						       --
						   
						   <cfelse>
						   	
							   <cfif user.disabled eq "1">
							   
							   	<font color="FF0000">
								
							   </cfif>
							   
							        <table>
									<tr class="labelmedium">
									<cfif user.mailserveraccount neq "">
									<td style="font-size:10px">ldap:</td>
									<td>#user.mailserveraccount#</td>
									</cfif>
									<cfif user.accountno neq "">
									<td style="font-size:10px">id:</td>
									<td>#user.accountno#</td>
									</cfif>
									<td style="font-size:10px">#SESSION.welcome#:</td>
									<td>#user.account#</td>
									</tr>
									
									</table>
							   						   								   
						   
						   </cfif>	                         
                             
                            
                           </td>   
						   </tr>

						  <cftry>
							      <cfquery name="qIndex" 
							         datasource="AppsSystem" 			
									 username="#SESSION.login#" 
									 password="#SESSION.dbpw#">
						             SELECT   * 
									 FROM     Employee.dbo.stIndexNo
						             WHERE    IndexNo != '#Employee.IndexNo#'
						             AND      PersonNo = '#URL.ID#'
							      </cfquery>	
						   
						   		  <cfif qIndex.recordcount neq 0>
								   <tr valign="top" class="fixlengthlist">
										<td class="labelit" style="padding-top:2px"><font color="6688aa"><cf_tl id="Alternate">:</td>
										<td class="labelmedium" style="padding-top:1px;height:20px">
											<cfset i = 0>
											<cfloop query="#qIndex#">
												<cfif i eq 0>
													#qIndex.IndexNo#
												<cfelse>
													, #qIndex.IndexNo#
												</cfif>
												
												<cfset i = i + 1>
												<cfif i MOD 2 eq 0>
													<br>
													<cfset i = 0>
												</cfif>	
											</cfloop>	
										</td>	 
								   </tr>
								  </cfif> 
						   <cfcatch>
						   		
						   </cfcatch>	
						   </cftry>						   
						   
						   
						   </cfif>
						   
						   </cfoutput>	
						 	   
						                                     	  
                     </table>   
   	  
   	              </td>   
				  
				  <!--- center cell --->
				     	 
                  <td valign="top" style="padding:4px">   				  
				  
   		    	 	<cfif url.scope eq "Backoffice">
					
                     <table width="100%">   
					 
					 	 <cfif employee.eMailaddress neq "">
					 	 <tr class="fixlengthlist">   
           
                              <td class="labelit"><font color="808080"><cf_tl id="Corporate mail">:</td>              
                              <td class="labelmedium" style="height:20px;font-size:14px">
                                 <cfoutput query="Employee">#eMailAddress#</cfoutput>
                             </td>   
           
                        </tr>   
						</cfif>   
					 
					 	 <tr class="fixlengthlist">   
           
                              <td class="labelit"><font color="808080"><cf_tl id="Parent Office">:</td>   
           
                              <td class="labelmedium" style="height:20px;font-size:14px">
							    <cfif Employee.ParentOffice eq "">--<cfelse>
                                 <cfoutput query="Employee">
								   #ParentOffice# #ParentOfficeLocation#
                                 </cfoutput>
								 </cfif>
                             </td>   
           
                        </tr>  					
						   		    		  	      	     	                              
                        <cfif Param.EnablePersonGroup neq "0">                           											
                         	   
                           <tr style="height:20px" class="fixlengthlist">   
           
                              <td class="labelit"><font color="808080"><cf_tl id="Marital Status">:</td>   
           
                              <td class="labelmedium" style="height:20px;font-size:14px">  
							  
							   <table>
							  <tr class="labelmedium">
							  <td>
							   							  
                                 <cfoutput query="Employee">
                                    #MaritalStatus#
                                 </cfoutput>
								 
								 </td>
								 
								 <cfquery name="Prior" 
							      datasource="AppsEmployee" 
								  maxrows="1" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								    SELECT     EAS.ActionFieldValue, EA.ActionDate
									FROM       EmployeeActionSource AS EAS INNER JOIN
									           EmployeeAction AS EA ON EAS.ActionDocumentNo = EA.ActionDocumentNo
									WHERE      EAS.PersonNo = '#Employee.PersonNo#' 
									AND        EAS.ActionStatus = '9' 
									AND        EA.ActionCode = '1005'
									ORDER BY   EAS.ActionDocumentNo DESC							  
								  </cfquery>
							  
							    <cfif Prior.recordcount gte "1">	
								   	<cfoutput>
									  	<td style="padding-left:4px">(#Prior.ActionFieldValue# <i><cf_tl id="until">:</i> #dateformat(Prior.ActionDate,client.dateformatshow)#)</td>							  
									</cfoutput>
							    </cfif>
							  
							  </tr>
							  </table>
							  </td>								
   	   
                           </tr>                             	  	                    
						     	       		
                        <cfelse>
			
                           <cfquery name="Group" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
                              
                              			SELECT    R.Description AS Value, 
                              			          RG.Description AS Topic,
												  RG.ActionCode
                              			FROM      PersonGroup PG INNER JOIN
                              	                  Ref_PersonGroupList R ON PG.GroupCode = R.GroupCode AND PG.GroupListCode = R.GroupListCode INNER JOIN
                              	                  Ref_PersonGroup RG ON R.GroupCode = RG.Code
                              			WHERE PG.PersonNo = '#URL.ID#'		
										
										<cfif getAdministrator("*") eq "0">
																				
										 AND   RG.Code IN (SELECT GroupCode 
										                FROM   Ref_PersonGroupRole						
														WHERE  Role IN (SELECT DISTINCT Role 
										                                FROM   Organization.dbo.OrganizationAuthorization
																		WHERE  UserAccount = '#SESSION.acc#')
														)	
																			
										 AND   RG.Code IN (SELECT GroupCode
										                FROM   Ref_PersonGroupOwner				
														WHERE  Owner IN (SELECT MissionOwner
														                 FROM   Organization.dbo.Ref_Mission
																		 WHERE  Mission IN (SELECT DISTINCT P.Mission 
																		                    FROM   PersonAssignment PA, Position P 
																						    WHERE  PA.PositionNo = P.PositionNo
																						    AND    PA.PersonNo   = '#URL.ID#')
																		)
													  )									   
																						   
										 </cfif>	  
								                              			
                           </cfquery>
						   						                                			
                           <cfoutput query="group" maxrows=7>
                            			    
                              <tr class="fixlengthlist">   
                                 <td style="padding-top:1px" style="height:20px;font-size:14px" class="labelit fixlength"><font color="808080">#Topic#:</td>   
   	    	                     <td class="labelmedium" style="height:20px;font-size:14px">
								 
								 <table>
								  <tr class="labelmedium" style="height:20px;font-size:14px">
								  <td class="fixlength">#value#</td>
									 
									 <cfquery name="Prior" 
								      datasource="AppsEmployee" 
									  maxrows="1" 
									  username="#SESSION.login#" 
									  password="#SESSION.dbpw#">
										    SELECT     EAS.ActionFieldValue, EA.ActionDate
											FROM       EmployeeActionSource AS EAS INNER JOIN
											           EmployeeAction AS EA ON EAS.ActionDocumentNo = EA.ActionDocumentNo
											WHERE      EAS.PersonNo = '#Employee.PersonNo#' 
											AND        EAS.ActionStatus = '9' 
											AND        EA.ActionCode = '#ActionCode#'
											ORDER BY   EAS.ActionDocumentNo DESC							  
									 </cfquery>
								  
								   <cfif Prior.recordcount gte "1">							  
									  <td class="fixlength" style="padding-left:4px">(#Prior.ActionFieldValue# <i><cf_tl id="until">:</i> #dateformat(Prior.ActionDate,client.dateformatshow)#)</td>							  
								  </cfif>
								  
								  </tr>
								  </table>
								  </td>
									 
	                          </tr>   						   
    			
                           </cfoutput>
                        
   	                    </cfif>
                               
                     </table>   
					 
   	  				</cfif>
					
                  </td>   
				  
				  <!--- Contact cell --->			  
				  
				  <td valign="top" style="padding:4px;padding-right:10px">
				  				  
					<cfquery name="Address" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT   TOP 1 *
					    FROM     vwPersonAddress
						WHERE    PersonNo = '#URL.ID#'						 
						AND      AddressType = '#Param.AddressType#' 
						ORDER BY DateExpiration DESC
					</cfquery>
										
					<cfoutput query="Address">
					
					 <table width="100%" cellspacing="0" cellpadding="0"  border="0"> 
					 
					 <!---
					 <tr>
					 	<td style="padding-top:2px" class="labelit"><font color="808080"><cf_tl id="eMail">:</td>
						<td class="labelmedium" style="height:20px;font-size:14px">
						  <cfif Address.eMailAddress eq "">--<cfelse>
						   <a href="javascript:email('#address.eMailAddress#','','','','Person','#url.ID#')">#Address.eMailAddress#</a>
						 </cfif></td>
					 </tr>
					 --->		
						 
					 <cfquery name="ContactNo" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						   SELECT   TOP 6
									AT.Description,
									PAC.ContactCallSign as CallSign
							FROM	PersonAddress PA
									INNER JOIN PersonAddressContact PAC
										ON PA.PersonNo = PAC.PersonNo
										AND PA.AddressId = PAC.AddressId
									INNER JOIN Ref_Contact C
										ON PAC.ContactCode = C.Code
									INNER JOIN Ref_AddressType AT
										ON PA.AddressType = AT.AddressType
							WHERE	C.SelfService = 1
							AND		PA.PersonNo = '#url.ID#'
					 </cfquery>
				 
					 <cfloop query="ContactNo">					 
						 <tr style="height:20px" class="fixlengthlist">
						 	<td style="padding-top:1px" class="labelit"><font color="808080"><cf_tl id="#Description#">:</td>
							<td style="height:20px;font-size:14px" class="labelmedium"><cfif callsign eq "">-<cfelse>#CallSign#</cfif></td>
						 </tr>					 
					 </cfloop>					 
					
					 <tr style="height:20px" class="fixlengthlist">
					 	<td style="padding-top:1px" class="labelit"><font color="808080"><cf_tl id="Room">:</td>
						<td style="height:20px;font-size:14px" title="#Address.AddressRoom#" class="labelmedium"><cfif Address.AddressRoom eq "">--<cfelse>#Address.AddressRoom#</cfif></td>
					 </tr>		
					
					 <cfif access100 eq "EDIT" or access100 eq "ALL" or access000 eq "EDIT" or access000 eq "ALL" or url.mode eq "workflow">  
										 
						 <tr style="height:20px" class="fixlengthlist">
						 	<td style="padding-top:1px" class="labelit"><font color="808080"><cf_tl id="Address additional">:</td>
							<td style="height:20px;font-size:14px" title="#Address.Address2#" class="labelmedium"><cfif Address.Address2 eq "">--<cfelse>#Address.Address2#</cfif></td>
						 </tr>		
						 
					</cfif>
						 
					 <tr class="fixlengthlist">
					 	<td style="padding-top:1px" class="labelit"><font color="808080"><cf_tl id="Postal code">:</td>
						<td style="height:20px;font-size:14px" class="labelmedium">#Address.AddressPostalCode#</td>
					 </tr>	
										 
					 </table>
					 
					 </cfoutput>
				  
				  </td>
				  
				  <cfoutput query="Employee">
				  
				  <!--- ------------ --->
				  <!--- picture cell --->
				      	                       	  		
				  <cfif indexNo neq "">				  
				    <cfset nme = IndexNo>
				  <cfelseif reference neq "">
				    <cfset nme = Reference>	
				  <cfelse>
				  	<cfset nme = Personno>	
				  </cfif>	
				 				  
				  <!--- ------------ --->
				  <!--- picture cell --->
				  		 
				    	                       	  		
                  <td height="112" align="center" style="border:0;width:140px;padding:8px" valign="top" id="Pic"
				  onclick="$('##picturedialog').slideDown(300);ptoken.navigate('#session.root#/Portal/Photo/PhotoUpload.cfm?mode=staffing&fileName=#nme#','picturedialog')">   
				  				
				   <cfset url.PictureHeight = Param.PictureHeight>
				   <cfset url.PictureWidth  = Param.PictureWidth>
				   <!---
				   <cfset url.mode          = "Staffing">
				   --->
				   <cfset url.personNo      = PersonNo>
				   <cfset url.reference     = Reference>
				   <cfset url.indexNo       = IndexNo>
				   				   
   			       <cfinclude template="PersonPicture/PersonViewPicture.cfm">		           											        
				                     
				   <!---     <cfdiv id="divPictureCell" style="height:100%;min-height:100%" 
						bind="url:#session.root#/Staffing/Application/Employee/PersonPicture/PersonViewPicture.cfm?PersonNo=#PersonNo#&mode=staffing&indexNo=#indexNo#&reference=#reference#&PictureHeight=#Param.PictureHeight#&PictureWidth=#Param.PictureWidth#&scope=#url.scope#">  		                       
						--->
                        			 
                  </td>   
    	 
                  </cfoutput>
               	  
      </tr> 	  
	  	 	  
	 <cfif url.header eq "1" >
	  		
		 <cfif url.scope eq "BackOffice">
	     	<tr><td colspan="4" style="padding:4px">	 	 
			 	<cfinclude template="PersonViewHeaderContract.cfm">		   		   
		     	</td>
		 	</tr>
		 </cfif> 
	 
	 </cfif>
	 		  		  
   </table> 	
   
<cfelse>
 
	<cf_message message="You have not been granted access to this profile. Please contact your administrator." return="No">
	
	<cfabort>   
   
</cfif>