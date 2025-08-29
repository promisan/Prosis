<!--
    Copyright © 2025 Promisan B.V.

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
<cfoutput>	

	<script language="JavaScript">	
		
		function more(bx,act,id) {
		 
			icM  = document.getElementById(bx+"Min")
		    icE  = document.getElementById(bx+"Exp")
			se   = document.getElementById(bx);
			frm  = document.getElementById("i"+bx);
				 		 
			if (act=="show") {
			   	 icM.className = "regular";
			     icE.className = "hide";
				 se.className  = "regular";
				 ColdFusion.navigate('#SESSION.root#/ProgramREM/Reporting/Progress/Project/ProgressDrill.cfm?programcode=' + id + '&period=#URL.Period#','i'+bx)
										
			 } else {
			   	 icM.className = "hide";
			     icE.className = "regular";
		    	 se.className  = "hide"
			 }
				 		
		  }		
		  
		 function search(pg,prg,per) {
		     ptoken.navigate('#SESSION.root#/programREM/reporting/progress/project/ProgressDrillDetail.cfm?ProgramCode='+prg+'&Period='+per+'&Text='+pg,prg+'_result')
		 } 
		  		  
	</script>			
  
</cfoutput>	
	
	<cf_tl id="Over 60 days" var="1">
	<cfset t60 = "#Lt_text#">
	
	<cf_tl id="Over 30 days" var="1">
	<cfset t30 = "#Lt_text#">

	<cf_tl id="Less than 30 days" var="1">
	<cfset tlt30 = "#Lt_text#">
	
	<cf_tl id="On schedule" var="1">
	<cfset tos = "#Lt_text#">

	<cf_tl id="Ahead of schedule" var="1">
	<cfset tahead = "#Lt_text#">
	
	<cf_tl id="Completed" var="1">
	<cfset tcompleted = "#Lt_text#">
	
	<cf_tl id="Not started" var="1">
	<cfset tnstarted = "#Lt_text#">
	
	<!--- check reference table --->
		
	<cf_insertStatus  
	 ProgramClass="Project"  Status="S0"  Description="#t60#"    ListingOrder="1"   Color="red"   Expand="0">
	<cf_insertStatus  
	 ProgramClass="Project"  Status="S1"  Description="#t30#"    ListingOrder="2"   Color="yellow"   Expand="0">
	<cf_insertStatus  
	 ProgramClass="Project"  Status="S2"  Description="#tlt30#"  ListingOrder="3"   Color="silver"   Expand="0">
	<cf_insertStatus  
	 ProgramClass="Project"  Status="S3"  Description="#tos#"    ListingOrder="4"   Color="gray"   Expand="0">	 
	<cf_insertStatus  
	 ProgramClass="Project"  Status="S4"  Description="#tahead#" ListingOrder="5"   Color="blue"     Expand="0">	 
	<cf_insertStatus  
	 ProgramClass="Project"  Status="S8"  Description="#tcompleted#"  ListingOrder="6"   Color="green"   Expand="0">
	<cf_insertStatus  
	 ProgramClass="Project"  Status="S9"  Description="#tnstarted#"   ListingOrder="7"   Color="white"   Expand="0">
	<!--- userQuery.dbo.tmp#SESSION.acc#Program#FileNo# Has valid project for the selected period and unit --->
	
    <cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#ActivityPending1#FileNo#">
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#ActivityPending2#FileNo#">
		
	<!--- reset the programCode to the ParentCode in Pending --->	
	
	<cfquery name="Reset" 
	 datasource="AppsQuery" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 UPDATE  #SESSION.acc#ActivityPending#FileNo#	
		 SET     ProgramCode = ParentCode
		 WHERE   ParentCode IN (SELECT ProgramCode 
		                        FROM   userQuery.dbo.tmp#SESSION.acc#Program#FileNo#
								WHERE  ProgramClass = 'Project')
    </cfquery>
								
	<!--- define the first ending incomplete activity --->
	<cfquery name="IncompleteActivityEndFirst" 
	 datasource="AppsQuery" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT   ProgramCode, 
		          Status, 
		          MIN(ActivityDate) AS ActivityDateEnd 
		 INTO     userQuery.dbo.#SESSION.acc#ActivityPending1#FileNo#	
	     FROM     userQuery.dbo.#SESSION.acc#ActivityPending#FileNo#	P
		 WHERE    P.ProgramCode IN (SELECT ProgramCode 
		                          FROM  userQuery.dbo.tmp#SESSION.acc#Program#FileNo#
								  WHERE  ProgramCode = P.ProgramCode)
	     GROUP BY ProgramCode, Status
	</cfquery>
	
	<!--- define the start date of the first ending incomplete activity --->
	
	<cfquery name="IncompleteActivityEndFirstStart" 
	 datasource="AppsQuery" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 
	 SELECT     AE.ProgramCode, 
	            AE.Status, 				
	            AE.ActivityDateEnd,
				MIN(A.ActivityDateStart) AS ActivityDateStart, 
				MAX(PG.Created) as LastSubmitted
				
	 INTO       dbo.#SESSION.acc#ActivityPending2#FileNo# 
	 
	 FROM       #SESSION.acc#ActivityPending1#FileNo# AE INNER JOIN
                #SESSION.acc#ActivityPending#FileNo# A ON AE.ActivityDateEnd = A.ActivityDate AND AE.ProgramCode = A.ProgramCode LEFT OUTER JOIN
                Program.dbo.ProgramActivityProgress PG ON AE.ProgramCode = PG.ProgramCode
		
	 GROUP BY AE.ProgramCode, AE.Status, AE.ActivityDateEnd 
	 	 
	</cfquery>
		
	
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#ActivityPending0#FileNo#"> 
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#ActivityPending1#FileNo#"> 
		
	<!--- loop through the table to determine how delayed the projects are --->
			
	<cfquery name="Define" 
	 datasource="AppsQuery" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT     *
	 FROM       #SESSION.acc#ActivityPending2#fileNo#
	</cfquery>
	
	<cfloop query="Define">
	
		<cfif ActivityDateEnd lt now()>
		 
		    <cfset diff = (now() - ActivityDateEnd)>
			<cfif diff lte 30>
			    <cfset st = "S2">
			<cfelseif diff lte 60>	
			    <cfset st = "S1">	
			<cfelse>
			    <cfset st = "S0">	
			</cfif>
				
		<cfelse>
		
			<cfif ActivityDateStart lte now()>
			    <cfset st = "S3">   <!--- in line --->
			<cfelse>
			    <cfset st = "S4">	<!--- ahead --->
			</cfif>
			
			<cfif st eq "S4"> 
			
				<cfquery name="Check" 
				 datasource="AppsProgram" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 SELECT   MIN(ActivityDateStart) as Start
					 FROM     ProgramActivity
					 WHERE    ProgramCode = '#ProgramCode#' 
					 AND      RecordStatus != '9'
				</cfquery>
				
				<cfif Check.Start gte now()>
						<cfset st = "S9">
				</cfif>
					
			</cfif>
				
		</cfif>
		
		<cfquery name="Update" 
		 datasource="AppsQuery" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		     UPDATE #SESSION.acc#ActivityPending2#fileNo# 
		     SET    Status = '#ST#'
		     WHERE  ProgramCode = '#ProgramCode#'
		</cfquery>
		
	</cfloop>
	
	<!--- now add the projects that are COMPLETED --->
	
		<!--- ---------------------------- ---> 
	   <!--- Pending : limit the contents --->
	   <!--- ---------------------------- --->
	     
	   <cfquery name="RolledUp"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT    P.ProgramCode AS ProjectCode, PA.*
		
		INTO 	  userQuery.dbo.#SESSION.acc#Activity#FileNo#
		
		FROM      ProgramActivity PA, Program P
		WHERE     P.ProgramCode  = PA.ProgramCode 		
		AND       P.ProgramClass  = 'Project'	
		AND       PA.ActivityPeriod   = '#url.period#'  <!--- to show only activities under this period, might not be correct --->
		AND       PA.RecordStatus    != '9'	
		AND       PA.ProgramCode IN (SELECT ProgramCode 
		                             FROM   #per#
								     WHERE  ProgramCode = PA.ProgramCode 
								     AND    RecordStatus != '9') 		
		
		<!--- onclude also the parent action --->
			 
		UNION ALL
		
		SELECT    Pe.PeriodParentCode AS ProjectCode, PA.*
		FROM      ProgramActivity PA, 	 
		          Program P,
				  ProgramPeriod Pe
		WHERE     P.ProgramCode  = PA.ProgramCode 		
		AND       P.ProgramCode  = Pe.ProgramCode
		AND       Pe.Period      = '#url.period#' <!--- added to detect the correct hierarchy --->
		AND       PA.ActivityPeriod   = '#url.period#'  <!--- to show only activities under this period, might not be correct --->
		AND       P.ProgramClass = 'Project'		
		AND       PA.RecordStatus != '9' 	
		AND       P.ProgramCode IN (SELECT ProgramCode 
		                            FROM   #per# 
									WHERE  ProgramCode = P.ProgramCode 
									AND    RecordStatus != '9')
		
		<!--- parent project of a sub-project to show consolidated progress --->
		
		AND       EXISTS (SELECT    'X'
		                  FROM    Program
	    	              WHERE   ProgramCode = Pe.PeriodParentCode
						  AND     ProgramClass = 'Project')
		ORDER BY ProjectCode
	   </cfquery>
	
	
	
	<cfquery name="CompletedProject" 
	 datasource="AppsQuery" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	
		 INSERT INTO dbo.#SESSION.acc#ActivityPending2#fileNo# (ProgramCode, Status)
		 SELECT  DISTINCT ProjectCode, 'S8'
		 FROM    #SESSION.acc#Activity#FileNo# P
		 WHERE   ProjectCode NOT IN (SELECT ProgramCode 
		                             FROM   #SESSION.acc#ActivityPending2#fileNo#
								     WHERE  ProgramCode = P.ProjectCode)		
		 <!--- Make sure the projects belong to the set 
		                   that indeed needs to be shown --->						   
		 AND   ProjectCode IN  (SELECT ProgramCode 
		                        FROM   userQuery.dbo.tmp#SESSION.acc#Program#FileNo#
							    WHERE  ProgramCode = P.ProjectCode)						   
			
	</cfquery>
	
	<!--- r1/6/2006 : remove the subprojects from this listing --->

	<cfquery name="DeleteSubProject" 
	 datasource="AppsQuery" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 DELETE FROM #SESSION.acc#ActivityPending2#fileNo#
		 WHERE ProgramCode IN (SELECT  DISTINCT ProgramCode
							   FROM    #SESSION.acc#Activity#FileNo#
							   WHERE   ProgramCode <> ProjectCode)
	</cfquery>

	<!--- prepare the chart --->
			
	<cfquery name="Chart" 
	 datasource="AppsQuery" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT     DISTINCT S.Status, S.Description, S.ListingOrder, S.Color, count(P.ProgramCode) as Total 
		 FROM       #SESSION.acc#ActivityPending2#fileNo# P RIGHT OUTER JOIN Program.dbo.stStatus S ON S.Status = P.Status
		 WHERE      S.ProgramClass = 'Project'	      
		 GROUP BY   S.ListingOrder, S.Status, S.Description, S.Color
		 ORDER BY   S.ListingOrder, S.Status, S.Description
	</cfquery>

	<!---
	<cfset cl = "">
	
	<cfloop query="Chart">
	   <cfif cl neq "">
		<cfset cl = "#cl#,#Chart.color#">
	   <cfelse>
	    <cfset cl = "#Chart.color#">
	   </cfif>	
	</cfloop>	
	--->
		
	<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
	 
	  <tr>
	    <td style="padding-top:6px;font-size:24px;height:36px;padding-left:6px" class="labellarge">
						
			<cfoutput>
			<cfif Len(Org.OrgUnitName) gt 40>
		     &nbsp;#Left(Org.OrgUnitName, 40)#...
		    <cfelse>
		     &nbsp;#Org.OrgUnitName#
		    </cfif>
			</cfoutput>
		
		</td>
		
		<td colspan="2" align="right" class="labellarge">
		
		<cfoutput>
		  <cf_tl id="Status">: #dateFormat(now(), CLIENT.DateFormatShow)#
		</cfoutput>
			
		</td>
		
		<!---	
		<td align="right"  class="labelmedium">			
		<cfoutput query="DisplayPeriod">
			#Description#&nbsp;
		</cfoutput>					
	    </TD>
		--->
		
	  </tr>
		  
	  <tr><td height="23" colspan="3" style="padding-top:6px;padding-left:10px">

		<!--- 5.	Present status in graph --->
				
		<cfchart
	           format="png"
	           chartheight="190"
	           chartwidth="#client.width-450#"
	           showxgridlines="yes"
	           seriesplacement="default"
	           font="Calibri"
	           fontsize="12"
	           labelformat="number"
	           xaxistitle="Status"
	           yaxistitle="Projects"
	           show3d="no"
	           xoffset="0.05"
	           yoffset="0.05"
	           tipstyle="mouseOver"
	           tipbgcolor="E9E9D1"
	           pieslicestyle="solid"
	           url="javascript:maximize('$ITEMLABEL$','Exp')"
	           backgroundcolor="ffffff">
					   
		   <cfchartseries
		        type="bar"
		        query="Chart"
		        itemcolumn="Description"
		        valuecolumn="Total"
		        serieslabel="Target"				
		        colorlist="red,yellow,silver,gray,blue,green,white"
				datalabelstyle="Value"
		        paintstyle="light"
		        markerstyle="circle"/> 
					 
		 </cfchart>	
	
	   </td></tr>
	
	<!--- 6.    List by status (Expand) and drill down --->
	
   	 <cfquery name="Detail"
		datasource="AppsProgram"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
			SELECT     stStatus.*, 
			           P.ProgramCode AS ProgramCode, 
					   P.LastSubmitted,
					   Pe.PeriodParentCode as ParentCode,
			           PO.ProgramName        AS ProgramName, 
			           Pe.PeriodDescription  AS ProgramDescription, 
					   Pe.Reference,
	                   PO.ProgramClass       AS ProgramClass, 
					   P.ActivityDateStart   AS DateStart, 
					   P.ActivityDateEnd     AS DateEnd
	   		FROM       stStatus,
	                   userQuery.dbo.#SESSION.acc#ActivityPending2#fileNo# P, 
	                   Program PO,
					   ProgramPeriod Pe
			WHERE      stStatus.Status      = P.Status
			AND        P.ProgramCode        = PO.ProgramCode
			AND        P.ProgramCode        = Pe.ProgramCode
			AND        Pe.Period = '#url.period#'
			AND        stStatus.ProgramClass = 'Project'			  
			ORDER BY   stStatus.ListingOrder, ProgramName			  
	  </cfquery>
	 			    
	  <cfoutput query="detail" group="ListingOrder">
	  
	    <tr><td colspan="3" style="border:1px solid gray">
		
		 <cfif Expand eq "0">
		   <cfset sh = "Hide">
		 <cfelse>
		   <cfset sh = "Show">  
		 </cfif>
		 
		 <cfquery name="Total" 
	      datasource="AppsQuery" 
     	  username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT     count(P.ProgramCode) as Total 
	      FROM       #SESSION.acc#ActivityPending2#fileNo# P
     	  WHERE      P.Status = '#Status#'
		</cfquery>
				 
	     <cf_tableToggle id="#Description#" 
			   	header="#Description# [#Total.Total#]" 
				size="100%"
				mode="#sh#"
				line="0"
				border="0"
				icon="#sh#"
				scroll="40"
				color="#Color#">
			
		</td></tr>		
						
		<tr><td colspan="3" align="center" class="#sh#" id="#Description#">
							
			<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding navigation_table">
			
			   <tr><td height="4"></td></tr>
				 
			   <cfoutput>		   
			   
			   <tr class="labelmedium line navigation_row">
			   
			     <td width="3%" height="23" align="center">#CurrentRow#</td>  
			   
			     <td width="3%" align="center">
				 				 			  
					<img src="#SESSION.root#/Images/arrowright.gif" alt="Drill down" 
						id="#CurrentRow#Exp" border="0" class="show" 
						align="absmiddle" style="cursor: pointer;" 
						onClick="more('#CurrentRow#','show','#ProgramCode#')">
					
					<img src="#SESSION.root#/Images/arrowdown.gif" 
						id="#CurrentRow#Min" alt="" border="0" 
						align="absmiddle" class="hide" style="cursor: pointer;" 
						onClick="more('#CurrentRow#','hide','#ProgramCode#')">
	
				  </td>
				 				 				  
				  <td width="1%" align="center"></td>
			      <td width="10%"><cfif Reference neq "">#Reference#<cfelse>#ProgramCode#</cfif></td>
				  <td width="45%"><a href="javascript:AuditProject('#ProgramCode#','#DisplayPeriod.Period#')">#ProgramName#</a></td>
				  <td width="10%">#dateformat(LastSubmitted, CLIENT.DateFormatShow)#</td>
				  <td width="25%">
				  
					  <cfquery name="Parent" 
						 datasource="AppsProgram" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT     *
						 FROM       Program
						 WHERE      ProgramCode = '#ParentCode#'
						 AND        ProgramScope = 'Unit'
					  </cfquery>
					  
					  <cfif Parent.Recordcount eq "1">
				  			<cf_tl id="under">:  #Parent.ProgramName#
					  </cfif>
				  			  
				  </td>
				
			   </tr>
			   			   
			    <tr id="#CurrentRow#" class="hide">
				<td width="100%" height="100%" colspan="7" align="right" valign="middle" style="padding-left:20px">
					<cfdiv id="i#CurrentRow#">					
				</td></tr>
								
			    </cfoutput>
				
				 <tr><td height="4"></td></tr>
				 
			</table>
		
		</td></tr>			
	   			
	 </cfoutput>
		 
	 </table>	

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#ActivityPending2#FileNo#"> 
