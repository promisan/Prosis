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

<cfquery name="Param" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_ParameterMission
		WHERE   Mission   = '#url.id2#'		
</cfquery>	

<cfparam name="hunit" default="">

<cftransaction isolation="READ_UNCOMMITTED">

<cfif URL.ID neq "BOR"> <!--- regular --->

	<!--- URL.ID4 = mission operational, is where the post is used in a different entity/mission --->
		
	<cfquery name="PostShow" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT   DISTINCT 
		         Org.Mission           as OrganizationMission,
				 Org.MandateNo         as OrganizationMandate,
				 Org.OrgUnit           as OrganizationOrgUnit, 
		         Org.OrgUnitName       as OrganizationOrgUnitName,
				 Org.OrgUnitCode       as OrganizationOrgUnitCode, 
				 Org.HierarchyCode     as OrganizationHierarchyCode,				  
				 Org.DateExpiration    as OrgExpiration,
				 
				 P.*, 
			   	 PP.FunctionDescription as ParentFunctionDescription,
		         PP.OrgUnitOperational  as ParentOrgUnit, 
				 Ass.*,
				 R.PresentationColor,
					  
			     (SELECT count(*) 
				  FROM   Employee.dbo.PositionGroup
				  WHERE  PositionNo = P.PositionNo 
				  AND    Status != '9') as PositionGroup
				 
		FROM     userQuery.dbo.#SESSION.acc#Post#FileNo# P 
		         INNER JOIN Employee.dbo.PositionParent PP ON P.PositionParentId = PP.PositionParentId 
				 INNER JOIN Employee.dbo.Ref_PostClass R  ON P.PostClass        = R.PostClass 
				 INNER JOIN  Organization Org ON  
				 
				 <!--- URL.ID4 is the other mission if this is an intermission loan we make this different and connect to P.OrgUnit = --->	            
				 <cfif URL.ID4 neq ""> P.OrgUnit 
				 <cfelse> (CASE WHEN P.MissionOperational = P.Mission THEN P.OrgUnitOperational ELSE PP.OrgUnitOperational END)  
				 </cfif> = Org.OrgUnit 
				 LEFT OUTER JOIN userQuery.dbo.#SESSION.acc#Assignment#FileNo# Ass ON P.PositionNo = Ass.PositionNo		 
				 
		WHERE    P.HierarchyCode >= '#HStart#' 
		     AND P.HierarchyCode < '#HEnd#'				
			 <cfif URL.ID neq "ORG" and URL.ID4 eq "">
			 AND Org.OrgUnit IN (SELECT OrgUnit 
			                     FROM   userQuery.dbo.#SESSION.acc#PositionSum#FileNo# 
								 WHERE  Post > 0 or Staff > 0
								)	
			 </cfif>						 
		ORDER BY Org.Mission, Org.MandateNo, P.HierarchyCode, P.ViewOrder, P.PostOrder, P.PositionNo  
			
		
	</cfquery>		
	
	<!--- alert I change <cfif URL.ID4 eq ""> into <cfif URL.ID4 neq ""> on 11/12 as Aung reported that load positions were not shown --->
		
<cfelse>

	<!--- combine position and assignment --->
		
	<cfquery name="PostShow" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT    DISTINCT P.*, 
		        Ass.*,
				
			   (SELECT PresentationColor 
			    FROM Employee.dbo.Ref_PostClass 
				WHERE PostClass = P.PostClass) as PresentationColor,			
		  
			   (SELECT count(*) 
				FROM   Employee.dbo.PositionGroup
				WHERE  PositionNo = P.PositionNo  AND Status != '9' ) as PositionGroup
				
	  FROM      dbo.#SESSION.acc#Post#FileNo# P LEFT OUTER JOIN 
			    dbo.#SESSION.acc#Assignment#FileNo# Ass ON Ass.PositionNo = P.PositionNo				
		WHERE   P.Mission   = '#URL.Mission#'
		AND     P.MandateNo = '#URL.Mandate#'				
	 ORDER BY   P.HierarchyCode, P.ViewOrder, P.PostOrder, P.PositionNo 
	 	 
	</cfquery>
	
	
</cfif>

</cftransaction>

<cfif getAdministrator(url.mission) eq "0">
	
	<cfquery name="PostType"
	     dbtype="query">
			SELECT DISTINCT PostType
			FROM   PostShow		 
	</cfquery>
	
	<cfloop query="PostType">
		
		<cfinvoke component = "Service.Access"  
		    method          = "staffing" 
		    mission         = "#URL.Mission#" 
		    posttype        = "#PostType#"
		    returnvariable  = "accessStaffing#PostType#"> 
			
		<cfinvoke component = "Service.Access"  
		    method          = "position" 
		    mission         = "#URL.Mission#" 
		    posttype        = "#PostType#"
		    returnvariable  = "accessPosition#PostType#"> 	
		
	</cfloop>	

</cfif>

<cfif URL.ID eq "ORG">
   <cfset cond = CondA>
</cfif>

<table width="99.5%"> 

<cfif PostShow.recordcount eq "0">

	<tr><td colspan="7" style="padding-top:5px" height="46" align="center" class="labelmedium2">There are no records to show in this view</td></tr>

</cfif>

<cfoutput query="PostShow" group="OrganizationMission">

<cfoutput group="HierarchyCode">

     <cfset org  = OrgUnit>   
                
	 <cfif currentRow eq "1">
	 
		 	<cfif URL.Lay eq "Listing">
		   
			   <tr class="line labelmedium fixrow" style="background-color:efefef">
			   <td colspan="8" class="clsPrintContent">
				    <table width="100%">
					<tr class="labelmedium">			
					    <td style="padding-left:100px"></td>
						<td style="min-width:70px"><cf_tl id="Grade"></td>
						<td style="min-width:290px"><cf_tl id="Function"></td>
						<td style="min-width:70px"><cf_tl id="PostNo"></td>
						<td style="min-width:75px"><cf_tl id="Duty"></td>
						<td style="min-width:50px"><cf_tl id="G"></td>
						<td style="width:100%"><cf_tl id="Incumbent"></td>
						<td style="min-width:85px"><cf_UIToolTip  tooltip="Contract Grade and Step"><cf_tl id="Contract"></cf_UIToolTip></td>
						<td style="min-width:85px"><cf_tl id="SPA"></td>
						<td style="min-width:100px"><cf_tl id="IndexNo"></td>
						<td style="min-width:45px"><cf_UIToolTip  tooltip="Gender"><cf_tl id="G"></cf_UIToolTip></td>
						<td style="min-width:40px"><cf_UIToolTip  tooltip="Current Nationality"><cf_tl id="Nat"></cf_UIToolTip></td>
						<td style="min-width:60px"><cf_UIToolTip  tooltip="Percentage of post incumbency"><cf_tl id="Percent"></cf_UIToolTip></td>
						<td style="min-width:20px"></td>
					</tr>
					
					</table>
				</td>
			   </tr>
		   
		   	</cfif>  
	    	   
		    <tr class="labelmedium2">			 
			   <td width="2%">&nbsp;</td>
		       <td colspan="2" style="width:100%"></td>
			   <td style="min-width:90px" align="center"><cf_tl id="Authorised"></td>
		   	   <td style="min-width:90px" align="center"><cf_tl id="Positions"></td>
			   <td style="min-width:90px" align="center"><cf_tl id="Loaned"></td>
		       <td style="min-width:90px" align="center"><cf_tl id="Borrowed"></td>
		       <td style="min-width:90px" align="center"><cf_tl id="Incumbered"></td>			 
		     </tr>
	   	   			   	   	   
	    	   <cfquery name="Total" 
			       datasource="AppsQuery" 
			       username="#SESSION.login#" 
			       password="#SESSION.dbpw#">
			       SELECT  ISNULL(SUM(PostBorrowed),0) as PostBorrowed, 
						   ISNULL(SUM(PostLoaned),0)   as PostLoaned,
						   ISNULL(SUM(Authorised),0)   as Authorised,
				           ISNULL(SUM(Post),0)         as Post,
				           ISNULL(SUM(Staff),0)        as Staff
	  		       FROM    #SESSION.acc#PositionSum#FileNo# P
			   </cfquery>			  
			  			   		   		   
			   <tr class="labelmedium">
			   
				   <td width="65%" colspan="3" style="height:20px;padding-right:10px">
				   
				   	   <cfif URL.header eq "requisition">
					   
					   	<cf_tl id="Summary">
					   
					   <cfelse>
				   
					       <table width="98%" border="0" class="formpadding">
						   <tr>
						   					   
						   <!--- moved from the bottom --->
							  
							  <cfif URL.PDF eq 0 and (accessPosition eq "ALL" or accessPosition eq "EDIT")>
							  											 		 		  		  
									<cfquery name="Check" 
									datasource="AppsOrganization" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										  SELECT   *
										  FROM     Ref_Mandate
										  WHERE    Mission = '#URL.Mission#'					      					 
									      AND      DateEffective > '#Mandate.DateEffective#'	
										  AND      MandateStatus = '1'
										  ORDER BY DateEffective		 	  
							        </cfquery>
									
									<!--- check if there is a mandate after the current mandate and make sure this one is open --->
																																											
									<cfif check.recordcount eq "0" and (accessPosition eq "ALL" or accessStaffing eq "EDIT" or accessStaffing eq "ALL")>
														
									  <td width="20" colspan="1" height="20">  		
									  <cf_tl id="Extend Assignment" var="vBatch">			  
									  <input type="button" name="Extend" id="Extend" style="border:1px solid silver;width:200" value="#vBatch#" class="button10g clsNoPrint" onClick="extend('#URL.Mission#','#URL.Mandate#')">
									  </td>
									  
									</cfif>  												
													
										<cfif ( Mandate.MandateStatus eq "0" or Mandate.MandateStatus eq "" or Mandate.MandateDefault eq 1) and counted gt 0 > 
											
											<td width="20" style="padding-left:1px;height:20px">
											
												<input type="button" 
													  name="MovePositions" 
													  id="MovePositions" 
													  value="Move Selected Positions" 
													  onclick="movePositions('#URL.Mission#','#URL.Mandate#')" 
													  class="button10g clsNoPrint" 
													  style="border:1px solid silver;width:180px">	
												  
											</td>
											
										</cfif>
										
										<cfif ( Mandate.MandateStatus eq "0" or Mandate.MandateStatus eq "")> 
										
											<td width="20" style="padding-left:1px">	
												<input type="button" name="Remove" id="Remove" class="button10g" 
											    		style="height:25px;width:180px"
														value="Remove Selected Positions" 							
														onClick="ColdFusion.navigate('#SESSION.root#/staffing/application/position/PositionBatch.cfm?action=purge&Lay=#url.lay#&page=#url.page#&sort=#url.sort#&id=#url.id#&id1=#url.id1#&Mission=#URL.Mission#&mandate=#URL.Mandate#','process')"/>															
											</td>	
										
										</cfif>
									
												
								</cfif>	
								
								<td align="right" class="labelmedium2">
								
								 <cfif hunit neq "">
						   		   
									    <cfif URL.PDF eq 0>
									   		<a href="javascript:sumpos('#hunit#','p#hunit#','all')" style="color:black"><cf_tl id="Total">: #DateFormat(IncumDate, CLIENT.DateFormatShow)#</font></a>
										<cfelse>
									   		<font size="4"><cf_tl id="Total">:</font> #DateFormat(IncumDate, CLIENT.DateFormatShow)#
										</cfif>		
											   
								   </cfif>
								
								</td>
						   
						   </tr>
						   
						   </table>
					   
					   </cfif>
				   			   
				   </td>
			   
		   	       <td class="cell" style="font-size:16px;background-color:eaeaea;border:1px solid silver;height:20px;padding-right:6px" align="right">			   
				   		#total.authorised#			  
				   </td>
			   
				   <td class="cell" style="font-size:16px;background-color:eaeaea;border:1px solid silver;height:20px;padding-right:6px" align="right">
				   <cfif total.postloaned eq "">
				   		#total.post#
				   <cfelse>
					    #total.post-total.postloaned#
				   </cfif>
				   
				   </td> 
				   <td class="cell" style="font-size:16px;background-color:eaeaea;border:1px solid silver;height:20px;padding-right:6px" align="right">#total.postloaned#</td>
				   <td class="cell" style="font-size:16px;background-color:eaeaea;border:1px solid silver;height:20px;padding-right:6px" align="right">#total.postborrowed#</td>
				   <td class="cell" style="font-size:16px;background-color:eaeaea;border:1px solid silver;height:20px;padding-right:6px" align="right">#total.staff#</td>
				
		   </tr>
		  	  
		   <tr id="sumboxp#hunit#" class="hide"><td colspan="8"><cfdiv id="sump#hunit#"></td></tr>
		  		   	   
	  </cfif>
	  	   
   <cfquery name="Check" 
       datasource="AppsQuery" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT *
       FROM   #SESSION.acc#PositionSum#FileNo#
	   WHERE  OrgUnit = '#orgunit#' 
   </cfquery>
   
   <cfif check.Post neq "">      
	   <cfset currrowX = currrow + Check.Post>
   <cfelse>
       <cfset currrowX = currrow>
   </cfif>	 
      						
   <cfif currrowX gte first>
          
	    <cfset Go = "0">
	   
	    <cfif Len(HierarchyCode) eq "2">
		   <cfset color = "FFFF9B">
		   <cfset Go = "1">
		   
		<cfelse>
		    <cfset color = "FDFEE0">
		    <cfif URL.ID neq "ORG">
		   	   <cfif Check.post gt 0 or Check.Staff gt 0>
			      	   <cfset Go = "1">
			   </cfif>
			<cfelse>	   
		       <cfset Go = "1">
			</cfif>
	    </cfif>
				
		<cfif Go eq "1">
		
				<tr><td style="height:13px"></td></tr>
								
			    <tr class="labelmedium fixrow3" style="height:39px;border-top:1px solid silver">
			    <td width="30" style="padding-left:3px;padding-top:5px">
								
					<cfif url.pdf eq "0">	 					     
						 <cf_img icon="expand" toggle="yes" onClick="sumpos('#orgunit#','#orgunit#','')">											  
					</cfif>		  
											  																
			    </td>
								
			    <td style="min-width:100px;padding-left:4px">#HierarchyCode#</td>				
			    <td width="96%" style="height:20px">
								
				<cfif URL.PDF eq 1>		
						
					#OrgUnitName# <font size="2">(#OrgUnitCode#)</font>				
					
				<cfelse>
								
					<table>
					
					<cfparam name="CLIENT.dropdownno"  default="1">
					<cfparam name="dropdownno" 		   default="#CLIENT.dropdownno#">
					
					<tr onContextMenu="cmexpand('mymenu','#dropdownno#','')" onclick="cmclear('mymenu')">
					<td class="labellarge" style="height:20;font-size:18px">#OrgUnitName# <font size="1">#OrgUnitCode#</font></td>
					<td id="mymenu#dropdownno#" class="hide">
								
						 <cf_dropDownMenu
						     name="menu"
					   	     headerName="Organization"
						     menuRows="2"
							 AjaxId="mymenu#dropdownno#"											 
						     menuName1="Edit"
						     menuAction1="javascript:editOrgUnit('#OrgUnit#')"
						     menuIcon1="#SESSION.root#/Images/review.jpg"
						     menuStatus1="Edit details"											     		 
						     menuName2="Maintain"
						     menuAction2="javascript:viewOrgUnit('#OrgUnit#')"
						     menuIcon2="#SESSION.root#/Images/edit.jpg"
						     menuStatus2="Maintain organization information">	
							 
					</td>		
					
					</tr>
					
					</table> 
				
				</cfif>
				
				</TD>
				
				<cfset unit = OrgUnitName>
				  
				  <td><table style="width:100%"><tr>
				  <td class="cell" style="padding-top:2px;font-size:14px;background-color:f1f1f1;border:1px solid silver;border-right:0px;height:20px;padding-right:6px" align="right">				   
				   #check.authorised#				  
				  </td>
				  </tr></table></td>
				  
				  <td>
				  <table style="width:100%"><tr>
				  <td class="cell" style="padding-top:2px;font-size:14px;background-color:f1f1f1;border:1px solid silver;border-right:0px;height:20px;padding-right:6px" align="right">
				  
				    <cfif check.postloaned eq "">
				   		#check.post#
				   <cfelse>
					    #check.post-check.postloaned#
				   </cfif>
				   
				  </td> 
				  </tr></table></td>
				  
				  <td><table style="width:100%"><tr>
				  <td class="cell" style="padding-top:2px;font-size:14px;background-color:f1f1f1;border:1px solid silver;border-right:0px;height:20px;padding-right:6px" align="right">#check.postloaned#</td>
				  </tr></table></td>
				  
				  <td><table style="width:100%"><tr>
				  <td class="cell" style="padding-top:2px;font-size:14px;background-color:f1f1f1;border:1px solid silver;border-right:0px;height:20px;padding-right:6px" align="right">#check.postborrowed#</b></td>
				  </tr></table></td>
				  
				  <td><table style="width:100%"><tr>
				  <td class="cell" style="padding-top:2px;font-size:14px;background-color:f1f1f1;border:1px solid silver;height:20px;padding-right:6px" align="right">#check.staff#</td>				
				  </tr></table></td>
				</tr>
												
				<tr id="sumbox#org#" class="hide"><td colspan="8"><cfdiv id="sum#org#"></td></tr>
			   
			   <cfset pte = "">
			   <cfset orow = 0>
			 			   
			   <cfoutput group="ViewOrder">
			   			   
			   <!--- now is the time to define access rights for position and assignment --->
			   
			   <cfif getAdministrator(url.mission) eq "0">
			   		  			   			   
				   <cfif PostType neq pte>
				   
				   	   <!--- staffing --->
					   <cfif evaluate("accessStaffing#PostType#") neq "EDIT" and evaluate("accessStaffing#PostType#") neq "ALL">
					   		   			  			  		
							<cfinvoke component = "Service.Access"  
					          method            = "staffing" 
							  orgunit           = "#OrgUnit#" 
							  posttype          = "#PostType#"
							  returnvariable    = "accessStaffing"> 
							  
							  <cfparam name="AccessStaffing#PostType#" default="#accessStaffing#">
							  											  
						<cfelse>
						
							<cfset accessStaffing = evaluate("accessStaffing#PostType#")>  
						  
						</cfif>  
						
						<!--- recruit --->
						<cfif accessStaffing eq "NONE" or accessStaffing eq "READ">
						  
							  <cfinvoke component="Service.Access"  
					          method          = "recruit" 
							  orgunit         = "#OrgUnit#" 
							  posttype        = "#PostType#"
							  returnvariable  = "accessRecruit"> 
							  						 
						<cfelse>
						  
						  	<cfset accessRecruit = "EDIT">
						  
						</cfif>
						
						<!--- position --->
						<cfif evaluate("accessPosition#PostType#") neq "EDIT" and evaluate("accessPosition#PostType#") neq "ALL">  
										  
							<cfinvoke component="Service.Access"  
					          method         = "position" 
							  orgunit        = "#OrgUnit#" 
							  role           = "'HRPosition'"
							  posttype       = "#PostType#"
							  returnvariable = "accessPosition"> 
							  
							   <cfparam name="AccessPosition#PostType#" default="#accessPosition#">
													  
						 <cfelse> 
						 
						    <cfset accessPosition = evaluate("accessPosition#PostType#")>
						 
						</cfif> 
						  							  										  				  
						<cfset pte = PostType>
					  
					</cfif>	
				
				<cfelse>
				
					<cfset accessStaffing = "ALL">
					<cfset accessPosition = "ALL">
					<cfset accessRecruit  = "ALL">
				
				</cfif>
																				  			   
			   <cfoutput group="PostOrder">		 
			  			   					   			   
				
			   <cfoutput group="PositionNo">
			   			   			   
			        <cfset currrow = currrow + 1>
					<cfif currrow gte first and currrow lte last>
					
						<cfif URL.Lay eq "Advanced">
							
						  <cfif currrow gte first and currrow lte last>
						  		
								<tr><td height="2"></td></tr>				  						  
						        <tr><td colspan="8" style="border-top:1px solid silver;">
							       <cfinclude template="MandateViewOrganizationPosition.cfm">
								</td></tr>
															
								<tr>																
								<td colspan="8" id="i#positionno#">																
								<cfoutput group="AssignmentNo">															
									<input type="button" id="refresh_i#positionno#" class="hide" type="button" onclick="reloadassignment('#positionno#','#url.lay#')">								 							 										 							
		 							<cfinclude template="MandateViewOrganizationAssignment.cfm">																
								</cfoutput>								
								</td>
								</tr>														
																	
						  </cfif>
								
						<cfelse>	
																						
						       <cfif currrow gte first and currrow lte last>
							   
							    <button id="refresh_i#positionno#" type="button"
						    	    class="hide"	
									onclick="reloadposition('#positionno#','#url.lay#','#class#')"/>
								
								 <cfset prior = "">								 
								 <cfoutput group="AssignmentNo">	
								 							 								 
								 <tr style="height:0px"><td colspan="8" id="i#positionno#" align="center"><cfinclude template="MandateViewOrganizationAssignmentView.cfm"></td></tr>	
								 <cfset prior = PositionNo>
								 </cfoutput>
								 
						       </cfif>						   
							
						</cfif>
								 	
				     <cfelseif currrow gt last>
					 														 
						 <tr><td height="8" colspan="12">
						<cfinclude template="Navigation.cfm">
						 </td></tr>								 		
						 <cfinclude template="MandateViewExit.cfm">
					     <cfabort> 
					 </cfif> 		
				 
			   </cfoutput>
			   </cfoutput>
			   
			   </CFOUTPUT>
		 
    	  </cfif>
			
	<cfelse>
	  <cfset currrow = CurrrowX> 
	</cfif>		
	
	<cfif currrow gt last>
        	
	 <tr><td height="14" colspan="8">		 					 
      	 <cfinclude template="Navigation.cfm">					 
     </td></tr>
			 			 
	</cfif>		
		
</CFOUTPUT>

</CFOUTPUT>

</table>

<script>
	Prosis.busy('no')
</script>
