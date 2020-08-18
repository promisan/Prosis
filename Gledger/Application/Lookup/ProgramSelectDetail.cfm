
<!--- provision to select only mission --->

    <cfquery name="Parameter" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_ParameterMission
		WHERE Mission = '#URL.Mission#'
	</cfquery>
	
	<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   DISTINCT P.ProgramCode, 
		         P.ProgramName, 
				 P.ProgramClass, 
				 Pe.PeriodHierarchy as ProgramHierarchy, 				
				 Pe.Reference,
				 Pe.Period,
				 Pe.ReferenceBudget1,
				 Pe.ReferenceBudget2,
				 Pe.ReferenceBudget3,
				 Pe.ReferenceBudget4,
				 Pe.ReferenceBudget5,
				 Pe.ReferenceBudget6,
				 O.OrgUnitCode,
				 O.OrgUnitName,
				 (SELECT OrgUnitNameShort
				  FROM Organization.dbo.Organization 
				  WHERE OrgUnitCode = O.HierarchyRootUnit AND Mission = O.Mission and MandateNo = O.MandateNo) as Parent,
				 O.HierarchyCode
		FROM     Program P INNER JOIN
	             ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN Organization.dbo.Organization O ON Pe.OrgUnit = O.OrgUnit
		WHERE    P.Mission = '#URL.Mission#'
		<cfif url.period neq "">
		 AND (Pe.Period IN
	                          (SELECT    Period
	                            FROM     Organization.dbo.Ref_MissionPeriod
	                            WHERE    Mission = '#URL.Mission#' AND (AccountPeriod = '#URL.Period#' or MandateNo = '#URL.Period#'))
								OR Period = '#URL.Period#'
								)
		</cfif>						
	    <cfif url.idParent neq "">
		AND ProgramClass = '#URL.IDParent#'
		</cfif>		
		<!--- Removed by Armin October 9th 2012
		 AND ProgramScope = 'Unit' the lookup should allow for including also "global programs"
		---->
		AND Pe.RecordStatus != '9'
		
		<cfif url.idParent neq "Program">		
		AND P.ProgramScope = 'Unit'		
		</cfif>
		
		<cfif url.crit neq "">
		AND (P.ProgramName LIKE '%#URL.Crit#%' OR Pe.Reference LIKE '%#URL.crit#%' OR P.ProgramCode LIKE '%#URL.crit#%'  OR O.OrgUnitName LIKE '%#URL.crit#%')
		</cfif>					
		ORDER BY O.HierarchyCode, Pe.PeriodHierarchy   
	
	</cfquery>
	
<cfif Program.recordcount lte "350">
	<cfset nav = "1">	
<cfelse>
    <cfset nav = "0">
</cfif>
	  
<table width="97%" border="0" style="padding-top:1px;padding-bottom:1px" cellspacing="0" cellpadding="0" align="center" class="<cfif nav eq '1'>navigation_table</cfif>">
	
	 <!---
	 <TR class="labelmedium">        	   
	   <td width="40" height="19"></td>
       <TD width="20%" class="labelit"><cf_tl id="Code"></TD>	   
       <TD width="60%" class="labelit"><cf_tl id="Name"></TD>	  
	   <td></td>
	 </TR>
	 
	 --->	
	 			   	 
	 <cfset prior = "">
	 		 	  	 		 
	 <cfoutput query="Program" group="HierarchyCode">	 	 
	 
	 <cfoutput group="ProgramHierarchy">
	 
	 	 <cfif orgunitname neq prior>
		
		 	 <tr class="line"><td height="1" class="labellarge" colspan="6" style="height:34px;padding-left:3px">
			 			  			  
			    <cfif orgunitname neq prior>
				
				 <cfif parent neq orgunitName>
					#parent#/#orgunitName#	 
				 <cfelse>
					 #orgunitname#
				 </cfif>
				 
				</cfif>				
			  			 
			 </td></tr>		
					 
		 </cfif>
	 	 		 
		 <cfif ProgramClass eq "Program">
		 	<cfset cl = "e4e4e4">
		 <cfelse>
		 	<cfset cl = "transparent">	
		 </cfif>
		 
		 <TR class="<cfif nav eq '1'>navigation_row</cfif> line labelmedium" bgcolor="#cl#" style="height:22px">		 
				 
			 <td height="18" align="center" style="padding-top:2px;padding-left:10px" class="<cfif nav eq '1'>navigation_action</cfif>" onclick="setvalue('#ProgramCode#')">		  
				 <cf_img icon="select">		 				      		 
			 </TD>			 	 
			 <TD style="min-width:100px" onclick="setvalue('#ProgramCode#')">		
			 	 
			 <cfif ReferenceBudget1 eq "" and Reference neq "">		 
			 	#Reference#
			 <cfelseif ReferenceBudget1 eq "" and Reference eq "">
			    #ProgramCode#
			 <cfelse>
			 	#ReferenceBudget1#-#ReferenceBudget2#-#ReferenceBudget3#<cfif ReferenceBudget4 neq "">-#ReferenceBudget4#<cfif ReferenceBudget5 neq "">-#ReferenceBudget5#</cfif>-#ReferenceBudget6#</cfif>
			 </cfif>			 
			 
			 </TD>			
		  	 <td style="width;100%">#ProgramName#</TD>						 
			 <td align="right" style="padding-right:6px">		 
			     <cf_img icon="edit" onClick="ViewProgram('#ProgramCode#','#Period#','#ProgramClass#')">			
			 </td>	
		 
		 </tr>	
		 							 
		 <cfset prior = orgunitname>
		 
	 </cfoutput>
	 
 </cfoutput>
	 	
</table>
	 		
<cfset AjaxOnLoad("doHighlight")>	