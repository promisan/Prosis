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

<cfparam name="url.programcode"   default="">
<cfparam name="url.period"        default="">
<cfparam name="url.editionid"     default="">
<cfparam name="url.objectcode"    default="">
<cfparam name="url.activityid"    default="">
<cfparam name="url.requirementid" default="">
<cfparam name="url.mode"          default="view">
<cfparam name="url.cell"          default="">
<cfparam name="url.OERefresh"     default="0">

<!--- edition is locked = 3 --->

<cfinvoke component="Service.Access"  
	Method         = "budget"
	ProgramCode    = "#URL.ProgramCode#"
	Period         = "#URL.Period#"	
	EditionId      = "#URL.editionId#"  
	Role           = "'BudgetManager'"
	ReturnVariable = "BudgetObject">	

<cfif url.editionid eq "">

	<!--- we determine the default edition --->
		
	<cfquery name="getEdition" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      Ref_MissionPeriod
		WHERE     Mission        = (SELECT Ox.Mission 
		                            FROM Program.dbo.ProgramPeriod PPx 
									     INNER JOIN Organization.dbo.Organization Ox ON PPx.OrgUnit = Ox.OrgUnit 
								    WHERE PPx.ProgramCode = '#URL.ProgramCode#' AND PPx.Period = '#URL.Period#') 
		AND       PlanningPeriod = '#url.Period#' 
		AND       isPlanPeriod = 1
	</cfquery>
			
	<cfset url.editionid = getEdition.editionid>

</cfif>

<cfif url.editionid eq "">

	<table align="center">
		<tr>
			<td class="labelmedium">
			<font color="FF0000">Problem, edition could not be determined. Please contact your administrator</font>
			</td>
		</tr>
	</table>
	<cfabort>

</cfif>

<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *,
			 (SELECT Ox.Mission FROM Program.dbo.ProgramPeriod PPx INNER JOIN Organization.dbo.Organization Ox ON PPx.OrgUnit = Ox.OrgUnit WHERE PPx.ProgramCode = Pe.ProgramCode AND PPx.Period = Pe.Period) as UnitMission
	FROM     Program P
			 INNER JOIN ProgramPeriod Pe
			 	ON P.ProgramCode = Pe.ProgramCode
	WHERE    P.ProgramCode  = '#url.programcode#' 
	AND      Pe.Period      = '#url.period#' 	
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
	FROM      Ref_AllotmentEdition R, Ref_AllotmentVersion V
	WHERE     Editionid     = '#url.editionid#' 
	AND       R.Version = V.Code
</cfquery>

<cfquery name="Object" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     R.Code as Resource,
	           R.Description as Category, 
	           R.ListingOrder as CategoryOrder, 
			   O.Code, 
			   O.CodeDisplay,
			   ParentCode, 			   
			   O.Description AS Description, 
			   O.ListingOrder,
			   (SELECT count(*) FROM Ref_Object WHERE ParentCode = O.Code) as isParent	
	FROM       #LanPrefix#Ref_Object O INNER JOIN
	           #LanPrefix#Ref_Resource R ON O.Resource = R.Code
	WHERE	   ObjectUsage = '#Edition.ObjectUsage#' 	
	
		
	<cfif  BudgetObject eq "EDIT" or BudgetObject eq "ALL">
	AND        RequirementEnable IN ('1','2')
	<cfelse>
	AND        RequirementEnable IN ('1')
	</cfif>
	<!--- only if the code has an item master --->
	
		
	AND  (
	    		
		      O.Code IN (SELECT ObjectCode 
			             FROM   Purchase.dbo.ItemMasterObject 
						 WHERE  ItemMaster IN (SELECT ItemMaster 
                                               FROM   Purchase.dbo.ItemMaster 
											   WHERE  Operational = 1)
						)					  	

			  <cfif Parameter.BudgetObjectMode eq "Parent">					  
			  			
			  AND
			 			  			  
			   (
			  
			   O.Code IN (SELECT ParentCode
			              FROM   Ref_Object 
						  WHERE  ObjectUsage = '#Edition.ObjectUsage#' 	
						  UNION 
						  SELECT Code
						  FROM   Ref_Object
						  WHERE  ObjectUsage = '#Edition.ObjectUsage#' 	
						  AND    (ParentCode is NULL or ParentCode = '')
						  )
			  
			   )
			   			  
			  </cfif>			  						   
					   
		      OR
			  <!--- already used and thus to be shown --->
	    	  O.Code IN (
			             SELECT ObjectCode 
			             FROM   ProgramAllotmentDetail 
						 WHERE  ProgramCode = '#url.programcode#'
			             AND    EditionId IN ('#url.editionid#')
						)
		  )		  
		  
		  
		  ORDER BY R.ListingOrder
		  
		   
</cfquery>

<cfif Edition.status eq "1">

	<!--- edition is open --->

	<cfinvoke component="Service.Access"  
		Method         = "budget"
		ProgramCode    = "#URL.ProgramCode#"
		Period         = "#URL.Period#"	
		EditionId      = "#URL.editionId#"  
		Role           = "'BudgetManager','BudgetOfficer'"
		ReturnVariable = "BudgetAccess">	

<cfelse>

	<!--- edition is locked = 3 --->

	<cfinvoke component="Service.Access"  
		Method         = "budget"
		ProgramCode    = "#URL.ProgramCode#"
		Period         = "#URL.Period#"	
		EditionId      = "#URL.editionId#"  
		Role           = "'BudgetManager'"
		ReturnVariable = "BudgetAccess">	

</cfif>

<cfif (BudgetAccess eq "EDIT" or BudgetAccess eq "ALL") and url.mode neq "Add">

	 <cfset url.mode = "edit">

</cfif>


<cfif url.mode eq "resource">
	<cfset user = "Yes">
<cfelse>
	<cfset user = "No">
</cfif>

<cfoutput>

<cfif url.activityid eq "">

	<cf_screentop height="100%" 
	    scroll="Yes"
		html="Yes" 
		band="no" 
		systemmodule="Budget" 
		functionclass="Window" 
		functionName="Financial Requirement" 		
		layout="webapp" 
		banner="gray"
		border="0" 
		jQuery="yes"
		line="no"		
		label="#Edition.Description# for plan period #URL.Period#"
		option="Financial Requirements">
	
<cfelse>
	
	<cf_screentop height="100%" 
	    scroll="Yes"
		html="no" 
		band="no" 
		systemmodule="Budget" 
		functionclass="Window" 
		functionName="Financial Requirement" 	
		layout="webapp" 
		banner="gray"
		border="0" 
		jQuery="yes"
		line="no"		
		label="#Edition.Description# for plan period #URL.Period#"
		option="Financials requirements">

</cfif>	

<cfinclude template="RequestScript.cfm">
<cf_dialogOrganization>
<cf_calendarscript>
	
<script>

	function object(obj) {  		    
	    se = dialogview.document.getElementById("requirementid").value		
		if (se == "") {
        alldetinsert('#url.editionid#_'+obj,'#url.editionid#',obj,'','add','dialog')     
		} else {
		alldetinsert('#url.editionid#_'+obj,'#url.editionid#',obj,se,'edit','dialog')   
		}		
        ptoken.navigate('ObjectSelect.cfm?objectcode='+obj+'&prior='+selectme.value,'selected')				
	}
	
	function period(edi,obj) {  		
		ptoken.navigate('setLabel.cfm?period=#url.period#&editionid='+edi,'selected')
		ptoken.open("RequestDialogView.cfm?mode=#url.mode#&requirementid=#url.requirementid#&programcode=#url.programcode#&period=#url.period#&activityid=#url.activityid#&editionid="+edi+"&objectcode="+obj+"&cell=#url.cell#","dialogview")
		ptoken.navigate('ObjectSelect.cfm?objectcode='+obj+'&prior='+document.getElementById('selectme').value,'selected')	 	
	}
	
	function reload(obj) {            	
       	ptoken.open("RequestDialogView.cfm?mode=#url.mode#&requirementid=#url.requirementid#&programcode=#url.programcode#&period=#url.period#&activityid=#url.activityid#&editionid=#url.editionid#&objectcode="+obj+"&cell=#url.cell#","dialogview")
		ptoken.navigate('ObjectSelect.cfm?objectcode='+obj+'&prior='+selectme.value,'selected')
	}
	
	function getrate(row,prg,mas,top,mde,rid,obj,loc,per) {		
				
		if (mde == "refresh") {
		
			dialogview.document.formrequest.onsubmit() 
			if( _CF_error_messages.length == 0 ) {    		 
				dialogview.ptoken.navigate("#SESSION.root#/programrem/Application/Budget/Request/RateCalculation.cfm?row="+row,'entrydialogsave','','','POST','formrequest');						
			 }  	
			 		
		} else {
		
			se = dialogview.document.getElementById('dPrice_'+row);
			
			if (se.style.display == "none")	{

				se.style.display="inline";	
				se.style.visibility ="visible";													
				dialogview.ptoken.navigate("RequestDialogGetRate.cfm?row="+row+"&objectcode="+obj+"&location="+loc+"&programcode="+prg+"&period="+per+"&itemmaster="+mas+"&topicvaluecode="+top+"&mode="+mde+"&requirementid="+rid,'dPrice_'+row);		
				
			} else {
				se.style.display="none";	
				se.style.visibility ="hidden";	
			}
			
		}		
	
	}

</script>
	
	<table width="100%" height="100%" align="center">
	
	<tr class="line">
	<td style="padding-top:4px;padding-bottom:2px"><cfinclude template="RequestMenu.cfm"></td>
	</tr>
				
	<tr><td width="100%" 
	        height="100%" 
			colspan="4" valign="top" style="padding:2px" valign="middle" align="center">
			
			<cfif Object.recordcount eq "0">
	
	          <table><tr><td height="60" class="labelmedium">
				<font color="0080C0">No object codes are available for requirement definition. It might be that no item masters were associated yet.</font>
				</td></tr></table>
	
			<cfelse>
						
			<iframe name    = "dialogview" 
		        src         = "RequestDialogView.cfm?mode=#url.mode#&requirementid=#url.requirementid#&programcode=#url.programcode#&period=#url.period#&activityid=#url.activityid#&editionid=#url.editionid#&objectcode=#url.objectcode#&cell=#url.cell#&mid=#url.mid#" 
				id          = "dialogview" 
				width       = "100%"
				height      = "100%" 
				scrolling   = "auto" 
				frameborder = "0"></iframe>
				
			</cfif>	
					
	</td></tr>
	
	<tr><td height="7"></td></tr>
	
	</table>

</cfoutput>

<cfif url.OERefresh eq "1">
	<cfset AjaxOnLoad("function(){ $('##ObjectSelect').trigger('onchange'); }")>
</cfif>

<cf_screenbottom layout="webapp">
