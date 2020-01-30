<cfparam name="url.scope" 		default="backend">

<cf_screentop height="100%" jquery="Yes" scroll="Yes" html="No" busy="busy10.gif">

<cf_panescript>
<cf_presentationscript>
<cf_dialogPosition>
<cf_dialogStaffing>
<cf_dialogREMProgram>

<cfinclude template="../../System/EntityAction/EntityView/MyClearancesScript.cfm">
<cfinclude template="../../Vactrack/Application/Document/Dialog.cfm">
 
<cfajaximport tags="cfdiv,cfform,cfchart">

<cfoutput>
	
	<script language="JavaScript">
	 
		function refreshme(id,act,num) {   		    
			 ptoken.location('PortalTopics.cfm?id=' + id + '&act=' + act)	 			 
		}
				
		function facttabledetailxls1(control,format,box) {  
	     	ptoken.open("#SESSION.root#/component/analysis/CrossTabLaunch.cfm?ts="+new Date().getTime()+"&box="+box+"&data=1&controlid="+control+"&format="+format, "facttable");
		}		
		  
		function action(id,num) { 
			se = document.getElementById("box_"+num)
			ic = document.getElementById("toggle_"+num)		
			if (se.className == "regular") {
			     se.className = "hide"
			     ic.src = "#SESSION.root#/Images/portal_max.png" 
			     ptoken.navigate('PortalTopicsAction.cfm?id=' + id + '&act=min','content_'+num)
			} else {
			    se.className = "regular"
			    ic.src = "#SESSION.root#/Images/portal_min.png"
			    ptoken.navigate('PortalTopicsAction.cfm?id=' + id + '&act=max','content_'+num)
			} 				
		}
		
		function loadedit(frm,num,id) {    
		    se = document.getElementById("box_"+num)
			se.className = "regular"
		    ptoken.navigate('TopicEdit.cfm?id=' + id + '&context=subscription','content_'+num)
		}
		
		function loadmodule(path,mis,cond,sid) { 		
			ptoken.open(path+'?mission='+mis+'&'+cond+'&systemfunctionid='+sid,'_blank')
		}	
			
		function show_box_search() {
			element = document.getElementById('img_search');
			element_row = document.getElementById('dBox');
			if (element_row.className == 'hide') {
			    element_row.className = 'normal';
				element.src = '#SESSION.root#/images/arrow-up.gif';
			} else	{
				element_row.className = 'hide';
				element.src = '#SESSION.root#/images/arrow-down.gif';
			}	
		 }
	 	
	</script>

</cfoutput>

<style>
	.pane_clsSummaryPanelContainer, .pane_clsSummaryPanelItem {
		padding:0px;
		margin:0px;
		margin-bottom:7px;
	}
</style>

<cfparam name="URL.id"            default="">
<cfparam name="URL.go"            default="">
<cfparam name="URL.message"       default="">
<cfparam name="URL.messagehide"   default="">
<cfparam name="URL.act"           default="">
<cfparam name="SESSION.acc"        default="unknown">
<cfparam name="SESSION.login"      default="unknown">
<cfparam name="CLIENT.resolution" default="">

<cfif URL.messagehide eq "hide">
    <cfset CLIENT.resolution = "Hide">
</cfif>

<cfif URL.ID neq "">

   <cfswitch expression="#URL.Act#">

   <cfcase value="del">
   
	   <cfquery name="Delete" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM UserModule 
			WHERE  SystemFunctionId = '#URL.ID#'
			AND    Account = '#SESSION.acc#'  
	   </cfquery>
   
   </cfcase>
   
   </cfswitch>

</cfif>
 
<cfparam name="class" default="'Main'">

<cfquery name="SearchResult" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   M.FunctionMemo, 
	         M.FunctionPath, 
			 U.Status, 
			 U.Account, 
			 U.SystemFunctionId
	FROM     Ref_ModuleControl M, UserModule U
	WHERE    M.SystemFunctionId = U.SystemFunctionId 
	AND      M.SystemModule = 'Portal' 
	AND      M.Operational  = '1' 
	AND      M.MenuClass    = 'Topic'
	AND      U.Account      = '#SESSION.acc#' 
	AND      M.SystemModule IN (SELECT SystemModule FROM Ref_SystemModule WHERE Operational = 1)
	
	
	ORDER BY U.OrderListing, 
	         M.FunctionClass, 
			 M.MenuOrder 
</cfquery>

<cf_divscroll>

<!--- Search form --->

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">

	<cfif url.scope eq "backend">

		<tr><td style="padding-left:10px;padding-right:10px">
		
			<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="white">
				<tr>
					
					<td height="80" valign="middle" align="left" width="95%" style="top; padding-left:10px">
						<table width="100%" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td style="z-index:1; width:644px; height:78px; position:absolute; right:0px; top:0px; background-image:url(<cfoutput>#SESSION.root#</cfoutput>/images/logos/BGV2.png); background-repeat:no-repeat">							
								</td>
							</tr>
                            <tr style="height:100px">
								<td>
                                   
                                    <img src="<cfoutput>#SESSION.root#</cfoutput>/images/Home-Circle.png" width="72" height="72" style="float: left;position: relative;top:5px;left:2px;">
                                    <h1 style="position: relative;font-size: 30px;font-weight: 200;top: 13px;left: 0;color: #033F5D;margin:0;"><cf_tl id="Home"><br>
                                        <span style="font-size: 16px;position: relative; top: -5px;left: 1px;"><cf_tl id="Main Menu"></span></h1>

								</td>
							</tr>
						</table>
					</td>
				</tr>
				</table>
				</td>
				
		</tr>

	</cfif>
			
	<tr><td height="10px"></td></tr>
			
<cfoutput query="searchresult">
   
   <tr class="line" style="height:40px"><td colspan="4" style="padding-top:4px;height:20px;padding-left:20px" class="labellarge">
   
	   		<table width="100%" cellspacing="0" cellpadding="0">
				<tr>
				<td width="20">
				<cfif Status eq "1">
				   <img src="#SESSION.root#/Images/portal_min.png" height="20" id="toggle_#currentrow#" alt="Toggle topic" border="0" align="absmiddle" style="cursor: pointer;" onClick="action('#SystemFunctionId#','#currentrow#')">
				<cfelse>				  
			   	   <img class="hoverEffect" src="#SESSION.root#/Images/portal_max.png" height="20" id="toggle_#currentrow#" alt="Toggle topic" border="0" align="absmiddle" style="cursor: pointer;" onClick="action('#SystemFunctionId#','#currentrow#')">
			    </cfif>			
				</td>
				<td width="97%" onClick="action('#SystemFunctionId#','#currentrow#')" style="cursor:pointer;color:F24F00;font-weight:340;padding-left:10px;font-size:22" class="labelmedium">#FunctionMemo#</td>
				</tr>
				
				
			</table>
	   
	   </td>
   
       <td colspan="2" align="right" style="padding-left:20px;padding-right:20px">
	   
		   <table align="right" width="40" cellspacing="0" cellpadding="0">
		   
			   <tr>
		       <td align="right" style="border:0px solid silver;padding-left:5px;padding-right:5px">
			  
				   <cfif fileExists("#SESSION.rootpath#/Portal/Topics/#FunctionPath#/TopicEdit.cfm")>
				       <cf_img icon="edit_large" onclick="loadedit('#FunctionPath#/TopicEdit.cfm','#currentrow#','#SystemFunctionId#')">
				   </cfif>
			  
			   </td>
			   <td colspan="1" align="left" style="border:0px solid silver;padding-right:5px;padding-left:6px;">
			      <cf_img icon="delete_large" onClick="refreshme('#SystemFunctionId#','del','#currentrow#')">					
			   </td>
			   </tr>
			   
		   </table>
	   </td>
   </tr>
      			    
   <tr id="box_#currentrow#" class="<cfif Status is "1">regular<cfelse>hide</cfif>">
      <td colspan="6">
		    
		 <table width="100%" cellspacing="0" cellpadding="0" align="center">
		    <tr>					
		     <cfif Status is "1">
			 	<td style="padding-left:47px;padding-top:4px" align="center" id="content_#currentrow#">
				 <cfset scope = "topic">
				 <cfinclude template="#FunctionPath#/Topic.cfm">
				 </td>
			 <cfelse>
			    <td style="padding-left:47px;padding-top:4px" align="center" id="content_#currentrow#"></td>	 				 
			 </cfif>
			 </tr>
		 </table>
		 
	  </td>
   </tr>		 
         
</cfoutput>

</TABLE>

</cf_divscroll>

