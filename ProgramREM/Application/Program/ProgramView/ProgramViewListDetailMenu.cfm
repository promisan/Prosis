<cfparam name="URL.lev" default="0">
<cfparam name="URL.Unit" default="0">
<cfparam name="URL.ProgramAccess" default="NONE">
<cfparam name="URL.ManagerAccess" default="NONE">



<!--- JM on 02/02/2010 Added Ajax Id, and moved some of the interface text --->

<cfparam name="URL.AjaxId" default="">

<cfquery name="Program" 
	 datasource="AppsProgram" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT P.*, 
		        Pe.*,
				Pa.Textlevel1,
				PA.TextLevel2,
				PA.enableEntry,
				PA.enableBudget, 
				PA.EnableProjectLevel1
		 FROM   Program P, ProgramPeriod Pe, Ref_ParameterMission Pa
		 WHERE  P.ProgramCode = Pe.ProgramCode 
		 AND    Pe.ProgramId = '#URL.ProgramId#'	
		 AND    P.Mission = Pa.Mission
</cfquery>

<cfif lev eq "0">
    <cfset txt = Program.TextLevel1>
<cfelse>
    <cfset txt = Program.TextLevel2> 
</cfif>

	<!---language matters --->
			
	<cf_tl id="Started" var="1">
	<cfset tStarted = "#Lt_text#">
	
	<cf_tl id="Not started" var="1">
	<cfset tNotStarted = "#Lt_text#">
	
	<cf_tl id="Cluster" var="1">
	<cfset tCluster = "#Lt_text#">
		
	<cf_tl id="Inquiry" var="1">
	<cfset tInquiry = "#Lt_text#">
	
	<cf_tl id="Maintain" var="1">
	<cfset tMaintain = "#Lt_text#">	
				
	<cf_tl id="Budget" var="1">
	<cfset tCosting = "#Lt_text#">
		 
	<cf_tl id="Activities" var="1">
	<cfset tProgress = "#Lt_text#">
	
	<cf_tl id="Indicator" var="1">
	<cfset tIndicator = "#Lt_text#">
		 
	<cf_tl id="Title and Settings" var="1">
	<cfset tEdit = "#Lt_text#">
		 
	<cf_tl id="Budget Execution" var="1">
	<cfset tExecution = "#Lt_text#">

<cfif Program.ProgramClass eq "Project">

	<cfquery name="Parent" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT *
		FROM   Program
		WHERE  ProgramCode = '#Program.PeriodParentCode#'
	</cfquery>
	
	<cfif Parent.ProgramNameShort neq "">
			
		 <cfset pnt = "Project">	
		 
	<cfelse>
		
	     <cfset pnt = ""> 	
		 	
	</cfif>	
	
<cfelse>

	<cfset pnt = ""> 	
	
</cfif>
	
<cfif Program.ProgramNameShort neq "">
		
	<cf_tl id="Add #Program.ProgramNameShort#" var="1">
	<cfset tAdd = "#Lt_text#">
		
	<cf_tl id="Add #Program.ProgramNameShort# component" var="1">
	<cfset tAdds = "#Lt_text#">	
	
<cfelse>

	<cf_tl id="Add Project" var="1">
	<cfset tAdd = "#Lt_text#">
		
	<cf_tl id="Add #txt#" var="1">
	<cfset tAdds = "#Lt_text#">
	
	
</cfif>	


<cfoutput>

<!--- define access context sensitive menu --->

    <cfset show   = "0"> 	
    <cfset show1  = "Hide">    <!--- view --->
	<cfset show2  = "Hide">    <!--- edit --->
	<cfset show3  = "Hide">    <!--- review --->
	<cfset show4  = "Hide">    <!--- P: add project --->
	<cfset show5  = "Hide">    <!--- C: add component --->
	<cfset show6  = "Hide">    <!--- B:costing --->
	<cfset show7  = "Hide">    <!--- P: gantt --->
	<cfset show8  = "Hide">    <!--- C:measurement --->
	<cfset show9  = "Hide">    <!--- modify project --->
	<cfset show10 = "Hide">   <!--- modify Component --->
	<cfset show11 = "Hide">   <!--- modify Program --->
			
	<cfif Program.ProgramClass eq "Project">
		
	      <cfset icon = "newwindow.gif">
		  <cfset iconw = "15">
		  <cfset iconh = "9"> 
		  						  
		  <CFIF (url.ManagerAccess NEQ "NONE" or url.ProgramAccess NEQ "NONE")> 
		  
		    <cfset show1 = "Show">  <!--- view --->
			<cfset show2 = "Show">  <!--- edit --->
			<cfif (Program.enableEntry eq "1") and (url.ManagerAccess NEQ "NONE" or url.ManagerAccess NEQ "NONE")>
		
				    <cfset show4 = "Show">  <!--- P: add project --->
					<cfset show5 = "Show">  <!--- C: add component --->				
				
			</cfif>
			<cfif Program.enableBudget eq "1">
				<cfset show6 = "Show">  <!--- B:costing --->
			</cfif>
			<cfset show7 = "Show">  <!--- P: gantt audit --->
		    
			<cfset show9 = "Show">  <!--- modify --->
			
		  <cfelse>
		  
		    <cfset show1 = "Show">  <!--- view --->
			<cfif Program.enableBudget eq "1">
				<cfset show6 = "Show">  <!--- B:costing --->
			</cfif>
			
		  </cfif>	
	  
	 <cfelse> <!--- program --->
	 
		    <cfif Program.ProgramScope eq "Unit" or Program.ProgramScope eq "Parent">
		 
		 	  <cfset icon = "newwindow.gif">
			  <cfset iconw = "15">
			  <cfset iconh = "9">
				   
			<cfelse>
			
			  <cfset icon = "pointer.gif">	
			  <cfset iconw = "9">
		      <cfset iconh = "9">
			
			</cfif>	 
			
			<!--- 29/5 hide indicator for programs, programs do nit have indicators only components --->
			
			<cfif Program.ProgramClass eq "Component">  			
				<cfset show8 = "Show">   <!--- C: Measurement ---> 
			<cfelse>			
				<cfset show8 = "Hide">	
			</cfif>
		
		  <CFIF (url.ManagerAccess NEQ "NONE" or url.ProgramAccess NEQ "NONE")> 
			  		 	 
			 	<cfif Program.ProgramScope eq "Unit" or Program.ProgramScope eq "Parent">
				
					<cfset show1 = "Show">  <!--- view --->
					<cfset show2 = "Show">  <!--- edit --->
					<cfif Program.ProgramClass eq "Program">
						<cfset show3 = "Show">  <!--- review --->
					</cfif>
					
					<cfif (Program.enableEntry eq "1" or 
					     (url.ManagerAccess EQ "ALL" or url.ManagerAccess EQ "EDIT" or url.ManagerAccess EQ "READ"))
						  and url.ProgramAccess neq "NONE">

						<cfif lev lt "4">  
							<cfif Program.EnableProjectLevel1 eq "1">
						  		  <cfset show4 = "show">  <!--- P: add project   --->
								  <cfset show5 = "Show">  <!--- C: add component --->
						    </cfif> 							
						</cfif>	
						
					</cfif>
					<cfif Program.enableBudget eq "1">
						<cfset show6 = "Show">  <!--- B:costing --->
					</cfif>
					
					<!--- overruled this is driven more complicated and better to do from maintrenance --->
					<cfset show6 = "hide">
					
					<cfif lev eq "0">					
				   	   <cfset show11 = "Show">  <!--- modify --->
					<cfelse>					
					   <cfset show10 = "Show">  <!--- modify --->
					</cfif>
				
				<cfelse> <!--- global programs --->				
								
					<cfif url.ManagerAccess EQ "ALL" or url.ManagerAccess EQ "EDIT">
						 <cfset show1 = "Show">  <!--- view --->
					     <cfset show2 = "Show">  <!--- edit --->
						<cfif Program.ProgramClass eq "Program">
							<cfset show3 = "Show">  <!--- review --->
						</cfif>
					</cfif>
					
					<cfif Program.enableBudget eq "1" and (url.ManagerAccess EQ "ALL" or url.ManagerAccess EQ "EDIT" or url.ManagerAccess EQ "READ")>					
						<cfset show6 = "Show">  <!--- B:costing --->
					</cfif>
					
					<!--- overruled this is driven more complicated and better to do from maintrenance --->
					<cfset show6 = "hide">

					<cfif (Program.enableEntry eq "1" or 
					     (url.ManagerAccess EQ "ALL" or url.ManagerAccess EQ "EDIT"))
						  and url.ProgramAccess neq "NONE">
						  
						<cfset show4 = "Show">  <!--- P: add project --->
					    <cfset show5 = "Show">  <!--- C: add component --->
					</cfif>
					
					<cfif url.ManagerAccess EQ "ALL" or url.ManagerAccess EQ "EDIT">
						<cfif url.lev eq "0">
				   	  	   <cfset show11 = "Show"> <!--- modify --->
						<cfelse>
						   <cfset show10 = "Show">  <!--- modify --->
						</cfif>
					</cfif>
				    						
				</cfif>
		 
	 	</cfif> 
		
	 </cfif>
	 	 
	 <cfif show1 eq "Hide" 
	     and show2 eq "Hide" 
		 and show3 eq "Hide" 
		 and show4 eq "Hide" 
		 and show5 eq "Hide" 
		 and show6 eq "Hide" 
		 and show7 eq "Hide" 
		 and show8 eq "Hide" 
		 and show9 eq "Hide" 
		 and show10 eq "Hide" 
		 and show11 eq "Hide">
	 
	 <!--- nada --->
	 
	 <cfelse>
	 	 		 								 	  
     <cf_dropDownMenu
	     name="menu"
	  	 headerName="Options"
	     menuRows="10"
		 AjaxId="#url.AjaxId#"	
		 
		 menuName1="#tEdit#"
	     menuAction1="javascript:AddProject('#Program.mission#','#Program.Period#','#Program.PeriodParentCode#','#Program.OrgUnit#','#Program.ProgramCode#','0','#Program.ProgramId#');" 
	     menuIcon1="#SESSION.root#/Images/view.jpg"
	     menuStatus1="#tEdit#"
		 menuShow1="#show9#"	 	 
			 
	     menuName2="#tMaintain#"
	     menuAction2="javascript:EditProgram('#Program.ProgramCode#','#Program.Period#','#Program.ProgramClass#')"
	     menuIcon2="#SESSION.root#/Images/edit.gif"
	     menuStatus2="#tMaintain#"
		 menuShow2="#show2#"
		 
		 menuName3="#tProgress#"
	     menuAction3="javascript:AuditProject('#Program.ProgramCode#','#Program.Period#')"
	     menuIcon3="#SESSION.root#/Images/gantt.gif"
	     menuStatus3="#tProgress#"	
		 menuShow3="#show7#"
		 
		 menuName4="#tCosting#"	 
		 menuAction4="javascript:AllotmentProgram('#Program.Mission#','#Program.ProgramCode#','#Program.Period#')"
	     menuIcon4="#SESSION.root#/Images/dollar.png"
	     menuStatus4="#tCosting#"	
		 menuShow4="#show6#"
		 	 
		 menuName5="#tIndicator#"
	     menuAction5="javascript:AuditProgram('#Program.ProgramCode#','#Program.Period#')"
	     menuIcon5="#SESSION.root#/Images/chart.gif"
	     menuStatus5="tIndicator"	
		 menuShow5="#show8#"     
		 menuLine5="Yes"
		
	     menuName6="#tAdd#"
	     menuAction6="javascript:AddProject('#Program.mission#','#Program.Period#','#Program.ProgramCode#','#URL.Unit#','','0','add');"
	     menuIcon6="#SESSION.root#/Images/insert.gif"
	     menuStatus6="#tAdd#"
		 menuShow6="#show4#"
			 
		 menuName7="#tAdds#"
	     menuAction7="javascript:AddComponent('#Program.mission#','#Program.Period#','#Program.ProgramCode#','#URL.Unit#','','0','add')"
	     menuIcon7="#SESSION.root#/Images/insert.gif"
	     menuStatus7="#tAdds#"
		 menuShow7="#show5#"
				 
		 menuName8="#tExecution#"
	     menuAction8="javascript:detail('#Program.ProgramCode#');"
	     menuIcon8="#SESSION.root#/Images/spend.png"
	     menuStatus8="#tEdit#"
		 menuShow8="show"
		 menuLine8="Yes"
		 
		 menuName9="#tEdit#"
	     menuAction9="javascript:AddComponent('#Program.mission#','#Program.Period#','#Program.PeriodParentCode#','#Program.OrgUnit#','#Program.ProgramCode#','0','#Program.ProgramId#');"
	     menuIcon9="#SESSION.root#/Images/preview.png"
	     menuStatus9="#tEdit#"
		 menuShow9="#show10#"
		 
	     menuName10="#tEdit#"
	     menuAction10="javascript:AddProgram('#Program.mission#','#Program.Period#', '#Program.OrgUnit#','#Program.ProgramCode#','0','#Program.ProgramId#');"
	     menuIcon10="#SESSION.root#/Images/preview.png"
	     menuStatus10="#tEdit#"
		 menuShow10="#show11#">
	 								 
	 </cfif>		 			 
					    		
</cfoutput>



