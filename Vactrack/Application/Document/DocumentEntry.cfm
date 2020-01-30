<cfparam name="URL.Caller" default="">
<cfparam name="URL.ID1" default="">

<CFIF url.id1 neq "">
  <cfinclude template="DocumentEntryPosition.cfm">
  <cfabort>
</CFIF>

<cf_dialogPosition>

<cfquery name="Mis" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT DISTINCT M.Mission, 
                  M.MissionOwner
  FROM Ref_Mission M, Ref_MissionModule R
  WHERE M.Mission    = R.Mission
  AND R.SystemModule = 'Vacancy'
  AND M.Mission IN (SELECT Mission 
                    FROM   Ref_Mandate 
					WHERE  DateExpiration > getDate())  
				
  <cfif SESSION.isAdministrator eq "No">				
  AND (
  
      M.Mission IN (SELECT DISTINCT A.Mission
					FROM     OrganizationAuthorization A INNER JOIN
					         Ref_EntityAction R ON A.ClassParameter = R.ActionCode
					WHERE   A.UserAccount = '#SESSION.acc#' 
					AND     R.EntityCode = 'VacDocument'
					AND     R.ActionType = 'Create')  
	  OR M.Mission IN (SELECT DISTINCT Mission 
	                   FROM OrganizationAuthorization
					   WHERE   UserAccount = '#SESSION.acc#' 
					   AND     Role = 'VacOfficer')
	   )
	               				
  </cfif>	
 		
</cfquery>

<cfoutput>

	<script LANGUAGE = "JavaScript">

	function search() {		
		mis = document.getElementById("mission").value
		grd = document.getElementById("postgrade").value
		url = "DocumentEntryFind.cfm?mission="+mis+"&postgrade="+grd
		ColdFusion.navigate(url,'search')		  
	}
	
		
	function selected(pos) {
	
	    ColdFusion.Window.create('mydialog', 'Recruitment Track', '',{x:100,y:100,height:600,width:640,modal:false,resizable:false,center:true})    
		ColdFusion.Window.show('mydialog') 				
		ColdFusion.navigate('#SESSION.root#/Vactrack/Application/Document/DocumentEntryPosition.cfm?ID1=' + pos + '&Caller=entry','mydialog')	
	}
		
	</script>

</cfoutput>

<cfif mis.recordcount eq "0">

	<cf_message Message="Problem, you are <b>NOT</b> authorised to register vactracks" return="back">
	<cfabort>

</cfif>

<cfif url.caller eq "Listing">
  <cfset html = "Yes">
<cfelse>
  <cfset html = "No">  
</cfif>

<cfajaximport tags="cfwindow,cfform,cfinput-datefield">

<cf_screentop html="#html#" height="100%" label="Recruitment Request" layout="innerbox" scroll="Yes" jQuery="Yes">

<table width="94%"  border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" class="formpadding">
  <tr><td height="10"></td></tr>
  <tr>
    <cfoutput>
    <td class="labelit" width="100%" height="46" align="left" valign="middle" style="height:54px;font-size:28px">
	 <cf_tl id="Initiate Recruitment Request" class="Message"></b></font>
	</td>
	</cfoutput>
  </tr> 	
     
  <tr>
    <td>
	    <table border="0" cellpadding="0" cellspacing="0">
					
		<TR>
	    		
	    <td class="labelit" width="120" height="20"><cf_tl id="Tree/Organization">:</td>
		<td>		     
			 <select name="mission" id="mission" class="regularxl" style="font-size:27px;height:39px">
			 
				 <cfoutput query="Mis">
				 <cfinvoke component="Service.Access"  
			          method="vacancytree" 
			    	  mission="#Mission#"
				      returnvariable="accessTree">
		   
		 			 <cfif AccessTree neq "NONE">
						 <option value="#Mission#" class="regularxl">#Mission#</option>
					 </cfif>		 
				 </cfoutput>
			 </select>			 
					 
	    </td>	
						
		
		
	    <TD class="labelit" style="padding-left:30px" width="140"><cf_tl id="Grade/Level">:</TD>
	    <TD width="100">		
		<cfdiv bind="url:DocumentEntryGrade.cfm?mission={mission}" id="gradebox">				
		</TD>
		
		<td align="center" style="padding-left:20px">
	  		  <cf_tl id="List" var="1">
			  <input class="button10g"
				     type="button" 
				     style="width:120px;font-size:20px;height:37px"
					 name="Submit" 
					 value="<cfoutput>#lt_text#</cfoutput>" 
					 onclick="search()">
			</td>
		
		</TR>	
			
		</TABLE>
	   </td>
	</tr>
				
	<tr>
		<td class="linedotted" style="padding-top:5px"><cfdiv id="search"></td>
	</tr>
		
</TABLE>

<cfif url.caller eq "Listing">
  <cfset html = "Yes">
<cfelse>
  <cfset html = "No">  
</cfif>

<cf_screenbottom html="#html#" layout="innerbox">

