
<cf_divscroll id="processrelease"               
	  modal     = "yes" 
	  close     = "no"
	  width     = "600" 
	  height    = "110" 
	  float     = "yes"
	  overflowy = "hidden" 
	  zindex    = "11" >

	<cf_tableround mode="modal" totalheight="100%">	    
	
		<table width="100%" height="100%" bgcolor="FFFFFF">
		
		<tr>
		<td height="10" style="padding-left:10px">
			<font face="Verdana" size="2">Preparing Release Package</font>
		</td>
		</tr>
		
		<tr id="myprogressbox">
				
			<td height="20" align="center" style="padding:3px">			
						
					<cfif isDefined("Session.status")>
						<cfscript>
							StructDelete(Session,"Status");
						</cfscript>
					</cfif>
										
					<cfprogressbar name="pBar" 
					    style="bgcolor:fafafa;progresscolor:ffffaf" 					
						height="20" 
						bind="cfc:#client.virtualdir#.component.Authorization.AuthorizationBatch.getstatus()"				
						interval="1000" 
						autoDisplay="true" 
						width="506"/> 
															
			  </td>
				  
		</tr>	
		
		<cfoutput>
		<!--- execute the preparation --->
		<tr class="hide"><td>		
		    <!--- starts the scrollbar --->
		    <cfdiv bind="url:ReleasePackageGo.cfm"/>		
			<!--- triggers the package to be prepared --->
		    <cfdiv bind="url:ReleasePackagePrepare.cfm?site=#URL.site#&group=#url.group#"/>				
		</td></tr>
		</cfoutput>				
				
		</table>
	
    </cf_tableround>
	   
</cf_divscroll>

