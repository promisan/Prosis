
<!--- filter by owner of the position --->

<cfset mission = "">

<cfloop index="itm" list="#url.mission#" delimiters="__">

	<cfif mission eq "">
		<cfset mission = "'#itm#'">
	<cfelse>
		<cfset mission = "#mission#,'#itm#'">
	</cfif>	
	
</cfloop>

<cfparam name="url.orgunit"  default="">
<cfparam name="url.period"   default="">
<cfparam name="url.actor"    default="">
<cfparam name="url.sort"     default="Margin">
<cfparam name="url.month"    default="">
<cfparam name="url.status"   default="">

<cfparam name="url.field"    default="">
<cfparam name="url.value"    default="">

<cfif url.field eq "undefined">
	<cfset url.field = "trigger">
</cfif>

<cfquery name="base" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	

	SELECT     Sub.Mission, 
			   Sub.FirstName,
			   Sub.LastName,
			   Sub.IndexNo,
			   Sub.PersonNo,
			   Sub.PositionNo,
			   Sub.PostNumber,
			   <cfif url.orgunit neq "" and url.orgunit neq "0">
	           P.OrgUnit, 
			   P.OrgUnitName, 
			   </cfif>
			   Sub.Eventid,		 
			   Sub.DateEvent,
			   Sub.EventYear, 
			   Sub.EventMonth, 
			   Sub.ActionStatus, 
			   Sub.EventTrigger, 
			   Sub.EventTriggerName, 
			   Sub.ReasonName,
			   Sub.EventCode, 
			   Sub.EventName, 
			   Sub.DateEventDue,
			   MONTH(Sub.ActionDateEffective) as MonthEffective,		   
		       Sub.ActionDateEffective,
			   Sub.ActionDateExpiration,
	           Sub.Actor,
			   Sub.ActorName,
			   Sub.ActorComments,
			   Sub.Remarks,
			   Sub.OfficerLastName,
			   Sub.OfficerUserId
						  
	FROM         (SELECT     Pe.Mission, 
							 Pe.DateEvent,
							 Pe.DateEventDue,
							 <cfif url.sort eq "Margin">
								 YEAR(CASE WHEN Pe.DateEventDue  is NULL THEN Pe.DateEvent ELSE Pe.DateEventDue END) AS EventYear, 
								 MONTH(CASE WHEN Pe.DateEventDue is NULL THEN Pe.DateEvent ELSE Pe.DateEventDue END) AS EventMonth,                      						
							 <cfelse>
								 YEAR( CASE WHEN Pe.ActionDateEffective is NULL THEN Pe.DateEvent ELSE Pe.ActionDateEffective END) AS EventYear, 
								 MONTH(CASE WHEN Pe.ActionDateEffective is NULL THEN Pe.DateEvent ELSE Pe.ActionDateEffective END) AS EventMonth,
							 </cfif>
							 Pe.EventId,
							 Pe.PersonNo,
							 Pe.PositionNo,
							
							 P.IndexNo,
							 P.LastName,
							 P.FirstName,
	
							(CASE WHEN OrgUnit = '0' THEN
	                                (SELECT    OrgUnitOperational
	                                 FROM      Position
	                                 WHERE     PositionNo = Pe.PositionNo) ELSE OrgUnit END) AS OrgUnit, 
									 
							 Pe.ActionStatus, 						
	                         Pe.EventTrigger, 								 				
							 R.Description AS EventTriggerName, 
							 Pe.EventCode, 
							 E.Description AS EventName,		
							 (
							 SELECT Description
							 FROM Ref_PersonGroupList
							 WHERE GroupCode     = Pe.ReasonCode
							 AND   GroupListCode = Pe.ReasonListCode ) as ReasonName,
							 				 
							 Pe.ActionDateEffective,
							 Pe.ActionDateExpiration,						
							 Pe.OfficerUserId,
							 Pe.OfficerLastName,
							 Pe.Created,
	                         
	                         (SELECT     TOP 1 U.Account
	                          FROM       Organization.dbo.OrganizationObjectActionAccess AS OOAA INNER JOIN
	                                     Organization.dbo.OrganizationObjectAction AS OOA ON OOAA.ObjectId = OOA.ObjectId INNER JOIN
	                                     System.dbo.UserNames AS U ON OOAA.UserAccount = U.Account INNER JOIN
	                                     Organization.dbo.OrganizationObject AS OO ON OOAA.ObjectId = OO.ObjectId
	                          WHERE      OO.ObjectKeyValue4 = Pe.EventId AND OOAA.AccessLevel = 1
	                          ORDER BY   OOAA.Created DESC) AS Actor,						  
							    
	                         (SELECT     TOP 1 U.LastName
	                          FROM       Organization.dbo.OrganizationObjectActionAccess AS OOAA INNER JOIN
	                                     Organization.dbo.OrganizationObjectAction AS OOA ON OOAA.ObjectId = OOA.ObjectId INNER JOIN
	                                     System.dbo.UserNames AS U ON OOAA.UserAccount = U.Account INNER JOIN
	                                     Organization.dbo.OrganizationObject AS OO ON OOAA.ObjectId = OO.ObjectId
	                          WHERE      OO.ObjectKeyValue4 = Pe.EventId AND OOAA.AccessLevel = 1
	                          ORDER BY   OOAA.Created DESC) AS ActorName,
							  
							  (
							  SELECT     TOP 1 CONVERT(VARCHAR(5000), ActionMemo)
							  FROM       Organization.dbo.OrganizationObjectAction OOA INNER JOIN
	                                     Organization.dbo.OrganizationObject AS OO ON OOA.ObjectId = OO.ObjectId
						      WHERE      OO.ObjectKeyValue4 = Pe.EventId
							  AND        OOA.ActionCode IN ('Pev003','VAP110')  <!--- hardcoded UN ---> 
							  ORDER BY   ActionFlowOrder DESC ) as ActorComments,
							  
							  (SELECT    SourcePostNumber
							  FROM       Position
							  WHERE      PositionNo = Pe.PositionNo) as PostNumber,
							 						  
							  Pe.Remarks
														
	            FROM       dbo.PersonEvent AS Pe INNER JOIN
	                       dbo.Ref_EventTrigger AS R ON Pe.EventTrigger = R.Code INNER JOIN
	                       dbo.Ref_PersonEvent AS E ON Pe.EventCode = E.Code INNER JOIN
						   dbo.Person AS P ON Pe.PersonNo = P.PersonNo
						   
	            WHERE      Pe.ActionStatus IN ('0','1','2','3')) AS Sub 					   
			
		   <cfif url.OrgUnit neq "" and url.orgunit neq "0">			   
		        INNER JOIN  Organization.dbo.Organization AS O ON Sub.OrgUnit = O.OrgUnit 
				INNER JOIN  Organization.dbo.Organization AS P ON O.Mission = P.Mission AND O.MandateNo = P.MandateNo AND O.HierarchyRootUnit = P.OrgUnitCode
		   </cfif>				  
						  
	WHERE  Sub.Mission IN (#preserveSingleQuotes(mission)#) 
	
	
	<cfif url.period eq "All">
		AND     Sub.EventYear >= '2015'
	<cfelse>
		AND    Sub.EventYear  = '#url.period#' 	
	</cfif>
	
	
	<cfif url.OrgUnit neq "" and url.orgunit neq "0">
		AND    P.OrgUnit = '#url.orgunit#' 
	</cfif>		
	
	<cfif url.Month neq "">
		AND    Sub.EventMonth  = '#url.month#'	
	</cfif>
	
	<cfif url.Actor neq "">
		AND    Sub.Actor  = '#url.actor#' 
	</cfif>
	
	<cfif url.field eq "Trigger">
	
		<cfif url.value neq "">
			AND    Sub.EventTrigger = '#url.value#'
		</cfif>
		
	<cfelse>
	
		<cfif url.value neq "">
			AND    Sub.EventCode    = '#url.value#'
		</cfif>	
		
	</cfif>
	
	<cfif url.status eq "P">
		AND    Sub.ActionStatus < '3'
	<cfelse>
		AND    Sub.ActionStatus = '3'
	</cfif>
							  
	ORDER BY EventMonth, 
	         ActionDateEffective, 
			 DateEvent
		 		
</cfquery>

<cfif base.recordcount eq "0">

	<table width="100%">
	   <tr><td align="center" style="height:40px" class="labelmedium"><cf_tl id="No records to show in this view"></td></tr>
	</table>

<cfelse>

  	
	<table width="100%">
	
	   <tr><td style="height:6px"></td></tr>
	
	   <tr style="border-top:0px solid silver" class="labelmedium line navigation_table fixlengthlist">
	       <td></td>
	       <td><cf_tl id="IndexNo"></td>
	       <td><cf_tl id="Name"></td>
		   <td><cf_tl id="Due date"></td>
		   <td><cf_tl id="Event"></td>	 
		   <td><cf_tl id="Effective"></td>
		   <td><cf_tl id="Expiration"></td>
		   <td><cf_tl id="Officer"></td>
		   <td><cf_tl id="Actor"></td>
	   </tr>   	  
	 	   
	   <cfoutput query="base" group="EventMonth">
	   
	   <tr>
	   
		   <td colspan="5" style="height:34px" class="labellarge">
		   <cftry>
		   #monthasstring(eventMonth)#
		   <cfcatch></cfcatch>
		   </cftry>
		   </td>	  	   
		   
		   <td align="right" valign="bottom" colspan="4" style="padding-right:4px" class="labelmedium">
		   
		   <font color="808080">
		   
		   <cfif url.field eq "Trigger">		   
				 #Base.EventTriggerName#							
		   <cfelse>		   
		   		 #Base.EventName# 								
		   </cfif>
		   
		   </font>
		   	   
		   </td>
	   	   
	   </tr>
	   
	   <cfoutput>
	   
		   <tr class="labelmedium2 navigation_row fixlengthlist" style="height:20px;border-top:1px solid silver">
		       <td style="min-width:20px;padding-top:2px;padding-left:10px"><cf_img navigation="Yes" icon="open" onclick="eventdialog('#eventid#')"></td>
		       <td style="padding-right:7px">
				   <table><tr class="labelmedium2">
				          <td><img src="#session.root#/images/logos/staffing/iconperson.png" style="height:17px" alt="" border="0"></td>
				          <td style="padding-left:4px" ><a href="javascript:EditPerson('#personno#')">#IndexNo#</a></td>
				   </tr>
				   </table>
			   </td>
		       <td>#FirstName# #LastName#</b></td>
			   <td>#dateformat(DateEventDue,client.dateformatshow)#</td>
			   <td>#EventTriggerName#: <font color="808000">#EventName# </td>	 
			   <td>#dateformat(ActionDateEffective, client.dateformatshow)#</td>
			   <td>#dateformat(ActionDateExpiration, client.dateformatshow)#</td>	 
			   <td>#OfficerLastName#</td>  
			   <td>#ActorName#</td> 
		   </tr>
		   
		   <tr class="labelmedium2 navigation_row_child" style="height:20px;border-top:1px solid silver">
		        <td colspan="1"></td>
				<cfif PositionNo neq "">
				<td style="padding-left:4px;background-color:ffffaf" >
					<table>
						<tr class="labelmedium2"><td><img src="#session.root#/images/logos/staffing/iconposition.png" style="height:17px" alt="" border="0"></td>
							<td style="padding-left:8px;background-color:ffffaf" ><a href="javascript:EditPosition('','','#PositionNo#')">#PostNumber#</a></td>
						</tr>
					</table>	
				<cfelse>
				<td></td>
				</cfif>
				<!---
				<td colspan="1" style="background-color:##e1e1e180;border-left:1px solid silver;;border-right:1px solid silver;padding-left:3px;padding-left:1px;"><cf_tl id="Request">:</td>
				--->
		        <td colspan="7" style="padding-left:4px;background-color:##ffffcf80">
				 <cfif base.reasonname neq ""><b>#Base.ReasonName#:&nbsp;</b></cfif><cfif remarks neq "">#remarks#</cfif>
			   </td>
		   </tr>
		   		  
		   <cfif actorcomments neq "">
		   <tr class="labelmedium2 navigation_row_child" style="height:20px;border-top:1px solid silver">
		        <td colspan="1"></td>
				<td></td>
				<td colspan="1" style="background-color:##e1e1e180;border-left:1px solid silver;;border-right:1px solid silver;padding-left:3px;padding-left:1px;""><cf_tl id="Actor">:</b> </td>
				<td colspan="6" style="padding-left:4px"><font color="red">#ActorComments#</td></tr>	   
		   </cfif>
	      
	   </cfoutput>
	   
	   </cfoutput>
	   
	  </table>
  
</cfif>  
    
<cfset AjaxOnLoad("doHighlight")>