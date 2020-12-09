<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfinvoke component="Service.Presentation.Presentation" 
     method="highlight" 
	 returnvariable="stylescroll">
	 
 <cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.idmenu#"
	Key2Value       = "#url.mission#"				
	Label           = "Yes">	
	 
<cf_screentop label="#url.mission# : #lt_content#" html="Yes" jquery="Yes" layout="Webapp" banner="gray" bannerforce="Yes">	 

<cf_listingscript       mode="Regular">
<cf_dialogstaffing>
<cf_dialogPosition>
<cf_actionlistingscript mode="Regular">
<cf_fileLibraryScript   mode="Regular">
<cfajaximport tags="cfdiv">

<cfparam name="url.mandate" default="P002">
   
<!--- obtain a list of functions to be shown here --->

<cfinvoke component = "Service.Authorization.Function"  
  			 method           = "AuthorisedFunctions" 
			 mode             = "View"			 
			 mission          = "#url.mission#" 
			 orgunit          = ""
   			 Role             = ""
			 SystemModule     = "'Staffing'"
			 FunctionClass    = "'Inquiry'"
			 MenuClass        = "'Action'"
			 Except           = "''"
   			 Anonymous        = ""
			 returnvariable   = "listaccess">		 
	  

<cfif listaccess.recordcount eq "">

	<table width="98%" align="center">

		<tr>
		   <td align="center" class="labelmedium" style="font-size:16px;padding-top:40px"><font color="FF0000">You have no access to this function.<br>Please contact your administrator</td>
		</tr>
	
	</table>	

<cfelse>
      
	<cfoutput>
	
		<script language="JavaScript">
		
		function submenu(category,menusel,len) {
			
			 menucnt=1 	
			 len++ 	 	
			
		     while (menucnt != (len)) {
					
				  if (menucnt == menusel) {
				    document.getElementById(category+menucnt).className = "highlight"
				  } else {
				    document.getElementById(category+menucnt).className = "regular"
				  }		  
				  menucnt++	  	 
			 }
				
		 }
		
		 function personevent(sid) {
		      Prosis.busy('yes')
		      _cf_loadingtexthtml='';
			  ptoken.navigate('#SESSION.root#/Staffing/Reporting/ActionLog/EventListing.cfm?systemfunctionid='+sid+'&mission=#url.mission#&mandateno='+document.getElementById('mandateselect').value,'actionbox')		 
		 }
		 
		 function personcost(sid) {
		      Prosis.busy('yes')
		      _cf_loadingtexthtml='';
			  ptoken.navigate('#SESSION.root#/Staffing/Reporting/ActionLog/EmployeeCostListing.cfm?systemfunctionid='+sid+'&mission=#url.mission#&mandateno='+document.getElementById('mandateselect').value,'actionbox')		 
		 }
		 		 
		 function personassignment(sid) {
		      Prosis.busy('yes')
		      _cf_loadingtexthtml='';
		      ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/PersonAction/ActionListContent.cfm?systemfunctionid='+sid+'&mode=assignment&mission=#url.mission#&mandateno='+document.getElementById('mandateselect').value,'actionbox')		 
		 }
		 
		  function personaction(sid) {
		      Prosis.busy('yes')
		      _cf_loadingtexthtml='';
		      ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/PersonAction/ActionListContent.cfm?systemfunctionid='+sid+'&mode=other&mission=#url.mission#&mandateno='+document.getElementById('mandateselect').value,'actionbox')		 
		 }		 
		
		</script>
			
	<table width="100%" align="center" height="100%">
		 
	 <tr class="line">
	 	    
	   <td class="labellarge" style="padding-left:6px;min-width:80px;font-size: 18px;height: 35px;padding-top: 2px;padding-right: 5px"><cf_tl id="Period">:</td>
	   
	        <cfquery name="MandateList" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   *
			    FROM     Ref_Mandate
				WHERE    Mission = '#URL.Mission#' 
				AND      Operational = 1
				ORDER BY DateEffective
			</cfquery>
								
			<td style="width:100px">
			
				<select name="MandateSelect" id="mandateselect" style="border:0px;font-size:18px;height:26px;width:190" class="regularxl" onChange="reloadview(totals.value,snapshot.value,'operational',this.value)">
					<cfloop query="MandateList">
						<option value="#MandateNo#" 
						<cfif MandateNo eq "#URL.Mandate#">selected</cfif>>
						#MandateNo# [#DateFormat(DateExpiration, CLIENT.DateFormatShow)#]
					</option>						
					</cfloop>
				</select>
																		
			</td>
		  
	       <td align="right" style="width:100%;padding-left:10px">
		   
		   <table style="height:100%" cellspacing="0" cellpadding="0">
		   <tr>
		  		     
			   <cfloop query="listaccess"> 
			   			    				
					 <td name="actionlog#currentrow#" id="actionlog#currentrow#" style="padding-top3px" #stylescroll# 			  
						  onclick="submenu('actionlog','#currentrow#','#recordcount#');#scriptname#('#systemfunctionid#')">
						
						<table border="0" style="cursor:pointer">
				  		<tr>
						<td align="center" style="padding-left:6px;height:50px">
							<img src="#SESSION.root#/Images/Menu_brown.png" height="32" width="32">
						</td>						
						<td align="center" style="padding-left:6px;padding-right:20px;font-size:16px;border-right:1px solid ##cccccc;" class="labelmedium"><cf_uitooltip tooltip="#FunctionMemo#"><font color="000000">#FunctionName#</cf_uitooltip><td>
						</tr>				
			  		    </table>  
												
					 </td>	
				 
				</cfloop> 
				 		   
		   </tr>	   
		   </table>
	   
	   </td>		 	 
	 </tr>
	 
	 </cfoutput>
	 	 
	 <tr>
	  <td height="100%" valign="top" colspan="3" id="actionbox"></td>
	 </tr>
					  
	</table>  
	
</cfif>	
 