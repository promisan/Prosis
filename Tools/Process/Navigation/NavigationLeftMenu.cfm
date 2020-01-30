
<cf_screentop height="100%" scroll="No" jquery="Yes" html="No" title="#SESSION.welcome#">

<cfajaximport>

<cf_param name="URL.Section"         default="" 		    type="String">
<cf_param name="URL.Code"            default="" 		    type="String">
<cf_param name="URL.Owner"           default="" 		    type="String">
<cf_param name="URL.Mission"         default="" 		    type="String">
<cf_param name="URL.Alias"           default="" 		    type="String">
<cf_param name="URL.Object"          default="" 		    type="String">
<cf_param name="URL.ObjectId"        default="Id" 	     	type="String">
<cf_param name="URL.TableName"       default="#URL.Object#" type="String">
<cf_param name="URL.Group"           default="#URL.Object#" type="String">
<cf_param name="URL.ID"              default="" 		    type="String">
<cf_param name="URL.ID1"             default="" 		    type="String">
<cf_param name="URL.IconWidth"       default="48"		    type="String">
<cf_param name="URL.IconHeight"      default="48"		    type="String">

<cfparam name="Attributes.Section"       default="#URL.Section#">
<cfparam name="Attributes.Alias"         default="#URL.Alias#">
<cfparam name="Attributes.Owner"         default="#URL.Owner#">
<cfparam name="Attributes.Mission"       default="#URL.Mission#">
<cfparam name="Attributes.TableName"     default="#URL.TableName#">
<cfparam name="Attributes.Object"        default="#URL.Object#">
<cfparam name="Attributes.ObjectId"      default="#URL.ObjectId#">
<cfparam name="Attributes.Group"         default="#URL.Group#">
<cfparam name="Attributes.ID"            default="#URL.ID#">
<cfparam name="Attributes.ID1"           default="#URL.ID1#">
<cfparam name="Attributes.IconWidth"     default="#URL.IconWidth#">
<cfparam name="Attributes.IconHeight"    default="#URL.IconHeight#">

<cfif Attributes.Object eq "">
  <cfabort>
</cfif> 

<cfset alias      = Attributes.Alias>
<cfset tablename  = Attributes.TableName>
<cfset object     = Attributes.Object>
<cfset objectId   = Attributes.ObjectId>
<cfset iconWidth  = Attributes.IconWidth>
<cfset iconHeight = Attributes.IconHeight>

<cfquery name="Select" 
	datasource="#Alias#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
    FROM   #TableName# R
    WHERE  #Object##ObjectId# = '#Attributes.Id#' 
</cfquery>

<cfoutput>

<script language="JavaScript">
	
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
	function refresh() {
		history.go()
	}
	
	function hl(itm,fld,name){
			 
	     if (ie){
	          while (itm.tagName!="TABLE")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TABLE")
	          {itm=itm.parentNode;}
	     }
			 		 	
		 if (fld != false){
			
		 if (itm.className != "select") {	 		
			 itm.className = "highLight";
		     self.status = name;
			 }
			 
		 } else {
			
		 if (itm.className != "select") {	 
			 itm.className = "normal";		
			 itm.style.cursor = "";
			 self.status = name;
			 }
		 
		 }
	  }
	  
	function loadform(itm) {
	   
	   parent.Prosis.busy('yes')
	   try {		      
	 	   ptoken.navigate('#SESSION.root#/tools/Process/Navigation/Launch.cfm?Owner=#url.owner#&Mission=#url.mission#&Code=#URL.Code#&Alias=#Alias#&TableName=#TableName#&Object=#Object#&ObjectId=#ObjectId#&id=#Attributes.Id#&section='+itm,'selectoption') 
	   } catch(e) {  		      
	      parent.right.location = "#SESSION.root#/tools/Process/Navigation/Launch.cfm?Owner=#url.owner#&Mission=#url.mission#&ts="+(Math.floor(Math.random()*20)+1)+"&Code=#URL.Code#&Alias=#Alias#&TableName=#TableName#&Object=#Object#&ObjectId=#ObjectId#&id=#Attributes.Id#&section="+itm 
	 }
	}
	
	function selected(menu){
	
		var m = document.getElementById("menu"); 
		var cells = m.getElementsByTagName("table"); 
		for (var i = 0; i < cells.length; i++) {
			 cells[i].className = "normal"; 
		}		
		se = document.getElementById(menu)	
		se.className = "select";			
	  }
	  
	function scrollToItem(selector) {
		$('.menucontainer2').animate({
	        scrollTop: $(selector).offset().top
	    }, 250);
	}
	  
</script>  

</cfoutput>

<style>

	body, html {
		border:0px;
		margin:0px;
		padding:0px;
	}
	
	.menucontainer1{
	    height: 100%;
	    width: 100%;
	    overflow: hidden;
	}
	
	.menucontainer2{
	    height: 100%;
	    width: 110px;
	    overflow-y: hidden;
		overflow-x: hidden;
	}

	A {
		text-decoration: none;
		color: black;
	}

	A:Hover {
		text-decoration: none;
		color: gray;
	}

	table.highLight {
		background-color: #E5E5E5;
		color : black;
		border : Black;
		font-weight : normal;
		border-top : 0px solid silver;
		border-right : 0px solid silver;
		border-left : 0px solid silver;
		border-bottom : 0px solid silver;
	}

	table.normal {
		color : black;
		font-weight : normal;
		border-top : 0px solid f4f4f4;
		border-right : 0px solid f4f4f4;
		border-left : 0px solid f4f4f4;
		border-bottom : 0px solid f4f4f4;
	}
	
	table.regular {
		color : black;
		font-weight : normal;
		border-top : 0px solid f4f4f4;
		border-right : 0px solid f4f4f4;
		border-left : 0px solid f4f4f4;
		border-bottom : 0px solid f4f4f4;
	}

	table.select {
		color : black;
		border : #C9D3DE;
		font-weight : normal;
		border-top : 0px solid gray;
		border-right : 0px solid gray;
		border-left : 0px solid gray;
		border-bottom : 0px solid gray;
		background-color: #E5E5E5;
	}
</style>

<div class="menucontainer1" style="width:100%">

    <div class="menucontainer2" style="width:100%">

		<table width="100%" border="0" cellspacing="0" cellpadding="0" id="menu">
							   	
			<cfoutput>
			
				<cfset r = 0>
			
				<cftry>
				
					<!--- Check if the table has an underline owner restriction --->
					<cfquery name="qCheckOwnerSection" 
					datasource="appsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   *
						FROM     #CLIENT.LanPrefix#Ref_#Object#SectionOwner
						WHERE    Owner = '#URL.Owner#' 
					</cfquery>
					<cfset ValidateOwner = qCheckOwnerSection.recordcount>
					
				<cfcatch>
				
					<cfset ValidateOwner = 0>	
					
				</cfcatch>	
				
				</cftry>
				
				<cfquery name="Section" 
				datasource="#alias#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   #CLIENT.LanPrefix#Ref_#Object#Section R INNER JOIN #Object#Section C 
					   ON  R.Code = C.#Object#Section
					  AND  C.#Attributes.Object##Attributes.ObjectId# = '#Attributes.Id#' 
				    WHERE  R.TriggerGroup = '#Attributes.Group#'	
					AND    R.Operational = 1 
					AND    C.Operational = 1
					<cfif ValidateOwner neq 0>
						AND EXISTS
						(
							SELECT 'X'
							FROM #CLIENT.LanPrefix#Ref_#Object#SectionOwner
							WHERE Code = R.Code
							AND   Owner = '#URL.Owner#'
							AND   Operational = '1' 
						)
					</cfif>	
					ORDER BY ListingOrder  
					
				</cfquery>	
													
				<cfloop query="Section">
				
				    <cfset show = "1">
									
					<cfif Attributes.Object eq "Claim">
					
							<cfquery name="Check" 
							datasource="#Alias#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT *
								FROM   ClaimSection 
								WHERE  ClaimId = '#Attributes.Id#'
								AND    ClaimSection = '#Code#'
							</cfquery> 
					
						 	<cfquery name="Operational" 
							datasource="#Alias#" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT  TOP 1 * 
								FROM    ClaimRequestLine
								WHERE   ClaimRequestId = '#Select.ClaimRequestId#'	
								<cfif showcondition neq "">
								AND     #PreserveSingleQuotes(ShowCondition)#
								</cfif>
							</cfquery> 
							
							<cfset show = operational.recordcount>
							
							<cfif Check.recordcount eq "0">
																											
									<cfquery name="Insert" 
									datasource="#Alias#" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										INSERT INTO ClaimSection 
										(ClaimId,ClaimSection,Operational)
										VALUES ('#Attributes.Id#','#Code#','#Check.recordcount#')
									</cfquery> 
														
							<cfelse>
											
									<cfif Operational.recordcount eq "0" and Check.Operational eq "1">
									
											<cfquery name="Update" 
											datasource="#Alias#" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												UPDATE ClaimSection 
												SET    Operational = 0
												WHERE  ClaimId = '#Attributes.Id#'
												AND    ClaimSection = '#Code#'
											</cfquery> 
																			
									<cfelseif Operational.recordcount eq "1" and Check.Operational eq "0">
															
											<cfquery name="Update" 
											datasource="#Alias#" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												UPDATE ClaimSection 
												SET    Operational = 1
												WHERE  ClaimId = '#Attributes.Id#'
												AND    ClaimSection = '#Code#'
											</cfquery> 
										
									</cfif>	
									
							</cfif>		
						
					<cfelse>
									
					    <cfquery name="Check" 
						datasource="#Alias#" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  * 
							FROM   #Attributes.TableName#
							WHERE  #Attributes.Object##Attributes.Objectid# = '#Attributes.Id#'
							       #PreserveSingleQuotes(ShowCondition)# 
						</cfquery> 

						<cfset vCheckAccess = true> 

						<cfif isDefined("AllowedGroups")>
							<cfif AllowedGroups neq "">
								<cfquery name="CheckAccess" 
								datasource="#Alias#" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT	*
									FROM	System.dbo.UserNamesGroup
									WHERE	Account = '#session.acc#'
									AND		AccountGroup IN (#preserveSingleQuotes(AllowedGroups)#)
								</cfquery>

								<cfif CheckAccess.recordCount eq 0>
									<cfset vCheckAccess = false>
								</cfif>
							</cfif>
						</cfif>
						
						<cfif Check.recordcount eq "0" OR not vCheckAccess>
									
						   <cfset show = "0">
						   
						<cfelse>
									
							<cftry>
								
								<cfquery name="Insert" 
								datasource="#Alias#" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									INSERT INTO #Object#Section 
									(#Attributes.Object##Attributes.Objectid#,#Object#Section)
									VALUES ('#Attributes.Id#','#Code#')
								</cfquery> 
								
							<cfcatch></cfcatch>
								
							</cftry>
						
						</cfif>   
						
					</cfif>	
																									
					<cfif show eq "1">
										
						<cfset r = r+1>
									
						 <cfif Attributes.Section eq Code>
						   <cfset cl = "select">
			   			 <cfelse>			 
						   <cfset cl = "regular">
						 </cfif>						
												 
						 <td id="#code#" name="#code#" align="center" style="height:54px; width:100%;border-bottom: 1px solid ##dddddd;">						 
						 
						 		<cfinclude template="NavigationLeftMenuNode.cfm">			 		   
						 </td>
						 </tr>
				
				    </cfif>
						
				</cfloop>
					
				<tr class="hide"><td height="1" id="selectoption"></td></tr>
					
			</cfoutput>
			
		</table>	
   </div>
</div>


