
<cfparam name="url.positionNo" default="0">
<cfparam name="url.class" default="Used">

<cfquery name="Position" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  P.*,		       
		        PP.OrgUnitOperational AS ParentOrgUnit
		FROM    Position AS P INNER JOIN
                PositionParent AS PP ON P.PositionParentId = PP.PositionParentId
		WHERE   P.PositionNo = '#url.positionno#'
</cfquery>		

<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_Mandate
		WHERE   Mission   = '#Position.Mission#'
		AND     MandateNo = '#Position.MandateNo#'
</cfquery>		


<cfquery name="Param" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_ParameterMission
		WHERE   Mission   = '#Position.Mission#'		
</cfquery>	

<cfinvoke component    = "Service.Access"  
      method           = "staffing" 
	  orgunit          = "#Position.OrgUnitOperational#" 
	  posttype         = "#Position.PostType#"
	  returnvariable   = "accessStaffing"> 

<cfinvoke component="Service.Access"  
      method         = "position" 
	  orgunit        = "#Position.OrgUnitOperational#" 
	  role           = "'HRPosition'"
	  posttype       = "#Position.PostType#"
	  returnvariable = "accessPosition"> 	
	  
<cfinvoke component="Service.Access"  
     method          = "recruit" 
     orgunit         = "#Position.OrgUnitOperational#" 
     posttype        = "#Position.PostType#"
     returnvariable  = "accessRecruit"> 	    

<cfoutput>

<!--- DEFINE access on the fly --->

    <cfset show  = "0"> 	
    <cfset show1 = "hide">
	<cfset show2 = "hide">
	<cfset show3 = "hide">
	<cfset show4 = "hide">
	<cfset show5 = "hide">
	<cfset show6 = "hide">
	
	<cfif (AccessPosition eq "EDIT" OR AccessPosition eq "ALL")>

        <cfset show  = "1"> 	
		<cfset show1 = "Show">
		<cfset show2 = "Show">
		<cfset show3 = "Show">
		<cfset show4 = "Show">
				
	</cfif>	
	
	<cfif AccessStaffing eq "EDIT" OR AccessStaffing eq "ALL">
	
	    <cfset show  = "1"> 	
		<cfset show4 = "Show">
		<cfset show5 = "Show">
		<cfset show6 = "Show">
			
	</cfif>
	
	<cfif (AccessRecruit eq "EDIT" OR AccessRecruit eq "ALL")>
	
	    <cfset show  = "1"> 	
		<cfset show6 = "Show">
					
	</cfif>	
	
	<cfif Position.Mission neq Position.MissionOperational>
	
		 <cfset show2 = "Hide">
	
	</cfif>
	
	<cfif param.AssignmentEntryDirect eq "0">	
		 <cfset show5 = "hide">
	</cfif>
		
	<cfif show neq "0">
	
	   <cfif Position.ParentOrgUnit neq Position.OrgUnitOperational and url.Class eq "Used">
	   
	   <img src="#SESSION.root#/Images/sync.gif" alt="Borrowed - Position menu" name="img0_#url.positionno#" 
		 onMouseOver="document.img0_#url.positionno#.src='#SESSION.root#/Images/button.jpg'" 
		 onMouseOut="document.img0_#url.positionno#.src='#SESSION.root#/Images/sync.gif'"
		 style="cursor: pointer;" height="9" width="9" border="0" align="absmiddle">
	   
	   <cfelse>
	
		<img src="#SESSION.root#/Images/pointer.gif" alt="Position menu" name="img0_#url.positionno#" 
		 onMouseOver="document.img0_#url.positionno#.src='#SESSION.root#/Images/button.jpg'" 
		 onMouseOut="document.img0_#url.positionno#.src='#SESSION.root#/Images/pointer.gif'"
		 style="cursor: pointer;" height="9" width="9" border="0" align="absmiddle">
		 
	   </cfif>	 
		
	  <cfif Mandate.MandateStatus eq "1" or Position.Mission neq Position.MissionOperational>	
	  
		 <cf_dropDownMenu
		  name="menu"
		  headerName="Position"
		  menuRows="5"
		  AjaxId="#url.ajaxid#"
		  
		  menuName1="Enter Assignment"
		  menuAction1="javascript:AddAssignment('#url.PositionNo#','i#url.PositionNo#')"
		  menuIcon1="#SESSION.root#/Images/AssignmentAdd.png"
		  menuStatus1="Add a new assignment"
		  menuShow1="#show5#"
				  
		  menuName2="Duplicate position"
		  menuAction2="javascript:AddPosition('#Position.Mission#','#Position.MandateNo#','#Position.OrgUnitOperational#','#Position.FunctionNo#','#Position.Posttype#','#Position.PostGrade#','#Position.LocationCode#','#Position.OrgUnitAdministrative#','#url.PositionNo#')"
		  menuIcon2="#SESSION.root#/Images/PositionDuplicate.png"
		  menuStatus2="Duplicate position"
		  menuShow2="#show2#"
		  
		  menuName3="View Position"
		  menuAction3="javascript:EditPost('#url.PositionNo#')"
		  menuIcon3="#SESSION.root#/Images/PositionView.png"
		  menuStatus3="View position"
		  menuShow3="#show3#"
		  
		  menuName4="Edit Position"
		  menuAction4="javascript:EditPosition('#Position.Mission#','#Position.MandateNo#','#url.PositionNo#','i#url.PositionNo#')"
		  menuIcon4="#SESSION.root#/Images/PositionEdit.png"
		  menuStatus4="Edit position"
		  menuShow4="#show4#"	   
		  
	      menuName5="Initiate Recruitment"
		  menuAction5="javascript:AddVacancy('#url.PositionNo#')"
		  menuIcon5="#SESSION.root#/Images/Recruitment.png"
		  menuStatus5="Initiate recruitment"	  
		  menuShow5="#show6#">
		  
		  <cfelse>
		  
		    <cf_dropDownMenu
		  name="menu"
		  headerName="Position"
		  menuRows="5"
		  AjaxId="#url.ajaxid#"
		  
		  menuName1="Enter Assignment"
		  menuAction1="javascript:AddAssignment('#url.PositionNo#','i#url.PositionNo#')"
		  menuIcon1="#SESSION.root#/Images/AssignmentAdd.png"	  
		  menuStatus1="Add a new assignment"
		  menuShow1="#show5#"
		  
		  menuName2="Duplicate Position"
		  menuAction2="javascript:AddPosition('#Position.Mission#','#Position.MandateNo#','#Position.OrgUnitOperational#','#Position.FunctionNo#','#Position.Posttype#','#Position.PostGrade#','#Position.LocationCode#','#Position.OrgUnitAdministrative#','#url.PositionNo#')"
		  menuIcon2="#SESSION.root#/Images/PositionDuplicate.png"
		  menuStatus2="Duplicate position"
		  menuShow2="#show2#"
		  
		  menuName3="View Position"
		  menuAction3="javascript:EditPost('#url.PositionNo#')"
		  menuIcon3="#SESSION.root#/Images/PositionView.png"
		  menuStatus3="View position"
		  menuShow3="#show3#"
		  
		  menuName4="Edit Position"
		  menuAction4="javascript:EditPosition('#Position.Mission#','#Position.MandateNo#','#url.PositionNo#','i#url.PositionNo#')"
		  menuIcon4="#SESSION.root#/Images/PositionEdit.png"
		  menuStatus4="Edit position"
		  menuShow4="#show4#"
		  
		  menuName5="Intiate Recruitment"
		  menuAction5="javascript:AddVacancy('#url.PositionNo#')"
		  menuIcon5="#SESSION.root#/Images/Recruitment.png"
		  menuStatus5="Initiate recruitment"
		  menuShow5="#show6#">
		  
		  </cfif>
		  	  
	  </cfif>
		  
</cfoutput>	  