
<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfparam name="URL.Caller" default="">

<cfquery name="Position" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM Position
    WHERE PositionNo = '#PositionChild.PositionNo#'
</cfquery>
	
<cfquery name="Parameter" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM Parameter
</cfquery>		

<cfquery name="Admin" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT O.*, O2.OrgUnitNameShort as ParentNameShort
    FROM   Organization.dbo.Organization O, Organization.dbo.Organization O2
    WHERE  O.OrgUnit        = '#Position.OrgUnitAdministrative#'
    AND    Left(O.HierarchyCode,2) = O2.HierarchyCode
    AND    O.MandateNo             = O2.MandateNo
    AND    O.Mission               = O2.Mission   
</cfquery> 
	
<cfquery name="Functional" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
    FROM    Organization
    WHERE   OrgUnit = '#Position.OrgUnitFunctional#'
</cfquery>	
	
<cfquery name="Assignment" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   O.OrgUnitCode, OrgUnitName, A.*, P.*, R.Description
    FROM     PersonAssignment A INNER JOIN
	         Person P ON A.PersonNo = P.PersonNo INNER JOIN
			 Organization.dbo.Organization O ON O.OrgUnit = A.OrgUnit INNER JOIN
			 Ref_AssignmentClass R ON A.AssignmentClass = R.AssignmentClass
    WHERE    PositionNo = '#PositionChild.PositionNo#' 	
	AND      A.AssignmentStatus IN ('0','1') 	
	ORDER BY DateExpiration DESC, DateEffective DESC
</cfquery>	

<table border="0">
   
  <tr>
    <td colspan="2">
	
    <table>
		
	 <cfoutput> 
		 
	 <cfif PositionParent.FunctionNo neq Position.FunctionNo>
	     <cfset fun = "1">
	 <cfelse>	
     	 <cfset fun = "0"> 
	 </cfif> 
	    
      <tr class="labelmedium" style="height:20px">
        <td height="20" width="200"><cf_tl id="Functional Title">:</td>
		<cfif fun eq "1">
        <td colspan="2" class="notify">#Position.PostClass# / #Position.PostGrade# / #Position.FunctionDescription# <cfif Position.SourcePostNumber neq "">#Position.SourcePostNumber#</cfif></td>
		<cfelse>
		<td colspan="2">#Position.PostClass# / #Position.PostGrade# / #Position.FunctionDescription# <cfif Position.SourcePostNumber neq "">#Position.SourcePostNumber#</cfif></td>
		</cfif>
		<td colspan="1" rowspan="4" valign="bottom" align="right">
		
		</td>
				
      </tr>
	 	  
	  </cfoutput>
	  
	  <cfquery name="Location" 
          datasource="AppsEmployee" 
          username="#SESSION.login#" 
          password="#SESSION.dbpw#">
	          SELECT  * 
	          FROM    Location
	          WHERE   LocationCode = '#Position.LocationCode#'
	   </cfquery>
	  
	  <tr style="height:20px" class="labelmedium">
        <td height="16"><cf_tl id="Used by">:</td>
				
	    <cfquery name="Level00" 
	          datasource="AppsEmployee" 
	          username="#SESSION.login#" 
	          password="#SESSION.dbpw#">
	          SELECT O.*, O2.OrgUnitNameShort as ParentNameShort
	          FROM   Organization.dbo.Organization O, Organization.dbo.Organization O2
	          WHERE  O.OrgUnit = '#Position.OrgUnitOperational#'
	          AND    LEFT(O.HierarchyCode,2)=O2.HierarchyCode
	          AND    O.MandateNo  = O2.MandateNo
	          AND    O.Mission    = O2.Mission 
	   </cfquery>
		
	   <cfif PositionParent.OrgUnitOperational neq Position.OrgUnitOperational>
		     <cfset org = "1">
	   <cfelse>	
     		 <cfset org = "0"> 
	   </cfif>
		
	   <cfoutput query="Level00">
	       
		  <cfif org eq "1">
		      <td>
			    <table>
				<tr class="labelmedium" style="height:20px">
				<td class="notify">#Mission#: #ParentNameShort# / #OrgUnitName# (#OrgUnitCode#) / <font color="808000">#Location.LocationName#</font></td>									
				</tr>
				</table>				
				</td>
		  <cfelse>
		      <td>#Mission#:  #ParentNameShort# / #OrgUnitName# (#OrgUnitCode#) / <font color="808000">#Location.LocationName#</font></td>
		  </cfif>
		  
     </TR>	   
	  
	 <cfif Admin.OrgUnitName neq "">
		  
		  <tr style="height:20px" class="labelmedium">
	        <td height="16"><cf_tl id="Administrative Unit">:</td>
	        <td colspan="2"><cfif Admin.OrgUnitName eq "">N/A<cfelse>#Admin.ParentNameShort# / #Admin.OrgUnitName#</cfif></td>
	      </tr>
	  
	 </cfif>
		  	  
	 <tr style="height:20px" class="labelmedium">
        <td></td>
        <td colspan="2">
		<table>
			<tr style="height:20px" class="labelmedium">
			<td><font color="808080">#Position.OfficerFirstName# #Position.OfficerLastName# (#dateformat(Position.created,CLIENT.DateFormatShow)#)</font></td>
			<cfif session.acc eq position.OfficerUserid or getAdministrator("*") eq "1">
				<cfif org eq "1" or fun eq "1">
					<td style="padding-left:6px">:<cf_tl id="Loan">:</td>
					<td style="padding-left:4px">			  
						  <input type="checkbox" 
						  onclick="ptoken.navigate('setPosition.cfm?positionno=#position.positionno#&field=disableloan&value='+this.checked,'loan#position.positionno#')" 
						  value="0" <cfif Position.DisableLoan eq "0">checked</cfif>>			  
					</td>		
					<td class="hide" id="loan#position.positionno#"></td>  
				</cfif>
			</cfif>
					
			</tr>
		</table>
		</td>
		
     </tr>
	  
	 <tr style="height:20px" class="labelmedium"><td></td>
	      <td colspan="2">		  
		  		  
		  <cfif AccessPosition eq "EDIT" or AccessPosition eq "ALL"  or AccessLoaner eq "EDIT" or AccessLoaner eq "ALL">
		 	  
			  	 <cf_filelibraryN
					DocumentPath  = "Position"
					SubDirectory  = "#Position.PositionNo#" 
					Filter        = ""
					loadscript    = "No"
					Insert        = "yes"
					Remove        = "yes"
					Highlight     = "no"
					Listing       = "yes">
				
			 <cfelse>
			 
			   	 <cf_filelibraryN
					DocumentPath  = "Position"
					SubDirectory  = "#Position.PositionNo#" 
					Filter        = "main"
					loadscript    = "No"
					Insert        = "no"
					Remove        = "no"
					Highlight     = "no"
					Listing       = "yes">
			 	 
			 </cfif>
			 				  
		  </td>
	  </tr>
	  
	  <tr><td height="4"></td></tr>
	   	 	  
	  </cfoutput>
			 	
    </table>
    </td>
  </tr>
</table>

