
<cfquery name="PositionParent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PositionParent 
	WHERE  PositionParentId = '#URL.ID#'
</cfquery>

<cfquery name="Period" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_MissionPeriod
	WHERE  Mission   = '#PositionParent.Mission#'
	AND    MandateNo = '#PositionParent.MandateNo#'
</cfquery>

<cfinvoke component  = "Service.Access"  
	  method         = "position" 
	  orgunit        = "#PositionParent.OrgUnitOperational#" 
	  role           = "'HRPosition'"
	  posttype       = "#PositionParent.PostType#"
	  returnvariable = "accessPosition">
	  
<cfif accessPosition eq "EDIT" or accessPosition eq "ALL">
    <cfset url.access  = "edit">
<cfelse>
	<cfset url.access = "view">   
</cfif>	  
  
<cfquery name="Org" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Organization
	WHERE OrgUnit = '#PositionParent.OrgUnitOperational#'
</cfquery>

<cfparam name="URL.Object"    default="">
<cfparam name="URL.Perc"      default="1">
<cfparam name="URL.action"    default="">
<cfparam name="URL.fundingid" default="">

<cfif url.action eq "del">

	<cftransaction>
		
		<cfquery name="getFunding" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   PositionParentFunding
			WHERE  FundingId = '#URL.FundingId#'
		</cfquery>

		<cfquery name="delete" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	DELETE FROM PositionParentFunding 
			WHERE  	PositionParentId = '#getFunding.PositionParentId#' 
			AND  	DateEffective    = '#getFunding.DateEffective#'
			-- AND 	DateExpiration   = '#getFunding.DateExpiration#'
		</cfquery>
		
		<cfquery name="getLastDate" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	MAX(DateExpiration) as DateExpiration
				FROM  	PositionParentFunding 
				WHERE 	PositionParentId = '#URL.ID#'
		</cfquery>

		<cfquery name="updatePreviousExpirationDates" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE 	PositionParentFunding 
				SET 	DateExpiration   = '#PositionParent.DateExpiration#'
				WHERE 	PositionParentId = '#URL.ID#'
				AND 	DateExpiration   = '#getLastDate.DateExpiration#'
		</cfquery>

	</cftransaction>
	
	<cfset url.fundingid = "">

</cfif>

<cfif url.action eq "save">
    <cfinclude template="PositionFundingEdit.cfm">
	<cfset url.fundingid = "">	
</cfif>

<cfquery name="getLastDate" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM  	 PositionParentFunding 
		WHERE 	 PositionParentId = '#URL.ID#'
		ORDER BY DateEffective DESC
</cfquery>

<cfquery name="Clear" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM PositionParentFunding  
	WHERE       PositionParentId = '#URL.ID#' 
	AND         Percentage = 0 
</cfquery>

<cfquery name="Funding" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   F.*, 
			 (SELECT Description FROM Program.dbo.Ref_Object WHERE Code = F.ObjectCode) as Description		    		    
    FROM     PositionParentFunding F
	WHERE    PositionParentId = '#URL.ID#'	
	 AND    ( RequisitionNo NOT IN (SELECT RequisitionNo FROM Purchase.dbo.RequisitionLine) OR  RequisitionNo is NULL							  
	)							   
	ORDER BY DateEffective, DateExpiration, Percentage DESC
</cfquery>

<cfquery name="Edition" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_AllotmentEdition E, Ref_AllotmentVersion V
	WHERE  (
	         EditionId IN (SELECT EditionId 
	                     FROM   Organization.dbo.Ref_MissionPeriod 
						 WHERE  Mission   = '#PositionParent.mission#'
						   AND  MandateNo = '#PositionParent.mandateno#')
			OR
			
			 EditionId IN (SELECT EditionIdAlternate 
	                     FROM   Organization.dbo.Ref_MissionPeriod 
						 WHERE  Mission   = '#PositionParent.mission#'
						   AND  MandateNo = '#PositionParent.mandateno#')			   
		  )				   
						   
	AND   E.Version = V.Code 					 
</cfquery>	

<cfquery name="FundList" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT Code
	FROM   Ref_AllotmentEditionFund EF, Ref_Fund E
	<cfif Edition.recordcount gte "1">
	WHERE  EditionId IN (#quotedvalueList(edition.editionid)#)
	<cfelse>
	WHERE  1=1
	</cfif>
	AND    Code = '#PositionParent.fund#'
	AND    EF.Fund = E.Code
</cfquery>			 

<cfif FundList.recordcount eq "0">
	
	<cfquery name="FundList" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT Code
		FROM   Ref_AllotmentEditionFund EF, Ref_Fund E
		<cfif Edition.recordcount gte "1">
		WHERE  EditionId IN (#quotedvalueList(edition.editionid)#)
		<cfelse>
		WHERE  1=1
		</cfif>
		AND    EF.Fund = E.Code
	</cfquery>			

</cfif>

<!--- show only relevant OE --->

<cfquery name="ObjectList" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Object
	<cfif URL.Object neq "">
	WHERE Code = '#URL.Object#'
	<cfelse>
	WHERE 1=1	
	</cfif>
	<!---
	AND Procurement = 0 
	--->
	AND ObjectUsage = '#edition.ObjectUsage#'			
</cfquery>


<cfquery name="ClassList" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_PostClass			
</cfquery>

<cfinvoke component="Service.Access"  
	  method         = "position" 
	  orgunit        = "#PositionParent.OrgUnitOperational#" 
	  role           = "'HRPosition'"
	  posttype       = "#PositionParent.PostType#"
	  returnvariable = "accessPosition">
	 
	
<cf_tl id="Save" var="1">
<cfset vsave=lt_text>		

<cfform name="processaction">   

<table border="0" align="center" width="99%" cellspacing="0" cellpadding="0" class="navigation_table formpadding">
    
	  <tr>
	  		    	    
	    <td>		
		    <table width="100%" border="0">
		
			<tr><td height="4"></td></tr>
		
			<tr class="line labelmedium">
			
				<td style="min-width:100px;padding-left:8px;"><cf_tl id="Effective"></td>		
				<td style="min-width:100px;padding-left:8px;"><cf_tl id="Expiration"></td>			
				<td style="padding-left:8px;"><cf_tl id="Center"></td>
				<td style="padding-left:8px;"><cf_tl id="Class"></td>
				<td style="padding-left:8px;"><cf_tl id="Fund"></td>				
				<td style="padding-left:8px;"><cf_tl id="Program/Project"></td>
				<td colspan="1" align="right" style="padding-left:18px;">%</td>								
				<td style="padding-left:12px;"><cf_tl id="Object of Expenditure"></td>
				<td></td>
				<cfif url.fundingid eq "" and url.access eq "edit">
				
				<td onclick="$('.clsAddNewPositionFunding').show();" align="center">
					<cfoutput>
						<cf_tl id="Add new" var="1">
						<img src="#session.root#/images/add_bluesquare.png" style="cursor:pointer; height:18px;" title="#lt_text#">
					</cfoutput>
				</td>
				<cfelse>
				<td></td>
				</cfif>
			
			</tr>
			
			<cfif funding.recordcount eq "0">
			
			<!---
				<tr><td colspan="7" align="center" class="labelit">No information to show in this view</td></tr>
				--->
			
			</cfif>
		
			<cfoutput query="Funding" group="DateEffective">
			
			<cfset fd  = Fund>
			<cfset obj = ObjectCode>

			<cfquery name="getFundingCluster" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	*
					FROM  	PositionParentFunding
					WHERE   PositionParentId = '#PositionParentId#'
				 	AND  	DateEffective = '#DateEffective#'
				 	AND   	DateExpiration = '#DateExpiration#'
			</cfquery>
																
			<cfif URL.fundingid eq FundingId>
												
				<TR class="navigation_row labelmedium line">
				
				   <td style="padding-left:8px;height:35px">

						<input type="hidden" value="#dateformat(dateeffective,CLIENT.DateFormatShow)#" name="dateeffective" id="dateeffective">
						#dateformat(dateeffective,CLIENT.DateFormatShow)#
						
				   </td>
				   
				    <td style="padding-left:8px;">
				   
					   	<input type="hidden" value="#dateformat(DateExpiration,CLIENT.DateFormatShow)#" name="dateexpiration" id="dateexpiration">
						<cfif DateExpiration gte DateEffective and DateExpiration lt PositionParent.DateExpiration>
						#dateformat(DateExpiration,CLIENT.DateFormatShow)#
						<cfelse>
						<cfif currentrow eq recordcount>
							<cf_tl id="End of position">
						<cfelse>	
						    --						
						</cfif>	
						</cfif>		
										
				   </td>

				   <td style="padding-left:8px;">#Org.OrgUnitCode#</td>
				   
				     <td style="padding-left:8px;">
				   		
					   	   <select name="fundclass" id="fundclass" class="regularxl" style="width:99%">								 			   				   
					           <cfloop query="ClassList">
							     <option value="#PostClass#" <cfif postclass eq fundclass>selected</cfif>>#PostClass#</option>
							   </cfloop>
					   	   </select>
					  
				   </td>

				   <td style="padding-left:8px;">
				   		<cfif getFundingCluster.recordCount lt 2>
					   	   <select name="fund" id="fund" class="regularxl" style="width:99%">	
							   <option value="#fd#" selected>#fd#</option>					   				   
					           <cfloop query="FundList">
							     <option value="#Code#">#Code#</option>
							   </cfloop>
					   	   </select>
					   	<cfelse>
					   		<input type="hidden" name="fund" id="fund" value="#fd#">
					   		#fd#
				   		</cfif>
				   </td>
				   					
					  <!--- Query returning search results --->
					  
				      <cfquery name="Prg"
				          datasource="AppsProgram" 
				          username="#SESSION.login#" 
				          password="#SESSION.dbpw#">
				          SELECT *
					      FROM   Program P, ProgramPeriod Pe
					      WHERE  P.ProgramCode = Pe.ProgramCode
						  AND    P.ProgramCode = '#Funding.ProgramCode#'						      
						  AND    Pe.Period IN (SELECT  TOP 1 Period 
						                       FROM    Organization.dbo.Ref_MissionPeriod 
											   WHERE   Mission   = '#PositionParent.mission#'
											   AND     MandateNo = '#PositionParent.mandateno#'
											   ORDER BY DefaultPeriod DESC)
					  </cfquery>	
					  
					 										  
					  <cfif prg.recordcount eq "0">
					  					  
					    <cfquery name="Prg"
				          datasource="AppsProgram" 
				          username="#SESSION.login#" 
				          password="#SESSION.dbpw#">
				          SELECT *
					      FROM   Program P
					      WHERE  P.ProgramCode = '#Funding.ProgramCode#'						  				
					    </cfquery>	
						
					  </cfif>	
					  
					  <td class="labelit" style="padding-left:8px;">	

					  	  <cfif getFundingCluster.recordCount lt 2>
					 
						  <table cellspacing="0" cellpadding="0">
						  
							  <tr>
								  <td>

									  <img src="#SESSION.root#/Images/search.png" 
										  alt="Select Program" 
										  name="img5" 
										  onMouseOver="document.img5.src='#SESSION.root#/Images/contract.gif'" 
										  onMouseOut="document.img5.src='#SESSION.root#/Images/search.png'"
										  style="cursor: pointer;" 
										  width="23" 
										  height="23" 
										  border="0" 
										  style="border-color:silver"						 
										  align="absmiddle" 
										  onClick="selectprogram('#PositionParent.mission#','','applyprogram','')">						  
									  
								  </td>
								  
								  <td> 							 		  
									  <input type="text" id="programdescription" name="programdescription" value="#Prg.ProgramName#" class="regularxl" size="35" maxlength="60" readonly style="width:99%">
									  <input type="hidden" id="programcode" name="programcode" value="#Funding.ProgramCode#">							  
								  </td>
								  
							  </tr>
							  
						  </table> 

						  <cfelse>

						  	<input type="hidden" name="programcode" id="programcode" value="#Funding.ProgramCode#">
					   		<cfif isDefined("prg.reference")>#Prg.Reference#<cfelse>#Prg.ProgramCode#</cfif> #Prg.ProgramName#

						  </cfif>				
					 					 
				   </td>

				   <td align="right" style="padding-left:8px;">#numberformat(percentage*100, ",")#</td>				 				 
					   
				   <td style="padding-left:15px;">
				   
					   <select name="objectcde" id="objectcode" class="regularxl" style="width:99%">
					   <option value="">[Defined through Payroll Lines]</option>
				           <cfloop query="ObjectList">
							   <option value="#Code#" <cfif obj eq Code> SELECTED</cfif>>
								 #Code# #Description#
							   </option>
						   </cfloop>
				   	   </select>
					   
				   </td>
				 	
				   <td colspan="2" align="center" style="padding-left:8px;padding-right:5px">	
					   <input class="button10g" style="width:55;height:25" type="button" name="save" value="#vSave#" onclick="javascript:funding('','#fundingid#','save',processaction.fund.value,fundclass.value,processaction.objectcde.value,processaction.programcode.value,processaction.dateeffective.value,processaction.dateexpiration.value)">
				   </td>
	
			    </TR>	
				
			<cfelse>
			
				<TR class="navigation_row labelmedium line" style="height:30px">
				   <td style="padding-left:8px;">#Dateformat(dateeffective,CLIENT.DateFormatShow)#</td>	
				   <td style="padding-left:8px;">
				  				   
				   <cfif DateExpiration gte DateEffective 
				       and DateExpiration LT PositionParent.DateExpiration>
					   #dateformat(DateExpiration,CLIENT.DateFormatShow)#
				   <cfelse>
				   <font color="808080"><i>
				   <cfif currentrow eq recordcount>
							<cf_tl id="End of position">
						<cfelse>
							--
						</cfif>	
				  
				   </cfif>
				   </td>					   				  
				   <td style="padding-left:8px;">#Org.OrgUnitCode#</td>
				   <td style="padding-left:8px;">#FundClass#</td>  		
				   <td style="padding-left:8px;">#Fund#</td>				   	   
					   
					    <!--- check if project is valid --->
				
					<cfquery name="Periods"
					    datasource="AppsProgram" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
					      SELECT   Pe.Period
						  FROM     Ref_Period AS R INNER JOIN
					               ProgramPeriod AS Pe ON R.Period = Pe.Period INNER JOIN
				                   Program AS P ON Pe.ProgramCode = P.ProgramCode
						  WHERE    R.isPlanningPeriod = 1 
						  AND      Pe.ProgramCode     = '#ProgramCode#' 
						  AND      RecordStatus != '9'
						  -- AND      R.DateEffective   <= '#Dateformat(dateeffective,CLIENT.DateSQL)#'
						  AND      R.DateExpiration  >= '#Dateformat(dateeffective,CLIENT.DateSQL)#'					  				  				
				    </cfquery>	
					
					<cfif Periods.recordcount eq "0">
										
						<cfset cl = "color:red;text-decoration: line-through;">
					
					<cfelse>
					
						<cfset cl = "color:black">
					
					</cfif>
									   
				     <!--- Query returning search results --->
				      <cfquery name="Prg"
				          datasource="AppsProgram" 
				          username="#SESSION.login#" 
				          password="#SESSION.dbpw#">
				          SELECT *
					      FROM   Program P, ProgramPeriod Pe
					      WHERE  P.ProgramCode = '#ProgramCode#'
						  AND    P.ProgramCode = Pe.ProgramCode
						  AND    Pe.Period IN (SELECT TOP 1 Period 
						                       FROM   Organization.dbo.Ref_MissionPeriod 
											   WHERE  Mission    = '#PositionParent.mission#'
											   AND    MandateNo  = '#PositionParent.mandateno#'
											   ORDER BY DefaultPeriod DESC)
					  </cfquery>	
					  
					  <cfif prg.recordcount gte "1">
					  
					   <td style="#cl#;padding-left:8px;">#Prg.Reference#&nbsp;#Prg.ProgramName#
					  
					  <cfelse>
					  
					    <cfquery name="Prg"
				          datasource="AppsProgram" 
				          username="#SESSION.login#" 
				          password="#SESSION.dbpw#">
				          SELECT *
					      FROM   Program P
					      WHERE  P.ProgramCode = '#ProgramCode#'						  				
					    </cfquery>	
						
						<td style="#cl#;padding-left:8px;">#Prg.ProgramName# 
											  
					  </cfif>	
					  
					  <cfloop query="Periods">
											
						#Period#<cfif currentrow neq recordcount>;</cfif>
					
					  </cfloop>
					  					  
				   </td>	
				   
				   <td align="right" style="padding-left:4px">
				  					   
					   <table>
					   	   <tr>		
						   <cfif url.access eq "edit">
						   <td><cf_img icon="edit" onclick="editFunding('#PositionParentId#','#fundingid#');"></td>						 
						   </cfif>		   
						   <td>#numberformat(percentage*100, ",")#</td>						   
						   </tr>
					   </table>			   
				   
				   </td>
				   				   

				   <td style="padding-left:15px;">
					   <cfif ObjectCode eq "">
					   [defined through Payroll]
					   <cfelse>
					   #ObjectCode# #Description#
					   </cfif> 
				   </td>
				   
				   <td align="center" style="padding-left:8px;">
				   
				   	   <cfif RequisitionNo eq "">
				   
						   <cfif URL.Access eq "Edit">								   			   
						   		<cf_img icon="edit" navigation="Yes" onClick="funding('','#FundingId#','edit')">					   
						   </cfif>		 		   
					   
					   </cfif>
					  
				   </td>
				   
				   <td align="center" style="padding-right:5px">
				   
				   	<cfif URL.Access eq "Edit">
					
						<cfif getLastDate.dateEffective eq dateEffective>
							<cf_img icon="delete" onClick="funding('','#FundingId#','del')">				        
						</cfif>
									   
				     </cfif>	
					 
				   </td>
				   
			    </TR>	
													
			</cfif>

			<cfset cntRows = 1>

		    <cfoutput>

		    	<cfif cntRows gt 1>

			    	<cfquery name="Prg"
				          datasource="AppsProgram" 
				          username="#SESSION.login#" 
				          password="#SESSION.dbpw#">
				          SELECT *
					      FROM   Program P, ProgramPeriod Pe
					      WHERE  P.ProgramCode = '#Funding.ProgramCode#'
						  AND    P.ProgramCode = Pe.ProgramCode
						  AND    Pe.Period IN (SELECT  TOP 1 Period 
						                       FROM    Organization.dbo.Ref_MissionPeriod 
											   WHERE   Mission   = '#PositionParent.mission#'
											   AND     MandateNo = '#PositionParent.mandateno#'
											   ORDER BY DefaultPeriod DESC)						 
						  					   
					  </cfquery>	
					  
					  										  
					  <cfif prg.recordcount eq "0">
					  					  
					    <cfquery name="Prg"
				          datasource="AppsProgram" 
				          username="#SESSION.login#" 
				          password="#SESSION.dbpw#">
				          SELECT *
					      FROM   Program P
					      WHERE  P.ProgramCode = '#Funding.ProgramCode#'						  				
					    </cfquery>	
						
					  </cfif>
					  <tr class="labelmedium" style="height:15px">
				    	<td width="60px" style="padding-left:8px;"></td>		
						<td width="60px" style="padding-left:8px;"></td>			
						<td style="padding-left:8px;"></td>
						<td style="padding-left:8px;"></td>
						<td style="padding-left:8px;">#Fund#</td>
						<td style="padding-left:8px;"><cfif isDefined("prg.reference")>#Prg.Reference#<cfelse>#Prg.ProgramCode#</cfif> #Prg.ProgramName#</td>
						<td align="right" style="width:40px">#percentage*100#</td>
						<td style="padding-left:12px;"></td>
						<td></td>
						<td></td>
					  </tr>

				  </cfif>

				  <cfset cntRows = cntRows + 1>

		    </cfoutput>
			
			
			</cfoutput>
			
		
		<cfif url.access eq "edit">		

			<cfset vInitialDate = PositionParent.DateEffective>
				   						
			<cfif getLastDate.DateEffective neq "">												
				<cfset vInitialDate = dateAdd('m', 1, getLastDate.DateEffective)>				
			</cfif>
				
			<cfif URL.fundingid eq "" or URL.fundingid eq "New">
															
			<tr><td height="3"></td></tr>
							
			<TR class="clsAddNewPositionFunding line" style="display:none;">		
				   <td style="padding-left:8px;min-width:150px">
				   	
					   	<cf_intelliCalendarDate9
							FieldName="dateeffective" 
							Default="#Dateformat(vInitialDate, client.dateformatshow)#"
							DateValidStart="#Dateformat(vInitialDate, 'YYYYMMDD')#"
							DateValidEnd="#Dateformat(PositionParent.DateExpiration, 'YYYYMMDD')#"		
							class="regularxl"
							style="border:0px"
							AllowBlank="False">	
				   
				   </td>
				   
				    <td style="padding-left:8px;">
						<cfoutput>
							<cfinput type="hidden" value="" name="dateexpiration" id="dateexpiration">
							<cf_tl id="End of position">
							<!--- #dateformat(PositionParent.DateExpiration,CLIENT.DateFormatShow)# --->
				   		</cfoutput>
				   </td>

				   <td class="labelmedium" style="padding-left:8px;"><cfoutput>#Org.OrgUnitCode#</cfoutput></td>
				   
				     <td style="padding-left:8px;">
				   		
					   	   <select name="fundclass" id="fundclass" class="regularxl" style="border:0px;width:99%">	
							 			   				   
					           <cfoutput query="ClassList">
							     <option value="#PostClass#">#PostClass#</option>
							   </cfoutput>
					   	   </select>
					  
				   </td>
					
				   <td style="padding-left:8px;">
				  				   
					   <select name="fund" id="fund" class="regularxl" style="border:0px;width:99%">
				           <cfoutput query="FundList">						   
						     <option value="#Code#">#Code#</option>
						   </cfoutput>
				   	   </select>
					   
				   </td>
				  				  
					   
				   <td style="padding-left:8px;">			   
				   
				   	<table cellspacing="0" cellpadding="0"><tr><td>
				   
				  		<cfoutput>		
												  
												
					  		<img src="#SESSION.root#/Images/search.png" 
							  alt="Select Program" 
							  name="img5" 
							  onMouseOver="document.img5.src='#SESSION.root#/Images/contract.gif'" 
							  onMouseOut="document.img5.src='#SESSION.root#/Images/search.png'"
							  style="cursor: pointer;" 
							  width="25" 
							  height="23" 
							  border="0" 
							  style="border-color:silver"						 
							  align="absmiddle" 
							  onClick="selectprogram('#PositionParent.mission#','','applyprogram','')">

						</cfoutput>		
						
						</td>
						
						<td style="padding-left:2px">   
								  
						<input type="text"    id="programdescription" name="programdescription" value="" class="regularxl" size="25" maxlength="60" readonly style="border:0px;width:99%">
						<input type="hidden"  id="programcode"        name="programcode"        value="" maxlength="20" readonly>
						
						</td></tr></table>
						
				   </td>

				   <td style="padding-left:8px;">100</td>
					   
				   <td style="padding-left:15px;">
					   <select name="objectcde" id="objectcode" class="regularxl" style="width:99%;border:0px">
					        <option value=""><cf_tl id="Payroll item [recommended]"></option>
				           <cfoutput query="ObjectList">
						     <option value="#Code#">#Code# #Description#</option>
						   </cfoutput>
				   	   </select>
				   </td>
				   								   
				   <td colspan="2" align="center" style="padding-left:5px;padding-right:5px">
					   
					   <cfoutput>
					  	 <input class="button10g" style="width:55;height:25" type="button" name="save" value="#vSave#" onclick="funding('','','save',processaction.fund.value,processaction.fundclass.value,processaction.objectcde.value,processaction.programcode.value,processaction.dateeffective.value,processaction.dateexpiration.value)">
					   </cfoutput>
					   
					</td>   
					   
				</TR>	
					
				<tr><td height="3"></td></tr>
			
			</table>		
			</td>
			</tr>	
			
			</cfif>
			
		</cfif>	
				
</table>

</cfform>		

<cfset ajaxonload("function(){ doHighlight(); doCalendar(); }")>
<cfif URL.fundingid neq "">
	<cfset ajaxOnLoad("function(){ $('.date-picker-control').hide(); }")>
</cfif>