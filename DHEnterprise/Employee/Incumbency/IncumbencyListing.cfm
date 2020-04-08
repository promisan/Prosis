
<cfparam name="URL.Print" default="No">

<!--- Query returning search results --->

	<cfquery name="Hub" 
	datasource="hubEnterprise" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">

	SELECT    PA.TransactionId,
			  PA.PositionId, 	
	          PA.Source,          
			  PA.DateEffective, 
			  PA.DateExpiration, 				  
			  PA.AssignmentType, 
			  PA.IndicatorMobility,
			  R.ListingColor,
			  PA.Incumbency,	
			  
			  (SELECT DutyStationName 
			   FROM   Ref_Location 
			   WHERE  DutyStation = PA.Location) as LocationName,		 			 	  
			   
			  PA.Location,
			  
   		    (
			  	SELECT   TOP 1 MissionLabel
				FROM     MissionOrganization MO, Mission M
				WHERE    MO.Mission = M.Mission
				AND      MO.DateEffective <= PA.DateExpiration
				AND      MO.OrgUnitId = PA.OrgUnitId
				ORDER BY MO.DateEffective DESC) as Mission,	
			  
			  (CASE WHEN Source = 'IMIS' THEN (
			  
			  	  ( SELECT    TOP 1 OrgUnitName+' / '+OrgUnitNameShort
					FROM      NYVM1613.Organization.dbo.Organization O
					WHERE     O.Mission       = 'UN' 
					AND       O.MandateNo     = 'P001'
					AND       '2000'+O.OrgUnitCode = PA.OrgUnitId ) 			  
			  
			  ) ELSE 
			  			  
				  ( SELECT   TOP 1 OrgUnitNameShort
					FROM     MissionOrganization MO, Mission M
					WHERE    MO.Mission = M.Mission
					AND      MO.DateEffective <= PA.DateExpiration
					AND      MO.OrgUnitId = PA.OrgUnitId
					ORDER BY MO.DateEffective DESC) 
					
				END ) as OrgUnitName,					
				
			    (CASE WHEN (PA.JobCode is NULL) THEN  			   	  
			  
					   ( SELECT    TOP 1 JobDescription
						 FROM      PositionOrganization O, Ref_Job J
						 WHERE     O.PositionId         = PA.PositionId
						 AND       O.DateExpiration    >= PA.DateEffective
						 AND       O.JobCode            = J.JobCode
						 AND       O.TransactionStatus != '9'	
						 ORDER BY  O.DateExpiration DESC )
								
				ELSE
				
					( SELECT  JobDescription
					  FROM      Ref_Job J
					  WHERE     J.JobCode =  PA.JobCode )
					
				
				END ) as FunctionDescription,
				
			  ( SELECT    TOP 1 Grade
				FROM      PersonGrade G
				WHERE     IndexNo = PA.IndexNo
				AND       G.GradeClass = 'Regular'
				AND       DateEffective <= PA.DateExpiration
				AND       TransactionStatus != '9'	
				ORDER BY  DateEffective DESC ) as Grade,	
				
			   ( SELECT    TOP 1 Step
				FROM      PersonGrade G
				WHERE     IndexNo = PA.IndexNo
				AND       G.GradeClass = 'Regular'
				AND       DateEffective <= PA.DateExpiration
				AND       TransactionStatus != '9'	
				ORDER BY  DateEffective DESC ) as Step,		
				
				<!--- SPA / Temp --->
				
				(SELECT Grade+'/'+Step
				FROM   PersonGrade
				WHERE  IndexNo     = PA.IndexNo
				AND    GradeClass != 'Regular'
				AND    TransactionId IN 		
							
								   ( SELECT   TOP 1 TransactionId
									FROM      PersonGrade G
									WHERE     IndexNo = PA.IndexNo									
									AND       DateEffective  <= PA.DateExpiration		
									AND       DateExpiration >= PA.DateEffective		
									AND       TransactionStatus != '9'	
									AND       HistoricAction = 0
									ORDER BY  DateEffective DESC ))	as SPA,
				
							
				
			  ( SELECT    TOP 1 PostTypeName
				FROM      PositionModality P, Ref_PostType R
				WHERE     PositionId = PA.PositionId
				AND       P.PostType = R.PostType
				AND       DateExpiration >= PA.DateEffective
				AND       TransactionStatus != '9'	
				ORDER BY  DateExpiration DESC ) as PostType,	
			  			  
			  ( SELECT    TOP 1 PostGrade
				FROM      PositionModality
				WHERE     PositionId     = PA.PositionId
				AND       DateExpiration >= PA.DateEffective
				AND       TransactionStatus != '9'	
				ORDER BY  DateExpiration DESC ) as PostGrade,
			  
			  ( SELECT    TOP 1 CBFund
				FROM      PositionFunding
				WHERE     PositionId     = PA.PositionId
				AND       DateExpiration >= PA.DateEffective
				AND       TransactionStatus != '9'		
				ORDER BY  DateExpiration DESC ) as CBFund,
				
			   (
			   SELECT     TOP 1 CBCostCenter
				FROM      PositionFunding
				WHERE     PositionId     = PA.PositionId
				AND       DateExpiration >= PA.DateEffective
				AND       TransactionStatus != '9'		
				ORDER BY  DateExpiration DESC ) as CBCostCenter,
				
			  (
			   SELECT     TOP 1 CBFunctionalArea
				FROM      PositionFunding
				WHERE     PositionId     = PA.PositionId
				AND       DateExpiration >= PA.DateEffective
				AND       TransactionStatus != '9'		
				ORDER BY  DateExpiration DESC ) as CBFunctionalArea	
			  
	FROM        PersonAssignment AS PA INNER JOIN Ref_AssignmentType R ON PA.AssignmentType = R.AssignmentType
		
	<cfif len(url.id) eq "6">		  
	WHERE       PA.IndexNo      = '00#URL.ID#' 
	<cfelse>
	WHERE       PA.IndexNo      = '#URL.ID#'
	</cfif>	
	AND         PA.TransactionStatus != '9'			  		
	AND         (PA.OrgUnitId <> 0 OR (PA.OrgUnitId = '0' and PositionId = '99999999'))
	AND         PA.DateEffective <= PA.DateExpiration
	
	ORDER BY    DateExpiration DESC, 	
	            DateEffective DESC,            
			    Incumbency DESC
				  	
</cfquery>



<cfquery name="LastContract" 
datasource="hubEnterprise" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *, 
			YEAR(DateExpiration) as ExpYearContract
	FROM  	 PersonAppointment
	<cfif len(url.id) eq "6">		  
	WHERE       IndexNo      = '00#URL.ID#' 
	<cfelse>
	WHERE       IndexNo      = '#URL.ID#'
	</cfif>	
	AND      TransactionStatus = '1'
	AND      TransactionLevel  = '1'    
	ORDER BY DateExpiration DESC
</cfquery>	

<cfparam name="URL.ID1" default="ASc.cfm">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">

<tr class="clsNoPrint">
    
    <td class="labelit" style="height:40px;padding-left:10px">
	
	<table><tr class="labelmedium">
	
	<cfoutput>
	<td><input type="radio" class="radiol" name="view" value="ASc.cfm" <cfif URL.ID1 eq 'ASc.cfm'> checked </cfif> onClick="Prosis.busy('yes');_cf_loadingtexthtml='';	ColdFusion.navigate('../../DHEnterprise/Employee/Incumbency/IncumbencyListing.cfm?ID=#URL.ID#','ass')"></td><td class="labelmedium" style="font-size:21px;padding-left:7px;padding-right:10px">Position movements</td>
	<td><input type="radio" class="radiol" name="view" value="AS.cfm" <cfif URL.ID1 eq 'AS.cfm'> checked </cfif> onClick="Prosis.busy('yes');_cf_loadingtexthtml='';	ColdFusion.navigate('../InquiryEmployee/Search_Result'+this.value+'?ID=#URL.ID#','ass')"></td><td style="padding-left:4px;padding-right:8px">Detail records (IMIS)</td>
	<!---
    <td><input type="radio" class="radiol" name="view" value="ASx.cfm" <cfif URL.ID1 eq 'ASx.cfm'> checked </cfif> onClick="Prosis.busy('yes');_cf_loadingtexthtml='';	ColdFusion.navigate('../InquiryEmployee/Search_Result'+this.value+'?ID=#URL.ID#','ass')"></td><td style="padding-left:4px;padding-right:8px">Movements (IMIS)</td>	
	--->
	 </cfoutput>
	</tr>
	</table>    
   
    </td>
	<td align="right" style="padding-right:10px">
		<cf_tl id="Show Personnel Actions" var="lblShowPA">
		<cf_tl id="Show Lien Assignments" var="lblShowLI">
		<cfoutput>
			<table>
				<tr>
					<td class="labellarge">
						<input type="Checkbox" id="toggleAllDetails" onclick="toggleAllDetails(this.checked)" style="cursor:pointer;"> <label style="cursor:pointer;" for="toggleAllDetails">#lblShowPA#</label>
					</td>
					<td style="padding-left:20px;" class="labellarge">
						<input type="Checkbox" id="toggleLI" onclick="toggleAssignmentType(this.checked, 'LI')" style="cursor:pointer;" checked> <label style="cursor:pointer;" for="toggleLI">#lblShowLI#</label>
					</td>
				</tr>
			</table>
		</cfoutput>
	</td>
</tr>  

<tr> 
  <td width="100%" colspan="2" style="height:20px">
  
  <table border="0" cellpadding="0" cellspacing="0"  width="99%" align="center">
  
    <TR class="labelmedium line" style="border-top:1px solid gray;background-color:d0d0d0;height:15px">	 	
			<td style="padding-left:3px;min-width:15"></td>
	        <td style="padding-left:3px;min-width:50"><cf_tl id="Year"></td>	
			<TD style="padding-left:3px;min-width:80"><cf_tl id="Position"></TD>
		    <TD style="min-width:80"><cf_tl id="Start"></TD>
		    <TD style="min-width:80"><cf_tl id="End"></TD>					
			<TD style="min-width:190;max-width:100%;width:25%"><cf_tl id="Entity"></TD>	
			<TD style="min-width:100"><cf_tl id="Location"></TD>	    
			<TD style="min-width:180"><cf_tl id="Funding"></TD>	    
			<TD style="min-width:90"><cf_tl id="Type"></TD>	
			<TD style="min-width:80">Ass/%</TD>		  
		    <TD style="min-width:70"><cf_tl id="Grade"></TD>			
			<TD style="min-width:70"><cf_tl id="Source"></TD>	
			<td>&nbsp;&nbsp;&nbsp;</td>		
    </TR>	
	<TR class="labelmedium line" style="background-color:e0e0e0;height:15px">	 	
	        <td></td>	
			<td></td>	
			<TD></TD>		
			 <TD colspan="2"><cf_tl id="Duration"></TD>		
			<TD><cf_tl id="Job"></TD>	
			<TD></TD>	
			<TD></TD>	    
			<TD></TD>	    
			<TD>Mobility</TD>		   	    
		    <TD><cf_tl id="Level"></TD>			
			<TD><cf_tl id="SPA">/<cf_tl id="Temp"></TD>		
			<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>		
    </TR>	
	
   </table>
   </td>
   
</tr>

<tr>   
  	<td width="100%" colspan="2" height="100%">
	
		<cf_divscroll>
	  
	    <table border="0" cellpadding="0" cellspacing="0"  width="99%" align="center" class="navigation_table">
			
		<cfset prior = '0'>	
				
		<cfif Hub.recordcount eq "0">		
			<tr class="labelmedium"><td colspan="13" align="center"><cf_tl id="No records to show in this view"></td></tr>		
		</cfif>
		
		<cfset posit = "">
		<cfset prior = "">
		<cfset total = "0">
		 
		 <cfset vPreviousEffectiveDate = "">
		 
		 <cfoutput query="Hub">  	 
			 
		 	<cfif AssignmentType eq "ZA" and Incumbency eq "0">
				
				<!--- do not show, better to remove records --->
			
			<cfelse>			
								
		 		<cfif AssignmentType eq "ZA">			
				    <cfset cl = "red">	
					<cfset cf = "white">
			 	<cfelse>			
					<cfset cl = listingcolor>
					<cfset cf = "black">				
				</cfif> 
				
				<cfif AssignmentType eq "LI">
					<cfset ln = "line">
				<cfelse>
					<cfset ln = "">	
				</cfif>
										
				<cfif currentrow gte "2" and assignmenttype eq "PM" and dateDiff("d",DateExpiration,eff) gte 5>			
					<tr class="labelmedium" bgcolor="FFFF00" class="line" style="height:23px;border-bottom:1px solid gray">
						<td colspan="13" align="center"><cf_tl id="Interuption in continuous assignment">					
												
						<cfset m = dateDiff("m",dateExpiration,eff+1)>	
						<cfset d = dateDiff("d",DateExpiration,eff+1)>
										
						<cfset y = int(m/12)>
						<cfset m = m - (y*12)>
						
						<cfif y neq 0>#y# year<cfif y gt "1">s</cfif> </cfif><cfif m neq "0">#m# month<cfif m gt "1">s</cfif></cfif> = #d#d	
						
						
						</td>
					</tr>					
				</cfif>
				
				<cfif AssignmentType neq "ZA" and AssignmentType neq "LI">			
					<tr bgcolor="#cl#" style="height:2px" class="navigation_row #ln#"><td colspan="13"></td></tr>
				</cfif>
						 		 	    	
			    <tr bgcolor="#cl#" class="labelmedium navigation_row_child clsAssignmentType_#AssignmentType# #ln#" style="height:22px">	
					<td style="padding-left:5px; padding-right:3px;">
					
						<cf_tl id="Show details" var="1">
						<cfset vTransactionId = replace(TransactionId, "-", "", "ALL")>
						<cfset vCurrentEffectiveDate = dateFormat(DateEffective, client.dateFormatShow)>
						<cfif AssignmentType eq "LI">
							<cfset vPreviousEffectiveDate = "">
						</cfif>
						
						<img src     = "#session.root#/images/arrowright.gif" 
							 title   = "#lt_text#" 
							 class   = "clsTwistieTransaction" 
							 id      = "twistie_#vTransactionId#" 
							 onclick = "showResultASCDetail('#vTransactionId#', '#TransactionId#', '#indexNo#', '#vPreviousEffectiveDate#', '#vCurrentEffectiveDate#', '#Source#')">
							 
					</td>
					<TD style="min-width:50;color:#cf#;padding-left:4px;padding-right:3px"><cfif year(DateEffective) neq prior><b>#year(DateEffective)#</cfif></TD>	
					<TD style="min-width:80;color:#cf#;padding-left:6px;padding-right:3px">
		
						<table>
						<tr class="labelmedium"><td>		
						<cfif PositionId neq "99999999">
						<a href ="javascript:ShowPost('#PositionId#')"><font color="#cf#"><cfif posit neq positionid or AssignmentType eq "LI">#PositionId#<cfelse>...</cfif></font></a>
						</cfif>
						</td>
						<cfif AssignmentType eq "LI" and currentrow lte "2">
							<td style="padding-left:3px"><img src="#session.root#/images/link.gif" onclick="positionchain('#indexno#')" alt="" border="0"></td>
						</cfif>						
						</tr>
						</table>	
						
					</TD>		
					
					<TD style="min-width:80;color:#cf#;padding-right:3px">
						<cfset vPreviousEffectiveDate = dateFormat(DateEffective, client.dateFormatShow)>
						#Dateformat(DateEffective, CLIENT.DateFormatShow)#
					</TD>						
				    <TD style="min-width:80;color:#cf#;padding-right:3px">
					    <cfif DateExpiration neq "9999-12-31">#Dateformat(DateExpiration, CLIENT.DateFormatShow)#
						<cfelseif LastContract.DateExpiration neq ""><font color="red"><font size="1">E:</font>#Dateformat(LastContract.DateExpiration, CLIENT.DateFormatShow)#</font>
						<cfelse>---
						</cfif>
					</TD>								
				    <TD style="min-width:190;max-width:100%;width:25%;color:#cf#;padding-left:5px;padding-right:3px">
					
					    <!--- we check if for the period of the psoition assignment the orgunit has changed as well --->
						
						<cfquery name="PositionHistory" 
						datasource="hubEnterprise" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">					
							SELECT     PositionId,
								      (SELECT     TOP (1) Mission
		                               FROM       MissionOrganization
	    	                           WHERE      OrgUnitId = PO.OrgUnit 
									   AND        DateEffective <= PO.DateEffective
									   ORDER BY DateEffective DESC) AS Mission,
									   
		                              (SELECT     TOP (1) OrgUnitNameShort
		                               FROM       MissionOrganization
	    	                           WHERE      OrgUnitId = PO.OrgUnit 
									   AND        DateEffective <= PO.DateEffective
									   ORDER BY DateEffective DESC) AS OrgUnitName, 
								       OrgUnit, 
									   DateEffective, 
									   DateExpiration, 
									   DutyStation, 
									   JobCode
							FROM      PositionOrganization AS PO
							WHERE     TransactionStatus = '1' 
							AND       PositionId      = '#PositionId#' 
							AND       DateEffective  <= '#dateExpiration#' 
							AND       DateExpiration >= '#dateEffective#'
							AND       Source = 'Umoja'
							ORDER BY DateEffective DESC						
						</cfquery>
						
						<cfquery name="Org" dbtype="query">						
							SELECT    DISTINCT OrgUnitName
							FROM      PositionHistory
						</cfquery>
						
						<cfif Org.recordcount gte "2">
						
						<cfset p = "">
						<table width="100%">
						<cfloop query = "PositionHistory">
							<tr class="<cfif currentrow neq recordcount>line</cfif> labelmedium" style="height:20px">		
							<cfif currentrow eq recordcount>	
							<td><b>#Mission#</b>: #OrgUnitName# #OrgUnit#</td>							
							<td align="right" style="min-width:190px;color:brown;padding-left:7px;padding-right:8px">#dateFormat(Hub.DateEffective,client.dateformatshow)# <cfif p neq "">- #dateFormat(p,client.dateformatshow)#</cfif></td>																									
							<cfelse>
							<td><b>#Mission#</b>: #OrgUnitName#</td>							
							<td align="right" style="min-width:190px;color:brown;padding-left:7px;padding-right:8px">#dateFormat(DateEffective,client.dateformatshow)# <cfif p eq "">- #dateFormat(Hub.DateExpiration,client.dateformatshow)#<cfelse>- #dateFormat(p,client.dateformatshow)#</cfif></td>							
							<cfset p = DateEffective-1>
							</cfif>									
								
							
							</tr>
						</cfloop>						
						</table>
						
						<cfelse>
						
						<cfif AssignmentType eq "ZA" and positionid eq "99999999">				
						<cf_tl id="Separation">
						<cfelse>
						<b>#Mission#</b>: #OrgUnitName#
						</cfif>
												
						</cfif>						
						
					</TD>	    
				    <TD style="min-width:100;color:#cf#;padding-right:3px"><cfif locationName neq "Undef">#LocationName#</cfif></TD>	    
					<TD style="min-width:180;color:#cf#;padding-right:3px">
					<cfif Source neq "IMIS"><cfif AssignmentType neq "ZA">#CBFund#-#CBCostCenter#-#CBFunctionalArea#</cfif><cfelse><i>BAC will be shown</i></cfif></TD>	    
					<td style="min-width:90;color:#cf#;padding-right:3px">#PostType#</TD>
					<TD style="min-width:80;color:#cf#;padding-right:3px">#AssignmentType# <cfif AssignmentType neq "ZA">/#Incumbency#</cfif></TD>				    
				    <TD style="min-width:70;color:#cf#;padding-right:3px">#PostGrade#</TD>
					<td style="min-width:70;color:#cf#;padding-right:3px">#Source#</td>
				    	    
			    </TR>
											
				<tr bgcolor="#cl#" class="labelmedium navigation_row_child clsAssignmentType_#AssignmentType#" style="height:15px">	
					<td></td>
					<td colspan="2"></td>
					<td colspan="2" style="background-color:0078B3;color:white;padding-left:7px;border:1px solid 0078B3;border-bottom:0px">
								
																			
						<cfif DateExpiration gte now() and LastContract.DateExpiration eq "">						
							<cfset m = dateDiff("m",DateEffective,now()+1)>	
							<cfset d = dateDiff("d",DateEffective,now()+1)>
						<cfelseif DateExpiration gte now() and LastContract.DateExpiration neq "" AND year(DateExpiration) eq "9999">							
						    <cfset m = dateDiff("m",DateEffective,LastContract.DateExpiration+1)>	
							<cfset d = dateDiff("d",DateEffective,LastContract.DateExpiration+1)> 
						<cfelse>						
							<cfset m = dateDiff("m",DateEffective,DateExpiration+1)>	
							<cfset d = dateDiff("d",DateEffective,DateExpiration+1)>
						</cfif>
						
						<cfset y = int(m/12)>
						<cfset m = m - (y*12)>
						
						<cfif y neq 0>#y# year<cfif y gt "1">s</cfif> </cfif><cfif m neq "0">#m# month<cfif m gt "1">s</cfif></cfif> = #d#d
						
					</td>
					<td colspan="3" style="padding-left:2px">
					    <cfif functiondescription neq "">
						<table>
						<tr class="labelmedium" style="height:15px">						
						<td style="color:#cf#;padding-left:4px">#FunctionDescription#</td>					
						</tr>						
						</table>					
						</cfif>
					</td>
					<td></td>
					<td>
					<cfif  AssignmentType neq "LI" and AssignmentType neq "ZA">
						<cfif IndicatorMobility eq "1" or IndicatorMobility eq "X"><font color="FF0000"><b>Y</b></font></cfif>
					</cfif>
					</td>			
						
					
											
					<td style="background-color:d1e0e4;padding-left:4px;border:1px solid gray;border-bottom:0px">#Grade#/#Step#</td>
					<cfif AssignmentType neq "LI" and AssignmentType neq "ZA" and SPA neq "">
					<td style="background-color:yellow;padding-left:4px;border:1px solid gray;border-bottom:0px">#SPA#</td>
					<cfelse>
					<td></td>
					</cfif>
						
				</tr>				
									
				<tr class="clsAssignmentType_#AssignmentType#">
					<td></td>
					<td colspan="11" id="detailContainer_#vTransactionId#" class="clsContainerTransactionDetail"></td>
				</tr>
				
				<cfif AssignmentType neq "LI">
					<tr style="height:1px"><td colspan="12" class="line"></td></tr>			
				</cfif>
				
				<cfif AssignmentType eq "PM" or AssignmentType eq "LI" or AssignmentType eq "ZA">
					<cfset eff = DateEffective>
				</cfif>
				
				<cfif Incumbency eq "0" or (Assignmenttype eq "ZA" and Positionid eq "99999999")>				
					<!--- no counting --->				
				<cfelse>
				
					<cfif DateExpiration gte now()>
						<cfset m = dateDiff("d",DateEffective,now()+1)>	
					<cfelse>
						<cfset m = dateDiff("d",DateEffective,DateExpiration+1)>	
					</cfif>					
					<cfset total = total + d>
										
				</cfif>
							
			</cfif>
			
			<cfset prior = year(DateEffective)>
			<cfset posit = positionId>
			<cfset lastd = DateEffective>
			
	    </cfoutput>
		
		</table>
		
		</cf_divscroll>
	
	</td>
	</tr>
	
	<cfparam name="lastd" default="">
	
	<cfif lastd neq "">
		
		<tr style="height:30px;padding-bottom:10px" class="clsNoPrint">
			<td colspan="2">
				<table width="100%">				
					<tr style="padding-left:10px;border-bottom:1px solid black;border-top:1px solid black;background-color:000000;height:27px;">		
						<td style="padding-left:10px" colspan="7" class="labelmedium">
						<font color="FFFFFF">
							<cfoutput>
							Approximate cumulative work history in UNCS since #dateformat(lastd,client.dateformatshow)#:
							</cfoutput>
						</font>
						</td>
						<td class="labelmedium" align="center" style="padding-right:40px">
							<font color="FFFFFF">
								<cfoutput>
									<cfset y = int(total/365)>
									<cfset m = round((total - (y*365))/30)>
									<cfif y neq 0><b>#y#</b> year<cfif y neq "1">s</cfif> </cfif><b>#m#</b> month<cfif m neq "1">s</cfif> 
								</cfoutput>	
							</font>
						</td>				
					</tr>			
				</table>
			</td>
		</tr>
	
	</cfif>

</TABLE>

<cfif Hub.recordcount neq "0">
	<cfset AjaxOnLoad("doHighlight")>
</cfif>

<script>
	Prosis.busy('no')
</script>	