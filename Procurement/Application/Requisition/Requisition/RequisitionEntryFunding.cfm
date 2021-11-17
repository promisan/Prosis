<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->


<cfparam name="URL.itemmaster"  default="">
<cfparam name="URL.enforcefund" default="0">
<cfparam name="URL.fundingid"   default="">

<!--- define possible periods --->

<cfquery name="Prior" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT  * 
	   FROM    RequisitionLine 
	   WHERE   RequisitionNo = '#URL.ID#' 
</cfquery>		


<cfquery name="Base" 
     datasource="AppsProgram" 
  	  username="#SESSION.login#" 
     password="#SESSION.dbpw#">
       SELECT  *
       FROM    Organization.dbo.Ref_MissionPeriod M
       WHERE   M.Mission = '#URL.Mission#'
	   AND     M.Period  = '#Prior.period#'    
</cfquery>	

<!--- select only periods if that period is in the same mandate as otherwise the unit will not match --->

<cfquery name="PeriodList" 
     datasource="AppsProgram" 
  	 username="#SESSION.login#" 
     password="#SESSION.dbpw#">
       SELECT  R.*, M.MandateNo 
       FROM    Ref_Period R, 
               Organization.dbo.Ref_MissionPeriod M
       WHERE   IncludeListing = 1  	   
       AND     M.Mission   = '#URL.Mission#'
	   AND     M.MandateNo = '#Base.Mandateno#' 
       AND     R.Period    = M.Period
	   ORDER BY R.Period DESC
</cfquery>	

<!--- update item master --->

<cfif url.itemmaster neq "">

	<cfif url.itemmaster neq prior.itemmaster>
		
		<!--- capture the change --->		
		<cfif prior.recordcount neq 0>
			<cf_assignId>

			<cfsavecontent variable="content">
				<cfinclude template="RequisitionEditLog.cfm">
			</cfsavecontent>

			<cfquery name="InsertAction"
				 datasource="AppsPurchase"
				 username="#SESSION.login#"
				 password="#SESSION.dbpw#">
				 INSERT INTO RequisitionLineAction
						 (RequisitionNo,
						  ActionId,
						  ActionStatus,
						  ActionDate,
						  ActionMemo,
						  ActionContent,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				 VALUES
						 ('#URL.ID#',
						  '#rowguid#',
						  '#Line.ActionStatus#',
						   getdate(),
						   'Update Item master to #url.itemmaster#',
						   '#Content#',
						   '#SESSION.acc#',
						   '#SESSION.last#',
						   '#SESSION.first#')
			</cfquery>
		</cfif>
	</cfif>					
	
	<cfquery name="UpdateRequisition" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   UPDATE   RequisitionLine 
	   SET      ItemMaster    = '#url.itemmaster#', 
	            Period        = '#url.per#'
	   WHERE    RequisitionNo = '#URL.ID#'
	</cfquery>	
				
	<cfquery name="Requisition" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 SELECT     L.*,
		            P.EntityClass as ReviewClass, 
					IM.code
		 FROM       ItemMaster IM INNER JOIN
	                RequisitionLine L ON IM.Code = L.ItemMaster INNER JOIN
	                Ref_ParameterMissionEntryClass P ON IM.EntryClass = P.EntryClass 
				AND L.Mission = P.Mission 
				AND L.Period = P.Period
		 WHERE      L.RequisitionNo = '#URL.ID#' 
	</cfquery>	
	
    <cfif Requisition.recordcount eq "0">
	
		<cfquery name="Requisition" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT     TOP 1 L.*,
			            P.EntityClass as ReviewClass, 
						IM.code
			 FROM       ItemMaster IM INNER JOIN
		                RequisitionLine L ON IM.Code = L.ItemMaster INNER JOIN
		                Ref_ParameterMissionEntryClass P ON IM.EntryClass = P.EntryClass 
					AND L.Mission = P.Mission 				
			 WHERE      L.RequisitionNo = '#URL.ID#' 
		</cfquery>		
	
	</cfif>

	<cfif Requisition.recordcount eq "0">
		
	<table align="center">
	    <tr>
		<td class="labelmedium"><font color="FF0000">There is a problem with the configuration of the entry class. Please contact your administrator.</font></td>
		</tr>
	</table>
	
	<cfabort>
	
		
	</cfif>
	
	<cfset reviewflow = Requisition.ReviewClass>
	
	<!--- Hanno note : this is for the CMP additional budget, 
	    however I am not certain on its purpose at this moment 17 May 2010, it cleans if there is not flow, which is right I believe --->
	
	<cfif reviewflow eq "">
			
		<cfquery name="Clear" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    DELETE FROM RequisitionLineBudget 
			WHERE RequisitionNo = '#URL.ID#'
		</cfquery>
	
	</cfif>
	
		
<cfelse>

	<cfquery name="Requisition" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT     L.*
	 FROM       RequisitionLine L  			
	 WHERE      L.RequisitionNo = '#URL.ID#' 
	</cfquery>	
	
	<cfset reviewflow = "">
		
</cfif>

<cfquery name="Unit" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Organization 
	WHERE OrgUnit = '#Requisition.OrgUnit#'
</cfquery>

<!--- clear for object code --->

<cfquery name="ClearObject" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    DELETE FROM RequisitionLineFunding 
	WHERE  RequisitionNo = '#URL.ID#'
	AND    ObjectCode NOT IN (SELECT Code 
	                          FROM   Program.dbo.Ref_Object)
</cfquery>

<cfquery name="Funding" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  RequisitionLineFunding 
	WHERE RequisitionNo = '#URL.ID#'
	ORDER BY ProgramPeriod, Fund
</cfquery>

<cfquery name="fullfunded" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT SUM(Percentage) as Total
    FROM  RequisitionLineFunding 
	WHERE RequisitionNo = '#URL.ID#'	
</cfquery>

<cfparam name="url.archive" default="0">

<cfquery name="Parameter" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#Requisition.Mission#' 
</cfquery>
			
<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   E.*, 
	         EF.Fund, 
			 F.Description as FundDescription
	FROM     Ref_AllotmentEdition E, Ref_AllotmentEditionFund EF, Ref_Fund F
	WHERE    E.EditionId = EF.EditionId
	AND      F.Code = EF.Fund
	AND      E.EditionId IN (SELECT  EditionId
	                  	   FROM    Organization.dbo.Ref_MissionPeriod P
						   WHERE   Mission = '#Requisition.Mission#' 
							 AND   Period = '#Requisition.Period#'
						  )
</cfquery>

<cfquery name="FlowSetting" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT   S.*
	FROM     RequisitionLine R INNER JOIN
             ItemMaster M ON R.ItemMaster = M.Code INNER JOIN
             Ref_ParameterMissionEntryClass S ON R.Mission = S.Mission AND R.Period = S.Period AND M.EntryClass = S.EntryClass
	WHERE    R.RequisitionNo = '#Requisition.RequisitionNo#'
</cfquery>		

<!--- -------------------------------------------- --->
<!--- check if funding option will be made visible --->
<!--- -------------------------------------------- --->

<cfinvoke component     = "Service.Access"  
	   method           = "ProcRole" 
	   orgunit          = "#Requisition.OrgUnit#" 
	   mission          = "#Requisition.Mission#"
	   role             = "'ProcReqObject'"
	   returnvariable   = "access">		
	   
	 	   	     
<cfif  (url.ItemMaster eq "" and enforceFund eq "0" and fullfunded.total neq "1") 
           
          or	<!--- 1. no itemmaster defined yet --->
         (url.enforceFund eq "0" 		 
		     and Parameter.FundingByReviewer eq "2" 
			 and fullfunded.total eq "1"  <!--- Hanno 17/1/2011 added to show the funding if it is not fully funded yet --->
			 
			 <!---  hide if the status is passed and user has not right for funding   --->			 
			 <!--- 8/8/2010 removed  or Requisition.ActionStatus gte "3" in the below ---> 
			 
		     and (Requisition.ActionStatus eq "1" 
			      or Requisition.ActionStatus eq "2"  <!--- added 2, 2a, 2b here --->
				  or Requisition.ActionStatus eq "2a"
				  or Requisition.ActionStatus eq "2b"				  
			      or Requisition.ActionStatus gt "3" 
				  or Access eq "NONE" or Access eq "READ")					 
				 
   		     and (
			     FlowSetting.EnableFundingClear eq "1" or (FlowSetting.EnableFundingClear eq "0" and reviewflow neq "")
				 )
   		  )> 		  
				
		<!--- 
		 2. disabled if funding by reviewer only and status lt reviewed 
		 3. if stage for funding clearer is globally disabled AND the request is not part of workflow === CMP 
		--->
		
		
								
		<script>
		
		try {
		 	document.getElementById("funding1").className = "hide"
			document.getElementById("funding2").className = "hide"
		  } catch(e) {}
		</script>	
					
				
<cfelse>
	
	<script>
		try {
		 document.getElementById("funding1").className = "regular"
		 document.getElementById("funding2").className = "regular"
		 } catch(e) {}
		</script>			

	<cfif ((Parameter.FundingByReviewer eq "1" or Parameter.FundingByReviewer eq "1e" or Parameter.FundingByReviewer eq "2")
	       and url.archive eq "0" 
		   and Requisition.actionStatus lt "3")
	         or Funding.recordcount eq "0">
			 				
		<cfinvoke component  = "Service.Access"  
			  method         = "ProcRole" 
			  mission        = "#Requisition.mission#"
			  orgunit        = "#Requisition.OrgUnit#" 
			  role           = "'ProcReqReview','ProcReqApprove'"
			  returnvariable = "accessreq">
			
		<cfif accessreq eq "EDIT" or accessreq eq "ALL" 
		       or access eq "EDIT" or access eq "ALL">
			   			   
			  <cfset url.access = "edit">
			
		</cfif>
			
	</cfif>
			
	<!--- buyer has send back --->
	<cfif Requisition.JobNo neq "" and getAdministrator("*") eq "0" and Funding.recordcount neq "0">
		<cfset url.access = "view">
	</cfif>
	
	<cfif getAdministrator(requisition.mission) eq "1">
	   <cfset url.access = "edit">
	</cfif>	
		
	<cfparam name="URL.Perc"    default="1">
	<cfparam name="URL.Clear"   default="">
	<cfparam name="URL.Action"  default="">
	
	<cfif url.action eq "del">
	
		<cfquery name="delete" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
	    	DELETE 
			FROM  RequisitionLineFunding 
			WHERE FundingId = '#URL.FundingId#' 
		</cfquery>
	
	</cfif>
			
	<!--- ---------------------------- --->
	<!--- Process selection in funding --->
	<!--- ---------------------------- --->

	<cfif url.action eq "save">
		<cfinclude template="RequisitionEntryFundingEdit.cfm">
		<cfset url.fundingid = "">
	</cfif>
		
	<cfquery name="ClearZero" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  DELETE FROM RequisitionLineFunding 
		  WHERE  RequisitionNo = '#URL.ID#' 
			AND  Percentage = 0 
	</cfquery>	
		
	<cfquery name="Funding" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  F.*, O.CodeDisplay, O.Description
	    FROM    RequisitionLineFunding F, 
		        Program.dbo.Ref_Object O 
		WHERE   RequisitionNo = '#URL.ID#'
		AND     F.ObjectCode = O.Code
		ORDER BY ProgramPeriod, Fund
	</cfquery>
		
	<cfif url.access eq "Edit">
				
		<cfif Parameter.EnforceObject eq "1"> <!--- change the item master requires new objects --->
			
			<cfquery name="overwrite" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			 	    SELECT  *
					FROM    Ref_ParameterMissionEntryClass
					WHERE   Mission = '#requisition.Mission#' 
					AND     Period = '#requisition.Period#'
			</cfquery>		
			
			<cfif Overwrite.DisableFundingCheck eq "0">
				
				<!--- Disable the cleanup of the funding lines, the enforcement is done at the selection not after the fact for now
								
				<cfquery name="Delete" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    DELETE FROM RequisitionLineFunding 
					WHERE  RequisitionNo = '#URL.ID#' 				
					AND    ObjectCode NOT IN (SELECT ObjectCode FROM Itemmasterobject WHERE ItemMaster = '#Requisition.ItemMaster#')
				</cfquery>	
				--->
				
			</cfif>	
						
		</cfif>
		
		<cfif URL.Clear eq "all"> <!--- change the period will affect --->
							
			<cfquery name="Delete" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			    DELETE FROM RequisitionLineFunding
				WHERE  RequisitionNo = '#URL.ID#' 		
			</cfquery>	
			
		<cfelseif URL.clear eq "Item">
		
			<cfif Parameter.enforceObject neq "9">
			
			   <cfquery name="Delete" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				    DELETE FROM RequisitionLineFunding
					WHERE  RequisitionNo = '#URL.ID#' 		
				</cfquery>	
			
			</cfif>
				
						
		</cfif>
	
	</cfif>
		
	<cfquery name="Funding" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   F.*, 			         
					 O.Description, 
					 O.CodeDisplay,
				     (SELECT ProgramName FROM Program.dbo.Program WHERE Mission = '#url.mission#' AND ProgramCode = F.ProgramCode) as ProgramName						 
				
			
			FROM     RequisitionLineFunding F INNER JOIN
                     Program.dbo.Ref_Object O ON F.ObjectCode = O.Code 
					 
			WHERE RequisitionNo = '#URL.ID#'
			ORDER BY F.Created 
	</cfquery>
	
			
	<cfquery name="FundList" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	SELECT    Code
	FROM         Ref_Fund
	WHERE     (Code IN
                          (SELECT     Fund
                            FROM          Ref_AllotmentEditionFund
                            WHERE      (EditionId IN
                                                       (SELECT     EditionId
                                                         FROM          Ref_AllotmentEdition
                                                         WHERE      (Mission = '#Requisition.Mission#')))))
	
     </cfquery>
	 
	 <cfif FundList.recordcount eq "0">
	 
	  <cfquery name="FundList" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	 
			SELECT *
			FROM Ref_Fund
		</cfquery>
		
	 </cfif>
	 
	
	<cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 SELECT  *
		 FROM    Ref_ParameterMission
		 WHERE   Mission = '#Requisition.Mission#' 
	</cfquery>	
	
	<cfquery name="ObjectList" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Object R
		WHERE  1=1
		<cfif parameter.EnforceObject eq "1">
		AND    Code IN (SELECT ObjectCode 
		                FROM   Purchase.dbo.ItemMasterObject 
						WHERE  ObjectCode = R.Code
						AND    ItemMaster = '#URL.ItemMaster#')						
		</cfif>
		AND    ObjectUsage = '#Parameter.ObjectUsage#'
        AND    Procurement = 1 
	</cfquery>
	
	<cfif ObjectList.recordcount eq "0">
	
	<cfquery name="ObjectList" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Object R
		WHERE  1=1				
		AND    ObjectUsage = '#Parameter.ObjectUsage#'
        AND    Procurement = 1
	</cfquery>
	
	</cfif>
					
	<cfquery name="Percentage" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT SUM(Percentage) as Percentage
	    FROM   RequisitionLineFunding F
		WHERE  RequisitionNo = '#URL.ID#'
	</cfquery>
	
	<cfif Parameter.EnforceProgramBudget eq "1">
	
		<cfif Percentage.Percentage neq "" and Percentage.Percentage neq "1">
	
			<cfif funding.fundingId neq "">
			
				<cfquery name="Update" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    UPDATE RequisitionLineFunding 
					SET    Percentage = Percentage+(1-#Percentage.Percentage#)  
					WHERE  FundingId = '#Funding.FundingId#' 
				</cfquery>
					
			</cfif>	
							
			<cfquery name="Funding" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT F.*, 
					       O.CodeDisplay,
					       O.Description,
						   (SELECT ProgramName FROM Program.dbo.Program WHERE Mission = '#url.mission#' AND ProgramCode = F.ProgramCode) as ProgramName						 
					FROM   RequisitionLineFunding F INNER JOIN
                  		   Program.dbo.Ref_Object O ON F.ObjectCode = O.Code 				   
					WHERE  RequisitionNo   = '#URL.ID#'					
			</cfquery>				
						
		</cfif>
		
	<cfelse>
	
		<cfif percentage.percentage neq "">
			<cfset url.perc = 1-#Percentage.Percentage#>
		</cfif>
	
	</cfif>		
		
	<cf_tl id="Set" var="1">
	<cfset vsave=lt_text>	
			
	<table style="width:600px" border="0" class="navigation_table">
		    
		  <tr>
		  	  
		    <cfif Parameter.EnforceProgramBudget gte "1" and URL.Access eq "Edit">
		  
			    <cfif funding.recordcount eq "0">
			    <td class="labelmedium2">
				<cfelse>
				<td class="labelmedium2" width="30">
				</cfif>
					
				<cfoutput>	
					 <img src="#SESSION.root#/Images/search.png" alt="Select funding" name="img1" 
						  onMouseOver="document.img1.src='#SESSION.root#/Images/contract.gif'" 
						  onMouseOut="document.img1.src='#SESSION.root#/Images/search.png'"
						  style="cursor: pointer;;border-radius:5px" alt="" width="21" height="21" border="0" align="absmiddle" 
						  onClick="fd(period.value)">
				</cfoutput>	  
						
				<cfif funding.recordcount eq "0">
					 &nbsp;<a href="javascript:fd()">[<cf_tl id="REQ031">]</a>				 
				</cfif>
						
			    <td>
				
			</cfif>
		    
		    <td>
				
			<table width="100%">
									
			<cfoutput>
			
			<cfif Funding.recordcount gte "1">
			
				<tr class="line labelmedium2">
					<td width="60"><cf_tl id="Per"><cf_space spaces="15"></td>			
					<td width="50"><cf_tl id="Fund"></td>			
					<cfif Parameter.EnforceProgramBudget eq "1">		
					<td width="25%" style="padding-right:2px"><cf_tl id="Project"></td>
					<cfelse>
					<td></td>
					</cfif>
					<td width="25%"><cf_tl id="Object of Expenditure"></td>
					<td width="70">Perc.<cf_space spaces="20"></td>
					<td align="right" width="10%"><cf_tl id="Amount"></td>
					<td width="100" align="right"><cf_tl id="Date"></td>
					<td width="40"><cf_space spaces="15"></td>
				</tr>			
			
			</cfif>
						
			<cfloop query="Funding">
			
			<cfset fd     = Fund>
			<cfset obj    = ObjectCode>
			<cfset per    = URL.Per>
														
			<cfif URL.fundingid eq FundingId>
												
				<TR style="height:34px" class="line">
				
				   <td style="padding-left:4px">
				   
				     <select name="programperiod" id="programperiod" class="regularxxl" style="width:100%">
			           <cfloop query="PeriodList">
					     <option value="#Period#" <cfif period eq Funding.ProgramPeriod>selected</cfif>>#Period#</option>
					   </cfloop>
				   	   </select>				   				   
				   
				   </td>
							
				   <cfif Parameter.EnforceProgramBudget eq "0">				   	   	   
				    					   						 						  
					   <td style="padding-left:3px">
					   <select name="fund" id="fund" class="regularxxl" style="width:100%">
			           <cfloop query="FundList">
					     <option value="#Code#" <cfif fd eq Code> SELECTED</cfif>>#Code#</option>
					   </cfloop>
				   	   </select>
					   </td>				  					   
					   <td></td>
					   
					   <td style="padding-left:3px">
					   				   
					   <select name="objectcde" id="objectcde" class="regularxxl" style="width:100%">
			           <cfloop query="ObjectList">
					     <option value="#Code#" <cfif obj eq Code> SELECTED</cfif>>#Code# #Description#</option>
					   </cfloop>
				   	   </select>
					   </td>
				   
				   <cfelse>
				   
					     <td class="labelit" style="padding-left:3px">#Fund#</td>
												  
						 <cfquery name="Program" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT * FROM ProgramPeriod
								WHERE ProgramCode = '#ProgramCode#'
								AND   Period = (SELECT PlanningPeriod 
								                FROM   Organization.dbo.Ref_MissionPeriod 
												WHERE  Mission = '#Requisition.Mission#' 
												AND    Period = '#url.per#')					
							</cfquery>
						 						 						 
						 <td class="labelit" style="padding-left:3px">
						 <cfif programName neq "">
						 
							 <cfif Program.reference neq "">
							 #Program.Reference#
							 <cfelse>
							 #ProgramCode#
							 </cfif>
							 &nbsp; #ProgramName# 							
						 <cfelse>
						 
							 <cfif Parameter.EnforceProgramBudget eq "1">n/a</cfif>
							 
						 </cfif>
						 
						 </td>
						 <td class="labelmedium2" style="padding-left:3px"><cfif CodeDisplay neq "">#CodeDisplay#<cfelse>#ObjectCode#</cfif> #Description#</td>
						 <input type="hidden" name="fund" id="fund" value="#Fund#">
						 <input type="hidden" name="objectcde" id="objectcde" value="#ObjectCode#">
					 
				   </cfif>	 
				   			   
				   <input type="hidden" name="programcode" id="programcode" value="">
				 			   
				   <td style="padding-left:3px">
				  	 <input type="Text" class="regularxxl" name="percentage" id="percentage" value="#percentage*100#" size="2" style="text-align:center" maxlength="5">&nbsp;%
				   </td>
				   
				   <td></td>
				   
				   <td colspan="3" align="right" style="padding-right:10px">	
				  	 <cfoutput>		   
					   <input class="button10g" 
					          type="button" 
							  name="save"
                              id="save" 
							  style="width:70;height:28px;"
							  value="#vSave#" 
							  onclick="funding('','#fundingid#','save',document.getElementById('fund').value,document.getElementById('objectcde').value,document.getElementById('programcode').value,document.getElementById('percentage').value,document.getElementById('programperiod').value)">
					 </cfoutput>
				   </td>
				   	
			    </TR>	
								
				<cfif Parameter.FundingDetail eq "1">
				<tr style="height:0px">
				
				<td colspan="7" style="padding-left:20px">	
						
					<cf_securediv bind="url:#SESSION.root#/Procurement/Application/Requisition/FundingDetail/FundingDetail.cfm?id=#url.id#&fundingid=#url.fundingid#" 
					       id="i#url.fundingid#">												
				</td>
				</tr>
				</cfif>
				
			<cfelse>
			
						
				<TR class="labelmedium navigation_row line">
				    <td width="50" style="padding-left:3px">#ProgramPeriod#</td>
				    <td width="50" style="padding-left:3px">#Fund#</td>
										
					 <cfquery name="Program" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT * 
							FROM  ProgramPeriod
							WHERE ProgramCode = '#ProgramCode#'
							AND   Period = (SELECT PlanningPeriod 
							                FROM   Organization.dbo.Ref_MissionPeriod 
											WHERE  Mission = '#Requisition.Mission#' 
											AND    Period = '#ProgramPeriod#')					
					</cfquery>
													 						 						 
					<td>
					 
					 	<cfif ProgramName neq "">	
						    <a href="javascript:AllotmentInquiry('#ProgramCode#','#fund#','#URL.Per#','Budget','#Edition.Version#')">
								 <font color="0080C0">
								 <cfif Program.reference neq "">
								 #Program.Reference#
								 <cfelse>
								 #ProgramCode#
								 </cfif>												 
								 &nbsp;#ProgramName# 							
								 </font>							 
						    </a>	
						<cfelse>
							<cfif Parameter.EnforceProgramBudget eq "1">  n/a </cfif>													
						</cfif>
						 
					</td>					
					
					<td style="padding-left:3px"><cfif CodeDisplay neq "">#CodeDisplay#<cfelse>#ObjectCode#</cfif> #Description# </td>
					<td style="padding-left:3px" width="50">#numberformat(Percentage*100,"._")#%</td>
															
					<cfset amt = requisition.requestamountbase*percentage>
					
					<td align="right" style="padding-left:3px">
						<table>
							<tr>					
							<cfif Parameter.EnforceProgramBudget eq "1">		
								<td style="padding-top:2px;padding-right:4px">
									<cf_img icon="help" tooltip="Inquiry" onclick="detailfunding('tpc','detail','#fund#','#url.id#','#programperiod#','#programcode#','#ObjectCode#','view','view','#prior.mission#','','')">
								</td>
							</cfif>					
							<td style="height:20px" class="labelmedium">#numberformat(amt,",.__")#</td>
							</tr>
						</table>
					</td>
					<td style="padding-left:6px" align="right">#dateformat(created,CLIENT.DateFormatShow)#</td>
					<td align="center" style="padding-left:3px">
																									   
						 <table class="formpadding">
						   
						   <tr>			
						   
						     <cfif URL.Access eq "Edit">	
							 
							  <!--- show only if indeed	has records --->
							  
							    <cfquery name="Activity" 
									datasource="AppsProgram" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">		
										SELECT    *												  
										FROM      ProgramActivity
										WHERE     ProgramCode = '#ProgramCode#' 
										AND       RecordStatus <> '9' 													
									</cfquery>		
																 
							   <cfif activity.recordcount gte "1">
						       	<td style="padding-left:4px;padding-top:2px"><cf_img tooltip="Split funding by activity" icon="open" onclick="detailactivity('#requisitionno#','#fundingid#')"></td>
						  	   </cfif>
							   
							   <td style="padding-left:3px;padding-top:3px">						   
								   	<cf_img icon="edit" onclick="funding('','#FundingId#','edit')">						   
							   </td>						   
							   <td style="padding-left:2px;padding-top:3px">								   
								   <cfif funding.recordcount gte "2">							   
								       <cf_img icon="delete" onclick="funding('','#FundingId#','del')">								
								   </cfif>								
							   </td>
						   
						    </cfif>	
							
						 </tr>
						</table>						   
						   
					   </td>
   			    </tr>	
																
				<tr style="height:0px">								
				<td colspan="7" style="padding-left:20px">												
				    <cf_securediv bind="url:#SESSION.root#/Procurement/Application/Requisition/FundingDetail/FundingDetail.cfm?id=#url.id#&fundingid=#fundingid#&access=view" 
					       id="i#fundingid#">					
				</td>				
				</tr>
									
			</cfif>
						
			</cfloop>
			</cfoutput>		
			
			<cfif Parameter.EnforceProgramBudget eq "0" and (URL.Access eq "Edit" or percentage.percentage neq "1")>
			
					<cfquery name="Check" 
					     datasource="AppsPurchase" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
							SELECT ObjectCode 
			                FROM   ItemMasterObject 
							WHERE  Itemmaster = '#URL.itemmaster#'
					</cfquery>		
			
				    <cfif Check.recordcount gte "1">
					
						<cfquery name="Check" 
					     datasource="AppsProgram" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
							SELECT Code 
			                FROM   Program.dbo.Ref_Object 
						    WHERE  Code IN (SELECT ObjectCode 
							                FROM   Purchase.dbo.ItemMasterobject 
											WHERE  Itemmaster = '#URL.itemmaster#')
						</cfquery>	
						
						<cfif check.recordcount eq "0">
						 <tr><td><font color="FF0000">Problem, object codes no longer exist. Please contact your administrator.</td></tr>
						 <cfabort>
						</cfif>
								
					</cfif>
										
					<cfif perc gt "0" and (URL.FundingId eq "undefined" or URL.FundingId eq "")>
													
					<tr><td height="3"></td></tr>
							
					<TR>
					
					   <td>
					   
					   <select name="programperiod" id="programperiod" class="regularxxl" style="width:100%">
			           <cfoutput query="PeriodList">
					     <option value="#Period#" <cfif url.per eq period>selected</cfif>>#Period#</option>
					   </cfoutput>
				   	   </select>
					   
					   </td>
					
					   <td style="padding-left:3px">
					   <select name="fund" id="fund" class="regularxxl" style="width:100%">
			           <cfoutput query="FundList">
					     <option value="#Code#">#Code#</option>
					   </cfoutput>
				   	   </select></td>
					   
					   <td></td>
					 					   
					   <td style="padding-left:3px">
					    <select name="objectcde" id="objectcde" class="regularxxl" style="width:100%">
			           <cfoutput query="ObjectList">
					     <option value="#Code#">#Code# #Description#</option>
					   </cfoutput>
				   	   </select>
					   </td>
					   <td style="padding-left:3px">
					   <cfoutput>
					   <input type="Text" name="percentage" id="percentage" class="regularxxl" value="#perc*100#" range="1,#perc*100#" message="You entered an invalid percentage" validate="integer" required="Yes" size="3" maxlength="3" style="width:90%;height;21;font-size:13px;text-align:center">
					   </cfoutput>
					   </td>
					   <td>%</td>					   
					   <input type="hidden" name="programcode" id="programcode" value="">					   					   
					   <td colspan="3" style="padding-left:3px">
					   
					   <cfoutput>
					   
					       <input class   = "button10g"
						          type    = "button" 
							      name    = "save" 
                                  id      = "save"
							      style   = "width:80px;height:29px"
							      value   = "#vSave#" 
							      onclick = "funding('','','save',document.getElementById('fund').value,document.getElementById('objectcde').value,document.getElementById('programcode').value,document.getElementById('percentage').value,document.getElementById('programperiod').value)">
							 
					   </cfoutput>
					   
					</TR>	
														
					</cfif>	
					
			</cfif>			
			
			</table>		
			</td>
			</tr>		
		   							
	</table>	
	
	
</cfif>	

<cfset ajaxonload("doHighlight")>

		