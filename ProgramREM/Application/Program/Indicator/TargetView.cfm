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
<cfparam name="url.ProgramCode" default="">
<cfparam name="url.Period"      default="">
<cfparam name="url.ProgramId"   default="">

<cfajaximport tags="cfdiv">
<cf_ActionListingScript>
<cf_FileLibraryScript>	 
<cf_dialogREMProgram>	 

<cf_screenTop height="100%"
     title="Indicator Target" 	 
	 html="No"  
	 layout="webapp" 
	 scroll="yes" 	
	 jquery="yes">

<cfif url.ProgramCode eq "" and url.ProgramId neq "">
			
	<cfquery name="Period" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    ProgramPeriod
		WHERE   ProgramId = '#URL.id#'
	</cfquery>
	
	<cfset url.ProgramCode = Period.ProgramCode>
	<cfset url.Period      = Period.Period>

</cfif>

<cfquery name="Check" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    ProgramCategory
	WHERE   ProgramCode = '#URL.ProgramCode#'
</cfquery>

<cfquery name="Check" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    ProgramCategory
	WHERE   ProgramCode = '#URL.ProgramCode#'
</cfquery>

<cfif Check.recordcount eq "0">

  <cflocation addtoken="No" 
        url="#SESSION.root#/programRem/Application/Program/Category/CategoryEntry.cfm?Period=#URL.Period#&ProgramCode=#URL.ProgramCode#&mid=#url.mid#">
		
</cfif>


<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
<tr><td style="padding:10px">
	<cfinclude template="../Header/ViewHeader.cfm">
</td></tr>

<tr><td style="padding:10px">

	<cfform action="TargetViewSubmit.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#" 
	    method="POST" 
		name="TargetEntry">
	
	<cfparam name="URL.Mode" default="View">
	<cfparam name="URL.ShowAll" default="No">
	
	<cfoutput>
	
		<script language="JavaScript">
		 
			function toggledetail(itm,fld)  {
		
		     se1 = document.getElementById(itm+"1")
			 se2 = document.getElementById(itm+"2")
			 
			 if (fld == true) {
			 se1.className = "regular" 
			 se2.className = "regular" 
			 } else {
			 se1.className = "hide"
			 se2.className = "hide" 
			 }
			
		     }  
		  
		    function showall(val) {	    
				ptoken.location("TargetView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Mode=Edit&showall="+val)	
			}
		
			function recordedit() {
			    ptoken.location("TargetView.cfm?ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Mode=Edit&showall=#url.showall#")
			}
			
			function ask(id) {
			if (confirm("Do you want to disable this indicator ?")) {
		        window.location = "IndicatorPurge.cfm?Id="+id+"&ProgramCode=#URL.ProgramCode#&Period=#URL.Period#&Mode=View"	
			}			
			return false			
			}	
			
			function access(targetid,box) {
			    
			    _cf_loadingtexthtml='';	
				ColdFusion.navigate('TargetViewDetailAccess.cfm?TargetId='+targetid+'&i='+box,box)
			}	
			
			function revertaccess (targetid,unit,ind,role,acc,box) {
			
			   _cf_loadingtexthtml='';	
			   ColdFusion.navigate('TargetFlyRevoke.cfm?TargetId='+targetid+'&OrgUnit='+unit+'&IndicatorCode='+ind+'&role=ProgramAuditor&UserAccount='+acc+'&i='+box,box)  			
			}
		
		</script>
	
	</cfoutput>
	
	<cfquery name="Check" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Program
		WHERE   ProgramCode = '#URL.ProgramCode#'  
	</cfquery>
	
	<!---
	
	<cfquery name="CleanInvalidIndicator" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM ProgramIndicator
		WHERE ProgramCode = '#URL.ProgramCode#'
		AND   Period      = '#URL.Period#'
		<!--- AND   RecordStatus = '9' --->
		AND IndicatorCode NOT IN (SELECT DISTINCT I.IndicatorCode
							      FROM   ProgramCategory P INNER JOIN
	                                     Ref_Indicator I ON P.ProgramCategory = I.ProgramCategory
						          WHERE  ProgramCode = '#URL.ProgramCode#'
							      AND    Period      = '#URL.Period#')
	</cfquery>
	
	--->
	
	<cfquery name="Check" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    ProgramIndicator
		WHERE   ProgramCode = '#URL.ProgramCode#'
		AND     Period = '#URL.Period#'
	</cfquery>
	
	<cfif Check.recordcount eq "0">
	   <cfset URL.Mode = "Edit">
	</cfif>
	
	<cfquery name="Indicator" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT  *
		FROM    Ref_Indicator I, Ref_ProgramCategory C
		WHERE   C.Code = I.ProgramCategory
		
		<!--- temp disabled by Dev
		AND     ProgramCategory IN (SELECT   ProgramCategory
		                            FROM     ProgramCategory
		                            WHERE    ProgramCode = '#URL.ProgramCode#') 
		--->							
									
		AND     IndicatorCode IN (SELECT     IndicatorCode
		                          FROM    	 Ref_IndicatorMission
								  WHERE      Mission = '#Program.Mission#')		
							  			
		<cfif URL.Mode eq "View" or URL.ShowAll eq "No">
	
		AND     IndicatorCode IN (SELECT     IndicatorCode 
	    	                      FROM       ProgramIndicator 
								  WHERE      ProgramCode = '#URL.ProgramCode#'
								  AND	     RecordStatus != '9')
						  
		</cfif>							
	
		ORDER BY C.Area			
					
	</cfquery>
	
	<cfquery name="Location" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM     Employee.dbo.Location 
		WHERE    LocationCode IN (SELECT LocationCode 
		                          FROM   ProgramLocation
								  WHERE  ProgramCode = '#URL.ProgramCode#') 
		ORDER BY LocationName					
	</cfquery>
	
	<cfquery name="SubPeriod" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Ref_SubPeriod
			ORDER BY DisplayOrder
	</cfquery>
	
	<cfoutput>
		<input type="hidden" name="indicator" id="indicator" value="#Indicator.recordcount#">
		<input type="hidden" name="location"  id="location"  value="#Location.recordcount#">
		<input type="hidden" name="subperiod" id="subperiod" value="#Subperiod.recordcount#">
	</cfoutput>
		
	<cf_tl id="Program Performance Indicator targets" var="1" class="message">
	<cfset msg1="#lt_text#">	
	
	<cf_tl id="Description" var="1">
	<cfset vDescription="#lt_text#">	
	
	<cf_tl id="Target" var="1">
	<cfset vTarget="#lt_text#">	
	
	<cf_tl id="Indicator has been disabled" var="1" class="message">
	<cfset msg2="#lt_text#">	
	
	<cf_tl id="Alternate target description (verbal)" var="1" class="message">
	<cfset msg3="#lt_text#">	
					
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	 
	  <tr class="linedotted">
	  	 <cfoutput>	 
		     <td class="labelmedium"><font color="gray">#msg1#</font></td>		 
		 </cfoutput>	
		 
	     <td height="27" align="right">
		 
		   <table border="0" cellspacing="0" cellpadding="0" class="formpadding">
		   <tr>	       
			   
			   <cfif ProgramAccess eq "ALL">
			   	   <td class="labelmedium">Show all Indicators:</td>
				   <td style="padding-left:4px"><input type="radio" class="radiol" onClick="showall('Yes')" name="Show" value="Yes" <cfif url.showall eq "Yes">checked</cfif>></td>
				   <td style="padding-left:4px" class="labelit">Yes</td>
				   <td style="padding-left:6px"><input type="radio" class="radiol" onClick="showall('No')" name="Show" value="No" <cfif url.showall eq "No">checked</cfif>></td>
				   <td style="padding-left:4px" class="labelit">No</td>				  
			   </cfif>
			   
			   <td style="padding-left:5px"></td>
			   <td>
				   <cfif ProgramAccess eq "ALL"> 
						<cfif URL.Mode eq "View">
						    <input type="button" style="width:100px" name="Edit" value="Edit" class="button10g" onClick="recordedit()">
						<cfelse>
						    <input type="submit" style="width:100px" name="Submit" value="Submit" class="button10g">
						</cfif>
				   </cfif>
			   </td>
		   </tr>
		  </table>
		  </td>
		  
	 </tr>
	  
	 <tr>
	 <td colspan="2" align="center">
	  
	    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				
	    <cfif Location.recordcount neq "0">
		
		   <cfloop query="Location">
		       <cfset lor = currentrow>
		       <cfset loc = location.locationCode>
			   <tr> 
				   <cfoutput><td height="20" class="labelmedium" colspan="3"><cf_tl id="Location">: <b>#LocationName#</b></td></cfoutput>
			   </TR>
			   
			   <tr><td colspan="3" height="1" class="linedotted"></td></tr> 
			   
			   <tr height="30"> 		   
			   <td class="labelit" width="10%" align="center"><cf_tl id="Code"></td>
			   <td class="labelit" width="38%"><cfoutput>#vDescription#</cfoutput></td>		 
			   <td align="right">
				   	   <table style="border:1px dotted silver" cellspacing="0" cellpadding="0">
					   <tr>			
						
			 		    <cfloop query="subperiod">
							   <td align="center" bgcolor="ffffcf">
							       <cf_space spaces="15">
							       <cfoutput><cf_tl id="#DescriptionShort#"></cfoutput>
							   </td>						
						</cfloop>					
						 
						</tr>
						</table>
			   </td>
			   <td></td>
			   </TR>
			   
			   <cfoutput>
			  	 <tr><td colspan="3" height="1" class="linedotted"></td></tr>
			   </cfoutput>		
	   
			   <cfinclude template="TargetViewDetail.cfm">
			   
		   </cfloop>
		   
		 <cfelse>	 
		 		 
				<tr height="30"> 
				   <td class="labelit" width="10%" align="center"><cf_tl id="Code"></td>
				   <td class="labelit" width="38%"><cfoutput>#vDescription#</cfoutput></td>			  
				   <td align="right">
				   	   <table style="border:1px dotted silver" cellspacing="0" cellpadding="0">
					   <tr>				
						
			 		    <cfloop query="subperiod">
							   <td align="center" bgcolor="ffffcf" class="labelit">
							       <cf_space spaces="15">
							       <cfoutput><cf_tl id="#DescriptionShort#"></cfoutput>
							   </td>						
						</cfloop>					
						 
						</tr>
						</table>
					 </td>
					 <td></td>
				</TR>
					
				<tr><td colspan="4" class="linedotted" height="1"></td></tr>
				
		        <cfset lor = 0>
		        <cfset loc = "">
			    <cfinclude template="TargetViewDetail.cfm">
				
		 </cfif>
	        
	</TABLE>
	
	</td></tr>
	
	</table>
	
	</cfform>
	
</td>
</tr>	

<cfset wflnk = "TargetViewWorkFlow.cfm">

<tr><td width="100%" align="center">

 <cfoutput>
 
 	<input type="hidden"           
		  id="workflowlink_#Program.ProgramId#" 
          value="#wflnk#"> 
 
    <cfdiv id="#program.ProgramId#"  bind="url:#wflnk#?ajaxid=#Program.ProgramId#"/>
	
 </cfoutput>	 
	
</td></tr>

</table>



