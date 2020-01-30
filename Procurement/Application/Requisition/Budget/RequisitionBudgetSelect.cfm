
<cfoutput>

<!--- define expenditure periods --->

<cfquery name="Allotment" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_AllotmentEdition
	WHERE     EditionId = '#url.editionid#'
</cfquery>

<cf_screentop height="100%" layout="webapp" jquery="Yes" banner="red" label="Internal Budget #Allotment.Description# of #URL.Mission#" scroll="yes">

<cfparam name="url.object" default="">

<script>
ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 	 	 		 	
	 if (fld != false){			 
		 itm.className = "highLight3";				 
	 }else{			 
	     itm.className = "header";		
	 }
  }
  
function object(prg,mis,period,cls,hier,edt,fund) {
			
	icM  = document.getElementById(prg+"_"+edt+"_"+fund+"Min")
    icE  = document.getElementById(prg+"_"+edt+"_"+fund+"Exp")
	se   = document.getElementById("d"+prg+"_"+edt+"_"+fund);				
	
	if (se.className == "hide") {
	    se.className = "regular"
		icM.className = "regular"
		icE.className = "hide"
		ColdFusion.navigate('RequisitionBudgetSelectObject.cfm?Object=#URL.Object#&id=#url.id#&programcode='+prg+'&programclass='+cls+'&mission=#URL.mission#&programhierarchy='+hier+'&period='+period+'&edition='+edt+'&fund='+fund,'i'+prg+'_'+edt+'_'+fund)	
	} else {
	    se.className = "hide"
		icE.className = "regular"
		icM.className = "hide"	
	}					
	 		 		
  }
  
function bmore(tpc,box,fund,reqno,period,prg,obj,act,mode) {	
        
		se   = document.getElementById(tpc+box);			
				 
		if (se.className == "hide") {	      	
			se.className  = "regular";		
			ColdFusion.navigate('../Requisition/RequisitionEntryBudgetListing.cfm?mission=#URL.mission#&box='+box+'&reqno='+reqno+'&fund='+fund+'&period='+period+'&programcode='+prg+'&objectcode='+obj+'&mode='+mode,'i'+tpc+box)	 
		} else {	         	
	        se.className  = "hide"	 		
		}		 		
	}
	
 
</script>

</cfoutput>

<cf_DialogProcurement>
<cf_DialogLedger>

<cfparam name="URL.Period" default="FY 04/05">
<cfparam name="URL.Org"    default="0">
<cfparam name="URL.Job"    default="">
<cfparam name="URL.ID"     default="">

<cfset persel = "'#Allotment.Period#'">

<!--- define expenditure periods --->

<cfquery name="Expenditure" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_MissionPeriod
	WHERE     Mission = '#URL.Mission#'
	<cfif Allotment.Period neq "">
	AND       Period  = '#Allotment.Period#'
	</cfif>
</cfquery>

<cfloop query="Expenditure">

  <cfif persel eq "">
     <cfset persel = "'#Period#'"> 	
  <cfelse>
     <cfset persel = "#persel#,'#Period#'">	
  </cfif>
  
</cfloop>


<cfif persel eq "">

	<cf_message message="Problem with defined periods. Please contact your administrator">
	<cfabort>

</cfif>


<cfif URL.Job eq "">

    <cfif len(URL.Org) gt 20>
	
		<cfquery name="Per" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_MissionPeriod
		WHERE  Mission = '#URL.Mission#'
		AND    Period = '#URL.Period#'    
		</cfquery>
	
		<cfquery name="Unit" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Organization
		 WHERE  Mission = '#URL.Mission#'
		 AND    MandateNo = '#Per.MandateNo#'
		 AND    MissionOrgUnitId = '#URL.Org#'  
	    </cfquery>
		
		<cf_OrganizationSelect OrgUnit = "#Unit.OrgUnit#">  
		
	<cfelse>	
	
		<cf_OrganizationSelect OrgUnit = "#URL.Org#">  
	
	</cfif>
	
</cfif>	

<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_AllotmentEditionFund
	WHERE    EditionId  = '#URL.EditionId#'		
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#URL.Mission#'
</cfquery>

<cf_tl id="Select" var="1">
<cfset vSelect=#lt_text#>

<form target="result" action="RequisitionBudgetSelectSubmit.cfm?ID=<cfoutput>#URL.ID#</cfoutput>" method="POST" name="fund" id="fund">

<table width="98%" align="center" cellspacing="0" cellpadding="0" class="navigation_table">

<tr class="labelit">	
	<td height="20"></td>
	<td>Project/Program Name</td>
	<td colspan="1" align="right"><cf_tl id="Allotment"></td>
	<td colspan="1" align="right"><cf_tl id="Pre-encum"></td>
	<td colspan="1" align="right"><cf_tl id="Obligated"></td>
	<td colspan="1" align="right"><cf_tl id="Expenditure"></td>	
</tr>
<tr><td colspan="6" class="line" height="1"></td></tr>

<!--- overall totals --->
<cfinclude template="RequisitionBudgetSelectBaseFile.cfm">

<cfset cnt = 0>


<cfloop query="Edition">

	<!--- ----------------------------------------------------------------------------- --->
	<!--- provision to open the selected object of expenditire upon editing of the fund --->
	<!--- ----------------------------------------------------------------------------- --->
	
	<cfquery name="Current" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   DISTINCT ProgramCode
		FROM     RequisitionLineBudget
		WHERE    RequisitionNo = '#URL.ID#' 	
		AND      Fund          = '#fund#'
	</cfquery>
	
	<cfset cur = "">
	<cfloop query="current">
		<cfset cur = "#cur#,#programcode#">
	</cfloop>	
		
	<!--- ----------------------------------------------------------------------------- --->
	<!--- select fundable programs ---------------------------------------------------- --->
	<!--- ----------------------------------------------------------------------------- --->
		
	<cfquery name="Program" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   P.ProgramCode,
		         P.ProgramName,
				 Pe.PeriodDescription as ProgramDescription,
				 P.ProgramClass, 
				 Pe.PeriodHierarchy as ProgramHierarchy
		FROM     Program P INNER JOIN
		         ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode
		WHERE    P.Mission = '#URL.Mission#' 
		AND      Pe.Period = '#URL.Period#' 
		
		<cfif URL.Job eq ""> 	
		   			
			AND      Pe.OrgUnit IN (SELECT  OrgUnit 
			                        FROM    Organization.dbo.Organization
			                        WHERE   Mission = '#URL.Mission#'
									AND     HierarchyCode >= '#HStart#' 
									AND     HierarchyCode < '#HEnd#') 
			
		<cfelse>  <!--- provision for job additions S&H --->
		
		AND       Pe.OrgUnit IN (SELECT OrgUnit 
		                          FROM  Purchase.dbo.RequisitionLine 
								  WHERE JobNo = '#URL.Job#')  
		</cfif>	
		
		<!--- ---------------------------------------------------- --->
		<!--- additional filter added, to be checked for CMP as they might link for project which 
		are not funded, make it a parameter instead --->
		
		<!--- show only programs that have or a budget or have a funding used --->
		
		<cfif Parameter.FundingOnProgram eq "1">
				
		AND    P.ProgramCode IN (
		
							   <!--- used in allotment --->	
		
							   SELECT DISTINCT PD.ProgramCode 
		                       FROM  ProgramAllotmentDetail PD
							   WHERE PD.ProgramCode = P.ProgramCode							  
							   AND   PD.Period      = '#URL.Period#' 
							   AND   PD.Fund        = '#Fund#'
							   <!---
							   AND   PD.AmountBase  <> '0'
							   --->
							   
							   UNION  <!--- used in purchase --->
							   
							   SELECT DISTINCT F.ProgramCode 
		                       FROM  Purchase.dbo.RequisitionLine R,
							         Purchase.dbo.RequisitionLineFunding F
							   WHERE R.RequisitionNo = F.RequisitionNo
							   AND   R.Mission       = '#URL.Mission#'
							   <!--- removed by hanno, we can safely allow for this
							   AND   R.Period        = '#URL.Period#'
							   --->
							   AND   F.ProgramCode   = P.ProgramCode
							   AND   F.Fund          = '#Fund#'
							   
							 
		                       
							  ) 
							   
		</cfif>					   
		AND      Pe.RecordStatus <> '9'	
		
		ORDER BY Pe.PeriodHierarchy	
	</cfquery>
	
	<cfif program.recordcount gte "1">
		<cfoutput>
			<tr><td colspan="6" class="line" height="1"></td></tr>
			<tr class="labelit"><td colspan="6" height="1"><font size="2"><b>#Fund#</b></font></td></tr>
			<tr><td colspan="6" class="line" height="1"></td></tr>	
		</cfoutput>
	</cfif>		
	
	<cfset cnt = cnt+program.recordcount>
		
	<cfset edid = editionid>
	<cfset fdid = fund>
					 
	<cfoutput query="Program">
		
		<cfif ProgramClass eq "Program">
			 <cfset cl = "e7e7e7">
		<cfelseif ProgramClass eq "Component">
			 <cfset cl = "f1f1f1"> 
		<cfelse>
			 <cfset cl = "ffffff">
		</cfif>
		
		<cfif ProgramClass neq "xxxx">
		
			<tr class="labelit" bgcolor="#cl#" class="navigation_row"
			onclick="object('#programcode#','#url.mission#','#url.period#','#programclass#','#programhierarchy#','#edid#','#fdid#')">
		
		<cfelse>
		
			<tr class="labelit" bgcolor="#cl#" class="navigation_row">
		
		</cfif>
		
		<td align="center" width="30">
		
		<cf_space spaces="6">
		
		<cfif ProgramClass neq "xxxxx">
		
		   <img src="#SESSION.root#/Images/icon_expand.gif" alt="" 
				id="#programcode#_#edid#_#fdid#Exp" border="0" class="regular" 
				align="absmiddle" style="cursor: pointer;">
										
		   <img src="#SESSION.root#/Images/icon_collapse.gif" 
				id="#programcode#_#edid#_#fdid#Min" alt="" border="0" 
				align="absmiddle" class="hide" style="cursor: pointer;">
				
		</cfif>			
				
		</td>
			
		<td colspan="1" width="80%">
		<cfloop index="itm" list="#ProgramHierarchy#" delimiters=".">
		  <b>.&nbsp;&nbsp;</b>
		</cfloop>
		 <a title="#programdescription#"><cfif ProgramClass neq "Program">#ProgramClass# - </cfif> #ProgramName#</a>
		</td>
				
		<td align="right"
	    style="border-left: 1px solid Gray; padding: 1;">
		
			<cfif ProgramClass neq "-----Project">
		
				<cfquery name="Total" 
				datasource="AppsQuery" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    SUM(Total) AS Total
				FROM      dbo.#SESSION.acc#Release
				WHERE     ProgramCode IN (SELECT ProgramCode 
				                       FROM Program.dbo.ProgramPeriod
									   WHERE Period = '#url.Period#'
									   AND   PeriodHierarchy LIKE '#ProgramHierarchy#%')
				AND       Fund = '#fdid#'							 
			    </cfquery>
				
				<cfif Total.total eq "">
					  <cfset all = 0>
				<cfelse>
					  <cfset all =  Total.total>
				</cfif>
					
				<cf_space align="right" label="#numberformat(all/1000,"_,_._")#" spaces="23">
			
			</cfif>
		
		</td>
		
		<td align="right" style="border-left: 1px solid Gray; padding: 1;">
			
			<!--- define reservations --->
			<cfquery name="Reservation" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   SUM(ReservationAmount) as ReservationAmount
			FROM     dbo.#SESSION.acc#Requisition
			WHERE    ProgramCode IN (SELECT ProgramCode 
				                       FROM Program.dbo.ProgramPeriod
									   WHERE Period = '#url.Period#'
									   AND   PeriodHierarchy LIKE '#ProgramHierarchy#%')
			AND       Fund = '#fdid#'							   
			</cfquery>
			
			<cfif Reservation.ReservationAmount eq "">
			  <cfset res = 0>
			<cfelse>
			  <cfset res =  Reservation.ReservationAmount>
			</cfif>
		
			
			<cf_space align="right" label="#numberformat(res/1000,"_,_._")#" spaces="23">
		
		</td>
		<td align="right" style="border-left: 1px solid Gray;padding: 1;">
			
			<!--- define obligations --->
			<cfquery name="Obligation" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   SUM(ObligationAmount) as ObligationAmount
			FROM     dbo.#SESSION.acc#Obligation
			WHERE    ProgramCode IN (SELECT ProgramCode 
				                       FROM Program.dbo.ProgramPeriod
									   WHERE Period = '#url.Period#'
									   AND   PeriodHierarchy LIKE '#ProgramHierarchy#%')
			AND       Fund = '#fdid#'							   
			</cfquery>
			
			<cfif Obligation.ObligationAmount eq "">
			  <cfset obl = 0>
			<cfelse>
			  <cfset obl =  Obligation.ObligationAmount>
			</cfif>
						
			<cf_space align="right" label="#numberformat(obl/1000,"_,_._")#" spaces="23">
			
		
		</td>
		<td align="right" style="border-left: 1px solid Gray;padding: 1;">
		
		<cf_space align="right" label="#numberformat((Obl+res)/1000,"_,_._")#" spaces="23">
		
		</td>
				
		</tr>
		<tr id="d#ProgramCode#_#edid#_#fdid#" class="hide"><td></td>
		     <td colspan="5" align="right"><cfdiv id="i#ProgramCode#_#edid#_#fdid#"/></td>
		</tr>			
								 
		<cfif find(programcode,cur)>
		
			<script>
			try {document.getElementById('#programcode#_#edid#_#fdid#Exp').click() } catch(e) {}		
			</script>	 
			 
		</cfif> 
		
	</cfoutput>	
				
	</cfloop>
	
	<!--- final section --->
	
	<cfif cnt eq "0">

	     <cf_message message = "Sorry, but I am not able to locate any programs for your unit. Request can not be completed!"
    	  return = "close">
		  
	     <cfabort>

	<cfelse>
						
		<tr><td height="1" colspan="6" class="linedotted"></td></tr>
		
		<tr class="hide"><td colspan="6">
			<iframe name="result" id="result" width="100%" height="100" frameborder="0"></iframe>
		</td></tr>
		
		<tr><td height="28" colspan="6" align="center">
		<cfoutput>
		<input type="button" name="Close" id="Close" value="Close" class="button10g" onclick="window.close()">
		<input type="submit" name="Submit" id="Submit" value="#vSelect#" class="button10g">
		</cfoutput>
		</td></tr>
	
	</cfif>
	
	</table>

</form>

<cf_screenbottom layout="innerbox">

<cfset ajaxonload("doHighlight")>

