
<cfquery name="Parameter" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  *
FROM Parameter
</cfquery>

<cfparam name="url.verbose" default="">
<cfparam name="url.output"  default="">

<cfparam name="client.verbose" default="#url.verbose#">

<cfif url.verbose eq "">
	<cfset url.verbose = client.verbose>
<cfelse>
    <cfset client.verbose = url.verbose>	
</cfif>


<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  P.*, 
	        O.OrgUnitName as OrganizationName, 
			Pe.OrgUnit, 
			O.Mission, 
			O.OrgUnitCode, 
			Pe.Reference, 
			Pe.ReferenceBudget1,
			Pe.ReferenceBudget2,
			Pe.ReferenceBudget3,
			Pe.ReferenceBudget4,
			Pe.ReferenceBudget5,
			Pe.ReferenceBudget6,
			Pe.Period, 
			Pe.ProgramManager, 
			Pe.PeriodDescription,
			Pe.PeriodObjective,
			Pe.PeriodGoal,
			Pe.ProgramId,
			Pe.Status 
	FROM    #CLIENT.LanPrefix#Program P, Organization.dbo.#CLIENT.LanPrefix#Organization O, #CLIENT.LanPrefix#ProgramPeriod Pe
	WHERE   Pe.OrgUnit       = O.OrgUnit
	AND     P.ProgramCode    = '#URL.ProgramCode#'
	AND     Pe.ProgramCode   = P.ProgramCode
	AND     Pe.Period        = '#URL.Period#'
</cfquery>

<cfquery name="Param" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  *
FROM    Ref_ParameterMission
WHERE    Mission = '#Program.Mission#' 
</cfquery>


<cfinvoke component="Service.Access"
	Method="program"
	ProgramCode="#URL.ProgramCode#"
	Period="#URL.Period#"
	ReturnVariable="ProgramAccess">	

<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="e8e8e8">
	
	 <cfoutput query="Program"> 
	 	 
     <tr class="line">
        <td width = "20%"  class="labelmedium"><cf_tl id="Code">:</td>
        <td colspan="2" id="ref_#programid#" class="labelmedium">
		
		<cfif ReferenceBudget1 neq "">#ReferenceBudget1#-#ReferenceBudget2#-#ReferenceBudget3#-#ReferenceBudget4#-#ReferenceBudget5#-#ReferenceBudget6#
			<cfelseif Reference neq "">#Reference# <font size="1">(#ProgramCode#)</font>
			<cfelse>#ProgramCode#</cfif>		
		</td>		
		
	</tr>
		
     			
    <tr class="line">
	
        <td  class="labelmedium"><cf_tl id="Name">:</td>
        <td colspan="1" id="nme_#programid#" class="labelmedium"><b>#ProgramName#</b>
		
		<td align="right" style="padding-right:10px">
		<cfif url.Verbose eq "0">
				<img src="#SESSION.root#/Images/down2.gif" alt="" border="0"
				onclick="ColdFusion.navigate('#SESSION.root#/ProgramRem/Application/Program/Header/ProgramViewHeaderContent.cfm?programcode=#url.programcode#&period=#url.period#&verbose=1','header')"
			align="absmiddle" 
			style="mouse:pointer">
		</cfif>			
		
		</td> 		
      </tr>
	  	
     </cfoutput>
	 
<cfif url.Verbose eq "1">
   	 
	 <cfoutput query="Program"> 
	 
	  <tr class="line">
        <td  class="labelmedium"><cf_tl id="Description">:</td>
        <td colspan="2" class="labelmedium">#PeriodDescription#</td>
      </tr>
	 	 
	 <cfif Param.EnableObjective eq "1">	
	  
     <tr class="line">
        <td  class="labelmedium"><cf_tl id="Goal">:</td>
        <td colspan="2" class="labelmedium">#PeriodGoal#</td>
      </tr>
		 
     <tr class="line">
        <td  class="labelmedium"><cf_tl id="Objective">:</td>
        <td colspan="2" class="labelmedium">#PeriodObjective#</td>
      </tr>
			 
	 </cfif>
	  
      <tr class="line">
        <td  class="labelmedium"><cf_tl id="Period">:</td>
        <td colspan="2" class="labelmedium"><b>#Period#</b> [<cf_tl id="Entered">: #Dateformat(Created, CLIENT.DateFormatShow)#] </td>
      </tr>

      <tr class="line">
        <td  class="labelmedium"><cf_tl id="Organization">:</td>
        <td colspan="2" class="labelmedium"><b><a href="javascript:viewOrgUnit('#OrgUnit#')">#OrganizationName#</a></b></td>
      </tr>
			  
     <tr class="line">
        <td  class="labelmedium"><cf_tl id="Program Officer">:</td>
        <td colspan="2" class="labelmedium">#ProgramManager#</b></td>
      </tr>
	 
     <tr class="line">
        <td  class="labelmedium"><cf_tl id="Scope">:</td>
        <td colspan="1" class="labelmedium">#ProgramScope#</b></td>
		<td align="right" style="padding-right:10px">
		<img src="#SESSION.root#/Images/up2.gif" alt="" border="0"
		onclick="ColdFusion.navigate('#SESSION.root#/ProgramRem/Application/Program/Header/ProgramViewHeaderContent.cfm?programcode=#url.programcode#&period=#url.period#&verbose=0','header')"
			align="absmiddle" 
			style="mouse:pointer">
		</td> 
	  </tr>  
	 
	  <tr class="line">
	  
	   <td colspan="3" class="clsNoPrint">  
	  
		  <cfif ListFind("ALL,EDIT",ProgramAccess) GT 0>		
		  
		  	 <cf_filelibraryN
			DocumentPath="#Parameter.DocumentLibrary#"
			SubDirectory="#ProgramCode#" 
			Filter="main"
			Insert="yes"
			Remove="yes"
			Highlight="no"
			Listing="yes">
			
		 <cfelse>
		 
		   	 <cf_filelibraryN
			DocumentPath="#Parameter.DocumentLibrary#"
			SubDirectory="#ProgramCode#" 
			Filter="main"
			Insert="no"
			Remove="no"
			Highlight="no"
			Listing="yes">
		 	 
		 </cfif>
	 		
	   </td>
	  
	 </tr>
	  
	  </cfoutput>	 
	   
	  </cfif>	 	  
	 	   
</table>