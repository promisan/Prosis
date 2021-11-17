

<cfparam name="url.mid" default="">

<cfquery name="Object" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_Object
	WHERE     Code = '#url.objectcode#'
</cfquery>

<cfset submithide = "0">

<cfset budgetperiod = url.period>

<cfset partialalloted = "0">

<cfif url.requirementid neq ""> 
 
	<cfset id = url.requirementid>	
	 	 
	<cfquery name="Requirement" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      ProgramAllotmentRequest
		WHERE     RequirementId = '#url.requirementid#'
	</cfquery>
		
   <!--- check if the requirement was partially alloted which prevents it from changing the fund --->
				   			   
   <cfquery name="getAllotmentStatus" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  
			   SELECT  *
			   FROM    ProgramAllotmentRequest PAR, 
			           ProgramAllotmentDetailRequest PADR, 
					   ProgramAllotmentDetail S
			   WHERE   PAR.RequirementIdParent = '#Requirement.RequirementIdParent#' <!--- alert : adjusted to consider the full transaction includes ripples and travel complex --->				   
			  	   
			   AND     PAR.RequirementId     =  PADR.RequirementId
			   AND     PADR.TransactionId    =  S.TransactionId				      
			   AND     PADR.Amount <> '0' <!--- indeed used in allotment --->
			   AND     S.Status IN ('1','9')

    </cfquery>	
		
	<cfif getAllotmentStatus.recordcount gt "1">
	
		<cfset partialAlloted = "1">
		
	</cfif>		
	
	<cfquery name="CheckObject" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_Object
		WHERE     Code = '#Requirement.objectcode#'
	</cfquery>
	
	<cfif Requirement.ObjectCode neq url.objectcode and (CheckObject.RequirementMode gte "2" or Object.RequirementMode gte "2")>		
	
	    <cf_assignid>
		<cfset id  = rowguid>
		<cfset par = rowguid>
		
		<input type="hidden" name="requirementid" id="requirementid" value="">
	
	<cfelse>
		
		<cfset par = Requirement.RequirementIdParent>
		<!--- used for OE changes --->		
		<cfoutput>
		 <input type="hidden" name="requirementid" id="requirementid" value="#url.requirementid#">
		</cfoutput>
	
	</cfif>
		 
<cfelse>

    <cf_assignid>
	<cfset id  = rowguid>
	<cfset par = rowguid>
		
	<input type="hidden" name="requirementid" id="requirementid" value="">
	
</cfif>


<cfparam name="url.itemmaster" default="">

<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Program P, ProgramPeriod Pe
	WHERE     P.ProgramCode  = Pe.ProgramCode
	AND       P.ProgramCode  = '#url.programcode#' 
	AND       Pe.Period       = '#url.period#' 	
</cfquery>

<cfset orgunit = program.orgunit>

<cfquery name="Settings" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      ProgramAllotment
	WHERE     ProgramCode    = '#url.programcode#' 
	AND       Period         = '#url.period#' 
	AND       EditionId      = '#URL.Editionid#'	
</cfquery>

<cfquery name="Fund" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_Fund	
	WHERE     Code IN (SELECT Fund 
	                   FROM   Ref_AllotmentEditionFund 
					   WHERE EditionId = '#url.editionid#')					   
						   
	<cfif settings.FundEnforce eq "1" and Settings.Fund neq "">
	AND      (
	         Code = '#Settings.Fund#' 
			 <cfif url.requirementid neq "">
	         OR Code = '#Settings.Fund#'
			 </cfif>
			 )
	</cfif>		
	ORDER BY ListingOrder		   
	
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_ParameterMission
	WHERE     Mission = '#Program.Mission#'	
</cfquery>

<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_AllotmentEdition
	WHERE     EditionId      = '#URL.Editionid#'	
</cfquery>

 <cfquery name="Period" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_Period
	WHERE     Period = '#Edition.period#' 	
  </cfquery>		
  
			   
 <cfquery name="Closure" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    MAX(RequirementDate) as RequirementStart
	FROM      Ref_AllotmentEditionFundObject
	WHERE     Editionid       = '#Edition.EditionId#' 	
	AND       ObjectCode      = '#url.objectcode#'
	AND       RequirementDate > '#Period.DateEffective#' 
	AND       RequirementEntryMode = 0 
	AND       Operational     = 1
 </cfquery>	
 
 <!--- Hanno 8/10/2015 now we define in addition the last allotment being issues --->
  	  
<cfquery name="LastAllotment" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    MAX(ActionDate) as ActionDate
	FROM      ProgramAllotmentAction
	WHERE     ProgramCode    = '#url.programcode#' 
	AND       Period         = '#url.period#' 
	AND       EditionId      = '#URL.Editionid#'
	AND       ActionClass     = 'Transaction' 	
</cfquery>

<cfif LastAllotment.ActionDate lt Closure.RequirementStart>

	<cfset closuredate = LastAllotment.ActionDate>
	
<cfelse>	

	<cfset closuredate = Closure.RequirementStart>

</cfif>  
		  
<cfquery name="Entry" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      ProgramAllotmentRequest
	WHERE     ProgramCode    = '#url.programcode#' 
	AND       Period         = '#url.period#' 
	AND       EditionId      = '#URL.Editionid#'
	AND       RequirementId  = '#id#' 	
</cfquery>

<cfinvoke component="Service.Access"  
	Method         = "budget"
	ProgramCode    = "#URL.Programcode#"
	Period         = "#url.period#"		
	EditionId      = "#url.editionid#" 			
	Role           = "'BudgetManager'"
	ReturnVariable = "BudgetManagerAccess">		

<!--- check if this transaction is cleared --->

<cfquery name="Allotment" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      ProgramAllotmentDetail T
	WHERE     TransactionId IN (SELECT TransactionId 
	                            FROM   ProgramAllotmentDetailRequest 
								WHERE  TransactionId = T.TransactionId
								AND    Requirementid ='#id#')	
</cfquery>

<cfif Allotment.Status eq "1" and getAdministrator("*") eq "0" and url.mode neq "Add">  <!--- wildcard added for admin only --->
	<cfset url.mode = "view">
</cfif>

<cfquery name="ItemMaster" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    IM.*, IMM.CodeDisplay
	FROM      ItemMaster IM LEFT OUTER JOIN
	          ItemMasterMission IMM	ON IM.Code = IMM.ItemMaster AND IMM.Mission = '#Program.Mission#'
	WHERE     Code IN  (SELECT ItemMaster 
	                    FROM   ItemMasterObject 
					    WHERE  ObjectCode = '#url.objectcode#')
	AND       (Operational = 1 or Code = '#Entry.ItemMaster#')
</cfquery>

<cfif entry.itemmaster neq "" and (url.itemmaster eq "" or url.itemmaster eq "undefined")>
     <cfset url.itemmaster = entry.itemmaster>
</cfif>

<cfoutput>

<cfform name="formrequest" onsubmit="return false" method="post">		

<table class="formpadding" width="98%" align="center" border="0">

<tr class="hide"><td id="process"></td></tr>

<tr><td style="padding-left:6px;padding-right:4px;border:1px solid silver">

	<table class="formpadding" align="center" width="99%" border="0">
						  
		   <input type="hidden"   name="ProgramCode" id="ProgramCode" value="#url.ProgramCode#">
		   <input type="hidden"   name="Period"      id="Period"      value="#url.Period#">
		   <input type="hidden"   name="EditionId"   id="EditionId"   value="#url.EditionId#">	  
		   <input type="hidden"   name="ObjectCode"  id="ObjectCode"  value="#url.objectcode#">
		  		   		   	 	   
		    <tr>
			   <td class="labelmedium" height="20"><cf_tl id="Fund">:</td>
			   <TD class="labelmedium" colspan="2">			
			   
			   <table>
			   <tr>
			   <td>   
			   			   
			   <cfif URL.Mode neq "edit" and url.mode neq "add">
	
				    #entry.fund#
					
					<cfset initfund = entry.fund>
					
			   <cfelseif partialAlloted eq "1">	
			   
			   		#entry.fund# <font color="FF0000">: <cf_tl id="transaction partially allotted"></font>
					
					<!--- we no longer allow for changes of the fund here --->
					
					<input type="hidden" name="Fund" id="fund" value="#entry.Fund#">
					
					<cfset initfund = entry.fund>
										
			   <cfelse>
			   			   
			   	   <cfif entry.fund eq "">
				  
				   	   <select name="fund" id="fund" class="regularxl enterastab" style="width:80px" 
					      onchange="javascript:reloadmatrix('#edition.period#','#id#');ptoken.navigate('#session.root#/ProgramREM/Application/Budget/Request/getContribution.cfm?mode=edit&requirementid=#url.requirementid#&programcode=#url.programcode#&fund='+this.value+'&period=#url.period#','contributionresult')">
						   <cfloop query="Fund">
						   <option value="#Code#" <cfif settings.fund eq code>selected</cfif>>#Description#</option>
						   </cfloop>
					   </select>
					   <cfif settings.fund eq "">
					   	 <cfset initfund = fund.code>
					   <cfelse>
					   	 <cfset initfund = settings.fund>
					   </cfif>
					 				   					   
				   <cfelse>
			   
					   <select name="fund" id="fund" class="regularxl enterastab" style="width:80px" 
					     onchange="javascript:reloadmatrix('#edition.period#','#id#');ptoken.navigate('#session.root#/ProgramREM/Application/Budget/Request/getContribution.cfm?mode=edit&requirementid=#url.requirementid#&programcode=#url.programcode#&fund='+this.value+'&period=#url.period#','contributionresult')">
						   <cfloop query="Fund">
						   <option value="#Code#" <cfif entry.fund eq code>selected</cfif>>#Description#</option>
						   </cfloop>
					   </select>
					   <cfset initfund = entry.fund>
				   
				   </cfif>
			   
			   </cfif>
			   
			   </td>
			   
			    <!--- ---------------------- --->
				<!--- special classification --->
				<!--- ---------------------- --->
				   
				<cfif parameter.budgetCategory neq "">
				   
					   <td style="padding-left:20px" class="labelmedium" height="20"><cf_tl id="Classification">:</td>
					   <TD style="padding-left:10px"  colspan="2">
					   
					   <cfif URL.Mode neq "edit" and url.mode neq "add">
					   
					   	<cfquery name="Display" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT    *
								FROM      Ref_ProgramCategory
								WHERE     Code = '#entry.budgetCategory#'			
							</cfquery>
			
						    #display.Description#
							
					   <cfelse>
					   
					   		<cfquery name="qClass" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT    *
								FROM      Ref_ProgramCategory
								WHERE     Parent = '#parameter.budgetCategory#'			
							</cfquery>
					   
						   <select name="BudgetCategory" class="regularxl enterastab" style="width:148px">			             
							   <cfloop query="qClass">
							   <option value="#Code#" <cfif entry.budgetCategory eq code>selected</cfif>>#Description#</option>
							   </cfloop>
						   </select>
					   
					   </cfif>
					   
					   </TD>
				  		   
				</cfif>  	
				
				</tr>
				</table>		   					   
			   			   
			   </TD>
		   </tr>
		   		   
			<cfquery name="Fund" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   *
				FROM     Ref_Fund
				WHERE    Code = '#initfund#'	
			</cfquery>
			
			<cfif Fund.FundingMode neq "Donor">
				<cfset  cl = "hide">
			<cfelse>
				<cfset  cl = "regular">
			</cfif>
		   
		   <tr id="contributionbox" class="#cl#"> 
		   
		   	<td style="padding-left:4px" class="labelmedium" height="26" width="150"></td>
		    <td  colspan="2">
			
			 <table width="100%">
			 <tr>
			 
				 <td style="padding-left:0px" id="contributionresult">
				 						
					<cfset url.fund = initfund>			
					 										
					<cfinclude template="getContribution.cfm">															
													 
				 </td>		
				 
				 <td id="contributionselect" valign="top" style="padding-left:2px;padding-top:2px">
				 				 
				  <img src="#SESSION.root#/Images/search.png" alt="Select item master" name="img16" 
					onMouseOver="document.img16.src='#SESSION.root#/Images/contract.gif'" 
					onMouseOut="document.img16.src='#SESSION.root#/Images/search.png'"
					style="cursor: pointer;" alt="" width="16" height="16" border="0" align="absmiddle" 
					onClick="getcontribution('#url.requirementid#',document.getElementById('fund').value,'#url.programcode#','#url.period#')">		
				 
				 </td>	
				 
			 </tr>				 
			 </table>
			
			</td>
		   </tr>
		   
						
		   <cfif url.activityid neq "" and url.requirementid eq "">
		   		   
				<!--- we link by default --->   
			   <input type="hidden" name="ActivityId" value="#url.activityid#">		   
			      			   
		   <cfelse>  			  		   
			   <!--- ---------------------- --->
			   <!--- ----- Activity ------- --->
			   <!--- ---------------------- --->
			   
			   <!--- in this case location is inherited --->
			   
			    <cfquery name="Period" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    *
					FROM      Ref_Period	
					WHERE     Period        = '#url.period#' 					
				</cfquery>  
					   	   
			   <cfquery name="Activity" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    *
					FROM      ProgramActivity			
					WHERE     ProgramCode         = '#url.programcode#' 
					AND       ActivityDateEnd    >= '#Period.DateEffective#'
					AND       ActivityDateStart  <= '#Period.DateExpiration#'
					<!---
					AND       ActivityPeriod      = '#url.period#' 			
					--->
					AND       (Activitydescription > ''	or  ActivityDescriptionShort > '')
					AND       RecordStatus != '9'
					ORDER BY  ActivityDateStart
				</cfquery>  
																										
				<cfif Activity.recordcount gt "0">
												
				<tr>
				   <td class="labelmedium" width="120"><cf_tl id="Activity">:</td>
				   <TD height="20" colspan="2">		
				   
				    <table cellspacing="0" cellpadding="0">
					<tr><td>
				    				   				
					<select name="ActivityId" id="activityid" class="enterastab regularxl" style="width:350px" onchange="if (this.value=='') { document.getElementById('activitybox').className = 'hide' } else { document.getElementById('activitybox').className = 'regular' }">
					
					    <option value=""> <cf_tl id="Multiple"> </option>
						<cfloop query="Activity">
							<option value="#ActivityId#" <cfif activityId eq entry.ActivityId>selected</cfif>><cfif ActivityDescriptionShort neq "">#ActivityDescriptionShort#<cfelse>#left(ActivityDescription,260)#</cfif></option>
						</cfloop>
							
					</select>
					
					</td>
					
					<cfif entry.activityId eq "">
						<cfset cl = "Hide">
					<cfelse>
					    <cfset cl = "Regular">
					</cfif>
					
					<td style="padding-left:2px" id="activitybox" class="#cl#">
														  							 
						  <img src="#SESSION.root#/Images/search.png" alt="Select item master" name="img6" 
								onMouseOver="document.img6.src='#SESSION.root#/Images/button.jpg'" 
								onMouseOut="document.img6.src='#SESSION.root#/Images/search.png'"
								style="cursor: pointer;" alt="" width="24" height="23" border="0" align="absmiddle" 
								onClick="programactivity('#url.programcode#','#url.period#',document.getElementById('activityid').value)">
					
					</td>
					
					</tr>
					</table>
					
					</td>
					
				</tr>	
				
				<cfelse>
				
					<input type="hidden" name="ActivityId" value="">
						
				</cfif>
				
			</cfif>					
			
		   <!--- -------------- --->	  
		   <!--- OrgUnit source --->
		   <!--- -------------- --->
		   
		   <cfif Object.RequirementUnit eq "1">
		   
			   <tr>
			   
			    <td class="labelmedium"><cf_tl id="OrgUnit">:</TD>
			    <td align="left" valign="top" colspan="2">	
					  
					  <cfquery name="Org"
			          datasource="AppsOrganization" 
			          username="#SESSION.login#" 
			          password="#SESSION.dbpw#">
				          SELECT * 
						  FROM   Organization 
						  WHERE  OrgUnit = '#Entry.ResourceUnit#'
				      </cfquery>	
					  
					  <cfif Org.recordcount eq "0">
					  
					   <cfquery name="Org"
			          datasource="AppsOrganization" 
			          username="#SESSION.login#" 
			          password="#SESSION.dbpw#">
				          SELECT * 
						  FROM   Organization 
						  WHERE  OrgUnit = '#OrgUnit#'
				      </cfquery>	
					  
					  </cfif>	
					  
					  <cfoutput>	
					  				
						  <table><tr><td> 				  							 
						    
						  <input type="text"   name="orgunitname"  id="orgunitname" value="#Org.OrgUnitName#" class="regularxl" size="43" maxlength="60" readonly ondblclick="document.getElementById('orgunitname').value = ''; document.getElementById('orgunit').value = ''">
						  
						  </td>
						  
						  <td style="padding-left:2px;">
						  
						  <input type="hidden" name="mission"      id="mission"     class="disabled" size="20" maxlength="20" readonly>
					   	  <input type="hidden" name="orgunit"      id="orgunit"     value="#Entry.ResourceUnit#">
						  <input type="hidden" name="orgunitcode"  id="orgunitcode">
					  	  <input type="hidden" name="orgunitclass" id="orgunitclass">
						  
						  	  <img src="#SESSION.root#/Images/search.png" alt="Select" name="img4" 
							onMouseOver="document.img4.src='#SESSION.root#/Images/contract.gif'" 
							onMouseOut="document.img4.src='#SESSION.root#/Images/search.png'"
							style="cursor: pointer;border:1px solid gray" alt="" width="24" height="23" border="0" align="absmiddle" 
							onClick="selectorgN('#program.mission#','','orgunit','applyorgunit','','0','')">
						    </td></tr></table>						
					  
					  </cfoutput>	
					  
				 </td>								
		       </tr>		
		  
		   </cfif>			 
		   
		     	   	   
		  <!--- ------------------------ --->
		  <!--- ------ Custom fields --- --->
		  <!--- ------------------------ --->
		   
		  <cfinclude template="CustomFields.cfm">			  	  
		  
		  <cfif Object.RequirementPeriod eq "0">
		  
		  	  <!--- ----------------- --->
			  <!--- single entry mode --->
			  <!--- ----------------- --->
				    
			 <tr>
				   <td class="labelmedium"><cf_tl id="Due date">:</td>
				   <TD class="labelmedium" colspan="2">				   
				   				   
				    <cfif URL.Mode neq "edit" and url.mode neq "add">
					
						#Dateformat(entry.RequestDue, CLIENT.DateFormatShow)#
					
					<cfelse>							 				  
												
						  <cfif Entry.RequestDue eq "" or url.mode eq "Add">						  						
						  
						  	  <cfif ClosureDate gte Period.DateEffective>
							  	<cfset dt = Dateformat(ClosureDate, CLIENT.DateFormatShow)>
								<cfset sd = ClosureDate>
							  <cfelse>
						      	<cfset dt = Dateformat(Period.DateEffective, CLIENT.DateFormatShow)>
								<cfset sd = Period.DateEffective>
							  </cfif>							  						  
							
						  <cfelse>
						  						  
						  	  <cfset dt = Dateformat(Entry.RequestDue, CLIENT.DateFormatShow)>
							  <cfif ClosureDate gte Period.DateEffective and ClosureDate lte Entry.RequestDue>
							  	  <cfset sd = ClosureDate>
							  <cfelse>
								  <cfset sd = Period.DateEffective>
							  </cfif>	  
						  
						  </cfif>	
						  						  
						  <cfif BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL">
						  
						  	   <!--- no limitation --->						  
							  <cfset sd = Period.DateEffective>
							  
						  </cfif>	
						  						  
						  <cfif sd lt Period.DateExpiration and BudgetManagerAccess eq "NONE">
						  
							  <cf_intelliCalendarDate9
								FieldName      = "RequestDue" 
								DateValidStart = "#Dateformat(sd, 'YYYYMMDD')#"
								DateValidEnd   = "#Dateformat(Period.DateExpiration, 'YYYYMMDD')#"							
								Default        = "#dt#"
								Manual         = "False"	
								AllowBlank     = "False"						
								class          = "regularxl enterastab">	   
							
						  <cfelse>
						  
							   <cf_intelliCalendarDate9
								FieldName      = "RequestDue" 
								DateValidStart = "#Dateformat(sd, 'YYYYMMDD')#"									
								Default        = "#dt#"
								AllowBlank     = "False"	
								Manual         = "False"					
								class          = "regularxl enterastab">	   
						  
						  </cfif>			   					   
							  
					
					</cfif>
				   
				   </TD>
		    </tr>		
							
		 </cfif>	
		 
		 
		<cfquery name="Mode" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      ItemMasterObject
				WHERE     ItemMaster  = '#url.itemmaster#'
				AND       ObjectCode  = '#url.objectcode#'
		</cfquery>

		 		 
		 <!--- ------------------ --->
		 <!--- financial location --->
		 <!--- ------------------ --->		
		 		
		     <cfif parameter.BudgetLocation eq "Staffing">
		
						 
			 	 <cfquery name="LocationList" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   L.LocationCode,L.LocationName as Description,0 as LocationDefault, (SELECT Name FROM System.dbo.Ref_Nation WHERE Code = L.Country) as Name
						FROM     Location L
						WHERE    L.Mission = '#Program.Mission#'										
						ORDER BY L.LocationName,L.LocationCode		
					</cfquery>
								
			 	 
		     <cfelse>	
		
			 		 
				 <cfquery name="LocationList" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   N.Code,N.Name,L.LocationCode,L.Description,LocationDefault
						FROM     Ref_PayrollLocation L, 
						         System.dbo.Ref_Nation N,
								 Ref_PayrollLocationMission M
						WHERE    L.LocationCountry = N.Code
						AND      M.LocationCode = L.LocationCode
						AND      M.Mission = '#Program.Mission#'	
						AND      N.Code != 'UUU'	
						AND      M.BudgetPreparation = 1			
						ORDER BY M.LocationDefault DESC, L.Description, N.Name, L.LocationCode
						
					</cfquery>
					
					<cfif LocationList.recordcount eq "0">
					
						<cfquery name="LocationList" 
							datasource="AppsPayroll" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT   Code,Name,LocationCode,L.Description,0 as LocationDefault
							FROM     Ref_PayrollLocation L, System.dbo.Ref_Nation N
							WHERE    L.LocationCountry = N.Code		
							AND      N.Code != 'UUU'				
							ORDER BY Description,Name,LocationCode 
						</cfquery>			
					
					</cfif>		
					
			   </cfif>				 
		  		   
			   <tr>
			    <td class="labelmedium fixlength" width="120"><cf_tl id="Activity Location">:</td>
				   <TD height="25" class="labelmedium" colspan="2">	
				   				   				   
				   <cfif URL.Mode neq "edit" and url.mode neq "add">
					
						<cfquery name="getLoc" dbtype="query">
								SELECT   *
								FROM     LocationList
								WHERE    LocationCode = '#entry.RequestLocationCode#'
						 </cfquery>			
						 
						 #getLoc.Description#, #ucase(getLoc.Name)# 
							
					<cfelse>	
				  				   
					   <cfif entry.RequestLocationCode eq "">
					   
						     <cfquery name="getDefault" dbtype="query">
								SELECT   *
								FROM     LocationList
								WHERE    LocationDefault = 1
							 </cfquery>		
							 			    
						   	 <cfset selected = getDefault.LocationCode>
						 
					   <cfelse>
					   	
							<cfset selected = entry.RequestLocationCode>
							
					   </cfif>	
					   				   
					     <select name="RequestLocationCode" id="requestlocationcode" style="width:350px" class="regularxl enterastab" 
						   onchange="javascript:reloadmatrix('#edition.period#','#id#')">
						    <!---
					   		<option value=""><cf_tl id="Undefined"></option>		
							--->
							
							<cfloop query="LocationList">
							<option value="#LocationCode#" <cfif selected eq locationcode>selected</cfif>>#Description# <cfif name neq "">, #ucase(Name)#</cfif></option>
							</cfloop>
							<option value="999" <cfif selected eq "999">selected</cfif>><cf_tl id="Multiple"></option>	
					   </select>
				   						
					</cfif>
				   					
					</td>
		
			  </tr>		  
			 
						   		  	
		 <!--- ------------------------------------ --->
		 <!--- ----- Requirement Master SELECT----- --->
		 <!--- ------------------------------------ --->
		  
		 <cfif Object.RequirementMode eq "3">	 
		 
			    <script language="JavaScript">	
							   		 
				     if (se = document.getElementById('details')) {
					   	 ptoken.navigate('../Request/RequestList.cfm?scope=dialog&programcode=#url.programcode#&period=#url.period#&editionid=#url.editionid#&objectcode=#url.objectcode#&requirementid=#id#','details')						   					   
					 }
								 
			   </script>	
		 
		 <cfelse>
		 			
			   <tr>
				   <td class="labelmedium" width="120"><cf_tl id="Requirement">:</td>
				   <TD height="20" class="labelmedium" colspan="2">		   
				   
					<cfif ItemMaster.recordcount eq "0">
		
						<table width="100%">
							<tr>
							<td class="labelmedium">
							<font color="FF0000"><cf_tl id="Problem">,
							 <cf_tl id="no item master defined"> <cf_tl id="for"> <cf_tl id="Object Code"> #url.objectcode# #Object.Description#. <br> <cf_tl id="Please contact your Administrator"> </font>
							</td>
							</tr>
						</table>
						
					<cfelse>
					
						<table width="100%">
							
							<tr>
								<td class="labelmedium">
																			
									<cfif URL.Mode neq "edit" and url.mode neq "add">
					   			   
											<cfquery name="ItemMaster" 
											datasource="AppsPurchase" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												SELECT    *
												FROM      ItemMaster
												WHERE     Code        = '#entry.itemmaster#'
												AND       Operational = 1
											</cfquery>
									   
									    	#ItemMaster.Code# #ItemMaster.Description#
											
											<input type="hidden" name="itemmaster" id="itemmaster" value="#entry.itemmaster#">
								   
								       <cfelse>
									   			  
									   	  <cfif Object.RequirementMode neq "2">	
										  										  										
										  	   <cfif Object.RequirementPeriod eq "1">												  			   			  									  
														  
									  				<select name="itemmaster" 
														  id="itemmaster"													     
												          message="Please select an item"
												          visible="Yes"
														  class="enterastab regularxl"
														  onchange="javascript:reloadmatrix('#edition.period#','#id#');alldetinsert('#url.editionid#_#url.objectcode#','#url.editionid#','#url.objectcode#','#requirementid#','edit','dialog',this.value)"
												          enabled="Yes"
														  style="width:350px"
												          required="Yes">
												  
												  <cfelse>
												  													  												  							  								  
												  	 <select name="itemmaster" 
													 	  id="itemmaster"												     	  
												          message="Please select an item"
												          visible="Yes"
														  enabled="Yes"
														  style="width:350px"
														  class="enterastab regularxl"
												          required="Yes"
												          onchange="javascript:reloadmatrix('#edition.period#','#id#');ptoken.navigate('../Request/getRequestDescription.cfm?line=1&id=#id#&itemmaster='+this.value,'description'); ptoken.navigate('../request/RequestList.cfm?scope=dialog&programcode=#url.programcode#&period=#url.period#&editionid=#url.editionid#&objectcode=#url.objectcode#&itemmaster='+this.value+'&requirementid=#id#','details')">
														  								 					  
												  </cfif>
											       
												   <!--- <option value="" <cfif url.itemMaster eq "">selected</cfif>></option> --->
												   
												   <cfloop query="itemmaster">
												   	 <option value="#Code#" <cfif url.itemmaster eq code>selected</cfif>><cfif CodeDisplay eq "">#Code#<cfelse>#CodeDisplay#</cfif> #Description#</option>
												   </cfloop>
												   
											   </select>
											   
											   <!--- load the budget item listing screen --->							   			   
											   
											   <cfif url.itemmaster neq "">
											   	<cfset itm = url.itemmaster>
											   <cfelse>
											    <cfset itm = itemmaster.code>
											   </cfif>
											   
											   <script language="JavaScript">	
											   		 
											     if (se = document.getElementById('details')) {
												   	 ptoken.navigate('../Request/RequestList.cfm?scope=dialog&programcode=#url.programcode#&period=#url.period#&editionid=#url.editionid#&objectcode=#url.objectcode#&itemmaster=#itm#&requirementid=#id#','details')						   					   
												 }
												 
											   </script>			 
										   				   
										   <cfelse>
										   											  	
											   <cfif url.itemmaster eq "" or url.mode eq "add"> 									   
											   																									   										   										   				   
												   <select onchange="javascript:reloadmatrix('#edition.period#','#id#')" name="itemmaster" id="itemmaster" style="width:350px" class="enterastab regularxl">
													  
													   <cfloop query="itemmaster">
													   	 <option value="#Code#" <cfif url.itemmaster eq code>selected</cfif>><cfif CodeDisplay eq "">#Code#<cfelse>#CodeDisplay#</cfif> #Description#</option>
													   </cfloop>
													   
												   </select>
											   
											   <cfelse>
											   
												   <cfquery name="ItemMaster" 
													datasource="AppsPurchase" 
													username="#SESSION.login#" 
													password="#SESSION.dbpw#">
														SELECT    *
														FROM      ItemMaster
														WHERE     Code        = '#url.itemmaster#'												
													</cfquery>
													
													<input type="hidden" name="itemmaster" id="itemmaster" value="#url.itemmaster#">
													#ItemMaster.Description#											   
											   
											   </cfif> 
										  
											   <!--- load the budget item listing screen --->
											   
											   <cfif url.itemmaster neq "">
											   	<cfset itm = url.itemmaster>
											   <cfelse>
											    <cfset itm = itemmaster.code>
											   </cfif>
										   
										       <script language="JavaScript1.2">											    
											     if (se = document.getElementById('details')) {
												   	 ptoken.navigate('../Request/RequestList.cfm?scope=dialog&programcode=#url.programcode#&period=#url.period#&editionid=#url.editionid#&objectcode=#url.objectcode#&itemmaster=#itm#&requirementid=#id#','details')						   					   
												 }
											   </script>	
										  			   
										   </cfif>
										   			   
									   </cfif>								   
								  
								</td>
							
								<td style="padding-left:8px;">
									<cf_tl id="Instructions" var="1">
									<table>
										<tr>
											<td>
												<img id="imgViewInstructions"
													name="imgViewInstructions"
													src="#session.root#/images/expand.png" 
													style="height:15px; cursor:pointer;" 
													title="#lt_text#" 
													onclick="getItemObjectInstructions('#url.objectcode#', $('##itemmaster').val(), '#url.programcode#','#url.period#','#url.editionid#','InstructionsDetail', this, 'collapse.png', 'expand.png');">
											</td>
											<td style="padding-left:3px;" class="labelmedium">											    
												<label for="imgViewInstructions"><cf_tl id="Instructions"></label>	
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>	
						
						 </cfif>					
							
				   </TD>
			   </tr>
			   
			   <tr>
					<td colspan="3" id="InstructionsDetail" style="display:none;">
						<cfdiv id="divInstructionsDetail">
					</td>
			   </tr>
		   
		   </cfif>
		   
		   <span class="hide" id="ctotal"></span>
		   
		 	   
		   <!--- -------------------------------------- --->
		   <!--- ---------- Subitem for period  ------- --->
		   <!--- -------------------------------------- --->
		   
		   <cfif Object.RequirementPeriod eq "1" and Object.RequirementMode neq "2">
		   
		       <!--- ---------------------------------------------- --->
			   <!--- ----- For unit matrix this is embedded ------- --->
			   <!--- ---------------------------------------------- --->
			   
			   <tr>
				   <td class="labelit" style="padding-left:15px" id="labelitem"><cf_tl id="Item">:</td>
				   <TD class="labelmedium" height="20" id="description" colspan="2">
				  
				   <cfif URL.Mode neq "edit" and url.mode neq "add">		   
					       #entry.requestDescription#				   
				   <cfelse>		
				      <cfparam name="itm" default="#url.itemmaster#">			 
					  <cf_securediv bind="url:getRequestDescription.cfm?line=1&id=#id#&itemmaster=#itm#">  
				   </cfif>
				   		   
				   </TD>
			   </tr>
		   
		   </cfif>
		   
		  <!--- ------------------------ --->
		  <!--- ------------------------ --->
		  <!--- ------ PROVISION-- ----- --->
		  <!--- ------------------------ --->   
		  <!--- ------------------------ --->
		   	   
		  <cfif Object.RequirementPeriod eq "0">
		  
		  	  	<cfif Object.RequirementMode eq "3">	
				
				<!--- define items and create lines based on the number --->
				
					<cfinclude template="RequestDialogFormItemMaster.cfm">
													
				<cfelse>
											
					<tr>
						<td valign="top" class="labelmedium"></td>
						<td colspan="2">
						<table width="100%">
						
							<tr class="labelmedium line">
							    <td id="labelitem"><cf_tl id="Item"></td>
								<td id="labelqty"><cf_tl id="Quantity"></td>
								<cfif Object.RequirementMode eq "1">
								<td id="labelday"><cf_tl id="Days"></td>
								<td><cf_tl id="Sum"></td>
								</cfif>
								<td align="right"><cf_tl id="Cost"></td>
								<td align="right"><cf_tl id="Total"> #Parameter.BudgetCurrency#</td>
							</tr>
																			
							<tr class="labelmedium line">				
						  
							<cfif URL.Mode neq "edit" and url.mode neq "add">	
							   
							   	 <td style="padding-right:1px;width:100" id="description" class="labelmedium">	   
							     #entry.requestDescription#				   
								 </td>
								 	   
						    <cfelse>		
						   
							      <cfparam name="itm" default="#url.itemmaster#">			 
								  <td style="width:100%;padding-right:4px">						  				  
								  <cf_securediv id="description" bind="url:getRequestDescription.cfm?line=1&id=#id#&itemmaster=#itm#">  
								  </td>
								  
						    </cfif>
							   					
							<cfif Object.RequirementMode eq "0">					
													   
								   <cfif URL.Mode neq "edit" and url.mode neq "add">
								   
									   <td style="padding-right:1px;width:40" align="right" class="labelmedium">		
									   #entry.requestQuantity#
									   </td>	   
									   
								   <cfelse>
								  
									   <td align="right" style="width:100;padding-right:4px">
									 
										   <cfinput type = "Text"
										       name      = "requestquantity_1"
											   id        = "requestquantity_1"
										       value     = "#entry.requestQuantity#"
										       validate  = "float"
											   class     = "enterastab regularxl"
											   style     = "text-align:right;padding-right:3px;width:40;height:25;border:0px;border-right:1px solid silver"		  
											   message   = "Please enter a quantity"
										       required  = "Yes"      
										       typeahead = "No">
											   
										</td>	   
									   
								   </cfif>	
													 
							<cfelse>
							 					 							
									<cfif URL.Mode neq "edit" and url.mode neq "add">
							   
							   	     <td style="padding-right:0px;width:60" align="right">						   
							   	      #entry.ResourceQuantity# 
									 </td> 
									 
									 <td style="padding-right:0px;width:60" align="right">						   
							   	      #entry.ResourceDays#					   
								     </td>
									 
									 <td style="padding-right:0px;width:60" align="right">						   
							   	      #entry.requestQuantity#					   
								     </td>
							   
							   	   <cfelse>
							   
							        <td style="padding-right:4px">	
								   
									    <cfinput type="Text"
									       name="resourcequantity_1"
										   id="resourcequantity_1"
									       value="#entry.resourceQuantity#"
									       validate="float"			
										   class="enterastab regularxl"		  
										   style="text-align:right;padding-right:3px;height:25;width:60;border:0px;border-right:1px solid silver"
										   message="Please enter a quantity"
									       required="Yes">
								   
								    </td>
								  				  					   
								    <td style="padding-right:4px">
								  						  
									    <cfinput type="Text"
									       name="resourcedays_1"
										   id="resourcedays_1"
									       value="#entry.resourcedays#"
									       validate="float"		
										   class="enterastab regularxl"			  
										   style="text-align:right;padding-right:3px;height:25;width:60;border:0px;border-right:1px solid silver"
										   message="Please enter a quantity"
									       required="Yes">
										   
								    </td>
								 				 					   
								    <td style="padding-left:3px;text-align:right;padding-right:3px;vertical-align: middle;">
								   					  
									  <cf_securediv id="quantity_1" style="width:60;border-right:1px solid silver;height:25;padding-right:3px;"
									    bind="url:RequestQuantityMode1.cfm?mode=quantity&resource_1={resourcequantity_1}&day_1={resourcedays_1}">
																									   
								     </td>
													 
								 </cfif>	
								 											 
					 		 </cfif>
							 	 			  		   
							 <cfif URL.Mode neq "edit" and url.mode neq "add">
								   
							   	 <td style="padding-right:3px;border-right:1px solid silver" align="right" class="labelmedium">#numberformat(entry.requestPrice,",.__")# </td>
								   
							 <cfelse>
								   
								 <td style="padding-left:1px;padding-right:1px">
									
								   <cfif entry.requestprice lte "0.05">
								     <cfset val = "0.00">				
								   <cfelse>	 			
								      <cfset val = "#numberformat(entry.requestPrice,",.__")#">
								   </cfif>
					
								   <cf_tl id="Please enter a cost price" var="1">
								   								   
								   <cfinput type="Text" 
									   name     = "requestprice_1"
									   id       = "requestprice_1"
								       value    = "#val#"												       				   
									   style    = "padding-right:3px;text-align:right;width:70;height:25;border:0px;border-right:1px solid silver"
									   message  = "#lt_text#"
									   class    = "regularxl enterastab"
								       required = "Yes">	
									   
									   <!-- validate = "float"	 --->		   
						 	   
								 </td>
								   
							 </cfif>		
					 	   			   
							 <td align="right" class="labelmedium"
							    style="padding-left:4px;width:85px;border-bottom:1px solid silver;text-align:right;padding-right:0px">
																						   
						   	<cfif URL.Mode neq "edit" and url.mode neq "add">
								
							   		#numberformat(entry.requestAmountBase,",.__")#
								
							<cfelse>		
																			
																				
									<cfif Object.RequirementMode eq "0">							
									   
									    <cf_securediv id="total_div" style="background-color:f1f1f1;width:80;border-right:1px solid silver;height:25;padding-right:3px;padding-top:4px"
										bind="url:RequestQuantityMode0.cfm?filler=0&mode=total&price={requestprice_1}&quantity_1={requestquantity_1}">
																
									<cfelse>												
																					
										<cf_securediv id="total_div" style="background-color:f1f1f1;width:80;border-right:1px solid silver;height:25;padding-right:3px;padding-top:4px"
										bind="url:RequestQuantityMode1.cfm?filler=0&mode=total&price={requestprice_1}&resource_1={resourcequantity_1}&day_1={resourcedays_1}">
																																							
									</cfif>													
																			
							</cfif>	
															
							<input type="hidden" name="requestamountbase_1" id="requestamountbase_1" value="#entry.requestAmountBase#">				
													
							</td>
												
							</tr>
												
						</table>
						</td>
									
					</tr>	
				
				</cfif>
					
			<cfelse>
					
				<!--- ---------------------------- --->
			    <!--- period and matrix entry mode --->
				<!--- ---------------------------- --->
						   	   
				<cfquery name="Dates" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    A.*, P.*
						FROM      Ref_Audit A LEFT OUTER JOIN ProgramAllotmentRequestQuantity P ON A.AuditId = P.AuditId 
						     AND  P.RequirementId  = '#id#' 	
							 
						<cfif edition.period eq "">	 
						WHERE     A.Period = '#url.Period#'
						<cfelse>
						WHERE     A.Period = '#Edition.Period#'
						</cfif>
						ORDER BY  DateYear, AuditDate 
				</cfquery>	
						
								
				<cfif Object.RequirementMode eq "0"	or Object.RequirementMode eq "1" or Object.RequirementMode eq "2">
						
				<tr>
						
				<td colspan="3" style="padding-left:4px;padding-right:7px">
				
					<cfset prior = "">
					
					<cfif Dates.recordcount eq "0">
					
						<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="d4d4d4">
						<tr><td align="center" height="30" class="labelmedium">
						<cfset lk = "">
						<cfset submithide = "1">
						<font color="808080"><i> <cf_tl id="Object expenditure requires sub periods to be defined for execution Period" class="message"> (#Edition.Period#). <cf_tl id="Please contact your administrator">.</font>
						</td>
						</tr>
						</table>
								
					<cfelse>		
																
						<cfif Object.RequirementMode eq "0" or Object.RequirementMode eq "1">			
							
							  <table width="100%" align="center" border="0">
							  <tr>	
																  
							   <cfset url.requirementid = id>
							   <cfparam name="itm" default="#url.itemmaster#">
							   <cfset url.itemmaster = itm>		
							   
							   <!--- entry of quantities per audit period --->					   					  
							   <cfinclude template="RequestDialogFormQuantity.cfm">		
							  
							  </tr>		   
						      </table>		
						
							<cfelse>	
											
							    <!--- entry of quantities per sub item and audit period --->	
																																																														   
							   <cfdiv id="matrixbox">					   
							   
									 								
								   <cfset url.planperiod  = url.period>	  
								   <cfset url.period      = edition.period>
								   <cfset url.requirementid = id>	
								   <cfparam name="itm" default="#url.itemmaster#">	
								   <cfset url.itemmaster  = itm>	
								   <cfset url.mission     = Program.Mission>
								   <cfset url.fund        = InitFund>								   
								   <cfset url.location    = selected>
								   <cfinclude template    = "RequestDialogFormMatrix.cfm">		
							   
							   </cfdiv>
							  
							</cfif>			
						
					</td>
					</tr>
					   
					<!--- show overall totals --->
					   
					   <cfif Object.RequirementPeriod eq "0">
					     <cfset cl = "regular">
					   <cfelse>
					     <cfset cl = "hide">
					   </cfif>
					  	 			   
				   	   <tr><td height="3"></td></tr>	 		   
					  
					   <tr class="#cl#">
					   <td width="120" class="labelmedium"><cf_tl id="Requirement">:</td>
					   				  
						   <cfif Object.RequirementMode eq "0">
						   					   					   
						  			<td>								
									
							   		<table cellspacing="0" cellpadding="0" class="formpadding">
										<tr>
											<td align="right" style="border: 1px solid silver;height:25px;width:90px;padding-right:4px">																				
											
												<cfif URL.Mode eq "edit" or url.mode eq "add">
													
													<cfset lk = "">
													<cfloop query="Dates">
														 <cfif lk eq "">
														 	 <cfset lk = "lines=#dates.recordcount#&quantity_#currentrow#={requestquantity_#currentrow#}">
														 <cfelse>
														  	 <cfset lk = "#lk#&quantity_#currentrow#={requestquantity_#currentrow#}"> 
														 </cfif>						
													</cfloop>																					
																																						
												    <cfdiv id="subtotal" bindonload="false" bind="url:RequestQuantityMode0.cfm?mode=quantity&#lk#&mid=#url.mid#">
														#entry.RequestQuantity#																																									
													</cfdiv>
																
												<cfelse>
												
													#entry.RequestQuantity#
												
												</cfif>
											
											</td>							
										</tr>						
									</table>
								
								</td>
									
							<cfelseif Object.RequirementMode eq "1">
							
								<td>
								
									<table cellspacing="0" cellpadding="0" class="formpadding">
										<tr>
											<td bgcolor="F4F4F4" align="right" class="labelmedium" style="border:1px solid silver;width:90px;height:25px;padding-right:4px">	
																																										
											<cfif URL.Mode eq "edit" or url.mode eq "add">
												
											    <cfset lk = "">
												<cfloop query="Dates">
													 <cfif lk eq "">
														  <cfset lk = "lines=#dates.recordcount#&resource_#currentrow#={resourcequantity_#currentrow#}&day_#currentrow#={resourcedays_#currentrow#}">
													 <cfelse>
														  <cfset lk = "#lk#&resource_#currentrow#={resourcequantity_#currentrow#}&day_#currentrow#={resourcedays_#currentrow#}"> 
													 </cfif>						
												</cfloop>
																														
												<cfdiv id="subtotal" bindonload="false"	bind="url:RequestQuantityMode1.cfm?scope=period&mode=quantity&#lk#&mid=#url.mid#">	
												
													<div id="total_display" style="font-size:13">#numberformat(entry.RequestQuantity,",.__")#</div>
													
												</cfdiv>
															
											<cfelse>
																						
												<div id="total_display" style="font-size:13">#numberformat(entry.RequestQuantity,",.__")#</div>
																					
											</cfif>
									
										    </td>
										</tr>						
									</table>
								
								</td>
								
							<cfelse>
							
							<!--- calculated overall amount --->
							<td>												
							   <input type="input" class="regularxl" readonly style="text-align:right;width:92px" name="overallamount" id="overallamount" value="#numberformat(entry.RequestAmountBase,',__.__')#"> 	 		
							</td>
									
						   </cfif>		
						   				   
						 </tr>  	 
					   
					</cfif>
				   	   	
			   </cfif>
			  			   
			   <!--- not for the matrix only for the subdivision of the item for the quantities recorded --->
			   
			   <cfif Object.RequirementMode neq "2">
		         	   
			     <TR>
				 
				   <td class="labelmedium"><cf_tl id="Standard Cost">:</td>			   
				 			  		   
				   <cfif URL.Mode neq "edit" and url.mode neq "add">				   
				   
				   	     <td width="120">#numberformat(entry.requestPrice,",.__")# </td>				   
						 
				   <cfelse>
				   
					   	<td width="120">
						
						   <cfif entry.requestprice lte "0.05">
						      <cfset val = "0.00">				
						   <cfelse>	 			
						      <cfset val = "#numberformat(entry.requestPrice,",.__")#">
						   </cfif>
			
						   <cf_tl id="Please enter an amount" var="1">
						   						   
						   <cfinput type="Text" 
							   name="requestprice_1"
							   id="requestprice_1"
						       value="#val#"						       			   
							   style="text-align:right;padding-right:3px;width:88px;border-radius:0px"
							   message="#lt_text#"
							   class="regularxl enterastab"
						       required="Yes">			   
							   
					    </td>
				   
				   </cfif>		
				   
			    </tr>			   
				   		   
			    <tr>	    
				 
				   <td style="width:100;padding-right:4px" class="labelmedium"><cf_tl id="Amount"> #Parameter.BudgetCurrency# :</td>				  
				   <td>				   
					   	<table cellspacing="0" cellpadding="0">
						<tr>
						
						   <td align="right" bgcolor="A4E4F0" style="font-size:15px;height:30px;width:132;border:1px solid silver;padding-right:3px">
							
							<cfparam name="lk" default="">
					   
					   		<cfif URL.Mode neq "edit" and url.mode neq "add">
							
						   		#numberformat(entry.requestAmountBase,",.__")#
							
							<cfelse>
												
									<cfif Object.RequirementMode eq "0">
																								
									    <cfdiv id="total" bindonload="false"
										bind="url:RequestQuantityMode0.cfm?scope=period&mode=total&price={requestprice_1}&#lk#&mid=#url.mid#">
										    <div id="total_display" style="font-size:18px">
												#numberformat(entry.requestAmountBase,",.__")#								
											</div>
										</cfdiv>
										
									<cfelse>
																			
										<cfdiv id="total" bindonload="false"
											bind="url:RequestQuantityMode1.cfm?scope=period&mode=total&price={requestprice_1}&#lk#&mid=#url.mid#">
											  <div id="total_display" style="font-size:18px">
											     #numberformat(entry.requestAmountBase,",.__")#							 
										      </div>
										</cfdiv>
									
									</cfif>											
																									
								<input type="hidden" name="requestamountbase_1" id="requestamountbase_1" value="#entry.requestAmountBase#">				
							
							</cfif>
							
							</td>
							</tr>
						</table>								   		   
					</td>				
					<td class="labelsmall" id="rounding" style="padding-left:4px"></td>		
												 
				 </tr>
			     	   
			     </cfif>			
			   
			</cfif>	   
			
		   <cfif Object.RequirementMode neq "3">	 
		   
		   <tr>
			   <td valign="top" id="labelmemo" style="padding-top:8px" class="labelmedium"><cf_tl id="Memo">: <font color="FF0000">*)</font></td>
			   <TD colspan="3">
			   
			   <cfif URL.Mode neq "edit" and url.mode neq "add">
			    <cfif entry.requestremarks neq "">
			   	#entry.requestRemarks#
				<cfelse>
				--
				</cfif>
			   
			   <cfelse>
			   		   
			   		<textarea style="background-color:f1f1f1;padding:4px;width:99.5%;max-width:99.5%;resize: vertical;height:45;font-size:16px" name="RequestRemarks" class="enterastab regular">#entry.requestRemarks#</textarea>
					
				</cfif>	
			   
			   </TD>
		   </tr>
		   
		   </cfif>
		   		   	   	    
			<cfquery name="Parameter" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  *
				FROM Parameter
			</cfquery>
		   
		    <tr class="line">
			<td class="labelmedium"><cf_tl id="Specifications">:</td>
		  
			<td colspan="2">
					
			  	 <cf_filelibraryN
					DocumentPath="#Parameter.DocumentLibrary#"
					SubDirectory="#url.ProgramCode#" 
					Filter="#left(par,8)#"
					Box="dialog"
					attachdialog="Yes"
					Insert="yes"
					Remove="yes"
					color="transparent"
					width="100%"
					Highlight="no"
					Listing="yes">
			
			</td>
		   
		   </tr>
			 
		   
		   <tr><td colspan="3" height="30">
		   	  
			   <cfif ItemMaster.recordcount gte "1" and (URL.Mode eq "edit" or URL.Mode eq "add")>
			   
				   <cfif submithide eq "0">		
				   
				   	   <cfif url.mode eq "add">
				   
				   	       <cf_tl id="Add  Requirement" var="1">
						   
					   <cfelse>
					   
					   	   <cf_tl id="Update Requirement" var="1">
					   
					   </cfif>	   
					  		   
					   <input type  = "button"
						value       = "#lt_text#" 	
						onClick     = "requestvalidate('#url.cell#','#id#','#url.mode#','#par#')"					
						id          = "Save"	
						class       = "button10g"				
						style       = "font-size:14px;width:220px;height:27">   			  
			    					
				   </cfif>	
					
			   </cfif>
		   		   		   
		   </td></tr>
		   			
	</table>	
	
</td>

</tr>

</table>
   
</cfform>	

<cfset ajaxOnLoad("doCalendar")>

<script>
	Prosis.busy('no')
	parent.Prosis.busy('no')
</script>

	
</cfoutput>	