 
<cfparam name="URL.ID"   	   default="">
<cfparam name="URL.Mode"	   default="dialog">
<cfparam name="URL.ReadOnly"   default="No">
<cfparam name="URL.SourcePath" default="">

<cfif url.id neq "">
	
	<cfquery name="Clear" 
	   datasource="AppsSystem" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    DELETE FROM   BroadCast
	    WHERE  (BroadcastId NOT IN
	                       (SELECT  BroadcastId
	                        FROM    BroadcastRecipient))
		AND    BroadcastId <> '#URL.ID#'
		AND    OfficerUserId = '#SESSION.acc#'						
	</cfquery>	

</cfif>
   
<cf_ajaxRequest>
<cf_textareascript>
<cfajaximport tags="cfform,cfdiv,cfwindow">
<cf_FileLibraryScript>
<cf_calendarscript>

<cfif url.id neq "">
	
	<cfquery name="Broadcast" 
	   datasource="AppsSystem" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		  SELECT *
		  FROM  Broadcast
		  WHERE BroadcastId = '#URL.ID#'
	</cfquery>

<cfelse>
	
	<cfquery name="Broadcast" 
	   datasource="AppsSystem" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		  SELECT  TOP 1 *
		  FROM    Broadcast
		  WHERE   OfficeruserId = '#SESSION.acc#'
		  ORDER BY Created DESC
	</cfquery>
	
	<cfset url.id = Broadcast.BroadcastId>	

</cfif>

<cfif url.id eq "">  
   <table align="center"><tr><td class="labelmedium" height="200" style="font-size:20px;font-weight:200">Sorry, No broadcasts requests found for your account.</td></tr></table>
   <cfabort>
 
</cfif>

<cfoutput>

<script language="JavaScript">

function broadcastreload(id) {
    window.location = "BroadCastView.cfm?mode=#url.mode#&id="+id
}

function preview(id,rid) {
    ColdFusion.Window.create('preview', 'Mail Preview', 'BroadCastPreview.cfm?id='+id+'&recipientid='+rid,{x:100,y:100,height:620,width:620,modal:false,center:true})				
	ColdFusion.navigate('BroadCastPreview.cfm?id='+id+'&recipientid='+rid,'preview')
}

function recipienttoggle(recid,val) {
	
	if (val == true) {
	  url = "BroadCastRecipientSelect.cfm?recid="+recid+"&val=1";
	} else {
	  url = "BroadCastRecipientSelect.cfm?recid="+recid+"&val=0";
	}	
	ColdFusion.navigate(url,'selected')	
}	   	
	   
function saveSettings(){

		document.formoption.onsubmit() 
		if( _CF_error_messages.length == 0 ) {
			ColdFusion.navigate('BroadcastSubmit.cfm?mode=#url.mode#&broadcastid=#url.id#&scope=option','contentbox2','','','POST','formoption')
		 }
	
}
	   
</script>	

</cfoutput>	

<cfif url.mode eq "menu">

<cf_screentop label="#SESSION.welcome# Mail Broadcast" 
	   height="99%"     
	   bannerheight="0"
	   html="no"
	   layout="webapp" 
	   validateSession="Yes"
	   scroll="Vertical"
	   jQuery="Yes">

<cfelse>

	<cfif url.mode eq "iframe">
		
		<cf_screentop label="#SESSION.welcome# Mail Broadcast" 
	   		height="99%"     	  
	   		html="yes"
	   		banner="gray"
	   		line="no"   
	   		close = "parent.ColdFusion.Window.hide('BroadcastWindow')"
	   		layout="webapp" 
	   		validateSession="Yes"
		   	scroll="Vertical"
		   	jQuery="Yes">
		
	<cfelse>
	
		<cf_screentop label="#SESSION.welcome# Mail Broadcast" 
	   		height="99%"     	  
	   		html="yes"
	   		banner="gray"
	   		line="no"   
	   		layout="webapp" 
	   		validateSession="Yes"
		   	scroll="Vertical"
		   	jQuery="Yes">
	   
	</cfif>
   
</cfif>   

<table border="0" width="100%" height="100%">

<tr><td valign="top" height="100%">

<cfparam name="url.id" default="53B71930-5BFF-4BC2-838D-E89B3F9735AF">

	<table width="97%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
	<!---
		
	<cfif url.mode eq "menu">		
	<tr>
	<td height="20">
	
		<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="white">
			<tr>
				<td width="5%"></td>

				<td height="80" valign="middle" align="left" width="98%" style="top; padding-left:10px">
					<table width="100%" cellpadding="0" cellspacing="0" border="0" >
						<tr>
							<td style="z-index:1; width:646px; height:78px; position:absolute; right:0px; top:0px; background-image:url(<cfoutput>#SESSION.root#</cfoutput>/images/logos/BGV2.png); background-repeat:no-repeat">							
							</td>
						</tr>
						<tr>
							<td style="z-index:5; position:absolute; top:23px; left:35px; ">
								<img src="<cfoutput>#SESSION.root#</cfoutput>/images/logos/broadcast/broadcast.png">
							</td>
						</tr>
						<tr>
							<td style="z-index:3; position:absolute; top:25px; left:90px; color:45617d; font-family:calibri; font-size:25px; font-weight:bold;">
								<cf_tl id="My Broadcasts">
							</td>
						</tr>
						<tr>
							<td style="position:absolute; top:5px; left:90px; color:e9f4ff; font-family:calibri; font-size:55px; font-weight:bold; z-index:2">
								<cf_tl id="Broadcast">
							</td>
						</tr>
						
						<tr>
							<td style="position:absolute; top:50px; left:90px; color:45617d; font-family:calibri; font-size:12px; font-weight:bold; z-index:4">
								<cf_tl id="Broadcast E-mail">
							</td>
						</tr>
						
						<tr>
							<td height="10"></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</td>
	</tr>	
	
	</cfif>
	
	--->
		
	<cfif broadcast.broadcaststatus eq "1">	 
	
	<tr>
	    
		<td class="labelmedium" style="height:30;font-size:17px;padding-left:30px;font-weight:200">		
			<cfoutput>Selected Broadcast was delivered to server on:&nbsp;</font><b>#dateformat(broadcast.broadcastSent,CLIENT.DateFormatShow)#</b> at: <b>#timeformat(broadcast.broadcastSent,"HH:MM:SS")#</cfoutput>&nbsp;&nbsp;										
		</td>
		<td id="sendbox"></td>
		
	</tr>
	
	</cfif>
			
	<cf_menuscript>
			
	<tr>	
	
	<td align="center" width="100%" height="40" valign="top" colspan="2">
	
		<table width="100%" height="100%" class="formspacing" cellspacing="0" cellpadding="0"><tr>
		
		<cfset ht = "64">
		<cfset wd = "64">
		
		<cfset itm = "1">
		
		  <cfif url.mode neq "modal">
				 			   
			  <cfset itm = itm + 1>  	
			 
			   <cf_menutab item       = "#itm#" 
		           iconsrc    = "Logos/User/Broadcast.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   targetitem = "2"
				   padding    = "5"
				   name       = "Select Broadcast"
				   source     = "BroadCastHistory.cfm?mode=#url.mode#&id=#url.id#">	  
				   
			 </cfif>	   
		
		 <cfset itm = itm + 1>
			  <cf_menutab item       = "1" 
	           iconsrc    = "Logos/User/Mail-Subject-Body.png" 
			   iconwidth  = "#wd#" 
			   targetitem = "1"
			   padding    = "5"
			   source     = "BroadCastBodyView.cfm?mode=#url.mode#&id=#url.id#&readonly=#URL.readonly#&sourcepath=#URL.sourcepath#"
			   iconheight = "#ht#" 
			   name       = "Mail Subject and Body">		
			   
						
			<cfif BroadCast.SystemFunctionId neq "">
			
				  <cfset itm = itm + 1>
			
			      <cf_menutab item       = "#itm#" 
		           iconsrc    = "Logos/User/Interface.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   targetitem = "2"
				   padding    = "5"
				   name       = "Fields"
				   source     = "BroadCastFields.cfm?mode=#url.mode#&id=#url.id#">	
							
			</cfif>
			
			<cfset itm = itm + 1>
			
			  <cf_menutab item       = "#itm#" 
	           iconsrc    = "Logos/User/Broadcast-Recipients.png" 
			   iconwidth  = "#wd#" 
			   iconheight = "#ht#" 
			   targetitem = "2"
			   padding    = "5"
			   name       = "Broadcast Recipients"
			   source     = "BroadCastRecipient.cfm?mode=#url.mode#&id=#url.id#">	
			   
			 <cfset itm = itm + 1>  	
			 
			   <cf_menutab item       = "#itm#" 
	           iconsrc    = "Logos/System/Settings.png" 
			   iconwidth  = "#wd#" 
			   iconheight = "#ht#" 
			   targetitem = "2"
			   padding    = "5"
			   name       = "Delivery Settings"
			   source     = "BroadCastOption.cfm?mode=#url.mode#&id=#url.id#">	
			   			   
			
					
			<cfinvoke component="Service.Access"  
			   method="useradmin" 
			   returnvariable="access">	
	
			<cfif access eq "xEDIT" or access eq "xALL">
			
				 <cfset itm = itm + 1>  	
			
				 <cf_menutab item       = "#itm#" 
		           iconsrc    = "Logos/User/Settings.png" 
				   iconwidth  = "#wd#" 
				   iconheight = "#ht#" 
				   targetitem = "1"
				   padding    = "5"
				   name       = "System Broadcasts"
				   source     = "">	  
					
			</cfif>			
		
		<td width="10%"></td>
		
		</table>
	
	</td></tr>
	
	<tr><td class="linedotted" colspan="2"></td></tr>
		
	<tr>
		<td align="left" height="100%" colspan="2">		
			<table width="100%" height="100%" cellspacing="0" cellpadding="0">	
				<cf_menucontainer item="1" class="regular"/>			
				<cf_menucontainer item="2" class="hide"/>			
			</table>		
		</td>
	</tr?		
						
	</table>
	
</td></tr>
		
</table>	

<!--- initially load --->

<cfoutput>

<cfif url.mode eq "menu">

	<script>
	    document.getElementById('menu1').click()
	</script>
	
<cfelse>

	<script>
	    document.getElementById('menu2').click()
	</script>
		
</cfif>
	
</cfoutput>

<cf_screenBottom layout="webapp">
	