<cf_screentop height="100%" scroll="Yes" html="no" label="Add Bucket" layout="webapp">

<!--- select only function is the class of the owner and that are enabled as roster function --->

<cf_dialogPosition>
<cf_calendarScript>

<cfquery name="Grade" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  OccGroup O, 
      FunctionTitle F
WHERE O.OccupationalGroup = F.OccupationalGroup
AND   F.FunctionNo = '#FunctionNo#' 
</cfquery>

<cfquery name="GradeDeploy1" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  FunctionTitleGrade 
WHERE FunctionNo = '#FunctionNo#' 
AND   Operational = 1
</cfquery>

<cfquery name="GradeDeploy2" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_GradeDeployment
	ORDER BY ListingOrder
</cfquery>

<cfquery name="Mis" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

  SELECT DISTINCT M.Mission, M.MissionOwner
  FROM   Ref_Mission M, Ref_MissionModule R
  WHERE  M.Mission      = R.Mission
  AND    R.SystemModule = 'Vacancy'  
  			
  <cfif SESSION.isAdministrator eq "No">	
  			
  AND (
      
	  M.Mission IN (SELECT  DISTINCT A.Mission
					FROM    OrganizationAuthorization A INNER JOIN
					        Ref_EntityAction R ON A.ClassParameter = R.ActionCode
					WHERE   A.UserAccount = '#SESSION.acc#' 
					AND     R.EntityCode  = 'VacDocument'
					AND     R.ActionType  = 'Create')  
	  OR 
	  
	  M.Mission IN (SELECT  DISTINCT Mission 
	                FROM    OrganizationAuthorization
				    WHERE   UserAccount   = '#SESSION.acc#' 
					AND     Role          = 'VacOfficer')
					
	  <cfif SESSION.isOwnerAdministrator neq "No">	 
	    OR M.MissionOwner IN (#preserveSingleQuotes(SESSION.isOwnerAdministrator)#)	  	 	 
	  </cfif>				
	  				
	 )
	               				
  </cfif>	
 		
</cfquery>

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  Ref_Mission M, Ref_MissionModule R
WHERE M.Mission = R.Mission
  AND R.SystemModule = 'Vacancy'
   <!---
  AND M.Mission IN (SELECT Mission 
                    FROM   Ref_Mandate 
					WHERE  DateExpiration > getDate())  
  --->		
</cfquery>

<cfquery name="Parameter"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ParameterOwner
	WHERE Owner = '#URL.Owner#'
</cfquery>

<cfquery name="ParameterMain"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Parameter
</cfquery>

<cfparam name="url.edition" default="">

<cfquery name="Edition"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_SubmissionEdition
	WHERE   Operational    = 1
	AND     Owner          = '#URL.Owner#'
	AND     EnableAsRoster = 1 
	AND     (ActionStatus  != '9' or SubmissionEdition = '#url.edition#')
	ORDER BY ListingOrder, ExerciseClass DESC
</cfquery>

<cfif Edition.recordcount eq "0">
	<cf_message message="Sorry, but NO active rosters have been enabled" return="close">
</cfif>

<cfquery name="Area"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_Organization
</cfquery>

<cfform action="BucketSubmit.cfm?occ=#Grade.OccupationalGroup#" method="POST" name="dialog" taget="result">

<!--- Entry form --->

<table width="96%" height="95%" border="0" cellspacing="0" bgcolor="ffffff" align="center">

<tr><td height="5"></td></tr>
<tr class="hide"><td><iframe name="result" id="result"></iframe></td></tr>

<tr class="line">
   <td width="125" style="height:30" class="labellarge"><cf_tl id="Create Bucket">:</TD>		
</tr>
	
<tr><td valign="top" style="padding-left:15px">

	<table width="100%" border="0" class="formpadding formspacing" cellspacing="0" cellpadding="0" align="center">
				
	 <tr><td width="125" height="22" class="labelmedium"><cf_tl id="Owner">:</TD>
		<TD class="labelmedium" width="70%">
		 <cfoutput>#URL.Owner#</cfoutput>
	   	</TD>
	</tr>
	
	 <tr><td width="125" height="22" class="labelmedium"><cf_tl id="Occupational group">:</TD>
		<TD class="labelmedium">
		 <cfoutput>#Grade.DescriptionFull#</cfoutput>
	   	</TD>
	</tr>
	
	<tr><td height="22" class="labelmedium"><cf_tl id="Functional Title">:</TD>
		<TD class="labelmedium" >
		 <cfoutput><b>#Grade.FunctionDescription#
		 <input type="hidden" name="functionno" id="functionno" value="#Grade.FunctionNo#">
		 </cfoutput>
	   	</TD>
	</tr>
	
	<tr><td height="22" class="labelmedium"><cf_tl id="Bucket Title">:</TD>
		<TD class="labelmedium" >
		 <cfoutput>
		 <input type="text" style="width:90%" class="regularxl" name="functiondescription" id="functiondescription" value="#Grade.FunctionDescription#" size="80" maxlength="120">
		 </cfoutput>
	   	</TD>
	</tr>
	
	<tr>
	   <td class="labelmedium"><cf_tl id="Grade">:</td>
   		<td>
		
		<table><tr><td>
		<cfif GradeDeploy1.recordcount eq "0">
		
			 <select name="postgrade" id="postgrade" class="regularxl">
		   <cfoutput query="gradedeploy2">
	    	 <option value="#GradeDeployment#">#GradeDeployment#</option>
		   </cfoutput>
		   </select>
		
		<cfelse>
		
		   <select name="postgrade" id="postgrade" class="regularxl">
		   <cfoutput query="gradedeploy1">
	    	 <option value="#GradeDeployment#">#GradeDeployment#</option>
		   </cfoutput>
		   </select>
		</cfif>   
		
		</td>
		
		<TD class="labelmedium">
			<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/finger.gif" align="absmiddle" onclick="javascript:gjp()" alt="" border="0">
			<a href="javascript:gjp()"><font color="0080C0"><cf_tl id="View job profile"></font></a>
		</td>
		
		</tr></table>
	   </td>
	</tr>
	
				
	<tr>	
    <td class="labelmedium" width="80"><cf_tl id="Area">:</td>
    <TD>  
    	<select name="OrganizationCode" required="Yes" class="regularxl enterastab">
		<option value="<cfoutput>#ParameterMain.DefaultOrganization#</cfoutput>" selected>N/A</option>
		<cfoutput query="Area">
		<option value="#OrganizationCode#">#OrganizationDescription#</option>
		</cfoutput>
		</select>
	      	 
	</TD>
	
	</TR>
		
    <TD class="labelmedium"><cf_tl id="Edition">:</TD>
    <TD>  
	    <cfset st = 0>
		
		<cfif url.edition neq "" and url.edition neq "undefined">
		
		    <cfset default = url.edition>
		  
		<cfelse>
		
			<cfset default =  Parameter.DefaultRoster>
			
		</cfif>	 
		
    	<select name="SubmissionEdition" required="Yes" class="regularxl enterastab">
		<cfoutput query="Edition">
		
		  <cfset st = 1>
		
		 <cfif Posttype neq "">
		
			 <cfinvoke component="Service.Access"  
		          method="vacancytree" 
		    	  posttype="#PostType#"
			      returnvariable="accessTree">
				  
			 <cfif AccessTree neq "NONE">	  
			 
					<cfif default eq SubmissionEdition>
						<option value="#SubmissionEdition#" selected>#EditionDescription#</option>
					<cfelse>
						<option value="#SubmissionEdition#" >#EditionDescription#</option>
					</cfif>
					
			 </cfif>		
			
		<cfelse>
		
			<cfif default eq SubmissionEdition>
				<option value="#SubmissionEdition#" selected>#EditionDescription#</option>
			<cfelse>
				<option value="#SubmissionEdition#" >#EditionDescription#</option>
			</cfif>
		
		</cfif>	
		
		</cfoutput>
		</select>
	      	 
	</TD>
	</tr>
		
	<TD class="labelmedium"><cf_tl id="Mission">:</TD>
	<td>		     
			
    	<cfinvoke component="Service.Access"  
		      method="roster" 
		      role="'AdminRoster'" 
			  returnvariable="Access"
			  Parameter="#URL.Owner#">
			  	
		 <select name="mission" id="mission" class="regularxl enterastab">
		 
		     <cfif Mis.recordcount eq Mission.Recordcount or (Access eq "ALL" or Access eq "EDIT")>
		         <option value=""><cf_tl id="Undefined"></option>
			 </cfif>
			 
			 <cfoutput query="Mis">
			 <cfinvoke component="Service.Access"  
		          method="vacancytree" 
		    	  mission="#Mission#"				  
			      returnvariable="accessTree">
	   
	 			 <cfif AccessTree neq "NONE" or Access eq "ALL" or Access eq "EDIT">
					 <option value="#Mission#" 
			         style="border-style: solid;">#Mission#</option>
				 </cfif>		 
			 </cfoutput>
		 </select>			 
				 
    </td>
	</tr>
	
	<tr> 
    <TD class="labelmedium"><cf_tl id="Location">:</TD>
    <TD>  	
		<cfdiv bind="url:getLocation.cfm?mission={mission}"/>	
	</TD>
	</TR>

	<tr> 
    <TD class="labelmedium"><cf_tl id="Job Opening">:</TD>
    <TD>  
	<cfinput type="Text"
       name="referenceno"
       message="Please enter a valid Job Opening No"      
       size="20"
	   validate="integer"
       maxlength="20"
	   onchange="ColdFusion.navigate('VACheck.cfm?referenceno='+this.value,'va')"
       class="regularxl enterastab">
	</TD>
	</TR>
	
	<cfoutput>
	
		<script language="JavaScript">
		
		//	function createva(ref) {
		//	   ret = window.showModalDialog("#SESSION.root#/Vactrack/Application/Announcement/DocumentEntry.cfm?referenceno="+ref+"&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:yes; dialogHeight:800px; dialogWidth:900px; help:no; scroll:yes; center:yes; resizable:no");
		//      if (ret) {	
		//		ColdFusion.navigate('VACheck.cfm?referenceno='+ref,'va')
		//	   }
			
		//	}
			
		</script>
		
	</cfoutput>
	
	<tr>
	    <td></td>
		<td id="va"></td>
	</tr>

    <TD class="labelmedium" height="22"><cf_tl id="Position specific">:</TD>
    <TD class="labelmedium">No
	</TD>
	</TR>
		
    <TD height="22" class="labelmedium"><cf_tl id="JO Effective">:</TD>
    <TD>  
	  <cf_intelliCalendarDate9
		FieldName="DateEffective" 
		Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
		AllowBlank="True"
		class="regularxl enterastab">	
	</TD>
	</TR>	
		
    <TD height="22" class="labelmedium"><cf_tl id="JO Expiration">:</TD>
    <TD>  
	  <cf_intelliCalendarDate9
		FieldName="DateExpiration" 
		Default="#Dateformat(now()+60, CLIENT.DateFormatShow)#"
		AllowBlank="True"
		class="regularxl">	
	</TD>
	</TR>
		
    <TD height="25" class="labelmedium"><cf_tl id="Officer">:</TD>
    <TD class="labelmedium">  
	<cfoutput>#SESSION.first# #SESSION.last#</cfoutput>
	</TD>
	</TR>
			
	<tr><td colspan="2" align="center" style="height:40px" class="line">			
	
	<cfif st eq "0">
		<!--- no access --->
	<cfelse>
		<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="parent.window.close()">
		<input class="button10g" type="submit" name="Insert" value="Save">		
	</cfif>
	
	</td>	
	
	</tr>
	
</TABLE>

</CFFORM>

<cf_screenbottom html="No">