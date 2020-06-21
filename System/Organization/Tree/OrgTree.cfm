
<!--- initial parameters --->

<cfparam name="URL.Mission"     default="">
<cfparam name="URL.OrgUnitCode" default="">
<cfparam name="URL.Tree"        default="Operational">
<cfparam name="URL.Mode"        default="Chart">

<cfquery name="Mission" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_Mission
	 WHERE  Mission   = '#URL.Mission#'		
</cfquery>

<cfset SESSION.Mission      = URL.Mission>
<cfset SESSION.MissionAdmin = Mission.TreeAdministrative>

<!--- 27/10/2014 not certain as to when this is used for MissionParentOrgUnit --->

<cfquery name="Mandate" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT  TOP 1 R.*, 
	         M.MissionName
	 FROM    Ref_Mandate R, Ref_Mission M
	 WHERE   R.Mission = M.Mission
	 <cfif URL.Mission neq "">
	 AND     M.Mission = '#URL.Mission#' 
	 <cfelse>
	 AND     M.MissionParentOrgUnit = '#URL.OrgUnitCode#' 
	 </cfif>
	 <cfif URL.MandateNo neq "">
	 AND     R.MandateNo='#URL.MandateNo#'
	 </cfif>	 
	 ORDER BY MandateDefault DESC
</cfquery>

<cfoutput>

<cf_dialogOrganization>
<cf_dialogStaffing>
<cf_calendarViewScript>

<cfinclude template="../../../Vactrack/Application/Document/Dialog.cfm">

<cf_calendarscript>

<cf_screenTop height="99%" 
    title="Organization tree: #url.Mission#" 	
	border="0" 
	bannerheight="50"
	html="No" 
	scroll="no" 	
	busy="busy10.gif"
	layout="webapp"
	jQuery="Yes">		

<cfinclude template="OrgTreeScript.cfm">
<cfajaximport tags="cfdiv">


<style>

	td.listcontent {		
		padding-left:3px;
		padding-right:3px
	}
	
</style>

<cf_layoutScript>	


<cfset attrib = {type="Border",name="lOrgTree",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	   	
	<cf_layoutarea 
          position="top"
          name="menu"
          minsize="50"
          maxsize="50"  
		  size="50"        
		  overflow="hidden"
          splitter="true">		   
		
		<cf_ViewTopMenu label="Staffing Table: <b>#Mandate.MissionName#</b> - Org Chart" background="BLUE" layout="webapp">
				 
	</cf_layoutarea>		
	
	<script>
		 function toggle(ob) {
			 se = document.getElementById(ob)
			 if (se.className == "hide") {
			     se.className = "regular"
			 } else {
			     se.className = "hide"
			 }	 
		}	 
	</script>
		
	<cf_layoutarea  position="left" name="treebox" size="370" splitter="true" collapsible="true">
				
		<cf_divScroll>	
						
	    <table border="0" width="100%" cellspacing="0" cellpadding="0">
						 
			 <tr><td align="center" style="padding-top:0px;padding-left:3px">
			 				  
					<cfoutput>
					 <table width="100%" height="100%" align="center">					
					 
					 <tr>
						  <td>
						    <table width="100%">		
							<tr class="line" style="height:25px">
						     
						     <td class="labelmedium" style="padding-left:4px;font-size:15px">
							 <a href="javascript:returnmain()"><font color="0080C0"><cf_tl id="back"></font></b></a>
							 </td>
							 <td class="labelmedium" style="padding-right:6px;padding-top:7px" align="right" valign="top">
							 
							 	<span style="display:none;" id="printTitle"><cf_tl id="Organization tree">: #url.Mission#</span>
							 	
								<cf_tl id="Print" var="1">
								<cf_button2 
									mode		= "icon"
									type		= "Print"
									title       = "#lt_text#" 
									id          = "Print"					
									height		= "28px"
									width		= "28px"
									imageheight  = "20px"
									printTitle	= "##printTitle"
									printContent = "##treeview">
								
							 </a></td>
						    </tr>
						    </tr>
							
							</table>
						  </td>
					 </tr>
									 
					 <input type="hidden" name="_Name"    id="_Name"   value="">
					 <input type="hidden" name="_OrgUnit" id="_OrgUnit" value="">				
											
					</table>
					</cfoutput>	 			
			 
			 </td></tr>	
			 
			 
			 					 
			 <tr class="hide"><td id="prepare"></td></tr>	    		 						  
						 				 
			 <tr id="selection">
			 
			 <td height="28" 
			    style="height:220;padding-left:8px;padding-right:18px;padding-bottom:9px" 
				valign="top" 				
				align="center">
										 
			 <cfif now() gte Mandate.DateEffective and now() lte Mandate.DateExpiration>
					<cfset vDefault = dateformat(now(),client.dateSQL)>					
				<cfelse>
					<cfset vDefault = Mandate.DateEffective>
				</cfif>
												
				<cfset URL.SelectionDate = vDefault>					
								
			 	<cf_calendarView 
				   mode           = "picker"		
				   title          = "mypicker"	
				   FieldName      = "selectiondate" 	
				   selecteddate   = "#url.selectiondate#"		
				   year           = "#year(vDefault)#"	
				   month          = "#month(vDefault)#"	   				   						  
				   day            = "#day(vDefault)#"
				   Function       = "refreshtree"	
				   showtoday      = "0"
				   showJump       = "0"		
				   showRefresh    = "0"
				   showPrint      = "0"	  					    			  				      	   
				   cellwidth      = "22"
				   cellheight     = "22"> 						 				   
								  								
				</td>
			 </tr>
			 		 
			
			 <!--- filtering --->			 			
					 
			 <tr><td>
			 
				 <table width="100%" cellspacing="0" cellpadding="0">
				 
				 	<tr onclick="toggle('filter')" style="cursor:pointer">
					<td height="23" width="20" style="padding-left:11px">
					
				 	<img src="#SESSION.root#/Images/arrow.gif" alt="Selection date" name="img_selectiondate" 
				   style="cursor: pointer;" align="absmiddle" border="0">
								  
					</td>
					<td class="labelmedium"><cf_tl id="Settings and Filters"></td>
					</tr>	
						 
				 </table>
				 
			 </td></tr>
			 
			 <tr id="filter" class="hide">
			 <td align="center" height="28" style="padding-left:10px">				
				<cfinclude template="OrgTreeFilter.cfm">				
			 </td>
			 </tr>	
			 
			 		 
			 <tr class="line"><td>
			 
				 <table width="100%" cellspacing="0" cellpadding="0">
				 
				 	<tr onclick="toggle('columns')" style="cursor:pointer">
					<td height="23" width="20" style="padding-left:11px">
					
				 	<img src="#SESSION.root#/Images/arrow.gif" alt="Selection date" name="img_selectiondate" 
				   style="cursor: pointer;" align="absmiddle" border="0">
								  
					</td>
					<td class="labelmedium"><font color="0080C0"><cf_tl id="Node content"></td>
					</tr>	
						 
				 </table>
				 
			 </td></tr>		
			 
			  			 
	 		 <tr id="columns" class="hide">
			 <td align="center" height="28">			
				<cfinclude template="OrgTreeColumns.cfm">			
			 </td>
			 </tr>	
			 			  
					 
			 <!--- tree selection --->
			 
			  <tr><td>
			 
				 <table width="100%" cellspacing="0" cellpadding="0">
				 
				    <tr><td height="4"></td></tr>					
				 	<tr onclick="toggle('tree')">					
					<td height="23" width="10" style="padding-left:1px"></td>
					<td>
					
						<select name="treeselect"
						      id="treeselect" 
							  onchange="showtree(this.value,'#url.Mission#','#url.mandateno#')" 
							  class="regularxl">
	
							<option value="Operational"    <cfif url.tree eq "Operational">selected</cfif>><cf_tl id="Functional Structure"></option>
							<option value="Administrative" <cfif url.tree eq "Administrative">selected</cfif>><cf_tl id="Budget Structure"></option>
							
						</select>
							
					</td>
					</tr>	
						 
				 </table>
				 
			 </td></tr>			 
			 			 	 		 		 
			 <tr><td id="tree" class="regular"  bgcolor="ffffff" style="padding-left:20px">			 
			 	<cfinclude template="OrgTreeShow.cfm">							
			</td>							
			</tr>				
			
		</table>
				
		</cf_divScroll>
		
	
	</cf_layoutarea> 

	<cf_layoutarea  
		position="center" 
		name="box"
		size="50%"
		maxsize="50%"
		minsize="50%"
		overflow="auto">

		<cf_divScroll overflowx="auto">
			<table width="100%" cellspacing="0" cellpadding="0" bgcolor="FFFFFF">
				<tr>				 		 
					<td valign="top" bgcolor="ffffff" align="center" style="padding:3px">
						<div id="wZoom" valign="center" align="center">
							<div id="wZoomContent" align="center" valign="center">
								<br>
								<input id="zoom" value="0" style="display:none"/>
							</div>
						</div>						
						<div id="treeview" style="zoom: 100%" align="center"></div>
					</td>					   
				</tr>
			</table>
		</cf_divScroll>		
			
	</cf_layoutarea>		

	<cf_layoutarea 
          position="right"
          name="rightbox"        
          size="130"
          collapsible="true"
          initcollapsed="true"
          splitter="true"
          maxsize="160">
		  
		  <cf_divScroll>
		  <table width="100%" cellspacing="0" cellpadding="0" bgcolor="FFFFFF" class="formpadding">				
				<tr>				 		 
					<td valign="top" id="picturebox" bgcolor="ffffff" align="center"></td>					   
				</tr>
			</table>
		  </cf_divScroll>
		  
	</cf_layoutarea>	  

	<cfif url.tree neq "Administrative">		
		
	<cf_layoutarea 
          position="bottom"
          name="treedetail"	         
          size="300px"			  
		  initcollapsed="true"
          collapsible="true">
				  
			<iframe name="treedetailcontent" id="treedetailcontent" width="100%" height="100%" scrolling="no" frameborder="0"></iframe>
				  
	</cf_layoutarea>			  

	</cfif>

</cf_layout>	

</cfoutput>
