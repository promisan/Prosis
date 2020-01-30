<cf_screentop html="no" jquery="yes">
	
<cfoutput>
		
	<cfquery name="Sys" 
		  datasource="AppsSystem">
	      SELECT * 
		  FROM   Parameter	  
	</cfquery>
	
	
	<cfquery name="Master" 
		  datasource="AppsControl">
	      SELECT * 
		  FROM   ParameterSite
		  WHERE  ServerRole = 'QA'
		  ORDER BY ServerRole
	</cfquery>

	
	<cfif Master.recordcount eq 1>

		<div id="divCodeScannerWaitText" style="display:none; text-align:center; margin:20%; margin-top:5%; padding:5%; font-size:28px; color:FAFAFA; background-color:rgba(0,0,0,0.7); border-radius:8px;">
			<cf_tl id="Please wait, while the scan is in progress">
			<br><br>
			<cfprogressbar name="pBar" 
			    style="bgcolor:000000; progresscolor:DB996E; textcolor:FAFAFA;"
				height="20" 
				bind="cfc:service.Authorization.AuthorizationBatch.getstatus()"				
				interval="1000" 
				autoDisplay="false" 
				width="700"/>
		</div>
	
		<script>
			function doScan(){
				_cf_loadingtexthtml="";	
				Prosis.busy('yes', 'divCodeScannerWaitText');
		
				window['__cbCodeScanner'] = function(){ Prosis.busy('no', 'divCodeScannerWaitText'); };

				document.getElementById('scanbutton').className="hide";
				ptoken.navigate('#Session.root#/Tools/Template/TemplateCheckContent.cfm','templatescan','__cbCodeScanner');
				ColdFusion.ProgressBar.start('pBar') ;
			}
		</script>
			
		<table width="100%">
		
	        <tr><td style="height:10px"></td></tr>
			
			<tr class="line">
				<td align="left" style="padding-left:25px;">
					<table>
						<tr  class="labelmedium">
							<td width="150">Application Server:</td>
							<td>#Master.ApplicationServer#</td>
						</tr>
						<tr  class="labelmedium">
							<td>Domain:</td>
							<td>#Master.ServerDomain#</td>
						</tr>
						<tr  class="labelmedium">
							<td>Host Name:</td>
							<td>#Master.HostName#</td>
						</tr>
					</table>
				</td>
			</tr>
			
			<tr>
				<td align="center" style="height:40px">
					<button name="scanbutton" id="scanbutton" class="button10g" style="width:200px;height:30px" onclick="javascript:doScan();">
						<img align="absmiddle" height="12" src="#SESSION.root#/Images/dataset_read.gif" border="0">&nbsp;Scan Master Code
					</button>
				</td>
			</tr>
			
			<tr><td id="templatescan" align="center"></td></tr>
			
		</table>
	
	</cfif>
	
</cfoutput>